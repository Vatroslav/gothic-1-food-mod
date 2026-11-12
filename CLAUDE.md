# Gothic 1 Remake: Food Scaling

Script-only ModKit mod. `FoodScaling/` is the mod package; only that folder goes to `G1R/Mods`.

## Rules

- **No spoilers.** Vatra is playing the game for the first time. Game scripts, docs and sample mods contain character, quest, place, item and chapter names. Never write those in chat, commits or files unless Vatra mentioned them first. Use UI names and general words ("food", "healing plant").
- Repo content (code, README, commits) is in English. Chat with Vatra is in Croatian.
- Writing outside `~/github` needs Vatra's explicit yes each time. This includes copying to `G1R\Mods`, launch options, `Mods.ini` and other mods in Vortex.
- Don't publish the mod to Nexus or Steam Workshop.
- Only Vatra can confirm the mod works, by seeing it in his game.
- Scope (agreed 2026-11-12): food that heals over time also heals a share of max health by tier (8/16/30%), same pace, longer duration, one strength slider, hero only. No mana, potion or other changes unless Vatra asks. Drinks and healing plants get the bonus because they share the effect; changing that needs an item check the scripts don't show yet.
- Other mods' code is a reference only: don't copy it without checking its license.
- Game behavior claims come from the shipped scripts (`G1R/Script`, also in the official `AlkimiaInteractive/G1R-Modkit` repo) or the ModKit docs, not from memory. Item consumption is native code; scripts only see the effect class and its spec.
