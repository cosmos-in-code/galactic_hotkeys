import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'galactic_hotkeys_controller.dart';

/// Definition of a map of shortcuts where T is the type of identifier.
typedef GroupsShortcuts<T> = Map<T, List<List<LogicalKeyboardKey>>>;

/// Definition of the callback function for when a shortcut is pressed.
typedef ShortcutPressed<T> = Function(
    T identifier, List<LogicalKeyboardKey> pressedKeys);

/// Widget that facilitates the implementation of keyboard shortcuts in Flutter.
class GalacticHotkeys<T> extends StatefulWidget {
  /// The main child widget that GalacticHotkeys wraps.
  final Widget? child;

  /// Widget builder for the main child widget.
  final Widget Function(BuildContext context, T? identifier)? builder;

  /// Map of shortcuts and their corresponding identifiers.
  final GroupsShortcuts<T> shortcuts;

  /// Callback function when a shortcut is pressed.
  final ShortcutPressed<T>? onShortcutPressed;

  /// Creates a new instance of the widget using a child.
  const GalacticHotkeys({
    super.key,
    required Widget this.child,
    required this.shortcuts,
    required ShortcutPressed<T> this.onShortcutPressed,
  }) : builder = null;

  /// Creates a new instance of the widget using a builder.
  const GalacticHotkeys.builder({
    super.key,
    required this.shortcuts,
    this.onShortcutPressed,
    required Widget Function(BuildContext context, T? identifier) this.builder,
  }) : child = null;

  @override
  State<GalacticHotkeys<T>> createState() => _GalacticHotkeysState<T>();
}

class _GalacticHotkeysState<T> extends State<GalacticHotkeys<T>> {
  /// Focus node for handling keyboard events.
  final _focusNode = FocusNode();

  final _controller = GalacticHotkeysController();

  /// List of currently pressed keys.
  final List<LogicalKeyboardKey> _pressedKeys = [];

  /// Current pressed shortcut, for example, when pressing `ctrl left`, this will be `LogicalKeyboardKey.controlLeft` until the shortcut is released.
  T? _currentPressedShortcut;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _controller,
      child: FocusScope(
        onKeyEvent: (focus, event) {
          _handleKey(event);
          return KeyEventResult.handled;
        },
        autofocus: true,
        child:
            widget.child ?? widget.builder!(context, _currentPressedShortcut),
      ),
    );
  }

  void _handleKey(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent &&
        !_pressedKeys.contains(keyEvent.logicalKey)) {
      _pressedKeys.add(keyEvent.logicalKey);
    } else {
      _pressedKeys.remove(keyEvent.logicalKey);
    }

    // Fix the bug when click many keys at the same time in macos
    if (Platform.isMacOS &&
        keyEvent is KeyUpEvent &&
        keyEvent.logicalKey == LogicalKeyboardKey.metaLeft) {
      _pressedKeys.clear();
    }

    _controller.add([..._pressedKeys]);

    bool found = false;

    // Check is a shortcut is pressed
    for (final entry in widget.shortcuts.entries) {
      final identifier = entry.key;
      final shortcuts = entry.value;

      for (final shortcut in shortcuts) {
        final test = shortcut.length == _pressedKeys.length &&
            shortcut.every((key) => _pressedKeys.contains(key));
        if (test) {
          found = true;
          break;
        }
      }

      if (found) {
        widget.onShortcutPressed?.call(identifier, _pressedKeys);
        if (widget.builder != null) {
          setState(() => _currentPressedShortcut = identifier);
        }
        break;
      }
    }
  }
}
