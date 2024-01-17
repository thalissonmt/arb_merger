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

  factory ArbModel.fromArb(Map<String, dynamic> arb) {
    final bundleItems = Map.fromEntries(
      arb.entries.where(
        (entry) => !entry.key.startsWith('@@'),
      ),
    );

    final _arb = ArbModel(
      author: arb['@@author'],
      context: arb['@@context'],
      lastModified: arb['@@last_modified'] == null
          ? DateTime.now()
          : DateTime.parse(arb['@@last_modified']),
      locale: arb['@@locale'],
    );

    for (final item in bundleItems.entries) {
      if (item.key.startsWith('@')) continue;

      // final name = item.key;
      // final value = item.value;
      // final options = bundleItems['@$name'] ?? <String, dynamic>{};

      // _arb.items.add(
      //   ArbItem(
      //     name: name,
      //     value: value,
      //     description: options['description'],
      //     placeholders: options['placeholders'],
      //     type: options['type'],
      //   ),
      // );
    }

    return _arb;
  }

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
