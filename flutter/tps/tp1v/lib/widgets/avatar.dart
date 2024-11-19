import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 44,
      backgroundImage: NetworkImage('assets/pp.jpg'),
    );
  }
}