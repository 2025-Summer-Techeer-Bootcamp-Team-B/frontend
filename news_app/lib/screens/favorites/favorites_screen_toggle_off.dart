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
            // 파란색 블롭 (왼쪽 아래, blur 적용)
            Positioned(
              left: -60,
              top: 570,
              width: 260,
              height: 260,
              child: SvgPicture.string(
                '''
                <svg width="260" height="260" viewBox="0 0 260 260" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <g filter="url(#blur1)">
                    <ellipse cx="130" cy="130" rx="110" ry="110" fill="url(#paint0_linear_blue)" fill-opacity="0.7"/>
                  </g>
                  <defs>
                    <filter id="blur1" x="-200" y="-200" width="600" height="600" filterUnits="userSpaceOnUse">
                      <feGaussianBlur stdDeviation="60"/>
                    </filter>
                    <linearGradient id="paint0_linear_blue" x1="130" y1="240" x2="130" y2="20" gradientUnits="userSpaceOnUse">
                      <stop stop-color="#0565FF"/>
                      <stop offset="1" stop-color="#D1D5F5"/>
                    </linearGradient>
                  </defs>
                </svg>
                ''',
                fit: BoxFit.cover,
              ),
            ),
            // 연두색 블롭 (오른쪽 위, blur 적용)
            Positioned(
              left: 180,
              top: 40,
              width: 260,
              height: 260,
              child: SvgPicture.string(
                '''
                <svg width="260" height="260" viewBox="0 0 260 260" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <g filter="url(#blur2)">
                    <ellipse cx="130" cy="130" rx="110" ry="110" fill="url(#paint0_linear_green)" fill-opacity="0.7"/>
                  </g>
                  <defs>
                    <filter id="blur2" x="-200" y="-200" width="600" height="600" filterUnits="userSpaceOnUse">
                      <feGaussianBlur stdDeviation="60"/>
                    </filter>
                    <linearGradient id="paint0_linear_green" x1="130" y1="240" x2="130" y2="20" gradientUnits="userSpaceOnUse">
                      <stop stop-color="#B6FF6E"/>
                      <stop offset="1" stop-color="#83CC3A"/>
                    </linearGradient>
                  </defs>
                </svg>
                ''',
                fit: BoxFit.cover,
              ),
            ),
            // 첫 번째 카드 (정치, 점선 정확히 맞춤)
            Positioned(
              left: 13,
              top: 193,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: -0.1102,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 4,
                    dashPattern: [10, 8],
                    radius: Radius.circular(47),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(238, 238, 238, 0.3),
                      borderRadius: BorderRadius.circular(47),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        // 정치 아이콘
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/a_image/politics_icon.webp',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.gavel,
                                    color: Colors.blue, size: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '정치',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '즐겨찾기 한 뉴스가 없습니다.',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color(0xFF9d9c9c),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 두 번째 카드 (경제, 점선 정확히 맞춤)
            Positioned(
              left: 115,
              top: 336,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: 0.162,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 4,
                    dashPattern: [10, 8],
                    radius: Radius.circular(47),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(238, 238, 238, 0.8),
                      borderRadius: BorderRadius.circular(47),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        // 경제 아이콘
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/a_image/IT_icon.webp',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.computer,
                                    color: Colors.green, size: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '경제',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 세 번째 카드 (이슈, 점선 적용)
            Positioned(
              left: 24.962,
              top: 530.479,
              width: 221,
              height: 262,
              child: Transform.rotate(
                angle: -0.209,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    color: Color(0xFFdadada),
                    strokeWidth: 4,
                    dashPattern: [10, 8],
                    radius: Radius.circular(47),
                  ),
                  child: Container(
                    width: 221,
                    height: 262,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(47),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이슈 아이콘
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/a_image/issue_icon.webp',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.whatshot,
                                    color: Colors.blue, size: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '이슈',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                ),
              ),
            ),
            // 완료 텍스트
            const Positioned(
              left: 325,
              top: 66,
              width: 66,
              height: 22,
              child: Text(
                '완료',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Color(0xFF0565FF),
                ),
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
