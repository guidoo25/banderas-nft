import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroments {
  initEnviroments() async {
    await dotenv.load(fileName: ".env");
  }

  static String direccion_contrato = dotenv.env['addres'] ?? '';
  static String secret_key = dotenv.env['secretkey'] ?? '';
  static String rpcUrl = dotenv.env['rpcUrl'] ?? '';
  static String cloudinaruser = dotenv.env['cloudinaryuser'] ?? '';
  static String cloudinaryKey = dotenv.env['clodinarykey'] ?? '';
}
