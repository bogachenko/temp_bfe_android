enum DriveItemKind {
  folder,
  personalVault,
  pdf,
  excel,
  word,
  powerPoint,
  photo,
  text,
  video,
  generic,
}

enum DriveItemModifiedTime {
  oneHourAgo,
  twoHoursAgo,
  yesterday,
  threeDaysAgo,
  oneWeekAgo,
}

class DriveItem {
  const DriveItem({
    required this.id,
    required this.name,
    required this.kind,
    required this.modified,
    required this.modifiedSortValue,
    this.sizeBytes,
    this.itemCount,
    this.isShared = false,
  });

  final String id;
  final String name;
  final DriveItemKind kind;
  final DriveItemModifiedTime modified;
  final int modifiedSortValue;
  final int? sizeBytes;
  final int? itemCount;
  final bool isShared;

  bool get isFolder => kind == DriveItemKind.folder;
  bool get isPersonalVault => kind == DriveItemKind.personalVault;
  bool get isFile => !isFolder && !isPersonalVault;
}