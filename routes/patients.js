const express = require('express');
const router = express.Router();
const User = require('../models/User');

// @route   GET /api/patients/:id
// @desc    Obtenir le profil d'un patient
// @access  Private
router.get('/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user || user.role !== 'patient') {
      return res.status(404).json({ message: 'Patient non trouvé' });
    }

    res.json({
      id: user._id,
      email: user.email,
      profile: user.profile,
      isVerified: user.isVerified,
      createdAt: user.createdAt
    });
  } catch (error) {
    console.error('Erreur lors de la récupération du patient:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   PUT /api/patients/:id
// @desc    Mettre à jour le profil d'un patient
// @access  Private (patient propriétaire)
router.put('/:id', async (req, res) => {
  try {
    const { profile } = req.body;

    const user = await User.findById(req.params.id);

    if (!user || user.role !== 'patient') {
      return res.status(404).json({ message: 'Patient non trouvé' });
    }

    // Mettre à jour le profil
    if (profile) {
      user.profile = { ...user.profile, ...profile };
    }

    user.updatedAt = Date.now();
    await user.save();

    res.json({
      message: 'Profil mis à jour avec succès',
      user: {
        id: user._id,
        email: user.email,
        profile: user.profile
      }
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du patient:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

