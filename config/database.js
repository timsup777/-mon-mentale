const mongoose = require('mongoose');
const redis = require('redis');

class DatabaseManager {
  constructor() {
    this.mongoConnection = null;
    this.redisClient = null;
    this.isConnected = false;
  }

  // Configuration MongoDB optimisée pour la scalabilité
  async connectMongoDB() {
    try {
      const mongoOptions = {
        useNewUrlParser: true,
        useUnifiedTopology: true,
        maxPoolSize: 100, // Nombre maximum de connexions dans le pool
        minPoolSize: 10,  // Nombre minimum de connexions dans le pool
        maxIdleTimeMS: 30000, // Fermer les connexions après 30s d'inactivité
        serverSelectionTimeoutMS: 5000, // Timeout de sélection du serveur
        socketTimeoutMS: 45000, // Timeout des sockets
        bufferMaxEntries: 0, // Désactiver le buffering
        bufferCommands: false, // Désactiver le buffering des commandes
        readPreference: 'secondaryPreferred', // Lire sur les secondaires si disponibles
        writeConcern: {
          w: 'majority', // Attendre la confirmation de la majorité
          j: true, // Attendre l'écriture sur disque
          wtimeout: 10000 // Timeout de 10s
        },
        // Configuration pour la réplication
        replicaSet: process.env.MONGODB_REPLICA_SET || undefined,
        // Configuration pour le sharding
        shardKey: process.env.MONGODB_SHARD_KEY || undefined
      };

      this.mongoConnection = await mongoose.connect(
        process.env.MONGODB_URI || 'mongodb://localhost:27017/mon-mentale',
        mongoOptions
      );

      // Configuration des événements de connexion
      mongoose.connection.on('connected', () => {
        console.log('✅ MongoDB connecté avec succès');
        this.isConnected = true;
      });

      mongoose.connection.on('error', (err) => {
        console.error('❌ Erreur MongoDB:', err);
        this.isConnected = false;
      });

      mongoose.connection.on('disconnected', () => {
        console.log('⚠️ MongoDB déconnecté');
        this.isConnected = false;
      });

      // Gestion de la fermeture gracieuse
      process.on('SIGINT', async () => {
        await this.disconnect();
        process.exit(0);
      });

      return this.mongoConnection;
    } catch (error) {
      console.error('❌ Erreur de connexion MongoDB:', error);
      throw error;
    }
  }

  // Configuration Redis pour la mise en cache
  async connectRedis() {
    try {
      this.redisClient = redis.createClient({
        host: process.env.REDIS_HOST || 'localhost',
        port: process.env.REDIS_PORT || 6379,
        password: process.env.REDIS_PASSWORD || undefined,
        db: process.env.REDIS_DB || 0,
        retry_strategy: (options) => {
          if (options.error && options.error.code === 'ECONNREFUSED') {
            console.error('❌ Redis serveur refusé la connexion');
            return new Error('Redis serveur refusé la connexion');
          }
          if (options.total_retry_time > 1000 * 60 * 60) {
            console.error('❌ Redis timeout de retry dépassé');
            return new Error('Redis timeout de retry dépassé');
          }
          if (options.attempt > 10) {
            console.error('❌ Redis trop de tentatives');
            return undefined;
          }
          return Math.min(options.attempt * 100, 3000);
        }
      });

      this.redisClient.on('connect', () => {
        console.log('✅ Redis connecté avec succès');
      });

      this.redisClient.on('error', (err) => {
        console.error('❌ Erreur Redis:', err);
      });

      await this.redisClient.connect();
      return this.redisClient;
    } catch (error) {
      console.error('❌ Erreur de connexion Redis:', error);
      throw error;
    }
  }

  // Méthodes de cache Redis
  async cacheSet(key, value, ttl = 3600) {
    if (!this.redisClient) return false;
    try {
      const serializedValue = JSON.stringify(value);
      await this.redisClient.setEx(key, ttl, serializedValue);
      return true;
    } catch (error) {
      console.error('Erreur cache set:', error);
      return false;
    }
  }

  async cacheGet(key) {
    if (!this.redisClient) return null;
    try {
      const value = await this.redisClient.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error('Erreur cache get:', error);
      return null;
    }
  }

  async cacheDel(key) {
    if (!this.redisClient) return false;
    try {
      await this.redisClient.del(key);
      return true;
    } catch (error) {
      console.error('Erreur cache del:', error);
      return false;
    }
  }

  async cacheFlush() {
    if (!this.redisClient) return false;
    try {
      await this.redisClient.flushAll();
      return true;
    } catch (error) {
      console.error('Erreur cache flush:', error);
      return false;
    }
  }

  // Vérifier la santé de la base de données
  async healthCheck() {
    const health = {
      mongodb: false,
      redis: false,
      timestamp: new Date().toISOString()
    };

    try {
      // Test MongoDB
      await mongoose.connection.db.admin().ping();
      health.mongodb = true;
    } catch (error) {
      console.error('MongoDB health check failed:', error);
    }

    try {
      // Test Redis
      if (this.redisClient) {
        await this.redisClient.ping();
        health.redis = true;
      }
    } catch (error) {
      console.error('Redis health check failed:', error);
    }

    return health;
  }

  // Déconnexion gracieuse
  async disconnect() {
    try {
      if (this.mongoConnection) {
        await mongoose.connection.close();
        console.log('✅ MongoDB déconnecté');
      }
      if (this.redisClient) {
        await this.redisClient.quit();
        console.log('✅ Redis déconnecté');
      }
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error);
    }
  }

  // Obtenir les statistiques de performance
  async getStats() {
    try {
      const stats = await mongoose.connection.db.stats();
      return {
        collections: stats.collections,
        dataSize: stats.dataSize,
        storageSize: stats.storageSize,
        indexes: stats.indexes,
        indexSize: stats.indexSize,
        objects: stats.objects,
        avgObjSize: stats.avgObjSize
      };
    } catch (error) {
      console.error('Erreur récupération stats:', error);
      return null;
    }
  }
}

module.exports = new DatabaseManager();

