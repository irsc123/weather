class Location {
  final int id;
  final String name;
  final String? admin1;
  final String? admin2;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.name,
    this.admin1,
    this.admin2,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      admin1: json['admin1'] as String?,
      admin2: json['admin2'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String? get region {
    if (admin1 != null && admin1!.isNotEmpty) return admin1;
    if (admin2 != null && admin2!.isNotEmpty) return admin2;
    return null;
  }

  String get subtitle {
    final parts = <String>[];
    final r = region;
    if (r != null) parts.add(r);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join('، ');
  }

  String get flag {
    if (countryCode == null || countryCode!.length != 2) return '';
    final code = countryCode!.toUpperCase();
    final first = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final second = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }
}