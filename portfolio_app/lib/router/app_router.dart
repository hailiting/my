import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/features/architecture/architecture_page.dart';
import 'package:portfolio_app/features/about/site_about_page.dart';
import 'package:portfolio_app/features/contact/contact_page.dart';
import 'package:portfolio_app/features/home/home_page.dart';
import 'package:portfolio_app/features/lab/lab_page.dart';
import 'package:portfolio_app/features/projects/projects_page.dart';
import 'package:portfolio_app/features/skills/skill_detail_page.dart';
import 'package:portfolio_app/features/skills/skills_page.dart';
import 'package:portfolio_app/features/shell/app_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomePage()),
          GoRoute(path: '/skills', builder: (_, __) => const SkillsPage()),
          GoRoute(
            path: '/skill/:slug',
            builder: (_, state) => SkillDetailPage(
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: '/projects',
            builder: (_, __) => const ProjectsPage(),
          ),
          GoRoute(path: '/lab', builder: (_, __) => const LabPage()),
          GoRoute(
            path: '/architecture',
            builder: (_, __) => const ArchitecturePage(),
          ),
          GoRoute(path: '/about', builder: (_, __) => const SiteAboutPage()),
          GoRoute(path: '/contact', builder: (_, __) => const ContactPage()),
        ],
      ),
    ],
  );
});
