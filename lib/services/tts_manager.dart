import 'package:just_audio/just_audio.dart';
import '../models/article_models.dart';

class TtsManager {
  static final TtsManager _instance = TtsManager._internal();
  factory TtsManager() => _instance;
  TtsManager._internal();

  final AudioPlayer _player = AudioPlayer(); // 한 번만 생성
  ArticleModel? _currentArticle;
  bool _isPlaying = false;

  AudioPlayer get currentPlayer => _player;
  ArticleModel? get currentArticle => _currentArticle;
  bool get isPlaying => _isPlaying;

  Future<void> play(ArticleModel article, String streamingUrl) async {
    if (_isPlaying && _currentArticle?.id != article.id) {
      await stop();
    }
    try {
      // 오디오 로드 및 재생
      await _player.setUrl(streamingUrl);
      await _player.play();
      _currentArticle = article;
      _isPlaying = true;
      print('TTS Manager: 재생 시작 - ${article.title}');
    } catch (e) {
      print('TTS Manager: 재생 실패 - $e');
      await stop();
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
      print('TTS Manager: 일시정지');
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentArticle = null;
    _isPlaying = false;
    print('TTS Manager: 정지');
  }

  bool isCurrentArticle(String articleId) {
    return _currentArticle?.id == articleId;
  }

  void dispose() {
    _player.dispose();
    _currentArticle = null;
    _isPlaying = false;
  }
} 