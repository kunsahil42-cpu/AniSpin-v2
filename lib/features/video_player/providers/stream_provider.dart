import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/anikoto/anikoto_api.dart';
import '../../anime_details/models/stream_source_model.dart';

/// Identifies a single resolvable stream: a MAL id, an episode number and the
/// sub/dub choice. Using a record keeps the [streamProvider] family key value-
/// equal, so toggling sub/dub or moving to the next episode reuses the cache
/// rather than re-resolving the same request.
typedef StreamRequest = ({int malId, int episode, bool dub});

final anikotoApiProvider = Provider<AnikotoApi>((ref) => AnikotoApi());

/// Resolves the playable [StreamSource] for a [StreamRequest].
///
/// The player watches this and feeds the resulting `.m3u8` (plus required
/// headers) into its `VideoPlayerController`. A thrown [AppFailure] surfaces as
/// the player's "Stream unavailable" + Retry state; `ref.invalidate` on this
/// provider is the retry.
final streamProvider =
    FutureProvider.family<StreamSource, StreamRequest>((ref, req) async {
  final api = ref.read(anikotoApiProvider);
  return api.resolveStream(
    malId: req.malId,
    episode: req.episode,
    dub: req.dub,
  );
});
