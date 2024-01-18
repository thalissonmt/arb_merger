import 'dart:collection';

import 'package:arb_merger/src/models/arb_item_options.dart';

class ArbItem {
  final String name;
  final String value;
  final ArbItemOptions arbItemOptions;

  ArbItem({
    required this.name,
    required this.value,
    required this.arbItemOptions,
  });

  SplayTreeMap<String, dynamic> get arb {
    final SplayTreeMap<String, dynamic> items = SplayTreeMap();

    items[name] = value;
    if (arbItemOptions.arb != null) {
      items["@$name"] = arbItemOptions.arb;
    }
    return items;
  }
}
