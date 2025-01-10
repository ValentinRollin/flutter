import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Pour le formatage des dates
import 'package:tp2meteo/styles/styles.dart';
import 'package:intl/date_symbol_data_local.dart'; // Pour initialiser les locales

// Modèle de données WeatherModel
class WeatherModel {
  String? cod;
  int? message;
  int? cnt;
  List<WeatherList>? list;
  City? city;

  WeatherModel({this.cod, this.message, this.cnt, this.list, this.city});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    message = json['message'];
    cnt = json['cnt'];
    if (json['list'] != null) {
      list = <WeatherList>[];
      json['list'].forEach((v) {
        list!.add(WeatherList.fromJson(v));
      });
    }
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    return data;
  }
}

// Classe pour la liste des prévisions
class WeatherList {
  int? dt;
  Main? main;
  List<WeatherData>? weather;
  String? dtTxt;

  WeatherList({
    this.dt,
    this.main,
    this.weather,
    this.dtTxt,
  });

  WeatherList.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    if (json['weather'] != null) {
      weather = <WeatherData>[];
      json['weather'].forEach((v) {
        weather!.add(WeatherData.fromJson(v));
      });
    }
    dtTxt = json['dt_txt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    if (main != null) {
      data['main'] = main!.toJson();
    }
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['dt_txt'] = dtTxt;
    return data;
  }
}

// Classe représentant les données principales (température, humidité)
class Main {
  num? temp;
  int? humidity;

  Main({
    this.temp,
    this.humidity,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['humidity'] = humidity;
    return data;
  }
}

// Classe pour décrire les données météorologiques détaillées (description, icône)
class WeatherData {
  String? main;
  String? description;
  String? icon;

  WeatherData({
    this.main,
    this.description,
    this.icon,
  });

  WeatherData.fromJson(Map<String, dynamic> json) {
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

// Classe représentant la ville
class City {
  String? name;

  City({
    this.name,
  });

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

// Fonction pour récupérer les données météo via l'API OpenWeather
Future<WeatherModel> getWeatherData(String cityName) async {
  final String apiKey = 'cfe1aac4b41f4746416078cf77ab4060'; // Remplacez par votre clé API
  final url =
      "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric&lang=fr";


  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return WeatherModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}

// Page principale pour afficher les données météo
class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  WeatherModel? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  void _fetchWeatherData(String cityName) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      WeatherModel data = await getWeatherData(cityName);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return DateFormat('EEEE, d MMM y', 'fr_FR').format(date);
  }

  List<Map<String, dynamic>> _getFutureDaysData() {
    List<Map<String, dynamic>> futureDays = [];
    if (weatherData != null && weatherData!.list != null) {
      // Collecte les prévisions pour les jours suivants
      for (int i = 1; i < weatherData!.list!.length; i += 8) {
        var dailyData = weatherData!.list![i];
        futureDays.add({
          'date': _formatDate(dailyData.dt!),
          'temp_min': dailyData.main!.temp,
          'temp_max': dailyData.main!.temp,
          'humidity': dailyData.main!.humidity!,
          'weather': dailyData.weather![0].main!,
          'icon': dailyData.weather![0].icon!,
        });
      }
    }
    return futureDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App', style: menuTextStyle), // Utilisation du style de texte défini
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de texte pour la ville
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'Entrez une ville',
                border: OutlineInputBorder(), // Ajout d'une bordure arrondie
                prefixIcon: Icon(Icons.search), // Icône de recherche
              ),
              onSubmitted: (value) {
                _fetchWeatherData(value);
                _cityController.clear();
              },
            ),
            const SizedBox(height: 20),

            // Affichage des informations météo
            isLoading
                ? const CircularProgressIndicator()
                : weatherData == null
                    ? Text(errorMessage.isNotEmpty ? errorMessage : "Aucune donnée", style: textWeatherCurrentStyle)
                    : Column(
                        children: [
                          Text(weatherData!.city!.name!, style: textVilleStyle),
                          Text(_formatDate(weatherData!.list![0].dt!), style: textDateStyle),
                          const SizedBox(height: 20),
                          Text(
                            'Température: ${weatherData!.list![0].main!.temp}°C',
                            style: textTempStyle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Humidité: ${weatherData!.list![0].main!.humidity}%',
                            style: textWeatherCurrentStyle,
                          ),
                          const SizedBox(height: 20),
                          Image.network(
                            'https://openweathermap.org/img/wn/${weatherData!.list![0].weather![0].icon}@2x.png',
                            width: 80,  // Agrandissement de l'icône
                            height: 80,
                          ),
                          const SizedBox(height: 20),
                          const Text("Prévisions des jours suivants:", style: textDayFutureStyle),
                          const SizedBox(height: 10),

                          // Affichage des prévisions horizontales
                          SizedBox(
                            height: 250,  // Hauteur de la section des prévisions
                            child: ListView(
                              scrollDirection: Axis.horizontal,  // Défilement horizontal
                              children: _getFutureDaysData().map((dayData) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 8.0), 
                                  color: Color(0xFFE1C6D1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(dayData['date'], style: textDayFutureStyle),
                                        Text("Min: ${dayData['temp_min']}°C", style: textWeatherFutureStyle),
                                        Text("Max: ${dayData['temp_max']}°C", style: textWeatherFutureStyle),
                                        Text("Humidité: ${dayData['humidity']}%", style: textWeatherFutureStyle),
                                        Text(dayData['weather'], style: textWeatherFutureStyle),
                                        Image.network(
                                          'https://openweathermap.org/img/wn/${dayData['icon']}@2x.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}

// Fonction principale
void main() async {
  // Initialisation des données locales avant d'utiliser le formatage de date
  await initializeDateFormatting('fr_FR', null);

  runApp(MaterialApp(
    home: WeatherPage(), // Page de la météo
    theme: themePersonalise,
  ));
}
