import 'package:rxdart/rxdart.dart';

extension StreamLog<T> on Stream<T> {
  Stream<T> log(String tag) =>
      this.doOnEach((notification) => print("$tag $notification"));
}

extension FutureLog<T> on Future<T> {
  Future<T> log(String tag) => this.then((value) {
        print("$tag $value");
        return value;
      });
}
