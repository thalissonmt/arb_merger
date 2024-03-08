import 'package:arb_merger/src/services/arb_merger.dart';
import 'package:arb_merger/src/services/yaml_settings_reader.dart';
import 'dart:io';

void main() async {
  final packageSettings = await YamlSettingsReader().readYaml();
  final ArbMerger arbMerger = ArbMerger();
  await arbMerger.merge(packageSettings);

  print("Iniciando o comando para atualizar.");
  await Process.run('flutter', ['gen-l10n'], runInShell: true);
  await Process.run('flutter', ['pub', 'get'], runInShell: true);
  print("L10n atualizado.");
}
