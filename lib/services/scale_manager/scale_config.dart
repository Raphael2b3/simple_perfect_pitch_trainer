class ScaleConfig {
  final String name;
  final List<String> values;
  final bool active;

  ScaleConfig(this.name, this.values, this.active);

  factory ScaleConfig.fromJson(Map<String, dynamic> json) {
    return ScaleConfig(
      json['name'] as String,
      List<String>.from(json['values'] as List<dynamic>),
      json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'values': values, 'active': active};
  }
}