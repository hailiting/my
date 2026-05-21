import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/theme/theme_provider.dart';
import 'package:portfolio_app/router/app_router.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeDataProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: '海立婷 · 求职作品集',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
    );
  }
}
