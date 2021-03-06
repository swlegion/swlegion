import 'package:swlegion/swlegion.dart';

final battleMeditation = Upgrade(
  id: 'battle-meditation',
  name: 'Battle Meditation',
  type: UpgradeSlot.force,
  points: 10,
  text: r'''
    When you issue orders, one of those orders can be issued to any friendly unit on the battlefield.
  ''',
  waves: const [
    Wave.wCore,
  ],
);
