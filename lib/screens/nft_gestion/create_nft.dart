import 'dart:convert';

import 'package:NFT/providers/api_contract.dart';
import 'package:NFT/providers/interactContract.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_elevated_button/loading_elevated_button.dart';

class UploadImageScreen extends ConsumerStatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

final _formkey = GlobalKey<FormState>();
final _paisController = TextEditingController();
final _paisajeController = TextEditingController();

class _UploadImageScreenState extends ConsumerState<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  String? selectedRareza;

  List<String> rarezas = ['1', '2', '3', '4', '5'];

  // Configuración de Cloudinary (reemplaza con tus credenciales)
  var cloudinary = CloudinaryPublic('dfha4roeg', 'onghmgzh', cache: false);

  @override
  void dispose() {
    _paisController.dispose();
    _paisajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _paisController,
                    decoration: InputDecoration(labelText: 'País'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del país';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _paisajeController,
                    decoration: InputDecoration(labelText: 'Paisaje'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del paisaje';
                      }
                      return null;
                    },
                  ),
                  DropdownButton(
                      hint: Text('Seleccione la rareza'),
                      items: rarezas.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRareza = value;
                        });
                      }),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                // Seleccionar imagen desde la galería
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Subir la imagen a Cloudinary
                  try {
                    CloudinaryResponse response = await cloudinary.uploadFile(
                      CloudinaryFile.fromFile(image.path,
                          resourceType: CloudinaryResourceType.Image),
                    );
                    setState(() {
                      _uploadedImageUrl = response.secureUrl;
                    });
                  } catch (e) {
                    print("Error al subir la imagen: $e");
                  }
                }
              },
              icon: Icon(Icons.photo_camera, size: 18.0),
              label: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 20),
            if (_uploadedImageUrl != null)
              Column(
                children: [
                  Text('Imagen Subida Exitosamente'),
                  SizedBox(height: 10),
                  Image.network(
                    _uploadedImageUrl!,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ), // Mostrar la imagen subida
                ],
              ),
            LoadingElevatedButton(
              onPressed: () async {
                // Verificar que el contrato esté inicializado y los datos sean válidos
                if (_formkey.currentState!.validate() &&
                    _uploadedImageUrl != null) {
                  try {
                    final json = await createNFTJson(
                        _paisController.text,
                        _paisajeController.text,
                        _uploadedImageUrl!,
                        selectedRareza!);
                    print(json);
                    await NftApiService().storeNFT(json);

                    print('NFT minteado correctamente');
                  } catch (e) {
                    print('Error al mintear el NFT: $e');
                  }
                } else {
                  print("Formulario inválido o imagen no subida");
                }
              },
              child: Text('Mintear NFT'),
            ),
          ],
        ),
      ),
    );
  }
}

//funcion genereara valor de  precio ramdon en

Future<String> createNFTJson(String pais, String paisaje,
    String uploadedImageUrl, String selectedRareza) async {
  final json = {
    "pais": "$pais",
    "description": "$paisaje",
    "image": uploadedImageUrl,
    "rareza": selectedRareza,
  };
  return jsonEncode(json);
}
