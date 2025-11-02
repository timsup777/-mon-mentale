const express = require('express');
const router = express.Router();

// @route   GET /api/reviews
// @desc    Obtenir les avis
// @access  Public
router.get('/', async (req, res) => {
  try {
    res.json({ message: 'Route avis - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   POST /api/reviews
// @desc    Créer un avis
// @access  Private
router.post('/', async (req, res) => {
  try {
    res.json({ message: 'Création d\'avis - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

