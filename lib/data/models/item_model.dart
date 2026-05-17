class LostFoundItem {
  final String? id;
  final String title;
  final String description;
  final String location;
  final String contactInfo;
  final String type; // 'Lost' or 'Found'
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

  // JSONPlaceholder /posts: { id, title, body, userId }
  // We store extra fields (location, type, status) locally since
  // JSONPlaceholder ignores unknown fields on POST/PUT but echoes them back.
  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['body'] ?? json['description'] ?? '',
      location: json['location'] ?? 'Campus',
      contactInfo: json['userId']?.toString() ?? json['contactInfo'] ?? '',
      type: json['type'] ?? 'Lost',
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': description,
      'userId': 1,
      'location': location,
      'contactInfo': contactInfo,
      'type': type,
      'status': status,
    };
  }
}
