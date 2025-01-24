class ScaleConfig {
  String name;
  List<String> values;
  bool isActive;
  final bool isCustom;

  ScaleConfig({
    required this.name,
    required this.values,
    required this.isActive,
    required this.isCustom,
  });
}
