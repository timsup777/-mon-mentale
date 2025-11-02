rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Fonction pour vérifier si l'utilisateur est authentifié
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Fonction pour obtenir le rôle de l'utilisateur
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    // Fonction pour vérifier si l'utilisateur est admin
    function isAdmin() {
      return isAuthenticated() && getUserRole() == 'admin';
    }
    
    // Fonction pour vérifier si l'utilisateur est patient
    function isPatient() {
      return isAuthenticated() && getUserRole() == 'patient';
    }
    
    // Fonction pour vérifier si l'utilisateur est psychologue
    function isPractitioner() {
      return isAuthenticated() && getUserRole() == 'psychologue';
    }
    
    // Fonction pour vérifier si l'utilisateur est le propriétaire du document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Collection users - Gestion des utilisateurs
    match /users/{userId} {
      // Lecture : utilisateur peut lire son propre profil, psychologues peuvent lire les profils patients de leurs rendez-vous
      allow read: if isAuthenticated() && (
        isOwner(userId) || 
        isAdmin() ||
        (isPractitioner() && resource.data.role == 'patient' && 
         exists(/databases/$(database)/documents/appointments/$(appointmentId)) &&
         get(/databases/$(database)/documents/appointments/$(appointmentId)).data.practitionerId == request.auth.uid &&
         get(/databases/$(database)/documents/appointments/$(appointmentId)).data.patientId == userId)
      );
      
      // Écriture : utilisateur peut modifier son propre profil, admins peuvent tout modifier
      allow write: if isAuthenticated() && (
        isOwner(userId) || 
        isAdmin()
      );
      
      // Création : utilisateur peut créer son propre profil
      allow create: if isAuthenticated() && isOwner(userId);
    }
    
    // Collection appointments - Gestion des rendez-vous
    match /appointments/{appointmentId} {
      // Lecture : patient peut lire ses rendez-vous, psychologue peut lire ses rendez-vous, admin peut tout lire
      allow read: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && resource.data.patientId == request.auth.uid) ||
        (isPractitioner() && resource.data.practitionerId == request.auth.uid)
      );
      
      // Création : patients et psychologues peuvent créer des rendez-vous
      allow create: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && request.resource.data.patientId == request.auth.uid) ||
        (isPractitioner() && request.resource.data.practitionerId == request.auth.uid)
      );
      
      // Modification : patient peut modifier ses rendez-vous (annulation), psychologue peut modifier ses rendez-vous, admin peut tout modifier
      allow update: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && resource.data.patientId == request.auth.uid && 
         request.resource.data.status in ['cancelled']) ||
        (isPractitioner() && resource.data.practitionerId == request.auth.uid)
      );
      
      // Suppression : seul l'admin peut supprimer
      allow delete: if isAdmin();
    }
    
    // Collection payments - Gestion des paiements
    match /payments/{paymentId} {
      // Lecture : patient peut lire ses paiements, psychologue peut lire ses paiements, admin peut tout lire
      allow read: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && resource.data.patientId == request.auth.uid) ||
        (isPractitioner() && resource.data.practitionerId == request.auth.uid)
      );
      
      // Création : système de paiement (via Cloud Functions) et admin
      allow create: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && request.resource.data.patientId == request.auth.uid)
      );
      
      // Modification : système de paiement et admin uniquement
      allow update: if isAuthenticated() && (
        isAdmin() ||
        // Permettre les mises à jour automatiques du système de paiement
        (request.resource.data.status in ['processing', 'succeeded', 'failed', 'refunded'])
      );
      
      // Suppression : admin uniquement
      allow delete: if isAdmin();
    }
    
    // Collection callLogs - Logs des appels Agora
    match /callLogs/{callLogId} {
      // Lecture : patient peut lire ses logs d'appel, psychologue peut lire ses logs d'appel, admin peut tout lire
      allow read: if isAuthenticated() && (
        isAdmin() ||
        (isPatient() && resource.data.patientId == request.auth.uid) ||
        (isPractitioner() && resource.data.practitionerId == request.auth.uid)
      );
      
      // Création : système Agora et admin
      allow create: if isAuthenticated() && (
        isAdmin() ||
        // Permettre la création par le système Agora
        (request.resource.data.patientId != null && request.resource.data.practitionerId != null)
      );
      
      // Modification : système Agora et admin uniquement
      allow update: if isAuthenticated() && (
        isAdmin() ||
        // Permettre les mises à jour automatiques du système Agora
        (request.resource.data.status in ['initiated', 'connected', 'in_progress', 'ended', 'failed'])
      );
      
      // Suppression : admin uniquement
      allow delete: if isAdmin();
    }
    
    // Collection messages - Messagerie (pour l'évolutivité future)
    match /messages/{messageId} {
      // Lecture : utilisateurs peuvent lire leurs messages
      allow read: if isAuthenticated() && (
        isAdmin() ||
        (resource.data.senderId == request.auth.uid) ||
        (resource.data.receiverId == request.auth.uid)
      );
      
      // Création : utilisateurs peuvent envoyer des messages
      allow create: if isAuthenticated() && (
        isAdmin() ||
        (request.resource.data.senderId == request.auth.uid)
      );
      
      // Modification : utilisateurs peuvent modifier leurs messages non lus
      allow update: if isAuthenticated() && (
        isAdmin() ||
        (resource.data.senderId == request.auth.uid && resource.data.isRead == false)
      );
      
      // Suppression : admin uniquement
      allow delete: if isAdmin();
    }
    
    // Collection notifications - Notifications
    match /notifications/{notificationId} {
      // Lecture : utilisateur peut lire ses notifications
      allow read: if isAuthenticated() && (
        isAdmin() ||
        (resource.data.userId == request.auth.uid)
      );
      
      // Création : système de notifications et admin
      allow create: if isAuthenticated() && (
        isAdmin() ||
        (request.resource.data.userId == request.auth.uid)
      );
      
      // Modification : utilisateur peut marquer ses notifications comme lues
      allow update: if isAuthenticated() && (
        isAdmin() ||
        (resource.data.userId == request.auth.uid && 
         request.resource.data.isRead == true)
      );
      
      // Suppression : utilisateur peut supprimer ses notifications
      allow delete: if isAuthenticated() && (
        isAdmin() ||
        (resource.data.userId == request.auth.uid)
      );
    }
  }
}
