import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Vivencias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VivenciaListScreen(),
    );
  }
}

class VivenciaListScreen extends StatefulWidget {
  const VivenciaListScreen({Key? key}) : super(key: key);

  @override
  _VivenciaListScreenState createState() => _VivenciaListScreenState();
}

class _VivenciaListScreenState extends State<VivenciaListScreen> {
  List<Vivencia> vivencias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vivencias'),
      ),
      body: ListView.builder(
        itemCount: vivencias.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(vivencias[index].titulo),
            subtitle: Text(vivencias[index].fecha),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VivenciaDetailScreen(vivencia: vivencias[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Vivencia? nuevaVivencia = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VivenciaFormScreen(),
            ),
          );
          if (nuevaVivencia != null) {
            setState(() {
              vivencias.add(nuevaVivencia);
            });
          }
        },
      ),
    );
  }
}

class Vivencia {
  final String titulo;
  final String fecha;
  final String descripcion;
  final String foto;
  final String audio;

  Vivencia({
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.foto,
    required this.audio,
  });
}

class VivenciaDetailScreen extends StatelessWidget {
  final Vivencia vivencia;

  const VivenciaDetailScreen({Key? key, required this.vivencia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vivencia.titulo),
      ),
      body: Column(
        children: [
          Text(vivencia.fecha),
          Text(vivencia.descripcion),
          Image.network(vivencia.foto),
          Text(vivencia.audio),
        ],
      ),
    );
  }
}

class VivenciaFormScreen extends StatefulWidget {
  const VivenciaFormScreen({Key? key}) : super(key: key);

  @override
  _VivenciaFormScreenState createState() => _VivenciaFormScreenState();
}

class _VivenciaFormScreenState extends State<VivenciaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String titulo = '';
  String fecha = '';
  String descripcion = '';
  String? foto;
  String audio = '';

  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        foto = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Vivencia'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el título';
                  }
                  return null;
                },
                onSaved: (value) {
                  titulo = value!;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la fecha';
                  }
                  return null;
                },
                onSaved: (value) {
                  fecha = value!;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  descripcion = value!;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      foto = pickedImage.path;
                    });
                  }
                },
                child: const Text('Capturar Foto'),
              ),
            ),
            if (foto != null)
              Container(
                margin: const EdgeInsets.all(16.0),
                child: Image.file(
                  File(foto!),
                  width: 200,
                  height: 200,
                ),
              ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Audio'),
                onSaved: (value) {
                  audio = value!;
                },
              ),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Vivencia nuevaVivencia = Vivencia(
                    titulo: titulo,
                    fecha: fecha,
                    descripcion: descripcion,
                    foto: foto ?? '',
                    audio: audio,
                  );
                  Navigator.pop(context, nuevaVivencia);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}