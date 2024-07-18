import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/fliter/category_model.dart';
import '../../../core/models/fliter/flag_model.dart';
import '../../../core/models/api/jokes_model.dart';
import '../../../core/repositories/joke_repository.dart';
import 'flag_fliter_state.dart';

import 'category_filter_state.dart';

final jokeRepoProvider = Provider<JokeRepository>((ref) {
  return JokeRepository();
});
final jokeProvider = FutureProvider<JokesModel>((ref) async {
  CategoryModel category = ref.watch(categoryProvider);
  FlagModel flag = ref.watch(flagProvider);

  String rawCategoryUrl =
      """${category.isChristmas ? "christmas," : ""}${category.isDark ? "dark," : ""}${category.isMiscellaneous ? "miscellaneous," : ""}${category.isPrograming ? "programming," : ""}${category.isPun ? "pun," : ""}${category.isSpooky ? "spooky," : ""}""";

  String rawFlagUrl =
      "${flag.isNsfw ? "nsfw," : ""}${flag.isExplicit ? "explicit," : ""}${flag.isReligious ? "religious," : ""}${flag.isPolitical ? "political," : ""}${flag.isRacist ? "racist," : ""}${flag.isSexist ? "sexist," : ""}${flag.isExplicit ? "explicit," : ""}";

  String url = rawCategoryUrl.isEmpty
      ? "any"
      : rawCategoryUrl.substring(0, rawCategoryUrl.length - 1);

  String flagUrl = rawFlagUrl.isEmpty
      ? ""
      : "blacklistFlags=${rawFlagUrl.substring(0, rawFlagUrl.length - 1)}";

  // String divider = flagUrl.isEmpty ? "?" : ",";

  log("category : $url");
  log("flag $flag");

  return ref.watch(jokeRepoProvider).getJokes("$url?$flagUrl");
});
