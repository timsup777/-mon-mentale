import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createDrawerNavigator } from '@react-navigation/drawer';
import Icon from 'react-native-vector-icons/MaterialIcons';

import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';

// Écrans d'authentification
import LoginScreen from '../screens/auth/LoginScreen';
import RegisterScreen from '../screens/auth/RegisterScreen';
import ForgotPasswordScreen from '../screens/auth/ForgotPasswordScreen';

// Écrans patients
import HomeScreen from '../screens/patient/HomeScreen';
import SearchScreen from '../screens/patient/SearchScreen';
import AppointmentsScreen from '../screens/patient/AppointmentsScreen';
import ProfileScreen from '../screens/patient/ProfileScreen';
import PractitionerDetailScreen from '../screens/patient/PractitionerDetailScreen';
import BookingScreen from '../screens/patient/BookingScreen';
import ChatScreen from '../screens/patient/ChatScreen';

// Écrans praticiens
import PractitionerDashboardScreen from '../screens/practitioner/DashboardScreen';
import PractitionerAppointmentsScreen from '../screens/practitioner/AppointmentsScreen';
import PractitionerPatientsScreen from '../screens/practitioner/PatientsScreen';
import PractitionerProfileScreen from '../screens/practitioner/ProfileScreen';
import PractitionerSettingsScreen from '../screens/practitioner/SettingsScreen';

// Écrans communs
import SplashScreen from '../screens/common/SplashScreen';
import OnboardingScreen from '../screens/common/OnboardingScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();
const Drawer = createDrawerNavigator();

const AuthStack = () => (
  <Stack.Navigator
    screenOptions={{
      headerShown: false,
      cardStyle: { backgroundColor: '#FFFFFF' }
    }}
  >
    <Stack.Screen name="Login" component={LoginScreen} />
    <Stack.Screen name="Register" component={RegisterScreen} />
    <Stack.Screen name="ForgotPassword" component={ForgotPasswordScreen} />
  </Stack.Navigator>
);

const PatientTabs = () => {
  const { currentTheme } = useTheme();
  
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;

          switch (route.name) {
            case 'Home':
              iconName = 'home';
              break;
            case 'Search':
              iconName = 'search';
              break;
            case 'Appointments':
              iconName = 'event';
              break;
            case 'Profile':
              iconName = 'person';
              break;
            default:
              iconName = 'help';
          }

          return <Icon name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: currentTheme.colors.primary,
        tabBarInactiveTintColor: currentTheme.colors.textSecondary,
        tabBarStyle: {
          backgroundColor: currentTheme.colors.surface,
          borderTopColor: currentTheme.colors.border,
          paddingBottom: 5,
          paddingTop: 5,
          height: 60,
        },
        headerStyle: {
          backgroundColor: currentTheme.colors.primary,
        },
        headerTintColor: '#FFFFFF',
        headerTitleStyle: {
          fontWeight: 'bold',
        },
      })}
    >
      <Tab.Screen 
        name="Home" 
        component={HomeScreen} 
        options={{ title: 'Accueil' }}
      />
      <Tab.Screen 
        name="Search" 
        component={SearchScreen} 
        options={{ title: 'Rechercher' }}
      />
      <Tab.Screen 
        name="Appointments" 
        component={AppointmentsScreen} 
        options={{ title: 'Rendez-vous' }}
      />
      <Tab.Screen 
        name="Profile" 
        component={ProfileScreen} 
        options={{ title: 'Profil' }}
      />
    </Tab.Navigator>
  );
};

const PractitionerDrawer = () => {
  const { currentTheme } = useTheme();
  
  return (
    <Drawer.Navigator
      screenOptions={{
        headerStyle: {
          backgroundColor: currentTheme.colors.primary,
        },
        headerTintColor: '#FFFFFF',
        headerTitleStyle: {
          fontWeight: 'bold',
        },
        drawerStyle: {
          backgroundColor: currentTheme.colors.surface,
        },
        drawerActiveTintColor: currentTheme.colors.primary,
        drawerInactiveTintColor: currentTheme.colors.textSecondary,
      }}
    >
      <Drawer.Screen 
        name="Dashboard" 
        component={PractitionerDashboardScreen}
        options={{
          title: 'Tableau de bord',
          drawerIcon: ({ color, size }) => (
            <Icon name="dashboard" size={size} color={color} />
          ),
        }}
      />
      <Drawer.Screen 
        name="Appointments" 
        component={PractitionerAppointmentsScreen}
        options={{
          title: 'Rendez-vous',
          drawerIcon: ({ color, size }) => (
            <Icon name="event" size={size} color={color} />
          ),
        }}
      />
      <Drawer.Screen 
        name="Patients" 
        component={PractitionerPatientsScreen}
        options={{
          title: 'Patients',
          drawerIcon: ({ color, size }) => (
            <Icon name="people" size={size} color={color} />
          ),
        }}
      />
      <Drawer.Screen 
        name="Profile" 
        component={PractitionerProfileScreen}
        options={{
          title: 'Profil',
          drawerIcon: ({ color, size }) => (
            <Icon name="person" size={size} color={color} />
          ),
        }}
      />
      <Drawer.Screen 
        name="Settings" 
        component={PractitionerSettingsScreen}
        options={{
          title: 'Paramètres',
          drawerIcon: ({ color, size }) => (
            <Icon name="settings" size={size} color={color} />
          ),
        }}
      />
    </Drawer.Navigator>
  );
};

const AppNavigator = () => {
  const { isAuthenticated, isLoading, user } = useAuth();

  if (isLoading) {
    return <SplashScreen />;
  }

  if (!isAuthenticated) {
    return <AuthStack />;
  }

  // Navigation basée sur le rôle de l'utilisateur
  if (user?.role === 'patient') {
    return (
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="PatientTabs" component={PatientTabs} />
        <Stack.Screen 
          name="PractitionerDetail" 
          component={PractitionerDetailScreen}
          options={{ title: 'Détails du praticien' }}
        />
        <Stack.Screen 
          name="Booking" 
          component={BookingScreen}
          options={{ title: 'Réserver un rendez-vous' }}
        />
        <Stack.Screen 
          name="Chat" 
          component={ChatScreen}
          options={{ title: 'Messages' }}
        />
      </Stack.Navigator>
    );
  }

  if (user?.role === 'psychologue' || user?.role === 'psychiatre') {
    return <PractitionerDrawer />;
  }

  // Par défaut, afficher l'écran d'authentification
  return <AuthStack />;
};

export default AppNavigator;

