--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroDBC
local DBC = HeroDBC.DBC
-- HeroLib
local HL = HeroLib
local Cache = HeroCache
local Unit = HL.Unit
local Player = Unit.Player
local Target = Unit.Target
local Spell = HL.Spell
local MultiSpell = HL.MultiSpell
local Item = HL.Item
-- HeroRotation
local HR = HeroRotation
local AoEON = HR.AoEON
local CDsON = HR.CDsON
-- Lua
local GetWeaponEnchantInfo = GetWeaponEnchantInfo


--- ============================ CONTENT ============================
--- ======= APL LOCALS =======
-- Commons
local Everyone = HR.Commons.Everyone
local Shaman = HR.Commons.Shaman

-- GUI Settings
local Settings = {
  General = HR.GUISettings.General,
  Commons = HR.GUISettings.APL.Shaman.Commons,
  Enhancement = HR.GUISettings.APL.Shaman.Enhancement
}

local S = Spell.Shaman.Enhancement

-- Items
if not Item.Shaman then Item.Shaman = {} end
Item.Shaman.Enhancement = {
  -- Legendaries

}
local I = Item.Shaman.Enhancement

-- Rotation Var
local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId

local Enemies40y, MeleeEnemies10y, MeleeEnemies10yCount, MeleeEnemies5y, Enemies40yCount, EnemiesCount30ySplash

local EnemiesFlameShockCount

local function bool(val)
  return val ~= 0
end

local function totemFinder()
  for i = 1,6,1
  do
    if string.match(Player:TotemName(i), 'Totem') then
      return i
    end
  end
end

local function EvaluateCycleFlameShock(TargetUnit)
  return (TargetUnit:DebuffDown(S.FlameShock) and TargetUnit:DebuffRefreshable(S.FlameShock))
end

local function checkWeaponEnchants()
  local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()

  print(hasMainHandEnchant)
  print(not hasMainHandEnchant and S.WindfuryWeapon:IsCastable())
  if not hasMainHandEnchant and S.WindfuryWeapon:IsCastable() then
    print("enchant")
    if HR.Cast(S.LightningBolt) then return "WindfuryWeapon enchant"; end
  end

end

local function precombat()
  --actions.precombat=flask
  --actions.precombat+=/food
  --actions.precombat+=/augmentation
  --actions.precombat+=/windfury_weapon

  if not hasMainHandEnchant and S.WindfuryWeapon:IsCastable() then
    if HR.Cast(S.WindfuryWeapon) then return "WindfuryWeapon enchant"; end
  end
  --actions.precombat+=/flametongue_weapon
  if not hasOffHandEnchant and S.FlamentongueWeapon:IsCastable() then
    if HR.Cast(S.FlamentongueWeapon) then return "FlamentongueWeapon enchant"; end
  end
  --actions.precombat+=/lightning_shield
  if S.LightningShield:IsCastable() and Player:BuffDown(S.LightningShield) then
    if HR.Cast(S.LightningShield) then return "lightning_shield precombat"; end
  end
  --actions.precombat+=/stormkeeper,if=talent.stormkeeper.enabled
  if S.Stormkeeper:IsCastable() and S.Stormkeeper:IsAvailable() then
    if HR.Cast(S.Stormkeeper) then return "Stormkeeper precombat"; end
  end
  --actions.precombat+=/windfury_totem
  if S.WindfuryTotem:IsCastable() and Player:BuffDown(S.WindfuryTotemBuff) then
    if HR.Cast(S.WindfuryTotem) then return "WindfuryTotem precombat"; end
  end
  --actions.precombat+=/potion
  --# Snapshot raid buffed stats before combat begins and pre-potting is done.
  --actions.precombat+=/snapshot_stats

  -- no APL but something to start with
  if S.FlameShock:IsCastable() and Target:DebuffDown(S.FlameShock) then
    if HR.Cast(S.FlameShock, nil, nil, not Target:IsSpellInRange(S.FlameShock)) then return "FlameShock precombat"; end
  end
end

local function single()
  --# Single target action priority list
  --actions.single=primordial_wave,if=!buff.primordial_wave.up TODO
  --actions.single+=/windfury_totem,if=runeforge.doom_winds.equipped&buff.doom_winds_debuff.down TODO
  --actions.single+=/flame_shock,if=!ticking
  if S.FlameShock:IsCastable() and Target:DebuffDown(S.FlameShock) then
    if HR.Cast(S.FlameShock, nil, nil, not Target:IsSpellInRange(S.FlameShock)) then return "FlameShock 1"; end
  end
  --actions.single+=/vesper_totem
  --actions.single+=/frost_shock,if=buff.hailstorm.up
  if S.FrostShock:IsCastable() and Player:BuffUp(S.HailstormBuff) then
    if HR.Cast(S.FrostShock, nil, nil, not Target:IsSpellInRange(S.FrostShock)) then return "FrostShock 1"; end
  end
  --actions.single+=/earthen_spike
  if S.EarthenSpike:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.EarthenSpike, nil, nil, not Target:IsSpellInRange(S.EarthenSpike)) then return "EarthenSpike 1"; end
  end
  --actions.single+=/fae_transfusion
  --actions.single+=/lightning_bolt,if=buff.stormkeeper.up
  if S.LightningBolt:IsCastable() and Player:BuffUp(S.StormkeeperBuff) then
    if HR.Cast(S.LightningBolt, nil, nil, not Target:IsSpellInRange(S.LightningBolt)) then return "LightningBolt 1"; end
  end
  --actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
  if S.ElementalBlast:IsCastable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.ElementalBlast, nil, nil, not Target:IsSpellInRange(S.ElementalBlast)) then return "ElementalBlast 1"; end
  end
  --actions.single+=/chain_harvest,if=buff.maelstrom_weapon.stack>=5
  --actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack=10
  if S.LightningBolt:IsCastable() and Player:BuffStack(S.MaelstromWeapon) == 10 then
    if HR.Cast(S.LightningBolt, nil, nil, not Target:IsSpellInRange(S.LightningBolt)) then return "LightningBolt 2"; end
  end
  --actions.single+=/lava_lash,if=buff.hot_hand.up|(runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6)
  -- TODO |(runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6)
  if S.LavaLash:IsCastable() and S.HotHand:IsAvailable() and bool(Player:BuffStack(S.HotHandBuff)) and Target:IsInMeleeRange(8) then
    if HR.Cast(S.LavaLash, nil, nil, not Target:IsSpellInRange(S.LavaLash)) then return "LavaLash 1"; end
  end
  --actions.single+=/stormstrike
  if S.Stormstrike:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.Stormstrike, nil, nil, not Target:IsSpellInRange(S.Stormstrike)) then return "Stormstrike 1"; end
  end
  --actions.single+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
  if S.Stormkeeper:IsCastable() and S.Stormkeeper:IsAvailable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.Stormkeeper) then return "Stormkeeper 1"; end
  end
  --actions.single+=/lava_lash
  if S.LavaLash:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.LavaLash, nil, nil, not Target:IsSpellInRange(S.LavaLash)) then return "LavaLash 2"; end
  end
  --actions.single+=/crash_lightning
  if S.CrashLightning:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.CrashLightning) then return "CrashLightning 1"; end
  end
  --actions.single+=/flame_shock,target_if=refreshable
  if S.FlameShock:IsCastable() and Target:DebuffRefreshable(S.FlameShock) then
    if HR.Cast(S.FlameShock, nil, nil, not Target:IsSpellInRange(S.FlameShock)) then return "FlameShock 2"; end
  end
  --actions.single+=/frost_shock
  if S.FrostShock:IsCastable() then
    if HR.Cast(S.FrostShock, nil, nil, not Target:IsSpellInRange(S.FrostShock)) then return "FrostShock 2"; end
  end
  --actions.single+=/ice_strike
  if S.IceStrike:IsCastable() then
    if HR.Cast(S.IceStrike) then return "IceStrike 1"; end
  end
  --actions.single+=/sundering
  if S.Sundering:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.Sundering) then return "Sundering 1"; end
  end
  --actions.single+=/fire_nova,if=active_dot.flame_shock
  if S.FireNova:IsCastable() and Target:DebuffUp(S.FlameShock) then
    if HR.Cast(S.FireNova) then return "FireNova 1"; end
  end
  --actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5
  if S.LightningBolt:IsCastable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.LightningBolt, nil, nil, not Target:IsSpellInRange(S.LightningBolt)) then return "LightningBolt 3"; end
  end
  --actions.single+=/earth_elemental
  if S.EarthElemental:IsCastable() then
    if HR.Cast(S.EarthElemental, Settings.Commons.GCDasOffGCD.EarthElemental) then return "EarthElemental 1"; end
  end
  --actions.single+=/windfury_totem,if=buff.windfury_totem.remains<30
  if S.WindfuryTotem:IsCastable() and (Player:BuffDown(S.WindfuryTotemBuff) or Player:TotemRemains(totemFinder()) < 30) then
    if HR.Cast(S.WindfuryTotem) then return "WindfuryTotem 2"; end
  end

end

local function aoe()
  --# Multi target action priority list
  --actions.aoe=frost_shock,if=buff.hailstorm.up
  if S.FrostShock:IsCastable() and Player:BuffUp(S.HailstormBuff) then
    if HR.Cast(S.FrostShock, nil, nil, not Target:IsSpellInRange(S.FrostShock)) then return "FrostShock 3"; end
  end
  --actions.aoe+=/windfury_totem,if=runeforge.doom_winds.equipped&buff.doom_winds_debuff.down TODO
  --actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled|talent.lashing_flames.enabled|covenant.necrolord TODO covenant
  if S.FlameShock:IsCastable() and (S.FireNova:IsAvailable() or S.LashingFlames:IsAvailable()) then
    if Everyone.CastCycle(S.FlameShock, Enemies40y, EvaluateCycleFlameShock, not Target:IsSpellInRange(S.FlameShock)) then return "FlameShock 3"; end
  end
  --actions.aoe+=/primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up TODO
  --actions.aoe+=/fire_nova,if=active_dot.flame_shock>=3 TODO
  if S.FireNova:IsCastable() and EnemiesFlameShockCount >= 3 then
    if HR.Cast(S.FireNova) then return "FireNova 2"; end
  end
  --actions.aoe+=/vesper_totem TODO
  --actions.aoe+=/lightning_bolt,if=buff.primordial_wave.up&(buff.stormkeeper.up|buff.maelstrom_weapon.stack>=5) TODO
  --actions.aoe+=/crash_lightning,if=talent.crashing_storm.enabled|buff.crash_lightning.down
  if S.CrashLightning:IsCastable() and (S.CrashingStorm:IsAvailable() or Player:BuffDown(S.CrashLightningBuff)) and Target:IsInMeleeRange(8) then
    if HR.Cast(S.CrashLightning) then return "CrashLightning 2"; end
  end
  --actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=talent.lashing_flames.enabled TODO
  --actions.aoe+=/crash_lightning
  if S.CrashLightning:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.CrashLightning) then return "CrashLightning 3"; end
  end
  --actions.aoe+=/chain_lightning,if=buff.stormkeeper.up
  if S.ChainLightning:IsCastable() and Player:BuffUp(S.StormkeeperBuff) then
    if HR.Cast(S.ChainLightning, nil, nil, not Target:IsSpellInRange(S.ChainLightning)) then return "ChainLightning 1"; end
  end
  --actions.aoe+=/chain_harvest,if=buff.maelstrom_weapon.stack>=5 TODO
  --actions.aoe+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
  if S.ElementalBlast:IsCastable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.ElementalBlast, nil, nil, not Target:IsSpellInRange(S.ElementalBlast)) then return "ElementalBlast 2"; end
  end
  --actions.aoe+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
  if S.Stormkeeper:IsCastable() and S.Stormkeeper:IsAvailable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.Stormkeeper) then return "Stormkeeper 2"; end
  end
  --actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack=10
  if S.ChainLightning:IsCastable() and Player:BuffStack(S.MaelstromWeapon) == 10 then
    if HR.Cast(S.ChainLightning, nil, nil, not Target:IsSpellInRange(S.ChainLightning)) then return "ChainLightning 2"; end
  end
  --actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled TODO
  --actions.aoe+=/sundering
  if S.Sundering:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.Sundering) then return "Sundering 2"; end
  end
  --actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6 TODO
  --actions.aoe+=/stormstrike
  if S.Stormstrike:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.Stormstrike, nil, nil, not Target:IsSpellInRange(S.Stormstrike)) then return "Stormstrike 2"; end
  end
  --actions.aoe+=/lava_lash
  if S.LavaLash:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.LavaLash, nil, nil, not Target:IsSpellInRange(S.LavaLash)) then return "LavaLash 3"; end
  end
  --actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1
  if S.FlameShock:IsCastable() then
    if Everyone.CastCycle(S.FlameShock, Enemies40y, EvaluateCycleFlameShock, not Target:IsSpellInRange(S.FlameShock)) then return "FlameShock 4"; end
  end
  --actions.aoe+=/fae_transfusion TODO
  --actions.aoe+=/frost_shock
  if S.FrostShock:IsCastable() then
    if HR.Cast(S.FrostShock, nil, nil, not Target:IsSpellInRange(S.FrostShock)) then return "FrostShock 4"; end
  end
  --actions.aoe+=/ice_strike
  if S.IceStrike:IsCastable() then
    if HR.Cast(S.IceStrike) then return "IceStrike 1"; end
  end
  --actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack>=5
  if S.ChainLightning:IsCastable() and Player:BuffStack(S.MaelstromWeapon) >= 5 then
    if HR.Cast(S.ChainLightning, nil, nil, not Target:IsSpellInRange(S.ChainLightning)) then return "ChainLightning 3"; end
  end
  --actions.aoe+=/fire_nova,if=active_dot.flame_shock>1#
  if S.FireNova:IsCastable() and Target:DebuffUp(S.FlameShock) then
    if HR.Cast(S.FireNova) then return "FireNova 3"; end
  end
  --actions.aoe+=/earthen_spike
  if S.EarthenSpike:IsCastable() and Target:IsInMeleeRange(8) then
    if HR.Cast(S.EarthenSpike, nil, nil, not Target:IsSpellInRange(S.EarthenSpike)) then return "EarthenSpike 2"; end
  end
  --actions.aoe+=/earth_elemental
  if S.EarthElemental:IsCastable() then
    if HR.Cast(S.EarthElemental, Settings.Commons.GCDasOffGCD.EarthElemental) then return "EarthElemental 2"; end
  end
  --actions.aoe+=/windfury_totem,if=buff.windfury_totem.remains<30
  if S.WindfuryTotem:IsCastable() and (Player:BuffDown(S.WindfuryTotemBuff) or Player:TotemRemains(totemFinder()) < 30) then
    if HR.Cast(S.WindfuryTotem) then return "WindfuryTotem 3"; end
  end

end


-- Counter for Debuff on other enemies
local function calcEnemiesFlameShockCount(Object, Enemies)
  local debuffs = 0;
  if HR.AoEON() then
    for _, CycleUnit in pairs(Enemies) do
      if CycleUnit:DebuffUp(Object) then
        debuffs = debuffs +1;
        EnemiesFlameShockCount = debuffs or 0
      end
    end
  end
end

--- ======= ACTION LISTS =======
-- Put here action lists only if they are called multiple times in the APL
-- If it's only put one time, it's doing a closure call for nothing.



--- ======= MAIN =======
local function APL ()
  -- Local Update
  totemFinder()
  hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
  -- Unit Update

  EnemiesCount30ySplash = Target:GetEnemiesInSplashRangeCount(30)
  if AoEON() then
    Enemies40y = Player:GetEnemiesInRange(40)
    Enemies40yCount = #Enemies40y
    MeleeEnemies10y = Player:GetEnemiesInMeleeRange(10)
    MeleeEnemies10yCount = #MeleeEnemies10y or 0
  else
    Enemies40yCount = 1

  end
  -- Defensives

  -- Out of Combat
  if not Player:AffectingCombat() then
    -- Flask
    -- Food
    -- Rune
    -- PrePot w/ Bossmod Countdown
    -- Opener
    if Everyone.TargetIsValid() then
      local ShouldReturn = precombat(); if ShouldReturn then return ShouldReturn; end
    end
    return
  end

  -- In Combat
  if Everyone.TargetIsValid() then
    --# Executed every time the actor is available.
    --actions=bloodlust
    --# In-combat potion is before combat ends.
    --actions+=/potion,if=expected_combat_length-time<60
    --# Interrupt of casts.
    --actions+=/wind_shear
    --actions+=/auto_attack
    --actions+=/windstrike
    if S.Windstrike:IsCastable() then
      if HR.Cast(S.Windstrike, nil, nil, not Target:IsSpellInRange(S.Windstrike)) then return "Windstrike 1"; end
    end
    --actions+=/heart_essence
    --actions+=/use_items
    --actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
    --actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
    --actions+=/fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
    --actions+=/ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
    --actions+=/bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
    --actions+=/feral_spirit
    if S.FeralSpirit:IsCastable() then
      if HR.Cast(S.FeralSpirit, Settings.Enhancement.GCDasOffGCD.FeralSpirit) then return "FeralSpirit 1"; end
    end
    --actions+=/ascendance
    if S.Ascendance:IsCastable() and S.Ascendance:IsAvailable() and CDsON() then
      if HR.Cast(S.Ascendance, Settings.Enhancement.GCDasOffGCD.Ascendance) then return "Ascendance 1"; end
    end
    --# If only one enemy, priority follows the 'single' action list.
    --actions+=/call_action_list,name=single,if=active_enemies=1
    if Enemies40yCount == 1 then
      local ShouldReturn = single(); if ShouldReturn then return ShouldReturn; end
    end
    --# On multiple enemies, the priority follows the 'aoe' action list.
    --actions+=/call_action_list,name=aoe,if=active_enemies>1
    if Enemies40yCount > 1 then
      calcEnemiesFlameShockCount(S.FlameShock, Enemies40y)
      local ShouldReturn = aoe(); if ShouldReturn then return ShouldReturn; end
    end



    return
  end
end

HR.SetAPL(263, APL)


--- ======= SIMC =======
-- Last Update: 11/10/2020

-- APL goes here
--# Executed before combat begins. Accepts non-harmful --actions only.
--actions.precombat=flask
--actions.precombat+=/food
--actions.precombat+=/augmentation
--actions.precombat+=/windfury_weapon
--actions.precombat+=/flametongue_weapon
--actions.precombat+=/lightning_shield
--actions.precombat+=/stormkeeper,if=talent.stormkeeper.enabled
--actions.precombat+=/windfury_totem
--actions.precombat+=/potion
--# Snapshot raid buffed stats before combat begins and pre-potting is done.
--actions.precombat+=/snapshot_stats

--# Executed every time the actor is available.
--actions=bloodlust
--# In-combat potion is before combat ends.
--actions+=/potion,if=expected_combat_length-time<60
--# Interrupt of casts.
--actions+=/wind_shear
--actions+=/auto_attack
--actions+=/windstrike
--actions+=/heart_essence
--actions+=/use_items
--actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
--actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
--actions+=/fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
--actions+=/ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
--actions+=/bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
--actions+=/feral_spirit
--actions+=/ascendance
--# If only one enemy, priority follows the 'single' action list.
--actions+=/call_action_list,name=single,if=active_enemies=1
--# On multiple enemies, the priority follows the 'aoe' action list.
--actions+=/call_action_list,name=aoe,if=active_enemies>1

--# Multi target action priority list
--actions.aoe=frost_shock,if=buff.hailstorm.up
--actions.aoe+=/windfury_totem,if=runeforge.doom_winds.equipped&buff.doom_winds_debuff.down
--actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled|talent.lashing_flames.enabled|covenant.necrolord
--actions.aoe+=/primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up
--actions.aoe+=/fire_nova,if=active_dot.flame_shock>=3
--actions.aoe+=/vesper_totem
--actions.aoe+=/lightning_bolt,if=buff.primordial_wave.up&(buff.stormkeeper.up|buff.maelstrom_weapon.stack>=5)
--actions.aoe+=/crash_lightning,if=talent.crashing_storm.enabled|buff.crash_lightning.down
--actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=talent.lashing_flames.enabled
--actions.aoe+=/crash_lightning
--actions.aoe+=/chain_lightning,if=buff.stormkeeper.up
--actions.aoe+=/chain_harvest,if=buff.maelstrom_weapon.stack>=5
--actions.aoe+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
--actions.aoe+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
--actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack=10
--actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled
--actions.aoe+=/sundering
--actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6
--actions.aoe+=/stormstrike
--actions.aoe+=/lava_lash
--actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1
--actions.aoe+=/fae_transfusion
--actions.aoe+=/frost_shock
--actions.aoe+=/ice_strike
--actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack>=5
--actions.aoe+=/fire_nova,if=active_dot.flame_shock>1
--actions.aoe+=/earthen_spike
--actions.aoe+=/earth_elemental
--actions.aoe+=/windfury_totem,if=buff.windfury_totem.remains<30

--# Single target action priority list
--actions.single=primordial_wave,if=!buff.primordial_wave.up
--actions.single+=/windfury_totem,if=runeforge.doom_winds.equipped&buff.doom_winds_debuff.down
--actions.single+=/flame_shock,if=!ticking
--actions.single+=/vesper_totem
--actions.single+=/frost_shock,if=buff.hailstorm.up
--actions.single+=/earthen_spike
--actions.single+=/fae_transfusion
--actions.single+=/lightning_bolt,if=buff.stormkeeper.up
--actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
--actions.single+=/chain_harvest,if=buff.maelstrom_weapon.stack>=5
--actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack=10
--actions.single+=/lava_lash,if=buff.hot_hand.up|(runeforge.primal_lava_actuators.equipped&buff.primal_lava_actuators.stack>6)
--actions.single+=/stormstrike
--actions.single+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
--actions.single+=/lava_lash
--actions.single+=/crash_lightning
--actions.single+=/flame_shock,target_if=refreshable
--actions.single+=/frost_shock
--actions.single+=/ice_strike
--actions.single+=/sundering
--actions.single+=/fire_nova,if=active_dot.flame_shock
--actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5
--actions.single+=/earth_elemental
--actions.single+=/windfury_totem,if=buff.windfury_totem.remains<30
