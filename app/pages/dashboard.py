"""
Dashboard de consultation — HospiConnect Maturité

T14 — Vue par établissement (score, radar, tableau détaillé, comparaison)
T15 — Vue consolidée groupe (tableau multi-établissements, graphe, alertes)
"""

from __future__ import annotations
import io
import streamlit as st
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px

from app.db.connection import get_cursor
from app.utils.scoring import (
    scores_par_domaine,
    scores_par_rubrique,
    score_global,
    build_score_df,
)


# ─────────────────────────────────────────────────────────────────────────────
# Helpers de chargement
# ─────────────────────────────────────────────────────────────────────────────

@st.cache_data(ttl=60, show_spinner=False)
def _get_campagnes() -> list[dict]:
    with get_cursor() as cur:
        cur.execute("SELECT id, libelle, statut FROM campagnes ORDER BY libelle DESC")
        return cur.fetchall()


@st.cache_data(ttl=60, show_spinner=False)
def _get_etablissements() -> list[dict]:
    with get_cursor() as cur:
        cur.execute("SELECT id, code, nom FROM etablissements WHERE actif = 1 ORDER BY nom")
        return cur.fetchall()


def _get_sessions_for(campagne_id: int | None = None) -> list[dict]:
    sql = """
        SELECT s.id, s.id_etablissement, s.id_campagne,
               e.nom AS etab_nom, e.code AS etab_code,
               c.libelle AS camp_lib, s.statut, s.nom_referent
        FROM sessions s
        JOIN etablissements e ON s.id_etablissement = e.id
        JOIN campagnes      c ON s.id_campagne      = c.id
        WHERE s.statut = 'SOUMISE'
    """
    params: list = []
    if campagne_id:
        sql += " AND s.id_campagne = %s"
        params.append(campagne_id)
    sql += " ORDER BY e.nom"
    with get_cursor() as cur:
        cur.execute(sql, params)
        return cur.fetchall()


# ─────────────────────────────────────────────────────────────────────────────
# T14 — Vue par établissement
# ─────────────────────────────────────────────────────────────────────────────

def _color_score(score: float | None) -> str:
    if score is None:
        return "#cccccc"
    if score < 1:
        return "#e74c3c"
    if score < 2:
        return "#e67e22"
    if score < 3:
        return "#f1c40f"
    return "#27ae60"


def _gauge(score: float | None, title: str = "Score global") -> go.Figure:
    value = score if score is not None else 0
    fig = go.Figure(go.Indicator(
        mode="gauge+number",
        value=value,
        domain={"x": [0, 1], "y": [0, 1]},
        title={"text": title, "font": {"size": 18}},
        gauge={
            "axis":  {"range": [0, 4], "tickwidth": 1},
            "bar":   {"color": _color_score(score)},
            "steps": [
                {"range": [0, 1], "color": "#fadbd8"},
                {"range": [1, 2], "color": "#fdebd0"},
                {"range": [2, 3], "color": "#fef9e7"},
                {"range": [3, 4], "color": "#eafaf1"},
            ],
            "threshold": {
                "line": {"color": "#2c3e50", "width": 4},
                "thickness": 0.75,
                "value": value,
            },
        },
        number={"suffix": " / 4", "font": {"size": 28}},
    ))
    fig.update_layout(height=280, margin=dict(t=60, b=20, l=20, r=20))
    return fig


def _radar(scores: list[dict]) -> go.Figure:
    labels = [s["domaine_code"] for s in scores]
    values = [s["score"] if s["score"] is not None else 0 for s in scores]
    labels_full = [s["domaine_libelle"] for s in scores]

    fig = go.Figure(go.Scatterpolar(
        r=values + [values[0]],
        theta=labels + [labels[0]],
        fill="toself",
        fillcolor="rgba(31, 119, 180, 0.3)",
        line=dict(color="#1f77b4"),
        hovertemplate="%{theta}<br>Score : %{r:.2f}<extra></extra>",
        customdata=[[lf] for lf in labels_full + [labels_full[0]]],
    ))
    fig.update_layout(
        polar=dict(
            radialaxis=dict(visible=True, range=[0, 4], tickfont=dict(size=10)),
        ),
        showlegend=False,
        height=380,
        margin=dict(t=40, b=40, l=60, r=60),
    )
    return fig


def _tab_etablissement() -> None:
    st.header("Vue par établissement")

    campagnes    = _get_campagnes()
    etablissements = _get_etablissements()

    if not campagnes or not etablissements:
        st.info("Aucune donnée disponible.")
        return

    col1, col2 = st.columns(2)
    with col1:
        camp_opts = {c["libelle"]: c for c in campagnes}
        sel_camp  = st.selectbox("Campagne", list(camp_opts.keys()), key="db_camp")
        campagne  = camp_opts[sel_camp]
    with col2:
        etab_opts = {e["nom"]: e for e in etablissements}
        sel_etab  = st.selectbox("Établissement", list(etab_opts.keys()), key="db_etab")
        etab      = etab_opts[sel_etab]

    # Chercher une session soumise
    try:
        with get_cursor() as cur:
            cur.execute("""
                SELECT id FROM sessions
                WHERE id_etablissement = %s AND id_campagne = %s AND statut = 'SOUMISE'
                LIMIT 1
            """, (etab["id"], campagne["id"]))
            session_row = cur.fetchone()
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    if not session_row:
        st.info(
            f"Aucune session soumise pour **{etab['nom']}** "
            f"sur la campagne **{campagne['libelle']}**."
        )
        return

    session_id  = session_row["id"]
    camp_id     = campagne["id"]

    # Score global
    score = score_global(session_id, camp_id)
    dom_scores = scores_par_domaine(session_id, camp_id)

    col_gauge, col_radar = st.columns([2, 3])
    with col_gauge:
        st.plotly_chart(_gauge(score), use_container_width=True)
    with col_radar:
        if dom_scores:
            st.plotly_chart(_radar(dom_scores), use_container_width=True)

    # Tableau par domaine
    st.subheader("Scores par domaine")
    if dom_scores:
        df_dom = pd.DataFrame(dom_scores)[["domaine_code", "domaine_libelle", "score", "answered", "total"]]
        df_dom.columns = ["Code", "Domaine", "Score /4", "Renseignés", "Total"]
        df_dom["Score /4"] = df_dom["Score /4"].apply(
            lambda s: f"{s:.2f}" if s is not None else "—"
        )
        st.dataframe(df_dom, use_container_width=True, hide_index=True)

    # Tableau détaillé rubrique
    st.subheader("Scores par rubrique")
    rub_scores = scores_par_rubrique(session_id, camp_id)
    if rub_scores:
        df_rub = pd.DataFrame(rub_scores)[["rubrique_code", "rubrique_libelle", "score", "answered", "total"]]
        df_rub.columns = ["Code", "Rubrique", "Score /4", "Renseignés", "Total"]
        df_rub["Score /4"] = df_rub["Score /4"].apply(
            lambda s: f"{s:.2f}" if s is not None else "—"
        )
        st.dataframe(df_rub, use_container_width=True, hide_index=True)

    # Détail par indicateur (expander)
    with st.expander("Voir le détail par indicateur"):
        try:
            df_full = build_score_df(session_id, camp_id)
            if not df_full.empty:
                cols = ["domaine_code", "rubrique_code", "pc_numero", "code", "titre",
                        "porteur", "type", "valeur_effective"]
                df_show = df_full[cols].copy()
                df_show["valeur_effective"] = df_show["valeur_effective"].apply(
                    lambda v: f"{int(v)}" if pd.notna(v) else "—"
                )
                df_show.columns = ["Domaine", "Rubrique", "PC", "Code", "Titre",
                                   "Porteur", "Type", "Palier"]
                st.dataframe(df_show, use_container_width=True, hide_index=True)
        except Exception as exc:
            st.error(f"Erreur : {exc}")

    # Comparaison inter-campagnes
    st.subheader("Comparaison avec une autre campagne")
    other_camps = [c for c in campagnes if c["id"] != campagne["id"]]
    if other_camps:
        ref_camp_opts = {c["libelle"]: c for c in other_camps}
        sel_ref = st.selectbox("Campagne de référence", ["—"] + list(ref_camp_opts.keys()), key="db_ref_camp")
        if sel_ref != "—":
            ref_camp = ref_camp_opts[sel_ref]
            try:
                with get_cursor() as cur:
                    cur.execute("""
                        SELECT id FROM sessions
                        WHERE id_etablissement = %s AND id_campagne = %s AND statut = 'SOUMISE'
                        LIMIT 1
                    """, (etab["id"], ref_camp["id"]))
                    ref_sess = cur.fetchone()
            except Exception as exc:
                st.error(f"Erreur : {exc}")
                ref_sess = None

            if ref_sess:
                ref_dom_scores = scores_par_domaine(ref_sess["id"], ref_camp["id"])
                _show_comparison_chart(dom_scores, ref_dom_scores, sel_camp, sel_ref)
            else:
                st.info(f"Aucune session soumise pour {etab['nom']} sur {sel_ref}.")
    else:
        st.caption("Pas d'autres campagnes disponibles pour la comparaison.")


def _show_comparison_chart(
    scores_a: list[dict], scores_b: list[dict],
    label_a: str, label_b: str
) -> None:
    """Graphe barres groupées pour comparer deux campagnes."""
    codes_a = {s["domaine_code"]: s["score"] or 0 for s in scores_a}
    codes_b = {s["domaine_code"]: s["score"] or 0 for s in scores_b}
    all_codes = sorted(set(list(codes_a.keys()) + list(codes_b.keys())))

    fig = go.Figure([
        go.Bar(name=label_a, x=all_codes, y=[codes_a.get(c, 0) for c in all_codes], marker_color="#1f77b4"),
        go.Bar(name=label_b, x=all_codes, y=[codes_b.get(c, 0) for c in all_codes], marker_color="#aec7e8"),
    ])
    fig.update_layout(
        barmode="group",
        yaxis=dict(range=[0, 4], title="Score /4"),
        xaxis_title="Domaine",
        height=350,
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1),
        margin=dict(t=40, b=40, l=40, r=20),
    )
    st.plotly_chart(fig, use_container_width=True)


# ─────────────────────────────────────────────────────────────────────────────
# T15 — Vue consolidée groupe
# ─────────────────────────────────────────────────────────────────────────────

def _score_cell_color(score: float | None) -> str:
    if score is None:
        return "background-color: #f0f0f0; color: #999"
    if score < 1:
        return "background-color: #fadbd8; color: #922b21"
    if score < 2:
        return "background-color: #fdebd0; color: #784212"
    if score < 3:
        return "background-color: #fef9e7; color: #7d6608"
    return "background-color: #eafaf1; color: #1e8449"


def _tab_groupe() -> None:
    st.header("Vue consolidée groupe")

    campagnes = _get_campagnes()
    if not campagnes:
        st.info("Aucune campagne disponible.")
        return

    camp_opts = {c["libelle"]: c for c in campagnes}
    sel_camp  = st.selectbox("Campagne", list(camp_opts.keys()), key="grp_camp")
    campagne  = camp_opts[sel_camp]

    sessions = _get_sessions_for(campagne["id"])
    if not sessions:
        st.info(f"Aucune session soumise pour la campagne **{campagne['libelle']}**.")
        return

    # Charger les domaines
    try:
        with get_cursor() as cur:
            cur.execute("SELECT id, code, libelle FROM domaines ORDER BY ordre")
            domaines = cur.fetchall()
    except Exception as exc:
        st.error(f"Erreur : {exc}")
        return

    # Construire la table de scores
    rows = []
    for sess in sessions:
        row = {"Établissement": sess["etab_nom"]}
        dom_scores = scores_par_domaine(sess["id"], campagne["id"])
        score_map  = {s["domaine_code"]: s["score"] for s in dom_scores}
        values     = [s["score"] for s in dom_scores if s["score"] is not None]
        row["Global"] = round(sum(values) / len(values), 2) if values else None
        for d in domaines:
            row[d["code"]] = score_map.get(d["code"])
        rows.append(row)

    df = pd.DataFrame(rows).set_index("Établissement")

    # Afficher avec style
    st.subheader("Scores par établissement et domaine")
    st.caption("🟢 > 3  🟡 2–3  🟠 1–2  🔴 < 1  ⬜ Non renseigné")

    # Formater pour affichage
    def fmt_score(v):
        return f"{v:.2f}" if v is not None else "—"

    df_display = df.applymap(fmt_score)
    st.dataframe(df_display, use_container_width=True)

    # Export CSV
    csv_buf = io.StringIO()
    df_display.to_csv(csv_buf)
    st.download_button(
        "⬇ Exporter en CSV",
        data=csv_buf.getvalue().encode("utf-8"),
        file_name=f"bilan_groupe_{campagne['libelle'].replace(' ', '_')}.csv",
        mime="text/csv",
    )

    # Graphe barres groupées
    st.subheader("Graphique comparatif")
    dom_cols = [d["code"] for d in domaines]
    fig = go.Figure()
    colors = px.colors.qualitative.Plotly
    for i, etab in enumerate(df.index):
        fig.add_trace(go.Bar(
            name=etab,
            x=dom_cols,
            y=[df.loc[etab, c] or 0 for c in dom_cols],
            marker_color=colors[i % len(colors)],
        ))
    fig.update_layout(
        barmode="group",
        yaxis=dict(range=[0, 4], title="Score /4"),
        xaxis_title="Domaine",
        height=400,
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1),
        margin=dict(t=40, b=40, l=40, r=20),
    )
    st.plotly_chart(fig, use_container_width=True)

    # Alertes automatiques
    st.subheader("Indicateurs de vigilance")
    _show_group_alerts(df, domaines)


def _show_group_alerts(df: pd.DataFrame, domaines: list[dict]) -> None:
    """Identifie les établissements et domaines les plus en retard."""
    col1, col2 = st.columns(2)

    with col1:
        st.markdown("**Établissements les plus en retard (score global)**")
        if "Global" in df.columns:
            df_sorted = df["Global"].dropna().sort_values()
            if not df_sorted.empty:
                for etab, score in df_sorted.head(3).items():
                    st.metric(etab, f"{score:.2f} / 4")
            else:
                st.caption("Pas de données.")

    with col2:
        st.markdown("**Domaines les plus faibles (moyenne groupe)**")
        dom_means = {}
        for d in domaines:
            col = d["code"]
            if col in df.columns:
                vals = [v for v in df[col] if v is not None and pd.notna(v)]
                if vals:
                    dom_means[d["libelle"]] = round(sum(vals) / len(vals), 2)

        if dom_means:
            for dom, score in sorted(dom_means.items(), key=lambda x: x[1])[:3]:
                st.metric(dom[:40], f"{score:.2f} / 4")
        else:
            st.caption("Pas de données.")


# ─────────────────────────────────────────────────────────────────────────────
# Point d'entrée
# ─────────────────────────────────────────────────────────────────────────────

def show() -> None:
    st.title("Dashboard de maturité")

    tab_etab, tab_groupe = st.tabs([
        "🏥 Vue établissement",
        "📊 Vue consolidée groupe",
    ])
    with tab_etab:
        try:
            _tab_etablissement()
        except Exception as exc:
            st.error(f"Erreur : {exc}")
    with tab_groupe:
        try:
            _tab_groupe()
        except Exception as exc:
            st.error(f"Erreur : {exc}")
