"""
Composant réutilisable d'affichage et de saisie d'un indicateur.

Modes :
- edition   : saisie par le référent (ETABLISSEMENT, non GROUPE)
- groupe    : lecture seule, valeur pré-remplie par l'admin
- lecture   : lecture seule générique (dashboard)
"""
# pylint: disable=too-many-arguments,too-many-positional-arguments
# pylint: disable=too-many-locals,too-many-branches,too-many-statements
# pylint: disable=broad-exception-caught

from __future__ import annotations
import streamlit as st
from app.config import TYPE_COLORS
from app.db.connection import get_cursor


# ─────────────────────────────────────────────────────────────────────────────
# Paliers : description du niveau sélectionné
# ─────────────────────────────────────────────────────────────────────────────

def _palier_desc(paliers: dict[int, str], niveau: int | None) -> str:
    if niveau is None:
        return ""
    return paliers.get(niveau, "")


# ─────────────────────────────────────────────────────────────────────────────
# Sauvegarde en base
# ─────────────────────────────────────────────────────────────────────────────

def _save_reponse(session_id: int, ind_id: int, valeur: int | None, commentaire: str) -> None:
    """INSERT ou DELETE une réponse standard."""
    with get_cursor() as cur:
        if valeur is None:
            cur.execute(
                "DELETE FROM reponses WHERE id_session = %s AND id_indicateur = %s",
                (session_id, ind_id)
            )
        else:
            cur.execute("""
                INSERT INTO reponses (id_session, id_indicateur, valeur, commentaire, date_saisie)
                VALUES (%s, %s, %s, %s, NOW())
                ON DUPLICATE KEY UPDATE valeur = VALUES(valeur),
                                        commentaire = VALUES(commentaire),
                                        date_saisie = NOW()
            """, (session_id, ind_id, int(valeur), commentaire))
        # Mettre à jour la date de modification de la session
        cur.execute(
            "UPDATE sessions SET date_modif = NOW() WHERE id = %s",
            (session_id,)
        )


def _save_reponse_typo(
    session_id: int, ind_id: int, id_typo: int,
    valeur: int | None, commentaire: str
) -> None:
    """INSERT ou DELETE une réponse par typologie."""
    with get_cursor() as cur:
        if valeur is None:
            cur.execute(
                "DELETE FROM reponses_typologies "
                "WHERE id_session = %s AND id_indicateur = %s AND id_typo = %s",
                (session_id, ind_id, id_typo)
            )
        else:
            cur.execute("""
                INSERT INTO reponses_typologies
                    (id_session, id_indicateur, id_typo, valeur, commentaire, date_saisie)
                VALUES (%s, %s, %s, %s, %s, NOW())
                ON DUPLICATE KEY UPDATE valeur = VALUES(valeur),
                                        commentaire = VALUES(commentaire),
                                        date_saisie = NOW()
            """, (session_id, ind_id, id_typo, int(valeur), commentaire))
        cur.execute(
            "UPDATE sessions SET date_modif = NOW() WHERE id = %s",
            (session_id,)
        )


# ─────────────────────────────────────────────────────────────────────────────
# Widget principal
# ─────────────────────────────────────────────────────────────────────────────

OPTIONS = [None, 0, 1, 2, 3, 4]


def _format_option(x):
    return "— Non renseigné" if x is None else str(x)


def render_indicateur(
    indicateur: dict,
    paliers: dict[int, str],
    reponse_courante: int | None,
    commentaire_courant: str,
    typologies: list[dict],
    reponses_typo_courantes: dict[int, int],
    mode: str,           # "edition" | "groupe" | "lecture"
    session_id: int | None = None,
    groupe_valeur: int | None = None,
) -> tuple[int | None, str]:
    """
    Affiche le widget d'un indicateur et gère la sauvegarde automatique.

    Returns:
        (valeur, commentaire) - valeurs actuelles après interaction
    """
    ind_id  = indicateur["id"]
    code    = indicateur["code"]
    titre   = indicateur["titre"]
    typ     = indicateur["type"]
    inverse = indicateur.get("inverse", False)
    porteur = indicateur.get("porteur", "ETABLISSEMENT")
    has_typo = indicateur.get("has_typologies", False)
    definition = indicateur.get("definition", "")
    perimetre  = indicateur.get("perimetre", "")
    objectif   = indicateur.get("objectif", "")

    color = TYPE_COLORS.get(typ, "#888")

    # ── En-tête de l'indicateur ────────────────────────────────
    col1, col2 = st.columns([8, 2])
    with col1:
        st.markdown(f"**{code}** — {titre}")
    with col2:
        _s = "padding:2px 6px;border-radius:4px;font-size:0.75em;color:white"
        badges = (
            f'<span style="background:{color};{_s}">{typ}</span>'
        )
        if porteur == "GROUPE":
            badges += (
                f' <span style="background:#e67e22;{_s}">GROUPE</span>'
            )
        if inverse:
            badges += (
                f' <span style="background:#c0392b;{_s}"'
                ' title="Palier élevé = situation plus risquée">'
                "INVERSÉ ⚠</span>"
            )
        st.markdown(badges, unsafe_allow_html=True)

    # ── Définition / périmètre (expander) ─────────────────────
    if definition or perimetre or objectif:
        with st.expander("Voir la définition complète", expanded=False):
            if definition:
                st.markdown(f"**Définition :** {definition}")
            if perimetre:
                st.markdown(f"**Périmètre :** {perimetre}")
            if objectif:
                st.markdown(f"**Objectif :** {objectif}")

    # Avertissement indicateur inversé
    if inverse and mode == "edition":
        st.caption(
            "⚠️ Indicateur inversé : "
            "un palier élevé correspond à une situation plus risquée."
        )

    # ── Affichage selon le mode ───────────────────────────────
    valeur_retour     = reponse_courante
    commentaire_retour = commentaire_courant

    if mode == "groupe":
        # Lecture seule — valeur de reponses_groupe
        if groupe_valeur is not None:
            desc = _palier_desc(paliers, groupe_valeur)
            st.info(f"**Palier {groupe_valeur}** (valeur groupe) — {desc}")
        else:
            st.warning("Valeur groupe non encore renseignée par l'administrateur.")
        return valeur_retour, commentaire_retour

    if mode == "lecture":
        # Lecture seule — valeur quelconque
        if reponse_courante is not None:
            desc = _palier_desc(paliers, reponse_courante)
            st.markdown(f"**Palier {reponse_courante}** — {desc}")
        else:
            st.markdown("*Non renseigné*")
        return valeur_retour, commentaire_retour

    # ── Mode édition ───────────────────────────────────────────
    if has_typo:
        # Indicateur par typologie (COUV-22D, COUV-22F)
        for typo in typologies:
            typo_id      = typo["id"]
            typo_libelle = typo["libelle_typo"]
            key_typo   = f"ind_{ind_id}_typo_{typo_id}"
            key_cmt    = f"cmt_{ind_id}_typo_{typo_id}"

            current_typo_val = reponses_typo_courantes.get(typo_id)

            # Initialiser session_state si besoin
            if key_typo not in st.session_state:
                st.session_state[key_typo] = current_typo_val
            if key_cmt not in st.session_state:
                st.session_state[key_cmt] = ""

            col_label, col_slider = st.columns([3, 7])
            with col_label:
                st.markdown(f"*{typo_libelle}*")
            with col_slider:
                def _on_change_typo(
                    _session_id=session_id,
                    _ind_id=ind_id,
                    _typo_id=typo_id,
                    _key=key_typo,
                    _key_cmt=key_cmt,
                ):
                    v = st.session_state[_key]
                    c = st.session_state.get(_key_cmt, "")
                    try:
                        _save_reponse_typo(_session_id, _ind_id, _typo_id, v, c)
                        st.toast("Réponse enregistrée", icon="✅")
                    except Exception as exc:
                        st.error(f"Erreur lors de la sauvegarde : {exc}")

                val = st.select_slider(
                    label=typo_libelle,
                    options=OPTIONS,
                    format_func=_format_option,
                    key=key_typo,
                    label_visibility="collapsed",
                    on_change=_on_change_typo,
                )
                if val is not None:
                    desc = _palier_desc(paliers, val)
                    if desc:
                        st.caption(desc)
        return valeur_retour, commentaire_retour

    # Indicateur standard ETABLISSEMENT
    key_val = f"ind_{ind_id}"
    key_cmt = f"cmt_{ind_id}"

    if key_val not in st.session_state:
        st.session_state[key_val] = reponse_courante
    if key_cmt not in st.session_state:
        st.session_state[key_cmt] = commentaire_courant or ""

    def _on_change(
        _session_id=session_id,
        _ind_id=ind_id,
        _key=key_val,
        _key_cmt=key_cmt,
    ):
        v = st.session_state[_key]
        c = st.session_state.get(_key_cmt, "")
        try:
            _save_reponse(_session_id, _ind_id, v, c)
            st.toast("Réponse enregistrée", icon="✅")
        except Exception as exc:
            st.error(f"Erreur lors de la sauvegarde : {exc}")

    val = st.select_slider(
        label="Palier",
        options=OPTIONS,
        format_func=_format_option,
        key=key_val,
        label_visibility="collapsed",
        on_change=_on_change,
    )

    # Afficher la description du palier sélectionné
    if val is not None:
        desc = _palier_desc(paliers, val)
        if desc:
            st.caption(desc)

    # Commentaire optionnel — sauvegarde automatique dès modification
    def _on_change_cmt(
        _session_id=session_id,
        _ind_id=ind_id,
        _key=key_val,
        _key_cmt=key_cmt,
    ):
        v = st.session_state.get(_key)
        c = st.session_state[_key_cmt]
        if v is not None:
            try:
                _save_reponse(_session_id, _ind_id, v, c)
                st.toast("Commentaire enregistré", icon="✅")
            except Exception as exc:
                st.error(f"Erreur lors de la sauvegarde : {exc}")

    commentaire_retour = st.text_area(
        "Commentaire (optionnel)",
        key=key_cmt,
        label_visibility="visible",
        height=60,
        on_change=_on_change_cmt,
    )

    return val, commentaire_retour
