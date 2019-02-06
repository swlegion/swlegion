import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

final _mapEquals = const MapEquality<Object, Object>().equals;
final _mapHash = const MapEquality<Object, Object>().hash;

class AttackPool {
  /// Aim tokens.
  final int aimTokens;

  /// How to treat [AttackDiceSide.surge].
  final AttackSurge surge;

  /// Attacking dice pool.
  final Map<AttackDice, int> dice;

  /// Attacking dice that are dependent on [WeaponKeyword.kSpray].
  final Map<AttackDice, int> spray;

  /// Whether [WeaponKeyword.kHighVelocity] is in the attack pool.
  final bool highVelocity;

  /// [WeaponKeyword.kPierce] in the attack pool.
  final int pierce;

  /// How many dice should be re-rolled when [aimTokens] are used.
  ///
  /// This should account for [UnitKeyword.kPrecise] and similar rules.
  final int diceToReroll;

  /// [WeaponKeyword.kImpact] in the attack pool.
  final int impact;

  /// [UnitKeyword.kSharpshooter] in the attack pool.
  final int sharpshooter;

  /// Whether [WeaponKeyword.kBlast] is in the attack pool.
  final bool blast;

  const AttackPool({
    this.aimTokens = 0,
    this.surge,
    @required this.dice,
    this.spray = const {},
    this.highVelocity = false,
    this.sharpshooter = 0,
    this.impact = 0,
    this.pierce = 0,
    this.diceToReroll = 2,
    this.blast = false,
  })  : assert(aimTokens >= 0),
        assert(dice != null),
        assert(spray != null),
        assert(pierce >= 0),
        assert(diceToReroll >= 2),
        assert(sharpshooter >= 0),
        assert(impact >= 0),
        assert(blast != null);

  AttackPool copyWith({
    int aimTokens,
    AttackSurge surge,
    Map<AttackDice, int> dice,
    Map<AttackDice, int> spray,
    int pierce,
    int diceToReroll,
    int sharpshooter,
    int impact,
    bool blast,
  }) {
    return AttackPool(
      aimTokens: aimTokens ?? this.aimTokens,
      surge: surge ?? this.surge,
      dice: dice ?? this.dice,
      spray: spray ?? this.spray,
      pierce: pierce ?? this.pierce,
      diceToReroll: diceToReroll ?? this.diceToReroll,
      sharpshooter: sharpshooter ?? this.sharpshooter,
      impact: impact ?? this.impact,
      blast: blast ?? this.blast,
    );
  }

  @override
  bool operator ==(Object o) {
    return identical(this, o) ||
        o is AttackPool &&
            aimTokens == o.aimTokens &&
            surge == o.surge &&
            _mapEquals(dice, o.dice) &&
            _mapEquals(spray, o.spray) &&
            highVelocity == o.highVelocity &&
            sharpshooter == o.sharpshooter &&
            impact == o.impact &&
            pierce == o.pierce &&
            diceToReroll == o.diceToReroll &&
            blast == o.blast;
  }

  @override
  int get hashCode =>
      aimTokens.hashCode ^
      surge.hashCode ^
      _mapHash(dice) ^
      _mapHash(spray) ^
      highVelocity.hashCode ^
      sharpshooter.hashCode ^
      impact.hashCode ^
      pierce.hashCode ^
      diceToReroll.hashCode ^
      blast.hashCode;

  /// Returns [dice] flattened a list of [totalDice].
  List<AttackDice> flattenDice({int targets}) {
    final results = dice.entries.fold<List<AttackDice>>([], (p, d) {
      return p..addAll(Iterable.generate(d.value, (_) => d.key));
    }).toList();
    if (targets != null && spray.isNotEmpty) {
      results.addAll(spray.entries.fold<List<AttackDice>>([], (p, d) {
        return p..addAll(Iterable.generate(targets * d.value, (_) => d.key));
      }));
    }
    return results;
  }

  /// Total dice (of any color) being thrown.
  int get totalDice {
    return dice.values.fold(0, (a, b) => a + b);
  }

  @override
  String toString() {
    final details = const JsonEncoder.withIndent('  ').convert({
      'aimTokens': aimTokens,
      'surge': surge?.name,
      'dice': dice,
      'spray': spray,
      'highVelocity': highVelocity,
      'sharpshooter': sharpshooter,
      'impact': impact,
      'pierce': pierce,
      'diceToReroll': diceToReroll,
      'blast': blast,
    });
    return 'AttackPool $details';
  }
}

class DefensePool {
  /// Whether the defending units have [UnitKeyword.kArmor].
  final bool armor;

  /// How much cover the defending units have.
  ///
  /// This should include terrain, suppression, and through abilities such as
  /// [UnitKeyword.kCover], [UnitKeyword.kLowProfile], or through upgrades like
  /// "Duck and Cover".
  final int cover;

  /// Whether the defending units have [UnitKeyword.kDeflect].
  final bool deflect;

  /// What type of dice the defending units are using.
  final DefenseDice dice;

  /// Total targets in this unit defending.
  final int targets;

  /// Whether to convert [DefenseDiceSide.surge] to a block.
  final bool surge;

  /// Dodge tokens.
  final int dodge;

  /// Number of nearby units with [UnitKeyword.kGuardian] available.
  final int guardians;

  /// Whether the defending units have [UnitKeyword.kImmuneBlast].
  final bool immuneToBlast;

  /// Whether the defending units have [UnitKeyword.kImmunePierce].
  final bool immuneToPierce;

  /// Whether the defending units have [UnitKeyword.kImpervious].
  final bool impervious;

  /// Whether the defending units have [UnitKeyword.kUncannyLuck].
  final int uncannyLuck;

  const DefensePool({
    @required this.dice,
    this.targets = 1,
    this.surge = false,
    this.armor = false,
    this.cover = 0,
    this.deflect = false,
    this.dodge = 0,
    this.guardians = 0,
    this.immuneToBlast = false,
    this.immuneToPierce = false,
    this.impervious = false,
    this.uncannyLuck = 0,
  })  : assert(dice != null),
        assert(targets >= 1),
        assert(surge != null),
        assert(armor != null),
        assert(cover >= 0 && cover <= 2),
        assert(deflect != null),
        assert(dodge >= 0),
        assert(guardians >= 0),
        assert(immuneToBlast != null),
        assert(immuneToPierce != null),
        assert(impervious != null),
        assert(uncannyLuck >= 0);

  /// Returns the amount of effective (final) cover if attacked by [attacker].
  int computeCover(AttackPool attacker) {
    if (attacker.blast && !immuneToBlast) {
      return 0;
    }
    return math.max(0, cover - attacker.sharpshooter);
  }

  DefensePool copyWith({
    int cover,
    int dodge,
    int guardians,
    int targets,
  }) {
    return DefensePool(
      dice: dice,
      surge: surge,
      armor: armor,
      cover: cover ?? this.cover,
      deflect: deflect,
      dodge: dodge ?? this.dodge,
      guardians: guardians ?? this.guardians,
      targets: targets ?? this.targets,
      immuneToBlast: immuneToBlast,
      immuneToPierce: immuneToPierce,
      impervious: impervious,
      uncannyLuck: uncannyLuck,
    );
  }

  @override
  bool operator ==(Object o) {
    return identical(this, o) ||
        o is DefensePool &&
            dice == o.dice &&
            surge == o.surge &&
            armor == o.armor &&
            cover == o.cover &&
            targets == o.targets &&
            deflect == o.deflect &&
            dodge == o.dodge &&
            guardians == o.guardians &&
            immuneToBlast == o.immuneToBlast &&
            immuneToPierce == o.immuneToPierce &&
            impervious == o.impervious &&
            uncannyLuck == o.uncannyLuck;
  }

  @override
  int get hashCode =>
      dice.hashCode ^
      surge.hashCode ^
      armor.hashCode ^
      cover.hashCode ^
      targets.hashCode ^
      deflect.hashCode ^
      dodge.hashCode ^
      guardians.hashCode ^
      immuneToBlast.hashCode ^
      immuneToPierce.hashCode ^
      impervious.hashCode ^
      uncannyLuck.hashCode;

  @override
  String toString() {
    final details = const JsonEncoder.withIndent('  ').convert({
      'dice': dice.name,
      'surge': surge,
      'armor': armor,
      'cover': cover,
      'targets': targets,
      'deflect': deflect,
      'dodge': dodge,
      'guardians': guardians,
      'immuneToBlast': immuneToBlast,
      'immuneToPierce': immuneToPierce,
      'impervious': impervious,
      'diceToReroll': uncannyLuck,
    });
    return 'DefensePool $details';
  }
}
