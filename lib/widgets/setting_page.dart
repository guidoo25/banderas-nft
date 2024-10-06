import 'package:NFT/providers/metamask.dart';
import 'package:NFT/screens/auth/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class settingPage extends ConsumerStatefulWidget {
  const settingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<settingPage> createState() => _settingPageState();
}

class _settingPageState extends ConsumerState<settingPage> {
  final List<IconData> _iconData = [Icons.login_outlined];

  List colors = [
    Color(0xff9b7fbf),
    Color(0xffd9aaca),
    Color(0xfff59297),
    Color(0xff88c5e4),
    Color(0xffa0a0a0)
  ];

  List bgColors = [
    Color(0xfff4f1f9),
    Color(0xfff5e9f2),
    Color(0xfffce4e5),
    Color(0xffe5f8ff),
    Color(0xfff5f5f7)
  ];

  @override
  Widget build(BuildContext context) {
    final walletprovider = ref.read(metaMaskProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Setting",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 10,
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                )
              ],
            ),
            child: Column(
                children: List.generate(1, (index) => index)
                    .map((e) => Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: bgColors[e]),
                              child: Icon(
                                _iconData[e],
                                color: colors[e],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Salir",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                walletprovider.logout();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red),
                                child: Text(
                                  "cerrar session",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}
