import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String? avatarUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        final data = snapshot.data();

        setState(() {
          avatarUrl = data?['avatarUrl'];
          _nameController.text = data?['name'] ?? '';
          _emailController.text = user!.email ?? '';
          _additionalInfoController.text = data?['additionalInfo'] ?? '';
        });
      } catch (e) {
        print("Erreur de récupération des données utilisateur : $e");
      }
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      try {
        final storageRef = FirebaseStorage.instance.ref('avatars/${user!.uid}.jpg');
        await storageRef.putFile(file);
        final url = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'avatarUrl': url,
        });

        setState(() {
          avatarUrl = url;
        });
      } catch (e) {
        print("Erreur lors du téléchargement de l'avatar : $e");
      }
    }
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        'additionalInfo': _additionalInfoController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données mises à jour avec succès!')),
      );
    } catch (e) {
      print("Erreur lors de la mise à jour des données utilisateur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour des données.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _uploadAvatar,
                    child: const Text("Mettre à jour l'avatar"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email (non modifiable)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _additionalInfoController,
              decoration: InputDecoration(
                labelText: 'Informations supplémentaires',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}


