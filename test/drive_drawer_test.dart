import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temp_bfe_android/app.dart';
import 'package:temp_bfe_android/theme/app_sizes.dart';

void main() {
  Future<void> pumpSignedInApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
  }

  testWidgets('avatar opens 305dp navigation drawer', (tester) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.byKey(const Key('driveDrawerAvatarButton')));
    await tester.pumpAndSettle();

    final drawer = find.byKey(const Key('driveNavigationDrawer'));
    expect(drawer, findsOneWidget);
    expect(tester.getSize(drawer).width, AppSizes.driveDrawerWidth);
    expect(find.text('Recycle bin'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Help and feedback'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('Privacy and cookies'), findsOneWidget);
  });

  testWidgets('Recycle bin item closes drawer and opens existing screen', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.byKey(const Key('driveDrawerAvatarButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('driveDrawerRecycleBin')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('driveNavigationDrawer')), findsNothing);
    expect(find.text('Recycle bin'), findsOneWidget);
    expect(find.text('Delete all'), findsOneWidget);
  });

  testWidgets('Sign out is confirmed before returning to sign in', (
    tester,
  ) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.byKey(const Key('driveDrawerAvatarButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('driveDrawerSignOut')));
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    expect(
      find.text(
        'Signing out will also remove all offline files.\n'
        'Do you want to continue?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.byKey(const Key('driveDrawerAvatarButton')), findsNothing);
  });
}
