#include <TFT_eSPI.h> // Bibliothèque pour l'écran intégré TTGO T-Display
#include <SPI.h>

// Définition des broches
#define LED_PIN 13
#define PHOTOCELL_PIN 39
#define THERMISTOR_PIN 38

// Seuil brut pour la température
const int tempRawThreshold = 30;

// Initialisation de l'écran
TFT_eSPI tft = TFT_eSPI();

void setup() {
    Serial.begin(115200);

    // Configuration des broches
    pinMode(LED_PIN, OUTPUT);
    pinMode(PHOTOCELL_PIN, INPUT);
    pinMode(THERMISTOR_PIN, INPUT);

    // Initialisation de l'écran
    tft.init();
    tft.setRotation(1); // Orientation horizontale
    tft.fillScreen(TFT_BLACK); // Effacer l'écran
    tft.setTextColor(TFT_WHITE, TFT_BLACK); // Texte blanc sur fond noir
    tft.setTextSize(2); // Taille du texte

    Serial.println("Système démarré : Affichage des capteurs et contrôle de la LED.");
}

void loop() {
    // Lecture brute des capteurs
    int lightValue = analogRead(PHOTOCELL_PIN);
    int tempRawValue = analogRead(THERMISTOR_PIN);

    // Contrôle de la LED en fonction de la température
    if (tempRawValue > tempRawThreshold) {
        digitalWrite(LED_PIN, HIGH); // Allume la LED si la température dépasse le seuil
    } else {
        digitalWrite(LED_PIN, LOW); // Éteint la LED sinon
    }

    // Affichage des données sur le moniteur série
    Serial.print("Luminosité (brute): ");
    Serial.print(lightValue);
    Serial.print(" | Température (brute): ");
    Serial.println(tempRawValue);

    // Affichage sur l'écran du TTGO
    tft.fillScreen(TFT_BLACK); // Effacer l'écran pour un affichage propre

    tft.setCursor(0, 0); // Position de départ
    tft.println("Capteurs TTGO");

    tft.setCursor(0, 30); // Affichage de la luminosité
    tft.printf("Luminosite: %d", lightValue);

    tft.setCursor(0, 60); // Affichage de la température brute
    tft.printf("Temp brute: %d", tempRawValue);

    tft.setCursor(0, 90); // Affichage de l'état de la LED
    if (tempRawValue > tempRawThreshold) {
        tft.println("LED: ALLUMEE");
    } else {
        tft.println("LED: ETEINTE");
    }

    delay(1000); // Pause avant le prochain cycle
}
