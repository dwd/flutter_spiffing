# flutter_spiffing

Flutter widgets for building security-label editor/picker UIs on top of the
[`spiffing`](https://github.com/dwd/spiffing-dart) library (a pure-Dart port
of the C++ `spiffing` SPIF/Label/Clearance policy engine).

Given a parsed **SPIF** (Security Policy Information File) and a `Label` to
edit, this package renders a reactive editor: pick a classification, toggle
category chips for each tag set, see a live marking preview, and (if a
holder's `Clearance` is supplied) see whether the label being built would
actually be releasable to them. Widgets stay disabled/hidden for
combinations the policy wouldn't allow, using the SPIF's own validity rules
rather than duplicating that logic in the UI: a category (or tag, or whole
tag set) that the current classification excludes outright is hidden
entirely, while a category that's merely off-limits given the label's
*other* selected categories stays visible but disabled.

This package is Flutter-only and has no platform-specific code, so it works
on Web, Android, iOS, and desktop wherever Flutter does.

## Features

- `LabelEditor` — a complete, ready-to-drop-in editor: marking preview +
  classification selector + a category picker per tag set, optionally with
  a clearance/ACDF indicator.
- `ClassificationSelector` — a colour-coded picker for a `Spif`'s
  classifications.
- `TagSetPicker` / `TagCategoryPicker` / `CategoryChip` — the individual
  building blocks `LabelEditor` is composed from, for apps that want their
  own layout.
- `MarkingPreview` — a banner rendering `Spif.displayMarking` for a label,
  coloured by its classification.
- `ClearanceIndicator` — shows the result of `Spif.acdf` for a label against
  a clearance, plus any categories still required by the label's
  classification.

## Getting started

Add both this package and `spiffing` as dependencies (until published, a
`git` dependency works fine — see this package's own `pubspec.yaml` for an
example pointing at the `spiffing-dart` repository).

## Usage

```dart
import 'package:flutter_spiffing/flutter_spiffing.dart';
import 'package:spiffing/spiffing.dart';

final spif = Spif.fromXml(spifXml); // obtained from your server
final label = Label.forPolicy(spif);

// ...

LabelEditor(
  spif: spif,
  label: label,
  clearance: holdersClearance, // optional
  onChanged: (label) {
    // persist / re-validate / send the edited label
  },
)
```

## Additional information

The picker/editor logic here is policy-shaped rather than app-shaped: any
SPIF-aware app (chat, document management, mail, ...) needing to let a user
build or review a security label can reuse these widgets as-is.
