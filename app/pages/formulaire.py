"""
Formulaire de collecte des indicateurs — Espace Référent

Workflow :
  T09 — Identification (campagne, établissement, nom)
  T10 — Navigation par domaine avec progression
  T11 — Affichage et saisie des indicateurs
  T12 — Sauvegarde automatique à chaque saisie
  T13 — Soumission finale
"""

from __future__ import annotations
import streamlit as st

from app.db.connection import get_cursor
from app.components.progress_bar import render_progress_bar, domain_badge, domain_status
from app.components.indicateur_widget import render_indicateur
from app.config import TYPE_COLORS
from mysql.connector import Error


# ─────────────────────────────────────────────────────────────────────────────
# Chargement des données référentiel
# ─────────────────────────────────────────────────────────────────────────────

@st.cache_data(ttl=300, show_spinner=False)
def _load_referentiel() -> dict:
    """
    Charge l'ensemble du référentiel (indicateurs, paliers, typologies) en mémoire.
    Cache pendant 5 minutes (le référentiel est statique).
    """
    with get_cursor() as cur:
        cur.execute("""
            SELECT
                d.id AS domaine_id, d.code AS domaine_code, d.libelle AS domaine_libelle, d.ordre AS domaine_ordre,
                r.id AS rubrique_id, r.code AS rubrique_code, r.libelle AS rubrique_libelle, r.ordre AS rubrique_ordre,
                pc.id AS pc_id, pc.numero AS pc_numero, pc.libelle AS pc_libelle, pc.ordre AS pc_ordre,
                i.id, i.code, i.lettre, i.titre, i.definition, i.perimetre, i.objectif,
                i.type, i.porteur, i.inverse, i.has_typologies, i.mode_saisie
            FROM indicateurs i
            JOIN points_cles pc ON i.id_point_cle = pc.id
            JOIN rubriques    r  ON pc.id_rubrique  = r.id
            JOIN domaines     d  ON r.id_domaine    = d.id
            ORDER BY d.ordre, r.ordre, pc.ordre, i.lettre
        """)
        indicators = cur.fetchall()

        cur.execute("SELECT id_indicateur, valeur, description FROM paliers ORDER BY id_indicateur, valeur")
        paliers: dict[int, dict[int, str]] = {}
        for p in cur.fetchall():
            paliers.setdefault(p["id_indicateur"], {})[p["valeur"]] = p["description"]

        cur.execute("""
            SELECT id, id_indicateur, code_typo, libelle_typo, ordre
            FROM indicateur_typologies ORDER BY id_indicateur, ordre
        """)
        typologies: dict[int, list[dict]] = {}
        for t in cur.fetchall():
            typologies.setdefault(t["id_indicateur"], []).append(t)

    return {"indicators": indicators, "paliers": paliers, "typologies": typologies}


def _load_session_reponses(session_id: int, campagne_id: int) -> tuple[dict, dict, dict]:
    """
    Charge les réponses existantes pour une session.
    Retourne (reponses_std, reponses_typo, reponses_groupe).
    """
    with get_cursor() as cur:
        cur.execute(
            "SELECT id_indicateur, valeur, commentaire FROM reponses WHERE id_session = %s",
            (session_id,)
        )
        std = {r["id_indicateur"]: r for r in cur.fetchall()}

        cur.execute("""
            SELECT rt.id_indicateur, rt.id_typo, rt.valeur, rt.commentaire
            FROM reponses_typologies rt WHERE rt.id_session = %s
        """, (session_id,))
        typo: dict[int, dict[int, int]] = {}  # {ind_id: {id_typo: valeur}}
        for r in cur.fetchall():
            typo.setdefault(r["id_indicateur"], {})[r["id_typo"]] = r["valeur"]

        cur.execute(
            "SELECT id_indicateur, valeur FROM reponses_groupe WHERE id_campagne = %s",
            (campagne_id,)
        )
        groupe = {r["id_indicateur"]: r["valeur"] for r in cur.fetchall()}

    return std, typo, groupe


# ─────────────────────────────────────────────────────────────────────────────
# T09 — Identification et gestion de session
# ─────────────────────────────────────────────────────────────────────────────

def _show_identification() -> None:
    st.subheader("Identification du référent")

    # Campagnes ouvertes
    try:
        with get_cursor() as cur:
            cur.execute(
                "SELECT id, libelle FROM campagnes WHERE statut = 'OUVERTE' ORDER BY libelle"
            )
            campagnes = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur de connexion : {exc}")
        return

    if not campagnes:
        st.warning(
            "Aucune campagne ouverte en ce moment. "
            "Contactez votre administrateur pour ouvrir une campagne."
        )
        return

    # Établissements actifs
    try:
        with get_cursor() as cur:
            cur.execute(
                "SELECT id, nom, code FROM etablissements WHERE actif = 1 ORDER BY nom"
            )
            etabs = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    if not etabs:
        st.warning("Aucun établissement actif. Contactez l'administrateur.")
        return

    with st.form("identification"):
        camp_opts  = {c["libelle"]: c for c in campagnes}
        etab_opts  = {f"{e['nom']} ({e['code']})": e for e in etabs}

        sel_camp  = st.selectbox("Campagne *", list(camp_opts.keys()))
        sel_etab  = st.selectbox("Établissement *", list(etab_opts.keys()))
        nom_ref   = st.text_input("Votre nom *")
        submitted = st.form_submit_button("Démarrer ou reprendre ma session")

    if submitted:
        nom_ref = nom_ref.strip()
        if not nom_ref:
            st.error("Votre nom est obligatoire.")
            return

        campagne    = camp_opts[sel_camp]
        etablissement = etab_opts[sel_etab]

        try:
            with get_cursor() as cur:
                cur.execute("""
                    SELECT id, statut FROM sessions
                    WHERE id_etablissement = %s AND id_campagne = %s AND nom_referent = %s
                """, (etablissement["id"], campagne["id"], nom_ref))
                existing = cur.fetchone()

            if existing:
                if existing["statut"] == "SOUMISE":
                    st.info(
                        f"Votre session pour la campagne **{campagne['libelle']}** "
                        "a déjà été **soumise**. Aucune modification possible."
                    )
                    return
                # Reprise de session EN_COURS
                st.session_state["session_id"]   = existing["id"]
                st.session_state["campagne_id"]  = campagne["id"]
                st.session_state["nom_referent"] = nom_ref
                st.session_state["campagne_lib"] = campagne["libelle"]
                st.session_state["etab_nom"]     = etablissement["nom"]
                st.session_state["session_loaded"] = False  # force reload réponses
                st.success("Session reprise.")
                st.rerun()
            else:
                # Créer une nouvelle session
                with get_cursor() as cur:
                    cur.execute("""
                        INSERT INTO sessions (id_etablissement, id_campagne, nom_referent, statut)
                        VALUES (%s, %s, %s, 'EN_COURS')
                    """, (etablissement["id"], campagne["id"], nom_ref))
                    new_id = cur.lastrowid

                st.session_state["session_id"]    = new_id
                st.session_state["campagne_id"]   = campagne["id"]
                st.session_state["nom_referent"]  = nom_ref
                st.session_state["campagne_lib"]  = campagne["libelle"]
                st.session_state["etab_nom"]      = etablissement["nom"]
                st.session_state["session_loaded"] = False
                st.success("Nouvelle session créée.")
                st.rerun()
        except Exception as exc:
            st.error(f"Erreur : {exc}")


# ─────────────────────────────────────────────────────────────────────────────
# T10-T12 — Formulaire de saisie par domaine
# ─────────────────────────────────────────────────────────────────────────────

def _init_session_state_from_db(session_id: int, campagne_id: int, referentiel: dict) -> None:
    """Initialise les clés session_state depuis les réponses en base (appelé une seule fois)."""
    std, typo, groupe = _load_session_reponses(session_id, campagne_id)

    for ind in referentiel["indicators"]:
        ind_id  = ind["id"]
        porteur = ind["porteur"]
        has_typo = ind["has_typologies"]

        if porteur == "GROUPE":
            continue

        if has_typo:
            for t in referentiel["typologies"].get(ind_id, []):
                key = f"ind_{ind_id}_typo_{t['id']}"
                if key not in st.session_state:
                    typo_map = typo.get(ind_id, {})
                    st.session_state[key] = typo_map.get(t["id"])
                key_cmt = f"cmt_{ind_id}_typo_{t['id']}"
                if key_cmt not in st.session_state:
                    st.session_state[key_cmt] = ""
        else:
            key = f"ind_{ind_id}"
            if key not in st.session_state:
                resp = std.get(ind_id)
                st.session_state[key] = resp["valeur"] if resp else None
            key_cmt = f"cmt_{ind_id}"
            if key_cmt not in st.session_state:
                resp = std.get(ind_id)
                st.session_state[key_cmt] = resp.get("commentaire", "") or "" if resp else ""


def _get_answered_etab(session_id: int, referentiel: dict) -> set[int]:
    """Retourne les id_indicateur ETABLISSEMENT ayant une réponse dans session_state."""
    answered = set()
    for ind in referentiel["indicators"]:
        if ind["porteur"] == "GROUPE":
            continue
        ind_id   = ind["id"]
        has_typo = ind["has_typologies"]
        if has_typo:
            typologies_list = referentiel["typologies"].get(ind_id, [])
            if all(
                st.session_state.get(f"ind_{ind_id}_typo_{t['id']}") is not None
                for t in typologies_list
            ):
                answered.add(ind_id)
        else:
            if st.session_state.get(f"ind_{ind_id}") is not None:
                answered.add(ind_id)
    return answered


def _show_domain_form(session_id: int, campagne_id: int, referentiel: dict) -> None:
    """Affiche la navigation par domaine et les indicateurs."""

    indicators   = referentiel["indicators"]
    paliers      = referentiel["paliers"]
    typologies   = referentiel["typologies"]

    # Charger les valeurs groupe
    _, _, groupe_vals = _load_session_reponses(session_id, campagne_id)

    # Construire la structure hiérarchique domaines → rubriques → points_cles → indicateurs
    domaines: dict[int, dict] = {}
    for ind in indicators:
        did = ind["domaine_id"]
        if did not in domaines:
            domaines[did] = {
                "code":    ind["domaine_code"],
                "libelle": ind["domaine_libelle"],
                "ordre":   ind["domaine_ordre"],
                "rubriques": {},
            }
        rid = ind["rubrique_id"]
        if rid not in domaines[did]["rubriques"]:
            domaines[did]["rubriques"][rid] = {
                "code":      ind["rubrique_code"],
                "libelle":   ind["rubrique_libelle"],
                "ordre":     ind["rubrique_ordre"],
                "points_cles": {},
            }
        pcid = ind["pc_id"]
        if pcid not in domaines[did]["rubriques"][rid]["points_cles"]:
            domaines[did]["rubriques"][rid]["points_cles"][pcid] = {
                "numero":  ind["pc_numero"],
                "libelle": ind["pc_libelle"],
                "indicators": [],
            }
        domaines[did]["rubriques"][rid]["points_cles"][pcid]["indicators"].append(ind)

    dom_sorted = sorted(domaines.items(), key=lambda x: x[1]["ordre"])

    # T10 — Barre de progression globale
    progress = render_progress_bar(session_id, campagne_id)
    by_domain = progress.get("answered_by_domain", {})

    st.divider()

    # Onglets par domaine avec badge
    tab_labels = []
    for did, dom in dom_sorted:
        bp = by_domain.get(did, {"answered": 0, "total": 0})
        status = domain_status(bp["answered"], bp["total"])
        icon = {"non_demarre": "○", "en_cours": "◑", "complet": "●"}.get(status, "○")
        badge = domain_badge(bp["answered"], bp["total"])
        tab_labels.append(f"{icon} {dom['code']} — {badge}")

    tabs = st.tabs(tab_labels)

    for tab_obj, (did, dom) in zip(tabs, dom_sorted):
        with tab_obj:
            _show_domain_content(
                dom, session_id, campagne_id,
                paliers, typologies, groupe_vals
            )


def _show_domain_content(
    dom: dict,
    session_id: int,
    campagne_id: int,
    paliers: dict,
    typologies: dict,
    groupe_vals: dict,
) -> None:
    """Affiche le contenu d'un onglet domaine."""
    st.markdown(f"### {dom['libelle']}")

    rub_sorted = sorted(dom["rubriques"].items(), key=lambda x: x[1]["ordre"])
    for rid, rub in rub_sorted:
        with st.expander(f"📂 {rub['libelle']}", expanded=True):
            pc_sorted = sorted(
                rub["points_cles"].items(),
                key=lambda x: x[1]["numero"]
            )
            for pcid, pc in pc_sorted:
                st.markdown(
                    f"**Point clé {pc['numero']}** — {pc['libelle']}",
                    help=f"Point clé n°{pc['numero']}"
                )
                for ind in pc["indicators"]:
                    ind_id   = ind["id"]
                    porteur  = ind["porteur"]
                    has_typo = ind["has_typologies"]

                    with st.container(border=True):
                        if porteur == "GROUPE":
                            mode = "groupe"
                            render_indicateur(
                                indicateur=ind,
                                paliers=paliers.get(ind_id, {}),
                                reponse_courante=None,
                                commentaire_courant="",
                                typologies=[],
                                reponses_typo_courantes={},
                                mode=mode,
                                session_id=session_id,
                                groupe_valeur=groupe_vals.get(ind_id),
                            )
                        elif has_typo:
                            typo_list = typologies.get(ind_id, [])
                            current_typo = {
                                t["id"]: st.session_state.get(f"ind_{ind_id}_typo_{t['id']}")
                                for t in typo_list
                            }
                            render_indicateur(
                                indicateur=ind,
                                paliers=paliers.get(ind_id, {}),
                                reponse_courante=None,
                                commentaire_courant="",
                                typologies=typo_list,
                                reponses_typo_courantes=current_typo,
                                mode="edition",
                                session_id=session_id,
                                groupe_valeur=None,
                            )
                        else:
                            current_val = st.session_state.get(f"ind_{ind_id}")
                            current_cmt = st.session_state.get(f"cmt_{ind_id}", "")
                            render_indicateur(
                                indicateur=ind,
                                paliers=paliers.get(ind_id, {}),
                                reponse_courante=current_val,
                                commentaire_courant=current_cmt,
                                typologies=[],
                                reponses_typo_courantes={},
                                mode="edition",
                                session_id=session_id,
                                groupe_valeur=None,
                            )
                st.markdown("---")


# ─────────────────────────────────────────────────────────────────────────────
# T13 — Soumission finale
# ─────────────────────────────────────────────────────────────────────────────

def _show_submission(session_id: int, referentiel: dict) -> None:
    """Affiche le bouton de soumission et gère la validation."""
    st.divider()
    st.subheader("Soumission de la session")

    answered = _get_answered_etab(session_id, referentiel)
    etab_indicators = [
        ind for ind in referentiel["indicators"]
        if ind["porteur"] == "ETABLISSEMENT"
    ]

    missing = [ind for ind in etab_indicators if ind["id"] not in answered]

    if missing:
        st.warning(
            f"**{len(missing)} indicateur(s) non renseigné(s)** :\n"
            + "\n".join(
                f"- **{ind['code']}** ({ind.get('domaine_code', '')})"
                for ind in missing[:20]
            )
            + ("\n- *(et d'autres…)*" if len(missing) > 20 else "")
        )
        st.info("Renseignez tous les indicateurs avant de soumettre.")
        return

    st.success("Tous les indicateurs ont été renseignés. Vous pouvez soumettre.")

    confirm_key = f"confirm_submit_{session_id}"
    if not st.session_state.get(confirm_key, False):
        if st.button("Soumettre ma session", type="primary"):
            st.session_state[confirm_key] = True
            st.rerun()
    else:
        st.warning("Êtes-vous sûr(e) de vouloir soumettre ? Cette action est irréversible.")
        col_ok, col_cancel = st.columns(2)
        with col_ok:
            if st.button("✅ Confirmer la soumission", type="primary"):
                try:
                    with get_cursor() as cur:
                        cur.execute(
                            "UPDATE sessions SET statut = 'SOUMISE', date_modif = NOW() "
                            "WHERE id = %s",
                            (session_id,)
                        )
                    st.balloons()
                    st.success(
                        "Session soumise avec succès ! "
                        "Votre référent recevra une confirmation."
                    )
                    # Nettoyer l'état session
                    for key in ["session_id", "campagne_id", "nom_referent",
                                "campagne_lib", "etab_nom", "session_loaded"]:
                        st.session_state.pop(key, None)
                    st.rerun()
                except Exception as exc:
                    st.error(f"Erreur lors de la soumission : {exc}")
        with col_cancel:
            if st.button("Annuler"):
                st.session_state[confirm_key] = False
                st.rerun()


# ─────────────────────────────────────────────────────────────────────────────
# Point d'entrée
# ─────────────────────────────────────────────────────────────────────────────

def show() -> None:
    st.title("Formulaire de collecte — Référent")

    session_id  = st.session_state.get("session_id")
    campagne_id = st.session_state.get("campagne_id")

    if not session_id:
        _show_identification()
        return

    # Afficher l'en-tête de session
    st.info(
        f"**Référent :** {st.session_state.get('nom_referent', '')}  "
        f"| **Établissement :** {st.session_state.get('etab_nom', '')}  "
        f"| **Campagne :** {st.session_state.get('campagne_lib', '')}"
    )

    if st.button("Changer de session"):
        for key in ["session_id", "campagne_id", "nom_referent",
                    "campagne_lib", "etab_nom", "session_loaded"]:
            st.session_state.pop(key, None)
        st.rerun()

    # Charger le référentiel (mis en cache)
    try:
        referentiel = _load_referentiel()
    except Exception as exc:
        st.error(f"Erreur de chargement du référentiel : {exc}")
        return

    # Initialiser session_state depuis la DB (une seule fois par session)
    if not st.session_state.get("session_loaded", False):
        try:
            _init_session_state_from_db(session_id, campagne_id, referentiel)
            st.session_state["session_loaded"] = True
        except Exception as exc:
            st.error(f"Erreur de chargement des réponses : {exc}")
            return

    # Formulaire par domaine
    _show_domain_form(session_id, campagne_id, referentiel)

    # Soumission
    _show_submission(session_id, referentiel)
