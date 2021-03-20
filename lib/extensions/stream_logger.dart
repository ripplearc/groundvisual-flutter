import 'package:rxdart/rxdart.dart';

extension StreamLog<T> on Stream<T> {
  Stream<T> log(String tag) => this
      .doOnListen(() => print("$tag 🦻🦻🦻 Listening"))
      .doOnEach((notification) => print("$tag ✅ ✅ ✅ Event: $notification"))
      .doOnDone(() => print("$tag 🌊 🌊 🌊 Done"))
      .doOnCancel(() => print("$tag ❌ ❌ ❌ Cancelled"))
      .doOnError((error, stacktrace) => print("$tag ⚠️ ⚠️ ⚠️️ Error: $error"));
}

extension FutureLog<T> on Future<T> {
  Future<T> log(String tag) => this.then((value) {
        print("$tag $value");
        return value;
      });
}
