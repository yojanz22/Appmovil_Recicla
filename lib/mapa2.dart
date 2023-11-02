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
    _loadCustomMarkersFromFirestore();
  }

  Marker _buildCustomMarker(String nombre, double latitud, double longitud) {
    return Marker(
      markerId: MarkerId(nombre),
      position: LatLng(latitud, longitud),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(
        title: nombre,
      ),
      onTap: () {
        _showProductInfo(nombre);
      },
    );
  }

  void _loadCustomMarkersFromFirestore() {
    FirebaseFirestore.instance
        .collection('producto')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final GeoPoint ubicacion = data['ubicacion'] as GeoPoint;
        final String nombre = data['nombre'] as String;

        final customMarker = _buildCustomMarker(
          nombre,
          ubicacion.latitude,
          ubicacion.longitude,
        );

        setState(() {
          _markers.add(customMarker);
        });
      });
    });
  }

  void _showProductInfo(String nombre) {
    // Implementa la lógica para mostrar información detallada sobre el producto aquí.
    // Puedes usar un cuadro de diálogo o un widget personalizado.
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
