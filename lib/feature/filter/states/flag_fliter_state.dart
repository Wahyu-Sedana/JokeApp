import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/fliter/flag_model.dart';

class FlagNotifier extends StateNotifier<FlagModel> {
  FlagNotifier()
      : super(
          FlagModel(
            isNsfw: false,
            isReligious: false,
            isPolitical: false,
            isRacist: false,
            isSexist: false,
            isExplicit: false,
          ),
        );

  void setNsfw(bool value) => state = state.copyWith(
        isNsfw: value,
        url: flagUrl,
      );
  void setExplicit(bool value) => state = state.copyWith(
        isExplicit: value,
        url: flagUrl,
      );
  void setPolitical(bool value) => state = state.copyWith(
        isPolitical: value,
        url: flagUrl,
      );
  void setRacist(bool value) => state = state.copyWith(
        isRacist: value,
        url: flagUrl,
      );
  void setReligious(bool value) => state = state.copyWith(
        isReligious: value,
        url: flagUrl,
      );
  void setSexist(bool value) => state = state.copyWith(
        isSexist: value,
        url: flagUrl,
      );

  String get flagUrl {
    if (isAllFlagNotChecked()) "";
    return "?blacklistFlags=${state.isNsfw ? "nsfw," : ""}${state.isExplicit ? "explicit," : ""}${state.isReligious ? "religious," : ""}${state.isPolitical ? "political," : ""}${state.isRacist ? "racist," : ""}${state.isSexist ? "sexist," : ""}${state.isExplicit ? "explicit," : ""}";
  }

  bool isAllFlagNotChecked() {
    return (!state.isNsfw &&
        !state.isExplicit &&
        !state.isNsfw &&
        !state.isRacist &&
        !state.isReligious &&
        !state.isSexist);
  }
}

final flagProvider = StateNotifierProvider<FlagNotifier, FlagModel>((ref) {
  return FlagNotifier();
});
