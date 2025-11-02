const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  patient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  practitioner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Practitioner',
    required: true
  },
  appointmentType: {
    type: String,
    enum: ['presentiel', 'teleconsultation', 'domicile'],
    required: true
  },
  status: {
    type: String,
    enum: ['scheduled', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'],
    default: 'scheduled'
  },
  date: {
    type: Date,
    required: true
  },
  duration: {
    type: Number,
    required: true,
    min: 15,
    max: 120
  },
  timeSlot: {
    start: {
      type: String,
      required: true
    },
    end: {
      type: String,
      required: true
    }
  },
  location: {
    type: {
      type: String,
      enum: ['cabinet', 'teleconsultation', 'domicile'],
      required: true
    },
    address: {
      street: String,
      city: String,
      postalCode: String,
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    },
    meetingLink: String // Pour les téléconsultations
  },
  reason: {
    type: String,
    maxlength: 500
  },
  notes: {
    patient: {
      type: String,
      maxlength: 1000
    },
    practitioner: {
      type: String,
      maxlength: 1000
    }
  },
  documents: [{
    type: {
      type: String,
      enum: ['prescription', 'certificat', 'bilan', 'autre']
    },
    name: String,
    url: String,
    uploadedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    uploadedAt: {
      type: Date,
      default: Date.now
    }
  }],
  payment: {
    amount: {
      type: Number,
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'failed', 'refunded'],
      default: 'pending'
    },
    method: {
      type: String,
      enum: ['card', 'bank_transfer', 'cash', 'insurance']
    },
    transactionId: String,
    paidAt: Date
  },
  reminders: [{
    type: {
      type: String,
      enum: ['email', 'sms', 'push']
    },
    sentAt: Date,
    status: {
      type: String,
      enum: ['sent', 'delivered', 'failed']
    }
  }],
  cancellation: {
    cancelledBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    reason: String,
    cancelledAt: Date,
    refundAmount: Number
  },
  followUp: {
    isRequired: {
      type: Boolean,
      default: false
    },
    suggestedDate: Date,
    notes: String
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
appointmentSchema.index({ patient: 1, date: 1 });
appointmentSchema.index({ practitioner: 1, date: 1 });
appointmentSchema.index({ status: 1, date: 1 });

// Méthode pour vérifier les conflits d'horaire
appointmentSchema.statics.checkConflicts = async function(practitionerId, date, startTime, endTime, excludeId = null) {
  const query = {
    practitioner: practitionerId,
    date: date,
    status: { $in: ['scheduled', 'confirmed', 'in_progress'] },
    $or: [
      {
        'timeSlot.start': { $lt: endTime },
        'timeSlot.end': { $gt: startTime }
      }
    ]
  };
  
  if (excludeId) {
    query._id = { $ne: excludeId };
  }
  
  return await this.find(query);
};

module.exports = mongoose.model('Appointment', appointmentSchema);

