local mod	= DBM:NewMod("Horsemen", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16063, 16064, 16065, 30549)

mod:RegisterCombat("combat", 16063, 16064, 16065, 30549)

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED_DOSE"
)

local warnMeteorSoon		= mod:NewAnnounce("WarningMeteorSoon", 1, 24340)
local warnMarkSoon			= mod:NewAnnounce("WarningMarkSoon", 1, 28835, false)
local warnMarkNow			= mod:NewAnnounce("WarningMarkNow", 2, 28835)

local specWarnMarkOnPlayer	= mod:NewSpecialWarning("SpecialWarningMarkOnPlayer", nil, false, true)

local timerMeteor			= mod:NewTimer(15, "TimerMetor", 24340)
local enrageTimer			= mod:NewBerserkTimer(60)

mod:AddBoolOption("HealthFrame", true)

--events.ScheduleEvent(EVENT_METEOR, urandms(10,15)); first
--events.ScheduleEvent(EVENT_METEOR, urandms(13,17)); thereafter

mod:SetBossHealthInfo(
	16064, L.Korthazz,
	30549, L.Rivendare,
	16065, L.Blaumeux,
	16063, L.Zeliek
)

local markCounter = 0

function mod:OnCombatStart(delay)
	markCounter = 0

	enrageTimer:Start(-delay)
	timerMeteor:Show(22 - delay)
	warnMeteorSoon:Schedule(20 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
local markSpam = 0
	if args:IsSpellID(28832, 28833, 28834, 28835) and (GetTime() - markSpam) > 5 then
		markSpam = GetTime()
		markCounter = markCounter + 1
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and args:IsPlayer() then
		if args.amount >= 4 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28884, 57467, 24340) then --thane's meteor
		timerMeteor:Show(13)
		warnMeteorSoon:Schedule(11)
	end
end
