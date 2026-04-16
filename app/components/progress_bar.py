"""
Composant barre de progression pour une session de saisie.
Expose les données de progression pour l'affichage Streamlit.
"""

from __future__ import annotations
import streamlit as st
from app.utils.scoring import progress_session


def render_progress_bar(session_id: int, campagne_id: int) -> dict:
    """
    Affiche la barre de progression globale de la session et retourne le dict de progression.

    Returns:
        dict avec clés : answered, total, answered_by_domain
    """
    progress = progress_session(session_id, campagne_id)
    answered = progress["answered"]
    total    = progress["total"]

    if total == 0:
        ratio = 0.0
        label = "Aucun indicateur"
    else:
        ratio = answered / total
        label = f"{answered} / {total} indicateurs renseignés"

    st.progress(ratio, text=label)
    return progress


def domain_badge(answered: int, total: int) -> str:
    """Retourne un badge textuel d'avancement pour un domaine."""
    if total == 0:
        return "—"
    if answered == 0:
        return f"0 / {total}"
    if answered == total:
        return f"✓ {total} / {total}"
    return f"{answered} / {total}"


def domain_status(answered: int, total: int) -> str:
    """Retourne le statut d'avancement d'un domaine : non_demarre / en_cours / complet."""
    if total == 0 or answered == 0:
        return "non_demarre"
    if answered == total:
        return "complet"
    return "en_cours"
