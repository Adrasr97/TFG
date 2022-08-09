// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormModel _$FormModelFromJson(Map json) => FormModel(
      uid: json['uid'] as String?,
      nameUser: json['nameUser'] as String?,
      uidUser: json['uidUser'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$FormModelToJson(FormModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'nameUser': instance.nameUser,
      'uidUser': instance.uidUser,
      'name': instance.name,
      'description': instance.description,
    };
