import 'package:NFT/screens/nft_gestion/create_nft.dart';
import 'package:NFT/screens/nft_gestion/my_list_nft.dart';
import 'package:flutter/material.dart';

class tabs_nft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: 2, // Replace 3 with the number of tabs you want
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Crear Usuarios'),
                Tab(text: 'lista de Usuarios'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Center(
                      child: MyNFTsScreen(),
                    ),
                  ),
                  // Replace these with your tab views
                  Container(
                    child: Center(
                      child: UploadImageScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
