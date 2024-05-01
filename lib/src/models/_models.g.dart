// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreativeInfo _$CreativeInfoFromJson(Map<String, dynamic> json) => CreativeInfo()
  ..creative = Creative.fromJson(json['creative'] as Map<String, dynamic>)
  ..clickUrl = json['clickUrl'] as String
  ..pixels = (json['pixels'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$CreativeInfoToJson(CreativeInfo instance) =>
    <String, dynamic>{
      'creative': instance.creative.toJson(),
      'clickUrl': instance.clickUrl,
      'pixels': instance.pixels,
    };

Creative _$CreativeFromJson(Map<String, dynamic> json) => Creative()
  ..id = (json['id'] as num).toInt()
  ..title = json['title'] as String
  ..subtitle = json['subtitle'] as String;

Map<String, dynamic> _$CreativeToJson(Creative instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
    };
