import 'package:country/router/app_router_const.dart';
import 'package:country/screens/country_list_screen.dart';
import 'package:country/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class MyAppRouterConfig {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: MyAppRouter().splashRouterPage,
        path: '/', // Ensure you have a parameter for the country slug
        builder: (context, state) {
          return  const SplashScreen();
        },
      ),  GoRoute(
        name: MyAppRouter().countryRouterPage,
        path: '/country', // Ensure you have a parameter for the country slug
        builder: (context, state) {
          return  CountryListScreen();
        },
      ),
    ],
  );

  GoRouter get router => _router;
}


