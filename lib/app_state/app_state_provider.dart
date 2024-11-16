import 'package:flutter/material.dart';

class AppState<T extends ChangeNotifier> extends InheritedWidget {
  final T state;

  const AppState({
    super.key,
    required this.state,
    required super.child,
  });

  // This is the method to access the provider's state from the widget tree.
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<AppState<T>>();
    assert(provider != null, 'No StateProvider found in context for $T');
    return provider!.state;
  }

  @override
  bool updateShouldNotify(covariant AppState<T> oldWidget) {
    return oldWidget.state != state;
  }
}