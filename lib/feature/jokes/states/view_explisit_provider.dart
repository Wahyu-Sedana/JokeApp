import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/core/models/api/joke_model.dart';
import 'package:nge_joke_app/core/repositories/joke_repository.dart';

class JokesNotifier extends AsyncNotifier<List<JokeModel>> {
  JokesNotifier({required this.filter});

  String filter;

  Future<List<JokeModel>> _fetchJokes(String filter) async {
    final jokes = JokeRepository();
    final result = await jokes.getJokes(filter);
    return result.jokes;
  }

  @override
  FutureOr<List<JokeModel>> build() async {
    return await _fetchJokes(filter);
  }
}
