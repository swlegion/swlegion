import 'package:swlegion/swlegion.dart';

import '../../units/fleet_troopers.dart' as unit;
import '../../weapons/upgrades/mpl_57_barrage_launcher.dart' as weapon;

final mpl57BarrageTrooper = Upgrade(
  id: 'MPL_57_BARRAGE_TROOPER',
  name: 'MPL-57 Barrage Trooper',
  type: UpgradeSlot.heavyWeapon,
  isExhaustible: true,
  restrictedToUnit: [unit.fleetTroopers],
  addsMiniature: true,
  weapon: weapon.mpl57BarrageLauncher,
  points: 33,
);