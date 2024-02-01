# Galactic Hotkeys

A Flutter package that simplifies the implementation of keyboard shortcuts in your Flutter applications.

## Usage

To use Galactic Hotkeys, wrap your main widget with the `GalacticHotkeys` widget and provide the desired shortcuts and a callback function to handle when a shortcut is pressed.

```dart
GalacticHotkeys<String>(
  shortcuts: {
    'Save': [
      [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyS],
      [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyS],
    ],
    'Copy': [
      [LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyC],
      [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyC],
    ],
    // Add more shortcuts as needed
  },
  onShortcutPressed: (String identifier) {
    // Handle the shortcut press
    print('Shortcut pressed: $identifier');
  },
  child: const Container(),
)
```

In this example, the GalacticHotkeys widget is used to capture keyboard shortcuts and trigger the onShortcutPressed callback with the corresponding identifier.

## License

This project is licensed under the **BSD 3-Clause License**.

