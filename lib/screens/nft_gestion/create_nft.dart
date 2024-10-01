import 'package:NFT/providers/interactContract.dart';
import 'package:NFT/providers/web3provider.dart';
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
    return FutureBuilder(
      future: ref.watch(meaningProvider.notifier).initialize(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar el contrato'));
        } else {
          final nftContract = ref.watch(meaningProvider.notifier);
          return _buildForm(nftContract);
        }
      },
    );
  }

  Widget _buildForm(MeaningNotifier nftContract) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Imagen'),
        backgroundColor: Colors.green,
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
                ],
              ),
            ),
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
                    await nftContract.mintNFT(
                      1, // Cantidad de NFTs a mintear
                      1, // Rareza
                      _uploadedImageUrl!, // URL de la imagen
                      _paisController.text, // País
                      _paisajeController.text, // Paisaje
                    );
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
