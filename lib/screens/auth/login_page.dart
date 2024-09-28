import 'package:flutter/material.dart';
import 'package:text_to_image/screens/auth/forget_password.dart';

import 'package:text_to_image/screens/auth/sign_up.dart';
import 'package:text_to_image/screens/nft_secure/secure_nft.dart';
import 'package:text_to_image/screens/nft_secure/successfull_secure.dart';
import 'package:text_to_image/styles/login_box.dart';
import 'package:text_to_image/utils/image_path.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, top: MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  "Log in!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, top: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  "Bienvenido identificate para continuar",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              loginBox(
                hintText: 'Email',
                iconColor: Color(0xffc576d7),
                boxColor: Color(0xffebd9ee),
                topMargin: MediaQuery.of(context).size.height * 0.06,
                icons: Icons.email_outlined,
              ),
              loginBox(
                hintText: 'Password',
                iconColor: Color.fromARGB(255, 134, 135, 136),
                boxColor: Color(0xffdfe9fe),
                topMargin: MediaQuery.of(context).size.height * 0.03,
                icons: Icons.lock_outline,
                visibleIcon: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                },
                child: Center(
                  child: Text(
                    "Forgot Password!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => successfullSecure()));

                  // MaterialPageRoute(builder: (context) => secureNft()));
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
                      "Iniciar Sesion",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.height * 0.07,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image:
                            AssetImage(NftConstant.getImagePath("google.png")),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.height * 0.07,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: AssetImage(
                            NftConstant.getImagePath("fbcircle.png")),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.height * 0.07,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image(
                        image:
                            AssetImage(NftConstant.getImagePath("apple.png")),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}