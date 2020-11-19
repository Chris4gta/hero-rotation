--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroLib
local HL = HeroLib
local Cache = HeroCache
local Unit = HL.Unit
local Player = Unit.Player
local Target = Unit.Target
local MouseOver = Unit.MouseOver
local Spell = HL.Spell
local Item = HL.Item
-- HeroRotation
local HR = HeroRotation
local Settings = HR.GUISettings.APL.Druid.Commons
local Everyone = HR.Commons.Everyone
-- Lua
-- File Locals
local Commons = {}

--- ======= GLOBALIZE =======
HR.Commons.Druid = Commons


--- ============================ CONTENT ============================
-- Spell
if not Spell.DemonHunter then Spell.DemonHunter = {} end
Spell.Druid.Feral = {
  -- Abilities
  FerociousBite = Spell(22568),
  Berserk = Spell(106951),
  Rake = Spell(1822),
  Rip = Spell(1079),
  Thrash = Spell(106830),
  TigersFury = Spell(5217),


  -- Defensive


  -- Talents
  SavageRoar = Spell(22568),
  Incarnation = Spell(102543),

  BrutalSlash = Spell(202028),
  PrimalWrath = Spell(285381),


  FeralFrenzy = Spell(274837),
  Bloodtalons = Spell(319439),

--[[
  FerociousBite = Spell(22568),
  FerociousBite = Spell(22568),
  FerociousBite = Spell(22568),
  FerociousBite = Spell(22568),
  FerociousBite = Spell(22568),
  FerociousBite = Spell(22568),]]

  -- Utility


  -- Covenant Abilities


  -- Legendary Effects


  -- Soulbind/Conduit Effects


  -- Trinket Effects


  -- Essences


  -- Other
}
