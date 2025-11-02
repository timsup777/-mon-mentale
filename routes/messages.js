const express = require('express');
const router = express.Router();

// @route   GET /api/messages
// @desc    Obtenir les messages
// @access  Private
router.get('/', async (req, res) => {
  try {
    res.json({ message: 'Route messages - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   POST /api/messages
// @desc    Envoyer un message
// @access  Private
router.post('/', async (req, res) => {
  try {
    res.json({ message: 'Envoi de message - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

