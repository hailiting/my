import 'package:flutter/material.dart';

/// 与 legacy/static-site/css/style.css 对齐的设计令牌。
abstract final class SiteColors {
  static const bg = Color(0xFF0A0E17);
  static const bgAlt = Color(0xFF111827);
  static const surface = Color(0xFF1A2234);
  static const text = Color(0xFFE8EDF5);
  static const textMuted = Color(0xFF94A3B8);
  static const accent = Color(0xFF38BDF8);
  static const accent2 = Color(0xFFA78BFA);
  static const border = Color(0x2663B3ED);
  static const radius = 12.0;
  static const navH = 64.0;
  static const maxContent = 1100.0;

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accent2, Color(0xFFF472B6)],
  );
}

class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (b) => SiteColors.gradient.createShader(b),
      child: Text(
        text,
        style: (style ?? Theme.of(context).textTheme.headlineMedium)?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
      ),
    );
  }
}

/// 顶栏固定导航（对应 .nav）
class SiteTopNav extends StatelessWidget implements PreferredSizeWidget {
  const SiteTopNav({
    super.key,
    required this.selectedPath,
    required this.onNavigate,
  });

  final String selectedPath;
  final ValueChanged<String> onNavigate;

  static const _links = [
    ('全景图', '/'),
    ('技能', '/skills'),
    ('作品', '/projects'),
    ('实验室', '/lab'),
    ('关于', '/about'),
    ('联系', '/contact'),
  ];

  bool _active(String path) {
    if (path == '/') {
      return selectedPath == '/' ||
          selectedPath.startsWith('/skill') ||
          selectedPath == '/architecture';
    }
    return selectedPath == path || selectedPath.startsWith('$path/');
  }

  @override
  Size get preferredSize => const Size.fromHeight(SiteColors.navH);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;

    return Material(
      color: SiteColors.bg.withOpacity(0.85),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: SiteColors.border)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: SiteColors.navH,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onNavigate('/'),
                    child: const GradientText(
                      '海立婷',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (wide) ...[
                    const Spacer(),
                    for (final link in _links) ...[
                      _NavLink(
                        label: link.$1,
                        active: _active(link.$2),
                        onTap: () => onNavigate(link.$2),
                      ),
                    ],
                  ] else ...[
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.menu, color: SiteColors.text),
                      color: SiteColors.surface,
                      onSelected: onNavigate,
                      itemBuilder: (_) => [
                        for (final link in _links)
                          PopupMenuItem(
                            value: link.$2,
                            child: Text(
                              link.$1,
                              style: TextStyle(
                                color: _active(link.$2)
                                    ? SiteColors.accent
                                    : SiteColors.text,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: active ? SiteColors.text : SiteColors.textMuted,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: active ? SiteColors.text : SiteColors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Hero 背景光晕（对应 .hero-bg）
class HeroBackdrop extends StatelessWidget {
  const HeroBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.9),
                  radius: 1.2,
                  colors: [
                    SiteColors.accent.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.6,
                heightFactor: 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        SiteColors.accent2.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// 页面内容区（对应 .container）
class SiteContainer extends StatelessWidget {
  const SiteContainer({
    super.key,
    required this.child,
    this.alt = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
  });

  final Widget child;
  final bool alt;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: alt ? SiteColors.bgAlt : SiteColors.bg,
      child: Padding(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: SiteColors.maxContent),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SitePrimaryButton extends StatelessWidget {
  const SitePrimaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: SiteColors.gradient,
        borderRadius: BorderRadius.circular(SiteColors.radius),
        boxShadow: [
          BoxShadow(
            color: SiteColors.accent.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(SiteColors.radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text(
              label,
              style: const TextStyle(
                color: SiteColors.bg,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SiteOutlineButton extends StatelessWidget {
  const SiteOutlineButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: SiteColors.text,
        side: const BorderSide(color: SiteColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SiteColors.radius),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    );
  }
}

class SiteStatTile extends StatelessWidget {
  const SiteStatTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SiteColors.surface,
        borderRadius: BorderRadius.circular(SiteColors.radius),
        border: Border.all(color: SiteColors.border),
      ),
      child: Column(
        children: [
          GradientText(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: SiteColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class SitePanel extends StatelessWidget {
  const SitePanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SiteColors.surface,
        borderRadius: BorderRadius.circular(SiteColors.radius),
        border: Border.all(color: SiteColors.border),
      ),
      child: child,
    );
  }
}

/// 子页面统一滚动布局（对应 .section + .container）
class SitePageScroll extends StatelessWidget {
  const SitePageScroll({
    super.key,
    required this.child,
    this.alt = false,
  });

  final Widget child;
  final bool alt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SiteContainer(alt: alt, child: child),
    );
  }
}

class SiteChipButton extends StatelessWidget {
  const SiteChipButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SiteColors.bgAlt,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: SiteColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: enabled ? SiteColors.accent : SiteColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
