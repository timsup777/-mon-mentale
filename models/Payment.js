const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema({
  appointment: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
    required: true
  },
  patient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  practitioner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  amount: {
    type: Number,
    required: true,
    min: 0
  },
  platformFee: {
    type: Number,
    required: true,
    min: 0
  },
  practitionerAmount: {
    type: Number,
    required: true,
    min: 0
  },
  currency: {
    type: String,
    default: 'eur',
    enum: ['eur', 'usd', 'gbp']
  },
  status: {
    type: String,
    enum: ['pending', 'processing', 'succeeded', 'failed', 'cancelled', 'refunded'],
    default: 'pending'
  },
  paymentMethod: {
    type: String,
    enum: ['card', 'bank_transfer', 'apple_pay', 'google_pay'],
    required: true
  },
  stripe: {
    paymentIntentId: String,
    chargeId: String,
    transferId: String, // Transfer vers le compte du praticien
    refundId: String,
    clientSecret: String
  },
  billing: {
    email: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    address: {
      line1: String,
      line2: String,
      city: String,
      postal_code: String,
      country: String
    }
  },
  refund: {
    amount: Number,
    reason: {
      type: String,
      enum: ['duplicate', 'fraudulent', 'requested_by_customer']
    },
    refundedAt: Date,
    refundedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  },
  metadata: {
    appointmentType: String,
    practitionerSpecialization: String,
    patientId: String,
    practitionerId: String
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Index pour les requêtes fréquentes
paymentSchema.index({ patient: 1, createdAt: -1 });
paymentSchema.index({ practitioner: 1, createdAt: -1 });
paymentSchema.index({ status: 1, createdAt: -1 });
paymentSchema.index({ 'stripe.paymentIntentId': 1 });

// Méthode pour calculer les frais de plateforme (5%)
paymentSchema.statics.calculatePlatformFee = function(amount) {
  return Math.round(amount * 0.05 * 100) / 100; // Arrondi à 2 décimales
};

// Méthode pour calculer le montant du praticien
paymentSchema.statics.calculatePractitionerAmount = function(amount) {
  const platformFee = this.calculatePlatformFee(amount);
  return Math.round((amount - platformFee) * 100) / 100;
};

// Méthode pour créer un paiement
paymentSchema.statics.createPayment = async function(appointment, patient, practitioner, amount) {
  const platformFee = this.calculatePlatformFee(amount);
  const practitionerAmount = this.calculatePractitionerAmount(amount);
  
  return await this.create({
    appointment,
    patient,
    practitioner,
    amount,
    platformFee,
    practitionerAmount,
    metadata: {
      appointmentType: appointment.appointmentType,
      practitionerSpecialization: practitioner.specializations?.[0] || 'psychologie',
      patientId: patient._id.toString(),
      practitionerId: practitioner._id.toString()
    }
  });
};

module.exports = mongoose.model('Payment', paymentSchema);

