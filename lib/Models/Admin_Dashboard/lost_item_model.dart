class LostItemData {
  final int id;
  final String userId;
  final String submitterName;
  final String name;
  final String description;
  final String dateFound;
  final String timeFound;
  final String locationFound;
  final String itemType;
  final String status;


  LostItemData({
    required this.id,
    required this.userId,
    required this.submitterName,
    required this.name,
    required this.description,
    required this.dateFound,
    required this.timeFound,
    required this.locationFound,
    required this.itemType,
    required this.status,
  });
}