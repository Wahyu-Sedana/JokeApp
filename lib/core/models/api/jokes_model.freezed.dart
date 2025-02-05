// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jokes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JokesModel _$JokesModelFromJson(Map<String, dynamic> json) {
  return _JokesModel.fromJson(json);
}

/// @nodoc
mixin _$JokesModel {
  bool? get error => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  List<JokeModel> get jokes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JokesModelCopyWith<JokesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokesModelCopyWith<$Res> {
  factory $JokesModelCopyWith(
          JokesModel value, $Res Function(JokesModel) then) =
      _$JokesModelCopyWithImpl<$Res, JokesModel>;
  @useResult
  $Res call({bool? error, int amount, List<JokeModel> jokes});
}

/// @nodoc
class _$JokesModelCopyWithImpl<$Res, $Val extends JokesModel>
    implements $JokesModelCopyWith<$Res> {
  _$JokesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? amount = null,
    Object? jokes = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      jokes: null == jokes
          ? _value.jokes
          : jokes // ignore: cast_nullable_to_non_nullable
              as List<JokeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JokesModelCopyWith<$Res>
    implements $JokesModelCopyWith<$Res> {
  factory _$$_JokesModelCopyWith(
          _$_JokesModel value, $Res Function(_$_JokesModel) then) =
      __$$_JokesModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? error, int amount, List<JokeModel> jokes});
}

/// @nodoc
class __$$_JokesModelCopyWithImpl<$Res>
    extends _$JokesModelCopyWithImpl<$Res, _$_JokesModel>
    implements _$$_JokesModelCopyWith<$Res> {
  __$$_JokesModelCopyWithImpl(
      _$_JokesModel _value, $Res Function(_$_JokesModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? amount = null,
    Object? jokes = null,
  }) {
    return _then(_$_JokesModel(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      jokes: null == jokes
          ? _value._jokes
          : jokes // ignore: cast_nullable_to_non_nullable
              as List<JokeModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JokesModel implements _JokesModel {
  _$_JokesModel(
      {required this.error,
      required this.amount,
      required final List<JokeModel> jokes})
      : _jokes = jokes;

  factory _$_JokesModel.fromJson(Map<String, dynamic> json) =>
      _$$_JokesModelFromJson(json);

  @override
  final bool? error;
  @override
  final int amount;
  final List<JokeModel> _jokes;
  @override
  List<JokeModel> get jokes {
    if (_jokes is EqualUnmodifiableListView) return _jokes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jokes);
  }

  @override
  String toString() {
    return 'JokesModel(error: $error, amount: $amount, jokes: $jokes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JokesModel &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            const DeepCollectionEquality().equals(other._jokes, _jokes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, error, amount, const DeepCollectionEquality().hash(_jokes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JokesModelCopyWith<_$_JokesModel> get copyWith =>
      __$$_JokesModelCopyWithImpl<_$_JokesModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JokesModelToJson(
      this,
    );
  }
}

abstract class _JokesModel implements JokesModel {
  factory _JokesModel(
      {required final bool? error,
      required final int amount,
      required final List<JokeModel> jokes}) = _$_JokesModel;

  factory _JokesModel.fromJson(Map<String, dynamic> json) =
      _$_JokesModel.fromJson;

  @override
  bool? get error;
  @override
  int get amount;
  @override
  List<JokeModel> get jokes;
  @override
  @JsonKey(ignore: true)
  _$$_JokesModelCopyWith<_$_JokesModel> get copyWith =>
      throw _privateConstructorUsedError;
}
