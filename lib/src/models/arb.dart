import 'dart:collection';

import 'package:arb_merger/src/models/arb_item.dart';
import 'package:arb_merger/src/models/arb_item_options.dart';
import 'package:intl/intl.dart';

class ArbFile {
  final DateTime lastModified;
  final String locale;
  final String? context;
  final String? author;
  final Set<ArbItem> items;

  ArbFile({
    required this.lastModified,
    required this.locale,
    this.context,
    this.author,
    required this.items,
  });

  factory ArbFile.empty() => ArbFile(
        lastModified: DateTime.now(),
        locale: "",
        items: {},
      );

  factory ArbFile.fromArb(Map<String, dynamic> arb) {
    final bundleItems = Map.fromEntries(
      arb.entries.where(
        (entry) => !entry.key.startsWith('@@'),
      ),
    );

    final _arb = ArbFile(
      author: arb['@@author'],
      context: arb['@@context'],
      lastModified: arb['@@last_modified'] == null
          ? DateTime.now()
          : DateTime.parse(arb['@@last_modified']),
      locale: arb['@@locale'],
      items: {},
    );

    for (final item in bundleItems.entries) {
      if (item.key.startsWith('@')) continue;

      final name = item.key;
      final value = item.value;
      final options = bundleItems["@$name"] ?? <String, dynamic>{};
      _arb.items.add(
        ArbItem(
          name: name,
          value: value,
          arbItemOptions: ArbItemOptions(
            description: options["description"],
            placeholders: options['placeholders'],
            type: options['type'],
          ),
        ),
      );
    }

    return _arb;
  }

  ArbFile copyWith({
    DateTime? lastModified,
    String? locale,
    String? context,
    String? author,
    Set<ArbItem>? items,
  }) {
    return ArbFile(
      lastModified: lastModified ?? this.lastModified,
      locale: locale ?? this.locale,
      context: context ?? this.context,
      author: author ?? this.author,
      items: items ?? this.items,
    );
  }

  SplayTreeMap<String, dynamic> get arb {
    final SplayTreeMap<String, dynamic> arbTemp = SplayTreeMap();

    arbTemp["@@locale"] = locale;
    arbTemp["@@last_modified"] =
        DateFormat("dd/MM/yyyy - hh:mm:ss").format(lastModified);
    if (context != null) {
      arbTemp["@@context"] = context;
    }
    if (author != null) {
      arbTemp["@@author"] = author;
    }
    for (var element in items) {
      arbTemp.addAll(element.arb);
    }

    return arbTemp;
  }
}
