import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web3/flutter_web3.dart';

// Clase que representa el estado de MetaMask
class MetaMaskState {
  final String currentAddress;
  final int currentChain;
  final bool isEnabled;
  final bool isInOperatingChain;
  final bool isConnected;

  MetaMaskState({
    required this.currentAddress,
    required this.currentChain,
    required this.isEnabled,
    required this.isInOperatingChain,
    required this.isConnected,
  });

  MetaMaskState.initial()
      : currentAddress = '',
        currentChain = -1,
        isEnabled = ethereum != null,
        isInOperatingChain = false,
        isConnected = false;

  MetaMaskState copyWith({
    String? currentAddress,
    int? currentChain,
    bool? isEnabled,
    bool? isInOperatingChain,
    bool? isConnected,
  }) {
    return MetaMaskState(
      currentAddress: currentAddress ?? this.currentAddress,
      currentChain: currentChain ?? this.currentChain,
      isEnabled: isEnabled ?? this.isEnabled,
      isInOperatingChain: isInOperatingChain ?? this.isInOperatingChain,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

// StateNotifier para gestionar MetaMask
class MetaMaskNotifier extends StateNotifier<MetaMaskState> {
  static const operatingChain = 1;

  MetaMaskNotifier() : super(MetaMaskState.initial()) {
    init();
  }

  // Inicializar listeners para cambios en la cuenta o la cadena
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

  // Conectar a MetaMask
  Future<void> connect() async {
    if (state.isEnabled) {
      try {
        final accs = await ethereum!.requestAccount();
        if (accs.isNotEmpty) {
          final newChainId = await ethereum!.getChainId();
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

  void clear() {
    state = MetaMaskState.initial();
  }
}

// Proveedor de MetaMask con Riverpod
final metaMaskProvider = StateNotifierProvider<MetaMaskNotifier, MetaMaskState>(
  (ref) => MetaMaskNotifier(),
);
