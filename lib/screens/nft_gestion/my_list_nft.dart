import 'package:NFT/providers/interactContract.dart';
import 'package:NFT/providers/web3provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyNFTsScreen extends ConsumerStatefulWidget {
  @override
  _MyNFTsScreenState createState() => _MyNFTsScreenState();
}

class _MyNFTsScreenState extends ConsumerState<MyNFTsScreen> {
  List<Map<String, dynamic>> _nfts = [];

  @override
  void initState() {
    super.initState();
    _fetchNFTs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.watch(meaningProvider.notifier).initialize(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar el contrato'));
        } else {
          final nftContract = ref.watch(meaningProvider.notifier);
          return _buildForm(nftContract);
        }
      },
    );
  }

  Future<void> _fetchNFTs() async {
    final nftContract = ref.read(meaningProvider.notifier);

    // Verificar que el contrato esté inicializado
    if (nftContract.state == null) {
      print("El contrato no está inicializado correctamente");
      return;
    }

    // Obtener la dirección de la wallet
    final address = await nftContract.state?.credentials.extractAddress();
    if (address == null) {
      print("No se pudo obtener la dirección del propietario");
      return;
    }

    try {
      // Obtener los NFTs del propietario
      List<dynamic> nfts = await nftContract.walletOfOwner(address);

      // Limpiar la lista antes de llenar
      _nfts.clear();

      // Iterar sobre cada NFT para obtener su URI
      for (var tokenId in nfts) {
        final tokenUri = await _getTokenUri(tokenId);
        setState(() {
          _nfts.add({
            'tokenId': tokenId.toString(),
            'tokenUri': tokenUri,
          });
        });
      }
    } catch (e) {
      print('Error al obtener los NFTs: $e');
    }
  }

  // Función para obtener el tokenURI de cada NFT
  Future<String> _getTokenUri(dynamic tokenId) async {
    final nftContract = ref.read(meaningProvider.notifier);

    // Verificar si el contrato está inicializado correctamente
    if (nftContract.state == null) {
      print("Contrato no inicializado");
      return '';
    }

    final tokenUriFunction = nftContract.state?.contract.function('tokenURI');
    try {
      final uri = await nftContract.state?.client.call(
        contract: nftContract.state!.contract,
        function: tokenUriFunction!,
        params: [BigInt.from(tokenId)],
      );
      return uri?.first ?? '';
    } catch (e) {
      print('Error al obtener el tokenURI del token $tokenId: $e');
      return '';
    }
  }

  Widget _buildForm(MeaningNotifier nftContract) {
    return FutureBuilder(
      future: _fetchNFTs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar los NFTs'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mis NFTs'),
              backgroundColor: Colors.green,
            ),
            body: _nfts.isEmpty
                ? Center(child: Text('No tienes NFTs en esta wallet'))
                : GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _nfts.length,
                    itemBuilder: (context, index) {
                      final nft = _nfts[index];
                      return Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            if (nft['tokenUri'] != null &&
                                nft['tokenUri'].isNotEmpty)
                              Image.network(
                                nft['tokenUri'],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'NFT ID: ${nft['tokenId']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}
