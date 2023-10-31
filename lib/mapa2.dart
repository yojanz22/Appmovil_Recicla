import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mapa2Page extends StatefulWidget {
  final Position location;

  Mapa2Page({required this.location});

  @override
  _Mapa2PageState createState() => _Mapa2PageState();
}

class _Mapa2PageState extends State<Mapa2Page> {
  GoogleMapController? _controller;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    _loadMarkersFromFirestore();
  }

  void _showProductInfo(String nombre, String descripcion, String direccion,
      String tipoDeMaterial) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nombre), // Muestra el nombre del producto como título
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descripción: $descripcion"),
              Text("Dirección: $direccion"),
              Text("Tipo de Material: $tipoDeMaterial"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _loadMarkersFromFirestore() {
    FirebaseFirestore.instance
        .collection('producto')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final GeoPoint ubicacion = data['ubicacion'] as GeoPoint;
        final String nombre = data['nombre'] as String;
        final String descripcion = data['descripcion'] as String;
        final String direccion = data['direccion'] as String;
        final String tipoDeMaterial = data['tipoDeMaterial'] as String;

        _markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(ubicacion.latitude, ubicacion.longitude),
          infoWindow: InfoWindow(
            title: nombre, // Agrega el título del marcador
          ),
          onTap: () {
            _showProductInfo(nombre, descripcion, direccion, tipoDeMaterial);
          },
        ));

        setState(() {
          _markers = _markers;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
      ),
    );
  }
}
