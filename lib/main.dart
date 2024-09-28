import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_to_image/screens/onboarding_screen/on_boarding.dart';
import 'package:text_to_image/styles/colors.dart';
import 'package:text_to_image/views/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFT MarketPlace',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onSecondary: onsecondaryColor,
              secondary: secoundryColor,
              onBackground: onbackgroundColor)),
      home: const OnBoardingScreen(),
    );
  }
}
