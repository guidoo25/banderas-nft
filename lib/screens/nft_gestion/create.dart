import 'package:NFT/providers/web3provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:NFT/configs/config.dart';

class NftScreen extends StatefulWidget {
  const NftScreen({Key? key}) : super(key: key);

  @override
  _NftScreenState createState() => _NftScreenState();
}

// Configuración de Cloudinary (reemplaza con tus credenciales)
var cloudinary =
    CloudinaryPublic(Enviroments.cloudinaruser, 'onghmgzh', cache: false);

class _NftScreenState extends State<NftScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    final contract = NFTContract();

    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Imagen'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                // Seleccionar imagen desde la galería
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Subir la imagen a Cloudinary
                  CloudinaryResponse response = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(image.path,
                        resourceType: CloudinaryResourceType.Image),
                  );
                  setState(() {
                    _uploadedImageUrl = response.secureUrl;
                  });
                }
                print('Imagen seleccionada: $image');
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
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
