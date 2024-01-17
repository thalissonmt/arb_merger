// ignore_for_file: public_member_api_docs, sort_constructors_first
class ArbModel {
  final DateTime lastModified;
  final String locale;
  final String? context;
  final String? author;

  ArbModel({
    required this.lastModified,
    required this.locale,
    this.context,
    this.author,
  });

  factory ArbModel.empty() => ArbModel(
        lastModified: DateTime.now(),
        locale: "",
      );

  ArbModel copyWith({
    DateTime? lastModified,
    String? locale,
    String? context,
    String? author,
  }) {
    return ArbModel(
      lastModified: lastModified ?? this.lastModified,
      locale: locale ?? this.locale,
      context: context ?? this.context,
      author: author ?? this.author,
    );
  }
}
