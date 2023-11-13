import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MapaZonasPage extends StatefulWidget {
  @override
  _MapaZonasPageState createState() => _MapaZonasPageState();
}

class _MapaZonasPageState extends State<MapaZonasPage> {
  GoogleMapController? _controller;
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Marker> _markers = Set<Marker>();

  Map<String, List<LatLng>> materialLocations = {
    'Plásticos': [],
    'Papeles y Cartón': [],
    'Vidrio': [],
    'Lata': [],
  };

  Map<String, int> materialCount = {
    'Plásticos': 0,
    'Papeles y Cartón': 0,
    'Vidrio': 0,
    'Lata': 0,
  };

  bool messageDisplayed = false;

  @override
  void initState() {
    super.initState();
    _loadZonasFromFirebase();
  }

  void _loadZonasFromFirebase() {
    FirebaseFirestore.instance
        .collection('producto')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GeoPoint geoPoint = doc['ubicacion'];
        LatLng location = LatLng(geoPoint.latitude, geoPoint.longitude);
        String tipoMaterial = doc['tipoDeMaterial'];
        materialLocations[tipoMaterial]!.add(location);

        int valorUnidad = int.parse(doc['valorUnidad']);
        _updateMaterialCount(tipoMaterial, valorUnidad);
      });

      _createPolygons();
    }).catchError((error) {
      print('Error fetching locations: $error');
    });
  }

  void _updateMaterialCount(String material, int valorUnidad) {
    materialCount[material] = (materialCount[material] ?? 0) + valorUnidad;
    if (materialCount[material]! >= 1000 && !messageDisplayed) {
      _showMessage(material);
      messageDisplayed = true;
    }
  }

  void _showMessage(String material) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('¡Límite alcanzado!'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('El material $material ha alcanzado 1000 unidades.'),
              SizedBox(height: 10),
              Card(
                color: determineColorForMaterial(material),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '¡Meta alcanzada para $material!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Ir a la ubicación'),
                onPressed: () {
                  _goToLocation(material);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToLocation(String material) {
    List<LatLng> locations = materialLocations[material]!;
    if (locations.isNotEmpty) {
      LatLng materialLocation = locations
          .first; // Obtén la primera ubicación del material (puedes personalizar esta lógica)
      _controller!.animateCamera(CameraUpdate.newLatLng(materialLocation));
    }
  }

  void _createPolygons() {
    materialLocations.forEach((material, locations) {
      List<List<LatLng>> groupedLocations = [];

      for (int i = 0; i < locations.length; i++) {
        bool added = false;

        for (int j = 0; j < groupedLocations.length; j++) {
          for (int k = 0; k < groupedLocations[j].length; k++) {
            double distance =
                _calculateDistance(locations[i], groupedLocations[j][k]);
            if (distance <= 0.1) {
              groupedLocations[j].add(locations[i]);
              added = true;
              break;
            }
          }
        }

        if (!added) {
          groupedLocations.add([locations[i]]);
        }
      }

      for (int i = 0; i < groupedLocations.length; i++) {
        Color polygonColor = determineColorForMaterial(material);

        final polygon = Polygon(
          polygonId: PolygonId('Zona $material $i'),
          points: groupedLocations[i],
          strokeWidth: 2,
          strokeColor: polygonColor,
          fillColor: polygonColor.withOpacity(0.3),
        );

        setState(() {
          _polygons.add(polygon);
        });

        if (materialCount[material]! >= 1000) {
          LatLng zoneCenter = _calculateZoneCenter(groupedLocations[i]);

          final marker = Marker(
            markerId: MarkerId('Marker $material $i'),
            position: zoneCenter,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            onTap: () {
              _showZoneInfo(material, i);
            },
          );

          setState(() {
            _markers.add(marker);
          });
        }
      }
    });
  }

  Color determineColorForMaterial(String material) {
    switch (material) {
      case 'Plásticos':
        return Colors.blue;
      case 'Papeles y Cartón':
        return Colors.green;
      case 'Vidrio':
        return Colors.yellow;
      case 'Lata':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const int earthRadius = 6371;
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  LatLng _calculateZoneCenter(List<LatLng> zonePoints) {
    double lat = 0;
    double lng = 0;

    for (var point in zonePoints) {
      lat += point.latitude;
      lng += point.longitude;
    }

    return LatLng(lat / zonePoints.length, lng / zonePoints.length);
  }

  void _showZoneInfo(String material, int zoneIndex) {
    // Aquí podrías implementar la lógica para mostrar información detallada
    // sobre la zona, como el material, índice de zona, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Zonas'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-33.030, -71.556),
          zoom: 14,
        ),
        polygons: _polygons,
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
