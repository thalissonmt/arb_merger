import 'dart:convert';

class ArbItemOptions {
  final String? type;
  final String? description;
  final Map<String, dynamic>? placeholders;

  ArbItemOptions({
    this.type,
    this.description,
    required this.placeholders,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'description': description,
      'placeholders': placeholders,
    };
  }

  factory ArbItemOptions.fromMap(Map<String, dynamic> map) {
    return ArbItemOptions(
      type: map['type'] != null ? map['type'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      placeholders: map['placeholders'] != null
          ? Map<String, dynamic>.from(
              (map['placeholders'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArbItemOptions.fromJson(String source) {
    return ArbItemOptions(placeholders: {});
  }
}
