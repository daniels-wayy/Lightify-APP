import 'package:freezed_annotation/freezed_annotation.dart';

part 'house.freezed.dart';

@freezed
abstract class House with _$House {
  const factory House({
    required String name,
    required List<String> remotes,
  }) = _House;
}
