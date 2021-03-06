import 'package:swlegion/swlegion.dart';

final ax20BlasterCannon = Weapon(
  name: 'AX-20 Blaster Cannon',
  dice: {
    AttackDice.white: 1,
    AttackDice.black: 1,
    AttackDice.red: 1,
  },
  minRange: 1,
  maxRange: 3,
  keywords: {
    WeaponKeyword.kFixedFront: '',
    WeaponKeyword.kImpact: 1,
  },
);
