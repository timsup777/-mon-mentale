const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

class StripeService {
  constructor() {
    this.platformFeePercentage = 0.05; // 5% de frais de plateforme
  }

  // Créer un PaymentIntent pour un paiement
  async createPaymentIntent(amount, currency = 'eur', metadata = {}) {
    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(amount * 100), // Stripe utilise les centimes
        currency,
        metadata,
        automatic_payment_methods: {
          enabled: true,
        },
        payment_method_types: ['card', 'apple_pay', 'google_pay'],
      });

      return {
        success: true,
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id
      };
    } catch (error) {
      console.error('Erreur création PaymentIntent:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Confirmer un paiement
  async confirmPayment(paymentIntentId) {
    try {
      const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId);
      
      if (paymentIntent.status === 'succeeded') {
        return {
          success: true,
          paymentIntent,
          chargeId: paymentIntent.latest_charge
        };
      }
      
      return {
        success: false,
        error: 'Paiement non confirmé'
      };
    } catch (error) {
      console.error('Erreur confirmation paiement:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Créer un transfer vers le compte du praticien
  async createTransfer(practitionerStripeAccountId, amount, paymentIntentId) {
    try {
      const transfer = await stripe.transfers.create({
        amount: Math.round(amount * 100),
        currency: 'eur',
        destination: practitionerStripeAccountId,
        transfer_group: paymentIntentId,
        metadata: {
          type: 'practitioner_payment',
          source_payment: paymentIntentId
        }
      });

      return {
        success: true,
        transferId: transfer.id
      };
    } catch (error) {
      console.error('Erreur création transfer:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Créer un compte connecté pour un praticien
  async createConnectedAccount(practitionerData) {
    try {
      const account = await stripe.accounts.create({
        type: 'express',
        country: 'FR',
        email: practitionerData.email,
        capabilities: {
          card_payments: { requested: true },
          transfers: { requested: true },
        },
        business_type: 'individual',
        individual: {
          first_name: practitionerData.firstName,
          last_name: practitionerData.lastName,
          email: practitionerData.email,
        },
        metadata: {
          practitioner_id: practitionerData._id,
          specialization: practitionerData.specializations?.join(',') || 'psychologie'
        }
      });

      // Créer un lien de compte pour l'onboarding
      const accountLink = await stripe.accountLinks.create({
        account: account.id,
        refresh_url: `${process.env.FRONTEND_URL}/practitioner/onboarding/refresh`,
        return_url: `${process.env.FRONTEND_URL}/practitioner/onboarding/success`,
        type: 'account_onboarding',
      });

      return {
        success: true,
        accountId: account.id,
        onboardingUrl: accountLink.url
      };
    } catch (error) {
      console.error('Erreur création compte connecté:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Obtenir le statut d'un compte connecté
  async getAccountStatus(accountId) {
    try {
      const account = await stripe.accounts.retrieve(accountId);
      
      return {
        success: true,
        chargesEnabled: account.charges_enabled,
        payoutsEnabled: account.payouts_enabled,
        detailsSubmitted: account.details_submitted,
        requirements: account.requirements
      };
    } catch (error) {
      console.error('Erreur récupération statut compte:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Créer un lien de paiement pour les paiements récurrents
  async createPaymentLink(priceId, metadata = {}) {
    try {
      const paymentLink = await stripe.paymentLinks.create({
        line_items: [
          {
            price: priceId,
            quantity: 1,
          },
        ],
        metadata,
        allow_promotion_codes: true,
      });

      return {
        success: true,
        url: paymentLink.url,
        paymentLinkId: paymentLink.id
      };
    } catch (error) {
      console.error('Erreur création lien de paiement:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Créer un remboursement
  async createRefund(chargeId, amount = null, reason = 'requested_by_customer') {
    try {
      const refund = await stripe.refunds.create({
        charge: chargeId,
        amount: amount ? Math.round(amount * 100) : undefined,
        reason,
        metadata: {
          type: 'appointment_refund'
        }
      });

      return {
        success: true,
        refundId: refund.id,
        amount: refund.amount / 100
      };
    } catch (error) {
      console.error('Erreur création remboursement:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Webhook pour traiter les événements Stripe
  async handleWebhook(event) {
    try {
      switch (event.type) {
        case 'payment_intent.succeeded':
          return await this.handlePaymentSucceeded(event.data.object);
        
        case 'payment_intent.payment_failed':
          return await this.handlePaymentFailed(event.data.object);
        
        case 'account.updated':
          return await this.handleAccountUpdated(event.data.object);
        
        default:
          console.log(`Événement non géré: ${event.type}`);
          return { success: true };
      }
    } catch (error) {
      console.error('Erreur traitement webhook:', error);
      return { success: false, error: error.message };
    }
  }

  async handlePaymentSucceeded(paymentIntent) {
    // Logique pour traiter un paiement réussi
    console.log('Paiement réussi:', paymentIntent.id);
    return { success: true };
  }

  async handlePaymentFailed(paymentIntent) {
    // Logique pour traiter un paiement échoué
    console.log('Paiement échoué:', paymentIntent.id);
    return { success: true };
  }

  async handleAccountUpdated(account) {
    // Logique pour traiter la mise à jour d'un compte
    console.log('Compte mis à jour:', account.id);
    return { success: true };
  }

  // Calculer les frais de plateforme
  calculatePlatformFee(amount) {
    return Math.round(amount * this.platformFeePercentage * 100) / 100;
  }

  // Calculer le montant pour le praticien
  calculatePractitionerAmount(amount) {
    const platformFee = this.calculatePlatformFee(amount);
    return Math.round((amount - platformFee) * 100) / 100;
  }
}

module.exports = new StripeService();

