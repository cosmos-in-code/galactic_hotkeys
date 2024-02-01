library galactic_hotkeys;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Definition of a map of shortcuts where T is the type of identifier.
typedef GroupsShortcuts<T> = Map<T, List<List<LogicalKeyboardKey>>>;

/// Definition of the callback function for when a shortcut is pressed.
typedef ShortcutPressed<T> = Function(T identifier);

/// Widget that facilitates the implementation of keyboard shortcuts in Flutter.
class GalacticHotkeys<T> extends StatefulWidget {

  /// The main child widget that GalacticHotkeys wraps.
  final Widget child;

  /// Map of shortcuts and their corresponding identifiers.
  final GroupsShortcuts<T> shortcuts;

  /// Callback function when a shortcut is pressed.
  final ShortcutPressed<T> onShortcutPressed;

  const GalacticHotkeys({
    super.key,
    required this.child,
    required this.shortcuts,
    required this.onShortcutPressed,
  });

  @override
  State<GalacticHotkeys<T>> createState() => _GalacticHotkeysState<T>();
}

class _GalacticHotkeysState<T> extends State<GalacticHotkeys<T>> {
  /// Focus node for handling keyboard events.
  final _focusNode = FocusNode();

  /// List of currently pressed keys.
  final List<LogicalKeyboardKey> _pressedKeys = [];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onKeyEvent: (focus, event) {
        _handleKey(event);
        return KeyEventResult.handled;
      },
      autofocus: true,
      child: widget.child,
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
        widget.onShortcutPressed(identifier);
        break;
      }
    }
  }
}
