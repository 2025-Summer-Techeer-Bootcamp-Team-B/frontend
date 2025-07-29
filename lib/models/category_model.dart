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
    "증권": "assets/a_image/certificate_icon.webp", // 새로 추가된 증권 아이콘
    "부동산": "assets/a_image/real_estate_icon.png", // 새로 추가된 부동산 아이콘
  };

  // 선택된 언론사들에 따라 사용 가능한 카테고리 목록을 반환
  static List<String> getAvailableCategories(List<String> selectedMedia) {
    Set<String> allCategories = {};
    
    for (String media in selectedMedia) {
      if (mediaCategories.containsKey(media)) {
        allCategories.addAll(mediaCategories[media]!);
      }
    }
    
    // 원하는 순서대로 정렬
    List<String> categories = allCategories.toList();
    List<String> orderedCategories = [];
    
    // 첫 번째 행: IT, 경제, 국제
    if (categories.contains('IT')) orderedCategories.add('IT');
    if (categories.contains('경제')) orderedCategories.add('경제');
    if (categories.contains('국제')) orderedCategories.add('국제');
    
    // 두 번째 행: 문화, 부동산, 사회
    if (categories.contains('문화')) orderedCategories.add('문화');
    if (categories.contains('부동산')) orderedCategories.add('부동산');
    if (categories.contains('사회')) orderedCategories.add('사회');
    
    // 세 번째 행: 스포츠, 연예, 정치
    if (categories.contains('스포츠')) orderedCategories.add('스포츠');
    if (categories.contains('연예')) orderedCategories.add('연예');
    if (categories.contains('정치')) orderedCategories.add('정치');
    
    // 네 번째 행: 증권 (첫 번째 열에 배치)
    if (categories.contains('증권')) orderedCategories.add('증권');
    
    return orderedCategories;
  }

  // 카테고리의 이미지 경로를 반환
  static String getCategoryImage(String category) {
    return categoryImages[category] ?? "assets/a_image/issue_icon.webp";
  }
} 