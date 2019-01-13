import 'package:swlegion/swlegion.dart';

final anakinsLightsaber = Weapon.melee(
  name: 'Anakin\'s Lightsaber',
  dice: {
    AttackDice.black: 6,
  },
  keywords: const {
    WeaponKeyword.kImpact: 2,
    WeaponKeyword.kPierce: 2,
  },
);
