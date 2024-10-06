import 'package:NFT/providers/metamask.dart';
import 'package:NFT/screens/nft_secure/successfull_secure.dart';
import 'package:NFT/utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Observar el estado de MetaMask
    final metamaskState = ref.watch(metaMaskProvider);
    final metamaskNotifier = ref.read(metaMaskProvider.notifier);

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20,
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Image.asset(
                      NftConstant.getImagePath("logonft.png"),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, top: MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  "Inicio de sesión!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, top: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  "Bienvenido, identifícate con tu wallet para continuar.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              GestureDetector(
                onTap: () {
                  metamaskNotifier.connect(); // Iniciar el login con MetaMask
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      metamaskState.isConnected
                          ? "Conectado: ${metamaskState.currentAddress}"
                          : "Conectar con MetaMask",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Indicador de conexión
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: metamaskState.isConnected
                          ? Colors.green // Verde si está conectado
                          : Colors.red, // Rojo si no está conectado
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      metamaskState.isConnected
                          ? "Billetera conectada"
                          : "No se ha conectado la billetera",
                      style: TextStyle(
                        fontSize: 16,
                        color: metamaskState.isConnected
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: metamaskState.isConnected
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => successfullSecure(),
                            ));
                      }
                    : null,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: metamaskState.isConnected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey),
                  child: Center(
                    child: Text(
                      "Ingresar",
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
            ],
          ),
        ),
      ),
    );
  }
}
