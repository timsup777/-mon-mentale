import { DefaultTheme } from 'react-native-paper';

const lightTheme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: '#2196F3', // Bleu principal
    primaryDark: '#1976D2',
    secondary: '#FFC107', // Jaune accent
    accent: '#FF5722', // Orange accent
    background: '#F5F5F5',
    surface: '#FFFFFF',
    text: '#212121',
    textSecondary: '#757575',
    error: '#F44336',
    success: '#4CAF50',
    warning: '#FF9800',
    info: '#2196F3',
    disabled: '#BDBDBD',
    placeholder: '#9E9E9E',
    border: '#E0E0E0',
    notification: '#FF5722',
    // Couleurs spécifiques à la santé mentale
    mentalHealth: {
      calm: '#E8F5E8',
      anxiety: '#FFF3E0',
      depression: '#E3F2FD',
      therapy: '#F3E5F5',
      wellness: '#E0F2F1'
    }
  },
  fonts: {
    ...DefaultTheme.fonts,
    regular: {
      fontFamily: 'System',
      fontWeight: '400',
    },
    medium: {
      fontFamily: 'System',
      fontWeight: '500',
    },
    light: {
      fontFamily: 'System',
      fontWeight: '300',
    },
    thin: {
      fontFamily: 'System',
      fontWeight: '100',
    },
  },
  roundness: 12,
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },
  shadows: {
    small: {
      shadowColor: '#000',
      shadowOffset: {
        width: 0,
        height: 1,
      },
      shadowOpacity: 0.18,
      shadowRadius: 1.0,
      elevation: 1,
    },
    medium: {
      shadowColor: '#000',
      shadowOffset: {
        width: 0,
        height: 2,
      },
      shadowOpacity: 0.25,
      shadowRadius: 3.84,
      elevation: 5,
    },
    large: {
      shadowColor: '#000',
      shadowOffset: {
        width: 0,
        height: 4,
      },
      shadowOpacity: 0.30,
      shadowRadius: 4.65,
      elevation: 8,
    },
  }
};

const darkTheme = {
  ...lightTheme,
  colors: {
    ...lightTheme.colors,
    primary: '#64B5F6',
    primaryDark: '#42A5F5',
    secondary: '#FFB74D',
    accent: '#FF7043',
    background: '#121212',
    surface: '#1E1E1E',
    text: '#FFFFFF',
    textSecondary: '#B0B0B0',
    border: '#333333',
    mentalHealth: {
      calm: '#1B5E20',
      anxiety: '#E65100',
      depression: '#0D47A1',
      therapy: '#4A148C',
      wellness: '#00695C'
    }
  }
};

export const theme = lightTheme;
export const darkTheme = darkTheme;
export const colors = lightTheme.colors;
export const spacing = lightTheme.spacing;
export const shadows = lightTheme.shadows;