import 'package:best_architecture_challenge/screens/home/bindings/home_bindings.dart';
import 'package:best_architecture_challenge/screens/home/views/home_view.dart';

import 'app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: '/', page: () => HomeView(), binding: HomeBindings()),
  ];
}
