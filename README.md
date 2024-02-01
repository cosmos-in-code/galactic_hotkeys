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
  onShortcutPressed: (String identifier, List<LogicalKeyboardKey> pressedKeys) {
    // Handle the shortcut press
    print('Shortcut pressed: $identifier');
  },
  child: const Container(),
)
```

In this example, the GalacticHotkeys widget is used to capture keyboard shortcuts and trigger the onShortcutPressed callback with the corresponding identifier.


Additionally, you can use the GalacticHotkeysBuilder widget to build your UI based on the currently pressed keys.

```dart
GalacticHotkeysBuilder(
  builder: (context, List<LogicalKeyboardKey> pressedKeys) {
    // Example: Check if only the Control key is pressed
    final onlyControlIsPressed = pressedKeys.length == 1 && pressedKeys.first == LogicalKeyboardKey.controlLeft;
    
    // Use the pressedKeys information to build your UI accordingly
    return YourCustomWidget(
      showControlMessage: onlyControlIsPressed,
    );
  },
)
```
In this example, GalacticHotkeysBuilder is used to get the list of currently pressed keys and build a custom widget based on the condition that only the Control key is pressed. Customize the builder function as needed for your application.
**Note:** GalacticHotkeysBuilder should have a parent GalacticHotkeys widget in the widget tree to function correctly. Ensure that you have wrapped your main widget with GalacticHotkeys or its equivalent ancestor using a Provider

## License

This project is licensed under the **BSD 3-Clause License**.

