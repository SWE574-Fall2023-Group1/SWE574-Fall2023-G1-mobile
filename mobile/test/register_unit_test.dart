import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/register/model/register_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late RegisterRepositoryImp registerRepository;
  late MockNetworkManager mockNetworkManager;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    registerRepository =
        RegisterRepositoryImp(networkManager: mockNetworkManager);

    // Register fallback values for any types used in the mocked methods
    registerFallbackValue(Uri());
  });

  group('RegisterRepositoryImp Tests', () {});
}
