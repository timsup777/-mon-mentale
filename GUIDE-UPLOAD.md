# 🚀 GUIDE : Mettre Votre Site en Ligne

## ✅ Ce qui est DÉJÀ FAIT

✅ Projet préparé pour le déploiement  
✅ Fichiers de configuration créés (.gitignore, render.yaml)  
✅ Git initialisé et premier commit créé  
✅ Serveur testé et fonctionnel en local  

---

## 📝 CE QU'IL VOUS RESTE À FAIRE (3 étapes simples)

### **ÉTAPE 1 : Finir MongoDB Atlas** ⏱️ 5 minutes

Retournez sur https://cloud.mongodb.com

**A. Créer un Utilisateur** (si pas déjà fait)
1. Menu gauche → **"Database Access"**
2. Cliquez **"Add New Database User"**
3. Username: `monmentale`
4. Password: Cliquez **"Autogenerate Secure Password"**
   - ⚠️ **COPIEZ CE MOT DE PASSE** quelque part !
5. Privileges: **"Atlas admin"**
6. Cliquez **"Add User"**

**B. Autoriser l'Accès Réseau**
1. Menu gauche → **"Network Access"**
2. Cliquez **"Add IP Address"**
3. Choisissez **"ALLOW ACCESS FROM ANYWHERE"**
4. IP: `0.0.0.0/0` (devrait se remplir automatiquement)
5. Cliquez **"Confirm"**

**C. Obtenir la Connexion String**
1. Menu gauche → **"Database"**
2. Sur votre Cluster0, cliquez **"Connect"**
3. Choisissez **"Drivers"**
4. Copiez la chaîne de connexion
5. Remplacez `<password>` par votre vrai mot de passe
6. Ajoutez `/mon-mentale` avant le `?`

**Exemple final:**
```
mongodb+srv://monmentale:VotreMotDePasse@cluster0.xxxxx.mongodb.net/mon-mentale?retryWrites=true&w=majority
```

⚠️ **GARDEZ CETTE CONNEXION STRING BIEN AU CHAUD !**

---

### **ÉTAPE 2 : Créer un Dépôt GitHub** ⏱️ 3 minutes

**A. Créer un compte GitHub** (si vous n'en avez pas)
→ Allez sur https://github.com
→ Cliquez "Sign up" et suivez les étapes

**B. Créer un nouveau dépôt**
1. Une fois connecté, cliquez sur **"+"** en haut à droite
2. Choisissez **"New repository"**
3. Repository name: `mon-mentale-backend`
4. Description: `Backend API pour Mon Mentale`
5. Visibilité: **Public** (nécessaire pour le free tier de Render)
6. **NE COCHEZ PAS** "Initialize with README"
7. Cliquez **"Create repository"**

**C. Pousser votre code**

GitHub va vous montrer des instructions. Copiez-les et exécutez dans votre Terminal :

```bash
cd /Users/timotheeberthelot/Desktop/MM3-1

git remote add origin https://github.com/VOTRE_USERNAME/mon-mentale-backend.git
git branch -M main
git push -u origin main
```

(Remplacez `VOTRE_USERNAME` par votre vrai username GitHub)

Si on vous demande vos identifiants :
- Username: votre username GitHub
- Password: utilisez un **Personal Access Token** (pas votre mot de passe)
  - Créez-le sur GitHub → Settings → Developer settings → Personal access tokens

---

### **ÉTAPE 3 : Déployer sur Render** ⏱️ 5 minutes

**A. Créer un compte Render**
→ Allez sur https://render.com
→ Cliquez **"Get Started"**
→ Inscrivez-vous avec **GitHub** (le plus simple)

**B. Créer un Web Service**
1. Dans le Dashboard Render, cliquez **"New +"** → **"Web Service"**
2. Connectez votre dépôt GitHub `mon-mentale-backend`
3. Cliquez **"Connect"**

**C. Configurer le Service**

Remplissez les champs :
- **Name**: `mon-mentale-api`
- **Region**: `Frankfurt (EU Central)` ou le plus proche
- **Branch**: `main`
- **Root Directory**: (laisser vide)
- **Environment**: `Node`
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Instance Type**: `Free`

**D. Ajouter les Variables d'Environnement**

Cliquez sur **"Advanced"** puis scrollez jusqu'à **"Environment Variables"**

Ajoutez ces variables une par une (cliquez "Add Environment Variable" à chaque fois):

```
Clé: NODE_ENV          Valeur: production
Clé: PORT              Valeur: 10000
Clé: JWT_SECRET        Valeur: (créez un secret fort, ex: Mon_Secret_Super_Securise_Production_2024_12345)
Clé: JWT_EXPIRE        Valeur: 7d
Clé: MONGODB_URI       Valeur: (collez votre connexion string MongoDB Atlas complète)
```

⚠️ **La plus importante** : `MONGODB_URI` - collez votre connexion string MongoDB !

**E. Déployer !**

1. Cliquez **"Create Web Service"**
2. Render va :
   - Cloner votre dépôt GitHub
   - Installer les dépendances
   - Démarrer le serveur
3. ⏱️ Attendez 2-3 minutes

**F. Récupérer votre URL**

Une fois le déploiement terminé, Render vous donne une URL :
```
https://mon-mentale-api.onrender.com
```

---

## 🎉 TESTER VOTRE SITE EN LIGNE

Une fois déployé, testez :

```bash
curl https://mon-mentale-api.onrender.com/api/test
```

Résultat attendu :
```json
{"message":"Mon Mentale API fonctionne ! 🧠"}
```

**🎊 FÉLICITATIONS ! Votre API est en ligne sur internet ! 🌍**

---

## 📱 Mettre à Jour l'App iOS

Dans votre code iOS, remplacez l'URL locale par votre nouvelle URL :

```swift
// Ancienne URL locale
let apiURL = "http://localhost:3000/api"

// Nouvelle URL de production
let apiURL = "https://mon-mentale-api.onrender.com/api"
```

---

## 🔄 Mettre à Jour Votre Site

Pour mettre à jour après des modifications :

```bash
cd /Users/timotheeberthelot/Desktop/MM3-1

git add .
git commit -m "Description de vos modifications"
git push origin main
```

Render redéploiera automatiquement ! ✨

---

## ⚠️ IMPORTANT : Limitations du Plan Gratuit

- Le serveur s'endort après **15 minutes** d'inactivité
- La première requête après le sommeil peut prendre **30 secondes**
- Parfait pour tester et développer
- Pour la production : passez au plan payant ($7/mois)

---

## 🆘 Besoin d'Aide ?

**Problème de connexion MongoDB ?**
→ Vérifiez Network Access = 0.0.0.0/0
→ Vérifiez que le mot de passe dans la connexion string est correct

**Déploiement échoue ?**
→ Vérifiez les logs sur Render Dashboard
→ Vérifiez que toutes les variables d'env sont bien remplies

**API répond 404 ?**
→ Attendez que le déploiement soit terminé
→ Vérifiez l'URL (doit inclure /api/)

---

## ✅ CHECKLIST COMPLÈTE

- [ ] MongoDB Atlas : Utilisateur créé
- [ ] MongoDB Atlas : Network Access configuré (0.0.0.0/0)
- [ ] MongoDB Atlas : Connexion string récupérée
- [ ] GitHub : Compte créé
- [ ] GitHub : Dépôt `mon-mentale-backend` créé
- [ ] GitHub : Code poussé sur GitHub
- [ ] Render : Compte créé (avec GitHub)
- [ ] Render : Web Service créé
- [ ] Render : Variables d'environnement configurées
- [ ] Render : Déploiement réussi
- [ ] Test : API accessible publiquement
- [ ] Bonus : URL mise à jour dans l'app iOS

---

**🚀 Bon déploiement ! N'hésitez pas si vous avez besoin d'aide !**

*Guide créé le 1 novembre 2025*

