const express = require('express');
const router = express.Router();
const Practitioner = require('../models/Practitioner');

// @route   GET /api/practitioners
// @desc    Obtenir la liste des praticiens
// @access  Public
router.get('/', async (req, res) => {
  try {
    const { 
      specialization, 
      city, 
      consultationType,
      page = 1,
      limit = 10 
    } = req.query;

    let query = { isActive: true, 'verification.isVerified': true };

    // Filtres
    if (specialization) {
      query.specializations = specialization;
    }

    if (city) {
      query['practice.address.city'] = new RegExp(city, 'i');
    }

    if (consultationType) {
      query['practice.consultationTypes'] = consultationType;
    }

    const practitioners = await Practitioner.find(query)
      .populate('user', 'email profile')
      .sort({ 'statistics.averageRating': -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const count = await Practitioner.countDocuments(query);

    res.json({
      practitioners,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
      total: count
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des praticiens:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   GET /api/practitioners/:id
// @desc    Obtenir un praticien par ID
// @access  Public
router.get('/:id', async (req, res) => {
  try {
    const practitioner = await Practitioner.findById(req.params.id)
      .populate('user', 'email profile');

    if (!practitioner) {
      return res.status(404).json({ message: 'Praticien non trouvé' });
    }

    res.json(practitioner);
  } catch (error) {
    console.error('Erreur lors de la récupération du praticien:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   POST /api/practitioners
// @desc    Créer un profil de praticien
// @access  Private (psychologue/psychiatre)
router.post('/', async (req, res) => {
  try {
    const practitioner = new Practitioner(req.body);
    await practitioner.save();

    res.status(201).json({
      message: 'Profil praticien créé avec succès',
      practitioner
    });
  } catch (error) {
    console.error('Erreur lors de la création du praticien:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   PUT /api/practitioners/:id
// @desc    Mettre à jour un profil de praticien
// @access  Private (praticien propriétaire)
router.put('/:id', async (req, res) => {
  try {
    const practitioner = await Practitioner.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );

    if (!practitioner) {
      return res.status(404).json({ message: 'Praticien non trouvé' });
    }

    res.json({
      message: 'Profil mis à jour avec succès',
      practitioner
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du praticien:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   GET /api/practitioners/search/nearby
// @desc    Rechercher des praticiens à proximité
// @access  Public
router.get('/search/nearby', async (req, res) => {
  try {
    const { latitude, longitude, maxDistance = 10000 } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).json({ message: 'Coordonnées GPS requises' });
    }

    const practitioners = await Practitioner.find({
      isActive: true,
      'verification.isVerified': true,
      'practice.address.coordinates': {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)]
          },
          $maxDistance: parseInt(maxDistance)
        }
      }
    }).populate('user', 'email profile');

    res.json(practitioners);
  } catch (error) {
    console.error('Erreur lors de la recherche de praticiens à proximité:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

