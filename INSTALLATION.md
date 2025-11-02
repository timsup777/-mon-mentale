# 🚀 Guide d'Installation - Mon Mentale Backend

## Prérequis

- ✅ Node.js v18+ (installé : v22.14.0)
- ✅ npm v10+ (installé : v10.9.2)
- ⚠️ MongoDB (à configurer)

## Étape 1 : Installation des Dépendances

```bash
cd /Users/timotheeberthelot/Desktop/MM3-1
npm install
```

✅ **Fait !**

## Étape 2 : Configuration de MongoDB

### Option A : MongoDB Atlas (Recommandé - Gratuit)

1. **Créer un compte MongoDB Atlas**
   - Allez sur https://www.mongodb.com/cloud/atlas
   - Créez un compte gratuit
   
2. **Créer un cluster gratuit**
   - Cliquez sur "Build a Database"
   - Choisissez "FREE" (M0 Sandbox)
   - Sélectionnez une région proche (ex: Frankfurt)
   - Créez le cluster

3. **Configurer l'accès**
   - Créez un utilisateur de base de données (username/password)
   - Ajoutez votre IP à la whitelist (ou 0.0.0.0/0 pour tout autoriser en dev)

4. **Obtenir la connexion string**
   - Cliquez sur "Connect"
   - Choisissez "Connect your application"
   - Copiez la connexion string
   - Exemple : `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/`

5. **Mettre à jour config.env**
   - Ouvrez `config.env`
   - Remplacez `MONGODB_URI` par votre connexion string
   - Ajoutez `/mon-mentale` à la fin de l'URL

### Option B : MongoDB Local

Si vous préférez installer MongoDB localement :

```bash
# macOS
brew tap mongodb/brew
brew install mongodb-community@7.0
brew services start mongodb-community@7.0

# Puis dans config.env, utilisez :
MONGODB_URI=mongodb://localhost:27017/mon-mentale
```

## Étape 3 : Vérifier la Configuration

Le fichier `config.env` doit contenir :

```env
MONGODB_URI=mongodb+srv://votre_user:votre_password@cluster.mongodb.net/mon-mentale
JWT_SECRET=mon_secret_jwt_super_securise
PORT=5000
NODE_ENV=development
```

## Étape 4 : Démarrer le Serveur

```bash
# Mode développement (avec auto-reload)
npm run dev

# Ou mode normal
npm start
```

Le serveur devrait démarrer sur : **http://localhost:5000**

## Étape 5 : Tester l'API

```bash
# Test de base
curl http://localhost:5000/api/test

# Résultat attendu :
# {"message":"Mon Mentale API fonctionne ! 🧠"}
```

## 🎯 Routes API Disponibles

- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/me` - Profil utilisateur
- `GET /api/practitioners` - Liste des praticiens
- `GET /api/appointments` - Rendez-vous
- `POST /api/payments/create-intent` - Créer un paiement

## ⚠️ Problèmes Courants

### Erreur : "Cannot find module 'express'"
→ Exécutez `npm install`

### Erreur de connexion MongoDB
→ Vérifiez que votre IP est autorisée dans MongoDB Atlas
→ Vérifiez que le username/password sont corrects dans MONGODB_URI

### Port 5000 déjà utilisé
→ Changez le PORT dans config.env

## 📱 Application iOS

L'application iOS se trouve dans le dossier `iOS/MonMentale/`

Pour la développer, ouvrez `iOS/MonMentale.xcodeproj` avec Xcode.

## 🔐 Sécurité

**Important pour la production :**
- Changez le `JWT_SECRET` en production
- N'exposez jamais vos clés API
- Utilisez des variables d'environnement sécurisées
- Activez HTTPS

## 📚 Documentation

- Backend API : Node.js + Express + MongoDB
- Base de données : MongoDB (Mongoose ORM)
- Authentification : JWT (JSON Web Tokens)
- Paiements : Stripe
- Frontend iOS : SwiftUI

Bon développement ! 🧠💙

