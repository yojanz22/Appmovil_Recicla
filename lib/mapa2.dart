import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recicla/chat.dart';

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

  Marker _buildCustomMarker(
      String nombre, double latitud, double longitud, String tipoMaterial) {
    BitmapDescriptor markerIcon;

    switch (tipoMaterial.toLowerCase()) {
      case 'plásticos':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        break;
      case 'papeles y cartón':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        break;
      case 'vidrio':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        break;
      case 'lata':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
        break;
      // Agrega más casos según tus necesidades
      default:
        markerIcon = BitmapDescriptor.defaultMarker;
        break;
    }

    return Marker(
      markerId: MarkerId(nombre),
      position: LatLng(latitud, longitud),
      icon: markerIcon,
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
        final String nombre = data['nombreProducto'] as String;
        final String tipoMaterial = data['tipoDeMaterial'] as String;

        final customMarker = _buildCustomMarker(
          nombre,
          ubicacion.latitude,
          ubicacion.longitude,
          tipoMaterial,
        );

        setState(() {
          _markers.add(customMarker);
        });
      });
    });
  }

  void _showProductInfo(String nombre) {
    FirebaseFirestore.instance
        .collection('producto')
        .where('nombreProducto', isEqualTo: nombre)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final producto =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                nombre, // Aquí se mostrará el nombre del producto
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Descripción: ${producto['descripcion']}'),
                  Text('Tipo de Material: ${producto['tipoDeMaterial']}'),
                  Text(
                      'Valor de Unidad: Peso de ${producto['valorUnidad']} KG'),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    final nombreUsuario = producto['nombreUsuario'];
                    final userId = ''; // Puedes llenar esto si es necesario
                    final otherUserId =
                        ''; // Puedes llenar esto si es necesario

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatPage(
                        nombreUsuario: nombreUsuario,
                        userId: userId,
                        otherUserId: otherUserId,
                      ),
                    ));
                  },
                  child: Text('Hablar con la persona'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      print('Error al obtener información del producto: $error');
    });
  }

  Widget _buildMaterialLegend() {
    final List<String> tiposDeMaterial = [
      'Plásticos',
      'Papeles y Cartón',
      'Vidrio',
      'Lata'
    ];

    return Positioned(
      top: 16.0,
      left: 16.0,
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipos de Materiales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: tiposDeMaterial.length,
                  itemBuilder: (context, index) {
                    return _buildMaterialTile(tiposDeMaterial[index],
                        getColorForMaterial(tiposDeMaterial[index]));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorForMaterial(String material) {
    switch (material.toLowerCase()) {
      case 'plásticos':
        return Colors.red;
      case 'papeles y cartón':
        return Colors.green;
      case 'vidrio':
        return Colors.blue;
      case 'lata':
        return Colors.yellow;
      // Agrega más casos según tus necesidades
      default:
        return Colors.grey; // Color predeterminado
    }
  }

  Widget _buildMaterialTile(String material, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 10,
          ),
          SizedBox(width: 8),
          Text(
            material,
            style: TextStyle(
                fontSize: 14.0, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.latitude, widget.location.longitude),
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },
          ),
          _buildMaterialLegend(),
        ],
      ),
    );
  }
}
