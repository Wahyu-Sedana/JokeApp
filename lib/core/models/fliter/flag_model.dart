import 'package:freezed_annotation/freezed_annotation.dart';

part 'flag_model.freezed.dart';

@unfreezed
class FlagModel with _$FlagModel {
  factory FlagModel({
    required bool isNsfw,
    required bool isReligious,
    required bool isPolitical,
    required bool isRacist,
    required bool isSexist,
    required bool isExplicit,
    String? url,
  }) = _FlagModel;
}
