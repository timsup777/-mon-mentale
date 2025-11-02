const express = require('express');
const router = express.Router();

// @route   GET /api/documents
// @desc    Obtenir les documents
// @access  Private
router.get('/', async (req, res) => {
  try {
    res.json({ message: 'Route documents - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   POST /api/documents
// @desc    Upload un document
// @access  Private
router.post('/', async (req, res) => {
  try {
    res.json({ message: 'Upload de document - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

