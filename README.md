# CineFocus

CineFocus est une application Flutter moderne et performante, conçue pour les passionnés de cinéma afin de découvrir des films et des séries TV. Elle arbore un design "Teal Moody" élégant avec des éléments d'interface lumineux et une intégration backend robuste via Supabase.

## 🚀 Fonctionnalités

### 🔐 Authentification
*   **Email & Mot de passe :** Flux d'inscription et de connexion traditionnel.
*   **Connexion Google :** Authentification simplifiée en un clic avec les comptes Google.
*   **Gestion sécurisée des sessions :** États de connexion persistants gérés via Supabase Auth.

### 🎬 Films & Séries TV
*   **Découverte :** Parcourez les contenus populaires, les mieux notés et les nouveautés.
*   **Recherche avancée :** Recherche en temps réel avec système de "debouncing".
*   **Catégorisation :** Filtrez par genres (Action, Comédie, Sci-Fi, etc.) ou listes spécifiques (Diffusés aujourd'hui, À l'antenne).
*   **Vues détaillées :** 
    *   Arrière-plans et affiches dynamiques.
    *   Classifications d'âge et certifications.
    *   Synopsis et dates de sortie.
    *   Lecteur de **bandes-annonces YouTube** intégré.
    *   Informations sur le casting et recommandations de contenus similaires.

### 👤 Profil
*   **Informations utilisateur :** Affichage du nom complet, de l'email et de l'avatar (gestion des photos de profil Google).
*   **Paramètres :** Accès rapide à la liste de suivi et aux préférences du compte.
*   **Déconnexion :** Fermeture de session sécurisée avec dialogue de confirmation.

## 🏗️ Architecture

Le projet suit une **Architecture orientée fonctionnalités (Feature-First Architecture)**, garantissant modularité, évolutivité et facilité de maintenance.

### Structure des dossiers
*   `lib/core/` : Constantes globales, thèmes et configuration du client Supabase.
*   `lib/features/` : Logique métier divisée par modules fonctionnels :
    *   `auth/` : Providers, écrans et services liés à l'authentification.
    *   `movies/` : Logique de récupération, d'affichage et de filtrage des films.
    *   `tv/` : Découverte et recherche de séries TV.
*   `lib/services/` : Implémentations de services génériques (ex: `AuthService`).
*   `lib/router.dart` : Configuration centralisée de la navigation avec GoRouter.

### 🛠️ Stack Technique
*   **Framework :** Flutter (Material 3)
*   **Gestion d'état :** Riverpod (utilisation des patterns modernes `Notifier` et `AsyncNotifier`)
*   **Navigation :** GoRouter
*   **Backend :** Supabase (Base de données & Auth)
*   **Networking :** Dio
*   **Source de données :** API TMDB
*   **Environnement :** `flutter_dotenv` pour la gestion sécurisée des clés API.
*   **Composants UI :** Google Fonts, Cached Network Image, Flutter SVG, YouTube Player Flutter.

## ⚙️ Configuration & Installation

1.  **Cloner le dépôt :**
    ```bash
    git clone https://github.com/votre_nom_utilisateur/cine_focus.git
    cd cine_focus
    ```

2.  **Variables d'environnement :**
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

4.  **Générer les icônes de lancement :**
    ```bash
    dart run flutter_launcher_icons
    ```

5.  **Lancer l'application :**
    ```bash
    flutter run
    ```

## 🎨 Charte Graphique
L'application utilise un thème personnalisé appelé "Teal Moody". 
*   **Couleurs :** Fonds sombres profonds (`0xFF080E11`) avec un Teal primaire vibrant (`0xFF00F2CC`).
*   **Visuels :** Gradients radiaux, ombres lumineuses et coins arrondis (32px pour les cartes, 16px pour les boutons).
*   **Typographie :** Police Poppins via Google Fonts pour un rendu moderne et épuré.
