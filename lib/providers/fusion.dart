import 'dart:typed_data';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageGenerationNotifier extends StateNotifier<ImageGenerationState> {
  ImageGenerationNotifier() : super(ImageGenerationState());

  var cloudinary = CloudinaryPublic('dfha4roeg', 'onghmgzh', cache: false);

  Future<String?> textToImage(
      String pais1, String pais2, String paisaje) async {
    String baseprompt =
        "Create a realistic art piece of a pole flag that combines elements from the countries $pais1 and $pais2. The flag should be set against a backdrop of $paisaje landscapes, showcasing the interior style and natural beauty of these regions.";
    String engineId = "stable-diffusion-v1-6";
    String apiHost = 'https://api.stability.ai';
    String apiKey = 'sk-SISMU3GHhmv27DBV6NeujZ9gqjIaffwDPxANS0WvEaXHLVJo';
    debugPrint(baseprompt);

    state = state.copyWith(isLoading: true, isSearching: true);

    final response = await http.post(
      Uri.parse('$apiHost/v1/generation/$engineId/text-to-image'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "image/png",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "text_prompts": [
          {"text": baseprompt, "weight": 1}
        ],
        "cfg_scale": 7,
        "height": 1024,
        "width": 1024,
        "samples": 1,
        "steps": 30,
      }),
    );

    if (response.statusCode == 200) {
      try {
        debugPrint(response.statusCode.toString());
        Uint8List imageData = response.bodyBytes;

        // Guardar la imagen como un archivo temporal
        final tempDir = await getTemporaryDirectory();
        final filePath = path.join(tempDir.path, 'generated_image.jpg');
        final file = File(filePath);
        await file.writeAsBytes(imageData);

        CloudinaryResponse uploadResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            filePath,
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        debugPrint('Imagen subida a Cloudinary: ${uploadResponse.secureUrl}');
        state = state.copyWith(
            imageData: imageData,
            isLoading: false,
            isSearching: false,
            url: uploadResponse.secureUrl);
        return uploadResponse.secureUrl;
      } catch (e) {
        debugPrint("Error generando o subiendo imagen: $e");
        state = state.copyWith(isLoading: false, isSearching: false);
        return null;
      }
    } else {
      debugPrint("Error en la generación de imagen");
      state = state.copyWith(isLoading: false, isSearching: false);
      return null;
    }
  }
}

class ImageGenerationState {
  final Uint8List? imageData;
  final bool isLoading;
  final bool isSearching;
  final String? url;

  ImageGenerationState({
    this.imageData,
    this.isLoading = false,
    this.isSearching = false,
    this.url,
  });

  ImageGenerationState copyWith({
    Uint8List? imageData,
    bool? isLoading,
    bool? isSearching,
    String? url,
  }) {
    return ImageGenerationState(
      imageData: imageData ?? this.imageData,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      url: url ?? this.url,
    );
  }
}

final imageGenerationProvider =
    StateNotifierProvider<ImageGenerationNotifier, ImageGenerationState>(
  (ref) => ImageGenerationNotifier(),
);
