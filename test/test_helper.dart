import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/l10n/app_localizations.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/router.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

@GenerateMocks([ServiceRepository, OrderRepository, SupabaseClient, User])
void main() {}

// A transparent 1x1 pixel image
final kTransparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class MockHttpClientHttp extends Mock implements http.Client {}

class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return super.noSuchMethod(
      Invocation.method(#getUrl, [url]),
      returnValue: Future.value(MockHttpClientRequest()),
      returnValueForMissingStub: Future.value(MockHttpClientRequest()),
    );
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() {
    return super.noSuchMethod(
      Invocation.method(#close, []),
      returnValue: Future.value(MockHttpClientResponse()),
      returnValueForMissingStub: Future.value(MockHttpClientResponse()),
    );
  }
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(kTransparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void setupMockHttpClient() {
  HttpOverrides.global = _MockHttpOverrides();
}

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

Future<void> setupMockSupabase() async {
  await Supabase.initialize(
    url: 'https://test.supabase.co',
    anonKey: 'test',
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
    httpClient: MockHttpClientHttp(),
  );
}

SupabaseClient _createMockSupabaseClient() {
  final mockSupabaseClient = MockSupabaseClient();
  final mockUser = MockUser();

  when(mockSupabaseClient.auth.currentUser).thenReturn(mockUser);

  return mockSupabaseClient;
}

Widget createTestWidget(
  Widget child, {
  List<Override> overrides = const [],
  SupabaseClient? mockSupabaseClient,
}) {
  setupMockSupabase();
  final container = ProviderContainer(
    overrides: [
      supabaseProvider.overrideWithValue(mockSupabaseClient ?? _createMockSupabaseClient()),
      ...overrides,
    ],
  );

  final router = container.read(appRouterProvider);

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}
