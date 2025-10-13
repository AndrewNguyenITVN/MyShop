import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'ui/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.purple,
      secondary: Colors.deepOrange,
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
        )
      ),
    );

    final router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/products',
      routes: [
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductsOverviewScreen(),
        ),
        GoRoute(
          path: '/products/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId']!;
            final product = context.read<ProductsManager>().findById(productId);
            return SafeArea(child: ProductDetailScreen(product!),);
          }
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const SafeArea(child: CartScreen(),),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const SafeArea(child: OrdersScreen(),),
        ),
        GoRoute(
          path: '/my-products',
          builder: (context, state) => const SafeArea(child: UserProductsScreen(),),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsManager()),
      ],
      child: MaterialApp.router(
        title: 'MyShop',
        debugShowCheckedModeBanner: false,
        theme: themData,
        routerConfig: router,
      ),
    );
  }
}
