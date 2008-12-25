------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Ingvar the Plunderer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local deathcount = 0

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ingvar",

	smash = "Smash",
	smash_desc = "Warn for the casting of Smash or Dark Smash.",
	smash_message = "Casting %s",

	smashBar = "Smash Bar",
	smashBar_desc = "Show a bar for the casting of Smash or Dark Smash.",
	
	roar = "Roar",
	roar_desc = "Warn for the casting of Staggering Roar or Dreadful Roar.",
	roar_message = "Casting %s",

	woe = "Woe Strike",
	woe_desc = "Warn for who has the Woe Strike debuff.",
	woe_message = "Woe Strike on %s",

	woeBar = "Woe Strike Bar",
	woeBar_desc = "Show a bar for the duration of the Woe Strike debuff.",
	woeBar_message = "Woe Strike: %s",
} end )

L:RegisterTranslations("koKR", function() return {
	smash = "강타",
	smash_desc = "어둠의 강타와 강타의 시전에 대해 알립니다.",
	smash_message = "%s 시전",
	
	smashBar = "강타 바",
	smashBar_desc = "어둠의 강타와 강타의 시전 바를 표시합니다.",
	
	roar = "포효",
	roar_desc = "포효의 시전에 대해 알립니다.",
	roar_message = "%s 시전",
	
	woe = "불행의 일격",
	woe_desc = "불행의 일격 디버프가 걸린 플레이어를 알립니다.",
	woe_message = "불행의 일격: %s",

	woeBar = "불행의 일격 바",
	woeBar_desc = "불행의 일격 디버프가 지속되는 바를 표시합니다.",
	woeBar_message = "불행의 일격: %s",
} end )

L:RegisterTranslations("frFR", function() return {
	smash = "Choc",
	smash_desc = "Prévient quand Ingvar incante son Choc ou son Choc sombre.",
	smash_message = "%s en incantation",

	roar = "Rugissement",
	roar_desc = "Prévient quand Ingvar incante un de ses Rugissements.",
	roar_message = "%s en incantation",
} end )

L:RegisterTranslations("zhTW", function() return {
	smash = "打擊",
	smash_desc = "当施放黑暗破擊或潰擊时发出警报。",
	smash_message = "正在施放 %s！",
	
	roar = "咆哮",
	roar_desc = "当施放驚恐咆哮或驚懼咆哮时发出警报。",
	roar_message = "正在施放 %s！",
} end )

L:RegisterTranslations("deDE", function() return {
	smash = "Zerkrachen",
	smash_desc = "Warnt vor Zerkrachen oder Dunkelem Zerkrachen.",
	smash_message = "Wirkt %s",
	
	roar = "Brüllen",
	roar_desc = "Warnt vor Wankendem Brüllen oder Grässliches Gebrüll.",
	roar_message = "Wirkt %s",
} end )

L:RegisterTranslations("zhCN", function() return {
	smash = "打击",
	smash_desc = "当施放黑暗打击或冲撞时发出警报。",
	smash_message = "正在施放 %s！",
	
	roar = "咆哮",
	roar_desc = "当施放惊愕怒吼或恐怖咆哮时发出警报。",
	roar_message = "正在施放 %s！",
} end )

L:RegisterTranslations("ruRU", function() return {
	smash = "Мощный удар",
	smash_desc = "Предупреждать о применении мощных ударов.",
	smash_message = "Применяется %s",

	smashBar = "Полоса удара",
	smashBar_desc = "Отображает полосу применения удара и мощного удара.",
	
	roar = "Рёв",
	roar_desc = "Предупреждать, когда Staggering применяет рёв или оглушающий рёв.",
	roar_message = "Применяется %s",
	
	woe = "Удар скорби",
	woe_desc = "Сообщает когда ктото получает дебафф удара скорби.",
	woe_message = "Удар скорби - %s",

	woeBar = "Полоса Удара скорби",
	woeBar_desc = "Отображает полосу продолжительности дебаффа удара скорби.",
	woeBar_message = "Удар скорби: %s",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Howling Fjord"
mod.zonename = BZ["Utgarde Keep"]
mod.enabletrigger = boss 
mod.guid = 23954
mod.toggleoptions = {"smash", "smashBar", -1, "woe", "woeBar", -1, "roar", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Smash", 42723, 42669, 59706)
	self:AddCombatListener("SPELL_CAST_START", "Roar", 42708, 42729, 59708, 59734)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Woe", 42730, 59735)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	deathcount = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Smash(_, spellID, _, _, spellName)
	if self.db.profile.smash then
		self:IfMessage(L["smash_message"]:format(spellName), "Urgent", spellID)
	end
	if self.db.profile.smashBar then
		self:Bar(L["smash_message"]:format(spellName), 3, spellID)
	end
end

function mod:Roar(_, spellID, _, _, spellName)
	if self.db.profile.roar then
		self:IfMessage(L["roar_message"]:format(spellName), "Urgent", spellID)
	end
end

function mod:BossDeath(_, _, source)
	if not self.db.profile.bosskill then return end
	if source == boss then
		deathcount = deathcount + 1	
	end
	if deathcount == 2 then
		self:GenericBossDeath(boss, true)
	end
end

function mod:Woe(player, spellId)
	if self.db.profile.woe then
		self:IfMessage(L["woe_message"]:format(player), "Urgent", spellId)
	end
	if self.db.profile.woeBar then
		self:Bar(L["woeBar_message"]:format(player), 10, spellId)
	end
end
