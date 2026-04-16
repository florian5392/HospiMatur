"""
Gestion unique de la connexion MySQL.
Toute connexion à la base passe par ce module — jamais directement dans les pages.
"""

import time
from contextlib import contextmanager

import mysql.connector
from mysql.connector import Error

# Les credentials viennent exclusivement du .env via config.py
from app.config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD


def get_connection(max_retries: int = 3, retry_delay: float = 1.0):
    """
    Retourne une connexion MySQL active.
    Tente max_retries fois avant de lever une ConnectionError.
    """
    last_error = None
    for attempt in range(max_retries):
        try:
            conn = mysql.connector.connect(
                host=DB_HOST,
                port=DB_PORT,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                charset="utf8mb4",
                use_unicode=True,
                autocommit=False,
                connection_timeout=10,
            )
            return conn
        except Error as exc:
            last_error = exc
            if attempt < max_retries - 1:
                time.sleep(retry_delay)

    raise ConnectionError(
        f"Impossible de se connecter à MySQL "
        f"({DB_HOST}:{DB_PORT}/{DB_NAME}) : {last_error}"
    ) from last_error


@contextmanager
def get_cursor(dictionary: bool = True):
    """
    Context manager fournissant un curseur MySQL.

    Usage :
        with get_cursor() as cursor:
            cursor.execute("SELECT ...")
            rows = cursor.fetchall()

    Commit automatique en fin de bloc, rollback en cas d'exception.
    """
    conn = get_connection()
    cursor = None
    try:
        cursor = conn.cursor(dictionary=dictionary)
        yield cursor
        conn.commit()
    except Error:
        conn.rollback()
        raise
    finally:
        if cursor:
            cursor.close()
        conn.close()


def test_connection() -> tuple[bool, str]:
    """Vérifie la connexion à la base. Retourne (succès, message)."""
    try:
        conn = get_connection(max_retries=1)
        conn.close()
        return True, "Connexion à la base de données établie."
    except ConnectionError as exc:
        return False, str(exc)
