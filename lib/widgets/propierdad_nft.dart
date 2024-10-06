import 'package:NFT/models/nft_model.dart';
import 'package:NFT/providers/api_contract.dart';
import 'package:NFT/providers/nft_state.dart';
import 'package:NFT/utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NftPropiedad extends ConsumerStatefulWidget {
  final String walletAddress;

  const NftPropiedad({Key? key, required this.walletAddress}) : super(key: key);

  @override
  ConsumerState<NftPropiedad> createState() => _CompradosNFTsScreenState();
}

class _CompradosNFTsScreenState extends ConsumerState<NftPropiedad> {
  late Future<List<NFT>> _nftsCompradosFuture;
  List<NFT> selectedNFTs = [];

  @override
  void initState() {
    super.initState();
    _nftsCompradosFuture =
        NftApiService().listarNFTsComprados(widget.walletAddress);
  }

  void _toggleSelection(NFT nft) {
    setState(() {
      if (selectedNFTs.contains(nft)) {
        selectedNFTs.remove(nft);
      } else if (selectedNFTs.length < 2) {
        selectedNFTs.add(nft);
      }
    });
  }

  void _confirmSelection(BuildContext context) {
    if (selectedNFTs.length == 2) {
      final productNotifier = ref.read(productProvider.notifier);
      for (var nft in selectedNFTs) {
        productNotifier.addProduct(nft);
      }
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes seleccionar exactamente 2 NFTs.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFTs en propiedad'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<NFT>>(
          future: _nftsCompradosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No has comprado ningún NFT.'));
            } else {
              final nftsComprados = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: nftsComprados.length,
                      itemBuilder: (context, index) {
                        final nft = nftsComprados[index];
                        final isSelected = selectedNFTs.contains(nft);
                        return GestureDetector(
                          onTap: () => _toggleSelection(nft),
                          child: NFTItemCard(nft: nft, isSelected: isSelected),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _confirmSelection(context),
                    child: const Text('Confirmar Selección'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class NFTItemCard extends ConsumerWidget {
  final NFT nft;
  final bool isSelected;

  const NFTItemCard({
    Key? key,
    required this.nft,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isSelected ? Colors.grey[300] : Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: nft.image.isNotEmpty
                      ? NetworkImage(nft.image)
                      : AssetImage(NftConstant.getImagePath('nft.png'))
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  nft.description.isNotEmpty
                      ? nft.description
                      : 'Sin descripción',
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Precio: ${nft.precio} ETH',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5),
                    Image.asset(NftConstant.getImagePath("eth.jpg"),
                        width: 20, height: 20),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Rareza: ${nft.rareza}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                nft.enVenta
                    ? const Text(
                        "En Venta",
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    : const Text(
                        "Comprado",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                IconButton(
                  onPressed: () {
                    //alter dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Eliminar NFT'),
                          content: const Text(
                              '¿Estás seguro de que deseas eliminar este NFT?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                NftApiService().eliminarNFT(nft.nftId!);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
