import 'package:flutter/material.dart';

class CrearPointPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Punto de Reciclaje'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '¿Qué deseas hacer?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TengoProductosParaReciclar(),
                  ),
                );
              },
              child: Text('Tengo productos para reciclar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TengoLugarParaReciclar(),
                  ),
                );
              },
              child: Text('Tengo un lugar para reciclar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TengoProductosParaReciclar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? selectedMaterial; // Cambiado a String?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tengo Productos para Reciclar'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '¿Qué tienes para reciclar?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                items: ['Vidrio', 'Papel', 'Metal'].map((material) {
                  return DropdownMenuItem<String>(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedMaterial = value;
                },
                decoration: InputDecoration(labelText: 'Tipo de material'),
                validator: (value) {
                  if (value == null) {
                    return 'Este campo es obligatorio.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción del producto',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cantidad que tienes',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí puedes acceder a la información del formulario
                    print('Tipo de material: $selectedMaterial');
                  }
                },
                child: Text('Esto tengo para reciclar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TengoLugarParaReciclar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tengo Lugar para Reciclar'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Describe el lugar para reciclar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Ubicación del lugar para reciclar',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Agregar lógica para "Esto quiero reciclar"
              },
              child: Text('Esto quiero reciclar'),
            ),
          ],
        ),
      ),
    );
  }
}
