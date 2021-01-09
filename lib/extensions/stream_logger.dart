import 'package:rxdart/rxdart.dart';

extension StreamLog<T> on Stream<T> {
  Stream<T> log(String tag) =>
      this.doOnEach((notification) => print("$tag $notification"));
}
