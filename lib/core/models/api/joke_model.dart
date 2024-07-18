import 'package:freezed_annotation/freezed_annotation.dart';

part 'joke_model.freezed.dart';
part 'joke_model.g.dart';

@unfreezed
class JokeModel with _$JokeModel {
  factory JokeModel({
    required bool safe,
    required final String type,
    required final bool? error,
    required final String? joke,
    required final String? setup,
    required final String? delivery,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) =>
      _$JokeModelFromJson(json);
}
