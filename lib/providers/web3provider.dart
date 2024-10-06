// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

// // Proveedor que contiene la lógica de conexión y las funciones del contrato NFT
// final nftContractProvider = Provider<NFTContract>((ref) {
//   return NFTContract();
// });

// class NFTContract {
//   final String rpcUrl = "http://127.0.0.1:7545"; // URL de Ganache
//   final String privateKey =
//       "0x59198b50442777d339f375b43d1e79a783c7def6744f0f13855cbfa184c824c5";
//   final String contractAddress = "0x425Bb07a14fdCC18D6520f483e36F79783d48563";
//   late Web3Client _web3client;
//   late DeployedContract _contract;
//   late Credentials _credentials;
//   late EthereumAddress _contractEthereumAddress;

//   NFTContract() {
//     _web3client = Web3Client(rpcUrl, Client());
//     _credentials = EthPrivateKey.fromHex(privateKey);
//     _contractEthereumAddress = EthereumAddress.fromHex(contractAddress);
//     _initializeContract();
//   }

//   Future<void> _initializeContract() async {
//     // Cargar el ABI desde assets
//     String abiString = await rootBundle.loadString("assets/MyNFT.json");
//     final abiJson = jsonDecode(abiString);
//     final abi =
//         jsonEncode(abiJson["abi"]); // Carga directamente la ABI desde el JSON

//     _contract = DeployedContract(ContractAbi.fromJson(abi, "SimpleNftLowerGas"),
//         _contractEthereumAddress);
//   }

//   Future<void> mintNFT(int mintAmount, int rareza, String tokenURI, String pais,
//       String paisaje) async {
//     final mintFunction = _contract.function("mint");

//     try {
//       await _web3client.sendTransaction(
//         _credentials,
//         Transaction.callContract(
//           contract: _contract,
//           function: mintFunction,
//           parameters: [
//             BigInt.from(mintAmount),
//             BigInt.from(rareza),
//             tokenURI,
//             pais,
//             paisaje
//           ],
//         ),
//         chainId: 1337,
//       );
//     } catch (e) {
//       print("Error al mintear NFT: $e");
//     }
//   }

//   // Función para obtener todos los NFTs de un propietario
//   Future<List<dynamic>> walletOfOwner(EthereumAddress owner) async {
//     final function =
//         _contract.function("walletOfOwner"); // Función de tu contrato

//     try {
//       List<dynamic> result = await _web3client.call(
//         contract: _contract,
//         function: function,
//         params: [owner], // Dirección del propietario
//       );
//       return result;
//     } catch (e) {
//       print("Error al obtener NFTs: $e");
//       return [];
//     }
//   }

//   // Función para fusionar NFTs
//   Future<void> fusionarNFTs(int tokenId1, int tokenId2) async {
//     final function = _contract
//         .function("fusionarNFTs"); // Nombre de la función en tu contrato

//     try {
//       await _web3client.sendTransaction(
//         _credentials,
//         Transaction.callContract(
//           contract: _contract,
//           function: function,
//           parameters: [BigInt.from(tokenId1), BigInt.from(tokenId2)],
//         ),
//         chainId: 1337,
//       );
//     } catch (e) {
//       print("Error al fusionar NFTs: $e");
//     }
//   }
// }
