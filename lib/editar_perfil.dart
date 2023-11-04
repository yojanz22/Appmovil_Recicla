import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfilPage extends StatefulWidget {
  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  DocumentReference? userDataRef;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.displayName ?? '';
        _emailController.text = user.email ?? '';
        userDataRef =
            FirebaseFirestore.instance.collection('registro').doc(user.uid);
      });
    }
  }

  Future<void> updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && userDataRef != null) {
      try {
        // Actualiza el nombre del usuario en Firebase Authentication
        await user.updateProfile(displayName: _nameController.text);

        // Si se proporciona una nueva contraseña, cámbiala
        if (_newPasswordController.text.isNotEmpty) {
          await user.updatePassword(_newPasswordController.text);
        }

        // Actualiza los valores en Firebase Firestore utilizando .set
        await userDataRef!.set({
          'nombreUsuario': _nameController.text,
          'correo': _emailController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil actualizado correctamente')),
        );

        // Regresa a la página de inicio o a donde desees después de actualizar el perfil
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario no autenticado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña Actual'),
              obscureText: true,
            ),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                updateUserProfile();
              },
              child: Text('Guardar Cambios'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
