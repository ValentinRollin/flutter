import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String? selectedAvatar;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  final List<String> localAvatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
  ];

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
          selectedAvatar = data?['avatarUrl'];
          _nameController.text = data?['name'] ?? '';
          _emailController.text = user!.email ?? '';
          _additionalInfoController.text = data?['additionalInfo'] ?? '';
        });
      } catch (e) {
        print("Erreur de récupération des données utilisateur : $e");
      }
    }
  }

  Future<void> _updateAvatar(String avatarPath) async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'avatarUrl': avatarPath,
        });

        setState(() {
          selectedAvatar = avatarPath;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar mis à jour avec succès!')),
        );
      } catch (e) {
        print("Erreur lors de la mise à jour de l'avatar : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour de l\'avatar.')),
        );
      }
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
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: selectedAvatar != null
                  ? AssetImage(selectedAvatar!) as ImageProvider
                  : const AssetImage('assets/avatars/avatar1.png'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAvatarSelectionDialog();
              },
              child: const Text("Choisir un avatar"),
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
              onPressed: () {
                _updateUserData();
              },
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choisissez un avatar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: localAvatars.length,
                  itemBuilder: (context, index) {
                    final avatarPath = localAvatars[index];
                    return GestureDetector(
                      onTap: () {
                        _updateAvatar(avatarPath);
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(avatarPath),
                        radius: 40,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
}
