import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/theme/app_theme.dart';

final appThemeDataProvider = Provider<ThemeData>((ref) => AppTheme.site);
