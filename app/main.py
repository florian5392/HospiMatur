"""
HospiConnect Maturité — Point d'entrée Streamlit

Navigation via la sidebar :
  - Formulaire référent (défaut)
  - Dashboard
  - Administration
"""

# Garantir que la racine du projet est dans sys.path, quel que soit le répertoire
# depuis lequel Streamlit est lancé (streamlit run app/main.py).
import sys
import os
_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _root not in sys.path:
    sys.path.insert(0, _root)

# pylint: disable=wrong-import-position
import streamlit as st
from app.config import APP_NAME, APP_VERSION, APP_ICON
from app.db.connection import test_connection

# ─────────────────────────────────────────────────────────────────────────────
# Configuration de la page (doit être le premier appel Streamlit)
# ─────────────────────────────────────────────────────────────────────────────

st.set_page_config(
    page_title=APP_NAME,
    page_icon=APP_ICON,
    layout="wide",
    initial_sidebar_state="expanded",
)

# ─────────────────────────────────────────────────────────────────────────────
# Initialisation de session_state globale
# ─────────────────────────────────────────────────────────────────────────────

if "admin_authenticated" not in st.session_state:
    st.session_state["admin_authenticated"] = False

if "current_page" not in st.session_state:
    st.session_state["current_page"] = "Formulaire référent"

# ─────────────────────────────────────────────────────────────────────────────
# Sidebar — Navigation + vérification DB
# ─────────────────────────────────────────────────────────────────────────────

with st.sidebar:
    st.markdown(f"## {APP_ICON} {APP_NAME}")
    st.caption(f"Version {APP_VERSION}")
    st.divider()

    # Vérification connexion DB (affichée une seule fois par session)
    if "db_ok" not in st.session_state:
        ok, msg = test_connection()
        st.session_state["db_ok"] = ok
        if not ok:
            st.error(f"Base de données inaccessible : {msg}")

    if not st.session_state.get("db_ok", False):
        st.error("Connexion à la base de données impossible.")
        st.stop()

    # Navigation
    pages = ["Formulaire référent", "Dashboard", "Administration"]
    icons = {"Formulaire référent": "📝", "Dashboard": "📊", "Administration": "⚙️"}

    st.markdown("### Navigation")
    for page in pages:
        label = f"{icons[page]} {page}"
        if st.button(label, use_container_width=True, key=f"nav_{page}"):
            st.session_state["current_page"] = page
            st.rerun()

    st.divider()

    # Indicateur admin connecté
    if st.session_state.get("admin_authenticated"):
        st.success("Admin connecté")

    # Info session référent active
    if st.session_state.get("session_id"):
        st.info(
            f"Session active :\n"
            f"**{st.session_state.get('nom_referent', '')}**\n"
            f"{st.session_state.get('etab_nom', '')}\n"
            f"{st.session_state.get('campagne_lib', '')}"
        )

    st.divider()
    st.caption("Groupe Hospitalité Saint-Thomas de Villeneuve")
    st.caption("Référentiel ANS — Indicateurs de maturité v1.0")

# ─────────────────────────────────────────────────────────────────────────────
# Routage vers la page sélectionnée
# ─────────────────────────────────────────────────────────────────────────────

current_page = st.session_state.get("current_page", "Formulaire référent")

if current_page == "Formulaire référent":
    from app.pages import formulaire
    formulaire.show()

elif current_page == "Dashboard":
    from app.pages import dashboard
    dashboard.show()

elif current_page == "Administration":
    from app.pages import admin
    admin.show()
