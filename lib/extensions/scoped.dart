/// main() {
///   Map<String, String> maybeNull;
///   maybeNull = {'hello': 'world'};
///
///   final bar = maybeNull?.also((absolutelyNotNull) {
///     absolutelyNotNull.addAll({'mickey': 'mouse'});
///   });
///
///   print(bar); // {hello: world, mickey: mouse}
///
///   final int nrOfKeys = bar?.let((mapNotNull) => mapNotNull.keys.length);
///
///   print(nrOfKeys); // 2
/// }
extension ScopingFunctions<T> on T {
  /// Calls the specified function [block] with `this` value
  /// as its argument and returns its result.
  R let<R>(R Function(T) block) => block(this);

  /// Calls the specified function [block] with `this` value
  /// as its argument and returns `this` value.
  T also(void Function(T) block) {
    block(this);
    return this;
  }
}
