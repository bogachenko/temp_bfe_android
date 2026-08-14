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
    required this.metadata,
    required this.kind,
  });

  final String name;
  final String metadata;
  final RecycleBinItemKind kind;
}
