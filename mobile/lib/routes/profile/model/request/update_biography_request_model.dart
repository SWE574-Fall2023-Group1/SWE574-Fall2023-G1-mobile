class UpdateBiographyRequestModel {
  final String biography;

  UpdateBiographyRequestModel({
    required this.biography,
  });

  factory UpdateBiographyRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateBiographyRequestModel(
      biography: json['biography'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'biography': biography,
    };
  }
}
