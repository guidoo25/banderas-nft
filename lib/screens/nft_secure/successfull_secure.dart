import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:NFT/screens/home/home_page.dart';
import 'package:NFT/utils/image_path.dart';

class successfullSecure extends StatefulWidget {
  const successfullSecure({Key? key}) : super(key: key);

  @override
  State<successfullSecure> createState() => _successfullSecureState();
}

class _successfullSecureState extends State<successfullSecure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onBackground),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
              ),
              Center(
                child: Image(
                    image:
                        AssetImage(NftConstant.getImagePath("estandarte.png"))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                  child: Text(
                "Proyecto de banderas",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Center(
                  child: Text(
                "Consigue toda la colección de banderas y fusionalos para obtener una bandera única",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homePage()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
