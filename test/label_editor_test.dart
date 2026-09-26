import 'package:flutter/material.dart';
import 'package:flutter_spiffing/flutter_spiffing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiffing/spiffing.dart';

// A small, self-contained SPIF mirroring the shape of the "food" example
// policy used by `spiffing-dart`'s own test suite: a few hierarchical
// classifications, one permissive tag set, and one restrictive tag set.
const _testSpifXml = '''
<SPIF>
  <securityPolicyId name="Food" id="1.2.826.0.1.6726289.0.0"/>
  <securityClassifications>
    <securityClassification name="Freely Available" color="#DFDFDF" lacv="50" hierarchy="0"/>
    <securityClassification name="Commodity" color="white" lacv="51" hierarchy="1"/>
    <securityClassification name="Luxury" color="red" lacv="52" hierarchy="2">
      <requiredCategory operation="oneOrMore">
        <categoryGroup tagSetRef="Taste Sensations" tagType="permissive" lacv="6"/>
      </requiredCategory>
    </securityClassification>
  </securityClassifications>
  <securityCategoryTagSets>
    <securityCategoryTagSet name="Taste Sensations" id="1.2.826.0.1.6726289.0.0.1">
      <securityCategoryTag name="Flavour" tagType="permissive">
        <tagCategory name="Sweet" lacv="3"/>
        <tagCategory name="Chocolate" lacv="6">
          <excludedClass>Commodity</excludedClass>
        </tagCategory>
      </securityCategoryTag>
    </securityCategoryTagSet>
    <securityCategoryTagSet name="Allergens" id="1.2.826.0.1.6726289.0.0.2">
      <securityCategoryTag name="Allergens" tagType="restrictive">
        <tagCategory name="Lactose" lacv="1"/>
      </securityCategoryTag>
    </securityCategoryTagSet>
    <securityCategoryTagSet name="Trade Secrets" id="1.2.826.0.1.6726289.0.0.3">
      <securityCategoryTag name="Trade Secrets" tagType="permissive">
        <tagCategory name="Recipe" lacv="1">
          <excludedClass>Freely Available</excludedClass>
        </tagCategory>
      </securityCategoryTag>
    </securityCategoryTagSet>
  </securityCategoryTagSets>
</SPIF>
''';

void main() {
  late Spif spif;
  late Label label;

  setUp(() {
    // Registering via a fresh [Site] (rather than `Spif.fromXml` directly)
    // makes the policy resolvable by id, which [Clearance.parse] needs.
    spif = Site().load(_testSpifXml);
    label = Label.forPolicy(spif);
  });

  Future<void> pumpEditor(WidgetTester tester, {Clearance? clearance}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: LabelEditor(spif: spif, label: label, clearance: clearance),
          ),
        ),
      ),
    );
  }

  testWidgets('renders the default classification and marking', (tester) async {
    await pumpEditor(tester);

    expect(find.text('Freely Available'), findsWidgets);
    expect(find.text('Sweet'), findsOneWidget);
    expect(find.text('Lactose'), findsOneWidget);
  });

  testWidgets('selecting a classification updates the label', (tester) async {
    await pumpEditor(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Commodity'));
    await tester.pump();

    expect(label.classification.name, 'Commodity');
  });

  testWidgets('toggling a category chip mutates the label', (tester) async {
    await pumpEditor(tester);

    final sweet = spif
        .tagSetLookupByName('Taste Sensations')
        .categoryLookupByName(TagType.permissive, 'Sweet');
    expect(label.hasCategory(sweet), isFalse);

    await tester.tap(find.widgetWithText(FilterChip, 'Sweet'));
    await tester.pump();

    expect(label.hasCategory(sweet), isTrue);
  });

  testWidgets(
    'a chip that would make the label invalid on removal is disabled',
    (tester) async {
      await pumpEditor(tester);

      // Select "Chocolate" while "Freely Available" (no exclusion applies).
      await tester.tap(find.widgetWithText(FilterChip, 'Chocolate'));
      await tester.pump();

      // "Luxury" requires "Chocolate" (already selected), and doesn't
      // exclude it, so switching to "Luxury" should succeed and leave the
      // chip visible...
      await tester.tap(find.widgetWithText(ChoiceChip, 'Luxury'));
      await tester.pump();

      final chocolateChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Chocolate'),
      );
      expect(chocolateChip.selected, isTrue);
      // ...but removing it now would leave "Luxury" without its required
      // category, so it must be disabled rather than hidden.
      expect(chocolateChip.onSelected, isNull);
    },
  );

  testWidgets(
    'a category excluded by the current classification is hidden entirely',
    (tester) async {
      await pumpEditor(tester);

      // "Chocolate" excludes the "Commodity" classification, but the label
      // starts as "Freely Available" so it should currently be shown.
      expect(find.widgetWithText(FilterChip, 'Chocolate'), findsOneWidget);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Commodity'));
      await tester.pump();

      // Rather than merely being disabled, the excluded chip disappears.
      expect(find.widgetWithText(FilterChip, 'Chocolate'), findsNothing);
    },
  );

  testWidgets(
    'a tag set with every category excluded by the classification is hidden',
    (tester) async {
      await pumpEditor(tester);

      // "Recipe" excludes "Freely Available" (the label's starting/default
      // classification), and it's the only category in "Trade Secrets", so
      // the whole tag set should be absent, not just its chip.
      expect(find.text('Recipe'), findsNothing);
      expect(find.text('Trade Secrets'), findsNothing);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Commodity'));
      await tester.pump();

      expect(find.text('Recipe'), findsOneWidget);
      expect(find.text('Trade Secrets'), findsWidgets);
    },
  );

  testWidgets('shows a clearance indicator when a clearance is supplied', (
    tester,
  ) async {
    final clearance = Clearance.parse('''
<clearance xmlns='http://surevine.com/xmlns/spiffy'>
  <policy id='1.2.826.0.1.6726289.0.0'>Food labelling policy</policy>
  <classification lacv='50'/>
</clearance>
''', Format.xml);

    await pumpEditor(tester, clearance: clearance);

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
