# Community Traits Ported (OpenMW)

Select your character's past that will shape his future.

This is an effort to port some community-made traits based on [Merlord's Character Backgrounds](https://www.nexusmods.com/morrowind/mods/46795) or MTR's mods.

## Traits

Currently ported trait packs:

- [Merlord's Character Backgrounds](https://www.nexusmods.com/morrowind/mods/46795) by Merlord
- [mtrByTheDivines](https://www.nexusmods.com/morrowind/mods/48031) by MTR
- [mtrLineage](https://www.nexusmods.com/morrowind/mods/49996) by MTR
- [mtrCultures](https://www.nexusmods.com/morrowind/mods/51282) by MTR

I'm not listing every single one of them (bro, there's 250+ of them here), so for info check individual mod pages instead.

### My Personal Changes

They are reduced to a minimum and either are aimed at better balancing or dictated by engine limitations / my unwillingness to abuse the API.

**Merlord's Character Backgrounds > Artificer**

> +50 Enchant -> +20 Enchant

Even though disabled spells is quite a heavy hindrance, at high levels Enchant becomes objectively more powerful than any school of magic due to charge discount.

**Merlord's Character Backgrounds > Framed**

> Initial bounty delay: 1 hour -> 1-24 hours

Initial bounty delay was increased and randomized to both give player more wiggle room at the start and make it more sudden (at default 30 timescale, 1 in-game day = 48 irl minutes).

> Bounty interval: 1-4 days -> 2-6 days

Merlord in his version skips adding bounty if the player is in combat at the time of checking. While this can be implemented in OpenMW in a roundabout way, I figured it would be easier to just pump the numbers up a bit. and not jump through the multiple hoops for this inconsequential change.

**Merlord's Character Backgrounds > Blood of the Dremora, Escaped Slave, Famed Warrior**

> Scripted enemies will spawn randomly behind the player instead of as sleep encounters.

I have multiple reasons for this change:

a. OpenMW Lua API doesn't have any way to **reliably** check if player is sleeping. If the logic for it is dependent on `Auto-save when Rest` setting specifically being ON, I would prefer to avoid that entirely  
1) While the "kill the target when it expects the least" reasoning can be far-fetched for random animals or assasin organization, it doesn't sit right for me in terms of slavers, rivals and daedra  
III - I like it being more unexpected. Fight me

And besides, limit on their spawn frequency is still the same.

## Installation

### Requirements

- Character Traits Framework by me
- [OAAB_Data](https://www.nexusmods.com/morrowind/mods/49042) by OAAB_Data Team - for Merlord's Character Backgrounds

### Load Order

All trait modules need to be loaded after the `CharacterTraitsFramework.lua`. For example:

- CharacterTraitsFramework.lua
- CharacterTraits_Backgrounds.omwaddon
- CharacterTraits_Backgrounds.omwscripts
- CharacterTraits_Beliefs.omwaddon
- CharacterTraits_Beliefs.omwscripts
- ...

## Compatibility

Compatible with any mods.

Safe to install or update mid-playthrough. Removing the mod, though, might not revert all effects of the picked traits.

## Credits

**Sosnoviy Bor** - Trait porting
**Merlord, MTR** - Making the origianl traits
