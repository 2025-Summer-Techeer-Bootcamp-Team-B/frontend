import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Marquee 패키지를 사용하기 위해 추가
import 'package:marquee/marquee.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 393,
          height: 852,
          child: Stack(
            children: [
              // 홈 타이틀
              Positioned(
                left: 20,
                top: 15,
                child: Text(
                  '홈',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
              // 실시간 속보 아이콘 + 텍스트
              Positioned(
                left: 20,
                top: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/a_image/home_newsflash_icon.png',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '실시간 속보',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF0565FF),
                      ),
                    ),
                  ],
                ),
              ),
              // 실시간 기사 카드 1 (검은 네모 + 사진이 위에)
              Positioned(
                left: 20,
                top: 100,
                child: Stack(
                  children: [
                    // 검은 네모 배경
                    Container(
                      width: 220,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.black,
                      ),
                    ),
                    // 사진이 위에
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/a_image/home_news1.jpg',
                          width: 220,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 카테고리 태그, 기사 제목 등 기존 내용은 그대로
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0565FF),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          '문화',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // 기사 제목에 marquee 적용
                    Positioned(
                      bottom: 70,
                      left: 12,
                      right: 12,
                      child: SizedBox(
                        height: 20,
                        child: Marquee(
                          text: "'케이팝 데몬 헌터스' OST, 빌보드",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          scrollAxis: Axis.horizontal,
                          blankSpace: 20.0,
                          velocity: 30.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 0.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 50,
                      left: 12,
                      child: Text(
                        '기사 출처',
                        style: TextStyle(
                          color: Color(0xFFC69F9F),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow, size: 16, color: Colors.black),
                            SizedBox(width: 3),
                            Text(
                              '5 : 00',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 실시간 기사 카드 2도 동일하게 적용
              Positioned(
                left: 250,
                top: 100,
                child: Stack(
                  children: [
                    // 검은 네모 배경
                    Container(
                      width: 220,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.black,
                      ),
                    ),
                    // 사진이 위에
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/a_image/home_news2.jpg',
                          width: 220,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 카테고리 태그, 기사 제목 등 기존 내용은 그대로
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0565FF),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          '정치',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // 기사 제목에 marquee 적용
                    Positioned(
                      bottom: 70,
                      left: 12,
                      right: 12,
                      child: SizedBox(
                        height: 20,
                        child: Marquee(
                          text: '여야, 검찰 개혁 공청회서 격돌',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          scrollAxis: Axis.horizontal,
                          blankSpace: 20.0,
                          velocity: 30.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 0.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 50,
                      left: 12,
                      child: Text(
                        '기사 출처',
                        style: TextStyle(
                          color: Color(0xFFC69F9F),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow, size: 16, color: Colors.black),
                            SizedBox(width: 3),
                            Text(
                              '4 : 30',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 오늘의 뉴스 타이틀
              Positioned(
                left: 20,
                top: 410,
                child: Text(
                  '오늘의 뉴스',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600, // 실시간 속보와 동일
                    fontSize: 20,
                    color: Color(0xFF0565FF),
                  ),
                ),
              ),
              // 오늘의 뉴스 카테고리 카드들
              Positioned(
                left: 0,
                top: 440,
                child: SizedBox(
                  width: 393,
                  height: 130,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        // 정치
                        Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 제목(가운데 정렬)
                              SizedBox(
                                height: 22,
                                width: 90,
                                child: Text(
                                  '정치',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // 아이콘(사진이 아래)
                              Image.asset(
                                'assets/a_image/politics_icon.webp',
                                width: 75,
                                height: 65,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        // 경제
                        Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCEF6FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 제목(가운데 정렬)
                              SizedBox(
                                height: 22,
                                width: 90,
                                child: Text(
                                  '경제',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // 아이콘(사진이 아래)
                              Image.asset(
                                'assets/a_image/economy.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        // 사회
                        Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 제목(가운데 정렬)
                              SizedBox(
                                height: 22,
                                width: 90,
                                child: Text(
                                  '사회',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // 아이콘(사진이 아래)
                              Image.asset(
                                'assets/a_image/society_icon.webp',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        // 필요시 더 추가
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // 하단 네비게이션 바
              Positioned(
                left: 0,
                bottom: 0,
                child: Column(
                  children: [
                    // 얇은 회색 경계선
                    Container(
                      width: 393,
                      height: 1,
                      color: Color(0xFFBDBDBD), // 연한 회색
                    ),
                    // 네비게이션 바 본체
                    Container(
                      width: 393,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.03),
                            Colors.grey.withOpacity(0.53),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 설정
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/a_image/pl_setting_icon.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  '설정',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // 설정-즐겨찾기 사이 구분선
                            Container(
                              width: 1,
                              height: 30,
                              color: Color(0xFFBDBDBD),
                            ),
                            // 즐겨찾기
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/a_image/pl_star_icon.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  '즐겨찾기',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // 즐겨찾기-재생기록 사이 구분선
                            Container(
                              width: 1,
                              height: 30,
                              color: Color(0xFFBDBDBD),
                            ),
                            // 재생 기록
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/a_image/pl_history_icon.png',
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  '재생 기록',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
