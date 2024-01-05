import 'package:arb_merger/src/services/arb_merger.dart';
import 'package:arb_merger/src/services/yaml_settings_reader.dart';

void main() async {
  final packageSettings = await YamlSettingsReader().readYaml();
  final ArbMerger arbMerger = ArbMerger();
  await arbMerger.merge(packageSettings);
}
