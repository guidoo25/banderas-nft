import 'dart:convert';

import 'package:NFT/configs/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart' as http;

class MetaMaskState {
  final String currentAddress;
  final int currentChain;
  final bool isEnabled;
  final bool isInOperatingChain;
  final bool isConnected;
  final bool isOwner;

  MetaMaskState({
    required this.currentAddress,
    required this.currentChain,
    required this.isEnabled,
    required this.isInOperatingChain,
    required this.isConnected,
    required this.isOwner,
  });

  MetaMaskState.initial()
      : currentAddress = '',
        currentChain = -1,
        isEnabled = ethereum != null,
        isInOperatingChain = false,
        isConnected = false,
        isOwner = false;

  MetaMaskState copyWith({
    String? currentAddress,
    int? currentChain,
    bool? isEnabled,
    bool? isInOperatingChain,
    bool? isConnected,
    bool? isOwner,
  }) {
    return MetaMaskState(
      currentAddress: currentAddress ?? this.currentAddress,
      currentChain: currentChain ?? this.currentChain,
      isEnabled: isEnabled ?? this.isEnabled,
      isInOperatingChain: isInOperatingChain ?? this.isInOperatingChain,
      isConnected: isConnected ?? this.isConnected,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}

class MetaMaskNotifier extends StateNotifier<MetaMaskState> {
  static const operatingChain = 1;

  MetaMaskNotifier() : super(MetaMaskState.initial()) {
    init();
  }

  void init() {
    if (state.isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });

      ethereum!.onChainChanged((chainId) {
        final newChainId = int.parse(chainId.toString());
        state = state.copyWith(
          currentChain: newChainId,
          isInOperatingChain: newChainId == operatingChain,
        );
      });
    }
  }

  Future<void> connect() async {
    if (state.isEnabled) {
      try {
        final accs = await ethereum!.requestAccount();
        if (accs.isNotEmpty) {
          final newChainId = await ethereum!.getChainId();
          final isOwner = await checkIfOwner(accs.first);

          state = state.copyWith(
            currentAddress: accs.first,
            currentChain: newChainId,
            isInOperatingChain: newChainId == operatingChain,
            isConnected: true,
          );
        }
      } catch (e) {
        print('Error al conectar con MetaMask: $e');
      }
    }
  }

  Future<void> checkIfOwner(dynamic walletowner) async {
    final wallet = walletowner.toLowerCase(); // Convertir a minúsculas

    try {
      final response = await http.post(
        Uri.parse('${Enviroments.API_URL}/validar-owner'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nftId': wallet,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isOwner'] == true) {
          state = state.copyWith(isOwner: true);
          print('Es propietario');
        } else {
          state = state.copyWith(isOwner: false);
        }
      } else {
        print('Error al verificar el propietario del NFT: ${response.body}');
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
    }
  }

  void clear() {
    state = MetaMaskState.initial();
  }

  void logout() {
    clear();
  }
}

final metaMaskProvider = StateNotifierProvider<MetaMaskNotifier, MetaMaskState>(
  (ref) => MetaMaskNotifier(),
);
