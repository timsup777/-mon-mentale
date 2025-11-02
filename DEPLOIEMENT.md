# 🌐 Guide de Déploiement - Mon Mentale

## 🚀 Déployer sur Render (Gratuit)

### Étape 1 : Préparer MongoDB Atlas

Avant de déployer, vous **devez** configurer MongoDB Atlas :

1. **Créer un compte MongoDB Atlas**
   - Allez sur https://www.mongodb.com/cloud/atlas
   - Créez un compte gratuit

2. **Créer un cluster**
   - Cliquez sur "Build a Database"
   - Choisissez "M0 FREE"
   - Sélectionnez une région (ex: Frankfurt)
   - Créez le cluster

3. **Créer un utilisateur**
   - Allez dans "Database Access"
   - Créez un utilisateur avec username et password
   - Notez bien ces identifiants !

4. **Autoriser tous les accès réseau**
   - Allez dans "Network Access"
   - Cliquez "Add IP Address"
   - Choisissez "Allow Access from Anywhere" (0.0.0.0/0)
   - Important pour que Render puisse se connecter

5. **Obtenir la connexion string**
   - Cliquez sur "Connect" sur votre cluster
   - Choisissez "Drivers"
   - Copiez la connexion string
   - Exemple : `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/mon-mentale?retryWrites=true&w=majority`

### Étape 2 : Créer un Dépôt GitHub

1. **Créer un compte GitHub** (si vous n'en avez pas)
   - Allez sur https://github.com
   - Créez un compte gratuit

2. **Créer un nouveau dépôt**
   - Cliquez sur "New repository"
   - Nom : `mon-mentale-backend`
   - Visibilité : Public (pour le free tier de Render)
   - Ne pas initialiser avec README (on a déjà les fichiers)

3. **Pousser le code sur GitHub**
   ```bash
   cd /Users/timotheeberthelot/Desktop/MM3-1
   
   # Initialiser Git
   git init
   
   # Ajouter tous les fichiers
   git add .
   
   # Premier commit
   git commit -m "Initial commit - Mon Mentale Backend"
   
   # Ajouter le dépôt distant (remplacer USERNAME par votre username GitHub)
   git remote add origin https://github.com/USERNAME/mon-mentale-backend.git
   
   # Pousser le code
   git branch -M main
   git push -u origin main
   ```

### Étape 3 : Déployer sur Render

1. **Créer un compte Render**
   - Allez sur https://render.com
   - Inscrivez-vous gratuitement
   - Connectez votre compte GitHub

2. **Créer un nouveau Web Service**
   - Dashboard → "New" → "Web Service"
   - Connectez votre dépôt GitHub `mon-mentale-backend`
   - Cliquez "Connect"

3. **Configurer le service**
   - **Name** : `mon-mentale-api`
   - **Region** : Europe (Frankfurt) ou le plus proche
   - **Branch** : `main`
   - **Root Directory** : (laisser vide)
   - **Environment** : `Node`
   - **Build Command** : `npm install`
   - **Start Command** : `npm start`
   - **Plan** : Free

4. **Ajouter les variables d'environnement**
   
   Cliquez sur "Advanced" puis "Add Environment Variable" :
   
   ```
   NODE_ENV = production
   PORT = 10000
   MONGODB_URI = mongodb+srv://votre_user:votre_password@cluster.mongodb.net/mon-mentale?retryWrites=true&w=majority
   JWT_SECRET = changez_moi_secret_tres_securise_production_12345678
   JWT_EXPIRE = 7d
   ```
   
   ⚠️ **Important** :
   - Remplacez `MONGODB_URI` par votre vraie connexion string
   - Créez un nouveau `JWT_SECRET` sécurisé pour la production

5. **Déployer**
   - Cliquez sur "Create Web Service"
   - Render va automatiquement :
     - Cloner votre dépôt
     - Installer les dépendances
     - Démarrer le serveur
   - Le déploiement prend environ 2-3 minutes

### Étape 4 : Tester Votre API en Ligne

Une fois le déploiement terminé, Render vous donnera une URL :

```
https://mon-mentale-api.onrender.com
```

**Tester l'API :**

```bash
curl https://mon-mentale-api.onrender.com/api/test
```

Résultat attendu :
```json
{"message":"Mon Mentale API fonctionne ! 🧠"}
```

## 🎯 Votre API est en Ligne !

### URLs de Production

- **API Base URL** : `https://mon-mentale-api.onrender.com`
- **Test Endpoint** : `https://mon-mentale-api.onrender.com/api/test`
- **Auth** : `https://mon-mentale-api.onrender.com/api/auth`
- **Practitioners** : `https://mon-mentale-api.onrender.com/api/practitioners`

### Mettre à Jour l'App iOS

Dans votre app iOS, remplacez l'URL locale par l'URL de production :

```swift
// Au lieu de
let apiURL = "http://localhost:3000/api"

// Utilisez
let apiURL = "https://mon-mentale-api.onrender.com/api"
```

## 🔄 Mettre à Jour le Site

Pour mettre à jour votre site après des modifications :

```bash
cd /Users/timotheeberthelot/Desktop/MM3-1

# Ajouter les modifications
git add .

# Créer un commit
git commit -m "Description de vos modifications"

# Pousser sur GitHub
git push origin main
```

Render détectera automatiquement les changements et redéploiera !

## ⚠️ Limitations du Plan Gratuit

- Le serveur s'endort après 15 minutes d'inactivité
- Première requête après inactivité peut prendre 30 secondes
- Suffisant pour un projet de test/développement
- Pour la production intensive, passez au plan payant ($7/mois)

## 🔐 Sécurité Production

**Important pour la production :**

1. ✅ Utilisez des secrets forts et uniques
2. ✅ Ne commitez JAMAIS config.env ou .env
3. ✅ Configurez CORS pour autoriser uniquement votre app
4. ✅ Activez HTTPS (automatique sur Render)
5. ✅ Limitez l'accès réseau MongoDB aux IPs de Render
6. ✅ Surveillez les logs sur Render Dashboard

## 📊 Alternatives à Render

Si vous préférez autre chose :

### Railway
- https://railway.app
- Très similaire à Render
- Free tier : 500h/mois

### Fly.io
- https://fly.io
- Un peu plus technique
- Free tier : 3 VMs

### Vercel (pour API Node.js)
- https://vercel.com
- Très rapide
- Idéal pour API serverless

## 🆘 Problèmes Courants

### Déploiement échoue
→ Vérifiez les logs sur Render Dashboard
→ Vérifiez que package.json est correct
→ Vérifiez que toutes les variables d'env sont configurées

### Cannot connect to MongoDB
→ Vérifiez que Network Access est sur 0.0.0.0/0
→ Vérifiez que la connexion string est correcte
→ Vérifiez que le username/password sont bons

### API répond 404
→ Vérifiez l'URL (doit inclure /api/)
→ Attendez que le déploiement soit terminé

## ✅ Checklist Avant Déploiement

- [ ] MongoDB Atlas configuré
- [ ] Utilisateur de BDD créé
- [ ] Network Access = 0.0.0.0/0
- [ ] Connexion string récupérée
- [ ] Compte GitHub créé
- [ ] Dépôt GitHub créé et code poussé
- [ ] Compte Render créé
- [ ] Variables d'environnement configurées sur Render
- [ ] Déploiement lancé
- [ ] API testée avec curl

---

**Bon déploiement ! 🚀🌍**

