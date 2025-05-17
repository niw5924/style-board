class ClosetItem {
  final String path;
  final String category;
  final Map<String, String> tags;
  final bool isLiked;

  ClosetItem({
    required this.path,
    required this.category,
    required this.tags,
    required this.isLiked,
  });
}
