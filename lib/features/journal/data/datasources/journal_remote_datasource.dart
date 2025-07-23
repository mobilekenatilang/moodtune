part of '_datasources.dart';

abstract class JournalRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> analyzeJournal(
    Journal journal,
    bool onlyLLM,
  );
}

@Injectable(as: JournalRemoteDataSource)
class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> analyzeJournal(
    Journal journal,
    bool onlyLLM,
  ) async {
    if (journal.title.isEmpty || journal.content.isEmpty) {
      return Parsed.fromDynamicData(400, {'error': 'Journal text is required'});
    }

    final text =
        'Perasaanku kali ini bisa digambarkan dengan kalimat '
        '"${journal.title}". "${journal.content}"';

    Map<String, dynamic> data = {'text': text};

    if (!onlyLLM) {
      // Get user profile for favorite music preferences
      try {
        final profileBloc = get<ProfileBloc>();
        
        if (profileBloc.state is ProfileLoaded) {
          final profile = (profileBloc.state as ProfileLoaded).profile;
          
          // Add favorite singers
          if (profile.favoriteSingers.isNotEmpty) {
            data['favouriteArtist'] = profile.favoriteSingers.join(', ');
            LoggerService.i('Added favorite singers: ${profile.favoriteSingers.join(', ')}');
          }
          
          // Add favorite genres
          if (profile.favoriteGenres.isNotEmpty) {
            data['favouriteGenre'] = profile.favoriteGenres.join(', ');
            LoggerService.i('Added favorite genres: ${profile.favoriteGenres.join(', ')}');
          }
        } else {
          LoggerService.i('Profile not loaded, using default preferences');
        }
      } catch (e) {
        LoggerService.e('Error getting profile for journal analysis: $e');
      }
    }

    LoggerService.i('Analyzing journal with data: $data');

    final response = await postIt(
      onlyLLM ? EndPoints.llm : EndPoints.analyze,
      model: data,
    );

    if (response.statusCode != 201) {
      return Parsed.fromDynamicData(response.statusCode ?? 500, {
        'error': 'Failed to analyze journal',
      });
    }

    final result = Analyzed.fromMap(response.data);
    LoggerService.i('Analyzed journal: \n$result');

    // Store the complete analysis result (emotion + music) as playlist in journal
    if (!onlyLLM && response.data != null) {
      try {
        // Debug: Log the original response structure
        LoggerService.i('Raw response data: ${response.data}');
        
        // Create playlist data structure compatible with JournalPlaylistService
        final playlistData = {
          'emotion': {
            'label': result.emotion.label,
            'emoji': result.emotion.emoji,
            'advice': result.emotion.advice,
          },
          'music': response.data['music'] ?? []
        };
        
        // Debug: Log the playlist data structure
        LoggerService.i('Playlist data to save: $playlistData');
        
        // Update journal with playlist data
        final updatedJournal = Journal(
          timestamp: journal.timestamp,
          title: journal.title,
          content: journal.content,
          mood: journal.mood,
          playlist: jsonEncode(playlistData), // Store complete analysis as JSON
        );
        
        // Save updated journal with playlist data
        final localDataSource = get<JournalLocalDataSource>();
        await localDataSource.update(updatedJournal);
        
        LoggerService.i('Successfully saved playlist data to journal: ${playlistData['music']?.length ?? 0} songs');
        
      } catch (e) {
        LoggerService.e('Error saving playlist to journal: $e');
      }
    }

    return response.parse({'result': result});
  }
}
