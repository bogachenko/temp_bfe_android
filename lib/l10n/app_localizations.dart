import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Application name used by the shell.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get appName;

  /// Signed-out first-run experience title.
  ///
  /// In en, this message translates to:
  /// **'Protect your files and access them anywhere'**
  String get signInTitle;

  /// Primary action on the signed-out screen.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInPrimaryAction;

  /// Tertiary action on the signed-out screen.
  ///
  /// In en, this message translates to:
  /// **'Skip to my photos'**
  String get signInTertiaryAction;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myFiles.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get myFiles;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// No description provided for @personalVault.
  ///
  /// In en, this message translates to:
  /// **'Personal Vault'**
  String get personalVault;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get sortModified;

  /// No description provided for @sortFileSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get sortFileSize;

  /// No description provided for @sortAtoZ.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get sortAtoZ;

  /// No description provided for @sortZtoA.
  ///
  /// In en, this message translates to:
  /// **'Z to A'**
  String get sortZtoA;

  /// No description provided for @sortOldestToNewest.
  ///
  /// In en, this message translates to:
  /// **'Oldest to newest'**
  String get sortOldestToNewest;

  /// No description provided for @sortNewestToOldest.
  ///
  /// In en, this message translates to:
  /// **'Newest to oldest'**
  String get sortNewestToOldest;

  /// No description provided for @sortSmallestToLargest.
  ///
  /// In en, this message translates to:
  /// **'Smallest to largest'**
  String get sortSmallestToLargest;

  /// No description provided for @sortLargestToSmallest.
  ///
  /// In en, this message translates to:
  /// **'Largest to smallest'**
  String get sortLargestToSmallest;

  /// No description provided for @viewOptions.
  ///
  /// In en, this message translates to:
  /// **'Switch view options'**
  String get viewOptions;

  /// No description provided for @viewAs.
  ///
  /// In en, this message translates to:
  /// **'View as'**
  String get viewAs;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewList;

  /// No description provided for @viewIcons.
  ///
  /// In en, this message translates to:
  /// **'Icons'**
  String get viewIcons;

  /// No description provided for @tapToSetUp.
  ///
  /// In en, this message translates to:
  /// **'Tap to set up'**
  String get tapToSetUp;

  /// No description provided for @relativeOneHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get relativeOneHourAgo;

  /// No description provided for @relativeTwoHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get relativeTwoHoursAgo;

  /// No description provided for @relativeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get relativeYesterday;

  /// No description provided for @relativeThreeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get relativeThreeDaysAgo;

  /// No description provided for @relativeOneWeekAgo.
  ///
  /// In en, this message translates to:
  /// **'1 week ago'**
  String get relativeOneWeekAgo;

  /// No description provided for @folderMetadata.
  ///
  /// In en, this message translates to:
  /// **'{count} items · {modified}'**
  String folderMetadata(int count, String modified);

  /// No description provided for @fileMetadata.
  ///
  /// In en, this message translates to:
  /// **'{size} · {modified}'**
  String fileMetadata(String size, String modified);

  /// No description provided for @moreActionsForItem.
  ///
  /// In en, this message translates to:
  /// **'More actions for {itemName}'**
  String moreActionsForItem(String itemName);

  /// No description provided for @shareCommand.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCommand;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @makeAvailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Make available offline'**
  String get makeAvailableOffline;

  /// No description provided for @copyCommand.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyCommand;

  /// No description provided for @moveCommand.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get moveCommand;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @deleteCommand.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCommand;

  /// No description provided for @searchYourFiles.
  ///
  /// In en, this message translates to:
  /// **'Search your files'**
  String get searchYourFiles;

  /// No description provided for @createOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Create or upload'**
  String get createOrUpload;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get newFolder;

  /// No description provided for @uploadFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get uploadFiles;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @openNavigationDrawer.
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get openNavigationDrawer;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerHelpAndFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help and feedback'**
  String get drawerHelpAndFeedback;

  /// No description provided for @drawerSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get drawerSignOut;

  /// No description provided for @drawerPrivacyAndCookies.
  ///
  /// In en, this message translates to:
  /// **'Privacy and cookies'**
  String get drawerPrivacyAndCookies;

  /// No description provided for @signOutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutConfirmationTitle;

  /// No description provided for @signOutConfirmationBodyPersonal.
  ///
  /// In en, this message translates to:
  /// **'Do you want to sign out of your personal OneDrive account?'**
  String get signOutConfirmationBodyPersonal;

  /// Recycle bin screen title.
  ///
  /// In en, this message translates to:
  /// **'Recycle bin'**
  String get recycleBinTitle;

  /// Toolbar action that permanently deletes every recycle bin item.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get recycleDeleteAll;

  /// Recycle bin item action.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get recycleRestore;

  /// Recycle bin item permanent delete action.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recycleDelete;

  /// Recycle bin item details action and details screen title.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get recycleDetails;

  /// File type label on the recycle bin details screen.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get recycleDetailsType;

  /// File size label on the recycle bin details screen.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get recycleDetailsSize;

  /// Modified date label on the recycle bin details screen.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get recycleDetailsModified;

  /// Localized type value for a folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get recycleFolderType;

  /// No description provided for @recycleUnitBytes.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get recycleUnitBytes;

  /// No description provided for @recycleUnitKilobytes.
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get recycleUnitKilobytes;

  /// No description provided for @recycleUnitMegabytes.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get recycleUnitMegabytes;

  /// No description provided for @recycleUnitGigabytes.
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get recycleUnitGigabytes;

  /// Accessibility tooltip for the recycle bin item overflow button.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get recycleMoreActions;

  /// Toast shown after a recycle bin item is restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get recycleRestored;

  /// Confirmation title for deleting every recycle bin item.
  ///
  /// In en, this message translates to:
  /// **'Empty recycle bin?'**
  String get recycleEmptyConfirmationTitle;

  /// Confirmation body for deleting every recycle bin item.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all items?'**
  String get recycleEmptyConfirmationBody;

  /// Confirmation title for permanently deleting one recycle bin item.
  ///
  /// In en, this message translates to:
  /// **'Delete {itemName}?'**
  String recycleDeleteItemConfirmationTitle(String itemName);

  /// Confirmation body for permanently deleting one recycle bin item.
  ///
  /// In en, this message translates to:
  /// **'This item will be permanently deleted from OneDrive.'**
  String get recycleDeleteItemConfirmationBody;

  /// Generic cancellation action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
