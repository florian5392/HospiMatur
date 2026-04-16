"""Configuration de l'application HospiConnect Maturité (variables d'env, constantes UI)."""
import os
import hmac
from dotenv import load_dotenv

load_dotenv()

# ── Base de données ────────────────────────────────────────────
DB_HOST     = os.getenv("DB_HOST", "localhost")
DB_PORT     = int(os.getenv("DB_PORT", "3306"))
DB_NAME     = os.getenv("DB_NAME", "hospiconnect")
DB_USER     = os.getenv("DB_USER", "hospiconnect_user")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

# ── Administration ─────────────────────────────────────────────
ADMIN_PASSWORD = os.getenv("ADMIN_PASSWORD", "")

# ── Application ────────────────────────────────────────────────
APP_NAME    = "HospiConnect Maturité"
APP_VERSION = "1.0.0"
APP_ICON    = "🏥"

# Couleurs par type d'indicateur
TYPE_COLORS = {
    "PROCESS":     "#1f77b4",
    "COUVERTURE":  "#2ca02c",
    "PILOTAGE":    "#ff7f0e",
    "GOUVERNANCE": "#9467bd",
}

TYPE_LABELS = {
    "PROCESS":     "PROCESS",
    "COUVERTURE":  "COUVERTURE",
    "PILOTAGE":    "PILOTAGE",
    "GOUVERNANCE": "GOUVERNANCE",
}


def check_admin_password(password: str) -> bool:
    """Comparaison sécurisée du mot de passe admin (protection timing-attack)."""
    if not ADMIN_PASSWORD:
        return False
    return hmac.compare_digest(
        password.encode("utf-8"),
        ADMIN_PASSWORD.encode("utf-8"),
    )
