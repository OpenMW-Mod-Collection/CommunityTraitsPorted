# Community Traits Ported (OpenMW)

Select your character's past that will shape his future.

This is an effort to port some community-made traits based on [Merlord's Character Backgrounds](https://www.nexusmods.com/morrowind/mods/46795) or MTR's mods.

## Traits

Currently ported trait packs:

**Backgrounds**

- [Merlord's Character Backgrounds](https://www.nexusmods.com/morrowind/mods/46795) by Merlord (27 traits)
- Sage's Backgrounds - Merged Version by VvardenfellStormSage (5 traits)
  - [Raised by Beasts](https://www.nexusmods.com/morrowind/mods/52560)
  - [Raised by Cultists](https://www.nexusmods.com/morrowind/mods/53851)
  - [The Slayer](https://www.nexusmods.com/morrowind/mods/52769)
  - [The Ronin](https://www.nexusmods.com/morrowind/mods/53696)
- [The Wretched and the Weird](https://www.nexusmods.com/morrowind/mods/55570) by AlandroSul
  - The Wretched and the Weird (9 traits)
  - Oblivion Backgrounds (12 traits)
- [More Backgrounds](https://www.nexusmods.com/morrowind/mods/55753) by Frana5u (14 traits)
- [More character backgrounds for Merlord's character backgrounds](https://www.nexusmods.com/morrowind/mods/48076) by isNaN (7 traits)

**Beliefs**

- [mtrByTheDivines](https://www.nexusmods.com/morrowind/mods/48031) by MTR (80 traits)

**Lineages**

- [mtrLineage](https://www.nexusmods.com/morrowind/mods/49996) by MTR (81 trait)

**Cultures**

- [mtrCultures](https://www.nexusmods.com/morrowind/mods/51282) by MTR (57 + 10 traits)

I'm not listing every single one of them, so for info check individual mod pages instead.

### My Personal Changes

They are reduced to a minimum and either are aimed at better balancing or dictated by engine limitations / my unwillingness to abuse the API.

**Merlord's Character Backgrounds > Artificer**

> +50 Enchant -> +20 Enchant

Even though disabled spells is quite a heavy hindrance, at high levels Enchant becomes objectively more powerful than any school of magic due to charge discount.

**Merlord's Character Backgrounds > Framed**

> Initial bounty delay: 1 hour -> 1-24 hours

Initial bounty delay was increased and randomized to both give player more wiggle room at the start and make it more sudden (at default 30 timescale, 1 in-game day = 48 irl minutes).

> Bounty interval: 1-4 days -> 2-6 days

Merlord in his version skips adding bounty if the player is in combat at the time of checking. While this can be implemented in OpenMW in a roundabout way, I figured it would be easier to just pump the numbers up a bit and not jump through the multiple hoops for this inconsequential change.

**Merlord's Character Backgrounds > Blood of the Dremora**  
**Merlord's Character Backgrounds > Escaped Slave**  
**Merlord's Character Backgrounds > Famed Warrior**

> Scripted enemies will spawn randomly behind the player instead of as sleep encounters.

I have multiple reasons for this change:

- OpenMW Lua API doesn't have any way to **reliably** check if player is sleeping. If the logic for it is dependent on `Auto-save when Rest` setting specifically being ON, I would prefer to avoid that entirely
- While the "kill the target when it expects the least" reasoning can be far-fetched for random animals or assasin organization, it doesn't sit right for me in terms of slavers, rivals and daedra
- I like it being more unexpected. Fight me

And besides, limit on their spawn frequency is still the same.

**Merlord's Character Backgrounds > Blood of the Dremora**

> Magic skills raised by killing a dremora don't conribute to your level progress.

It's actually the same as in Merlord's mod, but I figured I should mention it just in case. Yes, this is intentional, because otherwise you could get up to 8 major/minor skill ups for free every other level just by picking the right class.

**Merlord's Character Backgrounds > Escaped Slave**  
**MTR's Lineages > Khajiit**

> Added Tamriel_Data khajiit races to the trait requirements whitelist.

Self-explanatory, I presume?

**The Wretched and the Weird > Drunkard**

> Drain fatigue ability -> max fatigue reduction

Drain fatigue affects current fatigue and not max, thus it gets healed in a few seconds back.

> Duration of the withdrawal: 6 real life hours -> 7.5 in-game days

Since I like to leave the game running while I'm AFK, I translated real life time checks into in-game. At default settings they should be the same, but if you play with slower flow of time, you might want to reduce this setting. Or not. I certainly won't.

> Any potions are alcoholic -> only beverages are alcoholic

While I can imagine alchemists making their tinctures alcoholic-based, it doesn't make much sense gameplay-wise when you already constantly drinking potions.

**The Wretched and the Weird > Nudist**

> +75 Unarmored -> +30 Unarmored

Starting with ~50-70 armor right off the bat is not a good balancing in my book.

## Installation

### Requirements

- Character Traits Framework by me
- [OAAB_Data](https://www.nexusmods.com/morrowind/mods/49042) by OAAB_Data Team - for Merlord's Character Backgrounds and Sage's Backgrounds
- OpenMW 0.51 Nightly (April 2026 or newer) - for Famed Warrior background (Merlord's Character Backgrounds)

### Load Order

All trait modules need to be loaded after the `CharacterTraitsFramework.lua`. For example:

- CharacterTraitsFramework.lua
- CharacterTraits_Backgrounds.omwaddon
- CharacterTraits_Backgrounds.omwscripts
- CharacterTraits_Beliefs.omwaddon
- CharacterTraits_Beliefs.omwscripts
- ...

## Compatibility

Compatible with basically any mods.

Safe to install mid-playthrough. For updating check release details. Removing the mod might not revert all effects of the picked traits.

### Known issues

**[Sun's Dusk](https://www.nexusmods.com/morrowind/mods/57526)**

> Green Pact (Merlord's): Possible inconsistencies in tagging ingredients green pact compliant

While we use the same food and drinks database (at least, as of time of this collection's release), due to multiple factors I can't sync their data with mine.

> Green Pact (Merlord's): Eating food from world using SD "interaction" feature is not restricted

This should be done on SD's side.

### Supported mods

**Alcoholic drinks**

- [Tamriel_Data](https://www.nexusmods.com/morrowind/mods/44537)
- [OAAB_Data](https://www.nexusmods.com/morrowind/mods/49042)
- [Sun's Dusk](https://www.nexusmods.com/morrowind/mods/57526)

**Green pact-friendly foods**

- [Sun's Dusk](https://www.nexusmods.com/morrowind/mods/57526) (it actually takes over the control if it's installed)
- [Tamriel_Data](https://www.nexusmods.com/morrowind/mods/44537)
- [OAAB_Data](https://www.nexusmods.com/morrowind/mods/49042)
- [Devilish Vampire Overhaul](https://www.nexusmods.com/morrowind/mods/52969)
- [Expanded Loot](https://www.nexusmods.com/morrowind/mods/56699)
- [Hunterwind](https://www.nexusmods.com/morrowind/mods/54808)
- [Uvirith's Legacy](https://www.nexusmods.com/morrowind/mods/53858)
- [Starwind](https://www.nexusmods.com/morrowind/mods/48909)
- Plus a name-based recognition for non-covered cases

## Recommended Mods

- [Pretty Stats](https://www.nexusmods.com/morrowind/mods/58304) by ownlyme
- [Abilities Are Modifiers](https://www.nexusmods.com/morrowind/mods/57295) by ownlyme
- [Uncapper](https://www.nexusmods.com/morrowind/mods/58457) by ownlyme / [Skill Evolution](https://www.nexusmods.com/morrowind/mods/57802) by mym
- [HUDMarkers](https://www.nexusmods.com/morrowind/mods/57112) by ownlyme
- [Jammings off](https://www.nexusmods.com/morrowind/mods/44523) by SymphonyTeam
- [Attend Me](https://www.nexusmods.com/morrowind/mods/51232) by urm
- [Paxon the Pack Rat](https://www.nexusmods.com/morrowind/mods/45669) by Tizzo
- [Devilish Alcohol Overhaul](https://www.nexusmods.com/morrowind/mods/55038) by Merlord and DetailDevil

## Credits

**Sosnoviy Bor** - Trait porting  
**hyacinth and ownlyme** - Food and drinks databases ([Sun's Dusk](https://www.nexusmods.com/morrowind/mods/57526))  
**Merlord, MTR, AlandroSul, Frana5u, isNaN** - Making the origianl traits
