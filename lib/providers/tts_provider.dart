import 'package:flutter/material.dart';
import '../models/article_models.dart';
import 'package:just_audio/just_audio.dart';

class TtsProvider extends ChangeNotifier {
  ArticleModel? _currentArticle;
  bool _isPlaying = false;
  String? _currentAudioPlayerId;
  AudioPlayer? _currentAudioPlayer;
  bool _hasPlayedOnce = false; // 한 번이라도 재생된 적이 있는지 추적
  Duration _currentPosition = Duration.zero; // 현재 재생 위치 저장

  ArticleModel? get currentArticle => _currentArticle;
  bool get isPlaying => _isPlaying;
  String? get currentAudioPlayerId => _currentAudioPlayerId;
  AudioPlayer? get currentAudioPlayer => _currentAudioPlayer;
  bool get hasPlayedOnce => _hasPlayedOnce;
  Duration get currentPosition => _currentPosition;

  void setArticle(ArticleModel article, {String? audioPlayerId, AudioPlayer? audioPlayer}) {
    // 기사 정보만 설정하고 자동 재생하지 않음
    _currentArticle = article;
    _isPlaying = false;
    _currentAudioPlayerId = audioPlayerId;
    _currentAudioPlayer = audioPlayer;
    _currentPosition = Duration.zero; // 새 기사는 위치 초기화
    notifyListeners();
  }

  void updateAudioPlayer(AudioPlayer? audioPlayer) {
    // 오디오 플레이어만 업데이트 (재생 상태는 유지)
    _currentAudioPlayer = audioPlayer;
    notifyListeners();
  }

  void play(ArticleModel article, {String? audioPlayerId, AudioPlayer? audioPlayer}) async {
    // 다른 기사가 재생 중이면 자동으로 정지
    if (_isPlaying && _currentArticle?.id != article.id) {
      // 이전 오디오 플레이어 정지
      if (_currentAudioPlayer != null) {
        _currentAudioPlayer!.pause();
      }
      _isPlaying = false;
      _currentArticle = null;
      _currentAudioPlayerId = null;
      _currentAudioPlayer = null;
      _currentPosition = Duration.zero; // 위치 초기화
      notifyListeners();
    }
    
    // 새 기사인지 확인
    bool isNewArticle = _currentArticle?.id != article.id;
    
    // 현재 기사 설정
    _currentArticle = article;
    _isPlaying = true;
    _hasPlayedOnce = true; // 한 번 재생됨을 표시
    _currentAudioPlayerId = audioPlayerId;
    _currentAudioPlayer = audioPlayer;
    
    // 상태를 먼저 업데이트
    print('TtsProvider: 재생 - isPlaying: $_isPlaying, isNewArticle: $isNewArticle');
    notifyListeners();
    
    // 새 기사는 처음부터 시작, 같은 기사는 저장된 위치에서 재생
    if (audioPlayer != null) {
      if (isNewArticle) {
        // 새 기사는 처음부터 시작
        _currentPosition = Duration.zero;
        await audioPlayer.seek(Duration.zero);
        print('새 기사: 처음부터 시작');
      } else if (_currentPosition > Duration.zero) {
        // 같은 기사는 저장된 위치에서 재생
        await audioPlayer.seek(_currentPosition);
        print('같은 기사: ${_currentPosition.inSeconds}초부터 시작');
      } else {
        // 처음 재생하는 경우
        await audioPlayer.seek(Duration.zero);
        print('처음 재생: 처음부터 시작');
      }
    }
  }

  void pause() async {
    // 현재 오디오 플레이어 정지 및 위치 저장
    if (_currentAudioPlayer != null) {
      _currentPosition = await _currentAudioPlayer!.position;
      _currentAudioPlayer!.pause();
    }
    _isPlaying = false;
    print('TtsProvider: 일시정지 - isPlaying: $_isPlaying');
    notifyListeners();
  }

  void stop() {
    // 현재 오디오 플레이어 정지
    if (_currentAudioPlayer != null) {
      _currentAudioPlayer!.pause();
    }
    _isPlaying = false;
    _currentArticle = null;
    _currentAudioPlayerId = null;
    _currentAudioPlayer = null;
    _hasPlayedOnce = false; // 재생 기록 초기화
    notifyListeners();
  }

  bool isCurrentArticle(String articleId) {
    return _currentArticle?.id == articleId;
  }

  bool isCurrentAudioPlayer(String audioPlayerId) {
    return _currentAudioPlayerId == audioPlayerId;
  }
} 