# HospiConnect Maturité — Application de collecte des indicateurs

Application Streamlit de collecte et de pilotage des indicateurs de maturité HospiConnect, basée sur le référentiel ANS « Indicateurs de maturité de la gestion de l'identité numérique des professionnels » v1.0.

---

## Contexte

L'Hospitalité Saint-Thomas de Villeneuve (groupe multi-sites de santé privé) déploie le programme HospiConnect en réponse aux exigences réglementaires ANS (2026-2028). Cette application permet de mesurer semestriellement la maturité de chaque établissement sur 5 domaines et 123 indicateurs définis par l'ANS, et d'en piloter l'évolution dans le temps.

---

## Architecture

```
hospiconnect/
├── app/
│   ├── main.py                  # Point d'entrée Streamlit
│   ├── config.py                # Configuration et variables d'environnement
│   ├── db/
│   │   ├── __init__.py
│   │   └── connection.py        # Gestion de la connexion MySQL
│   ├── pages/
│   │   ├── admin.py             # Espace administration
│   │   ├── formulaire.py        # Formulaire de collecte référent
│   │   └── dashboard.py         # Dashboard de consultation
│   ├── components/
│   │   ├── indicateur_widget.py # Widget de saisie d'un indicateur
│   │   └── progress_bar.py      # Barre de progression session
│   └── utils/
│       ├── auth.py              # Authentification admin simple
│       └── scoring.py           # Calcul des scores de maturité
├── init/
│   ├── 01_create_tables.sql
│   └── 02_init_referentiel.sql
├── docker-compose.yml
├── .env.example
├── requirements.txt
└── README.md
```

---

## Stack technique

- **Python 3.11+**
- **Streamlit** : framework UI
- **MySQL 8.0** : base de données (via Docker)
- **mysql-connector-python** : connecteur Python/MySQL
- **pandas** : manipulation des données pour le dashboard
- **plotly** : visualisations dashboard

---

## Installation et démarrage

### Prérequis

- Docker et Docker Compose installés
- Python 3.11+ installé
- pip installé

### 1. Cloner le projet et configurer l'environnement

```bash
git clone <repo>
cd hospiconnect
cp .env.example .env
# Éditer .env avec les valeurs souhaitées
```

### 2. Démarrer MySQL via Docker

```bash
docker compose up -d
# Attendre que MySQL soit prêt (vérifier avec docker compose logs mysql)
```

Les scripts `init/01_create_tables.sql` et `init/02_init_referentiel.sql` sont exécutés automatiquement au premier démarrage.

### 3. Installer les dépendances Python

```bash
pip install -r requirements.txt
```

### 4. Lancer l'application

```bash
streamlit run app/main.py
```

L'application est accessible sur `http://localhost:8501`.

---

## Variables d'environnement

Fichier `.env` à créer à partir de `.env.example` :

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=hospiconnect
DB_USER=hospiconnect_user
DB_PASSWORD=hospiconnect_pass
ADMIN_PASSWORD=admin_password
```

---

## Profils utilisateurs

### Administrateur
Accès via mot de passe défini dans `.env` (`ADMIN_PASSWORD`).
Fonctions :
- Gérer les établissements (créer, activer, désactiver)
- Gérer les campagnes (créer, ouvrir, fermer)
- Consulter l'état d'avancement de toutes les sessions

### Référent établissement
Pas d'authentification — identification par nom + établissement + campagne.
Fonctions :
- Créer ou reprendre une session de saisie
- Remplir les indicateurs domaine par domaine
- Soumettre la session une fois complète

---

## Modèle de données

11 tables MySQL :

**Référentiel ANS (statique)**
- `domaines` : 5 domaines
- `rubriques` : 16 rubriques
- `points_cles` : 28 points clés
- `indicateurs` : 123 indicateurs (type, porteur, inversé, has_typologies)
- `paliers` : descriptions des paliers 0 à 4 par indicateur
- `indicateur_typologies` : typologies pour COUV-22D et COUV-22F (Médecins, IDE, Autres)

**Données opérationnelles (dynamiques)**
- `etablissements` : liste des établissements du groupe
- `campagnes` : campagnes semestrielles (S1 2026, S2 2026, etc.)
- `sessions` : sessions de saisie (établissement + campagne + référent)
- `reponses` : réponses aux indicateurs standards (palier 0-4)
- `reponses_typologies` : réponses aux indicateurs par typologie

### Champs importants sur `indicateurs`

| Champ | Description |
|---|---|
| `type` | PROCESS / COUVERTURE / PILOTAGE / GOUVERNANCE |
| `inverse` | TRUE si palier élevé = moins bon (indicateurs de risque) |
| `has_typologies` | TRUE pour COUV-22D et COUV-22F (saisie par Médecins/IDE/Autres) |
| `porteur` | ETABLISSEMENT ou GROUPE (les indicateurs GROUPE sont pré-remplis par la DSI) |

---

## Comportement de l'application

### Gestion des sessions

- Une session est identifiée par la combinaison unique `établissement + campagne + nom_référent`
- Une session peut être créée, mise en pause et reprise à tout moment
- La session passe en statut `SOUMISE` uniquement lorsque tous les indicateurs de tous les domaines sont renseignés et que le référent valide explicitement
- Les indicateurs de porteur `GROUPE` sont affichés en lecture seule pour le référent (pré-remplis par l'admin)

### Sauvegarde

- Chaque réponse est sauvegardée immédiatement en base à la saisie, sans attendre la soumission finale
- La reprise de session restaure toutes les réponses déjà saisies

### Indicateurs par typologie (COUV-22D, COUV-22F)

- Affichage de 3 lignes de saisie : Médecins, IDE, Autres professionnels
- Chaque ligne est un palier 0-4 indépendant
- Stocké dans `reponses_typologies` et non dans `reponses`

### Indicateurs inversés

- Les indicateurs avec `inverse = TRUE` sont des indicateurs de risque
- Un palier 0 = situation la plus risquée, palier 4 = situation la plus sûre
- L'interface doit signaler visuellement ce comportement inversé au référent

---

## Calcul des scores

Le score de maturité est calculé comme la moyenne des paliers saisis sur un périmètre donné (domaine, rubrique, point clé, ou global). Le score est exprimé sur 4.

Pour les indicateurs de porteur `GROUPE` non encore renseignés, ils sont exclus du calcul jusqu'à leur saisie.

Les indicateurs `has_typologies` contribuent au score avec la moyenne de leurs typologies.

---

## Conventions de code

- Langue : français pour les labels UI, anglais pour le code et les noms de variables
- Connexion MySQL : toujours via le module `db/connection.py`, jamais de connexion directe dans les pages
- Pas de données en dur dans le code : tout vient de la base
- Gestion des erreurs : toute exception de base de données est capturée et affichée proprement à l'utilisateur via `st.error()`
- Les credentials ne sont jamais écrits dans le code : uniquement via `.env`
