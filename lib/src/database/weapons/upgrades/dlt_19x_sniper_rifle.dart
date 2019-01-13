import 'package:swlegion/swlegion.dart';

final dlt19XSniperRifle = Weapon(
  name: 'DLT-19x Sniper Rifle',
  dice: {
    AttackDice.black: 2,
  },
  minRange: 1,
  keywords: const {
    WeaponKeyword.kHighVelocity: '',
    WeaponKeyword.kPierce: 1,
  },
);
