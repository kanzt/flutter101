import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DevModeBadge extends StatelessWidget {
  const DevModeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kDebugMode
            ? AppColors.accent.withValues(alpha: 0.15)
            : AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kDebugMode
              ? AppColors.accent.withValues(alpha: 0.4)
              : AppColors.success.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Text(
        kDebugMode ? 'LOCAL MODE' : 'LIVE MODE',
        style: TextStyle(
          color: kDebugMode ? AppColors.accent : AppColors.success,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
