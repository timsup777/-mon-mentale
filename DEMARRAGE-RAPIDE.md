# 🚀 Démarrage Rapide - Mon Mentale

## ✅ Le Serveur Fonctionne !

Votre serveur backend **Mon Mentale** est maintenant **opérationnel** ! 🎉

### 📍 Informations du Serveur

- **URL du serveur** : http://localhost:3000
- **URL de l'API** : http://localhost:3000/api
- **Port** : 3000
- **Statut** : ✅ En ligne

### 🧪 Test Rapide

```bash
# Tester que l'API répond
curl http://localhost:3000/api/test

# Résultat attendu :
# {"message":"Mon Mentale API fonctionne ! 🧠"}
```

## 🎯 Commandes Utiles

### Démarrer le Serveur

```bash
cd /Users/timotheeberthelot/Desktop/MM3-1
npm start
```

### Démarrer en Mode Développement (avec auto-reload)

```bash
npm run dev
```

### Arrêter le Serveur

```bash
# Trouver le processus
lsof -i :3000

# Tuer le processus (remplacer PID par le numéro affiché)
kill -9 PID
```

## 📡 Routes API Disponibles

### ✅ Routes Fonctionnelles (sans base de données)

- `GET /api/test` - Test de l'API ✅

### ⚠️ Routes Nécessitant MongoDB

Ces routes retourneront des erreurs jusqu'à ce que MongoDB soit configuré :

- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/practitioners` - Liste des praticiens
- `GET /api/appointments` - Rendez-vous
- `POST /api/payments/create-intent` - Paiements

## 🗄️ Configuration de MongoDB (Optionnel)

Pour activer toutes les fonctionnalités, vous devrez configurer MongoDB :

### Option 1 : MongoDB Local

```bash
# Installer MongoDB
brew tap mongodb/brew
brew install mongodb-community@7.0
brew services start mongodb-community@7.0

# Dans config.env, décommentez :
# MONGODB_URI=mongodb://localhost:27017/mon-mentale
```

### Option 2 : MongoDB Atlas (Cloud - Gratuit)

1. Créez un compte sur https://www.mongodb.com/cloud/atlas
2. Créez un cluster gratuit (M0)
3. Créez un utilisateur de base de données
4. Autorisez l'accès réseau (0.0.0.0/0)
5. Obtenez votre connexion string
6. Dans `config.env`, décommentez et configurez :
   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/mon-mentale
   ```
7. Redémarrez le serveur

## 🔧 Configuration Actuelle

### Fichier `config.env`

```env
# Base de données : Actuellement SANS MongoDB
# Le serveur fonctionne en mode limité

# JWT
JWT_SECRET=mon_secret_jwt_super_securise_changez_moi_en_production_123456
JWT_EXPIRE=7d

# Serveur
PORT=3000
NODE_ENV=development
```

## 📱 Application iOS

L'application iOS se trouve dans le dossier `iOS/MonMentale/`

Pour la développer :

```bash
cd iOS
open MonMentale.xcodeproj
```

Ou ouvrez directement avec Xcode.

## 🐛 Problèmes Courants

### Le port 3000 est déjà utilisé

```bash
# Trouver le processus
lsof -i :3000

# Le tuer
kill -9 PID

# Ou changer le PORT dans config.env
```

### Erreurs "Erreur serveur"

→ Normal si MongoDB n'est pas configuré. Les routes qui nécessitent la base de données retourneront cette erreur.

### Module non trouvé

```bash
# Réinstaller les dépendances
npm install
```

## 📊 Statut des Fonctionnalités

| Fonctionnalité | Statut |
|----------------|--------|
| ✅ Serveur backend | Opérationnel |
| ✅ Routes API | Créées |
| ✅ Modèles de données | Définis |
| ✅ Sécurité (Helmet, CORS) | Activée |
| ✅ Rate limiting | Activé |
| ⚠️ Base de données MongoDB | À configurer |
| ⚠️ Authentification JWT | Nécessite MongoDB |
| ⚠️ Paiements Stripe | À configurer |
| ⚠️ Emails | À configurer |

## 🎯 Prochaines Étapes

Pour un projet fonctionnel complet :

1. **Configurer MongoDB** (Atlas ou local)
2. **Tester l'inscription/connexion**
3. **Créer des données de test** (praticiens, patients)
4. **Configurer Stripe** pour les paiements
5. **Développer l'application iOS**
6. **Déployer en production**

## 📚 Documentation

- `README.md` - Documentation complète du projet
- `INSTALLATION.md` - Guide d'installation détaillé
- `package.json` - Dépendances et scripts

## 🆘 Support

Le serveur est maintenant **prêt à l'emploi** !

Pour toute question :
- Consultez la documentation
- Vérifiez les logs du serveur
- Testez avec `curl` ou Postman

---

**Bon développement ! 🧠💙**

*Dernière mise à jour : Samedi 1 novembre 2025*

