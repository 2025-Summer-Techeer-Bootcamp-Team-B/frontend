// lib/services/api_service.dart
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.b-team.ai/api/v1', // 백엔드가 배포한 주소
    headers: {
      'Content-Type': 'application/json',
    },
  ),
);
