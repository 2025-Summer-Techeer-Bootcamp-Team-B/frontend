// lib/features/player/widgets/audio_controls.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 아이콘 쓰려면 필요!

class AudioControls extends StatelessWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.backward_end_fill),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.play_arrow_solid),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.forward_end_fill),
          onPressed: () {},
        ),
      ],
    );
  }
}
