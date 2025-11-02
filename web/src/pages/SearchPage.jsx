import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import './SearchPage.css'

function SearchPage() {
  const navigate = useNavigate()
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedSpecialty, setSelectedSpecialty] = useState('all')
  const [selectedType, setSelectedType] = useState('all')
  const [practitioners, setPractitioners] = useState([])

  const specialties = [
    { value: 'all', label: 'Toutes les spécialités' },
    { value: 'clinique', label: 'Psychologie clinique' },
    { value: 'cognitive', label: 'Psychologie cognitive' },
    { value: 'comportementale', label: 'Psychologie comportementale' },
    { value: 'enfant', label: 'Psychologie de l\'enfant' },
    { value: 'adolescent', label: 'Psychologie de l\'adolescent' },
    { value: 'couple', label: 'Thérapie de couple' },
    { value: 'famille', label: 'Thérapie familiale' },
    { value: 'psychiatrie', label: 'Psychiatrie générale' }
  ]

  const consultationTypes = [
    { value: 'all', label: 'Tous les types' },
    { value: 'presentiel', label: '📍 Présentiel' },
    { value: 'teleconsultation', label: '💻 Téléconsultation' },
    { value: 'domicile', label: '🏠 À domicile' }
  ]

  // Praticiens d'exemple
  const samplePractitioners = [
    {
      id: 1,
      name: 'Dr. Sophie Martin',
      specialty: 'Psychologue clinicienne',
      experience: 12,
      rating: 4.9,
      reviews: 156,
      price: 65,
      location: 'Paris 15ème',
      types: ['presentiel', 'teleconsultation'],
      nextAvailable: 'Demain 14h00',
      image: '👩‍⚕️',
      languages: ['Français', 'Anglais']
    },
    {
      id: 2,
      name: 'Dr. Thomas Dubois',
      specialty: 'Psychiatre',
      experience: 15,
      rating: 4.8,
      reviews: 203,
      price: 80,
      location: 'Paris 8ème',
      types: ['presentiel', 'teleconsultation'],
      nextAvailable: 'Aujourd\'hui 16h30',
      image: '👨‍⚕️',
      languages: ['Français', 'Espagnol']
    },
    {
      id: 3,
      name: 'Dr. Emma Laurent',
      specialty: 'Psychologue pour enfants',
      experience: 8,
      rating: 5.0,
      reviews: 89,
      price: 60,
      location: 'Paris 16ème',
      types: ['presentiel'],
      nextAvailable: 'Mardi 10h00',
      image: '👩‍⚕️',
      languages: ['Français', 'Anglais', 'Allemand']
    },
    {
      id: 4,
      name: 'Dr. Marc Lefebvre',
      specialty: 'Thérapeute de couple',
      experience: 10,
      rating: 4.7,
      reviews: 127,
      price: 90,
      location: 'Paris 9ème',
      types: ['presentiel', 'teleconsultation'],
      nextAvailable: 'Vendredi 15h00',
      image: '👨‍⚕️',
      languages: ['Français']
    },
    {
      id: 5,
      name: 'Dr. Julie Moreau',
      specialty: 'Psychologue cognitive',
      experience: 6,
      rating: 4.9,
      reviews: 94,
      price: 55,
      location: 'Paris 11ème',
      types: ['teleconsultation'],
      nextAvailable: 'Aujourd\'hui 18h00',
      image: '👩‍⚕️',
      languages: ['Français', 'Italien']
    },
    {
      id: 6,
      name: 'Dr. Pierre Rousseau',
      specialty: 'Psychiatre',
      experience: 20,
      rating: 4.8,
      reviews: 278,
      price: 85,
      location: 'Paris 7ème',
      types: ['presentiel', 'domicile'],
      nextAvailable: 'Mercredi 9h30',
      image: '👨‍⚕️',
      languages: ['Français', 'Anglais']
    }
  ]

  useEffect(() => {
    setPractitioners(samplePractitioners)
  }, [])

  return (
    <div className="search-page">
      {/* Demo Banner */}
      <div className="demo-banner">
        <div className="container">
          <span className="demo-icon">⚠️</span>
          <span className="demo-text">
            <strong>Version démo</strong> - Les praticiens affichés sont des exemples fictifs pour démonstration.
          </span>
        </div>
      </div>

      {/* Header */}
      <header className="search-header">
        <div className="container">
          <div className="header-content">
            <div className="logo" onClick={() => navigate('/')}>
              <span className="logo-icon">🧠</span>
              <span className="logo-text">Mon Mentale</span>
            </div>
            <div className="header-search">
              <input
                type="text"
                placeholder="Rechercher un praticien, une spécialité..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="search-input"
              />
              <button className="search-button">🔍</button>
            </div>
            <button className="btn btn-secondary">Mon compte</button>
          </div>
        </div>
      </header>

      {/* Filters */}
      <div className="filters-section">
        <div className="container">
          <div className="filters">
            <div className="filter-group">
              <label>Spécialité</label>
              <select 
                value={selectedSpecialty}
                onChange={(e) => setSelectedSpecialty(e.target.value)}
                className="filter-select"
              >
                {specialties.map(spec => (
                  <option key={spec.value} value={spec.value}>{spec.label}</option>
                ))}
              </select>
            </div>
            
            <div className="filter-group">
              <label>Type de consultation</label>
              <select
                value={selectedType}
                onChange={(e) => setSelectedType(e.target.value)}
                className="filter-select"
              >
                {consultationTypes.map(type => (
                  <option key={type.value} value={type.value}>{type.label}</option>
                ))}
              </select>
            </div>
            
            <div className="filter-group">
              <label>Disponibilité</label>
              <select className="filter-select">
                <option>Toutes les disponibilités</option>
                <option>Aujourd'hui</option>
                <option>Cette semaine</option>
                <option>Ce mois</option>
              </select>
            </div>
            
            <button className="btn btn-primary">Appliquer les filtres</button>
          </div>
        </div>
      </div>

      {/* Results */}
      <div className="results-section">
        <div className="container">
          <div className="results-header">
            <h2>{practitioners.length} praticiens (démo)</h2>
            <div className="sort-options">
              <label>Trier par:</label>
              <select className="sort-select">
                <option>Pertinence</option>
                <option>Note</option>
                <option>Prix croissant</option>
                <option>Prix décroissant</option>
                <option>Disponibilité</option>
              </select>
            </div>
          </div>

          <div className="practitioners-grid">
            {practitioners.map(practitioner => (
              <div key={practitioner.id} className="practitioner-card card">
                <div className="card-header">
                  <div className="practitioner-avatar">{practitioner.image}</div>
                  <div className="practitioner-info">
                    <h3>{practitioner.name}</h3>
                    <p className="specialty">{practitioner.specialty}</p>
                    <div className="rating">
                      <span className="stars">⭐ {practitioner.rating}</span>
                      <span className="reviews">({practitioner.reviews} avis)</span>
                    </div>
                  </div>
                </div>

                <div className="card-body">
                  <div className="info-row">
                    <span className="icon">📍</span>
                    <span>{practitioner.location}</span>
                  </div>
                  
                  <div className="info-row">
                    <span className="icon">💼</span>
                    <span>{practitioner.experience} ans d'expérience</span>
                  </div>
                  
                  <div className="info-row">
                    <span className="icon">🌍</span>
                    <span>{practitioner.languages.join(', ')}</span>
                  </div>
                  
                  <div className="consultation-types">
                    {practitioner.types.includes('presentiel') && (
                      <span className="type-badge">📍 Présentiel</span>
                    )}
                    {practitioner.types.includes('teleconsultation') && (
                      <span className="type-badge">💻 Téléconsultation</span>
                    )}
                    {practitioner.types.includes('domicile') && (
                      <span className="type-badge">🏠 Domicile</span>
                    )}
                  </div>
                </div>

                <div className="card-footer">
                  <div className="price-info">
                    <span className="price">{practitioner.price}€</span>
                    <span className="next-available">
                      ⏰ {practitioner.nextAvailable}
                    </span>
                  </div>
                  <button className="btn btn-primary btn-book" disabled title="Démo seulement">
                    Voir le profil
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

export default SearchPage

