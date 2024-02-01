import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:galactic_hotkeys/galactic_hotkeys_controller.dart';
import 'package:provider/provider.dart';

/// A builder widget for handling Galactic Hotkeys and providing the list of pressed keys.
class GalacticHotkeysBuilder extends StatelessWidget {

  /// A function that takes [BuildContext] and a list of [LogicalKeyboardKey]s as arguments
  /// and returns a widget to be built with the current pressed keys.
  final Widget Function(BuildContext context, List<LogicalKeyboardKey> pressedKeys) builder;

  /// Creates a [GalacticHotkeysBuilder] with the specified builder function.
  ///
  /// The [builder] function is invoked with the current [BuildContext] and a list of
  /// [LogicalKeyboardKey]s representing the currently pressed keys.
  const GalacticHotkeysBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<GalacticHotkeysController>(context).stream,
      builder: (context, snapshot) {
        return builder(context, snapshot.data ?? []);
      },
    );
  }
}
