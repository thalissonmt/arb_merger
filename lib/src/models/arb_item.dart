// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ArbItem {
  final String name;
  final String value;

  ArbItem({
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{name: value};
  }

  factory ArbItem.fromMap(Map<String, dynamic> map) {
    return ArbItem(
      name: map['name'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArbItem.fromJson(String source) =>
      ArbItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
