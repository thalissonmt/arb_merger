import 'dart:convert';
import 'dart:io';

import 'package:arb_merger/arb_merger.dart';

import '../models/arb.dart';

class ArbMerger {
  Future<void> merge(PackageSettings packageSettings) async {
    final List<File> arbFiles = [];
    for (String locale in packageSettings.supportedLocales) {
      String pathInput = "${packageSettings.inputFilePath}/$locale";
      String pathOutput = "${packageSettings.outputFilePath}/$locale.arb";
      final inputDirectory = Directory(pathInput);
      if (packageSettings.outputFileName != null) {
        pathOutput =
            "${packageSettings.outputFilePath}/${packageSettings.outputFileName}_$locale.arb";
      }
      final mergedArbFile = File(pathOutput);
      createArbFileIfNotExits(pathOutput);
      if (inputDirectory.path.contains(".arb")) {
        arbFiles.add(File(inputDirectory.path));
        continue;
      }
      arbFiles.addAll((await inputDirectory.list().toList())
          .where((element) => element.path.contains(".arb"))
          .map((e) => File(e.path)));
      arbFiles.removeWhere((element) => element.uri == mergedArbFile.uri);
      Arb mergedBundle = Arb();
      for (final arbFile in arbFiles) {
        final bundle = Arb.fromFile(arbFile);
        mergedBundle = bundle.merge(mergedBundle);
      }
      var enconder = JsonEncoder.withIndent("  ").convert(mergedBundle.arb);
      await mergedArbFile.writeAsString(enconder);
    }
  }

  Future<void> createArbFileIfNotExits(String path) async {
    var file = File(path);
    if (await file.exists()) {
      return;
    }
    var directory = file.parent;
    if (!await directory.exists()) {
      await directory.create();
      // return;
    }
    await file.create(recursive: true);
  }
}
