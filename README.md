# 🧠 Mon Mentale - Plateforme de Santé Mentale

**Mon Mentale** est une application mobile iOS de prise de rendez-vous pour psychologues et psychiatres, inspirée du design et de l'expérience utilisateur de Doctolib, mais spécialement adaptée à la santé mentale.

## 📱 Description

Application complète permettant de connecter les patients avec des professionnels de santé mentale qualifiés (psychologues et psychiatres) via une plateforme moderne, sécurisée et intuitive.

## ✨ Fonctionnalités Principales

### Pour les Patients
- 🔍 Recherche de praticiens par spécialité, localisation, langues
- 📅 Prise de rendez-vous en ligne (présentiel, téléconsultation, domicile)
- 😊 Journal d'humeur quotidien et suivi du bien-être mental
- 💳 Paiement sécurisé des consultations (Stripe)
- 💬 Messagerie avec les praticiens
- 📄 Stockage sécurisé des documents médicaux
- ⭐ Système d'évaluation et d'avis
- 🔔 Notifications et rappels de rendez-vous

### Pour les Praticiens (Psychologues/Psychiatres)
- 👤 Profil professionnel détaillé
- 📋 Gestion des spécialisations et approches thérapeutiques
- 🗓️ Gestion des disponibilités et créneaux
- 💰 Configuration des tarifs (consultation, téléconsultation, domicile)
- ✅ Système de vérification des diplômes et licences
- 📊 Statistiques et tableau de bord
- 💬 Communication avec les patients

## 🏗️ Architecture Technique

### Backend (API REST)
- **Framework**: Node.js + Express.js
- **Base de données**: MongoDB + Mongoose
- **Authentification**: JWT (JSON Web Tokens)
- **Sécurité**: Helmet, CORS, Rate Limiting, Bcrypt
- **Paiements**: Stripe
- **Email**: Nodemailer
- **Temps réel**: Socket.io

### Frontend iOS
- **Framework**: SwiftUI (natif iOS)
- **Architecture**: MVVM (Model-View-ViewModel)
- **Design**: Interface moderne avec palette pastel apaisante
- **Localisation**: Support multilingue (Français, Allemand, Italien)
- **État**: Combine + ObservableObject

## 🚀 Installation et Démarrage

### Prérequis
- Node.js v18+ (actuellement v22.14.0)
- npm v10+ (actuellement v10.9.2)
- Compte MongoDB Atlas (gratuit)
- Xcode 14+ (pour l'app iOS)

### Installation Backend

```bash
# 1. Installer les dépendances
npm install

# 2. Configurer MongoDB Atlas
# - Créez un compte sur https://www.mongodb.com/cloud/atlas
# - Créez un cluster gratuit
# - Obtenez votre connexion string
# - Mettez à jour MONGODB_URI dans config.env

# 3. Démarrer le serveur
npm start

# Ou en mode développement (avec auto-reload)
npm run dev
```

Le serveur démarrera sur **http://localhost:5000**

### Test de l'API

```bash
curl http://localhost:5000/api/test
# Résultat: {"message":"Mon Mentale API fonctionne ! 🧠"}
```

### Installation iOS

```bash
# Ouvrir le projet iOS
open iOS/MonMentale.xcodeproj

# Ou avec Xcode
cd iOS && xcodebuild -project MonMentale.xcodeproj -scheme MonMentale
```

## 📚 Documentation API

### Routes Authentification
- `POST /api/auth/register` - Inscription (patient/praticien)
- `POST /api/auth/login` - Connexion
- `GET /api/auth/me` - Profil utilisateur connecté

### Routes Praticiens
- `GET /api/practitioners` - Liste des praticiens (avec filtres)
- `GET /api/practitioners/:id` - Détails d'un praticien
- `POST /api/practitioners` - Créer un profil praticien
- `PUT /api/practitioners/:id` - Mettre à jour un profil
- `GET /api/practitioners/search/nearby` - Recherche géolocalisée

### Routes Rendez-vous
- `GET /api/appointments` - Liste des rendez-vous
- `GET /api/appointments/:id` - Détails d'un rendez-vous
- `POST /api/appointments` - Créer un rendez-vous
- `PUT /api/appointments/:id` - Modifier un rendez-vous
- `DELETE /api/appointments/:id` - Annuler un rendez-vous

### Routes Paiements
- `POST /api/payments/create-intent` - Créer une intention de paiement Stripe
- `POST /api/payments/webhook` - Webhook Stripe
- `GET /api/payments/:id` - Détails d'un paiement

### Autres Routes
- `/api/patients` - Gestion des profils patients
- `/api/messages` - Messagerie
- `/api/reviews` - Avis et évaluations
- `/api/documents` - Documents médicaux
- `/api/notifications` - Notifications push

## 🗄️ Modèles de Données

### User (Utilisateur)
- Email, mot de passe hashé, rôle (patient/psychologue/psychiatre/admin)
- Profil (prénom, nom, téléphone, date de naissance, avatar)
- Vérification et statut actif

### Practitioner (Praticien)
- Référence utilisateur
- Spécialisations (psychologie clinique, cognitive, comportementale, etc.)
- Informations professionnelles (licence, université, expérience, langues)
- Cabinet (adresse, coordonnées GPS, types de consultation)
- Disponibilités par jour de la semaine
- Tarifs (consultation, téléconsultation, domicile)
- Vérification des documents
- Statistiques (rendez-vous, patients, note moyenne)

### Appointment (Rendez-vous)
- Patient et praticien
- Date et heure
- Type (présentiel/téléconsultation/domicile)
- Statut (en attente/confirmé/terminé/annulé)
- Notes et raison de consultation

### Payment (Paiement)
- Montant, devise, méthode
- Statut (en attente/réussi/échoué/remboursé)
- Référence Stripe
- Lien vers le rendez-vous

## 🎨 Design & UX

### Palette de Couleurs (Pastel)
- **Bleu principal**: Calme et confiance (#7BA3D1)
- **Rose secondaire**: Douceur et empathie (#F4C2C2)
- **Violet accent**: Créativité et intuition (#B19CD9)
- **Vert complémentaire**: Équilibre et croissance (#A8D5BA)
- **Beige neutre**: Chaleur et stabilité (#F5E6D3)

### Inspiration Design
- Interface inspirée de Doctolib
- Adaptée spécifiquement pour la santé mentale
- Couleurs apaisantes et rassurantes
- Expérience utilisateur fluide et intuitive

## 🔐 Sécurité

- ✅ Mots de passe hashés avec Bcrypt
- ✅ Authentification JWT sécurisée
- ✅ Rate limiting pour prévenir les abus
- ✅ Headers sécurisés avec Helmet
- ✅ Validation des données avec Express Validator
- ✅ CORS configuré
- ✅ Variables d'environnement pour les secrets

## 📦 Structure du Projet

```
MM3-1/
├── config/               # Configuration base de données
├── iOS/                  # Application iOS Swift
│   └── MonMentale/      # Code source iOS
│       ├── Design/      # Couleurs, composants, typographie
│       ├── Views/       # Vues SwiftUI
│       ├── ViewModels/  # ViewModels MVVM
│       ├── Models/      # Modèles de données
│       ├── Utils/       # Utilitaires
│       └── Localizations/ # Traductions
├── models/              # Modèles Mongoose (User, Practitioner, etc.)
├── routes/              # Routes API Express
├── services/            # Services (Stripe, Email, etc.)
├── config.env           # Variables d'environnement
├── server.js            # Point d'entrée du serveur
├── package.json         # Dépendances Node.js
├── INSTALLATION.md      # Guide d'installation détaillé
└── README.md           # Ce fichier

```

## 🌍 Localisation

Support multilingue intégré :
- 🇫🇷 Français
- 🇩🇪 Allemand
- 🇮🇹 Italien

## 📝 Variables d'Environnement

Voir `config.env` pour la configuration :

```env
# Base de données
MONGODB_URI=mongodb+srv://...

# JWT
JWT_SECRET=votre_secret
JWT_EXPIRE=7d

# Serveur
PORT=5000
NODE_ENV=development

# Stripe (optionnel)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...

# Email (optionnel)
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=...
EMAIL_PASS=...
```

## 🚧 Statut du Projet

- ✅ Backend API fonctionnel
- ✅ Modèles de données complets
- ✅ Authentification JWT
- ✅ Routes principales implémentées
- ✅ Application iOS (design et structure)
- ⚠️ MongoDB à configurer (Atlas recommandé)
- ⚠️ Intégration Stripe à finaliser
- ⚠️ Système de messagerie à compléter
- ⚠️ Tests unitaires à ajouter

## 📞 Support

Pour toute question ou problème :
1. Consultez `INSTALLATION.md` pour l'installation
2. Vérifiez que MongoDB est correctement configuré
3. Vérifiez que toutes les dépendances sont installées

## 📄 Licence

MIT License - Mon Mentale Team

## 🎯 Roadmap

- [ ] Ajouter les tests unitaires et d'intégration
- [ ] Implémenter la messagerie temps réel (Socket.io)
- [ ] Finaliser l'intégration Stripe
- [ ] Ajouter la gestion des documents (upload/download)
- [ ] Implémenter les notifications push
- [ ] Ajouter l'envoi d'emails automatiques
- [ ] Créer un tableau de bord admin
- [ ] Déployer en production (backend + MongoDB)
- [ ] Publier sur l'App Store

---

Développé avec 💙 pour la santé mentale

