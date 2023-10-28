import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'crear_anuncio.dart'; // Importa la página de Crear Anuncio

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  late Position _currentPosition;
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Activar Ubicación'),
            content: Text(
              'Por favor, active los servicios de ubicación para usar esta aplicación.',
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
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Permiso de Ubicación Denegado'),
              content: Text(
                'Debes otorgar permisos de ubicación para usar esta aplicación.',
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
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null && mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  Future<void> _searchLocation() async {
    List<Location> locations =
        await locationFromAddress(_addressController.text);
    if (locations.isNotEmpty) {
      Location location = locations[0];
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 14.0,
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dirección no encontrada'),
            content: Text('No se pudo encontrar la dirección ingresada.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Buscar dirección'),
          ),
          ElevatedButton(
            onPressed: _searchLocation,
            child: Text('Buscar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrearAnuncioPage(
                      location: _currentPosition), // Pasa la ubicación
                ),
              );
            },
            child: Text('Crear Anuncio'),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition?.latitude ?? 0.0,
                  _currentPosition?.longitude ?? 0.0,
                ),
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
