import 'package:NFT/providers/api_contract.dart';
import 'package:NFT/providers/metamask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NFTCard extends ConsumerWidget {
  final String imageUrl;
  final int priceEth;
  final int
      rareza; // Cambié el nombre de 'likes' a 'rareza' para reflejar la rareza
  final String titutlo;
  final String id_nft;

  NFTCard({
    required this.imageUrl,
    required this.priceEth,
    required this.rareza,
    required this.titutlo,
    required this.id_nft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaMaskState = ref.watch(metaMaskProvider);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NFT Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          // NFT Title
          Text(
            titutlo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          // Description (optional)
          Text(
            'Colección de NFTs de países',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          // Price and Rareza
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.green),
                  Text(
                    '$priceEth ETH',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // Iconos que indican la rareza
              Row(
                children: [
                  _getRarezaIcon(
                      rareza), // Aquí se utiliza la función _getRarezaIcon
                  SizedBox(width: 5),
                  Text('Rareza: $rareza',
                      style: TextStyle(color: Colors.black87)),
                  IconButton(
                      onPressed: () async {
                        //alert dialog
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Comprar NFT'),
                            content: Text('¿Estás seguro de comprar este NFT?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await NftApiService().comprarNFT(id_nft,
                                      priceEth, metaMaskState.currentAddress);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Comprar'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_cart)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3 days left',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(Icons.qr_code, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getRarezaIcon(int rareza) {
    switch (rareza) {
      case 1:
        return Icon(Icons.circle, color: Colors.brown, size: 20);
      case 2:
        return Icon(Icons.circle, color: Colors.grey, size: 25);
      case 3:
        return Icon(Icons.circle, color: Colors.blue, size: 30);
      case 4:
        return Icon(Icons.circle, color: Colors.yellow, size: 35);
      default:
        return Icon(Icons.circle, color: Colors.grey, size: 20);
    }
  }
}
