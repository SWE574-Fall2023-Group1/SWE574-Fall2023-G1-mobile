import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/register/model/register_request_model.dart';
import 'package:memories_app/routes/register/model/register_response_model.dart';
import 'package:memories_app/routes/register/model/register_repository.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late RegisterRepositoryImp registerRepository;
  late MockNetworkManager mockNetworkManager;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    registerRepository =
        RegisterRepositoryImp(networkManager: mockNetworkManager);

    registerFallbackValue(Uri());
    registerFallbackValue(RegisterRequestModel(
      username: '',
      email: '',
      password: '',
      passwordAgain: '',
    ));
  });

  group('RegisterRepository Tests', () {
    test('register calls correct endpoint and returns RegisterResponseModel',
        () async {
      final RegisterRequestModel testRequestModel = RegisterRequestModel(
        username: '',
        email: '',
        password: '',
        passwordAgain: '',
      );
      final RegisterResponseModel mockResponseModel = RegisterResponseModel(
        success: true,
        msg: 'ok',
      );

      // Convert RegisterResponseModel to a Map<String, dynamic>
      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.post(ApiEndpoints.register,
              body: any(named: 'body')))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call register
      final RegisterResponseModel responseModel =
          await registerRepository.register(testRequestModel);

      // Verify that the NetworkManager's post method was called with the correct URL and body
      verify(() => mockNetworkManager.post(ApiEndpoints.register,
          body: testRequestModel)).called(1);

      // Check if the returned object is the same as the mock response
      expect(responseModel.toJson(), equals(mockJson));
    });
  });
}
