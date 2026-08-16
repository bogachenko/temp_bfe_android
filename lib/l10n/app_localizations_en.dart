// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Drive';

  @override
  String get signInTitle => 'Protect your files and access them anywhere';

  @override
  String get signInPrimaryAction => 'Sign in';

  @override
  String get signInTertiaryAction => 'Skip to my photos';

  @override
  String get photos => 'Photos';

  @override
  String get files => 'Files';

  @override
  String get premium => 'Premium';

  @override
  String get home => 'Home';

  @override
  String get myFiles => 'My files';

  @override
  String get shared => 'Shared';

  @override
  String get personalVault => 'Personal Vault';

  @override
  String get sort => 'Sort';

  @override
  String get sortName => 'Name';

  @override
  String get sortModified => 'Modified';

  @override
  String get sortFileSize => 'File size';

  @override
  String get sortAtoZ => 'A to Z';

  @override
  String get sortZtoA => 'Z to A';

  @override
  String get sortOldestToNewest => 'Oldest to newest';

  @override
  String get sortNewestToOldest => 'Newest to oldest';

  @override
  String get sortSmallestToLargest => 'Smallest to largest';

  @override
  String get sortLargestToSmallest => 'Largest to smallest';

  @override
  String get viewOptions => 'Switch view options';

  @override
  String get viewAs => 'View as';

  @override
  String get viewList => 'List';

  @override
  String get viewIcons => 'Icons';

  @override
  String get tapToSetUp => 'Tap to set up';

  @override
  String get relativeOneHourAgo => '1 hour ago';

  @override
  String get relativeTwoHoursAgo => '2 hours ago';

  @override
  String get relativeYesterday => 'Yesterday';

  @override
  String get relativeThreeDaysAgo => '3 days ago';

  @override
  String get relativeOneWeekAgo => '1 week ago';

  @override
  String folderMetadata(int count, String modified) {
    return '$count items · $modified';
  }

  @override
  String fileMetadata(String size, String modified) {
    return '$size · $modified';
  }

  @override
  String moreActionsForItem(String itemName) {
    return 'More actions for $itemName';
  }

  @override
  String get shareCommand => 'Share';

  @override
  String get copyLink => 'Copy link';

  @override
  String get download => 'Download';

  @override
  String get makeAvailableOffline => 'Make available offline';

  @override
  String get copyCommand => 'Copy';

  @override
  String get moveCommand => 'Move';

  @override
  String get comments => 'Comments';

  @override
  String get details => 'Details';

  @override
  String get moveTo => 'Move to';

  @override
  String get rename => 'Rename';

  @override
  String get deleteCommand => 'Delete';

  @override
  String get searchYourFiles => 'Search your files';

  @override
  String get createOrUpload => 'Create or upload';

  @override
  String get newFolder => 'New folder';

  @override
  String get uploadFiles => 'Upload files';

  @override
  String get scan => 'Scan';

  @override
  String get openNavigationDrawer => 'Open navigation menu';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerHelpAndFeedback => 'Help and feedback';

  @override
  String get drawerSignOut => 'Sign out';

  @override
  String get drawerPrivacyAndCookies => 'Privacy and cookies';

  @override
  String get signOutConfirmationTitle => 'Sign out';

  @override
  String get signOutConfirmationBodyPersonal =>
      'Do you want to sign out of your personal OneDrive account?';

  @override
  String get recycleBinTitle => 'Recycle bin';

  @override
  String get recycleDeleteAll => 'Delete all';

  @override
  String get recycleRestore => 'Restore';

  @override
  String get recycleDelete => 'Delete';

  @override
  String get recycleDetails => 'Details';

  @override
  String get recycleDetailsType => 'Type';

  @override
  String get recycleDetailsSize => 'Size';

  @override
  String get recycleDetailsModified => 'Modified';

  @override
  String get recycleFolderType => 'Folder';

  @override
  String get recycleUnitBytes => 'B';

  @override
  String get recycleUnitKilobytes => 'KB';

  @override
  String get recycleUnitMegabytes => 'MB';

  @override
  String get recycleUnitGigabytes => 'GB';

  @override
  String get recycleMoreActions => 'More actions';

  @override
  String get recycleRestored => 'Restored';

  @override
  String get recycleEmptyConfirmationTitle => 'Empty recycle bin?';

  @override
  String get recycleEmptyConfirmationBody => 'Permanently delete all items?';

  @override
  String recycleDeleteItemConfirmationTitle(String itemName) {
    return 'Delete $itemName?';
  }

  @override
  String get recycleDeleteItemConfirmationBody =>
      'This item will be permanently deleted from OneDrive.';

  @override
  String get cancel => 'Cancel';
}
