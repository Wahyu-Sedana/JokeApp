// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_JokeModel _$$_JokeModelFromJson(Map<String, dynamic> json) => _$_JokeModel(
      safe: json['safe'] as bool,
      type: json['type'] as String,
      error: json['error'] as bool?,
      joke: json['joke'] as String?,
      setup: json['setup'] as String?,
      delivery: json['delivery'] as String?,
    );

Map<String, dynamic> _$$_JokeModelToJson(_$_JokeModel instance) =>
    <String, dynamic>{
      'safe': instance.safe,
      'type': instance.type,
      'error': instance.error,
      'joke': instance.joke,
      'setup': instance.setup,
      'delivery': instance.delivery,
    };
