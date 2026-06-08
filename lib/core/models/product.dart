class Product {
  final String id;
  final String name;
  final DateTime expiryDate;
  final int quantity;
  final String category;
  final String location;
  final String? barcode;
  final String? vendor;
  final String? batchNumber;
  final String? imageUrl;
  final DateTime addedAt;

  Product({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.quantity,
    required this.category,
    required this.location,
    this.barcode,
    this.vendor,
    this.batchNumber,
    this.imageUrl,
    required this.addedAt,
  });

  bool get isExpired {
    final now = DateTime.now();
    // Strip time for clean date comparison
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.isBefore(today);
  }

  bool get isExpiringSoon {
    if (isExpired) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final difference = expiry.difference(today).inDays;
    return difference >= 0 && difference <= 7;
  }

  bool get isSafe {
    return !isExpired && !isExpiringSoon;
  }

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  Product copyWith({
    String? id,
    String? name,
    DateTime? expiryDate,
    int? quantity,
    String? category,
    String? location,
    String? barcode,
    String? vendor,
    String? batchNumber,
    String? imageUrl,
    DateTime? addedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      location: location ?? this.location,
      barcode: barcode ?? this.barcode,
      vendor: vendor ?? this.vendor,
      batchNumber: batchNumber ?? this.batchNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
