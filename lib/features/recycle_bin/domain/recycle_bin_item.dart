enum RecycleBinItemKind {
  folder,
  genericFile,
  pdf,
  word,
  excel,
}

class RecycleBinItem {
  const RecycleBinItem({
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
    required this.kind,
    this.fileType = '',
  });

  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;
  final RecycleBinItemKind kind;
  final String fileType;
}
