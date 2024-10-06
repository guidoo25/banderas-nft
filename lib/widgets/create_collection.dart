import 'dart:convert';

import 'package:NFT/providers/api_contract.dart';
import 'package:NFT/screens/nft_secure/secure_nft.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:NFT/utils/image_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateCollection extends StatefulWidget {
  const CreateCollection({Key? key}) : super(key: key);

  @override
  State<CreateCollection> createState() => _CreateCollectionState();
}

class _CreateCollectionState extends State<CreateCollection> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  bool state = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedRareza;
  final cloudinary = CloudinaryPublic('dfha4roeg', 'onghmgzh', cache: false);
  List<String> rarezas = ['1', '2', '3', '4', '5'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create NFT Collection'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del formulario
                const Text(
                  "Crea tu nft",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Campo de texto para el nombre de la colección
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "pais",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a collection name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de texto para la descripción
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "paisaje",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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

                // Título para la sección de imagen
                const Text(
                  "sube imagen de nft",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Subir imagen con borde punteado
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [10, 5],
                  strokeWidth: 2,
                  color: Colors.deepPurpleAccent,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "PNG, JPG; Max Size: 100MB",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              try {
                                CloudinaryResponse response =
                                    await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(image.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );
                                setState(() {
                                  _uploadedImageUrl = response.secureUrl;
                                });
                              } catch (e) {
                                print("Error subir imagen: $e");
                              }
                            }
                          },
                          child: _uploadedImageUrl == null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "subir Imagen",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Image.network(
                                  _uploadedImageUrl!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón para enviar el formulario
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // final uuid = Uuid().v4();
                      if (_formKey.currentState?.validate() ?? false) {
                        final json = await createNFTJson(
                          _nameController.text,
                          _descriptionController.text,
                          _uploadedImageUrl!,
                          selectedRareza!,
                        );
                        await NftApiService().storeNFT(json);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Crear NFT",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> createNFTJson(String pais, String paisaje,
    String uploadedImageUrl, String selectedRareza) async {
  final json = {
    "pais": "$pais",
    "description": "$pais",
    "image": uploadedImageUrl,
    "rareza": selectedRareza,
  };
  return jsonEncode(json);
}
