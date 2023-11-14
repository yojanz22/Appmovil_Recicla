import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'crear_anuncio.dart';
import 'mapa2.dart';
import 'mapa_zona.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position _currentPosition;
  bool _locationObtained = false;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceAlert();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationPermissionAlert();
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _locationObtained = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      setState(() {
        _locationObtained = true;
      });
    });
  }

  void _showLocationServiceAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Servicio de ubicación deshabilitado'),
          content: Text(
            'Por favor, active el servicio de ubicación en la configuración de su dispositivo.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permisos de ubicación denegados'),
          content: Text(
            'Por favor, habilite los permisos de ubicación en la configuración de su dispositivo.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.green[700],
      ),
      body: _locationObtained ? buildMainScreen() : buildLoadingScreen(),
    );
  }

  Widget buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cargando mapa...',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(), // Puedes personalizar este indicador de carga
        ],
      ),
    );
  }

  Widget buildMainScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_locationObtained) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Mapa2Page(location: _currentPosition),
                    ),
                  );
                }
              },
              icon: Icon(Icons.map, size: 60),
              label: Text('Ver productos en el mapa'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 116, 23, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20), // Espacio entre los botones
          ElevatedButton.icon(
            onPressed: () {
              if (_locationObtained) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapaZonasPage(),
                  ),
                );
              }
            },
            icon: Icon(Icons.map, size: 60),
            label: Text('Ir al Mapa de Zonas'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 50, 5, 156),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20), // Espacio entre los botones
          SizedBox(
            width: 150,
            height: 150,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_locationObtained) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CrearAnuncioPage(location: _currentPosition),
                    ),
                  );
                }
              },
              icon: Icon(Icons.add, size: 60),
              label: Text('Crear una alerta'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
