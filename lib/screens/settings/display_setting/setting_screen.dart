import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contents_setting/keyword_edit.dart';
import '../contents_setting/voice_edit.dart';
import '../contents_setting/press_edit.dart';
import '../contents_setting/category_edit.dart';
import 'font_size.dart';
import '../../home/home_screen.dart';
import '../../history/history_list_screen.dart';
import '../../briefing/bri_playlist.dart';
import '../../auth/interest/voice_select.dart';
import '../../../providers/user_info_provider.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // 각 설정 카테고리의 확장 상태를 관리
  Map<String, bool> expandedStates = {
    '콘텐츠 설정': false,
    '알림 설정': false,
    '화면 설정': false,
    '기록 / 저장 관리': false,
    '앱 정보': false,
  };

  // 토글 상태 관리
  bool isMaleVoice = true; // 목소리 설정 (true: 남성, false: 여성)
  bool isDarkMode = false; // 다크모드 설정

  @override
  Widget build(BuildContext context) {
    final prevScreen = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: 393,
          height: 852,
          color: Colors.white,
          child: Column(
            children: [
              // 상단 헤더
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    // 뒤로가기 버튼
                    GestureDetector(
                      onTap: () {
                        if (prevScreen == 'home') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const CustomHomeScreen()),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 24,
                            color: Color(0xFF0565FF),
                          ),
                          SizedBox(width: 2),
                          Text(
                            '뒤로',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0565FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 사용자 프로필 카드
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: 363,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // 프로필 이미지
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 사용자 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<UserInfoProvider>(
                                builder: (context, userInfoProvider, child) {
                                  return Text(
                                    userInfoProvider.userEmail ?? '사용자 정보 없음',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Pretendard',
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  // 비밀번호 찾기 페이지로 이동
                                },
                                child: const Text(
                                  '비밀번호 찾기',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                    color: Color(0xFF969696),
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
              ),

              const SizedBox(height: 32),

              // 설정 메뉴
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 콘텐츠 설정
                        _buildSettingCategory(
                          icon: 'assets/a_image/contents_setting_icon.png',
                          title: '콘텐츠 설정',
                          subItems: [
                            '관심 카테고리 수정',
                            '관심 키워드 수정',
                            '관심 언론사 수정',
                            '음성 설정',
                          ],
                        ),
                        _buildDivider(),

                        // 알림 설정
                        _buildSettingCategory(
                          icon: 'assets/a_image/Notification_setting_icon.png',
                          title: '알림 설정',
                          subItems: [
                            // 즐겨찾기 기능 제거됨
                          ],
                        ),
                        _buildDivider(),

                        // 화면 설정
                        _buildSettingCategory(
                          icon: 'assets/a_image/display_setting_icon.png',
                          title: '화면 설정',
                          subItems: [
                            '다크모드',
                            '글자 크기 조정',
                            '테마 색깔 변경',
                          ],
                          hasToggle: true,
                          toggleValue: isDarkMode,
                          onToggleChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),
                        _buildDivider(),

                        // 기록 / 저장 관리
                        _buildSettingCategory(
                          icon: 'assets/a_image/save_setting_icon.png',
                          title: '기록 / 저장 관리',
                          subItems: [
                            '재생기록 초기화',
                            '즐겨찾기 초기화',
                            '설정 초기화',
                          ],
                        ),
                        _buildDivider(),

                        // 앱 정보
                        _buildSettingCategory(
                          icon: 'assets/a_image/information_setting_icon.png',
                          title: '앱 정보',
                          subItems: [
                            '앱 버전',
                            '피드백 보내기',
                            '오픈소스 라이선스',
                            '공지사항',
                          ],
                        ),
                        _buildDivider(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCategory({
    required String icon,
    required String title,
    required List<String> subItems,
    bool hasToggle = false,
    bool toggleValue = false,
    ValueChanged<bool>? onToggleChanged,
  }) {
    bool isExpanded = expandedStates[title] ?? false;

    return Column(
      children: [
        // 메인 설정 아이템
        GestureDetector(
          onTap: () {
            setState(() {
              expandedStates[title] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                // 아이콘
                Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 16),
                // 제목
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                  ),
                ),
                // 화살표 (확장 상태에 따라 회전)
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 하위 메뉴 아이템들
        if (isExpanded && subItems.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: subItems.map((subItem) {
                if (hasToggle && subItem == '다크모드') {
                  return _buildToggleItem(subItem, toggleValue, onToggleChanged);
                } else {
                  return _buildSubItem(subItem);
                }
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubItem(String title) {
    return GestureDetector(
      onTap: () {
        // 하위 아이템 클릭 시 처리
        if (title == '관심 카테고리 수정') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CategoryEditPage(),
            ),
          );
        } else if (title == '관심 키워드 수정') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const KeywordEditPage(),
            ),
          );
        } else if (title == '관심 언론사 수정') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PressEditPage(),
            ),
          );
        } else if (title == '글자 크기 조정') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FontSizeSettingScreen(),
            ),
          );
        } else if (title == '음성 설정') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VoiceEditPage(),
            ),
          );
        } else {
          print('선택된 항목: $title');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, ValueChanged<bool>? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Pretendard',
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0565FF),
            activeTrackColor: const Color(0xFF0565FF).withOpacity(0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFEAE9E9),
    );
  }
}
