import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../home/home_screen.dart';
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
    ];

    // 카드 위치/회전값 (원하는 만큼 추가 가능)
    final List<_CardTransform> cardTransforms = [
      const _CardTransform(dx: 0, dy: 0, angle: -0.06),
      const _CardTransform(dx: 40, dy: 80, angle: 0.04),
      const _CardTransform(dx: 20, dy: 160, angle: -0.03),
    ];

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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomHomeScreen()),
                            );
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
                // 카드들 (겹치게 배치, 세로 스크롤)
                Positioned.fill(
                  top: 80,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: 852,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              for (int i = 0; i < categories.length; i++)
                                Positioned(
                                  left: (constraints.maxWidth - 220) / 2 +
                                      cardTransforms[i % cardTransforms.length]
                                          .dx,
                                  top: cardTransforms[i % cardTransforms.length]
                                          .dy +
                                      i * 60,
                                  child: Transform.rotate(
                                    angle: cardTransforms[
                                            i % cardTransforms.length]
                                        .angle,
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

class _CardTransform {
  final double dx;
  final double dy;
  final double angle;
  const _CardTransform(
      {required this.dx, required this.dy, required this.angle});
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
