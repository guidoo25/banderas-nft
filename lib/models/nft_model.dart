import 'dart:convert';

class NFT {
  final String name;
  final String description;
  final String image;
  final int rareza;
  final int precio;
  final bool enVenta;
  final bool exists;
  final String? nftId;

  NFT({
    required this.name,
    required this.description,
    required this.image,
    required this.rareza,
    required this.precio,
    required this.enVenta,
    required this.exists,
    this.nftId,
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    final jsonData = jsonDecode(json['jsonData']);
    return NFT(
      name: jsonData['pais'] ?? 'Sin nombre',
      description: jsonData['description'] ?? '',
      image: jsonData['image'] ?? '',
      rareza: int.parse(json['rareza']),
      precio: int.parse(json['precio']),
      enVenta: json['enVenta'],
      exists: json['exists'],
      nftId: json['id'],
    );
  }

  static List<NFT> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NFT.fromJson(json)).toList();
  }
}
