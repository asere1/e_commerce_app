import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/utilites/routes.dart';
import 'package:e_commerce_app/views/pages/landing_page.dart';
import 'package:e_commerce_app/views/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/database_controller.dart';
import '../views/pages/auth_page.dart';
import '../views/pages/bottom_navbar.dart';
import '../views/pages/checkout/checkout_page.dart';
import '../views/pages/home_page.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.authPageRoute:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const AuthPage());

    case AppRoutes.homePageRoute:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const HomePage());

    case AppRoutes.bottomNavBarRoute:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const BottomNavbar());

    case AppRoutes.productDetailsPageRoute:
      final args = settings.arguments as Map<String, dynamic>;
      final product = args['product'];
      final database = args['database'];
      return MaterialPageRoute(
          settings: settings, 
           builder: (_) => Provider<Database>.value(
          value: database,
          child: ProductDetails(product: product),
        ),
          );

           case AppRoutes.checkoutPageRoute:
      final database = settings.arguments as Database;
      return MaterialPageRoute(
        builder: (_) => Provider<Database>.value(
          value: database,
          child: const CheckoutPage()),
        settings: settings,
      );

    case AppRoutes.landingPageRoute:
    default:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const LandingPage());
  }
}
