class ReportItemData {
  final int id;
  final String userId;
  final String submitterName;
  final String name;
  final String description;
  final String dateLost;
  final String timeLost;
  final String locationLost;
  final String itemType;
  final String status;


  ReportItemData({
    required this.id,
    required this.userId,
    required this.submitterName,
    required this.name,
    required this.description,
    required this.dateLost,
    required this.timeLost,
    required this.locationLost,
    required this.itemType,
    required this.status,
  });
}