import 'dart:convert';
import 'dart:io';

import 'package:arb_merger/src/models/arb_item.dart';
import 'package:arb_merger/src/models/arb_item_options.dart';
import 'package:intl/intl.dart';

import '../utils/util_test.dart';

class ArbTest {
  final DateTime lastModified;
  final String locale;
  final String? context;
  final String? author;
  final Set<ArbItem> arbItems;

  factory ArbTest.empty() => ArbTest(
        lastModified: DateTime.now(),
        locale: "",
        arbItems: {},
      );

  factory ArbTest.fromFile(File file) {
    final jsonString = file.readAsStringSync();
    print(jsonString);
    final decode = json.decode(jsonString);
    final entries = getEntries(decode);

    final arb = ArbTest(
      lastModified: decode["@@last_modified"] ?? DateTime.now(),
      locale: decode["@@locale"],
      author: decode['@@author'],
      context: decode['@@context'],
      arbItems: {},
    );
    Set<ArbItem> tempList = {};
    for (var element in entries.entries) {
      final bla = element.key.startsWith("@");
      if (bla) {
        Map<String, dynamic> options = element.value;
        ArbItemOptions(
          placeholders: options,
        );
        final arbItem = ArbItem(
          name: element.key,
          value: options.toString(),
        );
        tempList.add(arbItem);
      } else {
        final arbItem = ArbItem(
          name: element.key,
          value: element.value,
        );
        tempList.add(arbItem);
      }
    }

    return arb.copyWith(
      arbItems: tempList,
    );
  }

  ArbTest({
    required this.lastModified,
    required this.locale,
    this.context,
    this.author,
    required this.arbItems,
  });

  static Map<String, dynamic> getEntries(Map<String, dynamic> arb) =>
      Map.fromEntries(
        arb.entries.where(
          (entry) => !entry.key.startsWith('@@'),
        ),
      );

  ArbTest copyWith({
    DateTime? lastModified,
    String? locale,
    String? context,
    String? author,
    Set<ArbItem>? arbItems,
  }) {
    return ArbTest(
      lastModified: lastModified ?? this.lastModified,
      locale: locale ?? this.locale,
      context: context ?? this.context,
      author: author ?? this.author,
      arbItems: arbItems ?? this.arbItems,
    );
  }

  Map<String, dynamic> toMap() {
    var arb = <String, dynamic>{
      '@@lastModified': DateFormat("dd/MM/yyyy").format(lastModified),
      '@@locale': locale,
    };

    if (author != null) {
      arb["@@author"] = author;
    }
    if (context != null) {
      arb["@@context"] = context;
    }
    for (var element in arbItems) {
      if (element.value.startsWith("{")) {
        arb[element.name] = getJsonFromString(element.value);
      } else {
        arb[element.name] = element.value;
      }
    }
    return arb;
  }

  factory ArbTest.fromMap(Map<String, dynamic> map) {
    return ArbTest(
      lastModified:
          DateTime.fromMillisecondsSinceEpoch(map['lastModified'] as int),
      locale: map['locale'] as String,
      context: map['context'] != null ? map['context'] as String : null,
      author: map['author'] != null ? map['author'] as String : null,
      arbItems: Set<ArbItem>.from(
        (map['arbItems'] as List<int>).map<ArbItem>(
          (x) => ArbItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  ArbTest merge(ArbTest other) {
    final keys = arbItems.map((item) => item.name).toSet();
    final otherKeys = other.arbItems.map((item) => item.name).toSet();
    final newKeys = otherKeys.difference(keys);
    final newItems =
        other.arbItems.where((item) => newKeys.contains(item.name)).toSet();

    return ArbTest(
      lastModified: DateTime.now(),
      author: author,
      context: context,
      locale: locale,
      arbItems: arbItems.union(newItems),
    );
  }
}
