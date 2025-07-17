import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/keyword_provider.dart';
import 'audio_playing.dart';
import 'now_playing.dart';
import 'tts_slider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('뉴스 플레이어')),
      body: newsAsync.when(
        data: (newsList) {
          final news = newsList.first; // 일단 첫 번째 뉴스로
          return Column(
            children: [
              NowPlayingInfo(news: news),
              const SizedBox(height: 20),
              const TtsSlider(),
              const AudioControls(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }
}
