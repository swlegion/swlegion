import 'package:swlegion/swlegion.dart';

import '../../units/rebel_troopers.dart' as unit;

final rebelTrooper = Upgrade(
  id: 'REBEL_TROOPER',
  name: 'Rebel Trooper',
  type: UpgradeSlot.personnel,
  addsMiniature: true,
  restrictedToUnit: [unit.rebelTroopers],
  points: 10,
);