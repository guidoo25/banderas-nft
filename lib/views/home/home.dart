import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NFT/views/home/home_provider.dart';

class HomePageCrud extends ConsumerWidget {
  HomePageCrud({super.key});
  TextEditingController textController = TextEditingController();
  TextEditingController tokenIdController =
      TextEditingController(); // Para actualizar/eliminar tokens
  TextEditingController tokenURIController =
      TextEditingController(); // Para actualizar el token URI

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fWatch = ref.watch(homeProvider);
    final fRead = ref.read(homeProvider);

    return Scaffold(
      backgroundColor: const Color(0xff212121),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  'Generador de NFT con IA',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.openSans().fontFamily),
                ),
                const SizedBox(height: 30),
                // Campo de entrada para generar NFT
                _buildTextField(
                    'Ingrese la combinación de países', textController),
                const SizedBox(height: 30),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Generar NFT
                    GestureDetector(
                      onTap: () async {
                        await fRead.mintNFT(
                            textController.text, "https://link_to_image.com");
                        fRead.loadingChange(false);
                      },
                      child: _buildButton(
                          'Crear NFT', Colors.purple, Colors.purpleAccent),
                    ),
                    // Limpiar entrada
                    GestureDetector(
                      onTap: () {
                        fRead.loadingChange(false);
                        textController.clear();
                      },
                      child:
                          _buildButton('Limpiar', Colors.red, Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Obtener Tokens
                GestureDetector(
                  onTap: () async {
                    List tokens = await fRead.getAllTokens();
                    print("Tokens: $tokens");
                  },
                  child: _buildButton(
                      'Mostrar Todos los NFTs', Colors.blue, Colors.blueAccent),
                ),
                const SizedBox(height: 30),

                // Actualizar Token URI
                _buildTextField('ID del Token', tokenIdController),
                _buildTextField('Nuevo URI del Token', tokenURIController),
                GestureDetector(
                  onTap: () async {
                    await fRead.updateTokenURI(
                        int.parse(tokenIdController.text),
                        tokenURIController.text);
                  },
                  child: _buildButton(
                      'Actualizar NFT', Colors.green, Colors.greenAccent),
                ),
                const SizedBox(height: 30),

                // Eliminar Token
                GestureDetector(
                  onTap: () async {
                    await fRead.deleteNFT(int.parse(tokenIdController.text));
                  },
                  child: _buildButton(
                      'Eliminar NFT', Colors.orange, Colors.orangeAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widgets reutilizables
  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.openSans().fontFamily),
      cursorColor: Colors.white,
      maxLines: 1,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.openSans().fontFamily),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12.0)),
    );
  }

  Widget _buildButton(String label, Color color, Color gradientColor) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 160,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, gradientColor]),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.openSans().fontFamily),
      ),
    );
  }
}
