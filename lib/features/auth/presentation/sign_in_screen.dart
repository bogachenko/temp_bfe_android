import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    this.onSignIn,
    this.onSkipToPhotos,
  });

  final VoidCallback? onSignIn;
  final VoidCallback? onSkipToPhotos;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.neutralBackground1,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: AppColors.neutralBackground1,
      ),
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground1,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: _SignInContent(title: l10n.signInTitle),
                      ),
                    ),
                    _SignInActions(
                      primaryLabel: l10n.signInPrimaryAction,
                      tertiaryLabel: l10n.signInTertiaryAction,
                      onSignIn: onSignIn,
                      onSkipToPhotos: onSkipToPhotos,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInContent extends StatelessWidget {
  const _SignInContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        SizedBox.square(
          dimension: AppSizes.signInIllustration,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxl),
            child: SvgPicture.asset(
              'assets/illustrations/fre_signed_out_state.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.title1,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SignInActions extends StatelessWidget {
  const _SignInActions({
    required this.primaryLabel,
    required this.tertiaryLabel,
    required this.onSignIn,
    required this.onSkipToPhotos,
  });

  final String primaryLabel;
  final String tertiaryLabel;
  final VoidCallback? onSignIn;
  final VoidCallback? onSkipToPhotos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            onPressed: onSignIn ?? () {},
            child: Text(primaryLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onSkipToPhotos ?? () {},
            child: Text(tertiaryLabel),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
