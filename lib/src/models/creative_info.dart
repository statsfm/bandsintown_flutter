part of bandsintown_flutter.models;

@JsonSerializable(explicitToJson: true)
class CreativeInfo extends Object {
  CreativeInfo();

  factory CreativeInfo.fromJson(Map<String, dynamic> json) =>
      _$CreativeInfoFromJson(json);
  
  @JsonKey(name: 'creative')
  late Creative creative;

  @JsonKey(name: 'clickUrl')
  late String clickUrl;

  @JsonKey(name: 'pixels')
  late List<String> pixels;
}

@JsonSerializable(createToJson: true)
class Creative extends Object {
  Creative();

  Map<String, dynamic> toJson() => _$CreativeToJson(this);

  factory Creative.fromJson(Map<String, dynamic> json) =>
      _$CreativeFromJson(json);

  @JsonKey(name: 'id')
  late int id;

  @JsonKey(name: 'title')
  late String title;

  @JsonKey(name: 'subtitle')
  late String subtitle;
}