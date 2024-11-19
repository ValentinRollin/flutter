import 'package:flutter/material.dart';
import 'avatar.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 350,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gradient Container autour de l'Avatar
            Container( // Container pour ajouter le degradé autour de l'avatar
              padding: const EdgeInsets.all(4), // Espace entre le gradient et l'avatar
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Avatar(), // L'Avatar reste au centre
            ),
            const SizedBox(height: 10),
            const Text(
              'STINSON Barney',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'barney.stinson@etu.umontpellier.fr',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const Text(
              'twitter: @BarneyStinson',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
