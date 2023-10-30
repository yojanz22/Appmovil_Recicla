import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
            _markers.add(
              Marker(
                markerId: MarkerId('ubicacion'),
                position:
                    LatLng(widget.location.latitude, widget.location.longitude),
              ),
            );
          });
        },
      ),
    );
  }
}
