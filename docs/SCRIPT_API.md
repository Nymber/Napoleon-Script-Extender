# Napoleon: Total War - scripting API

Enumerated from `Napoleon.exe` by `tools/dump_script_api.rb`.
Every entry below is a real registration in the shipped binary - not a
guess, and not carried over from Empire.

## conditions - queries you may call from campaign script

308 entries.

| name | usage | what it does |
|---|---|---|
| `AdjacentRegionRebelling` | `AdjacentRegionRebelling()` | Are any of the regions adjacent to the region rebelling |
| `AdviceDisplayed` | `AdviceDisplayed("-1890476358")` | Has a piece of advice been seen since this game session started |
| `AdviceJustDisplayed` | `AdviceJustDisplayed("-1890476358")` | The name of the advisory issued or dismissed, as described in the key field of the advice level record |
| `AdviceThreadProgress` | `AdviceThreadProgress("0001_Battle_Advice_Friendly_Fire_thread")` | How much progress has been made through the named thread |
| `ArmyIsAlliedCampaign` | `ArmyIsAlliedCampaign()` | Does the army belong to a faction allied to the player faction |
| `ArmyIsLocalCampaign` | `ArmyIsLocalCampaign()` | Does the army belong to the player faction? |
| `BattleAllianceIsAttacker` | `BattleAllianceIsAttacker()` | Returns true if the alliance is the attacker from the campaign map |
| `BattleAllianceIsPlayers` | `BattleAllianceIsPlayers()` | Returns true if the alliance contains the players army |
| `BattleAllianceNumberOfShips` | `BattleAllianceNumberOfShips()` | Returns the number of ships in all the armies of the alliance |
| `BattleAllianceNumberOfUnits` | `BattleAllianceNumberOfUnits()` | Returns the number of units in all the armies of the alliance |
| `BattleCommanderIsGeneral` | `BattleCommanderIsGeneral()` | Returns true if the the alliance has a general and not just a colonel |
| `BattleEnemyAlliancePercentageCanHide` | `BattleEnemyAlliancePercentageCanHide()` | Checks the percentage of enemy units ( in alliance ) that can hide, returns a percentage |
| `BattleEnemyAlliancePercentageOfClassAndCategory` | `BattleEnemyAlliancePercentageOfClassAndCategory("class", "category")` | Takes in class and category of a particular unit and goes through every enemy army, returning the percentage of units that match the class and category |
| `BattleEnemyAlliancePercentageOfMountType` | `BattleEnemyAlliancePercentageOfMountType("mount_type")` | Determine the percentage of units in the enemies army that have the type of mount passed to the condition |
| `BattleEnemyAlliancePercentageOfSpecialAbility` | `BattleEnemyAlliancePercentageOfSpecialAbility("ability")` | Checks all of the Armies in the enemy alliances for the particular special ability |
| `BattleEnemyAlliancePercentageOfUnitCategory` | `BattleEnemyAlliancePercentageOfUnitCategory("category")` | Take in the name of the unit's category and returns the percentage of units in the alliance that match the given category |
| `BattleEnemyAlliancePercentageOfUnitClass` | `BattleEnemyAlliancePercentageOfUnitClass("class")` | Takes in the name of the unit's class and returns the percentage of units in the alliance that match the given class |
| `BattleEnemyDirectionOfMeleeAttack` | `BattleEnemyDirectionOfMeleeAttack("left_flank")` | Returns true if the passed parameter matches the direction of melee attack for the enemy unit |
| `BattleEnemyHasMissileSuperiority` | `BattleEnemyHasMissileSuperiority()` | Returns true if the combined missile streangth of the enemy is greater than the missile streangth of the player |
| `BattleEnemyShipActionStatus` | `BattleEnemyShipActionStatus` | Returns true if the action status of the enemy ship matches : dismasted, firing, hull_damaged, routing, sinking, wavering. |
| `BattleEnemyShipOnFire` | `BattleEnemyShipOnFire()` | Checks whether any of the enemies ships are on fire, returns true or false |
| `BattleEnemyUnitActionStatus` | `BattleEnemyUnitActionStatus("hiding")` | Returns true if the action status of the enemy unit matches : charging, exhausted, fighting_melee, firing, hiding, idling moving, moving_fast, pursue_routers, rallying, routing, wavering. |
| `BattleEnemyUnitCategory` | `BattleEnemyUnitCategory("category")` | Takes in a unit category string and returns true if there is an enemy and it matches the category of the enemy unit |
| `BattleEnemyUnitClass` | `BattleEnemyUnitClass("class")` | Takes in a unit class string and returns true if it matches the unit class of the enemy unit |
| `BattleEnemyUnitCurrentFormation` |  | Returns true if the unit has an enemy and the string matches the current formation employed by the enemy, otherwise it returns false |
| `BattleEnemyUnitOnLeftFlank` | `BattleEnemyUnitOnLeftFlank()` | Returns true if there's an enemy unit on the left flank |
| `BattleEnemyUnitOnRightFlank` | `BattleEnemyUnitOnRightFlank()` | Returns true if there's an enemy unit on the right flank |
| `BattleEnemyUnitSpecialAbilitySupported` | `BattlePlayerUnitSpecialAbilitySupported("ability")` | If there is an enemy unit then the condition checks all of the enemy unit's special abilities and returns true if the unit has the special ability |
| `BattleEnemyUnitTechnologySupported` | `BattleEnemyUnitTechnologySupported("ring_bayonets")` | Checks whether the unit has the technology passed in and returns true if the unit has the technology |
| `BattleHasCoverBuildings` | `BattleHasCoverBuildings()` | Returns true if it finds an occupiable building |
| `BattleHasCoverWalls` | `BattleHasCoverWalls()` | Returns true if the battlefield has walls that the men can take cover against |
| `BattleIsLandConflict` | `BattleIsLandConflict()` | Returns true if battle is being fought on land (this will NOT return true for fort battles) |
| `BattleIsNavalConflict` | `BattleIsNavalConflict()` | Returns true if battle is being fought on sea |
| `BattleIsSiegeConflict` | `BattleIsSiegeConflict()` | Returns true if there is a fort in the battle |
| `BattlePlayerAllianceDefendingHill` | `BattlePlayerAllianceDefendingHill()` | Returns true if a unit in the alliance is stationed on a hill |
| `BattlePlayerAlliancePercentageCanHide` | `BattlePlayerAlliancePercentageCanHide()` | Checks the percentage of player units ( in alliance ) that can hide, returns a percentage |
| `BattlePlayerAlliancePercentageGuerrillas` | `BattlePlayerAlliancePercentageGuerrillas` | Goes through the players alliance and searches for all the units that have guerrilla deployment |
| `BattlePlayerAlliancePercentageOfAmmoType` | `BattlePlayerAlliancePercentageOfAmmoType("bullet")` | Returns the percentage of units in the alliance that have the specified ammo type |
| `BattlePlayerAlliancePercentageOfClassAndCategory` | `BattlePlayerAlliancePercentageOfClassAndCategory("class", "category")` | Takes in Class and Category of a particular unit and goes through players army and returns the percentage that match the class and category |
| `BattlePlayerAlliancePercentageOfMountType` | `BattlePlayerPercentageOfMountType("mount_type")` | Determine the percentage of units in the players army that have the type of mount passed to the condition |
| `BattlePlayerAlliancePercentageOfSpecialAbility` | `BattlePlayerAlliancePercentageOfSpecialAbility("ability")` | Checks all of the Armies in the players alliance for the special ability |
| `BattlePlayerAlliancePercentageOfTechnology` | `BattlePlayerAlliancePercentageOfTechnology("ring_bayonets")` | Checks all of the Armies in the players alliance for the technology and returns the percentage of those that have it |
| `BattlePlayerAlliancePercentageOfUnitCategory` | `BattlePlayerAlliancePercentageOfUnitCategory("category")` | Goes through the players alliance and searches for all the units that fit the given category description |
| `BattlePlayerAlliancePercentageOfUnitClass` | `BattlePlayerAlliancePercentageOfUnitClass("class")` | Goes through the players alliance and searches for all the units that fit the given class description |
| `BattlePlayerAllianceToEnemyAllianceRatio` | `BattlePlayerAllianceToEnemyAllianceRatio() > 0.5 would mean that the players alliance has half as many men as the enemy's alliance` | Returns the ratio PlayersAlliance/EnemyAlliance in terms of men on the battlefield |
| `BattlePlayerDefendingFort` | `BattlePlayerDefendingFort()` | Returns true if player is still in control of the fort and is tasked to defend it. |
| `BattlePlayerDirectionOfMeleeAttack` | `BattlePlayerDirectionOfMeleeAttack("left_flank")` | Returns true if the passed parameter matches the direction of melee attack for the unit |
| `BattlePlayerDirectionOfMissileAttack` | `BattlePlayerDirectionOfMissileAttack("right_flank")` | Returns true if the passed parameter matches the direction of missile attack for the unit |
| `BattlePlayerSailsPercentageDamaged` | `BattlePlayerSailsPercentageDamaged()` | Returns the floating point value of percentage damaged in the range 0.0 to 100.0 |
| `BattlePlayerShipActionStatus` | `BattlePlayerShipActionStatus("hiding")` | Returns true if the action status of the ship : dismasted, firing, hull_damaged, routing, sinking, wavering. |
| `BattlePlayerShipClass` | `BattlePlayerShipClass("class")` | Takes in a ship class and returns true if it matches the ship class of the ship |
| `BattlePlayerUnitActionStatus` | `BattlePlayerUnitActionStatus("hiding")` | Returns true if the action status of the unit matches UNIT: charging, exhausted, fighting_melee, firing, hiding, idling moving, moving_fast, pursue_routers, rallying, routing, wavering. |
| `BattlePlayerUnitAmmoType` | `BattlePlayerUnitAmmoType("bullet")` | Returns true if the unit has the ammo type |
| `BattlePlayerUnitCategory` | `BattlePlayerUnitCategory("category")` | Takes in a unit category string and returns true if it matches the unit category of the unit |
| `BattlePlayerUnitClass` | `BattlePlayerUnitClass("class")` | Takes in a unit class string and returns true if it matches the unit class of the unit |
| `BattlePlayerUnitCurrentFormation` | `BattlePlayerUnitCurrentFormation( "pike_square_formation" )` | Returns true if the string matches the current formation employed, otherwise it returns false |
| `BattlePlayerUnitDefendingHill` | `BattlePlayerUnitDefendingHill()` | Returns true if a unit is stationed on a hill |
| `BattlePlayerUnitEngaged` | `BattlePlayerUnitEngaged()` | Returns true if a unit is either in a firefight or melee |
| `BattlePlayerUnitEngagedInMelee` | `BattlePlayerUnitEngagedInMelee()` | Returns true if a unit is in a melee fight |
| `BattlePlayerUnitMountType` | `BattlePlayerUnitMountClass("mount_type")` | Determines whether the unit is mounted on the type of mount passed to the condition |
| `BattlePlayerUnitMovingFast` | `BattlePlayerUnitMovingFast()` | Returns true if the unit is moving fast, otherwise false |
| `BattlePlayerUnitSpecialAbilityActive` | `BattlePlayerUnitSpecialAbilityActive()` | Checks whether the specified unit ability is active |
| `BattlePlayerUnitSpecialAbilitySupported` | `BattlePlayerUnitSpecialAbilitySupported("ability")` | Checks all of the units special abilities and returns true if the unit has ability |
| `BattlePlayerUnitTechnologySupported` | `BattlePlayerUnitTechnologySupported("ring_bayonets")` | Checks whether the unit has the technology passed in and returns true if the unit has the technology |
| `BattleResult` | `BattleResult("decisive_victory")` | Returns true if the battle result matches the one supplied |
| `BattleShipIsPlayers` | `BattleShipIsPlayers` | Returns true if the unit is part of the players army |
| `BattleShipSailsPercentageDamage` | `BattlePlayerShipSailsPercentageDamage()` | Returns the percentile of damage the sails have recieved in the range 0.0 to 100.0 |
| `BattleTimeLimitSet` | `BattleTimeLimitSet()` | Returns true if there's an alliance in a the battle that will win on a timeout |
| `BattleType` | `BattleType("normal")` | Returns true if the battle type matches the one supplied |
| `BattleUnitIsAllied` | `BattleUnitIsAllied()` | Returns true if the unit is part of the players alliance |
| `BattleUnitIsPlayers` | `BattleUnitIsPlayers()` | Returns true if the unit is part of the players army |
| `BattlesFought` | `BattlesFought()` | How many battles has this character fought in? |
| `BuildingLevelName` | `BuildingLevelName(corn_peasant_farms)` | Flags whether or not the context contains the supplied building level record |
| `BuildingTypeExistsAtSettlement` | `BuildingTypeExistsAtSettlement("barracks")` | Tests if a building of the specified type exists in the region settlement |
| `BuildingTypeExistsAtSlot` | `BuildingTypeExistsAtSlot("barracks")` | Tests if a building of the specified type exists in the region slot |
| `CampaignBattleType` | `CampaignBattleType("normal")` | Returns true if the battle type matches the one supplied |
| `CampaignName` | `CampaignName('main')` | Returns whether or not the current campaign name matches the supplied parameter |
| `CampaignPercentageOfOwnCaptured` | `CampaignPercentageOfOwnCaptured()` | Percentage of own men/ships captured in the battle that just took place |
| `CampaignPercentageOfOwnKilled` | `CampaignPercentageOfOwnKilled()` | Percentage of own men/ships killed in the battle that just took place |
| `CampaignPercentageOfOwnRouted` | `CampaignPercentageOfOwnRouted()` | Percentage of own men/ships that routed in the battle that just took place |
| `CampaignPercentageOfThemCaptured` | `CampaignPercentageOfThemCaptured()` | Percentage of opposing men/ships captured in the battle that just took place |
| `CampaignPercentageOfThemKilled` | `CampaignPercentageOfThemKilled()` | Percentage of opposing men/ships killed in the battle that just took place |
| `CampaignPercentageOfThemRouted` | `CampaignPercentageOfThemRouted()` | Percentage of opposing men/ships that routed in the battle that just took place |
| `CampaignPercentageOfUnitCategory` | `CampaignPercentageOfUnitCategory("naval_frigate")` | Percentage of type of ships/units under an admirals/generals command |
| `CanGenerateHistoricalCharacter` | `CanGenerateHistoricalCharacter("abraham_de_moivre")` |  |
| `CharacterAbility` | `CharacterAbility("can_assassinate")` | Returns whether a character can perform the ability specified |
| `CharacterArmyCouldReplenishFromBattle` | `CharacterArmyCouldReplenishFromBattle()` | Test to see if an army involved in the current pending battle and belonging to the player can replenish |
| `CharacterArmyUsedCoverBuildings` | `CharacterArmyUsedCoverBuildings()` | Did the characters army use buildings for conver? |
| `CharacterArmyUsedCoverWalls` | `CharacterArmyUsedCoverWalls()` | Did the characters army use walls for cover? |
| `CharacterAttribute` | `CharacterAttribute("command_land") >= 2` | Returns the value of the attribute specified.  This doesn't account for any given situation bonuses |
| `CharacterBattleWallsBreached` | `CharacterBattleWallsBreached()` | Did the characters army breach the walls of a fort? |
| `CharacterBuildingConstructed` | `CharacterBuildingConstructed("vineyards")` | Did this building type just get constructed? |
| `CharacterCapturedEnemyShip` | `CharacterCapturedEnemyShip()` | Did the given character capture an enemy ship? |
| `CharacterCultureType` | `CharacterCultureType("tribal")` | Returns true if the character context is of the culture specified |
| `CharacterDuelWeapon` | `CharacterDuelWeapon("duelling_pistols")` | Did the given character use the given weapon in the duel? |
| `CharacterDuelsFought` | `CharacterDuelsFought()` | Number of duels a character has fought. Character context |
| `CharacterDuelsLost` | `CharacterDuelsLost()` | Number of duels a character has lost. Character context |
| `CharacterDuelsWon` | `CharacterDuelsWon()` | Number of duels a character has won. Character context |
| `CharacterEndedInAmbushPosition` | `CharacterEndedInAmbushPosition()` | Returns true if the character is in an ambush position, as used in conjunction with out of mp this has just happened |
| `CharacterFactionAdmiralCount` | `CharacterFactionAdmiralCount()` | How many admirals does this characters faction have? |
| `CharacterFactionGeneralCount` | `CharacterFactionGeneralCount()` | How many generals does this characters faction have? |
| `CharacterFactionHasTechType` | `CharacterFactionHasTechType("enlightenment_abolition_of_slavery")` | Does the characters faction have the specified technology |
| `CharacterFactionMinisterAncillary` | `CharacterFactionMinisterAncillary("Ancillary_Boxer")` | Tests whether any minister in the characters faction has the specified ancillary |
| `CharacterFactionMinisterTrait` | `CharacterFactionMinisterTrait("drunkard")` | Tests whether any minister in the characters faction has the named trait |
| `CharacterFactionName` | `CharacterFactionName("britain")` | Is characters faction the one specified? |
| `CharacterFactionSubcultureType` | `CharacterFactionSubcultureType("sc_indian_islamic")` | Is the character part of the given subculture? |
| `CharacterForename` | `CharacterForename("names_name_names_irishAlan")` | Does the character have this forename? |
| `CharacterFoughtCulture` | `CharacterFoughtCulture("tribal")` | Has this character just fought this culture? |
| `CharacterHasAncillary` | `CharacterHasAncillary("Ancillary_Boxer")` | Tests whether the character has the specified ancillary |
| `CharacterHasTrait` | `CharacterHasTrait("drunkard")` | Does this character have the given trait? |
| `CharacterHoldsPost` | `CharacterHoldsPost()` | Is this character a minister with a post? |
| `CharacterInBuildingOfChain` | `CharacterInBuildingOfChain("tobacco")` | Is the character in a building of this chain type? |
| `CharacterInBuildingType` | `CharacterInBuildingType("naval_college")` | Is the character in a building of this type? |
| `CharacterInEnemyLands` | `CharacterInEnemyLands()` | Is the character in enemy lands? |
| `CharacterInHomeRegion` | `CharacterInHomeRegion()` | Is the character in their home region? |
| `CharacterInOwnFactionLands` | `CharacterInOwnFactionLands()` | Is the character in their own factions lands? |
| `CharacterInRegion` | `CharacterInRegion("england")` | Is the character in the given region? |
| `CharacterInTheatre` | `CharacterInTheatre("-1133129049")` | Is the character in the specified theatre |
| `CharacterIsAlliedCampaign` | `CharacterIsAllied()` | The character is allied to the local faction? |
| `CharacterIsEnemyCampaign` | `CharacterIsEnemy()` | The character is an enemy of the local faction? |
| `CharacterIsLocalCampaign` | `CharacterIsLocalCampaign()` | Does the character belong to the player faction? |
| `CharacterMPPercentageRemaining` | `CharacterMPPercentageRemaining() < 50` | Returns the percentage of movement points remaining as in integer value |
| `CharacterMinisterialPosition` | `CharacterMinisterialPosition("governor_europe")` | Does the character hold the specified ministerial position? |
| `CharacterNumberOfChildren` | `CharacterNumberOfChildren()` | How many children does this character have? |
| `CharacterRallied` | `CharacterRallied()` | Did the general rally at least one unit? |
| `CharacterRouted` | `CharacterRouted()` | Has the character routed? in the last battle? |
| `CharacterRunsSpyNetwork` | `CharacterRunsSpyNetwork()` | Test to see if the character runs a spy network |
| `CharacterStationaryForOneTurn` | `CharacterStationaryForOneTurn()` | Was the character stationary last turn (or longer) |
| `CharacterSurname` | `CharacterSurname("names_name_names_irishBlair")` | Does the character have this surname? |
| `CharacterTrait` | `CharacterTrait("drunkard") > 2` | Returns the value of the specified trait (0 if not present) |
| `CharacterTurnsAtHome` | `CharacterTurnsAtHome()` | Returns the number of turns in home regions exclusively |
| `CharacterTurnsAtSea` | `CharacterTurnsAtSea()` | Returns the number of turns at sea exclusively |
| `CharacterTurnsInEnemyLands` | `CharacterTurnsInEnemyLands()` | Returns the number of turns in enemy regions exclusively |
| `CharacterType` | `CharacterType("spy")` | Returns true if the character context is of the agent type specified |
| `CharacterWasAttacker` | `CharacterWasAttacker()` | Was the character the attacker in the last battle? |
| `CharacterWithdrewFromBattle` | `CharacterWithdrewFromBattle()` | Did the characters army withdraw from battle? |
| `CharacterWonBattle` | `CharacterWonBattle()` | Is the character part of the winning alliance in a battle |
| `CharacterWonDuel` | `CharacterWonDuel()` | Did the given character win the Duel? |
| `CharactersUnitRallied` | `CharactersUnitRallied()` | Did the generals unit rally? |
| `CommanderAncillary` | `CommanderAncillary("Ancillary_Boxer")` | Returns whether the commander has the specified ancillary |
| `CommanderFoughtInBattle` | `CommanderFoughtInBattle()` | Did the characters unit fight in the battle? (melee or missile) |
| `CommanderFoughtInMelee` | `CommanderFoughtInMelee()` | Did the characters unit engage in melee in the battle? |
| `CommanderTrait` | `CommanderTrait("C_General_Mad") > 2` | Returns the value of the specified trait (0 if not present) |
| `DateAndWeekInRange` | `DateAndWeekInRange(0, 1066, 47, 2001)` | Test to see if the current calendar year and week in year is within the years and weeks specified.  Week should be 0 <= week < 48.  start <= current <= end |
| `DateInRange` | `DateInRange(1066, 2001)` | Test to see if the current calendar year is within the years specified.  start <= current <= end |
| `DefensiveSiegesFought` | `DefensiveSiegesFought()` | Returns the number of siege defences a general has attempted |
| `DefensiveSiegesWon` | `DefensiveSiegesWon()` | Returns the number of siege defences a general has won |
| `DifficultyLevel` | `DifficultyLevel()` | What is the local faction's difficulty level? |
| `EnemyArmyGreaterCombatStrength` | `EnemyArmyGreaterCombatStrength()` | Is the enemies army stronger than ours? |
| `FactionAllyCount` | `FactionAllyCount() > 2` | Returns the number of allies the characters faction has |
| `FactionBuildingExists` | `FactionBuildingExists("britain", "admiralty")` | Does the specified faction have at least one of the specified building |
| `FactionCanBuildBuilding` | `FactionCanBuildBuilding("admiralty")` | Can the faction build the specified building at this point |
| `FactionCashFlow` | `FactionCashFlow() > 10` | Returns the percentage surplus/loss of the factions regular income and expenditure |
| `FactionDestroyedByCharacterFaction` | `FactionDestroyedByCharacterFaction()` | Did this characters faction destroy another faction this turn? |
| `FactionExists` | `FactionExists("britain")` | Does the given faction exist? |
| `FactionGovernmentType` | `FactionGovernmentType("gov_republic")` | Is the faction's government type equal to the passed government type |
| `FactionHasAllies` | `FactionHasAllies()` | Returns whether or not the characters faction has any allies |
| `FactionHasTradeShipNotInTradeNode` | `FactionHasTradeShipNotInTradeNode()` | Does the faction in context have a trade ship that is not in a trade node. Requires faction context |
| `FactionIsAlliedCampaign` | `FactionIsAlliedCampaign()` | Is the faction allied to the player faction? |
| `FactionIsEnemyCampaign` | `FactionIsEnemy("france")` | Is the specified faction at war with the player faction? |
| `FactionIsHuman` | `FactionIsHuman()` | Is the faction human? |
| `FactionIsLocal` | `FactionIsLocal()` | Is the faction the local faction? |
| `FactionLeadersAttribute` | `FactionLeadersAttribute("management")` | Gets the level of the faction leaders attribute specified as a parameter |
| `FactionLeadersTrait` | `FactionLeadersTrait("drunkard") > 2` | Returns the value of the specified trait for the characters faction leader (0 if not present) |
| `FactionName` | `FactionName("britain")` | Is the faction the one specified? |
| `FactionParticipatedInBattle` | `FactionParticipatedInBattle("ita_french_republic")` | Did the specified faction participate in the battle? |
| `FactionPatrioticFervour` | `FactionPatrioticFervour()` | Does this faction have patriotic fervour? |
| `FactionSupportCostsPercentage` | `FactionSupportCostsPercentage()` | What percentage of the factions expenditure is spent on army upkeep |
| `FactionTaxLevel` | `FactionTaxLevel("lower_classes") < TaxLevel("extortionate")` | Returns the average tax level for the faction |
| `FactionTechExists` | `FactionTechExists("britain", "enlightenment_abolition_of_slavery")` | Does the specified faction have the specified technology |
| `FactionTradeCommodityExists` | `FactionTradeCommodityExists("res_gold")` | Returns whether the faction has access to the trade resource |
| `FactionTradeValue` | `FactionTradeValue() > 1000` | Returns the absolute value of the factions global trade |
| `FactionTradeValuePercentage` | `FactionTradeValuePercentage() > 25` | Returns the percentage value of global trade owned by the faction |
| `FactionTreasury` | `FactionTreasury() > 100` | Returns the factions treasury value |
| `FactionTreasuryWorldPercentage` | `FactionTreasuryWorldPercentage() > 10` | Returns the characters factions treasury value as a percentage of the sum of all factions treasury values |
| `FactionWarWeariness` | `FactionWarWeariness()` | Does this faction have war weariness? |
| `FactionwideAncillaryTypeExists` | `FactionwideAncillaryTypeExists("unkillable_cat") == true` | Returns whether the named ancillary exists in the faction somewhere |
| `FortBuildingQueueIdleDespiteCash` | `FortBuildingQueueIdleDespiteCash()` | Is the fort's building queue empty even though the faction can afford to build the cheapest building? |
| `FortIsLocal` | `FortIsLocal()` | Does the fort belong to the player faction? |
| `FortName` | `FortName("Fort Duquesne")` | Returns if the passed fort name is equal to the fort's name |
| `GovernorTaxLevel` | `GovernorTaxLevel("upper") >= 90` | If the character is the governor returns the tax level set for the specified active class of that governorship.  Returns -1 if not. |
| `GovernorshipEquals` | `GovernorshipEquals("europe")` | Does the context's governorship key match the parameter |
| `GovernorshipTaxLevel` | `GovernorshipTaxLevel("europe")` | Returns the governorships tax level |
| `HasUnspecialisedPort` | `HasUnspecialisedPort()` | Does the region have a port with no building? |
| `InPort` | `InPort()` | Is the character in a port? |
| `InSettlement` | `InSettlement()` | Checks that a character is in a settlement |
| `InsurrectionCrushed` | `InsurrectionCrushed()` | Has the characters faction put down a rebellion in this turn (or the turn that is just ending) |
| `IsBesieging` | `IsBesieging()` | Is the character besieging? |
| `IsBlockading` | `IsBlockading()` | Is the character blockading? |
| `IsBuildingInChain` | `IsBuildingInChain("army-admin")` | Is garrison residence's building (all slots, road and fortifications for settlements) in the building chain specified by the parameter? |
| `IsBuildingOfType` | `IsBuildingOfType("admiralty")` | Is garrison residence's building type (all slots, road and fortifications for settlements) equal to the parameter? |
| `IsCarryingTroops` | `IsCarryingTroops()` | Is the character transporting an army? |
| `IsChildOf` | `IsChildOf("tax_slider")` | Returns true if the components parent, (or parent's parent, or parent's parent's parent etc) has the id specified  |
| `IsColony` | `IsColony()` | Is the region a colony |
| `IsComponentType` | `IsComponentType("government_screens")` | Returns true if the event was fired by the component named |
| `IsFactionBesiegingSettlement` | `IsFactionBesiegingSettlement("settlement:region:settlement_id")` | Is the context faction besieging the specified settlement? Intended for use with faction start of turn event. |
| `IsFactionLeader` | `IsFactionLeader()` | Is this character the faction leader? |
| `IsFactionLeaderFemale` | `IsFactionLeaderFemale()` | Is this character the faction leader and are they female? (Queen) |
| `IsGarrisoned` | `IsGarrisoned()` | Is garrison residence garrisoned? |
| `IsGuerrillaGeneral` | `IsGuerrillaGeneral()` | Tests whether the character is a guerilla general |
| `IsHomeRegion` | `IsHomeRegion()` | Is this region the home region of the owning faction |
| `IsMessageType` | `IsMessageType("unit_routs_in_battle")` | Returns true if the event that triggered the condition check was for the message named |
| `IsMultiplayer` | `IsMultiplayer()` | Returns true when in multiplayer campaign |
| `IsPlayerTurn` | `IsPlayerTurn()` | Is this the players turn? |
| `IsPortGarrisoned` | `IsPortGarrisoned()` | Is the port garrisoned by a navy? |
| `IsTheatreGovernor` | `IsTheatreGovernor()` | Returns whether the character is a governor |
| `IsTriggerableHistoricalEvent` | `IsTriggerableHistoricalEvent("3_colour_printing")` |  |
| `IsUnderBlockade` | `IsUnderBlockade()` | Is the character under blockade? |
| `IsUnderSiege` | `IsUnderSiege()` | Is the character under siege? |
| `LandTradeRouteRaided` | `LandTradeRouteRaided()` | Was one of this factions land trade routes has been raided i9n the last round? |
| `LosingMoney` | `LosingMoney()` | Returns whether or not the factions regular expenditure exceeds their regular income |
| `MapPosition` | `MapPosition(x, y)` | check to see if a map location matches the one return by the context |
| `MissionName` | `MissionName(Build_farm_ep1)` | Compare the custom identifier of the mission to the parameter |
| `NoActionThisTurn` | `NoActionThisTurn()` | Has an action occured this turn for this character? |
| `OffensiveSiegesFought` | `OffensiveSiegesFought()` | Returns the number of siege offences a general has attempted |
| `OffensiveSiegesWon` | `OffensiveSiegesWon()` | Returns the number of siege offences a general has won |
| `OnAWarFooting` | `OnAWarFooting()` | Returns whether or not the characters faction is at war with anyone |
| `ParentId` | `ParentId("tax_slider")` | Returns true if the name of the Components parent matches the id specified |
| `PercentageUnspentIncome` | `PercentageUnspentIncome()` | What percentage of the characters factions income remains unspent? |
| `PlayerFactionIsAttacker` | `PlayerFactionIsAttacker()` | Is the attackers faction the local faction? |
| `PortBlockaded` | `PortBlockaded()` | Is the port blockaded, and did it start in the last round? |
| `PortBlockadedLocal` | `PortBlockadedLocal()` | Is the port blockaded by the local faction, and did it start in the last round? |
| `RandomPercentCampaign` | `RandomPercentCampaign(50)` | Returns whether the parameter value is less than the random number |
| `RegionBuildableSlotEmpty` | `RegionBuildableSlotEmpty()` | Has the slot not been developed? |
| `RegionBuildingFinished` | `RegionBuildingFinished()` | Gets the key of the last building constructed in the region |
| `RegionClamoursReform` | `RegionClamoursReform()` | Is the population in this region clamouring for reform |
| `RegionCultureIsFactionCulture` | `RegionCultureIsFactionCulture()` | Is the region's originating culture the same as the owning factions culture |
| `RegionDemands` | `RegionDemands()` | Is the population in this region writing letters of demand |
| `RegionEconomicGrowthLow` | `RegionEconomicGrowthLow()` | Is this regions economic growth low? |
| `RegionFoodShortageEmigration` | `RegionFoodShortageEmigration()` | Are people in this region emigrating due to a shortage of food? |
| `RegionGovernorAttribute` | `RegionGovernorAttribute("management")` | Gets the level of the regions governers attribute specified as a parameter |
| `RegionHasFoodShortages` | `RegionHasFoodShortages()` | Does the region have food shortages |
| `RegionHasUnexportedTrade` | `RegionHasUnexportedTrade()` | Is the region producing more than it is exporting? |
| `RegionIsLocal` | `RegionIsLocal()` | Does the region belong to the player faction? |
| `RegionIsRebelling` | `RegionIsRebelling("ita_alpes_maritimes")` | Is the specified region rebelling. Requires faction context. |
| `RegionPopulationGrowthLow` | `RegionPopulationGrowthLow()` | Is this regions population growth low? |
| `RegionPopulationLow` | `RegionPopulationLow()` | Tests if the population of a region is has dropped below the previous town spawn threshold e.g. region has 5 towns but has dropped below the population requirement for 4 towns |
| `RegionPopulationMaxReached` | `RegionPopulationMaxReached()` | Tests if the population of a region the maximum population |
| `RegionRebels` | `RegionRebels()` | Is the region rebelling |
| `RegionReligionIsStateReligion` | `RegionReligionIsStateReligion()` | Is the region's religion the same as the owning factions religion |
| `RegionReligiousEmigration` | `RegionReligiousEmigration()` | Are people in this region emigrating due to religious intolerance? |
| `RegionResourceExists` | `RegionResourceExists("res_gold")` | Returns whether the resource exists in the region |
| `RegionResourceExploited` | `RegionResourceExploited("res_gold")` | Returns whether the resource is produced in the region |
| `RegionRiots` | `RegionRiots()` | Is the population in this region rioting |
| `RegionSlotBuildingCount` | `RegionSlotBuildingCount()` | Counts the number of buildings in the region slots in the region |
| `RegionSlotBuildingCultureExists` | `RegionSlotBuildingCultureExists("european")` | Tests if the region has a building from the given culture |
| `RegionSlotBuildingTypeCount` | `RegionSlotBuildingTypeCount("barracks")` | Counts the number of buildings in the region slots in the region of the specified type |
| `RegionSlotBuildingTypeExists` | `RegionSlotBuildingTypeExists("barracks")` | Tests if a building of the specified type exists in the region |
| `RegionSlotCount` | `RegionSlotCount()` | Counts the number of slots in a region including settlement slots |
| `RegionSlotEmptyCount` | `RegionSlotEmptyCount()` | Counts the number of empty (no building) slots in a region including settlement slots |
| `RegionSlotTypeExists` | `RegionSlotTypeExists("fish")` | Tests to see if the region has a slot (in any status) whose type matches the parameter |
| `RegionTaxExempt` | `RegionTaxExempt()` | Gets whether the region is tax exempt or not |
| `RegionTaxLevel` | `RegionTaxLevel("lower_classes")` | Returns whether the regions tax level |
| `RegionTaxTownWealthGrowthReduction` | `RegionTaxTownWealthGrowthReduction() > 1` | Returns the percentage of the regions town wealth growth lost due to taxes |
| `RegionTownWealthGrowth` | `RegionTownWealthGrowth() > 50` | Returns the town wealth growth of the region |
| `RegionWealthDecrease` | `RegionWealthDecrease()` | How much has the regions wealth decreased? |
| `RegionWealthIncrease` | `RegionWealthIncrease()` | How much has the regions wealth increased? |
| `ResearchCategory` | `ResearchCategory("enlightenment")` | Is the research just completed of this category? |
| `ResearchQueueIdle` | `ResearchQueueIdle()` | Is faction not researching any tech evn though they could be |
| `ResearchType` | `ResearchType("military_navy_flintlock_cannon")` | Is the technology just researched of this type? |
| `ResearchTypeUniqueToFaction` | `ResearchTypeUniqueToFaction()` | Are we the first faction to research this technology type? |
| `RoadsAtMaxLevel` | `RoadsAtMaxLevel()` | Are the regions roads at the maximum level (and thus impossible to upgrade)? |
| `SeaTradeRouteRaided` | `SeaTradeRouteRaided()` | Was one of this factions sea trade routes has been raided i9n the last round? |
| `SettlementBuildingQueueIdleDespiteCash` | `SettlementBuildingQueueIdleDespiteCash()` | Is the settlement's building queue empty even though the faction can afford to build the cheapest building in any of its slot? |
| `SettlementFortificationsBuildingQueueIdleDespiteCash` | `SettlementFortificationsBuildingQueueIdleDespiteCash()` | Is the settlements's fortification building queue empty even though the faction can afford to build the cheapest building? |
| `SettlementIsLocal` | `SettlementIsLocal()` | Does the settlement belong to the player faction? |
| `SettlementName` | `SettlementName("settlement:acadia:fort_nashwaak")` | Is the settlement's unique id equal to the parameter? |
| `SettlementOwnedBy` | `SettlementOwnedBy("france")` | Does the specified faction own the settlement in context |
| `SettlementRoadBuildingQueueIdleDespiteCash` | `SettlementRoadBuildingQueueIdleDespiteCash()` | Is the settlements's road building queue empty even though the faction can afford to build the cheapest building? |
| `SlotBuildingQueueIdleDespiteCash` | `SlotBuildingQueueIdleDespiteCash()` | Is the slot's building queue empty even though the faction can afford to build the cheapest building? |
| `SlotIsAlliedCampaign` | `SlotIsAlliedCampaign()` | Does the slot belong to a faction allied to the player faction? |
| `SlotIsLocal` | `SlotIsLocal()` | Does the slot belong to the player faction? |
| `SlotName` | `SlotName("port:england:portsmouth")` | Returns if the passed slot name is equal to the slot's name |
| `SlotType` | `SlotType("wheat")` | Is the slot's type from the slots table equal to the parameter? |
| `SupportCostsPercentage` | `SupportCostsPercentage()` | The percentage of outgoings used for upkeep in the recent turns for the given faction |
| `TargetArmyGreaterCombatStrength` | `TargetArmyGreaterCombatStrength()` | The does the target army have greater combat strength than the character? |
| `TargetCharacterIsAlliedCampaign` | `TargetCharacterIsAlliedCampaign()` | The target character is allied to the character? |
| `TargetCharacterIsEnemyCampaign` | `TargetCharacterIsEnemyCampaign()` | The target character is an enemy of the character? |
| `TargetInStrikingRangeOfEnemy` | `CharacterIsEnemy()` | The character is an enemy of the local faction? |
| `TaxCollectionLimited` | `TaxCollectionLimited()` | Are all the factions government building at the maximum level (and thus impossible to upgrade)? |
| `TaxLevel` | `FactionTaxLevel() < TaxLevel("extortionate")` | Returns the tax level for the given tax key |
| `TradeNodeAvailableWorldwide` | `TradeNodeAvailableWorldwide()` | Is there an unoccupied trade node (worldwide). Requires faction context |
| `TradePortsAtMaxLevel` | `TradePortsAtMaxLevel()` | Are all of the regions trade ports at the maximum level (and thus impossible to upgrade)? |
| `TradeRouteIsEnemy` | `TradeRouteIsEnemy()` | Returns whether the trade route attacked is used by an enemy of the local faction |
| `TradeRouteIsLocal` | `TradeRouteIsLocal()` | Returns whether the trade route attacked is used by the local faction |
| `TradeRouteLimitReached` | `TradeRouteLimitReached()` | Has the faction reached its limit of trade routes? |
| `TurnNumber` | `TurnNumber()` | Returns the number of the turn currently being taken, starting at 1 |
| `TurnsSinceThreadLastAdvanced` | `TurnsSinceThreadLastAdvanced("0001_Battle_Advice_Friendly_Fire_Thread")` | The number of turns since the advice thread was last advanced - 0 signifies that the thread is unadvanced or the number of turns cannot be established |
| `UnitCategory` | `UnitCategory("naval_frigate")` | Is the unit of this category type? |
| `UnitClass` | `UnitClass("cavalry_missile")` | Is the unit of this class? |
| `UnitCrushedInsurrection` | `UnitCrushedInsurrection()` | Did the given unit crush an insurrection in the last turn? |
| `UnitCultureType` | `UnitCultureType("tribal")` | Is the unit of this culture type? |
| `UnitFoughtInBattle` | `UnitFoughtInBattle()` | Did the unit fight in the last battle? |
| `UnitFoughtInMelee` | `UnitFoughtInMelee()` | Did the unit melee fight in the last battle? |
| `UnitInTheatre` | `UnitInTheatre("-1133129049")` | Is this unit within the specified theatre? |
| `UnitOnContinent` | `UnitOnContinent("cont_africa_south")` | Is the given unit on the specified continent? |
| `UnitRouted` | `UnitRouted()` | Did the given unit rout? |
| `UnitSufferedCasualties` | `UnitSufferedCasualties()` | What percentage of casualties did this unit suffer? |
| `UnitTrait` | `UnitTrait("U_Infected_Dysentry") > 2` | Returns the value of the specified trait (0 if not present) |
| `UnitType` | `UnitType("euro_line_infantry")` | Is the unit's unit record key equal to the parameter? |
| `UnitWonBattle` | `UnitWonBattle()` | Is the unit part of the winning alliance in a battle? |
| `UnusedInternationalTradeRoute` | `UnusedInternationalTradeRoute()` | Could the faction establish a new international trade route? |
| `WarEndedCharacterFaction` | `WarEndedCharacterFaction()` | Was peace declared between this faction and another faction this turn? |
| `WarStartedCharacterFaction` | `WarStartedCharacterFaction()` | Did a war start between this faction and another faction this turn? |
| `WorldResourceExists` | `WorldResourceExists("res_gold")` | Returns whether the resource exists anywhere |
| `WorldResourceExploited` | `WorldResourceExploited("res_gold")` | Returns whether the resource is produced by any faction |
| `WorldwideAncillaryTypeExists` | `WorldwideAncillaryTypeExists("unkillable_cat") == true` | Returns whether the named ancillary exists in the world somewhere |
| `WouldRebellionInRegionBeRevolution` | `WouldRebellionBeRevolutionInRegion()` | Would a rebellion here be revolution? |

### Parameters

**`AdjacentRegionRebelling`** &mdash; `0x0089A840` (CA: Ed)

- none

**`AdviceDisplayed`** &mdash; `0x00E0CC30` (CA: Guy)

- Key from advice_levels table

**`AdviceJustDisplayed`** &mdash; `0x00E0CCD0` (CA: Guy)

- None

**`AdviceThreadProgress`** &mdash; `0x00E0CD80` (CA: Guy)

- Key from advice_threads table

**`ArmyIsAlliedCampaign`** &mdash; `0x0089A900` (CA: Ed)

- none

**`ArmyIsLocalCampaign`** &mdash; `0x0089A990` (CA: Ed)

- none

**`BattleAllianceIsAttacker`** &mdash; `0x0052A280` (CA: Ingimar)

- No parameters needed

**`BattleAllianceIsPlayers`** &mdash; `0x0052A350` (CA: Ingimar)

- No parameters needed

**`BattleAllianceNumberOfShips`** &mdash; `0x0052A400` (CA: Ingimar)

- No parameters needed

**`BattleAllianceNumberOfUnits`** &mdash; `0x0052A470` (CA: Ingimar)

- No parameters needed

**`BattleCommanderIsGeneral`** &mdash; `0x0052A4E0` (CA: Ingimar)

- No parameters needed

**`BattleEnemyAlliancePercentageCanHide`** &mdash; `0x0052A5D0` (CA: Ingimar)

- No parameters needed

**`BattleEnemyAlliancePercentageOfClassAndCategory`** &mdash; `0x0052A6D0` (CA: Ingimar)

- Two lowercase strings, first being the particular class string ( see unit_stats_land table ) and second being the category string ( see units table )

**`BattleEnemyAlliancePercentageOfMountType`** &mdash; `0x0052A8B0` (CA: Ingimar)

- A lowercase string with the unit's mount type to be checked ( see type in battle_entities table )

**`BattleEnemyAlliancePercentageOfUnitCategory`** &mdash; `0x0052AB60` (CA: Ingimar)

- One lowercase string with the unit's category name ( see units table )

**`BattleEnemyAlliancePercentageOfUnitClass`** &mdash; `0x0052AD40` (CA: Ingimar)

- One lowercase string with the unit's class name ( see unit_stats_land table )

**`BattleEnemyDirectionOfMeleeAttack`** &mdash; `0x0052AF20` (CA: Ingimar)

- Possible string paramaters are "front", "left_flank", "right_flank" and "behind"

**`BattleEnemyHasMissileSuperiority`** &mdash; `0x0052B030` (CA: Ingimar)

- No paramaters needed

**`BattleEnemyShipActionStatus`** &mdash; `0x0052B3E0` (CA: Ingimar)

- Single string with action status

**`BattleEnemyShipOnFire`** &mdash; `0x0052B4D0` (CA: Ingimar)

- No parameters needed

**`BattleEnemyUnitActionStatus`** &mdash; `0x0052B600` (CA: Ingimar)

- Single string with action status

**`BattleEnemyUnitCategory`** &mdash; `0x0052B6C0` (CA: Ingimar)

- One lowercase string with the enemies unit's category name ( see units table )

**`BattleEnemyUnitClass`** &mdash; `0x0052B7B0` (CA: Ingimar)

- One lowercase string with the unit's class name ( see unit_stats_land table )

**`BattleEnemyUnitCurrentFormation`** &mdash; `0x0052B890` (CA: Ingimar)

- Takes in a single string which can be one of the following : block_formation, pike_square_formation, pike_wall_formation, square_formation, diamond_formation, wedge_formation, light_infantry_behaviour.

**`BattleEnemyUnitOnLeftFlank`** &mdash; `0x0052B980` (CA: Ingimar)

- No parameters needed

**`BattleEnemyUnitOnRightFlank`** &mdash; `0x0052BA00` (CA: Ingimar)

- No parameters needed

**`BattleEnemyUnitTechnologySupported`** &mdash; `0x0052BB70` (CA: Ingimar)

- Technology string : ring_bayonets, socket_bayonets, fire_mounted

**`BattleHasCoverBuildings`** &mdash; `0x0052BC30` (CA: Ingimar)

- No parameters needed

**`BattleHasCoverWalls`** &mdash; `0x0052BCE0` (CA: Ingimar)

- No parameters needed

**`BattleIsLandConflict`** &mdash; `0x0052BD60` (CA: Ingimar)

- No parameters needed

**`BattleIsNavalConflict`** &mdash; `0x0052BE00` (CA: Ingimar)

- No parameters needed

**`BattleIsSiegeConflict`** &mdash; `0x0052BE90` (CA: Ingimar)

- No parameters needed

**`BattlePlayerAllianceDefendingHill`** &mdash; `0x0052BF20` (CA: Ingimar)

- No parameters needed

**`BattlePlayerAlliancePercentageCanHide`** &mdash; `0x0052BFF0` (CA: Ingimar)

- No parameters needed

**`BattlePlayerAlliancePercentageGuerrillas`** &mdash; `0x0052C060` (CA: Scott)

- A single string representing the class of a unit ( see unit_stats_land table )

**`BattlePlayerAlliancePercentageOfAmmoType`** &mdash; `0x0052C180` (CA: Ingimar)

- Takes in a string describing the shottype ( see projectile_shot_type_enum_table )

**`BattlePlayerAlliancePercentageOfClassAndCategory`** &mdash; `0x0052C310` (CA: Ingimar)

- Two lowercase strings, first being the particular class string (see unit_stats_land table ) and second being the category string ( see units table )

**`BattlePlayerAlliancePercentageOfMountType`** &mdash; `0x0052C4A0` (CA: Ingimar)

- A lowercase string with the unit's mount type to be checked ( see type in battle_entities table )

**`BattlePlayerAlliancePercentageOfTechnology`** &mdash; `0x0052C660` (CA: Ingimar)

- Technology string : ring_bayonets, socket_bayonets, fire_mounted

**`BattlePlayerAlliancePercentageOfUnitCategory`** &mdash; `0x0052C7A0` (CA: Ingimar)

- A single string representing the category of a unit ( see units table )

**`BattlePlayerAlliancePercentageOfUnitClass`** &mdash; `0x0052C930` (CA: Ingimar)

- A single string representing the class of a unit ( see unit_stats_land table )

**`BattlePlayerAllianceToEnemyAllianceRatio`** &mdash; `0x0052CAC0` (CA: Ingimar)

- No parameters needed

**`BattlePlayerDefendingFort`** &mdash; `0x0052CD40` (CA: Ingimar)

- No parameters needed

**`BattlePlayerDirectionOfMeleeAttack`** &mdash; `0x0052CE50` (CA: Ingimar)

- Possible string paramaters are "front", "left_flank", "right_flank" and "behind"

**`BattlePlayerDirectionOfMissileAttack`** &mdash; `0x0052CF30` (CA: Ingimar)

- Possible string paramaters are "front", "left_flank", "right_flank" and "behind"

**`BattlePlayerSailsPercentageDamaged`** &mdash; `0x0052D040` (CA: Ingimar)

- No parameters needed

**`BattlePlayerShipActionStatus`** &mdash; `0x0052D0C0` (CA: Ingimar)

- Single string with action status

**`BattlePlayerShipClass`** &mdash; `0x0052D160` (CA: Ingimar)

- One lowercase string with the unit's class name ( see unit_stats_naval table )

**`BattlePlayerUnitActionStatus`** &mdash; `0x0052D220` (CA: Ingimar)

- Single string with action status

**`BattlePlayerUnitAmmoType`** &mdash; `0x0052D2C0` (CA: Ingimar)

- Takes in a string describing the shottype ( see projectile_shot_type_enum table )

**`BattlePlayerUnitCategory`** &mdash; `0x0052D380` (CA: Ingimar)

- One lowercase string with the unit's category name ( see units table )

**`BattlePlayerUnitClass`** &mdash; `0x0052D440` (CA: Ingimar)

- One lowercase string with the unit's class name ( see unit_stats_land table )

**`BattlePlayerUnitCurrentFormation`** &mdash; `0x0052D500` (CA: Ingimar)

- Takes in a single string which can be one of the following : block_formation, pike_square_formation, pike_wall_formation, square_formation, diamond_formation, wedge_formation, light_infantry_behaviour.

**`BattlePlayerUnitDefendingHill`** &mdash; `0x0052D5C0` (CA: Ingimar)

- No paramaters needed

**`BattlePlayerUnitEngaged`** &mdash; `0x0052D6A0` (CA: Ingimar)

- No parameters needed

**`BattlePlayerUnitEngagedInMelee`** &mdash; `0x0052D630` (CA: Ingimar)

- No parameters needed

**`BattlePlayerUnitMountType`** &mdash; `0x0052D760` (CA: Ingimar)

- A lowercase string with the unit's mount type to be checked ( see type in battle_entities ) table

**`BattlePlayerUnitMovingFast`** &mdash; `0x0052D830` (CA: Ingimar)

- No parameters needed

**`BattlePlayerUnitTechnologySupported`** &mdash; `0x0052DA20` (CA: Ingimar)

- Technology string : ring_bayonets, socket_bayonets, fire_mounted

**`BattleResult`** &mdash; `0x0089AA20` (CA: Luke)

- Result of the battle, e.g. "crushing_defeat", "major_victory", "pyrrhic_victory"

**`BattleShipIsPlayers`** &mdash; `0x0052DAB0` (CA: Ingimar)

- No parameters needed

**`BattleShipSailsPercentageDamage`** &mdash; `0x0052D040` (CA: Ingimar)

- No parameters needed

**`BattleTimeLimitSet`** &mdash; `0x0052DBF0` (CA: Ingimar)

- No parameters needed

**`BattleType`** &mdash; `0x0052DC80` (CA: Ingimar)

- Battle type string : normal, land_normal, land_bridge, fort_standard, fort_sally, fort_relief, settlement_standard, settlement_sally, settlement_relief settlement_unfortified, town_normal, naval_normal, naval_blockade, naval_breakout. Please see designers for which of these are supported.

**`BattleUnitIsAllied`** &mdash; `0x0052DD50` (CA: Ingimar)

- No parameters needed

**`BattleUnitIsPlayers`** &mdash; `0x0052DE10` (CA: Ingimar)

- No parameters needed

**`BattlesFought`** &mdash; `0x0089AB90` (CA: Luke)

- None

**`BuildingLevelName`** &mdash; `0x00B01ED0` (CA: Guy)

- String corresponding to level_name of supplied building level record

**`BuildingTypeExistsAtSettlement`** &mdash; `0x0089ABE0` (CA: Ed)

- The key of the building level you are querying from the building_levels table

**`BuildingTypeExistsAtSlot`** &mdash; `0x0089ACE0` (CA: Ed)

- The key of the building level you are querying from the building_levels table

**`CampaignBattleType`** &mdash; `0x0089ADA0` (CA: Luke)

- Battle type string : normal, land_normal, land_bridge, fort_standard, fort_sally, fort_relief, settlement_standard, settlement_sally, settlement_relief settlement_unfortified, town_normal, naval_normal, naval_blockade, naval_breakout. Please see designers for which of these are supported.

**`CampaignName`** &mdash; `0x0089AEA0` (CA: Guy)

- Name of the campaign to compare against, from the campaigns table

**`CampaignPercentageOfOwnCaptured`** &mdash; `0x0089AF70` (CA: Luke)

- None

**`CampaignPercentageOfOwnKilled`** &mdash; `0x0089B090` (CA: Luke)

- None

**`CampaignPercentageOfOwnRouted`** &mdash; `0x0089B1F0` (CA: Luke)

- None

**`CampaignPercentageOfThemCaptured`** &mdash; `0x0089B300` (CA: Luke)

- None

**`CampaignPercentageOfThemKilled`** &mdash; `0x0089B420` (CA: Luke)

- None

**`CampaignPercentageOfThemRouted`** &mdash; `0x0089B580` (CA: Luke)

- None

**`CampaignPercentageOfUnitCategory`** &mdash; `0x0089B690` (CA: Luke)

- None

**`CanGenerateHistoricalCharacter`** &mdash; `0x0089B830` (CA: Paul)

- Historical character record key

**`CharacterAbility`** &mdash; `0x0089BB10` (CA: Tom)

- Ability name (valid key from abilities table)

**`CharacterArmyCouldReplenishFromBattle`** &mdash; `0x0089BBD0` (CA: Paul)

- None

**`CharacterArmyUsedCoverBuildings`** &mdash; `0x0089BD00` (CA: Paul)

- None

**`CharacterArmyUsedCoverWalls`** &mdash; `0x0089BE10` (CA: Paul)

- None

**`CharacterAttribute`** &mdash; `0x0089BF20` (CA: Tom)

- Attribute name (valid key from agent_attributes table)

**`CharacterBattleWallsBreached`** &mdash; `0x0089BFE0` (CA: Paul)

- None

**`CharacterBuildingConstructed`** &mdash; `0x0089C0F0` (CA: Luke)

- The building type

**`CharacterCapturedEnemyShip`** &mdash; `0x0089C190` (CA: Luke)

- None

**`CharacterCultureType`** &mdash; `0x0089C240` (CA: Tom)

- Valid entry from 'key' field from cultures table in Empire.mdb

**`CharacterDuelWeapon`** &mdash; `0x0089C350` (CA: Luke)

- none

**`CharacterDuelsFought`** &mdash; `0x0089C430` (CA: Ed)

- None

**`CharacterDuelsLost`** &mdash; `0x0089C4A0` (CA: Ed)

- None

**`CharacterDuelsWon`** &mdash; `0x0089C510` (CA: Ed)

- None

**`CharacterEndedInAmbushPosition`** &mdash; `0x0089C580` (CA: Luke)

- none

**`CharacterFactionAdmiralCount`** &mdash; `0x0089C5E0` (CA: Luke)

- none

**`CharacterFactionGeneralCount`** &mdash; `0x0089C690` (CA: Luke)

- none

**`CharacterFactionHasTechType`** &mdash; `0x0089C740` (CA: Luke)

- A valid key from the technologies table.

**`CharacterFactionMinisterAncillary`** &mdash; `0x0089C860` (CA: Paul)

- Ancillary name

**`CharacterFactionMinisterTrait`** &mdash; `0x0089C990` (CA: Paul)

- Trait name

**`CharacterFactionName`** &mdash; `0x0089CAE0` (CA: Luke)

- The db record key for the faction

**`CharacterFactionSubcultureType`** &mdash; `0x0089CBA0` (CA: Luke)

- Subculture key

**`CharacterForename`** &mdash; `0x0089CC30` (CA: Alan)

- The forename's db key

**`CharacterFoughtCulture`** &mdash; `0x0089CCE0` (CA: Luke)

- None

**`CharacterHasAncillary`** &mdash; `0x0089CDF0` (CA: Paul)

- Ancillary name

**`CharacterHasTrait`** &mdash; `0x0089CF00` (CA: Luke)

- The name of the trait

**`CharacterHoldsPost`** &mdash; `0x0089D000` (CA: Luke)

- None

**`CharacterInRegion`** &mdash; `0x0089D500` (CA: Luke)

- The region key

**`CharacterInTheatre`** &mdash; `0x0089D5B0` (CA: Ed)

- none

**`CharacterIsAlliedCampaign`** &mdash; `0x0089D6E0` (CA: Ed)

- None

**`CharacterIsEnemyCampaign`** &mdash; `0x0089D770` (CA: Ed)

- None

**`CharacterIsLocalCampaign`** &mdash; `0x0089D800` (CA: Ed)

- none

**`CharacterMPPercentageRemaining`** &mdash; `0x0089D880` (CA: Tom)

- None

**`CharacterMinisterialPosition`** &mdash; `0x0089D930` (CA: Luke)

- Ministerial position

**`CharacterNumberOfChildren`** &mdash; `0x0089D9E0` (CA: Luke)

- None

**`CharacterRallied`** &mdash; `0x0089DA80` (CA: Paul)

- None

**`CharacterRouted`** &mdash; `0x0089DBC0` (CA: Luke)

- None

**`CharacterRunsSpyNetwork`** &mdash; `0x0089DD30` (CA: Paul)

- None

**`CharacterStationaryForOneTurn`** &mdash; `0x0089DDB0` (CA: Ed)

- None

**`CharacterSurname`** &mdash; `0x0089DE20` (CA: Alan)

- The surname's db key

**`CharacterTrait`** &mdash; `0x0089DED0` (CA: Tom)

- Trait name

**`CharacterType`** &mdash; `0x0089E0D0` (CA: Tom)

- Valid entry from 'key' field from Agents table in Empire.mdb

**`CharacterWasAttacker`** &mdash; `0x0089E190` (CA: Luke)

- none

**`CharacterWithdrewFromBattle`** &mdash; `0x0089E220` (CA: Paul)

- None

**`CharacterWonBattle`** &mdash; `0x0089E330` (CA: Ed)

- None

**`CharacterWonDuel`** &mdash; `0x0089E3C0` (CA: Luke)

- none

**`CharactersUnitRallied`** &mdash; `0x0089E460` (CA: Paul)

- None

**`CommanderAncillary`** &mdash; `0x0089E5A0` (CA: Luke)

- Ancillary name

**`CommanderFoughtInBattle`** &mdash; `0x0089E670` (CA: Luke)

- None

**`CommanderFoughtInMelee`** &mdash; `0x0089E7F0` (CA: Luke)

- None

**`CommanderTrait`** &mdash; `0x0089E960` (CA: Luke)

- Trait name

**`DateAndWeekInRange`** &mdash; `0x0089EA40` (CA: Paul)

- Start Week, Start Year, End Week, End Year (Inclusive)

**`DateInRange`** &mdash; `0x0089EBA0` (CA: Paul)

- Start Year, End Year (Inclusive)

**`DefensiveSiegesFought`** &mdash; `0x0089EC50` (CA: Ed)

- none

**`DefensiveSiegesWon`** &mdash; `0x0089ECC0` (CA: Ed)

- none

**`DifficultyLevel`** &mdash; `0x0089ED30` (CA: Paul)

- none

**`FactionAllyCount`** &mdash; `0x0089EE60` (CA: Paul)

- none

**`FactionBuildingExists`** &mdash; `0x0089EF20` (CA: Paul K)

- Parameter 1: A valid key from the factions table.  Parameter 2: A valid key from the building_levels table.

**`FactionCanBuildBuilding`** &mdash; `0x0089F1C0` (CA: Ed)

- The building key from the building levels table

**`FactionCashFlow`** &mdash; `0x0089F3C0` (CA: Paul)

- none

**`FactionExists`** &mdash; `0x0089F520` (CA: Luke)

- The db record for the faction

**`FactionGovernmentType`** &mdash; `0x0089F5D0` (CA: Ed)

- The government key from the government_types table

**`FactionHasAllies`** &mdash; `0x0089F710` (CA: Paul)

- none

**`FactionHasTradeShipNotInTradeNode`** &mdash; `0x0089F7C0` (CA: Ed)

- None

**`FactionIsAlliedCampaign`** &mdash; `0x0089F8A0` (CA: Ed)

- None

**`FactionIsEnemyCampaign`** &mdash; `0x0089F920` (CA: Ed)

- Faction to query

**`FactionIsHuman`** &mdash; `0x0089F9F0` (CA: Alan)

- none

**`FactionIsLocal`** &mdash; `0x0089FA60` (CA: Ed)

- none

**`FactionLeadersAttribute`** &mdash; `0x0089FAE0` (CA: Luke)

- The attribute which you wish to check on the factions leader

**`FactionLeadersTrait`** &mdash; `0x0089FBA0` (CA: Tom)

- Trait name

**`FactionName`** &mdash; `0x0089FC90` (CA: Alan)

- The db record for the faction

**`FactionParticipatedInBattle`** &mdash; `0x0089FD40` (CA: Ed)

- Faction key of the faction to be queried

**`FactionSupportCostsPercentage`** &mdash; `0x0089FE90` (CA: Ed)

- none

**`FactionTaxLevel`** &mdash; `0x0089FF20` (CA: Paul)

- "lower_classes" or "upper_classes"

**`FactionTechExists`** &mdash; `0x008A00B0` (CA: Paul K)

- Parameter 1: A valid key from the factions table.  Parameter 2: A valid key from the technologies table.

**`FactionTradeCommodityExists`** &mdash; `0x008A01F0` (CA: Paul)

- Valid entry from 'key' field from resources table in Empire.mdb

**`FactionTradeValue`** &mdash; `0x008A0630` (CA: Paul)

- none

**`FactionTradeValuePercentage`** &mdash; `0x008A0450` (CA: Paul)

- none

**`FactionTreasury`** &mdash; `0x008A0860` (CA: Paul)

- none

**`FactionTreasuryWorldPercentage`** &mdash; `0x008A0750` (CA: Paul)

- none

**`FactionwideAncillaryTypeExists`** &mdash; `0x008A0940` (CA: Tom)

- Ancillary name

**`FortBuildingQueueIdleDespiteCash`** &mdash; `0x008A0A40` (CA: Ed)

- none

**`FortIsLocal`** &mdash; `0x008A0AF0` (CA: Luke)

- none

**`FortName`** &mdash; `0x008A0B70` (CA: Ting)

- The name of the fort to check for

**`GovernorTaxLevel`** &mdash; `0x008A0C30` (CA: Tom)

- none

**`GovernorshipEquals`** &mdash; `0x008A0D30` (CA: Ed)

- Key of the governorship to be queried 

**`GovernorshipTaxLevel`** &mdash; `0x008A0DF0` (CA: Paul)

- Valid entry from 'governorship' field from governorships table in Empire.mdb

**`HasUnspecialisedPort`** &mdash; `0x008A0F20` (CA: Paul)

- none

**`InPort`** &mdash; `0x008A0FC0` (CA: Ed)

- none

**`InSettlement`** &mdash; `0x008A1030` (CA: Tom)

- none

**`InsurrectionCrushed`** &mdash; `0x008A1070` (CA: Luke)

- none

**`IsBesieging`** &mdash; `0x008A10E0` (CA: Ed)

- none

**`IsBlockading`** &mdash; `0x008A1150` (CA: Ed)

- none

**`IsBuildingInChain`** &mdash; `0x008A11C0` (CA: Ed)

- The key of the building chain you are querying from the building_chains table

**`IsBuildingOfType`** &mdash; `0x008A1410` (CA: Ed)

- The key of the building level you are querying from the building_levels table

**`IsCarryingTroops`** &mdash; `0x008A1680` (CA: Ed)

- none

**`IsChildOf`** &mdash; `0x00DA9680` (CA: tom)

- Component id

**`IsColony`** &mdash; `0x008A1710` (CA: Ed)

- none

**`IsComponentType`** &mdash; `0x00DA9750` (CA: tom)

- Component id

**`IsFactionBesiegingSettlement`** &mdash; `0x008A17B0` (CA: Ed)

- Settlement key

**`IsFactionLeader`** &mdash; `0x008A1940` (CA: Luke)

- none

**`IsFactionLeaderFemale`** &mdash; `0x008A18A0` (CA: Luke)

- none

**`IsGarrisoned`** &mdash; `0x008A19F0` (CA: Ed)

- none

**`IsGuerrillaGeneral`** &mdash; `0x008A1A60` (CA: Paul)

- None

**`IsHomeRegion`** &mdash; `0x008A1B20` (CA: Ed)

- none

**`IsMessageType`** &mdash; `0x00DA9750` (CA: tom)

- Message id

**`IsMultiplayer`** &mdash; `0x008A1BA0` (CA: Ting)

- None

**`IsPlayerTurn`** &mdash; `0x008A1C10` (CA: Luke)

- None

**`IsPortGarrisoned`** &mdash; `0x008A1CA0` (CA: Ed)

- none

**`IsTheatreGovernor`** &mdash; `0x008A1D40` (CA: Luke)

- none

**`IsTriggerableHistoricalEvent`** &mdash; `0x008A1DC0` (CA: Paul)

- Historical event record key

**`IsUnderBlockade`** &mdash; `0x008A1F60` (CA: Ed)

- none

**`IsUnderSiege`** &mdash; `0x008A1FF0` (CA: Ed)

- none

**`LandTradeRouteRaided`** &mdash; `0x008A20A0` (CA: Luke)

- none

**`LosingMoney`** &mdash; `0x008A2100` (CA: Paul)

- none

**`MapPosition`** &mdash; `0x009BE540` (CA: Ting)

- Location on the map

**`MissionName`** &mdash; `0x009BE760` (CA: Alan)

- mission name

**`NoActionThisTurn`** &mdash; `0x008A2190` (CA: Luke)

- none

**`OffensiveSiegesFought`** &mdash; `0x008A21F0` (CA: Ed)

- none

**`OffensiveSiegesWon`** &mdash; `0x008A2260` (CA: Ed)

- none

**`OnAWarFooting`** &mdash; `0x008A22D0` (CA: Paul)

- none

**`ParentId`** &mdash; `0x00DA98E0` (CA: tom)

- Component id

**`PercentageUnspentIncome`** &mdash; `0x008A2380` (CA: Luke)

- None

**`PlayerFactionIsAttacker`** &mdash; `0x008A24A0` (CA: Luke)

- none

**`PortBlockaded`** &mdash; `0x008A2610` (CA: Luke)

- none

**`PortBlockadedLocal`** &mdash; `0x008A2530` (CA: Luke)

- none

**`RandomPercentCampaign`** &mdash; `0x008A26B0` (CA: Ed)

- Number between 0 and 100 to test against

**`RegionBuildableSlotEmpty`** &mdash; `0x008A27A0` (CA: Ed)

- none

**`RegionBuildingFinished`** &mdash; `0x008A28C0` (CA: Ed)

- none

**`RegionClamoursReform`** &mdash; `0x008A2960` (CA: Ed)

- none

**`RegionCultureIsFactionCulture`** &mdash; `0x008A29D0` (CA: Ed)

- none

**`RegionDemands`** &mdash; `0x008A2A70` (CA: Ed)

- none

**`RegionEconomicGrowthLow`** &mdash; `0x008A2AE0` (CA: Luke)

- none

**`RegionFoodShortageEmigration`** &mdash; `0x008A2B50` (CA: Luke)

- none

**`RegionGovernorAttribute`** &mdash; `0x008A2BE0` (CA: Luke)

- The attribute which you wish to check on the regions governor

**`RegionHasFoodShortages`** &mdash; `0x008A2CB0` (CA: Ed)

- none

**`RegionHasUnexportedTrade`** &mdash; `0x008A2D20` (CA: Paul)

- none

**`RegionIsLocal`** &mdash; `0x008A2D90` (CA: Ed)

- none

**`RegionIsRebelling`** &mdash; `0x008A2E10` (CA: Ed)

- Key of the region to query

**`RegionPopulationGrowthLow`** &mdash; `0x008A2ED0` (CA: Luke)

- none

**`RegionPopulationLow`** &mdash; `0x008A2F70` (CA: Ed)

- none

**`RegionPopulationMaxReached`** &mdash; `0x008A3020` (CA: Ed)

- none

**`RegionRebels`** &mdash; `0x008A30A0` (CA: Ed)

- none

**`RegionReligionIsStateReligion`** &mdash; `0x008A3110` (CA: Ed)

- none

**`RegionReligiousEmigration`** &mdash; `0x008A31A0` (CA: Luke)

- none

**`RegionResourceExists`** &mdash; `0x008A3230` (CA: Paul)

- Valid entry from 'key' field from resources table in Empire.mdb

**`RegionResourceExploited`** &mdash; `0x008A3370` (CA: Paul)

- Valid entry from 'key' field from resources table in Empire.mdb

**`RegionRiots`** &mdash; `0x008A34C0` (CA: Ed)

- none

**`RegionSlotBuildingCount`** &mdash; `0x008A3530` (CA: Ed)

- none

**`RegionSlotBuildingCultureExists`** &mdash; `0x008A35F0` (CA: Ed)

- The key of the culture from the cultures table

**`RegionSlotBuildingTypeCount`** &mdash; `0x008A3730` (CA: Ed)

- The key of the building level you are querying from the building_levels table

**`RegionSlotBuildingTypeExists`** &mdash; `0x008A3880` (CA: Ed)

- The key of the building level you are querying from the building_levels table

**`RegionSlotCount`** &mdash; `0x008A3A00` (CA: Ed)

- none

**`RegionSlotEmptyCount`** &mdash; `0x008A3AC0` (CA: Ed)

- none

**`RegionSlotTypeExists`** &mdash; `0x008A3BD0` (CA: Ed)

- The key of the slot type you wish to find from the slots table

**`RegionTaxExempt`** &mdash; `0x008A3CC0` (CA: Luke)

- n/a

**`RegionTaxLevel`** &mdash; `0x008A3D20` (CA: Paul)

- "lower_classes" or "upper_classes"

**`RegionTaxTownWealthGrowthReduction`** &mdash; `0x008A3E10` (CA: Paul)

- none

**`RegionTownWealthGrowth`** &mdash; `0x008A3E90` (CA: Paul)

- none

**`RegionWealthDecrease`** &mdash; `0x008A3F00` (CA: Luke)

- none

**`RegionWealthIncrease`** &mdash; `0x008A3F80` (CA: Luke)

- none

**`ResearchCategory`** &mdash; `0x008A4000` (CA: Luke)

- Category

**`ResearchQueueIdle`** &mdash; `0x008A40B0` (CA: Ed)

- none

**`ResearchType`** &mdash; `0x008A4200` (CA: Luke)

- Research type

**`ResearchTypeUniqueToFaction`** &mdash; `0x008A4120` (CA: Luke)

- Research type

**`RoadsAtMaxLevel`** &mdash; `0x008A42A0` (CA: Paul)

- none

**`SeaTradeRouteRaided`** &mdash; `0x008A4340` (CA: Luke)

- none

**`SettlementBuildingQueueIdleDespiteCash`** &mdash; `0x008A43A0` (CA: Ed)

- none

**`SettlementFortificationsBuildingQueueIdleDespiteCash`** &mdash; `0x008A4490` (CA: Ed)

- none

**`SettlementIsLocal`** &mdash; `0x008A4520` (CA: Ed)

- none

**`SettlementName`** &mdash; `0x008A45A0` (CA: Ed)

- The unique id of the settlement from the campaign_map_settlements table or a character, in which case it looks at the settlement the character is in

**`SettlementOwnedBy`** &mdash; `0x008A4680` (CA: Ed)

- The unique id of the settlement from the campaign_map_settlements table or a character, in which case it looks at the settlement the character is in. Use "rebels" to test for rebel ownership

**`SettlementRoadBuildingQueueIdleDespiteCash`** &mdash; `0x008A47C0` (CA: Ed)

- none

**`SlotBuildingQueueIdleDespiteCash`** &mdash; `0x008A4850` (CA: Ed)

- none

**`SlotIsAlliedCampaign`** &mdash; `0x008A48D0` (CA: Luke)

- none

**`SlotIsLocal`** &mdash; `0x008A4950` (CA: Ed)

- none

**`SlotName`** &mdash; `0x008A49D0` (CA: Ed)

- The name of the slot to check for

**`SlotType`** &mdash; `0x008A4AA0` (CA: Ed)

- The slot type (key from the slots table)

**`SupportCostsPercentage`** &mdash; `0x008A4B50` (CA: Luke)

- none

**`TargetArmyGreaterCombatStrength`** &mdash; `0x008A4C30` (CA: Ed)

- None

**`TargetCharacterIsAlliedCampaign`** &mdash; `0x008A4CB0` (CA: Ed)

- None

**`TargetCharacterIsEnemyCampaign`** &mdash; `0x008A4D40` (CA: Ed)

- None

**`TargetInStrikingRangeOfEnemy`** &mdash; `0x008A4DD0` (CA: Ed)

- None

**`TaxCollectionLimited`** &mdash; `0x008A4E70` (CA: Paul)

- none

**`TaxLevel`** &mdash; `0x008A4F50` (CA: Paul)

- Valid entry from 'key' field from taxes_levels table in Empire.mdb

**`TradeNodeAvailableWorldwide`** &mdash; `0x008A5090` (CA: Ed)

- None

**`TradePortsAtMaxLevel`** &mdash; `0x008A52D0` (CA: Paul)

- none

**`TradeRouteIsEnemy`** &mdash; `0x008A53B0` (CA: Luke)

- None

**`TradeRouteIsLocal`** &mdash; `0x008A5510` (CA: Luke)

- None

**`TradeRouteLimitReached`** &mdash; `0x008A5670` (CA: Paul)

- none

**`TurnNumber`** &mdash; `0x008A5770` (CA: Guy)

- None

**`TurnsSinceThreadLastAdvanced`** &mdash; `0x00460AD0` (CA: Guy)

- Key from advice_threads table

**`UnitCategory`** &mdash; `0x008A57E0` (CA: Luke)

- none

**`UnitClass`** &mdash; `0x008A58C0` (CA: Luke)

- none

**`UnitCrushedInsurrection`** &mdash; `0x008A59A0` (CA: Luke)

- none

**`UnitCultureType`** &mdash; `0x008A59E0` (CA: Luke)

- none

**`UnitFoughtInBattle`** &mdash; `0x008A5AC0` (CA: Luke)

- none

**`UnitFoughtInMelee`** &mdash; `0x008A5C20` (CA: Luke)

- none

**`UnitInTheatre`** &mdash; `0x008A5D70` (CA: Luke)

- none

**`UnitOnContinent`** &mdash; `0x008A5EC0` (CA: Luke)

- none

**`UnitRouted`** &mdash; `0x008A5F90` (CA: Luke)

- none

**`UnitSufferedCasualties`** &mdash; `0x008A60E0` (CA: Luke)

- none

**`UnitTrait`** &mdash; `0x008A62F0` (CA: Luke)

- Trait name

**`UnitType`** &mdash; `0x008A6400` (CA: Ed)

- The unit key from the units table

**`UnitWonBattle`** &mdash; `0x008A64C0` (CA: Luke)

- None

**`UnusedInternationalTradeRoute`** &mdash; `0x008A6550` (CA: Paul)

- none

**`WorldResourceExists`** &mdash; `0x008A6730` (CA: Paul)

- Valid entry from 'key' field from resources table in Empire.mdb

**`WorldResourceExploited`** &mdash; `0x008A68A0` (CA: Paul)

- Valid entry from 'key' field from resources table in Empire.mdb

**`WorldwideAncillaryTypeExists`** &mdash; `0x008A6A20` (CA: Tom)

- Ancillary name

**`WouldRebellionInRegionBeRevolution`** &mdash; `0x008A6B00` (CA: Alan)

- none

## events - callback lists you may append handlers to

138 entries.

| event | context scope | when it fires |
|---|---|---|
| `AdviceDismissed` | **Advice thread** | Advice has been dismissed by the UI |
| `AdviceFinishedTrigger` | **Sound** | Notify scripters when current advice has finished playing |
| `AdviceIssued` | **Advice thread** | Advice has been sent to the UI |
| `AdviceSuperseded` | **Advice thread** | Advice has been superseded by another advice |
| `ArmySabotageAttemptSuccess` | **Character** | A character has successfully sabotaged an enemy army |
| `AssassinationAttemptSuccess` | **Character** | An agent has successfully assassinated an enemy |
| `BattleBoardingActionCommenced` | **Battle** | Fired each time a ship commences the boarding of an enemy vessel |
| `BattleBoardingShip` | **Battle** | Gets triggered when the order to board a ship is issued |
| `BattleCommandingUnitRouts` | **Land Battle** | Fires off an event for when a unit that has a commanding general attached to it routs |
| `BattleCompleted` | **Campaign model** | A battle has been completed on the campaign map |
| `BattleConflictPhaseCommenced` | **Battle** | Fired once at the start of conflict |
| `BattleDeploymentPhaseCommenced` | **Battle** | Fired once at the start of deployment |
| `BattleFortPlazaCaptureCommenced` | **Battle** | Fired each time an attacking unit starts capturing the victory location inside a fort |
| `BattleShipAttacksEnemyShip` | **Battle** | Gets fired off for every attack order executed by a ship |
| `BattleShipCaughtFire` | **Battle** | A ship just caught fire |
| `BattleShipMagazineExplosion` | **Battle** | Fired off when a ship explodes |
| `BattleShipRouts` | **Naval Battle** | Fires off whenever a ship enters the rout state of morale |
| `BattleShipRunAground` | **Naval Battle** | Fired off when a ship collides with the terrain |
| `BattleShipSailingIntoWind` | **Naval Battle** | Fired off when a ship is sailing approximately into the wind |
| `BattleShipSurrendered` | **Naval Battle** | Fired off when a ship surrenders |
| `BattleUnitAttacksBuilding` | **Battle** | Gets fired off for every attack order executed by a unit |
| `BattleUnitAttacksEnemyUnit` | **Battle** | Gets fired off for every attack order executed by a unit |
| `BattleUnitAttacksWalls` | **Battle** | Gets fired off for every attack order executed by a unit when attacking a fort building |
| `BattleUnitCapturesBuilding` | **Battle** | Gets fired each time a building has a new alliance as an owner, initiated by a unit |
| `BattleUnitDestroysBuilding` | **Battle** | Gets fired each time a building gets destroyed by a unit |
| `BattleUnitRouts` | **Land Battle** | Fires off an event for when a unit enters rout. |
| `BattleUnitUsingBuilding` | **Battle** | Fires off when a unit enters a building |
| `BattleUnitUsingWall` | **Battle** | Fires off when a unit attaches itself to a wall |
| `BuildingCardSelected` | **String (building record key)** | Fires when a building card is clicked on on the hud |
| `BuildingCompleted` | **Building level record, Character** | A building has been completed |
| `BuildingConstructionIssuedByPlayer` | **building level** | Fired when the player selects adds a building to the queue |
| `BuildingInfoPanelOpenedCampaign` | **string** | triggers when the building info panel is opened by the user in the campaign game |
| `CameraMoverCancelled` | **MAP_LOCATION** | When the camera controller is cancelled before completion |
| `CameraMoverFinished` | **MAP_LOCATION** | When the camera reaches the end of its path, or when another camera transition cuts in |
| `CampaignArmiesMerge` | **Character, character target** | Two campaign armies merge |
| `CampaignBuildingDamaged` | **Region slot** | A building is damaged |
| `CampaignSettlementAttacked` | **Settlement** | A settlement has been attacked |
| `CampaignSlotAttacked` | **Region slot** | A slot has been attacked |
| `CharacterAttacksAlly` | **Character** | A character has attacked an ally |
| `CharacterBlockadedPort` | **Character** | A character successfully blockades a port |
| `CharacterBrokePortBlockade` | **Character** | A character successfully broke a port blockade |
| `CharacterBuildsSpyNetwork` | **Character** | A character builds a spy network |
| `CharacterCanLiberate` | **Character** | A character was given the opportunity to liberate a region |
| `CharacterCandidateBecomesMinister` | **Character** | Fired when a candidate becomes a minister |
| `CharacterCompletedBattle` | **Character** | A character took part in a battle and didn't die |
| `CharacterCreated` | **Character** | Fired when a character is created |
| `CharacterCriticallyFailsAssassination` | **Character** | A character critically fails an assassination attempt (and dies) |
| `CharacterDisembarksNavy` | **Character** | A character disembarks a navy |
| `CharacterEmbarksNavy` | **Character** | A character embarks on a navy |
| `CharacterEntersAttritionalArea` | **Character** | Fired when a characters ends its movement in a position where it will suffer attrition |
| `CharacterEntersGarrison` | **Garrison, Character** | A character enters a garrison (settlement, slot or fort) |
| `CharacterFactionCompletesResearch` | **Technology record, Character** | A character belonging to the faction has completed some research |
| `CharacterFactionSpyAttemptSuccessful` | **Character** | A character belonging to the faction of this faction leader has successfully spied on an enemy |
| `CharacterFactionSuffersSuccessfulSpyAttempt` | **Character** | The capital of the faction of this faction leader was successfully spied on by an enemy |
| `CharacterInfoPanelOpened` | **character, faction** | triggers the character information panel has been opened |
| `CharacterLootedSettlement` | **Character** | A character loots a settlement |
| `CharacterPromoted` | **Character** | A character has been promoted |
| `CharacterSelected` | **Character** | Fired when a character is selected |
| `CharacterTurnEnd` | **Character** | Fired for every character at the start of their turn |
| `CharacterTurnStart` | **Character** | Fired for every character at the start of their turn |
| `ComponentLClickUp` | **String (ComponentType condition), Component** | Triggered when a user clicks on any component |
| `CustomMission` | **Cannot be used in LUA** | Internal event: does not fire and cannot be used in the script |
| `DuelFought` | **Character** | A duel has completed |
| `EspionageAgentApprehended` | **Character** | A character has foiled an espionage attempt |
| `EventMessageOpenedBattle` | **string (event name)** | triggers when a dropdown message is opened by the user |
| `EventMessageOpenedCampaign` | **string (event name)** | triggers when a dropdown message is opened by the user |
| `FactionBecomesLiberationProtectorate` | **Faction** | A faction has liberated another faction |
| `FactionGovernmentTypeChanged` | **Faction** | The factions government type has changed |
| `FactionRoundStart` | **Faction** | Faction starts the round |
| `FactionTurnEnd` | **Faction** | Faction ends it's turn |
| `FactionTurnStart` | **Faction** | Faction starts it's turn |
| `FortSelected` | **Fort** | Fired when the player selects a fort on the map |
| `GarrisonResidenceCaptured` | **Garrison residence** | A garrison residence (settlement, fort, port &c.) has been captured |
| `GovernorshipTaxRateChanged` | **Governorship** | A tax rate in a governorship has changed |
| `HarassmentAttemptSuccess` | **Character** | A character has successfully harrassed an enemy army |
| `HistoricalCharacters` | **List of possible historical characters** |  |
| `HistoricalEvents` | **List of possible historical events** |  |
| `HudRefresh` | **Empty string** | triggers when the HUD is reconstructed |
| `IncomingMessage` | **string (event name)** | triggers when a dropdown message first starts falling down the screen |
| `LandTradeRouteRaided` | **Character, Position** | A character has raided a land trade route |
| `LoadingGame` | **FileHandle** | A game is being loaded |
| `LocationEntered` | **MAP_LOCATION, the piece that entered** | When a piece enters a location trigger, fire ony once per trigger |
| `LocationUnveiled` | **MAP_LOCATION, the piece that unveiled the area** | When the location becomes visible for the first time |
| `MissionFailed` | **Mission, mission manager, faction of mission manager, campaign model** | The player has failed a mission |
| `MissionIssued` | **Mission, mission manager, faction of mission manager, campaign model** | A mission has been issued to the player |
| `MissionNearingExpiry` | **Mission, mission manager, faction of mission manager, campaign model** | A mission only has a quarter of its time left before its too late to complete it |
| `MissionSucceeded` | **Mission, mission manager, faction of mission manager, campaign model** | A mission has been successfully completed |
| `ModelCreated` | **none** | A game is being started or loaded, at this point the most vital parts pf the game are initialized |
| `MovementPointsExhausted` | **Character** | A general can move no more |
| `MultiTurnMove` | **Character** | A character has been issued a movement that will take more than one turn |
| `NewCampaignStarted` | **none** | A new campaign game is being started - called exactly once during a campaign, when it is created for the first time - NOT called when loading, NOT called when processing startpos |
| `NewSession` | **model access** | A game is being started, could be a new game or loading a save game |
| `PanelAdviceRequestedBattle` | **string** | triggers when the user clicks on the request advice button on a panel in battle |
| `PanelAdviceRequestedCampaign` | **string** | triggers when the user clicks on the request advice button on a panel in the campaign game |
| `PanelClosedBattle` | **string** | triggers when a ui panel is closed by the user in battle |
| `PanelClosedCampaign` | **string** | triggers when a ui panel is closed by the user in the campaign game |
| `PanelOpenedBattle` | **string** | triggers when a ui panel is opened by the user in battle |
| `PanelOpenedCampaign` | **string** | triggers when a ui panel is opened by the user in the campaign game |
| `PendingBankruptcy` | **Faction** | The faction is about to go bankrupt |
| `RecruitmentItemIssuedByPlayer` | **unit record** | Fired when the player selects adds a unit to the queue |
| `RegionIssuesDemands` | **Region** | This region has issued demands |
| `RegionRebels` | **Region** | This region has started rebelling |
| `RegionRiots` | **Region** | This region has started riots |
| `RegionStrikes` | **Region** | This region has started striking |
| `RegionTurnEnd` | **Region** | Region ends it's turn |
| `RegionTurnStart` | **Region** | Region starts it's turn |
| `ResearchCompleted` | **Technology record, Character** | Research has been completed in this slot |
| `SabotageAttemptSuccess` | **Character** | A character has successfully sabotaged the enemy |
| `SavingGame` | **FileHandle** | A game is being saveed |
| `SeaTradeRouteRaided` | **Character, Position** | A character has raided a sea trade route |
| `SettlementOccupied` | **Settlement** | A settlement is occupied by an enemy faction |
| `SettlementSelected` | **Settlement** | Fired when the player selects a settlement on the map |
| `SlotOccupied` | **Region Slot** | A slot is occupied by an enemy faction |
| `SlotOpens` | **Slot, Region** | A slot has just opened |
| `SlotRoundStart` | **Slot, Region** | The start of round for this slot |
| `SlotSelected` | **Slot** | Fired when the player selects a settlement slot on the map |
| `SlotTurnStart` | **Slot, Region** | The start of turn for this slot |
| `SpyingAttemptSuccess` | **Character** | An agent has successfully spied on the enemy |
| `SufferAssassinationAttempt` | **Character** | A character has suffered an assassination attempt |
| `SufferSpyingAttempt` | **Character** | A character has suffered a spying attempt |
| `TechnologyInfoPanelOpenedCampaign` | **string** | triggers when the technology info panel is opened by the user in the campaign game |
| `TestEvent` | **model** | Test event |
| `TimeTrigger` | **STRING, the id of the time trigger** | A registered timer have waited long |
| `TooltipAdvice` | **string** | triggers when a tooltip cycles though all of it's available lines (only happens at end of first sequence |
| `TradeRouteEstablished` | **Faction** | A trade route has been established with this faction |
| `UICreated` | **String (name of the UI), Component (root component of the ui)** | Fires when the UI is first created |
| `UIDestroyed` | **String (name of the UI)** | Fires when the UI is destroyed |
| `UngarrisonedFort` | **Region slot** | A fort has been left ungarrisoned |
| `UnitCompletedBattle` | **Unit** | A unit has completed the battle |
| `UnitCreated` | **Unit** | A unit has been created |
| `UnitSelectedCampaign` | **Unit (campaign)** | Fires when a unit card is selected on the campaign map |
| `UnitTrained` | **Unit** | A unit is trained |
| `UnitTurnEnd` | **Unit** | A unit has ended its turn |
| `VictoryConditionFailed` | **none** | The time limit has ran out for a victory condition |
| `VictoryConditionMet` | **faction** | Victory condition has been met by the player |
| `WorldCreated` | **none** | A game is being started or loaded, at this point the most vital parts pf the game are initialized |
| `battle_commanding_ship_routs` | **Naval Battle** | The ship containing the fleet admiral has just routed |
| `battle_ship_sunk` | **Naval Battle** | Fired off when a ship has sunk |

## effects - the `effect` table; these CHANGE game state

13 entries.

| name | usage | what it does |
|---|---|---|
| `adjust_treasury` | `adjust_treasury(12000)` | Adjusts the treasury by the given amount |
| `advance_contextual_advice_thread` | `advance_contextual_advice_thread("Character_Agent_Assassin_Early_Advice_Thread", 4, context)` | Directs the advisor to consider issuing advice about the thread |
| `advance_scripted_advice_thread` | `advance_scripted_advice_thread("Character_Agent_Assassin_Early_Advice_Thread")` | Directs the advisor to advance the specified thread by score increase, issuing advice as appropriate |
| `advance_scripted_advice_thread_located` | `advance_scripted_advice_thread_location("Character_Agent_Assassin_Early_Advice_Thread", 1, 10.0f, 301.0f)` | Directs the advisor to advance the specified thread by score increase, issuing advice as appropriate with the specified location |
| `advice` | `advice("Click the unit to continue")` | Directs the advisor to display the supplied advice string - please use this for debug only since localisation is bypassed |
| `ancillary` | `effect.ancillary("mayor")` | Causes an ancillary to be created and attached to the character |
| `historical_character` | `historical_character("abraham_de_moivre")` | Adds the supplied historical character to the game |
| `historical_event` | `historical_event("3_colour_printing")` |  |
| `remove_ancillary` | `effect.remove_ancillary("mayor")` | Causes an ancillary to be removed from the character |
| `remove_trait` | `remove_trait("drink")` | Removes the specified trait (all levels), unless character has got passed "no going back" level of trait |
| `rewind_scripted_advice` | `rewind_scripted_advice()` | Resets all the scripted advice threads, such as those in the campaign tutorials, to zero |
| `suspend_contextual_advice` | `suspend_contextual_advice(true)` | Prevents contextual advice from being displayed - useful for tutorials |
| `trait` | `trait("drink", 5, 20)` | Possibly adds the points supplied to the trait listed for the given character |

### Parameters

**`adjust_treasury`** &mdash; `0x008A9770` (CA: Guy)

- amount

**`advance_contextual_advice_thread`** &mdash; `0x00461040` (CA: Guy)

- Advice thread, score increase, context

**`advance_scripted_advice_thread`** &mdash; `0x00E0DF90` (CA: Guy)

- Advice thread, score increase

**`advance_scripted_advice_thread_located`** &mdash; `0x00E0E030` (CA: Paul)

- Advice thread, score increase, location

**`advice`** &mdash; `0x00E0E0F0` (CA: Guy)

- Advice string

**`ancillary`** &mdash; `0x008AAC30` (CA: Tom)

- ancillary record key

**`historical_character`** &mdash; `0x008C9580` (CA: Paul)

- Historical character record key

**`historical_event`** &mdash; `0x008C97B0` (CA: Paul)

- Historical event record key

**`remove_ancillary`** &mdash; `0x008E9990` (CA: Tom)

- ancillary record key

**`remove_trait`** &mdash; `0x008E9F50` (CA: Tom)

- trait key

**`rewind_scripted_advice`** &mdash; `0x00E2A5A0` (CA: Guy)

- None

**`suspend_contextual_advice`** &mdash; `0x00E2EA40` (CA: Guy)

- Flag

**`trait`** &mdash; `0x008F5070` (CA: Tom)

- trait key, points to add, chance of adding

## campaign UI commands (the CampaignUI global)

339 entries.

| name | usage | what it does |
|---|---|---|
| `AgentCardSelectionChanged` |  | In: Agent pointer.  Notify the UI that an agent card has been selected so that the selection context can be updated |
| `AgentEmbarkOrDisembark` |  |  |
| `AgentGentlemanDuel` |  |  |
| `AgentRakeAssassinate` |  |  |
| `AgentRakeSubterfuge` |  |  |
| `AgentRogueSabotageArmy` |  |  |
| `AttachMovieToComponent` |  | In: Component to attach to, Path to movie to play |
| `AttachRadarView` |  | In: Component to attach to |
| `AutoManage` |  |  |
| `AvailableCommandersForRecruitment` |  |  |
| `BattleResultsRefresh` |  | Refresh data for the battle results screen |
| `BattleSetupShip` |  |  |
| `BattleSetupShipFromRecord` |  |  |
| `BattleSetupUnit` |  |  |
| `BattleSetupUnitFromRecord` |  |  |
| `BeginConstruction` |  | Begins construction of a building |
| `BeginResearch` |  | Start a university researching a technology |
| `BeginStealing` |  | Start a character stealing a technology |
| `BeginUpgrade` |  | Begins upgrading of a building |
| `BuildFort` |  |  |
| `BuildingBrowserDetails` |  | Fills in a building browser details table |
| `BuildingDetails` |  | initialises a table of details about the building specified |
| `BuildingEffects` |  | Fills in a table with a table list for each effects class |
| `BuildingPointer` |  |  |
| `BuildingRecordDetails` |  | initialises a table of details about the building specified |
| `CameraManager` |  | Out: Pointer to the camera manager |
| `CameraPosition` |  | Out: x,y,z of current camera position |
| `CameraTarget` |  | Out: x, y, z of current cameras target, y (height) is the zoom level |
| `CameraView` |  | Out: Bounding box of camera current view |
| `CampaignIsEpisodic` |  | Out: Returns true if the current played cmapign is an episodic |
| `CampaignKey` |  | Out: Return the database key for the current campaign |
| `CampaignModel` |  | Out: Pointer to the campaign model |
| `CanAgentEmbarkOrDisembark` |  |  |
| `CanArmyEmbarkOrDisembark` |  |  |
| `CanDemolishBuilding` |  |  |
| `CanDemoteUnit` |  |  |
| `CanDisbandUnit` |  |  |
| `CanEndTurn` |  | Can the player end the turn at this time? |
| `CanHostDropin` |  | Out: False if you cannot host a dropin battles (i.e. if Steam is running in offline mode) |
| `CanPromoteUnit` |  |  |
| `CanRecruitCommander` |  |  |
| `CanResearch` |  | Can a university research this tech |
| `CanSackMinister` |  |  |
| `CanSave` |  | Out: boolean flag to say if it is possible to save the campaign at this point |
| `CanSteal` |  | Can a character steal some tech |
| `CanUnitsMerge` |  | In: 2 unit pointers.  Out:  True if 2nd unit can merge into first, false if not |
| `CancelConstruction` |  | Cancels construction of a building |
| `CancelFortRepair` |  | Cancels repairing of a fort! |
| `CancelOrderForSelectedCharacter` |  | the currently selected character has it's order cancelled |
| `CancelRecruitment` |  | Removes a siege equipment item from the queue in the specified slot |
| `CancelResearch` |  | Stop a university researching a technology |
| `CancelSiegeEquipment` |  | Removes a recruited unit from the recruitment queue in the specified slot |
| `CancelStealing` |  | Stop a character stealing a technology |
| `CancelUpgradeFort` |  |  |
| `ChanceToSteal` |  | Returns the chance to steal a technology |
| `ChangeAdviceAudioMode` |  | Repeat the current advice on the c++ side |
| `ChangeAdviceTextMode` |  | Repeat the current advice on the c++ side |
| `ChangeIngameOptions` |  | Current game options will be read from preferences and sent to the game |
| `CharacterInEnemyResidence` |  |  |
| `CharacterInValidEnemyUniversity` |  |  |
| `CharacterPointer` |  |  |
| `CharacterResidence` |  |  |
| `CharacterSelectionChangeWithinGarrison` |  | Uses a unit from the army or navy tab to set the selection contexts character |
| `CharacterSelectionClearWithinGarrison` |  | Resets the select context back to the garrison type only |
| `CharactersRelationshipToPlayersFaction` |  |  |
| `ClearSecondarySelectionContext` |  | Clears any secondary selection context based on the primary selection context. Eg. Clears agents for characters, clears characters for slots. |
| `ClosestRegionToCamera` |  | Returns the closest region to the camera in the list |
| `ClosestSlotToCamera` |  | Returns the closest slot to the camera in the list |
| `ConstructBuildingTree` |  |  |
| `ContinueGameSelected` |  | Player chose to continue the game when presented with the Continue Game/End Game dialog after victory conditions achieved |
| `CurrentFactionIsHuman` |  | Returns whether the faction whose turn it is is controlled by a human or not |
| `CurrentGameOptions` |  | Out: Table of options as set in the players setup |
| `CurrentSeasonString` |  | Returns the current season name in string! |
| `CurrentTurn` |  | Out: Reports the current turn number |
| `CurrentYear` |  | Returns the current year for the grand campaign or the turn number for episodics |
| `DebugMessage` |  | In: msg to show (debug only) |
| `DebugViewLuaComponentPtr` |  | Passes a component point out to C so we can view it in debug |
| `DeclareWarInstant` |  | Instantly declare war without going through diplomatic process.  Takes two faction keys, faction A will declare war on faction B.  No responses will be given |
| `DeclineSidingWithAlly` |  | In: (Opt) Faction key of ally they aren't siding with. Local player declines a request to side with the ally.  If faction isn't present then declines both allies |
| `DefaultSaveName` |  | Out: String containing the default save game name for this campaign |
| `DefaultSaveNameMP` |  | Out: String containing the default MP save game name for this campaign |
| `DemolishBuilding` |  | Demolishes the selected building |
| `DemolishFort` |  |  |
| `DemoteAdmiral` |  |  |
| `DisbandUnit` |  | Disbands the specified unit |
| `DismissAdvice` |  | Dismiss the current advice. |
| `DismissCurrentAdvice` |  | Dismisses the current advice on the c++ side |
| `DisplayingTurns` |  | Out: Returns true if the current campaigns date should be displayed as turns |
| `DropInInterface` |  | Out: Pointer to a dropin interface to be passed to UIMPInterface object |
| `EnableShortcutHandler` |  | In: true/false to enable/disable all keyboard shortcuts |
| `EnableVoiceChat` |  | In: true/false to start/stop voice chat |
| `EndTurn` |  | No documentation |
| `EnqueueSiegeEquipment` |  | Places a siege equipment item in the queue |
| `EnterRevolutionaryRegion` |  | In:  |
| `EntityTypeSelected` |  | Returns a table with a valid boolean entry for the type of entity selected |
| `EnumerateCampaignSaves` |  | In: Save game directory, file extension, Out: Table of details about each save game found in the directory |
| `EnumerateMultiplayerCampaignSaves` |  | In: Save game directory, file extension, Out: Table of details about each save game found in the directory |
| `ExitPreBattleContinuingSiege` |  | The player chose to continue sieging |
| `FactionDetails` |  | Retrieve some details about the given faction (name, flag path, leader etc) - pass in faction db id |
| `FactionsUniversities` |  | A list of a factions universities or educational facilities |
| `FileExtenstionAndPathForWriteClass` |  | In: string identifying OSFS_WRITECLASS.  Out: File extension used by that class, directory files are kept in |
| `Finalise` |  |  |
| `FinaliseDuel` |  | Finishes a duel.  Weapon type should have been selected |
| `FinaliseExchange` |  | Gathers the list of units/agents/etc that are to be exchanged |
| `FinaliseMoveTransition` |  | In: Character to move, Units to move, Position moving from, Index of transition area to move to. |
| `FinalisePendingAction` |  | Called from various places to complete the pending action |
| `FinalisePendingDuel` |  | Finalise a duel, more specific version of the above command |
| `FormatString` |  | In: Formating string, string to format into it. Out: Formatted version |
| `FortDetails` |  | initialises a table of details about the fort specified |
| `FortEffects` |  | Fills in a table with a table list for each effects class |
| `GentlemanStealing` |  | Fills in a technology record table |
| `GetCurrentGameInfo` |  | Out: Details about the current state of the game for the save game dialog |
| `GetCurrentMPGameInfo` |  | Out: Details about the current state of the game for the save game dialog |
| `GetDropinFriendPref` |  | Out: Returns true/false depending on whether the player only wants friends in their dropin battles |
| `GetExtendedMPSaveGameInfo` |  | In: Path to save game, Out: Table of extra details about that save game |
| `GetExtendedSaveGameInfo` |  | In: Path to save game, Out: Table of extra details about that save game |
| `GovernorshipList` |  | Returns a table of entries containing details of all governorships for a given faction |
| `HighlightConstructionItem` |  |  |
| `HighlightRecruitmentItem` |  |  |
| `HoldElections` |  | Hold elections immeadiately |
| `HomeTheatre` |  | Return the db key of the theatre containing the home region of the faction specified |
| `InformAdviceReachedRender` |  | repeat the curently played advice |
| `InformLootingSelection` |  | Informs the UI of the looting selection |
| `InitialiseCharacterDetails` |  | initialises a table of details about the character specified |
| `InitialiseGovernmentDetails` |  | Creates a table containing information about the government |
| `InitialiseRecruitableUnitDetails` |  |  |
| `InitialiseRegionInfoDetails` |  | Returns a table of information about a given region (supplied by address).  If no address is supplied, then the current selected region is used |
| `InitialiseTechDetails` |  | initialises a table of details about the tech specified |
| `InitialiseUnitDetails` |  | Parameter passed can be either a UNIT*, a CAMPAIGN_CARD string id or a UNIT_RECORD string id |
| `InstigateAssassination` |  | In: Attacker, target (character pointers). Issues an assassination order |
| `InstigateDuel` |  | In: Attacker, target (character pointers). Issues a duel order |
| `InstigateSabotage` |  | In: Attacker, target building.  Issues the sabotage order |
| `InviteAlliesIntoWar` |  | Called after the player acknowledged that another faction has declared war on them |
| `IsAudioPlaying` |  | repeat the curently played advice |
| `IsCharacterInPortResidence` |  |  |
| `IsCharacterPlayerControlled` |  |  |
| `IsConstructionItemHighlighted` |  |  |
| `IsMergingUnit` |  |  |
| `IsMultiplayer` |  | Out: true/false - Are we playing a multiplayer campaign |
| `IsMultiplayerOttomansFrenchDiplomacy` |  | Returns true if the factions attempting to enter into diplomacy are the Ottomans and France in a multiplayer game |
| `IsPlayersTurn` |  | Returns a boolean to say whether or not it is currently the human players turn |
| `IsRecruitmentItemHighlighted` |  |  |
| `IsTimedMultiplayer` |  |  |
| `IsTimedMultiplayerGame` |  |  |
| `IsUnitMergePossible` |  | Out: Bool.  Are unit merges allowed at the moment |
| `KickMinister` |  | In: Address of character that we want to kick |
| `ListOfPlayersInGame` |  | Out: A table of the players |
| `LoadCampaign` |  | In: Full path to save game file |
| `LocalisationString` |  | Retrieve a string from the random localisation strings table |
| `MPChangeIngameOptions` |  | Current game options will be read from table provided and sent to the network |
| `MPInviteToGame` |  | In: Array of Steam Player Id's. |
| `MPOnlinePresence` |  | Out: Return a pointer to the online prescence |
| `MPSaveGame` |  | In: bool.  Overwrite if file exists.  String: "filename". Saves a multiplayer campaign game.  The filename field is actually encoded in the header and wont be the name the file is saved as |
| `MergeUnits` |  | Merges all of the units in this table. This method is used when the merge is caused by the merge key being pressed. |
| `MergeUnitsWithFirst` |  | Merges all of the units in this table into the first. This Method is used for the dropping of cards onto another. |
| `MinisterPortraitPath` |  | In: Faction key, Out: Path to a "random" ministers portrait |
| `MissionsDetails` |  |  |
| `MonarchyInfo` |  |  |
| `MoveIntoTarget` |  | In: Character (agent), character or settlement (target), bool (research - steal if enemy settlement) |
| `MovieDismissed` |  | Movie dismissed by Player |
| `MultiplayerBaseInterface` |  | Out: Pointer to the multiplayer control module (to be passed to UIMPInterface object |
| `MultiplayerBattleSelectionComplete` |  | Winks to the other player that this player has made his battle selection |
| `MultiplayerDropInInterface` |  | Out: Pointer to the dropin interface |
| `MultiplayerOtherPlayersName` |  | The name of the non local player |
| `MultiplayerPlayerOutOfTurn` |  | Returns true if this machine is a human player whos turn is it not |
| `MultiplayerPlayersName` |  | The name of this player |
| `MultiplayerPostBattleDismissed` |  | Winks to the other player that this player has made his battle selection |
| `MultiplayerSaveConfirm` |  | Winks to the other player to drop the save message |
| `MultiplayerTimeIsUp` |  |  |
| `MultiplayerTurnTimer` |  |  |
| `MultiplayerTurnTimespan` |  |  |
| `MultiplayerUnlimitedTurnBeginConfirm` |  |  |
| `NavalUnitLimit` |  | Out: Returns the maximum number of units allowed in a navy |
| `NextAdvice` |  | display the next piece of advice |
| `NextAutoEntitySelection` |  | Moves the auto viewer to the next entity |
| `NextAutoSettlementSelection` |  | Moves the auto viewer to the next settlement |
| `NextExportTradeProblem` |  | Moves the camera to the next position on a trade route causing reduced trade income |
| `NextSupplyTradeProblem` |  | Moves the camera to the next position on a trade route causing reduced trade income |
| `OptimizeShip` |  | Optimizes the ships crew |
| `PauseCampaign` |  | In: Boolean, pause/unpause |
| `PlayDropInBattle` |  | In: is_land, is_siege, Out: Starts up hosting a drop in battle |
| `PlayerChoosesRevolutionSide` |  |  |
| `PlayerFactionId` |  | Retrieve the db key of the players faction (can be passed to GetFactionDetails etc |
| `PlayerFactionIsTribal` |  |  |
| `PlayerHasFunds` |  | Checks the player has enough funds |
| `PlayerIgnoresBankruptcy` |  |  |
| `PlayerInControl` |  | In: nothing. Out: bool if player is in control. |
| `PlayerOwnedUnit` |  |  |
| `PlayerPlayingAsRevolutionaries` |  | Out:  True if the player sided with the revolutionaries after a revolution |
| `PlayerSelected` |  | In: none, Out: true if player action caused the last object selected event |
| `PlayerSidesWithRevolutionaries` |  |  |
| `PlayerSurrenderDecision` |  |  |
| `PlayerUnitTypeCount` |  |  |
| `PlayersCulture` |  | Out: string (players culture database key |
| `PlayersFaction` |  | Passes the players facition ptr to lua |
| `PlayersFactionKey` |  | Passes the players facition key to lua |
| `PostNavalBattleRefresh` |  |  |
| `PostNavalBattleSetupValid` |  | Is the setup valid in its current state |
| `PreBattleAttack` |  | Start the battle immediately |
| `PreBattleAutoResolve` |  | Auto resolve the battle |
| `PreBattleDemandSurrender` |  | Demand the besieged surrender |
| `PreBattleNightAttack` |  | Fight the battle during night-time |
| `PreBattleRetreat` |  | Retreat from the attack |
| `PreBattleSiegeAttack` |  |  |
| `PreBattleSiegeAutoResolve` |  |  |
| `PreBattleSiegeNightAttack` |  |  |
| `PrestigeDetails` |  | Fills in a prestige details table |
| `PreviousAdvice` |  | display the previous piece of advice |
| `PreviousAutoEntitySelection` |  | Moves the auto viewer to the previous entity |
| `PreviousAutoSettlementSelection` |  | Moves the auto viewer to the previous settlement |
| `PromoteUnits` |  |  |
| `QuickLoad` |  | Loads the most recently saved campaign game |
| `QuickSave` |  | Campaign will be saved to the default quick save location |
| `QuitToMainScreen` |  | No documentation |
| `QuitToWindowsFromEscapeMenu` |  | No documentation |
| `RadarZoomIn` |  | Sets the radar zoom level if possible |
| `RadarZoomOut` |  | Sets the radar zoom level if possible |
| `RecruitUnit` |  | Places a recruitable unit in the recruitment queue |
| `RegimentName` |  |  |
| `RegionFromSelection` |  |  |
| `RegionKeyFromAddress` |  |  |
| `RegionKeyFromSlot` |  |  |
| `RegionTaxDetails` |  | In: Region pointer, Out: Table of details about wealth and taxes for this region |
| `RegionsGovernorship` |  | Takes the address of a region and returns the name of the governorship that the region is in |
| `RegionsInTheatre` |  | Initialise a table with details about each region in the specified theatre |
| `RegionsOwnedByFactionOrByProtectorates` |  | Initialise a table listing all regions owned by a faction by address and localised name |
| `RegionsPublicOrders` |  | Returns the public order in the region |
| `RemainingTimeToDrop` |  |  |
| `RepairBuilding` |  | Repairs the selected building |
| `RepairFort` |  |  |
| `RepeatAdvice` |  | Repeat the current advice on the c++ side |
| `RequestAssassinationTargets` |  | In: Character performing the action, Character or Garrison residence pointer.  Out.  Table of suitable characters.  Ask the game for suitable sabotage targets and show the sabotage target picker |
| `RequestDuelTargets` |  | In: Character performing the action, Character or Garrison residence pointer.  Out.  Table of suitable characters.  Ask the game for suitable sabotage targets and show the sabotage target picker |
| `RequestSabotageTargets` |  | In: Character performing the action, Garrison residence pointer.  Out.  Table of suitable buildings.  Ask the game for suitable sabotage targets and show the sabotage target picker |
| `RetrieveContainedEntitiesFromCharacter` |  | Retrieve various lists of exchangeable entities from the character |
| `RetrieveContainedEntitiesFromGarrison` |  | Retrieve various lists of exchangeable entities from the garrison |
| `RetrieveDiplomacyDetails` |  | Return a table containing allies, enemies and trade partners of the given faction |
| `RetrieveDiplomaticOpinions` |  | Return 2 strings representing each factions opinion of each other |
| `RetrieveDiplomaticStanceString` |  | Takes the db keys for two factions and returns a string representing the diplomatic stance of them (i.e. at war etc) |
| `RetrieveExistingTreaties` |  | Returns any treaties in place between the 2 factions |
| `RetrieveFactionAgentsList` |  | In: Faction key, Out: List of details of all agents in the faction specified |
| `RetrieveFactionListForDiplomacy` |  | Builds a table with a few details about each faction in the game |
| `RetrieveFactionMilitaryForceLists` |  | In: Faction, bool ( true = armies/ false = navies, Out: Retrieves the details of all the military forces of the types specified for the given faction |
| `RetrieveFactionRegionList` |  | In: Faction key, Out: Table of all regions owned by faction |
| `RetrieveGameCore` |  | Out: Returns pointers to the game core so that a UIPrefsInterface object can be initialised |
| `RetrieveGovernorshipDetails` |  | Get the details for a given governorship.  Need to pass in the name of the governorship |
| `RetrieveRemainingMilitaryAccessTurns` |  | Returns the remaining value of the military access |
| `RetrieveVisibleEnitityDetails` |  | Returns the details of all the campaign map entities (settlements, characters etc), that are currently visible in the camera view |
| `ReturnToCampaignFromEscapeMenu` |  | No documentation |
| `RevertShipsToPrize` |  | Moves ships back to the prize pool |
| `ReviewPanelInfo` |  |  |
| `ReviewPanelTabSelectionSet_1_Indexed` |  | Invokes a tab selection for the review panel |
| `SabotageArmy` |  | In: Character (agent), target character (general) |
| `SaveCampaign` |  | In: Full path to place to save game, bool: Confirm overwrite. Out: true if overwrite request is requested and needed.  false, save success if overwrite not requested or not needed |
| `ScreenSize` |  | Retrieve the current width and height of the screen |
| `ScrollCamera` |  | scroll the camera along a spline. ScrollCamera(seconds_it_takes_to_complete, list_of_coodinates...) |
| `ScupperToggleShip` |  | Scuppers or Unscuppers the ship |
| `SelectAndZoomToCharacter` |  | In: The horizontal focus position, EG. -1 for right centred and +1 for left centred. Address of a character to select |
| `SelectAndZoomToNextRegion` |  |  |
| `SelectAndZoomToPreviousRegion` |  |  |
| `SelectAndZoomToRegion` |  | In: Address of a region to select (actually selects settlement) |
| `SelectAndZoomToSlot` |  | In: The horizontal focus position, EG. -1 for right centred and +1 for left centred. Key of a region. Key of a slot to select |
| `SetAutomanageConstruction` |  | Switches on/off the automanagement of the construction for a specified theatre |
| `SetAutomanageTaxes` |  | Switches on/off the automanagement of the taxes for a specified theatre |
| `SetCameraTarget` |  | Move the camera to the look at the specified theatre/map position.  Takes either the name of the theatre, or x, y position, + optional positioning factor (-1 = right centred, +1 = left centered) |
| `SetCameraTargetInstant` |  | Move the camera to the look at the specified theatre/map position instantly.  Takes either the name of the theatre, or x, y position, + optional positioning factor (-1 = right centred, +1 = left centered) |
| `SetCameraZoom` |  | Zoom the camera, takes a float, currently clamped at 1.2 - 0.675, see CAMPAIGN_CAMERA_MAXIMUM_TILT_ANGLE and CAMPAIGN_CAMERA_MINIMUM_TILT_ANGLE |
| `SetDropinFriendPref` |  | In: true/false to set whether the player only wants friends in their dropin battles |
| `SetGovernorshipTaxRate` |  | Sets the tax rate for a specified class and theatre |
| `SetMyUnitName` |  |  |
| `SetRegionTaxed` |  | Sets the region to be taxed (or not) |
| `SetReinforcementsOrder` |  | Sets the reinforcement order for a combatant character |
| `SetSuccessor` |  |  |
| `SettlementsRegion` |  | In: Settlement pointer, Out: Region pointer |
| `ShouldShowLabelBottomRow` |  | In: Settlement pointer, Out: Selected settlement, mouse over settlement |
| `ShowBuildingInfoOnDblClick` |  | Dbl click response to clicking on a campaign slot |
| `ShowExchangeScreenForDockedNavy` |  | In: Pointer to commander of either the docked navy or the port garrisoned army |
| `ShowVoiceChat` |  | Returns whether voice chat can be displayed |
| `SideWithAlly` |  | In: Faction key of ally to side with |
| `SlotKeyFromAddress` |  |  |
| `SplitFromForce` |  | Takes a table of unit pointers and a table of character pointers and splits them from their current force, placing them at the map position that the cursor is over |
| `SpyingDataLevelCharacter` |  | Returns the spying data level for this character |
| `SpyingDataLevelUnit` |  | Returns the spying data level for this unit |
| `StateGiftValues` |  | Out: A table of 3 values representing the various values for state gifts |
| `SteamFriendsList` |  | In: Bool - show clan members Out: List of details about appropriate friends listed on Steam |
| `StopCamera` |  | Stop a scrolling camera. |
| `StopMovieInComponent` |  | In: Component movie is playing in |
| `SwapMinisters` |  | In: Character pointers for minister A & minister B.  Ministers will have their posts swapped |
| `TakePrizeShips` |  | Moves captured ships into the navy |
| `TechEffects` |  | Fills in a table with a table list for each effects class |
| `TechnologyPlayerDetails` |  | Fills in a technology details table for the players faction |
| `TechnologyResearchingDetails` |  | Fills in a technology details table for the players faction |
| `TechnologyStealingDetails` |  |  |
| `TheatreList` |  | Initialise a table with a list of all theatres available in the game |
| `TheatreMapDimensions` |  | Returns the world offset, width & height of the specified theatre map (x, y, w, h) |
| `TheatreMapPaths` |  | In: Theatre id, Out: Table containing paths to map, overlay and radar images |
| `Time` |  | Returns the current models time in seconds |
| `TimeSinceTick` |  | Returns the time passed since the last communication with the other player |
| `ToggleFlagDisplay` |  | Toggles the flag display on the campaign map |
| `ToggleLabels` |  | Toggles that labels under settlements on/off |
| `ToggleMoveSpeed` |  | Toggles the action speed on the campaign map |
| `ToggleReplenishUnit` |  | Toggles the replenish or repair command for the specified unit |
| `ToggleSFX` |  | Toggles the flag display on the campaign map |
| `TradeInfo` |  | Gathers the trade info for the players faction |
| `TriggerAdviceForPanel` |  | In: Name of panel |
| `TriggerBuildingCardSelectedEvent` |  | In: key of the building selected |
| `TriggerBuildingInfoPanelOpenEvent` |  | In:  |
| `TriggerCharacterInfoPanelOpenedEvent` |  | In: Pointer to character |
| `TriggerMessageDropEvent` |  | Plays the sound that occurs when a message hits the bottom of the msg stack |
| `TriggerMessageOpenedEvent` |  | In: Message id |
| `TriggerPanelClosedEvent` |  | In: Name of panel |
| `TriggerPanelOpenEvent` |  | In: Name of panel |
| `TriggerTechnologyInfoPanelOpenEvent` |  | In:  |
| `TriggerTooltipAdvice` |  | In: Component that the tooltip currently represents |
| `TriggerUnitSelectedEvent` |  | In: Pointer to unit selected |
| `TurnsToCompleteResearchingTechnology` |  | Number of turns a character is going to take to finish researching a technology |
| `TurnsToResearch` |  | Returns that how many turns necessary to research the technology |
| `UILocalisationString` |  | Retrieve a string from the ui.loc file |
| `UnitPointer` |  |  |
| `UnitScaleFactor` |  | In: (Opt) current scale factor, Out: float value representing current unit scale, index into scale factors list : 0-3 |
| `UnitSelectionChanged` |  | In: List of selected unit.  Notify the UI that the unit selection has changed so the selection context can be updated |
| `UnitTransporting` |  |  |
| `UniversityResearching` |  | Fills in a technology record table |
| `UpdateRadarView` |  | In: Table of update details |
| `UpgradeFort` |  |  |
| `Valid` |  | Is the UI open |
| `ValidAsassinationTargetsInResidence` |  |  |
| `ValidAssassinationTargets` |  |  |
| `ValidDuelTargetsInResidence` |  |  |
| `ValidSabotageArmyTarget` |  |  |
| `ValidSabotageTarget` |  |  |
| `WindowsTime` |  | Returns the current windows time in seconds |
| `ZoomToAdviceLocation` |  | Dismisses the current advice on the c++ side |
| `ZoomToCapital` |  | Move the camera to your capital |
| `ZoomToCharacter` |  | In: Address of a character to select |
| `ZoomToRegion` |  | In: Address of a region to zoom to (without selecting it) |
| `ZoomToUnit` |  | In: Address of a unit to select |
| `pending_auto_show_messages` |  | Return if any auto shown messages are queued |
| `shown_message` |  | Return if any message boxes currently displayed |

## battle script commands (battle lua_State only)

218 entries.

| name | usage | what it does |
|---|---|---|
| `AddUnitsToGroup` |  | Takes a table of unit addresses, and a group id and adds the units to the group specified |
| `Anchor` |  |  |
| `BackProjectPosition` |  | In: x,y,z, height adjustment.  Out: x,y z depth to move Component to, distance from camera |
| `BattleDetails` |  | Get some details about the battle.  For the time being this is whether it is a naval battle, and the players faction details |
| `BattleEditorPause` |  | No documentation |
| `BattleEditorUnpause` |  | No documentation |
| `BattleEditorVisibleState` |  | No documentation |
| `Board` |  |  |
| `BroadsideMouseEvent` |  |  |
| `Broadside_Left_Issue_Order` |  |  |
| `Broadside_Right_Issue_Order` |  |  |
| `Broadside_Update` |  |  |
| `CameraFocusOnSelection` |  | Takes the address of a unit.  Zooms the camera over to look at the unit specified.  Doesn't currently work in naval battles |
| `CameraZoomTo` |  | In: Position (x,y,z), facing |
| `CameraZoomToPictureInPictureLocation` |  | When the Picture in Picture is displayed, clicking this will zoom the camera to its location |
| `CameraZoomToSelection` |  | Takes the address of a unit.  Zooms the camera over to look at the unit specified.  Doesn't currently work in naval battles |
| `CancelOrderForSelection` |  | Cancel order for selected units |
| `ChangeAdviceAudioMode` |  | Repeat the current advice on the c++ side |
| `ChangeAdviceTextMode` |  | Repeat the current advice on the c++ side |
| `ClearDeployableItemsPanel` |  | checks if a unit is selectable |
| `Column_Infantry_Vanguard` |  |  |
| `CombatRatioDetails` |  | Out: Returns a table of details about each pair of units that need the combat ratio display |
| `CreateUnitGroup` |  | Takes a table of unit address to build a group from, returns the id of the new group |
| `Crescent_Attack` |  |  |
| `Crescent_Envelop` |  |  |
| `Current_Selection_Detonate_Fougasse_Basic` |  |  |
| `Current_Selection_Detonate_Fougasse_Improved` |  |  |
| `Current_Selection_Enable_Accuracy_Boost` |  |  |
| `Current_Selection_Enable_Canister_Shottype` |  |  |
| `Current_Selection_Enable_Carcass_Shottype` |  |  |
| `Current_Selection_Enable_Deploy_Stakes` |  | Currently selected units deploy stakes |
| `Current_Selection_Enable_Diamond_Formation` |  |  |
| `Current_Selection_Enable_Dismount` |  |  |
| `Current_Selection_Enable_Explosive_Shell` |  |  |
| `Current_Selection_Enable_Fire_And_Advance` |  | Currently selected units enable/disable the fire and advance order.  Takes true or false. |
| `Current_Selection_Enable_Fire_At_Will` |  |  |
| `Current_Selection_Enable_Grenade_Shottype` |  |  |
| `Current_Selection_Enable_Guard` |  |  |
| `Current_Selection_Enable_Hot_Shottype` |  |  |
| `Current_Selection_Enable_Improved_Grenades` |  | Currently selected units select improved grenades.  Takes true or false. |
| `Current_Selection_Enable_Inspire_Unit` |  | Currently selected units try to rally nearby units.  Takes true or false. |
| `Current_Selection_Enable_Light_Infantry_Behaviour` |  |  |
| `Current_Selection_Enable_Limber` |  |  |
| `Current_Selection_Enable_Loose_Formation` |  |  |
| `Current_Selection_Enable_Melee` |  |  |
| `Current_Selection_Enable_Melee_Formation` |  |  |
| `Current_Selection_Enable_Percussive_Shell` |  | Currently selected units enable/disable percussive shells.  Takes true or false. |
| `Current_Selection_Enable_Pike_Square_Formation` |  |  |
| `Current_Selection_Enable_Pike_Wall_Formation` |  |  |
| `Current_Selection_Enable_Plug_Bayonets` |  |  |
| `Current_Selection_Enable_Prone_Formation` |  |  |
| `Current_Selection_Enable_Quicklime_Shottype` |  |  |
| `Current_Selection_Enable_ROF_Boost` |  |  |
| `Current_Selection_Enable_Ring_Bayonets` |  | Currently selected units enable/disable ring bayonets.  Takes true or false. |
| `Current_Selection_Enable_Rockets_Shottype` |  |  |
| `Current_Selection_Enable_Shot_Shottype` |  |  |
| `Current_Selection_Enable_Shrapnel_Shottype` |  |  |
| `Current_Selection_Enable_Skirmish` |  |  |
| `Current_Selection_Enable_Spike` |  | Currently selected units perform the spike order |
| `Current_Selection_Enable_Square_Formation` |  |  |
| `Current_Selection_Enable_Wedge_Formation` |  |  |
| `Current_Selection_Halt` |  |  |
| `Current_Selection_Increase_File` |  |  |
| `Current_Selection_Increase_File_Proxy` |  |  |
| `Current_Selection_Increase_Rank` |  |  |
| `Current_Selection_Increase_Rank_Proxy` |  |  |
| `Current_Selection_Move_Backwards` |  |  |
| `Current_Selection_Move_Backwards_Proxy` |  |  |
| `Current_Selection_Move_Forwards` |  |  |
| `Current_Selection_Move_Forwards_Proxy` |  |  |
| `Current_Selection_Proxy_Rotate_Left` |  |  |
| `Current_Selection_Proxy_Rotate_Right` |  |  |
| `Current_Selection_Proxy_Turn_Left` |  |  |
| `Current_Selection_Proxy_Turn_Right` |  |  |
| `Current_Selection_Rally_Units` |  | Currently selected units try to rally nearby units.  Takes true or false. |
| `Current_Selection_Rotate_Left` |  |  |
| `Current_Selection_Rotate_Right` |  |  |
| `Current_Selection_Runs` |  |  |
| `Current_Selection_Special_ability` |  |  |
| `Current_Selection_Turn_Left` |  |  |
| `Current_Selection_Turn_Right` |  |  |
| `Current_Selection_Walks` |  |  |
| `CycleBattleSpeed` |  | Returns the current time multiplier of the battle |
| `Decrease_Sail` |  |  |
| `DeploymentFinishYesStart` |  | Returns true if we're in conflict mode |
| `DestroyUnitGroup` |  | Takes the id of a unit group as returned by the create function and removes it from the game |
| `DisableChevaux` |  | DisableChevaux |
| `DisableEarthworks` |  | Retrieve the current width and height of the screen |
| `DisableFougasse` |  | Retrieve the current width and height of the screen |
| `DisableFougasseImproved` |  | Retrieve the current width and height of the screen |
| `DisableGabionade` |  | DisableGabionade |
| `DismissCurrentAdvice` |  | Dismisses the current advice on the c++ side |
| `Double_Line_Screened` |  |  |
| `Double_Line_Standard` |  |  |
| `DropInInterface` |  | Out: Should always return null pointer as it shouldn't be used.  Only included for the sake of generic code |
| `ElapsedBattleTime` |  | Returns the current time in seconds |
| `EnableChevaux` |  | EnableChevaux |
| `EnableEarthworks` |  | Retrieve the current width and height of the screen |
| `EnableFougasse` |  | Retrieve the current width and height of the screen |
| `EnableFougasseImproved` |  | Retrieve the current width and height of the screen |
| `EnableGabionade` |  | EnableGabionade |
| `EnableShortcutHandler` |  | In: true/false to enable/disable all keyboard shortcuts |
| `EnableVoiceChat` |  | In: true/false to start/stop voice chat |
| `EntityDisplayInterface` |  | Out: Returns a pointer to the EntityDisplay |
| `EnumerateBattleReplays` |  | In: replay directory, file extention.  Out: Table of details about each replay file found in the directory |
| `ExitBattle` |  | set to normal tick speed and finishes the battle |
| `ExplicitlyCancelMouseHeld` |  | forces to UI to think the mouse left button is no longer held. Used when a panel is open that takes focus |
| `Ffwd` |  |  |
| `FileExtenstionAndPathForWriteClass` |  | In: string identifying OSFS_WRITECLASS.  Out: File extension used by that class, directory files are kept in |
| `FindImagePath` |  | Tells us what the currently selected Ui skin is (which should equate to the sub-folder used |
| `Fire_At_Will` |  |  |
| `Fwd` |  |  |
| `GetHealthStatus` |  | Update the killometer bar |
| `Go_Straight` |  |  |
| `HasEnteredDeployment` |  | Returns true if we're in deployment (not default deployment) mode |
| `Increase_Sail` |  |  |
| `InformAdviceReachedRender` |  | repeat the curently played advice |
| `InformOfBattleSummaryDismiss` |  | local player has dismissed the summary |
| `InformOfDeploymentCountdownBegun` |  | local player has dismissed the summary |
| `InformOfDeploymentFinished` |  | local player has dismissed the summary |
| `IsAudioPlaying` |  | repeat the curently played advice |
| `IsCampaignBattle` |  | Out: True if this battle was started from the campaign map |
| `IsConflict` |  | Returns true if we're in conflict mode |
| `IsDeploymentOrConflict` |  | Returns true if we're in conflict mode |
| `IsMinimisedHUD` |  | If it's minimised HUD |
| `IsMultiplayer` |  | Out: True if this is a multiplayer battle |
| `IsReplay` |  | If it's a replay |
| `IsSpectator` |  | If it's a spectator |
| `IsTimedMultiplayerGame` |  |  |
| `IsTutorial` |  | Out: true if we are running a tutorial battle |
| `IsUnitSelectable` |  | checks if a unit is selectable |
| `Land_Unit_Withdraw` |  |  |
| `Line_Abreast` |  |  |
| `Line_Astern` |  |  |
| `ListOfPlayersInGame` |  | Out: A table of the players |
| `LocalisationString` |  | Retrieve a string from the random localisation strings table |
| `MPOnlinePresence` |  | Out: Pointer to the online presence that exists in game core |
| `MPRematchVotes` |  | Gets the current number of votes to have a rematch |
| `MPRestartPossible` |  | If someone left the lobby then we can't restart |
| `MPRestartSwappedPossible` |  | If someone left the lobby then we can't restart |
| `MPResultsReady` |  | Checks to see if the MP battle results have been collected |
| `MPSwapVotes` |  | Gets the current number of votes to swap sides |
| `MPVoteRestart` |  | Player votes |
| `MPVotingComplete` |  | Checks for everyone having voted |
| `MouseMovedOffCard` |  | Notify the game that unit selection has changed |
| `MouseMovedOntoCard` |  | Notify the game that mouse has moved over this card |
| `Move_Camera` |  | Move Camera |
| `Move_Selection_To_Rader_Location` |  | Move Camera |
| `MultiplayerBaseInterface` |  | Out: Pointer to the multiplayer control module (to be passed to UIMPInterface object |
| `Naval_Unit_Withdraw` |  |  |
| `NextAdvice` |  | display the next piece of advice |
| `NextAvailableGroupID` |  | Takes the id of a unit group as returned by the create function and removes it from the game |
| `NotifyCameraControlsChanged` |  | this is for lua to change the camera (key controls handled by shortcut handler |
| `NotifyUIOptionsChanged` |  | this is for lua to change the camera (key controls handled by shortcut handler |
| `NumHumansRequestingNextPhase` |  | the number of Human players Requesting Next battle Phase |
| `Pause` |  |  |
| `Play` |  |  |
| `PostBattleDismissContinueBattle` |  | local player has dismissed the summary |
| `PostBattleDismissEndBattle` |  | local player has dismissed the summary |
| `PostBattleInfo` |  | Fetches the post battle info from the game and Alexs' MP API |
| `PreviousAdvice` |  | display the previous piece of advice |
| `Ram` |  |  |
| `ReleaseMouseCursorInterrupt` |  | forces to UI to think the mouse left button is no longer held. Used when a panel is open that takes focus |
| `RemainingTimeToDrop` |  | Out: True if this is a multiplayer battle |
| `RemoveUnitsFromGroup` |  | Takes a table of unit addresses, and removes the units from the group they are in |
| `Repair` |  |  |
| `RepeatAdvice` |  | repeat the curently played advice |
| `Repel` |  |  |
| `RequestMouseInterruptType` |  | forces to UI to think the mouse left button is no longer held. Used when a panel is open that takes focus |
| `ResizeMinimap` |  | Fetches the post battle info from the game and Alexs' MP API |
| `RetrieveGameCore` |  | Out: Returns pointers to the game core so that a UIPrefsInterface object can be initialised |
| `SaveReplay` |  | In: battle replay file name |
| `ScreenSize` |  | Retrieve the current width and height of the screen |
| `SelectAllArtillery` |  | select units of this type |
| `SelectAllCavalry` |  | select units of this type |
| `SelectAllInfantry` |  | select units of this type |
| `SelectAllMelee` |  | select units of this type |
| `SelectUnitBasedOnUnitType` |  | Change the selection based on a unit class |
| `SelectionChanged` |  | Notify the game that unit selection has changed |
| `SetSelectionProxy` |  | Takes the address of the entity (ship/unit) and a boolean flag and sets the proxy display for that entity as appropriate |
| `Shot_Chain` |  |  |
| `Shot_Grape` |  |  |
| `Shot_Waterline` |  |  |
| `ShowVoiceChat` |  | Returns whether voice chat can be displayed |
| `Single_Line_Cavalry_Left_Flank` |  |  |
| `Single_Line_Cavalry_Right_Flank` |  |  |
| `Single_Line_Standard` |  |  |
| `Slow` |  |  |
| `SquadInfoByPointer` |  | Notify the game that mouse has moved over this card |
| `Stop_Rotating_Rendering` |  |  |
| `TickPeriod` |  | Returns the current time multiplier of the battle |
| `Time` |  | Returns the current time in seconds |
| `ToggleMinimisedCards` |  | Toggles cards on and off |
| `ToggleMinimisedOrders` |  | Toggles orders on and off |
| `ToggleMinimisedRadar` |  | Toggles radar on and off |
| `ToggleMusic` |  | Toggles Music on and off |
| `ToggleSFX` |  | Toggles SFX on and off |
| `ToggleShipFiringArcs` |  | Toggle the display of ship firing arcs |
| `TriggerAdviceForPanel` |  | In: Name of panel |
| `TriggerMessageDropEvent` |  | Plays the sound that occurs when a message hits the bottom of the msg stack |
| `TriggerMessageOpenedEvent` |  | In: Message id |
| `TriggerPanelClosedEvent` |  | In: Name of panel |
| `TriggerPanelOpenEvent` |  | In: Name of panel |
| `Triple_Line_Grand_Battery` |  |  |
| `Triple_Line_Integrated_Artillery` |  |  |
| `Triple_Line_Standard` |  |  |
| `UILocalisationString` |  | Retrieve a string from the ui.loc file |
| `UISkin` |  | Tells us what the currently selected Ui skin is (which should equate to the sub-folder used |
| `UnitListForBattleIds` |  | Out: Returns a list of BattleUnit instances representing all units in the battle that need a battle id displaying |
| `UnitScaleFactor` |  | In: (Opt) current scale factor, Out: float value representing current unit scale, index into scale factors list : 0-3 |
| `UpdateBattleLocks` |  | Updates the battle sequences if any are appropriate for this battle |
| `Valid` |  | Is the UI open |
| `WindDirection` |  | Update the wind pointer |
| `WindowsTime` |  | Returns the current time in seconds |
| `ZoomToAdviceLocation` |  | Moves the camera the current advice on the c++ side |
| `ZoomToGeneral` |  | checks if a unit is selectable |
| `ZoomToUnit` |  | Zoom the camera over to a particular unit |
| `show_allied_units_proxies` |  |  |

## frontend / menu commands

118 entries.

| name | usage | what it does |
|---|---|---|
| `AreFriendsStatsDownloading` |  | Out: true/false if the stats are downloading or not |
| `ArmyFundsForSize` |  | In: Integer value representing size of army (0-2).  bool: is naval.  Out: Allowed funds for that size |
| `BattleMapDetailsFromPreviousSetup` |  | In: Pointer to a battle setup object.  Out: Table of details about the setups map |
| `BattleTypeString` |  | In: string identifying a battle type, Out: Localised form of that string |
| `BattleTypesFilterString` |  | Out: Enumerate supported battle types in a form suited for a dropdown list |
| `BattleWeatherAndTimeOfDayOptionsString` |  | In: Battle record key, Out: Dropdown menu formated options strings for weather and time of day |
| `BuildCpuName` |  | In: cpu id number.  Out: Formatted name string |
| `BuildCredits` |  | In: Parent Component.  Out: Height of all the credits. Credits file will be parsed and added as children to the parent |
| `BuildInfoSetup` |  | Builds a table of information required by the UIBattleSetupObject |
| `CampaignDetails` |  | Retrieves various details about the specified campaign |
| `CampaignSavesExist` |  | Out: Flag to indicate whether any campaign save games exist on disk |
| `CancelHostedGame` |  | Cancel the hosted game |
| `ClearPreviousSetup` |  | Clears any previous battle setup |
| `CloseMapDataFile` |  |  |
| `ContinueCampaign` |  | Load the most recently saved campaign game |
| `DefaultPrefsForBattle` |  | In: xml file battle specification. Out: Table of details about season, time of day and weather |
| `DropInInterface` |  | Out: Pointer to a dropin interface to be passed to UIMPInterface object |
| `EnableCreditScreenMusic` |  | In: boolean |
| `EnableVoiceChat` |  | In: true/false to start/stop voice chat |
| `EnumerateArmySetups` |  | In: Directory, file extension, Current era, current army size, current_unit_limit (from unit scale), allowed factions. Out: Lists unit saves that are complient with the settings provided |
| `EnumerateBattleMaps` |  | Find all the battle maps of a given type |
| `EnumerateBattleReplays` |  | In: replay directory, file extention.  Out: Table of details about each replay file found in the directory |
| `EnumerateCampaignSaves` |  | In: Save game directory, file extension, Out: Table of details about each save game found in the directory |
| `EnumerateCampaigns` |  | In: Boolean - Enumerate episodic campaigns (or grand campaigns)? Out: Table of details about each episodic campaign available |
| `EnumerateMultiplayerCampaignSaves` |  | In: Save game directory, file extension, Out: Table of details about each save game found in the directory |
| `EnumerateNapoleonsBattleMaps` |  | Find all the battle maps of a given type |
| `EnumerateNapoleonsCampaigns` |  | Out: Table of details about each of napoleons campaigns |
| `FactionDetails` |  | In: Faction key (string), era enum Out: Details from the faction record |
| `FactionListForBattles` |  | In: IsNaval (boolean), era value (0,1), Out: List of details about all factions defined in the database that have mp_available set to true |
| `FileExtenstionAndPathForWriteClass` |  | In: string identifying OSFS_WRITECLASS.  Out: File extension used by that class, directory files are kept in |
| `FormatMinutesString` |  | In: number of minutes, Out: Format time string (%d minutes |
| `FrontEnd` |  | Out: Returns a pointer to the frontend object |
| `FullUnitInformation` |  | In: Unit record key, faction record key, is_late_era, Out: Information about that unit that is required for the unit information panel |
| `GameVersion` |  | Out: Current game version number |
| `GenerateRegionOwnershipMaps` |  | In: Table of expected theatres, Campaign key, Faction key (opt: faction 2 key), Out: Table of images depicting region ownership for that faction in each theatre |
| `GenerateShipName` |  | In: Faction, unit class.  Out: A randomly generated ship name string |
| `GetExtendedMPSaveGameInfo` |  | In: Path to save game, Out: Table of extra details about that save game |
| `GetExtendedSaveGameInfo` |  | In: Path to save game, Out: Table of extra details about that save game |
| `GetWaterlooBattleDetails` |  | OUt: title, description, specification and unlock status of the waterloo battle |
| `ListOfPlayersInGame` |  | Get list of players  |
| `LoadArmySetup` |  | In: Path of file to load, Out: Table of army details |
| `LoadBattleReplay` |  | In: Path to replay to load |
| `LoadBattleSetup` |  | In: Filename to load.  Out: Table of preferences and army lists or nil on failure |
| `LoadCampaign` |  | In: Path to campaign file to load |
| `LocalPlayerName` |  | Out: Retrieve the name of the player |
| `LocalisationString` |  | Retrieve a string from the random localisation strings table |
| `LocalisedGameTypeString` |  | In: Selected Campaign victory condition type (1 based), Out: Localised string for that game type |
| `MPCampaignEnabled` |  | Out: Returns true if mp campaign is enabled |
| `MPCampaignSavesExist` |  | Out: Flag to indicate whether any multiplayer campaign save games exist on disk |
| `MPCanCancelQuickBattle` |  | Out: Returns whether we have passed the point of no return when looking for quick battles |
| `MPChangeRoom` |  | In: Room id |
| `MPCurrentGameDetails` |  | Out: Details of the current game (preferences as set by host), or nil if not in a game |
| `MPExperienceTables` |  | In: bool to specify land/naval battle modifiers (true if naval), Out: Table of fixed cost, multiplier tables for experience levels 0-9 |
| `MPGameInfoList` |  | In: boolean, battle or campaign.  Out: Table of details for all the mp games active for that mode, for the time being, in a single room |
| `MPHasGameInvite` |  | Out: Returns true if there is a game invite pending |
| `MPHasLobby` |  |  |
| `MPHostCampaign` |  | In: Game name and password, year and season. Out: Boolean success value |
| `MPHostCustomBattle` |  | In: Table containing: Game map path, map_name, game name, password, max_players, ranked, customise_armies, battle type, army_size (as int).  Hosts a battle. |
| `MPInterface` |  | Out: Pointer to the multiplayer control module (to be passed to UIMPInterface object |
| `MPInviteToGame` |  | In: Array of Steam Player Id's. |
| `MPIsJoiningByInvite` |  | Out: Boolean, are we joining a game via an invite in online mode (false if lan), nil if not joining on |
| `MPIsOnline` |  | Out: Boolean, are we logged on in online mode (false if lan), nil if not logged on |
| `MPJoinGame` |  | In: index, password, join the multiplayer game with the specified index.  Password string can be empty |
| `MPJoinInvitedGame` |  | In: password. Out: True/false join success.  If false then true/false if failed due to needing a password, followed by error message |
| `MPLocalPlayerHosting` |  | Out: True if the local player is hosting the current game or not |
| `MPLocalPlayerId` |  | Out: Steam id for local player |
| `MPLocalPlayerInLobby` |  |  |
| `MPLocalPlayerStats` |  | Out: A table with lots of information about the local player used by the stats screen |
| `MPLogOn` |  | In: Lan mode (true\|false). Log on to multiplayer. Out: Result code |
| `MPLogOut` |  | Log out of multiplayer.  Returns true or false on success |
| `MPOnlinePresence` |  | Out: Pointer to the online presence that exists in game core |
| `MPQuickBattleCancel` |  | Cancels any quick battle matchmaking |
| `MPQuickBattleDetails` |  | Out: Table of details about the quick battle matchmaking process, or nil if matchmaking complete |
| `MPQuickBattleSearchRange` |  | Out: Min and max skill values currently being used for quick battle searches |
| `MPQuickBattleStart` |  | In: Boolean to specify whether it should be a land battle or not |
| `MPReadyForLogOn` |  | In: bool (true = online, false = lan) Out: true/false if the multiplayer system is ready for action |
| `MaxUnitsFromUnitScaleFactor` |  | In: Current unit scale index (int).  Out: Max land units, max naval units |
| `MoviePlaying` |  | Out: Boolean - is a movie still playing |
| `MultiplayerBaseInterface` |  | Out: Pointer to the multiplayer control module (to be passed to UIMPInterface object |
| `OpenMapDataFile` |  | In: Campaign name, Out: Start date and season for that campaign.  Opens the basic information about the specified campaign if it hasn't opened it already! |
| `PlayMovieInComponent` |  | In: movie to play, component to attach movie to |
| `PreviousBattleSetup` |  | Out: Pointer to a previous battle setup and true/false if this is a special napoleonic battle, or nil if there are no previous details stored |
| `PreviousGameType` |  | Out: Enum value. -1 = none, 0 = battle, 1 = campaign, 2 = episodic campaign |
| `Quit` |  | Quit |
| `RecruitableUnits` |  | In: faction key (string), naval battle (bool), era (int), category mask (bitflag to hide various mp categories) Out: Table of details about units that are useable by the faction |
| `ResumeFrontEndMovie` |  | Should only be used if the frontend movie has been previously paused |
| `ResumeMultiplayerCampaign` |  | In: Path to save game.  Will attempt to resume host a multiplayer campaign |
| `RetrieveArmyPresets` |  | In: Faction, battle type, army size, and era Out: Table of unit presets for each weighting type |
| `RetrieveFriendsStats` |  | Out: Array of friends and their rankings |
| `RetrieveGameCore` |  | Out: Returns pointers to the game core so that a UIPrefsInterface object can be initialised |
| `RetrieveRandomPortraitPath` |  | In: Faction key, is_admiral, Out: Card path to a randomly assigned portrait |
| `SaveArmySetup` |  | In: Table of details about units, file path to save to (optional) bool to specify if existing files should be overwritten (false by default) |
| `SaveBattleSetup` |  | In: Table about map details, preferences, and army setups for each player in the battle. Path to save. (Optional) Boolean - overwrite existing files (false by default). Out: Overwrite == false -> bool, bool (files exists, save success), overwrite == true -> bool (save success) |
| `ScreenSize` |  | Retrieve the current width and height of the screen |
| `SetCurrentGameType` |  | In: Number relating to game type being played. 1 = Battle, 2 = Campaign, 3 = Episodic, 4 = Tutorial |
| `ShowDemoMovie` |  | In: movie to show |
| `ShowVoiceChat` |  |  |
| `SpanishCampaignEnabled` |  | Out: true if the player has Wellington PDLC |
| `StartBattle` |  | Takes a battle setup up (create one with UIBattleSetup(FrontEnd.BuildInfoSetup(battle_descr))), and a table of player info and starts the battle |
| `StartCampaign` |  | Starts the specified campaign.  Takes a campaign name, the faction to play as and a table of options (to be defined) |
| `StartFriendStatsDownload` |  | Starts the downloading of friends stats from the steam network. Out: Success flag |
| `StartTutorialBattle` |  | In: bool (true = land, false = naval) |
| `StartTutorialCampaign` |  | Starts the campaign tutorial (tut_napoleon) |
| `SteamFriendsList` |  | In: Bool - show clan members Out: List of details about appropriate friends listed on Steam |
| `SteamNewContentAvailable` |  | Out: true/false depending on whether the player owns any of the content available |
| `SteamOpenStore` |  | Open the steam interface on the store screen |
| `StopAllMovies` |  |  |
| `StopDemoMovie` |  | Stops the movie playing and restores the normal bg movie |
| `StopFriendStatsDownload` |  | Stops the downloading of friends stats from the steam network |
| `TheatreList` |  | In: Campaign key, Out: Table of details about each theatre in the campaign |
| `TimeOfDayOptionsString` |  | Out: A string formatted for dropdown lists containing all the times of day supported by the game |
| `TriggerMessageBoxOpenedEvent` |  | Fired when a message box in the frontend is shown |
| `TriggerSliderUpdateEvent` |  | In: Slider name. Triggers some sliders have there value changed in the FE |
| `UILocalisationString` |  | Retrieve a string from the ui.loc file |
| `UnitScaleFactor` |  | In: (Opt) current scale factor, Out: float value representing current unit scale, index into scale factors list : 0-3 |
| `ValidateArmySetup` |  | In: Table of details about the units used in the setup |
| `WindLevelOptionsString` |  | Out:  A string formatted for dropdown lists containin all the wind levels supported by the game |
| `navigate` |  |  |

