import 'dart:collection';

class ArbItemOptions {
  final String? type;
  final String? description;
  final Map<String, dynamic>? placeholders;
  ArbItemOptions({
    this.type,
    this.description,
    this.placeholders,
  });

  SplayTreeMap<String, dynamic>? get arb {
    final SplayTreeMap<String, dynamic> options = SplayTreeMap();
    if (type != null) {
      options['type'] = type;
    }

    if (description != null) {
      options['desc'] = description;
    }

    if (placeholders != null) {
      options['placeholders'] = placeholders;
    }

    return options.isNotEmpty ? options : null;
  }
}
