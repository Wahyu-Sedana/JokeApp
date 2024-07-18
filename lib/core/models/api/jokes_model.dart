import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nge_joke_app/core/models/api/joke_model.dart';

part 'jokes_model.freezed.dart';
part 'jokes_model.g.dart';

@freezed
class JokesModel with _$JokesModel {
  factory JokesModel(
      {required bool? error,
      required int amount,
      required List<JokeModel> jokes}) = _JokesModel;

  factory JokesModel.fromJson(Map<String, dynamic> json) =>
      _$JokesModelFromJson(json);
}
