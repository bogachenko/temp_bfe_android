import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/recycle_bin_item.dart';

abstract final class RecycleBinItemFormatter {
  static String metadata(BuildContext context, RecycleBinItem item) {
    return '${size(context, item)} · ${shortModified(context, item)}';
  }

  static String size(BuildContext context, RecycleBinItem item) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final bytes = item.sizeBytes;

    if (bytes >= 1024 * 1024 * 1024) {
      return '${_number(bytes / (1024 * 1024 * 1024), locale)} ${l10n.recycleUnitGigabytes}';
    }
    if (bytes >= 1024 * 1024) {
      return '${_number(bytes / (1024 * 1024), locale)} ${l10n.recycleUnitMegabytes}';
    }
    if (bytes >= 1024) {
      return '${_number(bytes / 1024, locale)} ${l10n.recycleUnitKilobytes}';
    }
    return '$bytes ${l10n.recycleUnitBytes}';
  }

  static String shortModified(BuildContext context, RecycleBinItem item) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.MMMd(locale).format(item.modifiedAt);
  }

  static String fullModified(BuildContext context, RecycleBinItem item) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'ru') {
      return DateFormat('dd.MM.yyyy HH:mm', 'ru').format(item.modifiedAt);
    }
    return DateFormat('MM/dd/yyyy h:mm a', 'en').format(item.modifiedAt);
  }

  static String type(BuildContext context, RecycleBinItem item) {
    if (item.kind == RecycleBinItemKind.folder) {
      return AppLocalizations.of(context).recycleFolderType;
    }
    return item.fileType;
  }

  static String _number(double value, String locale) {
    final pattern = value == value.roundToDouble() ? '0' : '0.#';
    return NumberFormat(pattern, locale).format(value);
  }
}
