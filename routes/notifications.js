const express = require('express');
const router = express.Router();

// @route   GET /api/notifications
// @desc    Obtenir les notifications
// @access  Private
router.get('/', async (req, res) => {
  try {
    res.json({ message: 'Route notifications - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   PUT /api/notifications/:id/read
// @desc    Marquer une notification comme lue
// @access  Private
router.put('/:id/read', async (req, res) => {
  try {
    res.json({ message: 'Marquer notification comme lue - À implémenter' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

