import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      title: 'Firebase Analytics Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = FirebaseAnalytics.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Analytics Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await FirebaseAnalytics.instance.logEvent(
                name: 'custom_test_event',
                parameters: {'test_key': 'test_value'},
              );
              print('🔥 Analytics event logged successfully!');
            } catch (e) {
              print('❌ Failed to log analytics event: $e');
            }
          },
          child: const Text('Log Event'),
        ),
      ),
    );
  }
}
