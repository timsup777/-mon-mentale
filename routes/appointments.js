const express = require('express');
const router = express.Router();
const Appointment = require('../models/Appointment');

// @route   GET /api/appointments
// @desc    Obtenir la liste des rendez-vous
// @access  Private
router.get('/', async (req, res) => {
  try {
    const { userId, practitionerId, status } = req.query;

    let query = {};

    if (userId) {
      query.patient = userId;
    }

    if (practitionerId) {
      query.practitioner = practitionerId;
    }

    if (status) {
      query.status = status;
    }

    const appointments = await Appointment.find(query)
      .populate('patient', 'profile email')
      .populate('practitioner')
      .sort({ scheduledAt: -1 });

    res.json(appointments);
  } catch (error) {
    console.error('Erreur lors de la récupération des rendez-vous:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   GET /api/appointments/:id
// @desc    Obtenir un rendez-vous par ID
// @access  Private
router.get('/:id', async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.id)
      .populate('patient', 'profile email')
      .populate('practitioner');

    if (!appointment) {
      return res.status(404).json({ message: 'Rendez-vous non trouvé' });
    }

    res.json(appointment);
  } catch (error) {
    console.error('Erreur lors de la récupération du rendez-vous:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   POST /api/appointments
// @desc    Créer un nouveau rendez-vous
// @access  Private
router.post('/', async (req, res) => {
  try {
    const appointment = new Appointment(req.body);
    await appointment.save();

    res.status(201).json({
      message: 'Rendez-vous créé avec succès',
      appointment
    });
  } catch (error) {
    console.error('Erreur lors de la création du rendez-vous:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   PUT /api/appointments/:id
// @desc    Mettre à jour un rendez-vous
// @access  Private
router.put('/:id', async (req, res) => {
  try {
    const appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );

    if (!appointment) {
      return res.status(404).json({ message: 'Rendez-vous non trouvé' });
    }

    res.json({
      message: 'Rendez-vous mis à jour avec succès',
      appointment
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du rendez-vous:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// @route   DELETE /api/appointments/:id
// @desc    Annuler un rendez-vous
// @access  Private
router.delete('/:id', async (req, res) => {
  try {
    const appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      { status: 'cancelled', updatedAt: Date.now() },
      { new: true }
    );

    if (!appointment) {
      return res.status(404).json({ message: 'Rendez-vous non trouvé' });
    }

    res.json({
      message: 'Rendez-vous annulé avec succès',
      appointment
    });
  } catch (error) {
    console.error('Erreur lors de l\'annulation du rendez-vous:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;

