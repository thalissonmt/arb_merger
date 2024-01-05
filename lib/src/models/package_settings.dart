class PackageSettings {
  final String inputFilePath;
  final String outputFilePath;
  final String? outputFileName;
  final List<String> supportedLocales;

  PackageSettings({
    required this.inputFilePath,
    required this.outputFilePath,
    required this.outputFileName,
    required this.supportedLocales,
  });
}
