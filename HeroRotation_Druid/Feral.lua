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


--- ============================ CONTENT ============================
--- ======= APL LOCALS =======
-- Commons
local Everyone = HR.Commons.Everyone
local Druid = HR.Commons.Druid

-- GUI Settings
local Settings = {
  General = HR.GUISettings.General,
  Commons = HR.GUISettings.APL.Druid.Commons,
  Feral = HR.GUISettings.APL.Druid.Feral
}

-- Spells
local S = Spell.Druid.Feral

-- Items
local I = Item.Druid.Feral
local TrinketsOnUseExcludes = {
  --  I.TrinketName:ID(),
}

-- Enemies

-- Stuns

-- Rotation Variables


--- ======= HELPERS =======


--- ======= ACTION LISTS =======
-- Put here action lists only if they are called multiple times in the APL
-- If it's only put one time, it's doing a closure call for nothing.


--- ======= MAIN =======
local function APL ()
  -- Rotation Variables Update

  -- Unit Update

  -- Defensives

  -- Out of Combat
  if not Player:AffectingCombat() then
    -- Flask
    -- Food
    -- Rune
    -- PrePot w/ Bossmod Countdown
    -- Opener
    if Everyone.TargetIsValid() then

    end
    return
  end

  -- In Combat
  if Everyone.TargetIsValid() then

    return
  end
end

local function OnInit ()
end

HR.SetAPL(000, APL, OnInit)


--- ======= SIMC =======
-- Last Update: 12/31/2999

-- APL goes here
--w # Executed before combat begins. Accepts non-harmful --actions only.
--actions.precombat=flask
--actions.precombat+=/food
--actions.precombat+=/augmentation
--# Snapshot raid buffed stats before combat begins and pre-potting is done.
--actions.precombat+=/snapshot_stats
--actions.precombat+=/flask
--actions.precombat+=/food
--actions.precombat+=/augmentation
--actions.precombat+=/variable,name=4cp_bite,value=0
--# Shred = 0, Non-snapshot Rake = 1, Snapshot Rake = 2, LI = 3, Swipe = 4
--actions.precombat+=/variable,name=filler,value=1
--actions.precombat+=/variable,name=filler,value=0,if=azerite.wild_fleshrending.enabled
--actions.precombat+=/variable,name=rip_ticks,value=7
--actions.precombat+=/variable,name=thrash_ticks,value=8
--actions.precombat+=/variable,name=thrash_ticks,value=0,if=azerite.wild_fleshrending.enabled
--actions.precombat+=/snapshot_stats
--actions.precombat+=/cat_form
--actions.precombat+=/prowl

--# Executed every time the actor is available.
--# Balance weaving investigation
--actions=cat_form,if=buff.cat_form.down
--# Prowl whenever possible
--actions+=/prowl
--actions+=/auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
--actions+=/variable,name=reaping_delay,value=target.time_to_die,if=variable.reaping_delay=0
--actions+=/cycling_variable,name=reaping_delay,op=min,value=target.time_to_die
--# One shot stealth
--actions+=/run_action_list,name=stealth,if=buff.shadowmeld.up|buff.prowl.up
--actions+=/call_action_list,name=cooldown
--actions+=/run_action_list,name=finisher,if=combo_points>=(5-variable.4cp_bite)
--# Multi-gcd stealth
--actions+=/run_action_list,name=stealth,if=buff.bs_inc.up|buff.sudden_ambush.up
--# The most expensive BT cycle (Thresh Shred Swipe cost 115 energy, make sure we can make that in 4 globals)
--actions+=/pool_resource,if=talent.bloodtalons.enabled&buff.bloodtalons.down&(energy+3.5*energy.regen+(40*buff.clearcasting.up))>=(115-23*buff.incarnation_king_of_the_jungle.up)&active_bt_triggers=0
--actions+=/run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&(buff.bloodtalons.down|active_bt_triggers=2)
--actions+=/rake,target_if=refreshable|persistent_multiplier>dot.rake.pmultiplier
--actions+=/feral_frenzy,if=combo_points=0
--actions+=/moonfire_cat,target_if=refreshable
--actions+=/thrash_cat,if=refreshable&druid.thrash_cat.ticks_gained_on_refresh>variable.thrash_ticks
--actions+=/brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))&(spell_targets.brutal_slash*action.brutal_slash.damage%action.brutal_slash.cost)>(action.shred.damage%action.shred.cost)
--actions+=/swipe_cat,if=spell_targets.swipe_cat>2
--actions+=/shred,if=buff.clearcasting.up
--actions+=/call_action_list,name=filler

--actions.bloodtalons=rake,target_if=(!ticking|(refreshable&persistent_multiplier>dot.rake.pmultiplier))&buff.bt_rake.down&druid.rake.ticks_gained_on_refresh>=2
--actions.bloodtalons+=/lunar_inspiration,target_if=refreshable&buff.bt_moonfire.down
--actions.bloodtalons+=/thrash_cat,target_if=refreshable&buff.bt_thrash.down&druid.thrash_cat.ticks_gained_on_refresh>8
--actions.bloodtalons+=/brutal_slash,if=buff.bt_brutal_slash.down
--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down&spell_targets.swipe_cat>1
--actions.bloodtalons+=/shred,if=buff.bt_shred.down
--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down
--actions.bloodtalons+=/thrash_cat,if=buff.bt_thrash.down

--actions.cooldown=berserk
--actions.cooldown+=/incarnation
--# Try and not waste TF energy, but also just use it for zerk and incarns
--actions.cooldown+=/tigers_fury,if=energy.deficit>55|(buff.bs_inc.up&buff.bs_inc.remains<13)
--# Might be wrong to use Smeld on Rake in very very niche situations, but very rarely
--actions.cooldown+=/shadowmeld,if=buff.tigers_fury.up&buff.bs_inc.down&combo_points<4&dot.rake.pmultiplier<1.6&energy>40
--actions.cooldown+=/berserking,if=buff.tigers_fury.up|buff.bs_inc.up
--actions.cooldown+=/potion,if=buff.bs_inc.up
--actions.cooldown+=/call_action_list,name=essence
--actions.cooldown+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|debuff.conductive_ink_debuff.up&target.time_to_pct_30<1.5|!debuff.conductive_ink_debuff.up&(debuff.razor_coral_debuff.stack>=25-10*debuff.blood_of_the_enemy.up|target.time_to_die<40)&buff.tigers_fury.remains>10
--actions.cooldown+=/use_items,if=buff.tigers_fury.up|target.time_to_die<20

--actions.essence=thorns,if=active_enemies>desired_targets|raid_event.adds.in>45
--actions.essence+=/the_unbound_force,if=buff.reckless_force.up|buff.tigers_fury.up
--actions.essence+=/memory_of_lucid_dreams,if=buff.berserk_cat.up|buff.incarnation_king_of_the_jungle.up
--actions.essence+=/blood_of_the_enemy,if=buff.tigers_fury.up&combo_points=5
--actions.essence+=/focused_azerite_beam,if=active_enemies>desired_targets|(raid_event.adds.in>90&energy.deficit>=50)
--actions.essence+=/purifying_blast,if=active_enemies>desired_targets|raid_event.adds.in>60
--actions.essence+=/guardian_of_azeroth,if=buff.tigers_fury.up
--actions.essence+=/concentrated_flame,if=buff.tigers_fury.up
--actions.essence+=/ripple_in_space,if=buff.tigers_fury.up
--actions.essence+=/worldvein_resonance,if=buff.tigers_fury.up
--actions.essence+=/reaping_flames,target_if=target.time_to_die<1.5|((target.health.pct>80|target.health.pct<=20)&variable.reaping_delay>29)|(target.time_to_pct_20>30&variable.reaping_delay>44)

--actions.filler=rake,target_if=variable.filler=1&dot.rake.pmultiplier<=persistent_multiplier
--actions.filler+=/rake,if=variable.filler=2
--actions.filler+=/lunar_inspiration,if=variable.filler=3
--actions.filler+=/swipe,if=variable.filler=4
--actions.filler+=/shred

--actions.finisher=savage_roar,if=buff.savage_roar.down|buff.savage_roar.remains<(combo_points*5+1)*0.3
--# Make sure to zero the variable so some old value don't end up lingering
--actions.finisher+=/variable,name=best_rip,value=0,if=talent.primal_wrath.enabled
--actions.finisher+=/cycling_variable,name=best_rip,op=max,value=druid.rip.ticks_gained_on_refresh,if=talent.primal_wrath.enabled
--actions.finisher+=/primal_wrath,if=druid.primal_wrath.ticks_gained_on_refresh>(variable.rip_ticks>?variable.best_rip)|spell_targets.primal_wrath>(3+1*talent.sabertooth.enabled)
--actions.finisher+=/rip,target_if=(!ticking|(remains+combo_points*talent.sabertooth.enabled)<duration*0.3|dot.rip.pmultiplier<persistent_multiplier)&druid.rip.ticks_gained_on_refresh>variable.rip_ticks
--actions.finisher+=/maim,if=buff.iron_jaws.up
--actions.finisher+=/ferocious_bite,max_energy=1,target_if=max:time_to_die

--# Rake needs roughly 50% of its length at a minimum to surpass shreds dpe
--actions.stealth=run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&buff.bloodtalons.down
--actions.stealth+=/rake,target_if=dot.rake.pmultiplier<1.6&druid.rake.ticks_gained_on_refresh>2
--actions.stealth+=/shred
