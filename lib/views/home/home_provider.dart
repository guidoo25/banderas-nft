import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making requests to the blockchain

final homeProvider =
    ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSearching = false;
  Uint8List? imageData;
  late Web3Client web3client;
  late DeployedContract contract;
  late Credentials credentials;
  final String rpcUrl = "http://127.0.0.1:7545"; // RPC URL de Ganache
  final String privateKey = ""; // Reemplaza con tu clave privada

  HomeProvider() {
    initWeb3();
  }

  // Inicializa la conexión con Web3 y el contrato inteligente
  Future<void> initWeb3() async {
    web3client = Web3Client(rpcUrl, Client());
    credentials = EthPrivateKey.fromHex(privateKey);

    String abiCode =
        await rootBundle.loadString("assets/MyNFT.json"); // ABI del contrato
    EthereumAddress contractAddress = EthereumAddress.fromHex(
        "DIRECCIÓN_DEL_CONTRATO"); // Dirección del contrato

    contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "MyNFT"), contractAddress);
  }

  // Crear un nuevo NFT llamando a la función mintToken
  Future<void> mintNFT(String tokenName, String tokenURI) async {
    if (contract == null) {
      print("El contrato no está inicializado");
      return;
    }

    final mintFunction = contract.function("mintToken");

    try {
      await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: mintFunction,
          parameters: [tokenName, tokenURI],
        ),
        chainId: 1337,
      );
      notifyListeners();
    } catch (e) {
      print("Error al mintar NFT: $e");
    }
  }

  // Obtener todos los tokens (lectura)
  Future<List> getAllTokens() async {
    final getAllTokensFunction = contract.function("getAllTokens");
    List tokens = await web3client.call(
      contract: contract,
      function: getAllTokensFunction,
      params: [],
    );
    return tokens;
  }

  // Actualizar el tokenURI de un NFT
  Future<void> updateTokenURI(int tokenId, String newTokenURI) async {
    final updateFunction = contract.function("updateTokenURI");

    try {
      await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: updateFunction,
          parameters: [BigInt.from(tokenId), newTokenURI],
        ),
        chainId: 1337,
      );
      notifyListeners();
    } catch (e) {
      print("Error al actualizar NFT: $e");
    }
  }

  // Eliminar un NFT
  Future<void> deleteNFT(int tokenId) async {
    final deleteFunction = contract.function("deleteToken");

    try {
      await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: deleteFunction,
          parameters: [BigInt.from(tokenId)],
        ),
        chainId: 1337,
      );
      notifyListeners();
    } catch (e) {
      print("Error al eliminar NFT: $e");
    }
  }

  // Cambios de estado visuales
  void loadingChange(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void searchingChange(bool val) {
    isSearching = val;
    notifyListeners();
  }

  // Generar imagen utilizando la API de IA
  Future<void> textToImage(String prompt, BuildContext context) async {
    String baseprompt = "Genera una imagen relacionada con $prompt";
    String engineId = "stable-diffusion-v1-6";
    String apiHost = 'https://api.stability.ai';
    String apiKey = 'sk-SISMU3GHhmv27DBV6NeujZ9gqjIaffwDPxANS0WvEaXHLVJo';
    debugPrint(prompt);

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
        imageData = response.bodyBytes;
        loadingChange(true);
        searchingChange(false);
        notifyListeners();
      } catch (e) {
        debugPrint("Error generando imagen: $e");
      }
    } else {
      debugPrint("Error en la generación de imagen");
    }
  }
}
