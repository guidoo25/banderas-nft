import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making HTTP requests
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle; // To load ABI

// Proveedor que contiene la lógica de conexión y las funciones del contrato NFT
final nftContractProvider = Provider<NFTContract>((ref) {
  return NFTContract();
});

class NFTContract {
  final String rpcUrl = "http://127.0.0.1:7545"; // URL de Ganache
  final String privateKey =
      "0xca23b0eef85aa28567f9f4192036033d8e342b70503acf1f2fca87edb4b5efc3"; // Reemplaza con tu clave privada
  final String contractAddress =
      "DIRECCION_DEL_CONTRATO"; // Dirección del contrato

  late Web3Client _web3client;
  late DeployedContract _contract;
  late Credentials _credentials;
  late EthereumAddress _contractEthereumAddress;

  NFTContract() {
    _web3client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _contractEthereumAddress = EthereumAddress.fromHex(contractAddress);
    _initializeContract();
  }

  Future<void> _initializeContract() async {
    // Cargar el ABI
    String abiString = await rootBundle.loadString("assets/MyNFT.json");
    var abiJson = jsonDecode(abiString);
    String abiCode = jsonEncode(abiJson["abi"]);

    _contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "MyNFT"), _contractEthereumAddress);
  }

  // Función para mintear un nuevo NFT
  Future<void> mintNFT(String tokenName, String tokenURI, int rareza) async {
    final mintFunction = _contract.function("mintToken");

    try {
      await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: mintFunction,
          parameters: [tokenName, tokenURI, BigInt.from(rareza)],
        ),
        chainId: 1337,
      );
    } catch (e) {
      print("Error al mintear NFT: $e");
    }
  }

  // Función para obtener todos los NFTs
  Future<List<dynamic>> getAllNFTs() async {
    final function = _contract.function("getAllTokens");

    try {
      List<dynamic> result = await _web3client.call(
        contract: _contract,
        function: function,
        params: [],
      );
      return result;
    } catch (e) {
      print("Error al obtener NFTs: $e");
      return [];
    }
  }

  // Función para comprar un NFT
  Future<void> comprarNFT(int tokenId, double price) async {
    final function = _contract.function("comprarNFT");

    try {
      await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: function,
          parameters: [BigInt.from(tokenId)],
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, price),
        ),
        chainId: 1337,
      );
    } catch (e) {
      print("Error al comprar NFT: $e");
    }
  }
}
