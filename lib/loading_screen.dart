import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool success;

  LoadingScreen({required this.success});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black.withOpacity(0.5), // Fondo ligeramente oscurecido
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            success
                ? Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Anuncio creado exitosamente',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Creando anuncio...',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
