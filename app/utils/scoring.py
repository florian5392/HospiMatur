"""
Calcul des scores de maturité HospiConnect.

Règles :
- Score = moyenne des paliers renseignés, exprimé sur 4.
- Une absence de réponse (pas de ligne) = indicateur exclu du calcul.
- Indicateurs porteur=GROUPE : valeur depuis reponses_groupe ; exclus si non encore renseignés.
- Indicateurs has_typologies=TRUE : contribuent avec la moyenne de leurs typologies
  (seulement si toutes les typologies sont renseignées).
- NULL (absence de ligne) ≠ palier 0.
"""
# pylint: disable=duplicate-code,too-many-locals

from __future__ import annotations

import functools

import pandas as pd

from app.db.connection import get_cursor


# ────────────────────────────────────────────────────────────────────────────
# Requête SQL commune
# ────────────────────────────────────────────────────────────────────────────

def _get_indicators_sql() -> str:
    """Retourne la requête SQL pour charger les indicateurs avec leur hiérarchie."""
    return """
        SELECT
            d.id   AS domaine_id,   d.code AS domaine_code,   d.libelle AS domaine_libelle,   d.ordre AS domaine_ordre,
            r.id   AS rubrique_id,  r.code AS rubrique_code,  r.libelle AS rubrique_libelle,  r.ordre AS rubrique_ordre,
            pc.id  AS pc_id,        pc.numero AS pc_numero,   pc.libelle AS pc_libelle,        pc.ordre AS pc_ordre,
            i.id   AS ind_id,       i.code,                   i.lettre,                        i.titre,
            i.type, i.porteur, i.inverse, i.has_typologies
        FROM indicateurs i
        JOIN points_cles pc ON i.id_point_cle = pc.id
        JOIN rubriques    r  ON pc.id_rubrique  = r.id
        JOIN domaines     d  ON r.id_domaine    = d.id
        ORDER BY d.ordre, r.ordre, pc.ordre, i.lettre
    """


# ────────────────────────────────────────────────────────────────────────────
# Chargement brut des données
# ────────────────────────────────────────────────────────────────────────────

def _load_indicators() -> pd.DataFrame:
    """Charge tous les indicateurs avec leur hiérarchie (domaine, rubrique, point clé)."""
    with get_cursor() as cur:
        cur.execute(_get_indicators_sql())
        return pd.DataFrame(cur.fetchall())


def _load_reponses(session_id: int) -> dict[int, int]:
    """Retourne {id_indicateur: valeur} pour les réponses standards d'une session."""
    with get_cursor() as cur:
        cur.execute(
            "SELECT id_indicateur, valeur FROM reponses WHERE id_session = %s",
            (session_id,)
        )
        return {r["id_indicateur"]: r["valeur"] for r in cur.fetchall()}


def _load_reponses_typo(session_id: int) -> dict[int, list[int]]:
    """Retourne {id_indicateur: [valeurs typologies]} pour les réponses par typologie."""
    with get_cursor() as cur:
        cur.execute("""
            SELECT rt.id_indicateur, rt.valeur
            FROM reponses_typologies rt
            WHERE rt.id_session = %s
        """, (session_id,))
        result: dict[int, list[int]] = {}
        for r in cur.fetchall():
            result.setdefault(r["id_indicateur"], []).append(r["valeur"])
        return result


def _load_reponses_groupe(campagne_id: int) -> dict[int, int]:
    """Retourne {id_indicateur: valeur} pour les indicateurs GROUPE d'une campagne."""
    with get_cursor() as cur:
        cur.execute(
            "SELECT id_indicateur, valeur FROM reponses_groupe WHERE id_campagne = %s",
            (campagne_id,)
        )
        return {r["id_indicateur"]: r["valeur"] for r in cur.fetchall()}


def _count_typologies() -> dict[int, int]:
    """Retourne {id_indicateur: nb_typologies} pour les indicateurs has_typologies."""
    with get_cursor() as cur:
        cur.execute("""
            SELECT id_indicateur, COUNT(*) AS nb
            FROM indicateur_typologies
            GROUP BY id_indicateur
        """)
        return {r["id_indicateur"]: r["nb"] for r in cur.fetchall()}


# ─────────────────────────────────────────────────────────────────────────────
# Calcul de la valeur effective d'un indicateur (réutilisable)
# ─────────────────────────────────────────────────────────────────────────────

def _compute_valeur_effective(
    row,
    reponses: dict,
    reponses_typo: dict,
    reponses_groupe: dict,
    nb_typologies: dict,
) -> float | None:
    """
    Retourne la valeur effective (0–4) d'un indicateur pour une session donnée,
    ou None si l'indicateur n'est pas renseigné.
    """
    ind_id = row["ind_id"]
    if row["porteur"] == "GROUPE":
        val = reponses_groupe.get(ind_id)
        return float(val) if val is not None else None
    if row["has_typologies"]:
        typo_vals = reponses_typo.get(ind_id, [])
        nb = nb_typologies.get(ind_id, 0)
        if nb > 0 and len(typo_vals) == nb:
            return float(sum(typo_vals) / nb)
        return None
    val = reponses.get(ind_id)
    return float(val) if val is not None else None


# ─────────────────────────────────────────────────────────────────────────────
# Construction du DataFrame de scores enrichi
# ────────────────────────────────────────────────────────────────────────────

def build_score_df(session_id: int, campagne_id: int) -> pd.DataFrame:
    """
    Construit un DataFrame avec une ligne par indicateur et la colonne `valeur_effective`.

    valeur_effective :
    - NaN  → indicateur non renseigné (exclu du calcul)
    - 0–4  → valeur contributive au score

    Le DataFrame contient également les colonnes de hiérarchie pour les agrégations.
    """
    df = _load_indicators()
    if df.empty:
        return df

    eff_fn = functools.partial(
        _compute_valeur_effective,
        reponses=_load_reponses(session_id),
        reponses_typo=_load_reponses_typo(session_id),
        reponses_groupe=_load_reponses_groupe(campagne_id),
        nb_typologies=_count_typologies(),
    )
    df["valeur_effective"] = df.apply(eff_fn, axis=1)
    return df


# ────────────────────────────────────────────────────────────────────────────
# Fonctions de score publiques
# ────────────────────────────────────────────────────────────────────────────

def score_global(session_id: int, campagne_id: int) -> float | None:
    """Score global toutes rubriques confondues (sur 4). None si aucune réponse."""
    df = build_score_df(session_id, campagne_id)
    answered = df["valeur_effective"].dropna()
    return round(float(answered.mean()), 2) if not answered.empty else None


def scores_par_domaine(session_id: int, campagne_id: int) -> list[dict]:
    """
    Retourne une liste de dicts par domaine :
    {domaine_id, domaine_code, domaine_libelle, score, answered, total}
    Triée par domaine_ordre.
    """
    df = build_score_df(session_id, campagne_id)
    if df.empty:
        return []

    result = []
    for (did, dcode, dlibelle), grp in df.groupby(
        ["domaine_id", "domaine_code", "domaine_libelle"]
    ):
        answered = grp["valeur_effective"].dropna()
        result.append({
            "domaine_id":      int(did),
            "domaine_code":    dcode,
            "domaine_libelle": dlibelle,
            "score":           round(float(answered.mean()), 2) if not answered.empty else None,
            "answered":        int(answered.count()),
            "total":           int(len(grp)),
        })

    # trier par domaine_ordre
    ordre = (
        df[["domaine_id", "domaine_ordre"]]
        .drop_duplicates()
        .set_index("domaine_id")["domaine_ordre"]
        .to_dict()
    )
    result.sort(key=lambda x: ordre.get(x["domaine_id"], 0))
    return result


def scores_par_rubrique(session_id: int, campagne_id: int) -> list[dict]:
    """Score par rubrique."""
    df = build_score_df(session_id, campagne_id)
    if df.empty:
        return []

    result = []
    for (rid, rcode, rlibelle, did), grp in df.groupby(
        ["rubrique_id", "rubrique_code", "rubrique_libelle", "domaine_id"]
    ):
        answered = grp["valeur_effective"].dropna()
        result.append({
            "rubrique_id":      int(rid),
            "rubrique_code":    rcode,
            "rubrique_libelle": rlibelle,
            "domaine_id":       int(did),
            "score":            round(float(answered.mean()), 2) if not answered.empty else None,
            "answered":         int(answered.count()),
            "total":            int(len(grp)),
        })

    ordre = (
        df[["rubrique_id", "domaine_ordre", "rubrique_ordre"]]
        .drop_duplicates()
        .set_index("rubrique_id")
        .to_dict("index")
    )
    result.sort(key=lambda x: (
        ordre.get(x["rubrique_id"], {}).get("domaine_ordre", 0),
        ordre.get(x["rubrique_id"], {}).get("rubrique_ordre", 0),
    ))
    return result


def scores_par_domaine_batch(
    session_ids: list[int],
    campagne_id: int,
) -> dict[int, list[dict]]:
    """
    Calcule les scores par domaine pour une liste de sessions en un minimum de requêtes.

    Au lieu de N × 5 requêtes SQL (pattern N+1), effectue :
    - 1 requête pour les indicateurs (référentiel commun)
    - 1 requête pour les typologies (référentiel commun)
    - 1 requête pour les réponses groupe (commune à la campagne)
    - 1 requête pour toutes les réponses standard (WHERE id_session IN (...))
    - 1 requête pour toutes les réponses par typologie (idem)

    Retourne {session_id: [liste de dicts domaine]} avec le même format que scores_par_domaine().
    """
    if not session_ids:
        return {}

    df_ind = _load_indicators()
    if df_ind.empty:
        return {sid: [] for sid in session_ids}

    reponses_groupe = _load_reponses_groupe(campagne_id)
    nb_typologies   = _count_typologies()

    placeholders = ",".join(["%s"] * len(session_ids))

    # Toutes les réponses standard pour ces sessions
    with get_cursor() as cur:
        cur.execute(
            f"SELECT id_session, id_indicateur, valeur "
            f"FROM reponses WHERE id_session IN ({placeholders})",
            session_ids,
        )
        all_reponses: dict[int, dict[int, int]] = {}
        for r in cur.fetchall():
            all_reponses.setdefault(r["id_session"], {})[r["id_indicateur"]] = r["valeur"]

    # Toutes les réponses par typologie pour ces sessions
    with get_cursor() as cur:
        cur.execute(
            f"SELECT id_session, id_indicateur, valeur "
            f"FROM reponses_typologies WHERE id_session IN ({placeholders})",
            session_ids,
        )
        all_typo: dict[int, dict[int, list[int]]] = {}
        for r in cur.fetchall():
            (all_typo
             .setdefault(r["id_session"], {})
             .setdefault(r["id_indicateur"], [])
             .append(r["valeur"]))

    ordre_ref = (
        df_ind[["domaine_id", "domaine_ordre"]]
        .drop_duplicates()
        .set_index("domaine_id")["domaine_ordre"]
        .to_dict()
    )

    result: dict[int, list[dict]] = {}
    for sid in session_ids:
        df = df_ind.copy()
        eff_fn = functools.partial(
            _compute_valeur_effective,
            reponses=all_reponses.get(sid, {}),
            reponses_typo=all_typo.get(sid, {}),
            reponses_groupe=reponses_groupe,
            nb_typologies=nb_typologies,
        )
        df["valeur_effective"] = df.apply(eff_fn, axis=1)

        dom_scores = []
        for (did, dcode, dlibelle), grp in df.groupby(
            ["domaine_id", "domaine_code", "domaine_libelle"]
        ):
            answered = grp["valeur_effective"].dropna()
            dom_scores.append({
                "domaine_id":      int(did),
                "domaine_code":    dcode,
                "domaine_libelle": dlibelle,
                "score":           round(float(answered.mean()), 2) if not answered.empty else None,
                "answered":        int(answered.count()),
                "total":           int(len(grp)),
            })

        dom_scores.sort(key=lambda x, _o=ordre_ref: _o.get(x["domaine_id"], 0))
        result[sid] = dom_scores

    return result


def progress_session(session_id: int, campagne_id: int) -> dict:
    """
    Retourne le taux d'avancement de la session :
    {answered, total, answered_by_domain: {domaine_id: {answered, total}}}

    Seuls les indicateurs ETABLISSEMENT comptent pour la responsabilité du référent.
    """
    df = build_score_df(session_id, campagne_id)
    if df.empty:
        return {"answered": 0, "total": 0, "answered_by_domain": {}}

    # Indicateurs à la charge du référent (ETABLISSEMENT)
    etab_df = df[df["porteur"] == "ETABLISSEMENT"]

    answered_total = int(etab_df["valeur_effective"].notna().sum())
    total          = int(len(etab_df))

    by_domain: dict[int, dict] = {}
    for (did,), grp in etab_df.groupby(["domaine_id"]):
        by_domain[int(did)] = {
            "answered": int(grp["valeur_effective"].notna().sum()),
            "total":    int(len(grp)),
        }

    return {
        "answered":         answered_total,
        "total":            total,
        "answered_by_domain": by_domain,
    }
