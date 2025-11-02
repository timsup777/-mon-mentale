const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config({ path: './config.env' });

const app = express();

// Middleware de sécurité
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limite chaque IP à 100 requêtes par windowMs
});
app.use('/api/', limiter);

// Connexion à MongoDB (optionnelle pour le démarrage)
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/mon-mentale';

if (MONGODB_URI && MONGODB_URI !== 'mongodb://localhost:27017/mon-mentale') {
  // Si une URI MongoDB est configurée, on tente la connexion
  mongoose.connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('✅ Connexion à MongoDB réussie'))
  .catch(err => {
    console.warn('⚠️  MongoDB non disponible, le serveur continue sans base de données');
    console.warn('   Pour activer MongoDB, installez-le ou configurez MongoDB Atlas');
  });
} else {
  console.log('ℹ️  Mode sans base de données - Pour activer MongoDB:');
  console.log('   Option 1: Installez MongoDB localement');
  console.log('   Option 2: Configurez MongoDB Atlas dans config.env');
}

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/practitioners', require('./routes/practitioners'));
app.use('/api/patients', require('./routes/patients'));
app.use('/api/appointments', require('./routes/appointments'));
app.use('/api/messages', require('./routes/messages'));
app.use('/api/payments', require('./routes/payments'));
app.use('/api/reviews', require('./routes/reviews'));
app.use('/api/documents', require('./routes/documents'));
app.use('/api/notifications', require('./routes/notifications'));

// Route de test
app.get('/api/test', (req, res) => {
  res.json({ message: 'Mon Mentale API fonctionne ! 🧠' });
});

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Erreur serveur interne' });
});

// Route 404
app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route non trouvée' });
});

const PORT = process.env.PORT || 3000;
const HOST = process.env.NODE_ENV === 'production' ? '0.0.0.0' : 'localhost';

app.listen(PORT, HOST, () => {
  console.log(`🚀 Serveur Mon Mentale démarré sur ${HOST}:${PORT}`);
  console.log(`📍 Environnement: ${process.env.NODE_ENV || 'development'}`);
  if (process.env.NODE_ENV === 'production') {
    console.log('🌍 Serveur accessible publiquement');
  }
});

