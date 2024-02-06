import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galactic_hotkeys/galactic_hotkeys_widget.dart';

void main() {
  runApp(const ExampleGalacticHotkeys());
}

class ExampleGalacticHotkeys extends StatelessWidget {
  const ExampleGalacticHotkeys({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galactic Hotkeys Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _HomePage(),
    );
  }
}

enum Shortcut {
  undo,
  redo,
  cut,
  copy,
  paste,
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  Shortcut? _latestPressedShortcut;
  Timer? _delayToClearShortcutPressed;

  @override
  void dispose() {
    _delayToClearShortcutPressed?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galactic Hotkeys'),
      ),
      body: GalacticHotkeys<Shortcut>(
        shortcuts: const {
          Shortcut.undo: [
            [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyZ],
            [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyZ],
          ],
          Shortcut.redo: [
            [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyY],
            [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyY],
            [
              LogicalKeyboardKey.controlLeft,
              LogicalKeyboardKey.shiftLeft,
              LogicalKeyboardKey.keyZ
            ],
            [
              LogicalKeyboardKey.metaLeft,
              LogicalKeyboardKey.shiftLeft,
              LogicalKeyboardKey.keyZ
            ],
          ],
          Shortcut.cut: [
            [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyX],
            [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyX],
          ],
          Shortcut.copy: [
            [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyC],
            [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyC],
          ],
          Shortcut.paste: [
            [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyV],
            [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyV],
          ],
        },
        onShortcutPressed: (Shortcut shortcut, pressedKeys) {
          setState(() => _latestPressedShortcut = shortcut);

          _delayToClearShortcutPressed?.cancel();
          _delayToClearShortcutPressed = Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => _latestPressedShortcut = null);
            }
          });
          // switch (shortcut) {
          //   case Shortcut.undo:
          //     break;
          //   case Shortcut.redo:
          //     break;
          //   case Shortcut.cut:
          //     break;
          //   case Shortcut.copy:
          //     break;
          //   case Shortcut.paste:
          //     break;
          // }
        },
        child: ListView(
          children: [
            for (final shortcut in Shortcut.values)
              ListTile(
                title: Text(
                  shortcut.name,
                  style: TextStyle(
                    color:
                        shortcut == _latestPressedShortcut ? Colors.red : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
