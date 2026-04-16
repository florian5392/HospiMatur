"""Authentification admin (délégation à config.check_admin_password)."""

import streamlit as st
from app.config import check_admin_password


def is_admin() -> bool:
    """Retourne True si l'admin est authentifié dans la session Streamlit."""
    return st.session_state.get("admin_authenticated", False)


def login(password: str) -> bool:
    """Tente une connexion admin. Met à jour session_state. Retourne True si OK."""
    if check_admin_password(password):
        st.session_state["admin_authenticated"] = True
        return True
    return False


def logout() -> None:
    """Déconnecte l'admin."""
    st.session_state["admin_authenticated"] = False
