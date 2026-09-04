import '../../models/pet_fact.dart';
import '../../utils/constants.dart';
import 'api_client.dart';

/// Pulls together two independent, key-less public APIs to produce a single
/// "did you know?" style card: a fun fact from catfact.ninja and a random
/// dog photo from dog.ceo.
class PetFactRemoteSource {
  final ApiClient _client;

  PetFactRemoteSource({ApiClient? client}) : _client = client ?? ApiClient();

  Future<PetFact> fetchRandomFact() async {
    final factData = await _client.getJson(AppConstants.catFactApi);
    final imageData = await _client.getJson(AppConstants.dogRandomImageApi);
    return PetFact(
      fact: factData['fact'] as String,
      imageUrl: imageData['message'] as String?,
    );
  }
}
