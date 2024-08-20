class Survey {
  final int? id;
  final String name;
  final String photoPath;
  final double latitude;
  final double longitude;
  final bool isSynced;

  Survey({
    this.id,
    required this.name,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    this.isSynced = false,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      name: json['name'],
      photoPath: json['photoPath'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isSynced: json['isSynced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'latitude': latitude,
      'longitude': longitude,
      'isSynced': isSynced ? 1 : 0,
    };
  }
}