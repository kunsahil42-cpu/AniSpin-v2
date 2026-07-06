class EpisodeModel {
  final int number;
  final String title;
  final String thumbnail;
  final String? airDate;
  final String? runtime;
  final String description;

  // Audio options
  final Map<String, Map<String, String>> servers; // e.g. {'Sub': {'Server 1': 'url1', 'Server 2': 'url2'}, 'Dub': {...}}
  final List<String> subtitles; // list of subtitle URLs or names

  EpisodeModel({
    required this.number,
    required this.title,
    required this.thumbnail,
    this.airDate,
    this.runtime,
    required this.description,
    required this.servers,
    required this.subtitles,
  });

  factory EpisodeModel.create({
    required int number,
    required String title,
    required String thumbnail,
    String? airDate,
    String? runtime,
    String? description,
  }) {
    return EpisodeModel(
      number: number,
      title: title,
      thumbnail: thumbnail,
      airDate: airDate,
      runtime: runtime ?? '24 min',
      description: description ?? 'Watch episode $number.',
      servers: const {},
      subtitles: const [],
    );
  }

  factory EpisodeModel.mock(int animeId, int episodeNumber) {
    // Stable high-quality public test streams
    const subServers = {
      'Server 1 (HLS)': 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
      'Server 2 (Backup)': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      'Server 3 (MP4)': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunby.mp4',
    };

    const dubServers = {
      'Server 1 (HLS)': 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
      'Server 2 (Backup)': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      'Server 3 (MP4)': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    };

    return EpisodeModel(
      number: episodeNumber,
      title: 'Episode $episodeNumber: The Journey Begins',
      thumbnail: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500&auto=format&fit=crop&q=60',
      airDate: 'July ${5 + episodeNumber}, 2026',
      runtime: '24 min',
      description: 'The protagonist sets out on their ultimate adventure, facing unexpected obstacles and meeting mysterious new allies.',
      servers: {
        'Sub': subServers,
        'Dub': dubServers,
      },
      subtitles: [
        'English',
        'Spanish',
        'French',
      ],
    );
  }
}
