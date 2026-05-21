import 'package:flutter/material.dart';
import 'package:portfolio_app/core/theme/site_style.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.lead,
  });

  final String number;
  final String title;
  final String? subtitle;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                number,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          if (lead != null) ...[
            const SizedBox(height: 12),
            Text(
              lead!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.75,
                    color: SiteColors.textMuted,
                  ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: SiteColors.textMuted.withOpacity(0.85),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
