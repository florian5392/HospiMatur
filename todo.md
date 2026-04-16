# TODO — HospiConnect Maturité

Liste complète des tâches de développement, dans l'ordre d'exécution recommandé.

---

## PHASE 0 — Initialisation du projet

- [x] Modèle de données défini (11 tables)
- [x] Scripts SQL créés (`01_create_tables.sql`, `02_init_referentiel.sql`)
- [x] Docker Compose MySQL opérationnel
- [x] Créer le fichier `.env.example` avec toutes les variables nécessaires (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `ADMIN_PASSWORD`)
- [x] Créer le fichier `requirements.txt` avec les dépendances : `streamlit`, `mysql-connector-python`, `pandas`, `plotly`, `python-dotenv`
- [x] Créer la structure de dossiers complète (`app/`, `app/db/`, `app/pages/`, `app/components/`, `app/utils/`)

---

## PHASE 1 — Socle technique

### T01 — Module de connexion MySQL (`app/db/connection.py`)

- [x] Charger les variables d'environnement depuis `.env` via `python-dotenv`
- [x] Implémenter une fonction `get_connection()` qui retourne une connexion `mysql.connector`
- [x] Implémenter un context manager `get_cursor()` pour usage avec `with` statement
- [x] Gérer la reconnexion automatique en cas de perte de connexion
- [x] Tester la connexion au démarrage et afficher un message d'erreur explicite si la base est inaccessible

### T02 — Configuration (`app/config.py`)

- [x] Charger et exposer toutes les variables d'environnement
- [x] Définir les constantes de l'application (nom app, version, couleurs UI)
- [x] Exposer le mot de passe admin hashé pour comparaison sécurisée

### T03 — Point d'entrée (`app/main.py`)

- [x] Configurer la page Streamlit (`st.set_page_config`) : titre, icône, layout wide
- [x] Implémenter la navigation principale : sidebar avec trois sections (Administration, Formulaire référent, Dashboard)
- [x] Gérer l'état de session Streamlit (`st.session_state`) pour conserver l'authentification admin et l'état de la session référent entre les pages
- [x] Afficher le nom de l'application et la version en sidebar

---

## PHASE 2 — Espace Administration (`app/pages/admin.py`)

### T04 — Authentification admin

- [x] Afficher un formulaire de saisie du mot de passe admin
- [x] Comparer avec `ADMIN_PASSWORD` depuis `.env` (comparaison sécurisée)
- [x] Stocker l'état d'authentification dans `st.session_state`
- [x] Afficher un bouton de déconnexion une fois connecté
- [x] Bloquer l'accès à toutes les fonctions admin si non authentifié

### T05 — Gestion des établissements

- [x] Afficher la liste des établissements existants (nom, code, statut actif/inactif) sous forme de tableau
- [x] Formulaire de création d'un établissement : champs `nom` (obligatoire) et `code` (obligatoire, unique)
- [x] Bouton d'activation/désactivation pour chaque établissement
- [x] Empêcher la désactivation d'un établissement ayant des sessions en cours sur une campagne ouverte (afficher un message d'avertissement)

### T06 — Gestion des campagnes

- [x] Afficher la liste des campagnes existantes (libellé, dates, statut) sous forme de tableau
- [x] Formulaire de création d'une campagne : champs `libellé` (ex : S1 2026, obligatoire, unique), `date_debut` (date picker), `date_fin` (date picker)
- [x] Validation : date_fin doit être postérieure à date_debut
- [x] Bouton pour ouvrir ou fermer une campagne (toggle statut OUVERTE/FERMEE)
- [x] Empêcher la fermeture d'une campagne ayant des sessions EN_COURS (afficher un avertissement)
- [x] Une seule campagne peut être OUVERTE à la fois (validation à la création et à l'ouverture)

### T07 — Vue d'ensemble des sessions (admin)

- [x] Afficher un tableau de toutes les sessions toutes campagnes confondues : établissement, campagne, référent, statut, date création, date dernière modification, nombre d'indicateurs renseignés / total
- [x] Filtre par campagne (selectbox)
- [x] Filtre par établissement (selectbox)
- [x] Filtre par statut (EN_COURS / SOUMISE)
- [x] Export CSV du tableau filtré

### T08 — Saisie des indicateurs GROUPE (admin)

- [x] Afficher la liste des indicateurs avec `porteur = GROUPE`
- [x] Sélecteur de campagne active pour laquelle renseigner les valeurs groupe
- [x] Pour chaque indicateur GROUPE : afficher titre, définition, et un slider 0-4 avec description du palier sélectionné
- [x] Sauvegarder les valeurs groupe dans `reponses_groupe`
- [x] Ces valeurs sont ensuite injectées en lecture seule dans le formulaire référent

---

## PHASE 3 — Formulaire de collecte référent (`app/pages/formulaire.py`)

### T09 — Identification et gestion de session

- [x] Afficher uniquement les campagnes avec statut `OUVERTE` dans le selectbox campagne
- [x] Si aucune campagne ouverte : afficher un message informatif et bloquer l'accès au formulaire
- [x] Afficher uniquement les établissements avec `actif = TRUE` dans le selectbox établissement
- [x] Champ texte `Votre nom` (obligatoire, trimming des espaces)
- [x] Bouton `Démarrer ou reprendre ma session`
- [x] Vérifier en base si une session existe pour la combinaison établissement + campagne + nom_referent
  - Si session existante EN_COURS : charger la session, afficher le nombre d'indicateurs déjà renseignés, proposer de reprendre
  - Si session existante SOUMISE : afficher un message indiquant que la session est déjà soumise pour cette campagne
  - Si aucune session : créer une nouvelle session en base, stocker l'`id_session` dans `st.session_state`

### T10 — Navigation par domaine

- [x] Afficher une barre de progression globale : nombre total d'indicateurs renseignés / total indicateurs de la session
- [x] Afficher les 5 domaines sous forme d'onglets avec indicateur d'avancement par domaine (ex : 12/23 indicateurs)
- [x] Permettre la navigation libre entre domaines sans perte des réponses déjà saisies
- [x] Afficher le statut de chaque domaine : non démarré / en cours / complet

### T11 — Affichage et saisie des indicateurs

- [x] Pour chaque domaine, afficher les indicateurs regroupés par rubrique puis par point clé
- [x] Afficher pour chaque point clé : son numéro et son libellé en titre de section
- [x] Pour chaque indicateur, afficher :
  - Code (ex : PROC-01A) et titre
  - Définition (dans un expander `Voir la définition complète`)
  - Badge de type : PROCESS / COUVERTURE / PILOTAGE / GOUVERNANCE (couleurs distinctes)
  - Badge GROUPE si `porteur = GROUPE` (affiché en lecture seule avec la valeur pré-remplie par l'admin)
  - Badge INVERSÉ si `inverse = TRUE` avec tooltip explicatif
- [x] Widget de saisie selon le type d'indicateur :
  - Indicateur standard : `st.select_slider` avec les 5 paliers (0 à 4), affichant la description du palier sélectionné
  - Indicateur `has_typologies = TRUE` (COUV-22D, COUV-22F) : 3 lignes de saisie (Médecins, IDE, Autres), chacune avec un `st.select_slider` 0-4
  - Indicateur `porteur = GROUPE` : affichage en lecture seule de la valeur saisie par l'admin, non modifiable par le référent
- [x] Champ commentaire optionnel (`st.text_area`) sous chaque indicateur
- [x] Valeur par défaut à None (non renseigné) — distinguer "non renseigné" de "palier 0"

### T12 — Sauvegarde automatique

- [x] Sauvegarder immédiatement en base chaque réponse dès qu'un palier est sélectionné (pas d'attente de soumission)
- [x] Pour les indicateurs standards : INSERT ou UPDATE dans `reponses`
- [x] Pour les indicateurs par typologie : INSERT ou UPDATE dans `reponses_typologies` pour chaque ligne de typologie
- [x] Mettre à jour `sessions.date_modif` à chaque sauvegarde
- [x] Afficher une confirmation visuelle discrète de la sauvegarde (ex : `st.toast("Réponse enregistrée")`)

### T13 — Soumission finale

- [x] Afficher le bouton `Soumettre ma session` uniquement si tous les indicateurs non-GROUPE sont renseignés
- [x] Si des indicateurs manquants : afficher la liste des indicateurs non renseignés par domaine
- [x] Demande de confirmation avant soumission (`st.warning` + bouton de confirmation)
- [x] À la soumission : mettre à jour `sessions.statut` à `SOUMISE` et `sessions.date_modif`
- [x] Afficher un message de confirmation de soumission avec récapitulatif

---

## PHASE 4 — Dashboard (`app/pages/dashboard.py`)

### T14 — Vue par établissement

- [x] Sélecteurs : établissement (selectbox) + campagne (selectbox)
- [x] Si aucune session soumise pour la sélection : afficher un message informatif
- [x] Score global de maturité : moyenne de tous les indicateurs renseignés, affichée sur 4 avec jauge visuelle
- [x] Graphique radar Plotly : un axe par domaine, score moyen par domaine
- [x] Tableau détaillé par domaine → rubrique → point clé avec score moyen et nombre d'indicateurs renseignés
- [x] Possibilité d'afficher les réponses détaillées par indicateur (expand/collapse par point clé)
- [x] Comparaison entre deux campagnes si les données existent (sélecteur campagne de référence)

### T15 — Vue consolidée groupe

- [x] Sélecteur de campagne
- [x] Tableau comparatif multi-établissements : une ligne par établissement, une colonne par domaine, valeur = score moyen du domaine, code couleur par niveau (rouge < 1, orange 1-2, jaune 2-3, vert > 3)
- [x] Graphique barres groupées Plotly : établissements en abscisse, score par domaine en couleur
- [x] Identification automatique des établissements les plus en retard (score global le plus bas)
- [x] Identification automatique des domaines les plus faibles sur l'ensemble du groupe
- [x] Export CSV du tableau comparatif

### T16 — Composant widget indicateur (`app/components/indicateur_widget.py`)

- [x] Extraire la logique d'affichage d'un indicateur dans un composant réutilisable
- [x] Accepter en paramètre : l'indicateur (dict), la réponse existante (None si non renseigné), le mode (édition / lecture seule)
- [x] Retourner la valeur saisie et le commentaire

### T17 — Composant barre de progression (`app/components/progress_bar.py`)

- [x] Calculer le nombre d'indicateurs renseignés vs total pour une session donnée
- [x] Calculer le même ratio par domaine
- [x] Exposer ces données pour affichage dans le formulaire et dans la vue admin

---

## PHASE 5 — Qualité et finalisation

### T18 — Gestion des erreurs

- [x] Toute exception de base de données capturée avec `st.error()` et message utilisateur lisible
- [x] Validation des formulaires admin (champs obligatoires, unicité, cohérence des dates)
- [x] Gestion de la perte de session Streamlit (rechargement de page) : vérifier que `st.session_state` est correctement réinitialisé

### T19 — Script SQL complémentaire

- [x] Créer `init/03_create_reponses_groupe.sql` avec la table `reponses_groupe`
- [x] Ajouter ce fichier dans le dossier `init/` pour exécution automatique au démarrage Docker

### T20 — Tests manuels

- [ ] Créer un établissement depuis l'espace admin
- [ ] Créer une campagne, l'ouvrir
- [ ] Renseigner les indicateurs GROUPE pour la campagne
- [ ] Démarrer une session référent, remplir partiellement, fermer le navigateur
- [ ] Reprendre la session et vérifier que les réponses sont bien restaurées
- [ ] Compléter tous les indicateurs et soumettre
- [ ] Vérifier l'affichage du dashboard vue établissement
- [ ] Créer une seconde session pour un autre établissement et vérifier la vue consolidée groupe

---

## Notes pour Claude Code

- Le projet utilise **Streamlit** avec `st.session_state` pour la gestion d'état entre interactions
- Toute la logique de base de données passe par `app/db/connection.py` — ne jamais créer de connexion directe dans les pages
- Les credentials sont **uniquement** dans `.env`, jamais dans le code
- Le référentiel ANS (domaines, rubriques, points_cles, indicateurs, paliers) est **en lecture seule** — aucune page ne doit permettre de le modifier
- La distinction `porteur = GROUPE` vs `porteur = ETABLISSEMENT` est critique : les indicateurs GROUPE sont saisis par l'admin dans `reponses_groupe`, pas par le référent dans `reponses`
- Les indicateurs `has_typologies = TRUE` sont uniquement COUV-22D et COUV-22F — ils utilisent `reponses_typologies` et non `reponses`
- Les indicateurs `inverse = TRUE` ont leur sens de notation inversé (palier 0 = risque maximal) — signaler visuellement au référent
- Ne jamais confondre "valeur non renseignée" (absence de ligne) et "palier 0" — un indicateur sans ligne ne doit pas contribuer au calcul des scores
