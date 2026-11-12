# Gothic 1 Remake: Food Scaling

A small script-only mod for Gothic 1 Remake: food that heals over time also heals a share of your max health, so small food stays useful when your max health grows.

| Unmodded healing | Tier | Bonus at 100% strength |
|---|---|---|
| 12 or less | weak | 8% of max health |
| 13 to 30 | medium | 16% of max health |
| more than 30 | strong | 30% of max health |

Example with 300 max health: food that heals 3 heals 3 + 24 = 27.

The pace stays the same (the item's own health per second); the healing lasts longer. Food never heals less than unmodded.

Set the bonus strength in `Settings > Game > Food Scaling` (0 to 200%, 0 = off).

## How it works

Every item that heals over time applies one game effect, with the healing per second and the number of seconds set by the item. The mod replaces that effect with a subclass whose duration is calculated: the item's own seconds plus enough extra seconds to heal the bonus. Only the hero gets the bonus.

Because it is one shared effect, drinks and healing plants that heal over time get the bonus too. Mana over time is not changed. Item tooltips still show the unmodded values.

The tier idea comes from the alternative mode of the UE4SS mod Food Rework; no code is taken from it.

## Install

1. Copy the `FoodScaling` folder to `G1R/Mods` in the game's install folder.
2. Enable the mod in the game's mod manager (launch option `-ModManagementUI`).

No UE4SS or other loader is needed. Loading an older save shows the game's different-modlist warning, as with any mod.

Unofficial fan mod, not affiliated with the game's developers or publisher.
