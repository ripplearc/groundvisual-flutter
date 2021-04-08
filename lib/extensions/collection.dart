import 'package:groundvisual_flutter/extensions/scoped.dart';

extension NullAware<T> on Iterable<T> {
  T? firstOrNull<T>() {
    if (isEmpty) {
      return null;
    } else {
      return first as T;
    }
  }

  T? getOrNull<T>(int index) {
    if (index >= length) {
      return null;
    } else {
      return elementAt(index) as T;
    }
  }

  Iterable<E> mapNotNull<E>(E? f(T t)) =>
      expand((t) => f(t)?.let((v) => [v]) ?? ([] as List<E>));

  Iterable<E> mapWithIndex<E>(E Function(int i, T) callback) =>
      Iterable.generate(
          length, (index) => callback(index, this.elementAt(index)));
}
