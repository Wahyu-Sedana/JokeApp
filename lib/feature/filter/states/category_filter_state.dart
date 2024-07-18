import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/fliter/category_model.dart';

class CategoriesNotifier extends StateNotifier<CategoryModel> {
  CategoriesNotifier()
      : super(
          CategoryModel(
              isAny: true,
              isPrograming: false,
              isMiscellaneous: false,
              isDark: false,
              isPun: false,
              isSpooky: false,
              isChristmas: false,
              url: "any"),
        );

  void setPrograming(bool value) {
    state = state.copyWith(
      isPrograming: value,
      isAny: false,
    );
  }

  void setChristmas(bool value) {
    state = state.copyWith(
      isChristmas: value,
      isAny: false,
    );
  }

  void setDark(bool value) {
    state = state.copyWith(
      isDark: value,
      isAny: false,
      url: "dark,",
    );
  }

  void setMiscellaneous(bool value) {
    state = state.copyWith(
      isMiscellaneous: value,
      isAny: false,
    );
  }

  void setPun(bool value) {
    state = state.copyWith(
      isPun: value,
      isAny: false,
    );
  }

  void setSpooky(bool value) {
    state = state.copyWith(
      isSpooky: value,
      isAny: false,
    );
  }

  void setAny(bool value) {
    state = state.copyWith(
      isAny: value,
      isChristmas: false,
      isDark: false,
      isMiscellaneous: false,
      isPrograming: false,
      isPun: false,
      isSpooky: false,
    );
  }
}

final categoryProvider =
    StateNotifierProvider<CategoriesNotifier, CategoryModel>((ref) {
  return CategoriesNotifier();
});
