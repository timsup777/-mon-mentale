const mongoose = require('mongoose');

const practitionerSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  specializations: [{
    type: String,
    enum: [
      'psychologie clinique',
      'psychologie cognitive',
      'psychologie comportementale',
      'psychologie de l\'enfant',
      'psychologie de l\'adolescent',
      'psychologie de la famille',
      'psychologie du couple',
      'psychologie du travail',
      'psychologie sociale',
      'psychiatrie générale',
      'psychiatrie de l\'enfant',
      'psychiatrie de l\'adolescent',
      'psychiatrie gériatrique',
      'psychiatrie légale',
      'addictologie',
      'psychotraumatologie',
      'neuropsychologie',
      'sexologie',
      'thérapie de couple',
      'thérapie familiale'
    ]
  }],
  professionalInfo: {
    licenseNumber: {
      type: String,
      required: true,
      unique: true
    },
    university: {
      type: String,
      required: true
    },
    graduationYear: {
      type: Number,
      required: true
    },
    experience: {
      type: Number,
      required: true,
      min: 0
    },
    languages: [{
      type: String,
      enum: ['français', 'anglais', 'espagnol', 'allemand', 'italien', 'arabe', 'portugais']
    }],
    description: {
      type: String,
      maxlength: 1000
    },
    approach: {
      type: String,
      maxlength: 500
    }
  },
  practice: {
    address: {
      street: String,
      city: String,
      postalCode: String,
      country: {
        type: String,
        default: 'France'
      },
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    },
    consultationTypes: [{
      type: String,
      enum: ['presentiel', 'teleconsultation', 'domicile']
    }],
    prices: {
      consultation: {
        type: Number,
        required: true
      },
      teleconsultation: Number,
      domicile: Number
    },
    availability: {
      monday: [{
        start: String,
        end: String
      }],
      tuesday: [{
        start: String,
        end: String
      }],
      wednesday: [{
        start: String,
        end: String
      }],
      thursday: [{
        start: String,
        end: String
      }],
      friday: [{
        start: String,
        end: String
      }],
      saturday: [{
        start: String,
        end: String
      }],
      sunday: [{
        start: String,
        end: String
      }]
    },
    consultationDuration: {
      type: Number,
      default: 45,
      min: 15,
      max: 120
    },
    breakDuration: {
      type: Number,
      default: 15,
      min: 5,
      max: 60
    }
  },
  verification: {
    isVerified: {
      type: Boolean,
      default: false
    },
    documents: [{
      type: String,
      url: String,
      status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        default: 'pending'
      },
      uploadedAt: {
        type: Date,
        default: Date.now
      }
    }],
    verifiedAt: Date
  },
  statistics: {
    totalAppointments: {
      type: Number,
      default: 0
    },
    totalPatients: {
      type: Number,
      default: 0
    },
    averageRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5
    },
    totalReviews: {
      type: Number,
      default: 0
    }
  },
  isActive: {
    type: Boolean,
    default: true
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

// Index pour la recherche géographique
practitionerSchema.index({ 'practice.address.coordinates': '2dsphere' });

// Index pour la recherche textuelle
practitionerSchema.index({
  'professionalInfo.description': 'text',
  'professionalInfo.approach': 'text',
  'specializations': 'text'
});

module.exports = mongoose.model('Practitioner', practitionerSchema);

