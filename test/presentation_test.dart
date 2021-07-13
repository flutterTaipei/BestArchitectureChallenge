import 'package:best_architecture_challenge/core/core_injection.dart';
import 'package:best_architecture_challenge/core/domain/fetch_post_usecase.dart';
import 'package:best_architecture_challenge/main.dart';
import 'package:best_architecture_challenge/screens/home/controllers/home_controller.dart';
import 'package:best_architecture_challenge/screens/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'presentation_test.mocks.dart';
import 'raw.dart';

@GenerateMocks([FetchPostUseCase], customMocks: [
  MockSpec<FetchPostUseCase>(as: #FetchPostUseCase2, returnNullOnMissingStub: true),
])
void main() async {
  CoreInjection.init();
  group(('presentation test'), () {
    late HomeController controller;
    setUp(() {
      final fetchPostUseCase = MockFetchPostUseCase();
      Get.put<FetchPostUseCase>(fetchPostUseCase);
      controller =
          Get.put<HomeController>(HomeController(fetchPostUseCase));

      when(fetchPostUseCase.execute(any))
          .thenAnswer((_) => Future.value(testPosts));
    });

    testWidgets('Home test', (tester) async {
      await tester.pumpWidget(GetMaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/',
        getPages: [GetPage(name: '/', page: () => HomeView())],
      ));

      expect(find.text('Posts: 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.sort));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('使用title排序'));

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(testPosts[1].title, controller.postList[0].title);

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text('使用id排序'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(testPosts[0].title, controller.postList[0].title);
    });
  });
}
