# Repository working instructions

- Always commit completed work. Multiple commits for a single user instruction
  are fine; use coherent commits and include all changes made for that work.
  Leave unrelated user changes untouched.
- Give every commit a short, descriptive headline followed by a detailed body.
  The body must explain the code changes and their purpose, and describe testing:
  tests added or changed, commands run, results, and any verification limitations.
  Do not claim checks that were not performed.
- Always add useful tests for behavior changes. Cover expected behavior, failure
  cases, and relevant policy-validity boundaries (e.g. classification/category
  combinations the underlying SPIF policy would reject). Refactor existing code
  when needed to make behavior testable rather than leaving it untested. For
  changes limited to documentation or build configuration, use the relevant
  existing checks; add regression coverage when it would detect a meaningful
  failure.
- Run the relevant tests and build checks before committing. Use `flutter
  analyze` and `dart format --output=none --set-exit-if-changed .` for static
  checks, and `flutter test` for the widget test suite. This package has no
  platform-specific code, but when a change could plausibly affect rendering on
  a given platform, verify the affected platform(s) build (`flutter build apk`,
  `flutter build linux`/`macos`/`windows`, `flutter build web`, as relevant)
  rather than assuming compatibility across targets.
- Maintain the overall design in `doc/design.md`, including decisions,
  assumptions, scope, test coverage, and known limitations. Keep `README.md`
  focused on usage, supported platforms, and externally relevant compatibility
  behavior.
- Stop and ask questions when requirements or consequential design choices need
  clarification. Record the resulting decisions in the design document. Proceed
  with routine implementation choices and work already authorized by the user.

## Project context

This project, `flutter_spiffing`, is a Flutter widget library implementing a
security-label editor/picker UI on top of the [`spiffing`](../spiffing-dart)
package (a pure-Dart SPIF/Label/Clearance security-labelling policy engine).
Given a parsed `Spif` and a `Label` to edit, it renders a reactive editor:
pick a classification, toggle category chips per tag set, see a live marking
preview, and (given a holder's `Clearance`) see whether the label being built
is releasable to them. The Dart package name is `flutter_spiffing`.

The widgets are pure Material components with no platform-specific code, so
the library must remain targetable to Web, Android, and desktop (Linux,
macOS, Windows) without branching on platform checks. Keep the public Dart
API (`lib/flutter_spiffing.dart`) free of anything that would tie it to a
single platform. Widgets must never duplicate policy logic in the UI layer:
enabled/disabled and visible/hidden states should always be derived from the
SPIF's own validity rules (`Spif.valid`, `Label.canAddCategory`,
`Spif.acdf`, etc.) or from small helpers built strictly on top of `spiffing`'s
public API (see `lib/src/label_helpers.dart`), never from ad hoc UI-side
policy checks.

The test suite should cover the widget behavior with `flutter test` against
small, self-contained sample SPIFs and must not require a real device,
emulator, or browser for the default run. If a gap is found in `spiffing`'s
public API (an enumeration, accessor, or validity check the UI needs but the
library doesn't expose), prefer extending `spiffing-dart` additively over
reimplementing or working around the gap here. Document such gaps and any
intentional design deviations in `doc/design.md`.
