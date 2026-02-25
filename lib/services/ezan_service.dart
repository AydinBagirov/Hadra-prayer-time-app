import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EzanService {
  static final AudioPlayer _audioPlayer = AudioPlayer();


  static const Map<String, String> ezanSounds = {
    'default': 'assets/sounds/ezan.mp3',
    'notification': '',
  };

  static Future<void> playEzan({String? ezanType}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedEzan = ezanType ?? prefs.getString('selectedEzan') ?? 'default';

      if (selectedEzan == 'notification') {
        print('📢 Sadece bildirim sesi seçili');
        return;
      }

      final soundPath = ezanSounds[selectedEzan];
      if (soundPath == null || soundPath.isEmpty) {
        print('⚠️ Ezan sesi bulunamadı: $selectedEzan');
        return;
      }


      await _audioPlayer.stop();


      await _audioPlayer.play(AssetSource(soundPath.replaceFirst('assets/', '')));
      print('🔊 Ezan çalınıyor: $selectedEzan');

    } catch (e) {
      print('❌ Ezan çalma hatası: $e');
    }
  }

  static Future<void> stopEzan() async {
    try {
      await _audioPlayer.stop();
      print('⏹️ Ezan durduruldu');
    } catch (e) {
      print('❌ Ezan durdurma hatası: $e');
    }
  }

    static Future<void> previewEzan(String ezanType) async {
    try {
      final soundPath = ezanSounds[ezanType];
      if (soundPath == null || soundPath.isEmpty) {
        print('⚠️ Ezan sesi bulunamadı: $ezanType');
        return;
      }

      await _audioPlayer.stop();

      await _audioPlayer.play(AssetSource(soundPath.replaceFirst('assets/', '')));


      Future.delayed(const Duration(seconds: 30), () {
        _audioPlayer.stop();
      });

      print('🔊 Ezan önizlemesi: $ezanType');
    } catch (e) {
      print('❌ Ezan önizleme hatası: $e');
    }
  }


  static Future<bool> shouldPlayEzan(String prayerTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final Map<String, String> prayerKeys = {
        'imsak': 'imsakEzan',
        'sunrise': 'sunriseEzan',
        'dhuhr': 'dhuhrEzan',
        'asr': 'asrEzan',
        'maghrib': 'maghribEzan',
        'isha': 'ishaEzan',
      };

      final key = prayerKeys[prayerTime.toLowerCase()];
      if (key == null) return false;

      final isEnabled = prefs.getBool(key) ?? false;
      print('🔍 $prayerTime için ezan: ${isEnabled ? "Açık" : "Kapalı"}');

      return isEnabled;
    } catch (e) {
      print('❌ Ezan kontrolü hatası: $e');
      return false;
    }
  }

  static Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}