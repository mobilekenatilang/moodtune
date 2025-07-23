import 'package:url_launcher/url_launcher.dart';
import 'package:moodtune/services/logger_service.dart';

class UrlLauncherUtils {
  /// Launch Spotify URL
  static Future<void> launchSpotifyUrl(String url) async {
    try {
      LoggerService.i('🎵 Attempting to launch Spotify URL: $url');
      
      if (url.isEmpty) {
        LoggerService.w('⚠️ Spotify URL is empty');
        return;
      }

      final uri = Uri.parse(url);
      
      // Try to launch the URL
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Force external app
        );
        LoggerService.i('✅ Successfully launched Spotify URL');
      } else {
        LoggerService.e('❌ Cannot launch Spotify URL: $url');
        
        // Fallback: try to launch in browser
        await launchUrl(
          uri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    } catch (e) {
      LoggerService.e('❌ Error launching Spotify URL: $e');
      
      // Last fallback: try to open in any external app
      try {
        final uri = Uri.parse(url);
        await launchUrl(uri);
      } catch (fallbackError) {
        LoggerService.e('❌ Fallback launch also failed: $fallbackError');
      }
    }
  }

  /// Launch any external URL
  static Future<void> launchExternalUrl(String url) async {
    try {
      LoggerService.i('🌐 Attempting to launch external URL: $url');
      
      if (url.isEmpty) {
        LoggerService.w('⚠️ URL is empty');
        return;
      }

      final uri = Uri.parse(url);
      
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        LoggerService.i('✅ Successfully launched external URL');
      } else {
        LoggerService.e('❌ Cannot launch URL: $url');
      }
    } catch (e) {
      LoggerService.e('❌ Error launching external URL: $e');
    }
  }
}
