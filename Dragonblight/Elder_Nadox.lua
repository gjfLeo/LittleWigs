﻿------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Elder Nadox"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ElderNadox",
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end)

L:RegisterTranslations("deDE", function() return {
} end)

L:RegisterTranslations("frFR", function() return {
} end)

L:RegisterTranslations("koKR", function() return {
} end)

L:RegisterTranslations("zhCN", function() return {
} end)

L:RegisterTranslations("zhTW", function() return {
} end)

L:RegisterTranslations("esES", function() return {
} end)

L:RegisterTranslations("ruRU", function() return {
	log = "|cffff0000"..boss.."|r: Для этого босса необходимы правильные данные. Пожалуйста, включите запись логов (команда /combatlog) или установите аддон transcriptor, и пришлите получившийся файл (или оставьте ссылку на файл в комментариях на curse.com).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partycontent = true
mod.otherMenu = "Dragonblight"
mod.zonename = BZ["Ahn'kahet: The Old Kingdom"]
mod.enabletrigger = boss
mod.guid = 29309
mod.toggleoptions = {"bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------
