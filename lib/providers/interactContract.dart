// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart';
// import 'package:web_socket_channel/io.dart';

// class MeaningState {
//   final Web3Client client;
//   final Credentials credentials;
//   final DeployedContract contract;

//   MeaningState({
//     required this.client,
//     required this.credentials,
//     required this.contract,
//   });
// }

// class MeaningNotifier extends StateNotifier<MeaningState?> {
//   MeaningNotifier() : super(null);
//   static const String _contractName = "SimpleNftLowerGas";
//   static const String _ip = "127.0.0.1";
//   static const String _port = "7545";
//   static const String _rpcUrl = "http://$_ip:$_port";
//   final String wsUrl = "ws://$_ip:$_port";
//   final String privateKey =
//       "59198b50442777d339f375b43d1e79a783c7def6744f0f13855cbfa184c824c5";

//   Future<void> initialize(context) async {
//     try {
//       final client = Web3Client(_rpcUrl, Client(), socketConnector: () {
//         return IOWebSocketChannel.connect(wsUrl).cast<String>();
//       });

//       String abiStringfile = await rootBundle.loadString("assets/MyNFT.json");
//       final abiJson = jsonDecode(abiStringfile);
//       final abi = jsonEncode(abiJson["abi"]);

//       final contractAddress =
//           EthereumAddress.fromHex("0x3aa2c38A297905892759890C4DB2231Aca450A89");
//       final _creedentials = EthPrivateKey.fromHex(privateKey);

//       final contract = DeployedContract(
//         ContractAbi.fromJson(abi, _contractName),
//         contractAddress,
//       );

//       // Verifica si el contrato es nulo o no
//       if (contract == null) {
//         throw Exception("El contrato no se pudo cargar.");
//       }

//       state = MeaningState(
//         client: client,
//         credentials: _creedentials,
//         contract: contract,
//       );

//       print("Contrato inicializado correctamente");
//     } catch (e) {
//       print("Error durante la inicialización del contrato: $e");
//     }
//   }

//   // Función para despausar el contrato
//   Future<void> despausarContrato() async {
//     final setPausedFunction = state?.contract.function('setPaused');

//     if (setPausedFunction == null) {
//       print("Contract not initialized");
//       return;
//     }

//     try {
//       // Llamada para despausar el contrato
//       await state?.client.sendTransaction(
//         state!.credentials,
//         Transaction.callContract(
//           contract: state!.contract,
//           function: setPausedFunction,
//           parameters: [false], // Despausar el contrato
//         ),
//         chainId: 1337,
//       );
//       print('Contrato despausado');
//     } catch (e) {
//       print('Error al despausar el contrato: $e');
//     }
//   }

//   // Función para verificar si la cuenta actual es el propietario
//   Future<bool> esOwner() async {
//     final ownerFunction = state?.contract.function('owner');
//     if (ownerFunction == null) {
//       print("Contract not initialized");
//       return false;
//     }

//     try {
//       final owner = await state!.client.call(
//         contract: state!.contract,
//         function: ownerFunction,
//         params: [],
//       );

//       final currentAddress = await state!.credentials.extractAddress();

//       // Verificar si la dirección actual es el propietario del contrato
//       return owner.first == currentAddress;
//     } catch (e) {
//       print('Error al verificar el propietario: $e');
//       return false;
//     }
//   }

//   // Función para mintear NFTs
//   Future<void> mintNFT(int mintAmount, int rareza, String tokenURI, String pais,
//       String paisaje) async {
//     final mintFunction = state?.contract.function("mint");

//     if (mintFunction == null) {
//       print("Contrato no inicializado");
//       return;
//     }

//     try {
//       final pausedFunction = state?.contract.function("paused");
//       final isPaused = await state!.client.call(
//         contract: state!.contract,
//         function: pausedFunction!,
//         params: [],
//       );

//       if (isPaused.first == true) {
//         print("El contrato está en pausa, no se puede mintear.");
//         return;
//       }

//       await state?.client.sendTransaction(
//         state!.credentials,
//         Transaction.callContract(
//           contract: state!.contract,
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
//       print("NFT minteado correctamente");
//     } catch (e) {
//       print("Error al mintear NFT: $e");
//     }
//   }

//   // Función para obtener la lista de NFTs del propietario
//   Future<List<dynamic>> walletOfOwner(EthereumAddress owner) async {
//     final function = state?.contract.function("walletOfOwner");

//     if (function == null) {
//       print("Contract not initialized");
//       return [];
//     }

//     try {
//       List<dynamic> result = await state!.client.call(
//         contract: state!.contract,
//         function: function!,
//         params: [owner],
//       );
//       return result;
//     } catch (e) {
//       print("Error al obtener NFTs: $e");
//       return [];
//     }
//   }

//   // Función para listar NFTs raros
//   Future<List<dynamic>> listarNFTsRaros() async {
//     final function = state?.contract.function("listarNFTsRaros");

//     if (function == null) {
//       print("Contract not initialized");
//       return [];
//     }

//     try {
//       List<dynamic> result = await state!.client.call(
//         contract: state!.contract,
//         function: function!,
//         params: [],
//       );
//       return result;
//     } catch (e) {
//       print("Error al listar NFTs raros: $e");
//       return [];
//     }
//   }

//   // Función para fusionar NFTs
//   Future<void> fusionarNFTs(int tokenId1, int tokenId2) async {
//     final function = state?.contract.function("fusionarNFTs");

//     if (function == null) {
//       print("Contract not initialized");
//       return;
//     }

//     try {
//       await state?.client.sendTransaction(
//         state!.credentials,
//         Transaction.callContract(
//           contract: state!.contract,
//           function: function!,
//           parameters: [BigInt.from(tokenId1), BigInt.from(tokenId2)],
//         ),
//         chainId: 1337,
//       );
//     } catch (e) {
//       print("Error al fusionar NFTs: $e");
//     }
//   }

//   // Función para listar NFTs en venta
//   Future<List<dynamic>> listarNFTsEnVenta() async {
//     final function = state?.contract.function("listarNFTsEnVenta");

//     if (function == null) {
//       print("Contract not initialized");
//       return [];
//     }

//     try {
//       List<dynamic> result = await state!.client.call(
//         contract: state!.contract,
//         function: function!,
//         params: [],
//       );
//       return result;
//     } catch (e) {
//       print("Error al listar NFTs en venta: $e");
//       return [];
//     }
//   }

//   // Función para comprar un NFT
//   Future<void> comprarNFT(int tokenId, BigInt precio) async {
//     final function = state?.contract.function("comprarNFT");

//     if (function == null) {
//       print("Contract not initialized");
//       return;
//     }

//     try {
//       await state?.client.sendTransaction(
//         state!.credentials,
//         Transaction.callContract(
//           contract: state!.contract,
//           function: function!,
//           parameters: [BigInt.from(tokenId)],
//           value: EtherAmount.fromUnitAndValue(EtherUnit.wei, precio),
//         ),
//         chainId: 1337,
//       );
//     } catch (e) {
//       print("Error al comprar NFT: $e");
//     }
//   }
// }

// final meaningProvider = StateNotifierProvider<MeaningNotifier, MeaningState?>(
//   (ref) => MeaningNotifier(),
// );
