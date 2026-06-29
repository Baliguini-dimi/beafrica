// lib/features/radio/providers/radio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class RadioState {
  final bool isPlaying;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  const RadioState({
    this.isPlaying = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  RadioState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return RadioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
    );
  }
}

class RadioNotifier extends StateNotifier<RadioState> {
  final AudioPlayer _player = AudioPlayer();

  // Flux audio Radio Ndeke Luka
  static const String _streamUrl =
      'https://stream.radiondekeluka.org/audio/128';

  RadioNotifier() : super(const RadioState()) {
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final isLoading =
          playerState.processingState == ProcessingState.loading ||
              playerState.processingState == ProcessingState.buffering;
      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: isLoading,
      );
    });
  }

  Future<void> play() async {
    state = state.copyWith(isLoading: true, hasError: false);
    try {
      await _player.setUrl(_streamUrl);
      await _player.play();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage:
            'Impossible de charger la radio. Vérifiez votre connexion.',
      );
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final radioProvider = StateNotifierProvider<RadioNotifier, RadioState>((ref) {
  return RadioNotifier();
});
