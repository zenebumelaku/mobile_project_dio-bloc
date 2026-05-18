class LostFoundItem {
  final String? id;
  final String title;
  final String description;
  final String location;
  final String contactInfo;
  final String type;   // 'Lost' or 'Found'
  final String status; // 'Active' or 'Claimed'

  LostFoundItem({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contactInfo,
    required this.type,
    required this.status,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      contactInfo: json['contactInfo']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Lost',
      status: json['status']?.toString() ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
        'contactInfo': contactInfo,
        'type': type,
        'status': status,
      };
}
