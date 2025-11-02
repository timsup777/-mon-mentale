import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import './HomePage.css'

function HomePage() {
  const navigate = useNavigate()
  const [currentMood, setCurrentMood] = useState(null)

  const moods = [
    { emoji: '😊', name: 'Excellent', color: '#A8D5BA' },
    { emoji: '🙂', name: 'Bien', color: '#7BA3D1' },
    { emoji: '😐', name: 'Moyen', color: '#F4C2C2' },
    { emoji: '😔', name: 'Difficile', color: '#B19CD9' }
  ]

  const stats = [
    { number: '10,000+', label: 'Patients aidés' },
    { number: '500+', label: 'Praticiens qualifiés' },
    { number: '4.9/5', label: 'Note moyenne' },
    { number: '24/7', label: 'Disponibilité' }
  ]

  const features = [
    {
      icon: '🔍',
      title: 'Trouvez votre praticien',
      description: 'Recherchez parmi des centaines de psychologues et psychiatres qualifiés près de chez vous'
    },
    {
      icon: '📅',
      title: 'Prenez rendez-vous facilement',
      description: 'Réservez en ligne en quelques clics, 24h/24, 7j/7'
    },
    {
      icon: '💬',
      title: 'Téléconsultation possible',
      description: 'Consultez depuis chez vous en vidéo, par téléphone ou par message'
    },
    {
      icon: '🔒',
      title: 'Sécurisé et confidentiel',
      description: 'Vos données sont protégées et votre confidentialité garantie'
    }
  ]

  return (
    <div className="homepage">
      {/* Hero Section */}
      <section className="hero">
        <div className="hero-bg">
          <div className="floating-shape shape-1"></div>
          <div className="floating-shape shape-2"></div>
          <div className="floating-shape shape-3"></div>
        </div>
        
        <nav className="navbar">
          <div className="container">
            <div className="nav-content">
              <div className="logo">
                <span className="logo-icon">🧠</span>
                <span className="logo-text">Mon Mentale</span>
              </div>
              <div className="nav-links">
                <a href="#features">Fonctionnalités</a>
                <a href="#how-it-works">Comment ça marche</a>
                <a href="#stats">À propos</a>
                <button className="btn btn-secondary">Connexion</button>
              </div>
            </div>
          </div>
        </nav>

        <div className="container">
          <div className="hero-content">
            <div className="hero-text">
              <h1 className="hero-title fade-in">
                Votre santé mentale,
                <br />
                <span className="gradient-text">notre priorité</span>
              </h1>
              <p className="hero-description fade-in">
                Trouvez le praticien qui vous correspond parmi des centaines de psychologues et psychiatres qualifiés. Prenez rendez-vous en ligne en quelques clics.
              </p>
              <div className="hero-buttons fade-in">
                <button 
                  className="btn btn-primary btn-lg"
                  onClick={() => navigate('/recherche')}
                >
                  <span>Trouver un praticien</span>
                  <span>→</span>
                </button>
                <button className="btn btn-secondary btn-lg">
                  <span>Comment ça marche</span>
                  <span>▶</span>
                </button>
              </div>
            </div>
            
            <div className="hero-visual">
              <div className="mood-tracker-preview float">
                <h3>Comment vous sentez-vous aujourd'hui ?</h3>
                <div className="mood-options">
                  {moods.map((mood, index) => (
                    <button
                      key={index}
                      className={`mood-btn ${currentMood === index ? 'active' : ''}`}
                      style={{ '--mood-color': mood.color }}
                      onClick={() => setCurrentMood(index)}
                    >
                      <span className="mood-emoji">{mood.emoji}</span>
                      <span className="mood-name">{mood.name}</span>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="features-section">
        <div className="container">
          <div className="section-header">
            <h2>Pourquoi choisir Mon Mentale ?</h2>
            <p>Une plateforme moderne conçue pour faciliter l'accès aux soins de santé mentale</p>
          </div>
          
          <div className="features-grid">
            {features.map((feature, index) => (
              <div 
                key={index} 
                className="feature-card card"
                style={{ animationDelay: `${index * 0.1}s` }}
              >
                <div className="feature-icon">{feature.icon}</div>
                <h3>{feature.title}</h3>
                <p>{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section id="how-it-works" className="how-section">
        <div className="container">
          <div className="section-header">
            <h2>Comment ça marche ?</h2>
            <p>3 étapes simples pour prendre soin de votre santé mentale</p>
          </div>
          
          <div className="steps-container">
            <div className="step">
              <div className="step-number">1</div>
              <div className="step-content">
                <h3>Recherchez un praticien</h3>
                <p>Utilisez nos filtres pour trouver le professionnel qui correspond à vos besoins : spécialité, localisation, langues parlées...</p>
              </div>
            </div>
            
            <div className="step-line"></div>
            
            <div className="step">
              <div className="step-number">2</div>
              <div className="step-content">
                <h3>Prenez rendez-vous</h3>
                <p>Consultez les disponibilités en temps réel et réservez votre créneau en quelques clics, en ligne ou en téléconsultation.</p>
              </div>
            </div>
            
            <div className="step-line"></div>
            
            <div className="step">
              <div className="step-number">3</div>
              <div className="step-content">
                <h3>Consultez votre praticien</h3>
                <p>Rendez-vous au cabinet ou connectez-vous pour votre téléconsultation. Simple, sécurisé et confidentiel.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section id="stats" className="stats-section">
        <div className="container">
          <div className="stats-grid">
            {stats.map((stat, index) => (
              <div key={index} className="stat-card">
                <div className="stat-number">{stat.number}</div>
                <div className="stat-label">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta-section">
        <div className="container">
          <div className="cta-content">
            <h2>Prêt à prendre soin de votre santé mentale ?</h2>
            <p>Trouvez le praticien qui vous correspond et prenez rendez-vous dès maintenant</p>
            <button 
              className="btn btn-primary btn-lg"
              onClick={() => navigate('/recherche')}
            >
              <span>Commencer maintenant</span>
              <span>→</span>
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="footer">
        <div className="container">
          <div className="footer-content">
            <div className="footer-section">
              <div className="logo">
                <span className="logo-icon">🧠</span>
                <span className="logo-text">Mon Mentale</span>
              </div>
              <p>Votre santé mentale, notre priorité</p>
            </div>
            
            <div className="footer-section">
              <h4>Liens rapides</h4>
              <a href="#features">Fonctionnalités</a>
              <a href="#how-it-works">Comment ça marche</a>
              <a href="/recherche">Trouver un praticien</a>
            </div>
            
            <div className="footer-section">
              <h4>Légal</h4>
              <a href="#">Conditions d'utilisation</a>
              <a href="#">Politique de confidentialité</a>
              <a href="#">Mentions légales</a>
            </div>
            
            <div className="footer-section">
              <h4>Contact</h4>
              <a href="mailto:contact@monmentale.fr">contact@monmentale.fr</a>
              <a href="tel:+33123456789">+33 1 23 45 67 89</a>
            </div>
          </div>
          
          <div className="footer-bottom">
            <p>© 2025 Mon Mentale. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default HomePage

