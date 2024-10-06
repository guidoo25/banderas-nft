import 'package:NFT/configs/config.dart';
import 'package:NFT/models/nft_model.dart';
import 'package:NFT/screens/nft_gestion/widgets/card_nft.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NFTListScreen extends StatefulWidget {
  @override
  _NFTListScreenState createState() => _NFTListScreenState();
}

class _NFTListScreenState extends State<NFTListScreen> {
  List<NFT> nftList = [];

  @override
  void initState() {
    super.initState();
    fetchNFTs();
  }

  Future<void> fetchNFTs() async {
    final apirul = Enviroments.API_URL;
    final url = '$apirul/listar';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        nftList = (jsonResponse['nfts'] as List)
            .map((data) => NFT.fromJson(data))
            .toList();
      });
    } else {
      print('Error al obtener NFTs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFTs en venta'),
      ),
      body: nftList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: nftList.length,
              itemBuilder: (context, index) {
                final nft = nftList[index];

                return NFTCard(
                  rareza: nft.rareza,
                  priceEth: nft.precio,
                  imageUrl: nft.image,
                  titutlo: nft.name,
                  id_nft: nft.nftId!,
                );
              },
            ),
    );
  }
}
