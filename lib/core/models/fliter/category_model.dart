import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';

@unfreezed
class CategoryModel with _$CategoryModel {
  factory CategoryModel({
    required bool isAny,
    required bool isPrograming,
    required bool isMiscellaneous,
    required bool isDark,
    required bool isPun,
    required bool isSpooky,
    required bool isChristmas,
    String? url,
  }) = _CategoryModel;
}
