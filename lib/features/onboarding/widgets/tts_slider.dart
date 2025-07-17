// lib/features/player/widgets/tts_slider.dart
import 'package:flutter/material.dart';

class TtsSlider extends StatefulWidget {
  const TtsSlider({super.key});

  @override
  State<TtsSlider> createState() => _TtsSliderState();
}

class _TtsSliderState extends State<TtsSlider> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Slider(value: _value, onChanged: (v) => setState(() => _value = v));
  }
}
