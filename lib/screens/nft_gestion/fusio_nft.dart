import 'package:NFT/providers/api_contract.dart';
import 'package:NFT/providers/fusion.dart';
import 'package:NFT/providers/nft_state.dart';
import 'package:NFT/screens/nft_gestion/create_nft.dart';
import 'package:NFT/widgets/fillter_result.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FusionCollection extends ConsumerStatefulWidget {
  final String walletAddress;
  const FusionCollection({Key? key, required this.walletAddress})
      : super(key: key);

  @override
  ConsumerState<FusionCollection> createState() => _FusionCollectionState();
}

class _FusionCollectionState extends ConsumerState<FusionCollection> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  bool marketplaceState = false;
  final CloudinaryPublic cloudinary =
      CloudinaryPublic('dfha4roeg', 'onghmgzh', cache: false);

  @override
  Widget build(BuildContext context) {
    final nftProvider = ref.watch(productProvider);
    final imageGenerationState = ref.watch(imageGenerationProvider);
    final imageGenerationNotifier = ref.watch(imageGenerationProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.09,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Seleccionar NFTs",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      nftProvider.isNotEmpty
                          ? Expanded(
                              child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 8,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        12), // Bordes redondeados
                                  ),
                                  child: Image.network(
                                    nftProvider[0].image,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 8,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.network(
                                    nftProvider[1].image,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ))
                          : Expanded(
                              child: Row(
                                children: [
                                  _buildPlaceholderContainer(),
                                  const SizedBox(width: 10),
                                  _buildPlaceholderContainer(),
                                ],
                              ),
                            ),
                      if (nftProvider.isNotEmpty)
                        ElevatedButton(
                            onPressed: () async {
                              await imageGenerationNotifier.textToImage(
                                  nftProvider[0].name,
                                  nftProvider[1].name,
                                  nftProvider[0].description);
                              await NftApiService()
                                  .eliminarNFT(nftProvider[0].nftId!);
                              await NftApiService()
                                  .eliminarNFT(nftProvider[1].nftId!);

                              await NftApiService().storeNFT(
                                  await createNFTJson(
                                      nftProvider[0].name,
                                      nftProvider[0].description,
                                      imageGenerationState.url!,
                                      "4"));
                              ;
                            },
                            child: Text("Generar Fusión")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                  width: double.maxFinite,
                                  child: CompradosNFTsScreen(
                                    walletAddress: widget.walletAddress,
                                  )),
                            );
                          },
                        );
                      },
                      child: const Text("Fusionar"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text("Resultado de la fusión"),
                  const SizedBox(height: 10),
                  if (imageGenerationState.isLoading)
                    const CircularProgressIndicator(),
                  if (imageGenerationState.imageData != null)
                    Image.memory(
                      imageGenerationState.imageData!,
                      height: 300,
                      width: 300,
                    ),
                  if (!imageGenerationState.isLoading &&
                      imageGenerationState.imageData == null)
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('No se ha generado ninguna funsion.'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          Icons.flag,
          size: 50,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
