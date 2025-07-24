import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_border/dotted_border.dart';

class FavoritesScreenToggleOff extends StatelessWidget {
  const FavoritesScreenToggleOff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 393,
        height: 852,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F0FF), Color(0xFFD6FFD6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 첫 번째 카드 (정치, 점선 정확히 맞춤)
            Positioned(
              left: 33,
              top: 193,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: -0.1102,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 3,
                    dashPattern: [8, 6],
                    radius: Radius.circular(36),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/a_image/politics_icon.webp',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.gavel, color: Colors.blue, size: 32),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '정치',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '윤석열 대통령, 한미 정상회담 참석',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2024.07.24 | 연합뉴스',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                              color: Color(0xFF9d9c9c),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 두 번째 카드 (경제, 점선 정확히 맞춤)
            Positioned(
              left: 135, // 기존 115에서 20만큼 오른쪽으로 이동
              top: 336,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: 0.162,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 3,
                    dashPattern: [8, 6],
                    radius: Radius.circular(36),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/a_image/IT_icon.webp',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.computer, color: Colors.green, size: 32),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '경제',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '삼성전자, 2분기 실적 발표',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2024.07.24 | 매일경제',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                              color: Color(0xFF9d9c9c),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 세 번째 카드 (이슈, 점선 적용)
            Positioned(
              left: 44.962, // 기존 24.962에서 20만큼 오른쪽으로 이동
              top: 530.479,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: -0.209,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 3,
                    dashPattern: [8, 6],
                    radius: Radius.circular(36),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // 위쪽 정렬
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/a_image/issue_icon.webp',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.whatshot, color: Colors.blue, size: 32),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '이슈',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '폭염특보 전국 확대, 온열질환 주의',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2024.07.24 | YTN',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                              color: Color(0xFF9d9c9c),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 상단 토글 버튼 (디자인용, 동작 없음)
            Positioned(
              left: 306,
              top: 132,
              width: 61,
              height: 32.657,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(231, 231, 231, 0.74),
                  borderRadius: BorderRadius.circular(16.3283),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 2),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 뒤로가기 아이콘 (임시)
            const Positioned(
              left: -5,
              top: 57,
              width: 41,
              height: 41,
              child: Icon(Icons.arrow_back_ios_new,
                  color: Color(0xFF0565FF), size: 32),
            ),
            // 뒤로 텍스트
            const Positioned(
              left: 34,
              top: 65,
              child: Text(
                '뒤로',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF0565FF),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            // 완료 텍스트
            const Positioned(
              left: 330, // 기존 325에서 310으로 조정 (더 왼쪽으로)
              top: 66,
              width: 80, // 기존 66에서 80으로 넓힘
              height: 22,
              child: Text(
                '완료',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Color(0xFF0565FF),
                  decoration: TextDecoration.none,
                ),
                overflow: TextOverflow.visible, // 혹시 모를 잘림 방지
                maxLines: 1,
              ),
            ),
            // 즐겨찾기 제목
            const Positioned(
              left: 159,
              top: 65,
              child: Text(
                '즐겨찾기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            // 전체 외곽선
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
