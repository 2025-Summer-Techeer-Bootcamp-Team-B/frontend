class CategoryModel {
  static const Map<String, List<String>> mediaCategories = {
    "한국경제": [
      "증권",
      "경제",
      "부동산",
      "IT",
      "정치",
      "국제",
      "사회",
      "문화",
      "스포츠",
      "연예"
    ],
    "SBS뉴스": [
      "정치",
      "경제",
      "사회",
      "국제",
      "문화",
      "연예",
      "스포츠"
    ],
    "매일경제": [
      "경제",
      "정치",
      "사회",
      "국제",
      "증권",
      "부동산",
      "문화",
      "스포츠",
      "IT"
    ]
  };

  static const Map<String, String> categoryImages = {
    "정치": "assets/a_image/politics_icon.webp",
    "경제": "assets/a_image/economy.png",
    "사회": "assets/a_image/society_icon.webp",
    "문화": "assets/a_image/culture_icon.webp",
    "IT": "assets/a_image/IT_icon.webp",
    "국제": "assets/a_image/global_icon.png",
    "스포츠": "assets/a_image/sport_icon.png",
    "연예": "assets/a_image/entertainment.webp",
    "증권": "assets/a_image/economy.png", // 증권은 경제 아이콘 사용
    "부동산": "assets/a_image/economy.png", // 부동산도 경제 아이콘 사용
  };

  // 선택된 언론사들에 따라 사용 가능한 카테고리 목록을 반환
  static List<String> getAvailableCategories(List<String> selectedMedia) {
    Set<String> allCategories = {};
    
    for (String media in selectedMedia) {
      if (mediaCategories.containsKey(media)) {
        allCategories.addAll(mediaCategories[media]!);
      }
    }
    
    return allCategories.toList()..sort();
  }

  // 카테고리의 이미지 경로를 반환
  static String getCategoryImage(String category) {
    return categoryImages[category] ?? "assets/a_image/issue_icon.webp";
  }
} 