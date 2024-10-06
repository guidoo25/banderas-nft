import 'package:NFT/configs/config.dart';
import 'package:NFT/models/nft_model.dart';
import 'package:dio/dio.dart';

class NftApiService {
  final Dio _dio = Dio();
  final String baseUrl = Enviroments.API_URL;

  // Crear NFT
  Future<Map<String, dynamic>> storeNFT(String jsonData) async {
    try {
      final response = await _dio.post(
        '$baseUrl/store',
        data: {
          'jsonData': jsonData,
          'precio': 1000,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al crear el NFT: $e');
    }
  }

  // Fusionar NFTs
  Future<Map<String, dynamic>> fusionarNFTs(
      String nftId1, String nftId2) async {
    try {
      final response = await _dio.post(
        '$baseUrl/fusionar',
        data: {
          'nftId1': nftId1,
          'nftId2': nftId2,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al fusionar los NFTs: $e');
    }
  }

  // Eliminar un NFT
  Future<Map<String, dynamic>> eliminarNFT(String nftId) async {
    try {
      final response = await _dio.delete(
        '$baseUrl/eliminar',
        data: {
          'nftId': nftId,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al eliminar el NFT: $e');
    }
  }

  // Listar NFTs en venta
  Future<List<dynamic>> listarNFTsEnVenta() async {
    try {
      final response = await _dio.get('$baseUrl/listarEnVenta');
      return response.data['nfts'];
    } catch (e) {
      throw Exception('Error al listar los NFTs en venta: $e');
    }
  }

  // Comprar un NFT
  Future<Map<String, dynamic>> comprarNFT(
      String nftId, int valor, String comprador) async {
    try {
      final response = await _dio.post(
        '$baseUrl/comprar',
        data: {
          'nftId': nftId,
          'valor': valor,
          'comprador': comprador,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al comprar el NFT: $e');
    }
  }

  // Cambiar el precio de un NFT
  Future<Map<String, dynamic>> setNFTPrice(String nftId, int newPrice) async {
    try {
      final response = await _dio.post(
        '$baseUrl/cambiarPrecio',
        data: {
          'nftId': nftId,
          'precio': newPrice, // Nuevo precio en wei
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al cambiar el precio del NFT: $e');
    }
  }

  // Listar los NFTs comprados por una wallet
  Future<List<NFT>> listarNFTsComprados(String walletAddress) async {
    try {
      final response = await _dio.get(
        '$baseUrl/propietario/$walletAddress',
      );
      print(response.data);
      return NFT.fromJsonList(response.data['nfts']);
    } catch (e) {
      throw Exception('Error al listar los NFTs comprados: $e');
    }
  }
}
