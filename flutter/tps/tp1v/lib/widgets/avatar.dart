import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 44,
      backgroundImage: const AssetImage('assets/pp.jpg'),
      onBackgroundImageError: (exception, stackTrace) {
        print('Erreur lors du chargement de l\'image : $exception');
      },
    );
  }
}
