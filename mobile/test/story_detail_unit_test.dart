import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late StoryDetailRepositoryImp storyDetailRepository;
  late MockNetworkManager mockNetworkManager;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    storyDetailRepository =
        StoryDetailRepositoryImp(networkManager: mockNetworkManager);

    // Register fallback values for any types used in the mocked methods
    registerFallbackValue(Uri());
  });

  group('StoryDetailRepositoryImp Tests', () {});
}
