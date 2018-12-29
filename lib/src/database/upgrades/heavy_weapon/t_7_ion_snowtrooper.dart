import 'package:swlegion/swlegion.dart';

import '../../units/snowtroopers.dart' as unit;
import '../../weapons/upgrades/t_7_ion_disrupter_rifle.dart' as weapon;

final t7IonSnowtrooper = Upgrade(
  id: 't-7-ion-snowtrooper',
  name: 'T-7 Ion Snowtrooper',
  type: UpgradeSlot.heavyWeapon,
  isExhaustible: true,
  restrictedToUnit: [unit.snowtroopers.toRef()],
  addsMiniature: true,
  weapon: weapon.t7IonDisrupterRifle,
  points: 34,
);
