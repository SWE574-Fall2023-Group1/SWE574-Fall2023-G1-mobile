class TagModel {
  final int? id;
  final String name;
  final String label;
  final String wikidataId;
  final String description;

  TagModel({
    required this.name,
    required this.label,
    required this.wikidataId,
    required this.description,
    this.id,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      label: json['label'] as String,
      wikidataId: json['wikidata_id'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'label': label,
      'wikidata_id': wikidataId,
      'description': description,
    };
  }
}
