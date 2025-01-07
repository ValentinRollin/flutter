import 'package:flutter/material.dart';
import 'package:tp2meteo/styles/colors.dart';

// Tailles d'objet
// Theme

// STYLE TEXTE
const scoreStyle = TextStyle(
  fontSize: 24, // Taille de police du score
  fontWeight: FontWeight.bold, // Graisse du texte
);
const resultatStyle = TextStyle(
  fontSize: 24, // Taille de police du score
  fontWeight: FontWeight.bold, // Graisse du texte
  color: fushiaClaire,
);
const menuTextStyle = TextStyle(
  fontSize: 27,
  fontWeight: FontWeight.bold,
  color: fushia, // Taille de la police
);
const menuTitreGroupe = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: fushiaGrey, // Taille de la police
);
const titreMenuBoutonStyle = TextStyle(
  fontSize: 20, // Taille de la police
);
const scoreTextStyle = TextStyle(
  fontSize: 24,
  color: fushia,
  fontWeight: FontWeight.bold,
);
const questionTextStyle = TextStyle(
  color: Colors.white, // Couleur du texte
  fontSize: 18.0, // Taille de police
  fontWeight: FontWeight.bold, // Graisse du texte
);
const textTitreStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
const textBodyStyle = TextStyle(
  fontSize: 16,
);
const textVilleStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
);
const textDateStyle = TextStyle(
  fontSize: 25,
);
const textTempStyle = TextStyle(
  fontSize: 40,
);
const textWeatherCurrentStyle = TextStyle(
  fontSize: 18,
);
const textWeatherFutureStyle = TextStyle(
  fontSize: 16.0,
);
const textDayFutureStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const textThemePersonel = TextTheme(
  titleLarge: textTitreStyle, // Exemple de style de texte
  bodyMedium: textBodyStyle, // Autre exemple de style de texte
);
var themePersonalise = ThemeData(
  primarySwatch: MaterialColor(
    fushia.value,
    <int, Color>{
      50: fushia.withOpacity(0.1),
      100: fushia.withOpacity(0.2),
      200: fushia.withOpacity(0.3),
      300: fushia.withOpacity(0.4),
      400: fushia.withOpacity(0.5),
      500: fushia.withOpacity(0.6),
      600: fushia.withOpacity(0.7),
      700: fushia.withOpacity(0.8),
      800: fushia.withOpacity(0.9),
      900: fushia,
    },
  ), // Couleur principale de l'application
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto', // Police de caractères par défaut
  textTheme: textThemePersonel,
);

// Box ombre
const boxShadow = BoxShadow(
  color: fushiaClaire,
  blurRadius: 5,
);

// Marges / Padding
const margePaddingAll50 = EdgeInsets.all(50);
const margePaddingAll10 = EdgeInsets.all(10);
const margePaddingAll75 = EdgeInsets.all(75);
const margePaddingAll20 = EdgeInsets.all(20);
// Espace verticale
const espaceVFixe3 = SizedBox(height: 3);
const espaceVFixe5 = SizedBox(height: 5);
const espaceVFixe10 = SizedBox(height: 10);
const espaceVFixe20 = SizedBox(height: 20);
const espaceVFixe30 = SizedBox(height: 30);
const espaceVFixe50 = SizedBox(height: 50);
// Espace horizontale
const espaceHFixe3 = SizedBox(width: 3);
const espaceHFixe5 = SizedBox(width: 5);
const espaceHFixe10 = SizedBox(width: 10);
const espaceHFixe20 = SizedBox(width: 20);
const espaceHFixe50 = SizedBox(width: 50);

// Bord
const edgeInsets20 = EdgeInsets.all(20.0);

// TAILLE
const sizeButton = Size(200, 50);