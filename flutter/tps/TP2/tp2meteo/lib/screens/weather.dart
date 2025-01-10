class Weather {
  final String city;
  final String date;
  final String icon;
  final double temperature;
  final double precipitation;
  final double humidity;

  Weather({
    required this.city,
    required this.date,
    required this.icon,
    required this.temperature,
    required this.precipitation,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      date: DateTime.now().toIso8601String(),
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
      precipitation: json['rain'] != null ? json['rain']['1h'].toDouble() : 0.0,
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}
