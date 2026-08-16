import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/presentation/sign_in_screen.dart';
import 'features/my_files/presentation/my_files_screen.dart';
import 'features/recycle_bin/presentation/recycle_bin_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_colors.dart';
import 'theme/app_radius.dart';
import 'theme/app_sizes.dart';
import 'theme/app_spacing.dart';
import 'theme/app_theme.dart';
import 'theme/app_typography.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _signedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _signedIn
          ? _DriveShell(
              onSignOut: () => setState(() => _signedIn = false),
            )
          : SignInScreen(
              onSignIn: () => setState(() => _signedIn = true),
            ),
    );
  }
}

class _DriveShell extends StatefulWidget {
  const _DriveShell({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  State<_DriveShell> createState() => _DriveShellState();
}

class _DriveShellState extends State<_DriveShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback? _pendingDrawerAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final safeTop = MediaQuery.paddingOf(context).top;

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerScrimColor: AppColors.drawerScrim,
      onDrawerChanged: _handleDrawerChanged,
      drawer: _DriveNavigationDrawer(
        onRecycleBin: () => _closeDrawerThen(_openRecycleBin),
        onSignOut: () => _closeDrawerThen(_showSignOutConfirmation),
      ),
      body: Stack(
        children: [
          const MyFilesScreen(),
          PositionedDirectional(
            start: 0,
            top: safeTop,
            width: AppSizes.myFilesAvatarTapTargetWidth,
            height: AppSizes.myFilesTopBarHeight,
            child: Semantics(
              button: true,
              label: l10n.openNavigationDrawer,
              child: GestureDetector(
                key: const Key('driveDrawerAvatarButton'),
                behavior: HitTestBehavior.translucent,
                onTap: _openDrawer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawerThen(VoidCallback action) {
    _pendingDrawerAction = action;
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _handleDrawerChanged(bool isOpened) {
    if (isOpened || _pendingDrawerAction == null) return;

    final action = _pendingDrawerAction!;
    _pendingDrawerAction = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) action();
    });
  }

  void _openRecycleBin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RecycleBinScreen(),
      ),
    );
  }

  Future<void> _showSignOutConfirmation() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.dialogScrim,
      builder: (dialogContext) {
        return _SignOutConfirmationDialog(
          title: l10n.signOutConfirmationTitle,
          message: l10n.signOutConfirmationBodyPersonal,
          cancelLabel: l10n.cancel,
          confirmLabel: MaterialLocalizations.of(dialogContext).okButtonLabel,
        );
      },
    );

    if (confirmed == true && mounted) {
      widget.onSignOut();
    }
  }
}

class _SignOutConfirmationDialog extends StatelessWidget {
  const _SignOutConfirmationDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final actionStyle = TextButton.styleFrom(
      minimumSize: const Size(
        AppSizes.signOutDialogActionMinWidth,
        AppSizes.signOutDialogActionHeight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: AppTypography.signOutDialogAction,
      foregroundColor: AppColors.brandForeground1,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.signOutDialogHorizontalInset,
      ),
      backgroundColor: AppColors.neutralBackground1,
      surfaceTintColor: AppColors.transparent,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.signOutDialog),
      ),
      child: SizedBox(
        key: const Key('signOutDialog'),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.signOutDialogTopPadding,
            bottom: AppSizes.signOutDialogBottomPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.signOutDialogHorizontalPadding,
                ),
                child: Text(
                  title,
                  key: const Key('signOutDialogTitle'),
                  style: AppTypography.signOutDialogTitle,
                ),
              ),
              const SizedBox(height: AppSizes.signOutDialogTitleBodyGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.signOutDialogHorizontalPadding,
                ),
                child: Text(
                  message,
                  key: const Key('signOutDialogBody'),
                  style: AppTypography.signOutDialogBody,
                ),
              ),
              const SizedBox(height: AppSizes.signOutDialogBodyActionsGap),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppSizes.signOutDialogActionsRightPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      key: const Key('signOutDialogCancel'),
                      style: actionStyle,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelLabel),
                    ),
                    const SizedBox(width: AppSizes.signOutDialogActionSpacing),
                    TextButton(
                      key: const Key('signOutDialogConfirm'),
                      style: actionStyle,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(confirmLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriveNavigationDrawer extends StatelessWidget {
  const _DriveNavigationDrawer({
    required this.onRecycleBin,
    required this.onSignOut,
  });

  final VoidCallback onRecycleBin;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      key: const Key('driveNavigationDrawer'),
      width: AppSizes.driveDrawerWidth,
      backgroundColor: AppColors.neutralBackground2,
      surfaceTintColor: AppColors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(AppRadius.driveDrawer),
          bottomEnd: Radius.circular(AppRadius.driveDrawer),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          children: [
            _DriveDrawerItem(
              key: const Key('driveDrawerRecycleBin'),
              icon: Icons.delete_outline_rounded,
              label: l10n.recycleBinTitle,
              onTap: onRecycleBin,
            ),
            _DriveDrawerItem(
              key: const Key('driveDrawerSettings'),
              icon: Icons.settings_outlined,
              label: l10n.drawerSettings,
            ),
            _DriveDrawerItem(
              key: const Key('driveDrawerHelp'),
              icon: Icons.help_outline_rounded,
              label: l10n.drawerHelpAndFeedback,
            ),
            _DriveDrawerItem(
              key: const Key('driveDrawerSignOut'),
              icon: Icons.logout_rounded,
              label: l10n.drawerSignOut,
              onTap: onSignOut,
            ),
            _DriveDrawerItem(
              key: const Key('driveDrawerPrivacy'),
              icon: Icons.lock_outline_rounded,
              label: l10n.drawerPrivacyAndCookies,
            ),
          ],
        ),
      ),
    );
  }
}

class _DriveDrawerItem extends StatelessWidget {
  const _DriveDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.driveDrawerItemHeight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppSizes.driveDrawerIconSize,
                color: AppColors.neutralForeground2,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
