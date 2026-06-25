local I = require("openmw.interfaces")

I.Settings.registerGroup {
    key = 'SettingsMerlordBackgrounds_framed',
    page = 'MerlordBackgrounds',
    l10n = 'MerlordBackgrounds',
    name = 'framed_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'minBounty',
            name = 'minBounty_name',
            renderer = 'number',
            default = 20,
        },
        {
            key = 'maxBounty',
            name = 'maxBounty_name',
            renderer = 'number',
            default = 120,
        },
        {
            key = 'bountyLimit',
            name = 'bountyLimit_name',
            description = 'bountyLimit_desc',
            renderer = 'number',
            default = 300,
        },
        {
            key = 'minInterval',
            name = 'minInterval_name',
            renderer = 'number',
            default = 2,
        },
        {
            key = 'maxInterval',
            name = 'maxInterval_name',
            renderer = 'number',
            default = 6,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsMerlordBackgrounds_ratKing',
    page = 'MerlordBackgrounds',
    l10n = 'MerlordBackgrounds',
    name = 'ratKing_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'spawnCooldown',
            name = 'spawnCooldown_name',
            renderer = 'number',
            default = 12,
        },
        {
            key = 'spawnChance',
            name = 'spawnChance_name',
            description = "spawnChance_desc",
            renderer = 'number',
            default = 10,
        },
        {
            key = 'minSpawn',
            name = 'minSpawn_name',
            renderer = 'number',
            default = 3,
        },
        {
            key = 'maxSpawn',
            name = 'maxSpawn_name',
            renderer = 'number',
            default = 5,
        },
        {
            key = 'hordeLimit',
            name = 'hordeLimit_name',
            description = 'hordeLimit_desc',
            renderer = 'number',
            default = 15,
            min = 0,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsMerlordBackgrounds_bloodOfDremora',
    page = 'MerlordBackgrounds',
    l10n = 'MerlordBackgrounds',
    name = 'bloodOfDremora_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'BoD_minDelay',
            name = 'BoD_minDelay_name',
            renderer = 'number',
            default = 1,
        },
        {
            key = 'BoD_maxDelay',
            name = 'BoD_maxDelay_name',
            renderer = 'number',
            default = 3 * 24,
        },
        {
            key = 'BoD_levelsPerEnemy',
            name = 'BoD_levelsPerEnemy_name',
            description = 'BoD_levelsPerEnemy_desc',
            renderer = 'number',
            default = 2,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsMerlordBackgrounds_escapedSlave',
    page = 'MerlordBackgrounds',
    l10n = 'MerlordBackgrounds',
    name = 'escapedSlave_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'ES_minDelay',
            name = 'ES_minDelay_name',
            renderer = 'number',
            default = 1,
        },
        {
            key = 'ES_maxDelay',
            name = 'ES_maxDelay_name',
            renderer = 'number',
            default = 3 * 24,
        },
        {
            key = 'ES_levelsPerEnemy',
            name = 'ES_levelsPerEnemy_name',
            description = 'ES_levelsPerEnemy_desc',
            renderer = 'number',
            default = 1,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsMerlordBackgrounds_famedWarrior',
    page = 'MerlordBackgrounds',
    l10n = 'MerlordBackgrounds',
    name = 'famedWarrior_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'FW_minDelay',
            name = 'FW_minDelay_name',
            renderer = 'number',
            default = 1,
        },
        {
            key = 'FW_maxDelay',
            name = 'FW_maxDelay_name',
            renderer = 'number',
            default = 3 * 24,
        },
        {
            key = 'FW_levelsPerEnemy',
            name = 'FW_levelsPerEnemy_name',
            description = 'FW_levelsPerEnemy_desc',
            renderer = 'number',
            default = 1,
        },
    }
}
