# CineFocus 🎬

CineFocus est une application Flutter moderne et performante, conçue pour les passionnés de cinéma afin de découvrir des films et des séries TV. Elle arbore un design "Teal Moody" élégant avec des éléments d'interface lumineux et une intégration backend robuste via Supabase.

## 🚀 Fonctionnalités Clés

### 🔐 Authentification
*   **Email & Mot de passe :** Flux d'inscription et de connexion traditionnel via Supabase Auth.
*   **Connexion Google :** Authentification simplifiée en un clic pour une meilleure accessibilité.
*   **Gestion sécurisée des sessions :** États de connexion persistants gérés de manière transparente.

### 🎬 Films & Séries TV
*   **Découverte :** Parcourez les contenus populaires, les mieux notés et les tendances.
*   **Découverte Dynamique (Films uniquement) :** La liste initiale des films est **mélangée (shuffled)** à chaque nouveau chargement pour offrir une expérience de découverte renouvelée, tandis que les pages suivantes et les résultats de recherche conservent leur ordre original.
*   **Recherche Avancée :** Recherche en temps réel avec un système de "debouncing" optimisé.
*   **Catégorisation :** Filtrez par genres (Action, Comédie, Sci-Fi, etc.) ou listes spécifiques (Diffusés aujourd'hui, À l'antenne).
*   **Vues Détaillées :**
    *   Arrière-plans et affiches dynamiques.
    *   Classifications d'âge et certifications.
    *   Synopsis et dates de sortie.
    *   Lecteur de **bandes-annonces YouTube** intégré.
    *   Informations sur le casting et recommandations de contenus similaires.

### 👤 Profil
*   **Infos Utilisateur :** Affiche le nom complet, l'email et l'avatar (supportant les photos de profil Google).
*   **Paramètres :** Accès rapide à la liste de suivi et aux préférences du compte.
*   **Déconnexion Sécurisée :** Fermeture de session avec une boîte de dialogue de confirmation.

## 🏗️ Architecture & Structure du Projet

L'application suit une **Architecture orientée fonctionnalités (Feature-First Architecture)**, s'inspirant des principes de la Clean Architecture pour assurer une séparation claire des préoccupations.

### 🧐 Qu'est-ce que la Feature-First Architecture ?
Contrairement à une approche par couches (Layer-First) où tout le code est regroupé par type technique (ex: tous les modèles ensemble, tous les écrans ensemble), l'approche **Feature-First** organise le code autour des fonctionnalités métier (ex: Authentification, Films, Séries TV).

Chaque dossier dans `features/` représente un module complet et indépendant. Ce module contient tout ce dont il a besoin pour fonctionner : sa logique de données, son domaine, sa gestion d'état et son interface utilisateur.

**Avantages :**
*   **Modularité :** Chaque fonctionnalité est isolée, facilitant les modifications sans impacter le reste.
*   **Scalabilité :** L'ajout d'une nouvelle fonctionnalité se fait simplement en créant un nouveau dossier dédié.
*   **Lisibilité :** Les développeurs peuvent localiser instantanément tout le code lié à un domaine spécifique.

### 📁 Arborescence du Projet (`lib/`)
```text
lib/
├── core/                 # Éléments partagés et configuration globale
│   ├── constants/        # Clés API, chaînes de caractères et constantes globales
│   ├── providers/        # Providers globaux (Dio, API client, etc.)
│   ├── supabase/         # Configuration et initialisation de Supabase
│   └── theme/            # Design System (Couleurs, thèmes Teal Moody, styles)
├── features/             # Fonctionnalités métier (Modules)
│   ├── auth/             # Module d'authentification (Google, Email/Password)
│   │   ├── data/         # Repositories et sources de données (Supabase)
│   │   ├── domain/       # Entités métier et contrats (interfaces)
│   │   ├── providers/    # Logique d'état avec Riverpod
│   │   └── screens/      # Écrans de l'interface utilisateur
│   ├── movies/           # Module de gestion des films (Discovery, Details)
│   │   ├── data/         # Implémentation TMDB et repositories
│   │   ├── domain/       # Modèles (Movie) et interfaces
│   │   ├── providers/    # Notifiers pour la liste des films et filtres
│   │   └── screens/      # Écrans Home, Movie Details, etc.
│   ├── tv/               # Module de gestion des séries TV
│   │   ├── data/
│   │   ├── domain/
│   │   ├── providers/
│   │   └── screens/
│   └── main_screen.dart  # Structure de navigation principale (Bottom Nav)
├── services/             # Services transversaux utilitaires (ex: AuthService)
├── main.dart             # Point d'entrée de l'application
└── router.dart           # Configuration de la navigation avec GoRouter
```

## 🛠️ Stack Technique
*   **Framework :** Flutter (Material 3)
*   **Gestion d'État :** Riverpod (patterns Notifier & AsyncNotifier)
*   **Navigation :** GoRouter
*   **Backend :** Supabase (Database & Auth)
*   **Networking :** Dio & API TMDB
*   **Environnement :** `flutter_dotenv` pour la gestion sécurisée des secrets.
*   **UI Components :** Google Fonts (Poppins), Cached Network Image, YouTube Player Flutter.

## 🤖 CI/CD & Automatisation (GitHub Workflows)

Le projet utilise **GitHub Actions** pour automatiser les builds et les releases via le workflow `.github/workflows/release.yml` :

### Workflow : Build & Release APK
*   **Déclencheurs :** S'exécute automatiquement lors d'un push sur la branche `main` ou par déclenchement manuel.
*   **Build Job :**
    *   Configure l'environnement Flutter et Java 17.
    *   Injecte les **GitHub Secrets** (clés Supabase, TMDB) dans un fichier `.env`.
    *   Décode et configure le Keystore Android pour signer l'APK.
    *   Génère un **APK de Release** optimisé.
*   **Release Job :**
    *   Crée automatiquement une **Release GitHub** taguée avec la version du projet.
    *   Attache l'APK généré pour un téléchargement facile.
    *   Génère des notes de version basées sur l'historique des commits.

## ⚙️ Configuration & Installation

1.  **Cloner le dépôt :**
    ```bash
    git clone https://github.com/votre_nom_utilisateur/cine_focus.git
    cd cine_focus
    ```

2.  **Variables d'Environnement :**
    Créez un fichier `.env` à la racine et ajoutez vos identifiants :
    ```env
    SUPABASE_URL=votre_url_supabase
    SUPABASE_ANON_KEY=votre_cle_anon_supabase
    TMDB_API_KEY=votre_cle_api_tmdb
    ```

3.  **Installer les dépendances :**
    ```bash
    flutter pub get
    ```

4.  **Lancer l'application :**
    ```bash
    flutter run
    ```

## 🎨 Identité Visuelle
L'application utilise un thème "Teal Moody".
*   **Couleurs :** Fonds sombres profonds (`0xFF080E11`) et accents Teal vibrants (`0xFF00F2CC`).
*   **Typographie :** Police Poppins pour un rendu propre et moderne.
