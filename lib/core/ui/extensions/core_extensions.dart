import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension Uint8ListExtensions on Uint8List {
  String get decode => utf8.decode(this);
}

extension ListExtensions on List {
  bool containsAt(int index) => asMap()[index] != null;
}

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(<K, List<E>>{},
      (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension StringExtensions on String {
  String getStringOnCount(int count) {
    return count > 1 || count == 0 ? '${this}s' : this;
  }

  String get capitalizeFirstLetter => isNotEmpty ? this[0].toUpperCase() + substring(1) : '';
}

extension BoolExtensions on bool {
  int get intState => this ? 1 : 0;
}

extension IntExtensions on int {
  bool get boolState => this == 1;
}

extension DoubleExtensions on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    final list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
