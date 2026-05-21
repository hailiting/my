import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/theme/site_style.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: SiteColors.bg,
      appBar: SiteTopNav(
        selectedPath: path,
        onNavigate: context.go,
      ),
      body: child,
    );
  }
}
