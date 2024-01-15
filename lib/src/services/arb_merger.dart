import 'dart:convert';
import 'dart:io';

import 'package:arb_merger/arb_merger.dart';
import 'package:arb_merger/src/models/arb.dart';

class ArbMerger {
  Future<void> merge(PackageSettings packageSettings) async {
    for (String locale in packageSettings.supportedLocales) {
      final List<File> arbFiles = [];
      String pathInput = "${packageSettings.inputFilePath}/$locale";
      String pathOutput = "${packageSettings.outputFilePath}/$locale.arb";
      final inputDirectory = Directory(pathInput);
      var inputFiles = await inputDirectory.list().toList();
      if (inputFiles.isEmpty) {
        print("a pasta $pathInput esta vazia");
        exit(0);
      }
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
      final allFolders = inputDirectory.listSync();

      for (var element in allFolders) {
        final tempDirectory = Directory(element.path);
        if (tempDirectory.path.contains(".arb")) {
          arbFiles.add(File(tempDirectory.path));
          continue;
        }
        arbFiles.addAll((await tempDirectory.list().toList())
            .where((element) => element.path.contains(".arb"))
            .map((e) => File(e.path)));
      }

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
