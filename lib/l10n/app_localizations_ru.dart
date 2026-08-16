// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Drive';

  @override
  String get signInTitle =>
      'Защищайте свои файлы и получайте доступ к ним в любом месте';

  @override
  String get signInPrimaryAction => 'Войти';

  @override
  String get signInTertiaryAction => 'Перейти к моим фотографиям';

  @override
  String get photos => 'Фотографии';

  @override
  String get files => 'Файлы';

  @override
  String get premium => 'Премиум';

  @override
  String get home => 'Главная';

  @override
  String get myFiles => 'Мои файлы';

  @override
  String get shared => 'Общие';

  @override
  String get personalVault => 'Личный сейф';

  @override
  String get sort => 'Сортировать';

  @override
  String get sortName => 'Имя';

  @override
  String get sortModified => 'Изменено';

  @override
  String get sortFileSize => 'Размер файла';

  @override
  String get sortAtoZ => 'А—Я';

  @override
  String get sortZtoA => 'Я—А';

  @override
  String get sortOldestToNewest => 'От старых к новым';

  @override
  String get sortNewestToOldest => 'От новых к старым';

  @override
  String get sortSmallestToLargest => 'По возрастанию';

  @override
  String get sortLargestToSmallest => 'По убыванию';

  @override
  String get viewOptions => 'Переключить параметры представления';

  @override
  String get viewAs => 'Посмотреть как';

  @override
  String get viewList => 'Список';

  @override
  String get viewIcons => 'Иконки';

  @override
  String get tapToSetUp => 'Коснитесь, чтобы настроить';

  @override
  String get relativeOneHourAgo => '1 час назад';

  @override
  String get relativeTwoHoursAgo => '2 часа назад';

  @override
  String get relativeYesterday => 'Вчера';

  @override
  String get relativeThreeDaysAgo => '3 дня назад';

  @override
  String get relativeOneWeekAgo => '1 неделю назад';

  @override
  String folderMetadata(int count, String modified) {
    return '$count элем. · $modified';
  }

  @override
  String fileMetadata(String size, String modified) {
    return '$size · $modified';
  }

  @override
  String moreActionsForItem(String itemName) {
    return 'Дополнительные действия для $itemName';
  }

  @override
  String get shareCommand => 'Поделиться';

  @override
  String get copyLink => 'Копировать ссылку';

  @override
  String get download => 'Скачать';

  @override
  String get makeAvailableOffline => 'Сделать доступным автономно';

  @override
  String get copyCommand => 'Копировать';

  @override
  String get moveCommand => 'Переместить';

  @override
  String get comments => 'Комментарии';

  @override
  String get details => 'Сведения';

  @override
  String get moveTo => 'Переместить в';

  @override
  String get rename => 'Переименовать';

  @override
  String get deleteCommand => 'Удалить';

  @override
  String get searchYourFiles => 'Поиск ваших файлов';

  @override
  String get createOrUpload => 'Создание или отправка';

  @override
  String get newFolder => 'Новая папка';

  @override
  String get uploadFiles => 'Загрузить файлы';

  @override
  String get scan => 'Сканировать';

  @override
  String get openNavigationDrawer => 'Открыть меню навигации';

  @override
  String get drawerSettings => 'Параметры';

  @override
  String get drawerHelpAndFeedback => 'Справка и отзывы';

  @override
  String get drawerSignOut => 'Выйти';

  @override
  String get drawerPrivacyAndCookies => 'Конфиденциальность и файлы cookie';

  @override
  String get signOutConfirmationTitle => 'Выйти';

  @override
  String get signOutConfirmationBodyPersonal =>
      'Вы хотите выйти из своей личной учетной записи OneDrive?';

  @override
  String get recycleBinTitle => 'Корзина';

  @override
  String get recycleDeleteAll => 'Удалить все';

  @override
  String get recycleRestore => 'Восстановить';

  @override
  String get recycleDelete => 'Удалить';

  @override
  String get recycleDetails => 'Сведения';

  @override
  String get recycleDetailsType => 'Тип';

  @override
  String get recycleDetailsSize => 'Размер';

  @override
  String get recycleDetailsModified => 'Изменено';

  @override
  String get recycleFolderType => 'Папка';

  @override
  String get recycleUnitBytes => 'Б';

  @override
  String get recycleUnitKilobytes => 'КБ';

  @override
  String get recycleUnitMegabytes => 'МБ';

  @override
  String get recycleUnitGigabytes => 'ГБ';

  @override
  String get recycleMoreActions => 'Другие действия';

  @override
  String get recycleRestored => 'Восстановлено';

  @override
  String get recycleEmptyConfirmationTitle => 'Очистить корзину?';

  @override
  String get recycleEmptyConfirmationBody => 'Удалить все элементы навсегда?';

  @override
  String recycleDeleteItemConfirmationTitle(String itemName) {
    return 'Удалить $itemName?';
  }

  @override
  String get recycleDeleteItemConfirmationBody =>
      'Этот элемент будет навсегда удален из OneDrive.';

  @override
  String get cancel => 'Отмена';
}
