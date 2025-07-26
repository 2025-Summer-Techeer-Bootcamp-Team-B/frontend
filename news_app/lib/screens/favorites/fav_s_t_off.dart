import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../home/home_screen.dart';
import '../history/history_list_screen.dart';
import '../settings/setting_screen.dart';
import '../briefing/bri_playlist.dart';

class FavoritesCategoryScreen extends StatelessWidget {
  const FavoritesCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prevScreen = ModalRoute.of(context)?.settings.arguments as String?;
    // 더미 카테고리 데이터
    final List<Map<String, String>> categories = [
      {
        'icon': 'assets/a_image/issue_icon.webp',
        'name': '이슈',
        'image': 'assets/a_image/home_news1.jpg',
        'date': '25/07/01',
        'title': '뉴스 제목 1',
      },
      {
        'icon': 'assets/a_image/issue_icon.webp',
        'name': '이슈',
        'image': 'assets/a_image/home_news1.jpg',
        'date': '25/07/02',
        'title': '뉴스 제목 2',
      },
      {
        'icon': 'assets/a_image/issue_icon.webp',
        'name': '이슈',
        'image': 'assets/a_image/home_news1.jpg',
        'date': '25/07/03',
        'title': '뉴스 제목 3',
      },
      {
        'icon': 'assets/a_image/issue_icon.webp',
        'name': '이슈',
        'image': 'assets/a_image/home_news1.jpg',
        'date': '25/07/04',
        'title': '뉴스 제목 4',
      },
      {
        'icon': 'assets/a_image/issue_icon.webp',
        'name': '이슈',
        'image': 'assets/a_image/home_news1.jpg',
        'date': '25/07/05',
        'title': '뉴스 제목 5',
      },
    ];

    // 카드 위치/회전값 패턴 (반복 적용)
    // 모든 카드 동일한 위치/회전값 적용
    const double cardDx = 0; // x축 이동 없음
    const double cardAngle = 0; // 회전 없음(혹은 미세하게 -0.01 등으로 조정 가능)

    // 카드 하나의 높이와 카드 간 겹침량(겹침이 많을수록 값이 큼)
    const double cardHeight = 260;
    const double overlapAmount = 60; // 카드가 겹치는 부분의 높이
    const double cardStep = cardHeight - overlapAmount; // 카드가 아래로 이동하는 거리

    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 393,
            height: 852,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F0FF), Color(0xFFF8FFF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // 상단 바
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (prevScreen == 'home') {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CustomHomeScreen()),
                              );
                            } else if (prevScreen == 'briefing') {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BriPlaylistScreen()),
                              );
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back_ios_new,
                                  color: Color(0xFF0565FF), size: 32),
                              SizedBox(width: 2),
                              Text('뒤로',
                                  style: TextStyle(
                                      color: Color(0xFF0565FF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                            ],
                          ),
                        ),
                        const Text(
                          '즐겨찾기',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text('완료',
                            style: TextStyle(
                              color: Color(0xFF0565FF),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                // 카드들 (포개지면서 아래로 쭉 펼쳐짐, 스크롤 정상)
                Positioned.fill(
                  top: 80,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: cardStep * (categories.length - 1) +
                              cardHeight +
                              40,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              for (int i = 0; i < categories.length; i++)
                                Positioned(
                                  left: (constraints.maxWidth - 220) / 2 +
                                      cardDx +
                                      (i % 2 == 0 ? -20 : 40),
                                  top: cardStep * i,
                                  child: Transform.rotate(
                                    angle: cardAngle,
                                    child: DashedBorderCard(
                                      categoryIcon: categories[i]['icon']!,
                                      categoryName: categories[i]['name']!,
                                      imagePath: categories[i]['image']!,
                                      date: categories[i]['date']!,
                                      title: categories[i]['title']!,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderCard extends StatelessWidget {
  final String categoryIcon;
  final String categoryName;
  final String imagePath;
  final String date;
  final String title;
  const DashedBorderCard({
    required this.categoryIcon,
    required this.categoryName,
    required this.imagePath,
    required this.date,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: const RoundedRectDottedBorderOptions(
        color: Color(0xFFdadada),
        strokeWidth: 2,
        dashPattern: [8, 6],
        radius: Radius.circular(28),
      ),
      child: Container(
        width: 220,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            // 카테고리 아이콘 + 이름 (왼쪽 상단)
            Positioned(
              left: 14,
              top: 14,
              child: Row(
                children: [
                  Image.asset(categoryIcon, width: 24, height: 24),
                  const SizedBox(width: 6),
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // 기사 사진 + 제목 + 날짜
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0565FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
