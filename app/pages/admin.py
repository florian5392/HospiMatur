"""
Espace Administration — HospiConnect Maturité

Onglets :
  1. Établissements
  2. Campagnes
  3. Sessions
  4. Indicateurs Groupe
"""
# pylint: disable=too-many-locals,too-many-branches,too-many-statements
# pylint: disable=broad-exception-caught

from __future__ import annotations
import io
import datetime
import streamlit as st
import pandas as pd

from mysql.connector import Error
from app.db.connection import get_cursor

from app.utils.auth import is_admin, login, logout



# ─────────────────────────────────────────────────────────────────────────────
# T04 — Authentification admin
# ─────────────────────────────────────────────────────────────────────────────

def _show_login_form() -> None:
    st.subheader("Authentification administrateur")
    with st.form("admin_login"):
        pwd = st.text_input("Mot de passe", type="password")
        submitted = st.form_submit_button("Se connecter")
    if submitted:
        if login(pwd):
            st.success("Connexion réussie.")
            st.rerun()
        else:
            st.error("Mot de passe incorrect.")


# ─────────────────────────────────────────────────────────────────────────────
# T05 — Gestion des établissements
# ─────────────────────────────────────────────────────────────────────────────

def _tab_etablissements() -> None:
    st.header("Établissements")

    # Liste
    try:
        with get_cursor() as cur:
            cur.execute("SELECT id, code, nom, actif FROM etablissements ORDER BY nom")
            etabs = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur de chargement des établissements : {exc}")
        return

    if etabs:
        df = pd.DataFrame(etabs)
        df["actif"] = df["actif"].map({1: "✅ Actif", 0: "❌ Inactif"})
        df.rename(columns={"code": "Code", "nom": "Nom", "actif": "Statut"}, inplace=True)
        st.dataframe(df[["Code", "Nom", "Statut"]], use_container_width=True)

        # Boutons activation / désactivation
        with st.expander("Activer / désactiver un établissement"):
            etab_options = {f"{e['nom']} ({e['code']})": e for e in etabs}
            selected_label = st.selectbox("Choisir un établissement", list(etab_options.keys()))
            selected = etab_options[selected_label]
            current_actif = selected["actif"]
            action_label = "Désactiver" if current_actif else "Activer"

            if st.button(f"{action_label} cet établissement"):
                # Vérifier s'il a des sessions EN_COURS sur campagne ouverte
                if current_actif:
                    try:
                        with get_cursor() as cur:
                            cur.execute("""
                                SELECT COUNT(*) AS nb FROM sessions s
                                JOIN campagnes c ON s.id_campagne = c.id
                                WHERE s.id_etablissement = %s
                                  AND s.statut = 'EN_COURS'
                                  AND c.statut = 'OUVERTE'
                            """, (selected["id"],))
                            nb = cur.fetchone()["nb"]
                        if nb > 0:
                            st.warning(
                                f"Impossible de désactiver : {nb} session(s) EN_COURS "
                                "sur une campagne ouverte."
                            )
                            return
                    except Exception as exc:
                        st.error(f"Erreur : {exc}")
                        return

                try:
                    with get_cursor() as cur:
                        cur.execute(
                            "UPDATE etablissements SET actif = %s WHERE id = %s",
                            (0 if current_actif else 1, selected["id"])
                        )
                    st.success(f"Établissement {action_label.lower()}.")
                    st.rerun()
                except Exception as exc:
                    st.error(f"Erreur : {exc}")
    else:
        st.info("Aucun établissement enregistré.")

    # Formulaire de création
    st.divider()
    st.subheader("Créer un établissement")
    with st.form("new_etab"):
        new_nom  = st.text_input("Nom *")
        new_code = st.text_input("Code unique *")
        submit   = st.form_submit_button("Créer")

    if submit:
        nom  = new_nom.strip()
        code = new_code.strip().upper()
        if not nom or not code:
            st.error("Le nom et le code sont obligatoires.")
        else:
            try:
                with get_cursor() as cur:
                    cur.execute(
                        "INSERT INTO etablissements (nom, code, actif) VALUES (%s, %s, 1)",
                        (nom, code)
                    )
                st.success(f"Établissement « {nom} » créé avec le code {code}.")
                st.rerun()
            except Error as exc:
                if "Duplicate" in str(exc):
                    st.error(f"Le code « {code} » existe déjà.")
                else:
                    st.error(f"Erreur : {exc}")


# ─────────────────────────────────────────────────────────────────────────────
# T06 — Gestion des campagnes
# ─────────────────────────────────────────────────────────────────────────────

def _tab_campagnes() -> None:
    st.header("Campagnes")

    try:
        with get_cursor() as cur:
            cur.execute(
                "SELECT id, libelle, date_debut, date_fin, statut "
                "FROM campagnes ORDER BY date_debut DESC"
            )
            campagnes = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur de chargement des campagnes : {exc}")
        return

    if campagnes:
        df = pd.DataFrame(campagnes)
        df.rename(columns={
            "libelle": "Libellé", "date_debut": "Début",
            "date_fin": "Fin", "statut": "Statut"
        }, inplace=True)
        st.dataframe(df[["Libellé", "Début", "Fin", "Statut"]], use_container_width=True)

        # Ouvrir / fermer
        with st.expander("Ouvrir / fermer une campagne"):
            camp_opts = {f"{c['libelle']} ({c['statut']})": c for c in campagnes}
            sel_label = st.selectbox("Choisir une campagne", list(camp_opts.keys()))
            sel_camp  = camp_opts[sel_label]
            is_open   = sel_camp["statut"] == "OUVERTE"
            btn_label = "Fermer" if is_open else "Ouvrir"

            if st.button(f"{btn_label} cette campagne"):
                if is_open:
                    # Vérifier sessions EN_COURS
                    try:
                        with get_cursor() as cur:
                            cur.execute(
                                "SELECT COUNT(*) AS nb FROM sessions "
                                "WHERE id_campagne = %s AND statut = 'EN_COURS'",
                                (sel_camp["id"],)
                            )
                            nb = cur.fetchone()["nb"]
                        if nb > 0:
                            st.warning(
                                f"Impossible de fermer : {nb} "
                                "session(s) EN_COURS sur cette campagne."
                            )
                            return
                    except Exception as exc:
                        st.error(f"Erreur : {exc}")
                        return
                else:
                    # S'assurer qu'aucune autre campagne n'est ouverte
                    try:
                        with get_cursor() as cur:
                            cur.execute(
                                "SELECT COUNT(*) AS nb FROM campagnes WHERE statut = 'OUVERTE'"
                            )
                            nb = cur.fetchone()["nb"]
                        if nb > 0:
                            st.warning("Une seule campagne peut être OUVERTE à la fois.")
                            return
                    except Exception as exc:
                        st.error(f"Erreur : {exc}")
                        return

                try:
                    new_statut = "FERMEE" if is_open else "OUVERTE"
                    with get_cursor() as cur:
                        cur.execute(
                            "UPDATE campagnes SET statut = %s WHERE id = %s",
                            (new_statut, sel_camp["id"])
                        )
                    st.success(f"Campagne {btn_label.lower()}.")
                    st.rerun()
                except Exception as exc:
                    st.error(f"Erreur : {exc}")
    else:
        st.info("Aucune campagne enregistrée.")

    # Formulaire de création
    st.divider()
    st.subheader("Créer une campagne")
    with st.form("new_campagne"):
        new_lib   = st.text_input("Libellé * (ex : S1 2026)")
        col1, col2 = st.columns(2)
        with col1:
            new_debut = st.date_input("Date de début *", value=datetime.date.today())
        with col2:
            new_fin   = st.date_input("Date de fin *",   value=datetime.date.today())
        submit = st.form_submit_button("Créer")

    if submit:
        lib = new_lib.strip()
        if not lib:
            st.error("Le libellé est obligatoire.")
        elif new_fin <= new_debut:
            st.error("La date de fin doit être postérieure à la date de début.")
        else:
            # Vérifier unicité libellé
            try:
                with get_cursor() as cur:
                    cur.execute(
                        "SELECT COUNT(*) AS nb FROM campagnes WHERE libelle = %s", (lib,)
                    )
                    if cur.fetchone()["nb"] > 0:
                        st.error(f"Une campagne « {lib} » existe déjà.")
                        return
                    cur.execute(
                        "INSERT INTO campagnes (libelle, date_debut, date_fin, statut) "
                        "VALUES (%s, %s, %s, 'FERMEE')",
                        (lib, new_debut, new_fin)
                    )
                st.success(f"Campagne « {lib} » créée (statut FERMEE).")
                st.rerun()
            except Exception as exc:
                st.error(f"Erreur : {exc}")


# ─────────────────────────────────────────────────────────────────────────────
# T07 — Vue d'ensemble des sessions
# ─────────────────────────────────────────────────────────────────────────────

def _tab_sessions() -> None:
    st.header("Sessions")

    try:
        with get_cursor() as cur:
            # Compte les indicateurs ETABLISSEMENT hors has_typologies
            cur.execute(
                "SELECT COUNT(*) AS nb FROM indicateurs "
                "WHERE porteur='ETABLISSEMENT' AND has_typologies=0"
            )
            total_std = cur.fetchone()["nb"]
            # Compte les typologies ETABLISSEMENT
            cur.execute("""
                SELECT COUNT(*) AS nb FROM indicateur_typologies it
                JOIN indicateurs i ON it.id_indicateur = i.id
                WHERE i.porteur = 'ETABLISSEMENT'
            """)
            total_typo = cur.fetchone()["nb"]
            total_indicators = total_std + total_typo

            cur.execute("""
                SELECT
                    s.id, e.nom AS etablissement, c.libelle AS campagne,
                    s.nom_referent, s.statut,
                    DATE_FORMAT(s.date_creation, '%d/%m/%Y %H:%i') AS date_creation,
                    DATE_FORMAT(s.date_modif,    '%d/%m/%Y %H:%i') AS date_modif,
                    (SELECT COUNT(*) FROM reponses r WHERE r.id_session = s.id) AS rep_std,
                    (SELECT COUNT(*) FROM reponses_typologies rt WHERE rt.id_session = s.id) AS rep_typo,
                    c.id AS id_campagne
                FROM sessions s
                JOIN etablissements e ON s.id_etablissement = e.id
                JOIN campagnes      c ON s.id_campagne      = c.id
                ORDER BY s.date_modif DESC
            """)
            sessions = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    if not sessions:
        st.info("Aucune session enregistrée.")
        return

    df = pd.DataFrame(sessions)
    df["renseignés"] = df["rep_std"] + df["rep_typo"]
    df["avancement"] = df.apply(
        lambda r: f"{r['renseignés']} / {total_indicators}", axis=1
    )

    # Filtres
    col1, col2, col3 = st.columns(3)
    with col1:
        camp_choices = ["Toutes"] + sorted(df["campagne"].unique().tolist())
        filtre_camp  = st.selectbox("Campagne", camp_choices)
    with col2:
        etab_choices = ["Tous"] + sorted(df["etablissement"].unique().tolist())
        filtre_etab  = st.selectbox("Établissement", etab_choices)
    with col3:
        filtre_statut = st.selectbox("Statut", ["Tous", "EN_COURS", "SOUMISE"])

    df_f = df.copy()
    if filtre_camp  != "Toutes":
        df_f = df_f[df_f["campagne"] == filtre_camp]
    if filtre_etab  != "Tous":
        df_f = df_f[df_f["etablissement"] == filtre_etab]
    if filtre_statut != "Tous":
        df_f = df_f[df_f["statut"] == filtre_statut]

    cols_display = ["etablissement", "campagne", "nom_referent", "statut",
                    "date_creation", "date_modif", "avancement"]
    df_display = df_f[cols_display].rename(columns={
        "etablissement": "Établissement",
        "campagne":      "Campagne",
        "nom_referent":  "Référent",
        "statut":        "Statut",
        "date_creation": "Créée le",
        "date_modif":    "Modifiée le",
        "avancement":    "Avancement",
    })
    st.dataframe(df_display, use_container_width=True)

    # Export CSV
    csv_buf = io.StringIO()
    df_display.to_csv(csv_buf, index=False)
    st.download_button(
        "⬇ Exporter en CSV",
        data=csv_buf.getvalue().encode("utf-8"),
        file_name="sessions_hospiconnect.csv",
        mime="text/csv",
    )


# ─────────────────────────────────────────────────────────────────────────────
# T08 — Saisie des indicateurs GROUPE
# ─────────────────────────────────────────────────────────────────────────────

def _tab_indicateurs_groupe() -> None:
    st.header("Indicateurs porteur GROUPE")

    # Sélecteur de campagne
    try:
        with get_cursor() as cur:
            cur.execute(
                "SELECT id, libelle, statut FROM campagnes ORDER BY date_debut DESC"
            )
            campagnes = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    if not campagnes:
        st.info("Aucune campagne disponible.")
        return

    camp_opts  = {c["libelle"]: c for c in campagnes}
    camp_label = st.selectbox(
        "Campagne pour laquelle saisir les valeurs groupe",
        list(camp_opts.keys())
    )
    campagne   = camp_opts[camp_label]
    campagne_id = campagne["id"]

    # Charger indicateurs GROUPE avec leurs paliers
    try:
        with get_cursor() as cur:
            cur.execute("""
                SELECT i.id, i.code, i.titre, i.definition, i.type,
                       pc.libelle AS pc_libelle, pc.numero AS pc_numero,
                       d.libelle  AS domaine_libelle
                FROM indicateurs i
                JOIN points_cles pc ON i.id_point_cle = pc.id
                JOIN rubriques   r  ON pc.id_rubrique  = r.id
                JOIN domaines    d  ON r.id_domaine     = d.id
                WHERE i.porteur = 'GROUPE'
                ORDER BY d.ordre, r.ordre, pc.ordre, i.lettre
            """)
            groupe_indicators = cur.fetchall()

            cur.execute("""
                SELECT id_indicateur, valeur, description
                FROM paliers ORDER BY id_indicateur, valeur
            """)
            all_paliers_raw = cur.fetchall()
            all_paliers: dict[int, dict[int, str]] = {}
            for p in all_paliers_raw:
                all_paliers.setdefault(p["id_indicateur"], {})[p["valeur"]] = p["description"]

            cur.execute(
                "SELECT id_indicateur, valeur, commentaire "
                "FROM reponses_groupe WHERE id_campagne = %s",
                (campagne_id,)
            )
            rg_existing = {r["id_indicateur"]: r for r in cur.fetchall()}
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    if not groupe_indicators:
        st.info("Aucun indicateur GROUPE trouvé.")
        return

    st.info(
        f"Saisie pour la campagne **{camp_label}** "
        f"({campagne['statut']}). "
        f"{len(groupe_indicators)} indicateurs GROUPE."
    )

    # Affichage par domaine
    current_domain = None
    for ind in groupe_indicators:
        if ind["domaine_libelle"] != current_domain:
            current_domain = ind["domaine_libelle"]
            st.subheader(current_domain)

        ind_id  = ind["id"]
        paliers = all_paliers.get(ind_id, {})
        existing = rg_existing.get(ind_id)
        current_val = existing["valeur"] if existing else None
        current_cmt = existing.get("commentaire", "") or "" if existing else ""

        key_val = f"groupe_{campagne_id}_{ind_id}"
        key_cmt = f"groupe_cmt_{campagne_id}_{ind_id}"

        if key_val not in st.session_state:
            st.session_state[key_val] = current_val
        if key_cmt not in st.session_state:
            st.session_state[key_cmt] = current_cmt

        with st.container(border=True):
            st.markdown(f"**{ind['code']}** — {ind['titre']}")
            if ind["definition"]:
                with st.expander("Voir la définition", expanded=False):
                    st.write(ind["definition"])

            col_sl, col_desc = st.columns([4, 6])
            with col_sl:
                options_groupe = [None, 0, 1, 2, 3, 4]

                def _on_change_groupe(
                    _camp_id=campagne_id,
                    _ind_id=ind_id,
                    _key=key_val,
                    _key_cmt=key_cmt,
                ):
                    v = st.session_state[_key]
                    c = st.session_state.get(_key_cmt, "")
                    if v is None:
                        try:
                            with get_cursor() as cur:
                                cur.execute(
                                    "DELETE FROM reponses_groupe "
                                    "WHERE id_campagne = %s AND id_indicateur = %s",
                                    (_camp_id, _ind_id)
                                )
                            st.toast("Valeur supprimée", icon="🗑️")
                        except Exception as exc:
                            st.error(f"Erreur : {exc}")
                    else:
                        try:
                            with get_cursor() as cur:
                                cur.execute("""
                                    INSERT INTO reponses_groupe
                                        (id_campagne, id_indicateur, valeur, commentaire, date_saisie)
                                    VALUES (%s, %s, %s, %s, NOW())
                                    ON DUPLICATE KEY UPDATE
                                        valeur = VALUES(valeur),
                                        commentaire = VALUES(commentaire),
                                        date_saisie = NOW()
                                """, (_camp_id, _ind_id, int(v), c))
                            st.toast("Valeur groupe enregistrée", icon="✅")
                        except Exception as exc:
                            st.error(f"Erreur : {exc}")

                val = st.select_slider(
                    label="Palier",
                    options=options_groupe,
                    format_func=lambda x: "— Non renseigné" if x is None else str(x),
                    key=key_val,
                    label_visibility="collapsed",
                    on_change=_on_change_groupe,
                )
            with col_desc:
                if val is not None and val in paliers:
                    st.caption(paliers[val])

            def _on_change_cmt_groupe(
                _camp_id=campagne_id,
                _ind_id=ind_id,
                _key=key_val,
                _key_cmt=key_cmt,
            ):
                v = st.session_state.get(_key)
                c = st.session_state[_key_cmt]
                if v is None:
                    return
                try:
                    with get_cursor() as cur:
                        cur.execute("""
                            INSERT INTO reponses_groupe
                                (id_campagne, id_indicateur, valeur, commentaire, date_saisie)
                            VALUES (%s, %s, %s, %s, NOW())
                            ON DUPLICATE KEY UPDATE
                                valeur = VALUES(valeur),
                                commentaire = VALUES(commentaire),
                                date_saisie = NOW()
                        """, (_camp_id, _ind_id, int(v), c))
                    st.toast("Commentaire groupe enregistré", icon="✅")
                except Exception as exc:
                    st.error(f"Erreur : {exc}")

            st.text_area(
                "Commentaire (optionnel)",
                key=key_cmt,
                height=50,
                label_visibility="visible",
                on_change=_on_change_cmt_groupe,
            )


# ─────────────────────────────────────────────────────────────────────────────
# Point d'entrée de la page
# ─────────────────────────────────────────────────────────────────────────────

def show() -> None:
    """Affiche la page administration (authentification + 4 onglets de gestion)."""
    st.title("Administration")

    if not is_admin():
        _show_login_form()
        return

    _, col_logout = st.columns([9, 1])
    with col_logout:
        if st.button("Déconnexion", type="secondary"):
            logout()
            st.rerun()

    tab_etab, tab_camp, tab_sess, tab_groupe = st.tabs([
        "🏥 Établissements",
        "📅 Campagnes",
        "📋 Sessions",
        "🔑 Indicateurs Groupe",
    ])
    with tab_etab:
        _tab_etablissements()
    with tab_camp:
        _tab_campagnes()
    with tab_sess:
        _tab_sessions()
    with tab_groupe:
        _tab_indicateurs_groupe()
