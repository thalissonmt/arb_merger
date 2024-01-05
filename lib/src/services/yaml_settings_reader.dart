import 'dart:io';

import 'package:arb_merger/arb_merger.dart';
import 'package:yaml/yaml.dart';

import '../models/yaml_arguments.dart';

class YamlSettingsReader {
  Future<PackageSettings> readYaml() async {
    final file = File(YamlArguments.yamlFileName);
    final yamlString = file.readAsStringSync();
    final Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);
    final yamlSection = yamlMap[YamlArguments.yamlSection];
    if (yamlSection == null) {
      printErrorAndExit("${YamlArguments.yamlSection} não encontrado");
    }
    var config = yamlSection[YamlArguments.inputFilePath];
    if (config == null) {
      printErrorAndExit(
          "Configuração: ${YamlArguments.inputFilePath} não encontrada");
    }
    final inputFilePath = config.toString();
    config = yamlSection[YamlArguments.supportedLocales];
    if (config == null) {
      printErrorAndExit(
          "Configuração: ${YamlArguments.supportedLocales} não encontrada");
    }
    final supportedLocales = config.toList().cast<String>();
    config = yamlSection[YamlArguments.outputFilePath];
    if (config == null || config.toString().isEmpty) {
      printErrorAndExit(
          "Configuração: ${YamlArguments.outputFilePath} não encontrada");
    }
    final outputFilePath = config;
    config = yamlSection[YamlArguments.outputFileName];
    if (config != null && config.toString().isEmpty) {
      printErrorAndExit(
          "Configuração: ${YamlArguments.outputFileName} não encontrada");
    }
    final outputFileName = config;

    return PackageSettings(
      inputFilePath: inputFilePath,
      outputFilePath: outputFilePath,
      outputFileName: outputFileName,
      supportedLocales: supportedLocales,
    );
  }

  void printErrorAndExit(String message) {
    print(message);
    exit(0);
  }
}
