import 'package:flutter/material.dart';
import '../../briefing/bri_caption.dart';

class FontSizeSettingScreen extends StatefulWidget {
  const FontSizeSettingScreen({Key? key}) : super(key: key);

  @override
  State<FontSizeSettingScreen> createState() => _FontSizeSettingScreenState();
}

class _FontSizeSettingScreenState extends State<FontSizeSettingScreen> {
  double _fontSize = 22;

  // bri_caption 미리보기용 mock 데이터
  final String _imageUrl = 'assets/a_image/caption.png';
  final String _title = 'AI가 요약한 오늘의 주요 뉴스';
  final String _reporter = '홍길동 기자';
  final List<String> _scriptLines = [
    '오늘의 첫 번째 뉴스입니다.',
    '기상청에 따르면 내일은 맑겠습니다.',
    '주요 이슈를 한눈에 정리해드립니다.',
    '정치, 경제, 사회, 문화 소식까지!',
    '이상 bri_caption이었습니다.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF0565FF), size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 2),
                const Text(
                  '뒤로',
                  style: TextStyle(
                    color: Color(0xFF0565FF),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                const Text(
                  '글자 크기 변경',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_fontSize);
                  },
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      color: Color(0xFF0565FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // 아이폰 15 프레임 + 미리보기
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Iphone15Frame(
                  child: BriCaptionPreview(
                    imageUrl: _imageUrl,
                    title: _title,
                    reporter: _reporter,
                    scriptLines: _scriptLines,
                    fontSize: _fontSize,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 글자 크기 조정 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                FontSizeSliderBar(
                  value: _fontSize,
                  min: 14,
                  max: 32,
                  divisions: 4,
                  onChanged: (v) => setState(() => _fontSize = v),
                ),
                const SizedBox(height: 10),
                Text('${_fontSize.toInt()} pt',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 32), // 인디케이터 공간 확보
        ],
      ),
    );
  }
}

// 아이폰 15 프레임 위젯 (노치, 인디케이터, 테두리 포함)
class Iphone15Frame extends StatelessWidget {
  final Widget child;
  const Iphone15Frame({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 440,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 4), // 검은색 테두리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 내부 화면 (노치 아래로 패딩)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 18), // 노치/인디케이터 공간 확보
                child: Container(
                  color: Colors.white,
                  child: child,
                ),
              ),
            ),
          ),
          // 노치
          Positioned(
            top: 8,
            left: (220 - 80) / 2,
            child: Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 하단 인디케이터
          Positioned(
            bottom: 8,
            left: (220 - 60) / 2,
            child: Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black, // 검은색 인디케이터
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// bri_caption 미리보기용 위젯 (글자 크기만 조정)
class BriCaptionPreview extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String reporter;
  final List<String> scriptLines;
  final double fontSize;
  const BriCaptionPreview({
    required this.imageUrl,
    required this.title,
    required this.reporter,
    required this.scriptLines,
    required this.fontSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 기사 정보
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reporter,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 대본 미리보기
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scriptLines.length,
              itemBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    scriptLines[idx],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 하단 pill형 슬라이더 커스텀 위젯
class FontSizeSliderBar extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;
  const FontSizeSliderBar({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('가', style: TextStyle(fontSize: 15)),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.5,
                activeTrackColor: const Color(0xFF1976D2),
                inactiveTrackColor: const Color(0xFF90CAF9),
                thumbColor: Colors.white,
                overlayColor: const Color(0x331976D2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: const Color(0xFF1976D2),
                inactiveTickMarkColor: const Color(0xFF1976D2),
                // 눈금 4개
                // (divisions: 4로 맞추면 5개 눈금, 3이면 4개)
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
          const Text('가',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
