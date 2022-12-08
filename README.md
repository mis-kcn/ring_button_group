<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Ring Button Group

This package provides a configurable component to support a group of buttons
displayed on a sized ring.

<img src="https://github.com/xeric/ring_button_group/raw/main/images/demo.png" title="" alt="" width="561">

## Features

<img src="https://github.com/xeric/ring_button_group/raw/main/images/demo.gif" title="" alt="" width="561">

## Getting started

```shell
flutter pub add ring_button_group
```

or manually add this to your package's `pubspec.yaml` file:

```yaml
...
dependencies:
  ring_button_group: ^1.0.0
```

Now in your Dart code, you can use:

```dart
import 'package:ring_button_group/ring_button_group.dart';
```

## Usage

```dart
SizedBox(
    width: 200, //set a width
    height: 200, //set a height, should be same with width
    child: RingButtonGroup(
      buttonNumber: 5, //total number of buttons in group
      icons: const [ //a list of icons displayed on button
        Icon(Icons.abc, color: Colors.white,),
        Icon(Icons.baby_changing_station, color: Colors.white,),
        Icon(Icons.cabin, color: Colors.white,),
        Icon(Icons.dangerous, color: Colors.white,),
        Icon(Icons.e_mobiledata, color: Colors.white,),
      ],
      type: RingButtonGroupType.MULTIPLE_SELECTABLE, // allow multiple select
      pressedIndex: const {1}, //default selected buttons index, start from 0
      shadowEffect: true,
      onPressed: (index, allSelected) {  },
    ),
  ),
)
```

## RingButtonGroup Attributes

| Attribute          | Type               | Default                  | Annotation                                                                                                                                        |
| ------------------ | ------------------ | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| buttonNumber       | int                |                          | total number of buttons in this group, must be greater than 1                                                                                     |
| pressedIndex       | Set<int>           | `{}`                     | a list of indexes of button which should be pressed when rendering, index starts from 0                                                           |
| onPressed          | OnPressedFunction? | `null`                   | bool Function(int index, Set<int>? selected), selected is a set of indexes represents current all pressed buttons when type is **MULTIPLE_SELECTABLE**, return true to accomplish press, otherwise it is cancel press action |
| disabled           | bool               | `false`                  | navigation buttons of **BottomBarWithSheet**                                                                                                      |
| buttonSize         | double             | `40`                     | the size of button, it identifies the radius of the circle                                                                                        |
| toneColor          | Color              | `Colors.blueAccent`      | main color of the button                                                                                                                          |
| tintColor          | Color              | `Colors.blueGrey`        | button color while pressing down                                                                                                                  |
| activeColor        | Color              | `Colors.lightBlueAccent` | button color after pressed                                                                                                                        |
| borderColor        | Color              | `Colors.lightBlueAccent` | button border color                                                                                                                               |
| disableColor       | Color              | `Colors.blueAccent`      | disabled main color, when color same with toneColor, auto transform to grayscale                                                                  |
| disableBorderColor | Color              | `Colors.lightBlueAccent` | disabled border color, when color same with borderColor, auto transform to grayscale                                                              |
| icons              | List<Icon>?        | `null`                   | button icons list, while set, the list length must be same with `buttonNumber`                                                                    |
| labels             | List<Text>?        | `null`                   | button label list, only works when `icons` is `null`, the list length must be same with `buttonNumber`                                            |
| child              | Widget?            | `null`                     | a child of ring button, common case is put a circle in the center for display purpose                                                             |
| shadowEffect       | bool               | `false`                    | use a inner shadow effects in pressed/selected button                                                                                             |
| splitStrokeSize    | double             | `0.5`                    | the width of line split the button, note that this is not the border of circle                                                                                             |

## RingButtonGroupType

| type                | description                                                                    |
| ------------------- | ------------------------------------------------------------------------------ |
| PRESS_ONLY          | such type only allow press action, but will not stay in pressed/selected state |
| SINGLE_SELECTABLE   | only allow one of buttons stay in pressed/selected state, like a radio box     |
| MULTIPLE_SELECTABLE | allow multiple pressed like a checkbox                                         |

## Example

to `/example` folder.

you can find the example show in screenshot from file: `./example/lib/main/dart`

#### Run example in your simulator or device

```shell
flutter run
```

## Additional information

when you using this ring button group, this widget should be contained by a `SizedBox` or similar widget with width and height properties, and must be a square - with same value in width and height, the widget itself is stretched.
