--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleBehaviorCollection = {
    Properties = {
        Name = "ModuleBehaviorCollection",
        Version = "3.0.0 (BETA 2.0.0)",
    },

    Global = {
        SoldierKillsCounter = {},
        VictoryWithPartyEntities = {},
    },
    Local = {},

    Shared = {},
};

-- Global ------------------------------------------------------------------- --

function ModuleBehaviorCollection.Global:OnGameStart()
    for i= 0, 8 do
        self.SoldierKillsCounter[i] = {};
    end
    self:OverrideIsObjectiveCompleted();
    self:OverrideOnQuestTriggered();
end

function ModuleBehaviorCollection.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.ThiefInfiltratedBuilding then
        self:OnThiefInfiltratedBuilding(arg[1], arg[2], arg[3], arg[4]);
    elseif _ID == QSB.ScriptEvents.ThiefDeliverEarnings then
        self:OnThiefDeliverEarnings(arg[1], arg[2], arg[3], arg[4], arg[5]);
    elseif _ID == QSB.ScriptEvents.EntityKilled then
        self:OnEntityKilled(arg[1], arg[2], arg[3], arg[4]);
    end
end

function ModuleBehaviorCollection.Global:OverrideOnQuestTriggered()
    QuestTemplate.Trigger_Orig_QSB_NewBehaviors = QuestTemplate.Trigger;
    QuestTemplate.Trigger = function(self)
        for b= 1, #self.Objectives, 1 do
            if self.Objectives[b] then
                -- Special Objective.DestroyEntities for spawners
                if self.Objectives[b].Type == Objective.DestroyEntities and self.Objectives[b].Data[1] == 3 then
                    -- Refill spawner once at quest start
                    if self.Objectives[b].Data[5] ~= true then
                        local SpawnPoints = self.Objectives[b].Data[2][0];
                        local SpawnAmount = self.Objectives[b].Data[3];
                        -- Delete remaining entities
                        for i=1, SpawnPoints, 1 do
                            local ID = GetID(self.Objectives[b].Data[2][i]);
                            local SpawnedEntities = {Logic.GetSpawnedEntities(ID)};
                            for j= 1, #SpawnedEntities, 1 do
                                DestroyEntity(SpawnedEntities[j]);
                            end
                        end
                        -- Spawn new entities and distribute them equally over
                        -- all spawner entities
                        while (SpawnAmount > 0) do
                            for i=1, SpawnPoints, 1 do
                                if SpawnAmount < 1 then
                                    break;
                                end
                                local ID = GetID(self.Objectives[b].Data[2][i]);
                                Logic.RespawnResourceEntity_Spawn(ID);
                                SpawnAmount = SpawnAmount -1;
                            end
                        end
                        -- Set icon
                        local CategoryDefinigEntity = Logic.GetSpawnedEntities(self.Objectives[b].Data[2][1]);
                        if not self.Objectives[b].Data[6] then
                            self.Objectives[b].Data[6] = {7, 12};
                            if Logic.IsEntityInCategory(CategoryDefinigEntity, EntityCategories.AttackableAnimal) == 1 then
                                self.Objectives[b].Data[6] = {13, 8};
                            end
                        end
                        self.Objectives[b].Data[5] = true;
                    end
                end
            end
        end
        self:Trigger_Orig_QSB_NewBehaviors();
    end
end

function ModuleBehaviorCollection.Global:OverrideIsObjectiveCompleted()
    QuestTemplate.IsObjectiveCompleted_Orig_QSB_NewBehaviors = QuestTemplate.IsObjectiveCompleted;
    QuestTemplate.IsObjectiveCompleted = function(self, objective)
        local objectiveType = objective.Type;
        if objective.Completed ~= nil then
            if objectiveType == Objective.DestroyEntities and objective.Data[1] == 3 then
                objective.Data[5] = nil;
            end
            return objective.Completed;
        end

        if objectiveType == Objective.DestroyEntities then
            if objective.Data[1] == 3 then
                objective.Completed = self:AreSpawnedQuestEntitiesDestroyed(objective);
            else
                return self:IsObjectiveCompleted_Orig_QSB_NewBehaviors(objective);
            end
        else
            return self:IsObjectiveCompleted_Orig_QSB_NewBehaviors(objective);
        end
    end

    QuestTemplate.AreSpawnedQuestEntitiesDestroyed = function(self, _Objective)
        if _Objective.Data[1] == 3 then
            local AllSpawnedEntities = {};
            for i=1, _Objective.Data[2][0], 1 do
                local ID = GetID(_Objective.Data[2][i]);
                AllSpawnedEntities = Array_Append(
                    AllSpawnedEntities,
                    {Logic.GetSpawnedEntities(ID)}
                );
            end
            if #AllSpawnedEntities == 0 then
                return true;
            end
        end
    end
end

function ModuleBehaviorCollection.Global:GetPossibleModels()
    local Data = {};
    -- Add generic models
    for k, v in pairs(Models) do
        if  not string.find(k, "Animals_")
        and not string.find(k, "MissionMap_")
        and not string.find(k, "R_Fish")
        and not string.find(k, "^[GEHUVXYZgt][ADSTfm]*")
        and not string.find(string.lower(k), "goods|tools_") then
            table.insert(Data, k);
        end
    end
    -- Add specific models
    table.insert(Data, "Effects_Dust01");
    table.insert(Data, "Effects_E_DestructionSmoke");
    table.insert(Data, "Effects_E_DustLarge");
    table.insert(Data, "Effects_E_DustSmall");
    table.insert(Data, "Effects_E_Firebreath");
    table.insert(Data, "Effects_E_Fireworks01");
    table.insert(Data, "Effects_E_Flies01");
    table.insert(Data, "Effects_E_Grasshopper03");
    table.insert(Data, "Effects_E_HealingFX");
    table.insert(Data, "Effects_E_Knight_Chivalry_Aura");
    table.insert(Data, "Effects_E_Knight_Plunder_Aura");
    table.insert(Data, "Effects_E_Knight_Song_Aura");
    table.insert(Data, "Effects_E_Knight_Trader_Aura");
    table.insert(Data, "Effects_E_Knight_Wisdom_Aura");
    table.insert(Data, "Effects_E_KnightFight");
    table.insert(Data, "Effects_E_NA_BlowingSand01");
    table.insert(Data, "Effects_E_NE_BlowingSnow01");
    table.insert(Data, "Effects_E_Oillamp");
    table.insert(Data, "Effects_E_SickBuilding");
    table.insert(Data, "Effects_E_Splash");
    table.insert(Data, "Effects_E_Torch");
    table.insert(Data, "Effects_Fire01");
    table.insert(Data, "Effects_FX_Lantern");
    table.insert(Data, "Effects_FX_SmokeBIG");
    table.insert(Data, "Effects_XF_BuildingSmoke");
    table.insert(Data, "Effects_XF_BuildingSmokeLarge");
    table.insert(Data, "Effects_XF_BuildingSmokeMedium");
    table.insert(Data, "Effects_XF_HouseFire");
    table.insert(Data, "Effects_XF_HouseFireLo");
    table.insert(Data, "Effects_XF_HouseFireMedium");
    table.insert(Data, "Effects_XF_HouseFireSmall");
    if g_GameExtraNo > 0 then
        table.insert(Data, "Effects_E_KhanaTemple_Fire");
        table.insert(Data, "Effects_E_Knight_Saraya_Aura");
    end
    -- Sort list
    table.sort(Data);
    return Data;
end

function ModuleBehaviorCollection.Global:OnThiefInfiltratedBuilding(_ThiefID, _PlayerID, _BuildingID, _BuildingPlayerID)
    for i=1, Quests[0] do
        if Quests[i] and Quests[i].State == QuestState.Active and Quests[i].ReceivingPlayer == _PlayerID then
            for j=1, Quests[i].Objectives[0] do
                if Quests[i].Objectives[j].Type == Objective.Custom2 then
                    if Quests[i].Objectives[j].Data[1].Name == "Goal_SpyOnBuilding" then
                        if GetID(Quests[i].Objectives[j].Data[1].Building) == _BuildingID then
                            Quests[i].Objectives[j].Data[1].Infiltrated = true;
                            if Quests[i].Objectives[j].Data[1].Delete then
                                DestroyEntity(_ThiefID);
                            end
                        end

                    elseif Quests[i].Objectives[j].Data[1].Name == "Goal_StealFromBuilding" then
                        local found;
                        local isCathedral = Logic.IsEntityInCategory(_BuildingID, EntityCategories.Cathedrals) == 1;
                        local isWarehouse = Logic.GetEntityType(_BuildingID) == Entities.B_StoreHouse;
                        if isWarehouse or isCathedral then
                            Quests[i].Objectives[j].Data[1].SuccessfullyStohlen = true;
                        else
                            for k=1, #Quests[i].Objectives[j].Data[1].RobberList do
                                local stohlen = Quests[i].Objectives[j].Data[1].RobberList[k];
                                if stohlen[1] == _BuildingID and stohlen[2] == _ThiefID then
                                    found = true;
                                    break;
                                end
                            end
                        end
                        if not found then
                            table.insert(Quests[i].Objectives[j].Data[1].RobberList, {_BuildingID, _ThiefID});
                        end
                    end
                end
            end
        end
    end
end

function ModuleBehaviorCollection.Global:OnThiefDeliverEarnings(_ThiefID, _PlayerID, _BuildingID, _BuildingPlayerID, _GoldAmount)
    for i=1, Quests[0] do
        if Quests[i] and Quests[i].State == QuestState.Active and Quests[i].ReceivingPlayer == _PlayerID then
            for j=1, Quests[i].Objectives[0] do
                if Quests[i].Objectives[j].Type == Objective.Custom2 then
                    if Quests[i].Objectives[j].Data[1].Name == "Goal_StealFromBuilding" then
                        for k=1, #Quests[i].Objectives[j].Data[1].RobberList do
                            local stohlen = Quests[i].Objectives[j].Data[1].RobberList[k];
                            if stohlen[1] == GetID(Quests[i].Objectives[j].Data[1].Building) and stohlen[2] == _ThiefID then
                                Quests[i].Objectives[j].Data[1].SuccessfullyStohlen = true;
                                break;
                            end
                        end

                    elseif Quests[i].Objectives[j].Data[1].Name == "Goal_StealGold" then
                        local CurrentObjective = Quests[i].Objectives[j].Data[1];
                        if CurrentObjective.Target == -1 or CurrentObjective.Target == _BuildingPlayerID then
                            Quests[i].Objectives[j].Data[1].StohlenGold = Quests[i].Objectives[j].Data[1].StohlenGold + _GoldAmount;
                            if CurrentObjective.Printout then
                                API.Note(string.format(
                                    "%d/%d %s",
                                    CurrentObjective.StohlenGold,
                                    CurrentObjective.Amount,
                                    API.Localize({de = "Talern gestohlen",en = "gold stolen",})
                                ));
                            end
                        end
                    end
                end
            end
        end
    end
end

function ModuleBehaviorCollection.Global:OnEntityKilled(_KilledEntityID, _KilledPlayerID, _KillerEntityID, _KillerPlayerID)
    if _KilledPlayerID ~= 0 and _KillerPlayerID ~= 0 then
        self.SoldierKillsCounter[_KillerPlayerID][_KilledPlayerID] = self.SoldierKillsCounter[_KillerPlayerID][_KilledPlayerID] or 0
        if Logic.IsEntityInCategory(_KilledEntityID, EntityCategories.Soldier) == 1 then
            self.SoldierKillsCounter[_KillerPlayerID][_KilledPlayerID] = self.SoldierKillsCounter[_KillerPlayerID][_KilledPlayerID] +1
        end
    end
end

function ModuleBehaviorCollection.Global:GetEnemySoldierKillsOfPlayer(_PlayerID1, _PlayerID2)
    return self.SoldierKillsCounter[_PlayerID1][_PlayerID2] or 0;
end

-- Local -------------------------------------------------------------------- --

function ModuleBehaviorCollection.Local:OnGameStart()
    self:DisplayQuestObjective();
    self:GetEntitiesOrTerritoryList();
    self:OverrideSaveQuestEntityTypes();
end

function ModuleBehaviorCollection.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleBehaviorCollection.Local:DisplayQuestObjective()
    GUI_Interaction.DisplayQuestObjective_Orig_NewBehavior = GUI_Interaction.DisplayQuestObjective;
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local QuestIndexTemp = tonumber(_QuestIndex);
        if QuestIndexTemp then
            _QuestIndex = QuestIndexTemp;
        end
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives";
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0);

        if QuestType == Objective.DestroyEntities and Quest.Objectives[1].Data[1] == 3 then
            local QuestObjectiveContainer = QuestObjectivesPath .. "/GroupEntityType";
            local QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestDestroy");
            local EntitiesList = GUI_Interaction.GetEntitiesOrTerritoryListForQuest( Quest, QuestType );
            local EntitiesAmount = #EntitiesList;
            if not Quest.Objectives[1].Data[5] and #EntitiesList == 0 then
                EntitiesAmount = Quest.Objectives[1].Data[2][0] * Quest.Objectives[1].Data[3];
            end

            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCaption", 0);
            XGUIEng.ShowWidget(QuestObjectiveContainer .. "/AdditionalCondition", 0);
            SetIcon(QuestObjectiveContainer .. "/Icon", Quest.Objectives[1].Data[6]);
            XGUIEng.SetText(QuestObjectiveContainer .. "/Number", "{center}" .. EntitiesAmount);

            XGUIEng.SetText(QuestObjectiveContainer .. "/Caption", "{center}" .. QuestTypeCaption);
            XGUIEng.ShowWidget(QuestObjectiveContainer, 1);
            GUI_Interaction.SetQuestTypeIcon(QuestObjectiveContainer .. "/QuestTypeIcon", _QuestIndex);
            if Quest.State == QuestState.Over then
                if Quest.Result == QuestResult.Success then
                    XGUIEng.ShowWidget(QuestObjectivesPath .. "/QuestOverSuccess", 1);
                elseif Quest.Result == QuestResult.Failure then
                    XGUIEng.ShowWidget(QuestObjectivesPath .. "/QuestOverFailure", 1);
                end
            end
            return;
        end
        GUI_Interaction.DisplayQuestObjective_Orig_NewBehavior(_QuestIndex, _MessageKey);
    end
end

function ModuleBehaviorCollection.Local:GetEntitiesOrTerritoryList()
    GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_NewBehavior = GUI_Interaction.GetEntitiesOrTerritoryListForQuest;
    GUI_Interaction.GetEntitiesOrTerritoryListForQuest = function(_Quest, _QuestType)
        local IsEntity = true;
        local EntityOrTerritoryList = {};
        if _QuestType == Objective.DestroyEntities then
            if _Quest.Objectives[1].Data and _Quest.Objectives[1].Data[1] == 3 then
                for i=1, _Quest.Objectives[1].Data[2][0], 1 do
                    local ID = GetID(_Quest.Objectives[1].Data[2][i]);
                    EntityOrTerritoryList = Array_Append(EntityOrTerritoryList, {Logic.GetSpawnedEntities(ID)});
                end
                return EntityOrTerritoryList, IsEntity;
            end
        end
        return GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_NewBehavior(_Quest, _QuestType);
    end
end

function ModuleBehaviorCollection.Local:OverrideSaveQuestEntityTypes()
    GUI_Interaction.SaveQuestEntityTypes_Orig_NewBehavior = GUI_Interaction.SaveQuestEntityTypes;
    GUI_Interaction.SaveQuestEntityTypes = function(_QuestIndex)
        if g_Interaction.SavedQuestEntityTypes[_QuestIndex] ~= nil then
            return;
        end
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        if QuestType == Objective.DestroyEntities and Quest.Objectives[1].Data[1] == 3 then
            local EntitiesList = GUI_Interaction.GetEntitiesOrTerritoryListForQuest(Quest, QuestType);
            EntitiesList[0] = #EntitiesList;
            if EntitiesList ~= nil then
                g_Interaction.SavedQuestEntityTypes[_QuestIndex] = {};
                for i = 1, EntitiesList[0], 1 do
                    if Logic.IsEntityAlive(EntitiesList[i]) then
                        local EntityType = Logic.GetEntityType(GetID(EntitiesList[i]));
                        table.insert(g_Interaction.SavedQuestEntityTypes[_QuestIndex], i, EntityType);
                    end
                end
                return;
            end
        end
        GUI_Interaction.SaveQuestEntityTypes_Orig_NewBehavior(_QuestIndex)
    end
end

-- -------------------------------------------------------------------------- --

Swift:RegisterModule(ModuleBehaviorCollection);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Dieses Modul f??gt neue Behavior f??r den Editor hinzu.
--
-- <p><b>Vorausgesetzte Module:</b></p>
-- <ul>
-- <li><a href="qsb.html">(0) Basismodul</a></li>
-- <li><a href="modules.QSB_1_GuiControl.QSB_1_GuiControl.html">(1) Anzeigekontrolle</a></li>
-- <li><a href="modules.QSB_1_Entity.QSB_1_Entity.html">(1) Entit??tensteuerung</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Die neuen Behavior f??r den Editor.
--
-- @set sort=true
--

-- -------------------------------------------------------------------------- --

---
-- Ein Entity muss sich zu einem Ziel bewegen und eine Distanz unterschreiten.
--
-- Optional kann das Ziel mit einem Marker markiert werden.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=string]  _Target     Skriptname des Ziels
-- @param[type=number]  _Distance   Entfernung
-- @param[type=boolean] _UseMarker  Ziel markieren
--
-- @within Goal
--
function Goal_MoveToPosition(...)
    return B_Goal_MoveToPosition:new(...);
end

B_Goal_MoveToPosition = {
    Name = "Goal_MoveToPosition",
    Description = {
        en = "Goal: A entity have to moved as close as the distance to another entity. The target can be marked with a static marker.",
        de = "Ziel: Ein Entity muss sich einer anderen bis auf eine bestimmte Distanz n??hern. Die Lupe wird angezeigt, das Ziel kann markiert werden.",
        fr = "Objectif: une entit?? doit s'approcher d'une autre ?? une distance donn??e. La loupe est affich??e, la cible peut ??tre marqu??e.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",   de = "Entity",         fr = "Entit??" },
        { ParameterType.ScriptName, en = "Target",   de = "Ziel",           fr = "Cible" },
        { ParameterType.Number,     en = "Distance", de = "Entfernung",     fr = "Distance" },
        { ParameterType.Custom,     en = "Marker",   de = "Ziel markieren", fr = "Marquer la cible" },
    },
}

function B_Goal_MoveToPosition:GetGoalTable()
    return {Objective.Distance, self.Entity, self.Target, self.Distance, self.Marker}
end

function B_Goal_MoveToPosition:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity = _Parameter
    elseif (_Index == 1) then
        self.Target = _Parameter
    elseif (_Index == 2) then
        self.Distance = _Parameter * 1
    elseif (_Index == 3) then
        self.Marker = API.ToBoolean(_Parameter)
    end
end

function B_Goal_MoveToPosition:GetCustomData( _Index )
    local Data = {};
    if _Index == 3 then
        Data = {"true", "false"}
    end
    return Data
end

Swift:RegisterBehavior(B_Goal_MoveToPosition);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss einen bestimmten Quest abschlie??en.
--
-- @param[type=string] _QuestName Name des Quest
--
-- @within Goal
--
function Goal_WinQuest(...)
    return B_Goal_WinQuest:new(...);
end

B_Goal_WinQuest = {
    Name = "Goal_WinQuest",
    Description = {
        en = "Goal: The player has to win a given quest.",
        de = "Ziel: Der Spieler muss eine angegebene Quest erfolgreich abschliessen.",
        fr = "Objectif: Le joueur doit r??ussir une qu??te indiqu??e.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name",  de = "Questname", fr = "Nom de la qu??te" },
    },
}

function B_Goal_WinQuest:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_WinQuest:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Quest = _Parameter;
    end
end

function B_Goal_WinQuest:CustomFunction(_Quest)
    local quest = Quests[GetQuestID(self.Quest)];
    if quest then
        if quest.Result == QuestResult.Failure then
            return false;
        end
        if quest.Result == QuestResult.Success then
            return true;
        end
    end
    return nil;
end

function B_Goal_WinQuest:Debug(_Quest)
    if Quests[GetQuestID(self.Quest)] == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Quest '"..self.Quest.."' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Goal_WinQuest);

-- -------------------------------------------------------------------------- --

---
-- Es muss eine Menge an Munition in der Kriegsmaschine erreicht werden.
--
-- <u>Relationen</u>
-- <ul>
-- <li>>= - Anzahl als Mindestmenge</li>
-- <li>< - Weniger als Anzahl</li>
-- </ul>
--
-- @param[type=string] _ScriptName  Name des Kriegsger??t
-- @param[type=string] _Relation    Mengenrelation
-- @param[type=number] _Amount      Menge an Munition
--
-- @within Goal
--
function Goal_AmmunitionAmount(...)
    return B_Goal_AmmunitionAmount:new(...);
end

B_Goal_AmmunitionAmount = {
    Name = "Goal_AmmunitionAmount",
    Description = {
        en = "Goal: Reach a smaller or bigger value than the given amount of ammunition in a war machine.",
        de = "Ziel: ??ber- oder unterschreite die angegebene Anzahl Munition in einem Kriegsger??t.",
        fr = "Objectif : D??passer ou ne pas d??passer le nombre de munitions indiqu?? dans un engin de guerre.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname",  fr = "Nom de l'entit??" },
        { ParameterType.Custom,     en = "Relation",    de = "Relation",    fr = "Relation" },
        { ParameterType.Number,     en = "Amount",      de = "Menge",       fr = "Quantit??" },
    },
}

function B_Goal_AmmunitionAmount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_AmmunitionAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Scriptname = _Parameter
    elseif (_Index == 1) then
        self.bRelSmallerThan = tostring(_Parameter) == "true" or _Parameter == "<"
    elseif (_Index == 2) then
        self.Amount = _Parameter * 1
    end
end

function B_Goal_AmmunitionAmount:CustomFunction()
    local EntityID = GetID(self.Scriptname);
    if not IsExisting(EntityID) then
        return false;
    end
    local HaveAmount = Logic.GetAmmunitionAmount(EntityID);
    if ( self.bRelSmallerThan and HaveAmount < self.Amount ) or ( not self.bRelSmallerThan and HaveAmount >= self.Amount ) then
        return true;
    end
    return nil;
end

function B_Goal_AmmunitionAmount:Debug(_Quest)
    if self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount is negative");
        return true
    end
end

function B_Goal_AmmunitionAmount:GetCustomData( _Index )
    if _Index == 1 then
        return {"<", ">="};
    end
end

Swift:RegisterBehavior(B_Goal_AmmunitionAmount);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss mindestens den angegebenen Ruf erreichen. Der Ruf muss
-- in Prozent angegeben werden (ohne %-Zeichen).
--
-- @param[type=number] _Reputation Ben??tigter Ruf
--
-- @within Goal
--
function Goal_CityReputation(...)
    return B_Goal_CityReputation:new(...);
end

B_Goal_CityReputation = {
    Name = "Goal_CityReputation",
    Description = {
        en = "Goal: The reputation of the quest receivers city must at least reach the desired hight.",
        de = "Ziel: Der Ruf der Stadt des Empf??ngers muss mindestens so hoch sein, wie angegeben.",
        fr = "Objectif: la r??putation de la ville du receveur doit ??tre au moins aussi ??lev??e que celle indiqu??e.",
    },
    Parameter = {
        { ParameterType.Number, en = "City reputation", de = "Ruf der Stadt", fr = "R??putation de la ville" },
    },
    Text = {
        de = "RUF DER STADT{cr}{cr}Hebe den Ruf der Stadt durch weise Herrschaft an!{cr}Ben??tigter Ruf: %d",
        en = "CITY REPUTATION{cr}{cr}Raise your reputation by fair rulership!{cr}Needed reputation: %d",
        fr = "R??PUTATION DE LA VILLE{cr}{cr} Augmente la r??putation de la ville en la gouvernant sagement!{cr}R??putation requise : %d",
    }
}

function B_Goal_CityReputation:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_CityReputation:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Reputation = _Parameter * 1;
    end
end

function B_Goal_CityReputation:CustomFunction(_Quest)
    self:SetCaption(_Quest);
    local CityReputation = Logic.GetCityReputation(_Quest.ReceivingPlayer) * 100;
    if CityReputation >= self.Reputation then
        return true;
    end
end

function B_Goal_CityReputation:SetCaption(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local Text = string.format(API.Localize(self.Text), self.Reputation);
        Swift.Quest:ChangeCustomQuestCaptionText(Text .."%", _Quest);
    end
end

function B_Goal_CityReputation:GetIcon()
    return {5, 14};
end

function B_Goal_CityReputation:Debug(_Quest)
    if type(self.Reputation) ~= "number" or self.Reputation < 0 or self.Reputation > 100 then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Reputation must be between 0 and 100!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Goal_CityReputation);

-- -------------------------------------------------------------------------- --

---
-- Eine Menge an Entities des angegebenen Spawnpoint muss zerst??rt werden.
--
-- <b>Hinweis</b>: Eignet sich vor allem f??r Raubtiere!
--
-- Wenn die angegebene Anzahl zu Beginn des Quest nicht mit der Anzahl an
-- bereits gespawnten Entities ??bereinstimmt, wird dies automatisch korrigiert.
-- (Neue Entities gespawnt bzw. ??bersch??ssige gel??scht)
--
-- Wenn _Prefixed gesetzt ist, wird anstatt des Namen Entities mit einer
-- fortlaufenden Nummer gesucht, welche mit dem Namen beginnen. Bei der
-- ersten Nummer, zu der kein Entity existiert, wird abgebrochen.
--
-- @param[type=string] _SpawnPoint Skriptname des Spawnpoint
-- @param[type=number] _Amount     Menge zu zerst??render Entities
-- @param[type=number] _Prefixed   Skriptname ist Pr??fix
--
-- @within Goal
--
function Goal_DestroySpawnedEntities(...)
    return B_Goal_DestroySpawnedEntities:new(...);
end

B_Goal_DestroySpawnedEntities = {
    Name = "Goal_DestroySpawnedEntities",
    Description = {
        en = "Goal: Destroy all entities spawned at the spawnpoint.",
        de = "Ziel: Zerst??re alle Entit??ten, die bei dem Spawnpoint erzeugt wurde.",
        fr = "Objectif: D??truire toutes les entit??s cr????es au point d'apparition.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Spawnpoint",       de = "Spawnpoint",         fr = "Point d'??mergence" },
        { ParameterType.Number,     en = "Amount",           de = "Menge",              fr = "Quantit??" },
        { ParameterType.Custom,     en = "Name is prefixed", de = "Name ist Pr??fix",    fr = "Le nom est un pr??fixe" },
    },
};

function B_Goal_DestroySpawnedEntities:GetGoalTable()
    -- Zur Erzeugungszeit Spawnpoint konvertieren
    -- Hinweis: Entities m??ssen zu diesem Zeitpunkt existieren und m??ssen
    -- Spawnpoints sein!
    if self.Prefixed then
        local Parameter = table.remove(self.SpawnPoint);
        local i = 1;
        while (IsExisting(Parameter .. i)) do
            table.insert(self.SpawnPoint, Parameter .. i);
            i = i +1;
        end
        -- Hard Error!
        assert(#self.SpawnPoint > 0, "No spawnpoints found!");
    end
    -- Behavior zur??ckgeben
    return {Objective.DestroyEntities, 3, self.SpawnPoint, self.Amount};
end

function B_Goal_DestroySpawnedEntities:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SpawnPoint = {_Parameter};
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or "false";
        self.Prefixed = API.ToBoolean(_Parameter);
    end
end

function B_Goal_DestroySpawnedEntities:GetMsgKey()
    local ID = GetID(self.SpawnPoint[1]);
    if ID ~= 0 then
        local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(ID));
        if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
            return "Quest_Destroy_Leader";
        elseif TypeName:find("Bear") or TypeName:find("Lion") or TypeName:find("Tiger") or TypeName:find("Wolf") then
            return "Quest_DestroyEntities_Predators";
        elseif TypeName:find("Military") or TypeName:find("Cart") then
            return "Quest_DestroyEntities_Unit";
        end
    end
    return "Quest_DestroyEntities";
end

function B_Goal_DestroySpawnedEntities:GetCustomData(_Index)
    if _Index == 2 then
        return {"false", "true"};
    end
end

Swift:RegisterBehavior(B_Goal_DestroySpawnedEntities);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss eine bestimmte Menge Gold mit Dieben stehlen.
--
-- Dabei ist es egal von welchem Spieler. Diebe k??nnen Gold nur aus
-- Stadtgeb??ude stehlen und nur von feindlichen Spielern.
--
-- <b>Hinweis</b>: Es k??nnen nur Stadtgeb??ude mit einem Dieb um Gold
-- erleichtert werden!
--
-- @param[type=number]  _Amount         Menge an Gold
-- @param[type=number]  _TargetPlayerID Zielspieler (-1 f??r alle)
-- @param[type=boolean] _CheatEarnings  Einnahmen generieren
-- @param[type=boolean] _ShowProgress   Fortschritt ausgeben
--
-- @within Goal
--
function Goal_StealGold(...)
    return B_Goal_StealGold:new(...)
end

B_Goal_StealGold = {
    Name = "Goal_StealGold",
    Description = {
        en = "Goal: Steal an explicit amount of gold from a players or any players city buildings.",
        de = "Ziel: Diebe sollen eine bestimmte Menge Gold aus feindlichen Stadtgeb??uden stehlen.",
        fr = "Objectif: les voleurs doivent d??rober une certaine quantit?? d'or dans les b??timents urbains ennemis.",
    },
    Parameter = {
        { ParameterType.Number,   en = "Amount on Gold", de = "Zu stehlende Menge",             fr = "Quantit?? ?? voler" },
        { ParameterType.Custom,   en = "Target player",  de = "Spieler von dem gestohlen wird", fr = "Joueur ?? qui l'on vole" },
        { ParameterType.Custom,   en = "Cheat earnings", de = "Einnahmen generieren",           fr = "G??n??rer des revenus" },
        { ParameterType.Custom,   en = "Print progress", de = "Fortschritt ausgeben",           fr = "Afficher les progr??s" },
    },
}

function B_Goal_StealGold:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_StealGold:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 1) then
        local PlayerID = tonumber(_Parameter) or -1;
        self.Target = PlayerID * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = API.ToBoolean(_Parameter);
    elseif (_Index == 3) then
        _Parameter = _Parameter or "true"
        self.Printout = API.ToBoolean(_Parameter);
    end
    self.StohlenGold = 0;
end

function B_Goal_StealGold:GetCustomData(_Index)
    if _Index == 1 then
        return { "-", 1, 2, 3, 4, 5, 6, 7, 8 };
    elseif _Index == 2 then
        return { "true", "false" };
    end
end

function B_Goal_StealGold:SetDescriptionOverwrite(_Quest)
    local TargetPlayerName = API.Localize({
        de = " anderen Spielern ",
        en = " different parties ",
        fr = " d'autres joueurs ",
    });

    if self.Target ~= -1 then
        TargetPlayerName = API.GetPlayerName(self.Target);
        if TargetPlayerName == nil or TargetPlayerName == "" then
            TargetPlayerName = " PLAYER_NAME_MISSING ";
        end
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local PlayerIDs = {self.Target};
        if self.Target == -1 then
            PlayerIDs = {1, 2, 3, 4, 5, 6, 7, 8};
        end
        for i= 1, #PlayerIDs, 1 do
            if i ~= _Quest.ReceivingPlayer and Logic.GetStoreHouse(i) ~= 0 then
                local CityBuildings = {Logic.GetPlayerEntitiesInCategory(i, EntityCategories.CityBuilding)};
                for j= 1, #CityBuildings, 1 do
                    local CurrentEarnings = Logic.GetBuildingProductEarnings(CityBuildings[j]);
                    if CurrentEarnings < 45 and Logic.GetTime() % 5 == 0 then
                        Logic.SetBuildingEarnings(CityBuildings[j], CurrentEarnings +1);
                    end
                end
            end
        end
    end

    local amount = self.Amount - self.StohlenGold;
    amount = (amount > 0 and amount) or 0;
    local text = {
        de = "Gold von %s stehlen {cr}{cr}Aus Stadtgeb??uden zu stehlende Goldmenge: %d",
        en = "Steal gold from %s {cr}{cr}Amount on gold to steal from city buildings: %d",
        fr = "Voler l'or de %s {cr}{cr}Quantit?? d'or ?? voler dans les b??timents de la ville : %d",
    };
    return "{center}" ..string.format(API.Localize(text), TargetPlayerName, amount);
end

function B_Goal_StealGold:CustomFunction(_Quest)
    Swift.Quest:ChangeCustomQuestCaptionText(self:SetDescriptionOverwrite(_Quest), _Quest);
    if self.StohlenGold >= self.Amount then
        return true;
    end
    return nil;
end

function B_Goal_StealGold:GetIcon()
    return {5,13};
end

function B_Goal_StealGold:Debug(_Quest)
    if tonumber(self.Amount) == nil and self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

function B_Goal_StealGold:Reset(_Quest)
    self.StohlenGold = 0;
end

Swift:RegisterBehavior(B_Goal_StealGold)

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss ein bestimmtes Stadtgeb??ude bestehlen.
--
-- Eine Kirche wird immer Sabotiert. Ein Lagerhaus verh??lt sich ??hnlich zu
-- einer Burg.
--
-- <b>Hinweis</b>: Ein Dieb kann nur von einem Spezialgeb??ude oder einem
-- Stadtgeb??ude stehlen!
--
-- @param[type=string] _ScriptName Skriptname des Geb??udes
-- @param[type=boolean] _CheatEarnings  Einnahmen generieren
--
-- @within Goal
--
function Goal_StealFromBuilding(...)
    return B_Goal_StealFromBuilding:new(...)
end

B_Goal_StealFromBuilding = {
    Name = "Goal_StealFromBuilding",
    Description = {
        en = "Goal: The player has to steal from a building. Not a castle and not a village storehouse!",
        de = "Ziel: Der Spieler muss ein bestimmtes Geb??ude bestehlen. Dies darf keine Burg und kein Dorflagerhaus sein!",
        fr = "Objectif: Le joueur doit voler un b??timent sp??cifique. Il ne peut s'agir ni d'un ch??teau ni d'un entrep??t de village !",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Building",        de = "Geb??ude",              fr = "B??timent" },
        { ParameterType.Custom,     en = "Cheat earnings",  de = "Einnahmen generieren", fr = "G??n??rer des revenus" },
    },
}

function B_Goal_StealFromBuilding:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_StealFromBuilding:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Building = _Parameter
    elseif (_Index == 1) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = API.ToBoolean(_Parameter);
    end
    self.RobberList = {};
end

function B_Goal_StealFromBuilding:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" };
    end
end

function B_Goal_StealFromBuilding:SetDescriptionOverwrite(_Quest)
    local isCathedral = Logic.IsEntityInCategory(GetID(self.Building), EntityCategories.Cathedrals) == 1;
    local isWarehouse = Logic.GetEntityType(GetID(self.Building)) == Entities.B_StoreHouse;
    local isCistern = Logic.GetEntityType(GetID(self.Building)) == Entities.B_Cistern;
    local text;

    if isCathedral then
        text = {
            de = "Sabotage {cr}{cr} Sendet einen Dieb und sabotiert die markierte Kirche.",
            en = "Sabotage {cr}{cr} Send a thief to sabotage the marked chapel.",
            fr = "Sabotage {cr}{cr} Envoyez un voleur pour saboter la chapelle marqu??e.",
        };
    elseif isWarehouse then
        text = {
            de = "Lagerhaus bestehlen {cr}{cr} Sendet einen Dieb in das markierte Lagerhaus.",
            en = "Steal from storehouse {cr}{cr} Steal from the marked storehouse.",
            fr = "Voler un entrep??t {cr}{cr} Envoie un voleur dans l'entrep??t marqu??.",
        };
    elseif isCistern then
        text = {
            de = "Sabotage {cr}{cr} Sendet einen Dieb und sabotiert den markierten Brunnen.",
            en = "Sabotage {cr}{cr} Send a thief and break the marked well of the enemy.",
            fr = "Sabotage {cr}{cr} Envoie un voleur et sabote le puits marqu??.",
        };
    else
        text = {
            de = "Geb??ude bestehlen {cr}{cr} Sendet einen Dieb und bestehlt das markierte Geb??ude.",
            en = "Steal from building {cr}{cr} Send a thief to steal from the marked building.",
            fr = "Voler un b??timent {cr}{cr} Envoie un voleur et vole le b??timent marqu??.",
        };
    end
    return "{center}" .. API.Localize(text);
end

function B_Goal_StealFromBuilding:CustomFunction(_Quest)
    if not IsExisting(self.Building) then
        if self.Marker then
            Logic.DestroyEffect(self.Marker);
        end
        return false;
    end

    if not self.Marker then
        local pos = GetPosition(self.Building);
        self.Marker = Logic.CreateEffect(EGL_Effects.E_Questmarker, pos.X, pos.Y, 0);
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local BuildingID = GetID(self.Building);        
        local CurrentEarnings = Logic.GetBuildingProductEarnings(BuildingID);
        if  Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1
        and CurrentEarnings < 45 and Logic.GetTime() % 5 == 0 then
            Logic.SetBuildingEarnings(BuildingID, CurrentEarnings +1);
        end
    end

    if self.SuccessfullyStohlen then
        Logic.DestroyEffect(self.Marker);
        return true;
    end
    return nil;
end

function B_Goal_StealFromBuilding:GetIcon()
    return {5,13};
end

function B_Goal_StealFromBuilding:Debug(_Quest)
    local eTypeName = Logic.GetEntityTypeName(Logic.GetEntityType(GetID(self.Building)));
    local IsHeadquarter = Logic.IsEntityInCategory(GetID(self.Building), EntityCategories.Headquarters) == 1;
    if Logic.IsBuilding(GetID(self.Building)) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is not a building");
        return true;
    elseif not IsExisting(self.Building) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is destroyed :(");
        return true;
    elseif string.find(eTypeName, "B_NPC_BanditsHQ") or string.find(eTypeName, "B_NPC_Cloister") or string.find(eTypeName, "B_NPC_StoreHouse") then
        error(_Quest.Identifier.. ": " ..self.Name .. ": village storehouses are not allowed!");
        return true;
    elseif IsHeadquarter then
        error(_Quest.Identifier.. ": " ..self.Name .. ": use Goal_StealInformation for headquarters!");
        return true;
    end
    return false;
end

function B_Goal_StealFromBuilding:Reset(_Quest)
    self.SuccessfullyStohlen = false;
    self.RobberList = {};
    self.Marker = nil;
end

function B_Goal_StealFromBuilding:Interrupt(_Quest)
    Logic.DestroyEffect(self.Marker);
end

Swift:RegisterBehavior(B_Goal_StealFromBuilding)

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss ein Geb??ude mit einem Dieb ausspoinieren.
--
-- Der Quest ist erfolgreich, sobald der Dieb in das Geb??ude eindringt. Es
-- muss sich um ein Geb??ude handeln, das bestohlen werden kann (Burg, Lager,
-- Kirche, Stadtgeb??ude mit Einnahmen)!
--
-- Optional kann der Dieb nach Abschluss gel??scht werden. Diese Option macht
-- es einfacher ihn durch z.B. einen Abfahrenden U_ThiefCart zu "ersetzen".
--
-- <b>Hinweis</b>: Ein Dieb kann nur in Spezialgeb??ude oder Stadtgeb??ude
-- eindringen!
--
-- @param[type=string]  _ScriptName  Skriptname des Geb??udes
-- @param[type=boolean] _CheatEarnings  Einnahmen generieren
-- @param[type=boolean] _DeleteThief Dieb nach Abschluss l??schen
--
-- @within Goal
--
function Goal_SpyOnBuilding(...)
    return B_Goal_SpyOnBuilding:new(...)
end

B_Goal_SpyOnBuilding = {
    Name = "Goal_SpyOnBuilding",
    IconOverwrite = {5,13},
    Description = {
        en = "Goal: Infiltrate a building with a thief. A thief must be able to steal from the target building.",
        de = "Ziel: Infiltriere ein Geb??ude mit einem Dieb. Nur mit Gebaueden m??glich, die bestohlen werden koennen.",
        fr = "Objectif: Infiltrer un b??timent avec un voleur. Seulement possible avec des b??timents qui peuvent ??tre vol??s.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target Building", de = "Zielgeb??ude",           fr = "B??timent cible" },
        { ParameterType.Custom,     en = "Cheat earnings",  de = "Einnahmen generieren",  fr = "G??n??rer des revenus" },
        { ParameterType.Custom,     en = "Destroy Thief",   de = "Dieb l??schen",          fr = "Supprimer le voleur" },
    },
}

function B_Goal_SpyOnBuilding:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_SpyOnBuilding:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Building = _Parameter
    elseif (_Index == 1) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = API.ToBoolean(_Parameter);
    elseif (_Index == 2) then
        _Parameter = _Parameter or "true"
        self.Delete = API.ToBoolean(_Parameter)
    end
end

function B_Goal_SpyOnBuilding:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" };
    end
end

function B_Goal_SpyOnBuilding:SetDescriptionOverwrite(_Quest)
    if not _Quest.QuestDescription then
        local text = {
            de = "Geb??ude infriltrieren {cr}{cr}Spioniere das markierte Geb??ude mit einem Dieb aus!",
            en = "Infiltrate building {cr}{cr}Spy on the highlighted buildings with a thief!",
            fr = "Infiltrer un b??timent {cr}{cr}Espionner le b??timent marqu?? avec un voleur!",
        };
        return API.Localize(text);
    else
        return _Quest.QuestDescription;
    end
end

function B_Goal_SpyOnBuilding:CustomFunction(_Quest)
    if not IsExisting(self.Building) then
        if self.Marker then
            Logic.DestroyEffect(self.Marker);
        end
        return false;
    end

    if not self.Marker then
        local pos = GetPosition(self.Building);
        self.Marker = Logic.CreateEffect(EGL_Effects.E_Questmarker, pos.X, pos.Y, 0);
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local BuildingID = GetID(self.Building);
        if  Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1
        and Logic.GetBuildingEarnings(BuildingID) < 5 then
            Logic.SetBuildingEarnings(BuildingID, 5);
        end
    end

    if self.Infiltrated then
        Logic.DestroyEffect(self.Marker);
        return true;
    end
    return nil;
end

function B_Goal_SpyOnBuilding:GetIcon()
    return self.IconOverwrite;
end

function B_Goal_SpyOnBuilding:Debug(_Quest)
    if Logic.IsBuilding(GetID(self.Building)) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is not a building");
        return true;
    elseif not IsExisting(self.Building) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is destroyed :(");
        return true;
    end
    return false;
end

function B_Goal_SpyOnBuilding:Reset(_Quest)
    self.Infiltrated = false;
    self.Marker = nil;
end

function B_Goal_SpyOnBuilding:Interrupt(_Quest)
    Logic.DestroyEffect(self.Marker);
end

Swift:RegisterBehavior(B_Goal_SpyOnBuilding);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss eine Anzahl an Gegenst??nden finden, die bei den angegebenen
-- Positionen platziert werden.
--
-- @param[type=string] _Positions Pr??fix aller durchnummerierten Enttities
-- @param[type=string] _Model     Model f??r alle Gegenst??nde
-- @param[type=number] _Distance  Aktivierungsdistanz (0 = Default = 300)
--
-- @within Goal
--
function Goal_FetchItems(...)
    return B_Goal_FetchItems:new(...);
end

B_Goal_FetchItems = {
    Name = "Goal_FetchItems",
    Description = {
        en = "Goal: ",
        de = "Ziel: ",
        fr = "Objectif: ",
    },
    Parameter = {
        { ParameterType.Default, en = "Search points",          de = "Suchpunkte",              fr = "Points de recherche" },
        { ParameterType.Custom,  en = "Shared model",           de = "Gemeinsames Modell",      fr = "Mod??le commun" },
        { ParameterType.Number,  en = "Distance (0 = Default)", de = "Enternung (0 = Default)", fr = "Distance (0 = Default)" },
    },

    Text = {
        {
            de = "%d/%d Gegenst??nde gefunden",
            en = "%d/%d Items gefunden",
            fr = "%d/%d objets trouv??s",
        },
        {
            de = "GEGENST??NDE FINDEN {br}{br}Findet die verloren gegangenen Gegenst??nde.",
            en = "FIND VALUABLES {br}{br}Find the missing items and return them.",
            fr = "TROUVER LES OBJETS {br}{br}Trouve les objets perdus.",
        },
    },

    Tools = {
        Models.Doodads_D_X_Sacks,
        Models.Tools_T_BowNet01,
        Models.Tools_T_Hammer02,
        Models.Tools_T_Cushion01,
        Models.Tools_T_Knife02,
        Models.Tools_T_Scythe01,
        Models.Tools_T_SiegeChest01,
    },

    Distance = 300,
    Finished = false,
    Positions = {},
    Marker = {},
}

function B_Goal_FetchItems:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_FetchItems:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SearchPositions = _Parameter;
    elseif (_Index == 1) then
        self.Model = _Parameter;
    elseif (_Index == 2) then
        if _Parameter == nil then
            _Parameter = self.Distance;
        end
        self.Distance = _Parameter * 1;
        if self.Distance == 0 then
            self.Distance = 300;
        end
    end
end

function B_Goal_FetchItems:CustomFunction(_Quest)
    Swift.Quest:ChangeCustomQuestCaptionText("{center}" ..API.Localize(self.Text[2]), _Quest);
    if not self.Finished then
        self:GetPositions(_Quest);
        self:CreateMarker(_Quest);
        self:CheckPositions(_Quest);
        if #self.Marker > 0 then
            return;
        end
        self.Finished = true;
    end
    return true;
end

function B_Goal_FetchItems:GetPositions(_Quest)
    if #self.Positions == 0 then
        -- Position is a table (script only feature)
        if type(self.SearchPositions) == "table" then
            self.Positions = self.SearchPositions;
        -- Search positions by prefix
        else
            local Index = 1;
            while (IsExisting(self.SearchPositions .. Index)) do
                table.insert(self.Positions, GetPosition(self.SearchPositions .. Index));
                Index = Index +1;
            end
        end
    end
end

function B_Goal_FetchItems:CreateMarker(_Quest)
    if #self.Marker == 0 then
        for i= 1, #self.Positions, 1 do
            local ID = Logic.CreateEntityOnUnblockedLand(Entities.XD_ScriptEntity, self.Positions[i].X, self.Positions[i].Y, 0, 0);
            if self.Model ~= nil and self.Model ~= "-" then
                Logic.SetModel(ID, Models[self.Model]);
            else
                Logic.SetModel(ID, self.Tools[math.random(1, #self.Tools)]);
            end
            Logic.SetVisible(ID, true);
            table.insert(self.Marker, ID);
        end
    end
end

function B_Goal_FetchItems:CheckPositions(_Quest)
    local Heroes = {};
    Logic.GetKnights(_Quest.ReceivingPlayer, Heroes);
    for i= #self.Marker, 1, -1 do
        for j= 1, #Heroes, 1 do
            if IsNear(self.Marker[i], Heroes[j], self.Distance) then
                DestroyEntity(table.remove(self.Marker, i));
                local Max = #self.Positions;
                local Now = Max - #self.Marker;
                API.Note(string.format(API.Localize(self.Text[1]), Now, Max));
                break;
            end
        end
    end
end

function B_Goal_FetchItems:Reset(_Quest)
    self:Interrupt(_Quest);
end

function B_Goal_FetchItems:Interrupt(_Quest)
    self.Finished = false;
    self.Positions = {};
    for i= 1, #self.Marker, 1 do
        DestroyEntity(self.Marker[i]);
    end
    self.Marker = {};
end

function B_Goal_FetchItems:GetCustomData(_Index)
    if _Index == 1 then
        local Data = ModuleBehaviorCollection.Global:GetPossibleModels();
        table.insert(Data, 1, "-");
        return Data;
    end
end

function B_Goal_FetchItems:Debug(_Quest)
    return false;
end

Swift:RegisterBehavior(B_Goal_FetchItems);

-- -------------------------------------------------------------------------- --

---
-- Ein beliebiger Spieler muss Soldaten eines anderen Spielers zerst??ren.
--
-- Dieses Behavior kann auch in versteckten Quests bentutzt werden, wenn die
-- Menge an zerst??rten Soldaten durch einen Feind des Spielers gefragt ist oder
-- wenn ein Verb??ndeter oder Feind nach X Verlusten aufgeben soll.
--
-- @param _PlayerA Angreifende Partei
-- @param _PlayerB Zielpartei
-- @param _Amount Menga an Soldaten
--
-- @within Goal
--
function Goal_DestroySoldiers(...)
    return B_Goal_DestroySoldiers:new(...);
end

B_Goal_DestroySoldiers = {
    Name = "Goal_DestroySoldiers",
    Description = {
        en = "Goal: Destroy a given amount of enemy soldiers",
        de = "Ziel: Zerst??re eine Anzahl gegnerischer Soldaten",
        fr = "Objectif: D??truire un certain nombre de soldats ennemis",
    },
    Parameter = {
        {ParameterType.PlayerID, en = "Attacking Player",   de = "Angreifer",   fr = "Attaquant", },
        {ParameterType.PlayerID, en = "Defending Player",   de = "Verteidiger", fr = "D??fenseur", },
        {ParameterType.Number,   en = "Amount",             de = "Anzahl",      fr = "Quantit??", },
    },

    Text = {
        de = "{center}SOLDATEN ZERST??REN {cr}{cr}von der Partei: %s{cr}{cr}Anzahl: %d",
        en = "{center}DESTROY SOLDIERS {cr}{cr}from faction: %s{cr}{cr}Amount: %d",
        fr = "{center}DESTRUIRE DES SOLDATS {cr}{cr}de la faction: %s{cr}{cr}Nombre : %d",
    }
}

function B_Goal_DestroySoldiers:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_DestroySoldiers:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AttackingPlayer = _Parameter * 1
    elseif (_Index == 1) then
        self.AttackedPlayer = _Parameter * 1
    elseif (_Index == 2) then
        self.KillsNeeded = _Parameter * 1
    end
end

function B_Goal_DestroySoldiers:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local PlayerName = GetPlayerName(self.AttackedPlayer) or ("Player " ..self.AttackedPlayer);
        Swift.Quest:ChangeCustomQuestCaptionText(
            string.format(
                Swift.Text:Localize(self.Text),
                PlayerName, self.KillsNeeded
            ),
            _Quest
        );
    end
    if self.KillsNeeded <= ModuleBehaviorCollection.Global:GetEnemySoldierKillsOfPlayer(self.AttackingPlayer, self.AttackedPlayer) then
        return true;
    end
end

function B_Goal_DestroySoldiers:Debug(_Quest)
    if Logic.GetStoreHouse(self.AttackingPlayer) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AttackinPlayer .. " is dead :-(")
        return true
    elseif Logic.GetStoreHouse(self.AttackedPlayer) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AttackedPlayer .. " is dead :-(")
        return true
    elseif self.KillsNeeded < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount negative")
        return true
    end
end

function B_Goal_DestroySoldiers:GetIcon()
    return {7,12}
end

Swift:RegisterBehavior(B_Goal_DestroySoldiers);

-- -------------------------------------------------------------------------- --
-- Reprisals                                                                  --
-- -------------------------------------------------------------------------- --

---
-- ??ndert die Position eines Siedlers oder eines Geb??udes.
--
-- Optional kann das Entity in einem bestimmten Abstand zum Ziel platziert
-- werden und das Ziel anschauen. Die Entfernung darf nicht kleiner sein als 50!
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=string]  _Target     Skriptname des Ziels
-- @param[type=boolean] _LookAt     Gegen??berstellen
-- @param[type=number]  _Distance   Relative Entfernung (nur mit _LookAt)
--
-- @within Reprisal
--
function Reprisal_SetPosition(...)
    return B_Reprisal_SetPosition:new(...);
end

B_Reprisal_SetPosition = {
    Name = "Reprisal_SetPosition",
    Description = {
        en = "Reprisal: Places an entity relative to the position of another. The entity can look the target.",
        de = "Vergeltung: Setzt eine Entity relativ zur Position einer anderen. Die Entity kann zum Ziel ausgerichtet werden.",
        fr = "R??tribution: place une Entity vis-??-vis de l'emplacement d'une autre. L'entit?? peut ??tre orient??e vers la cible.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",          de = "Entity",          fr = "Entit??", },
        { ParameterType.ScriptName, en = "Target position", de = "Zielposition",    fr = "Position cible", },
        { ParameterType.Custom,     en = "Face to face",    de = "Ziel ansehen",    fr = "Voir la cible", },
        { ParameterType.Number,     en = "Distance",        de = "Zielentfernung",  fr = "Distance de la cible", },
    },
}

function B_Reprisal_SetPosition:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetPosition:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Target = _Parameter;
    elseif (_Index == 2) then
        self.FaceToFace = API.ToBoolean(_Parameter)
    elseif (_Index == 3) then
        self.Distance = (_Parameter ~= nil and tonumber(_Parameter)) or 100;
    end
end

function B_Reprisal_SetPosition:CustomFunction(_Quest)
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        return;
    end

    local entity = GetID(self.Entity);
    local target = GetID(self.Target);
    local x,y,z = Logic.EntityGetPos(target);
    if Logic.IsBuilding(target) == 1 then
        x,y = Logic.GetBuildingApproachPosition(target);
    end
    local ori = Logic.GetEntityOrientation(target)+90;

    if self.FaceToFace then
        x = x + self.Distance * math.cos( math.rad(ori) );
        y = y + self.Distance * math.sin( math.rad(ori) );
        Logic.DEBUG_SetSettlerPosition(entity, x, y);
        LookAt(self.Entity, self.Target);
    else
        if Logic.IsBuilding(target) == 1 then
            x,y = Logic.GetBuildingApproachPosition(target);
        end
        Logic.DEBUG_SetSettlerPosition(entity, x, y);
    end
end

function B_Reprisal_SetPosition:GetCustomData(_Index)
    if _Index == 2 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetPosition:Debug(_Quest)
    if self.FaceToFace then
        if tonumber(self.Distance) == nil or self.Distance < 50 then
            error(_Quest.Identifier.. ": " ..self.Name.. ": Distance is nil or to short!");
            return true;
        end
    end
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Mover entity or target entity does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reprisal_SetPosition);

-- -------------------------------------------------------------------------- --

---
-- ??ndert den Eigent??mer des Entity oder des Battalions.
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=number] _NewOwner   PlayerID des Eigent??mers
--
-- @within Reprisal
--
function Reprisal_ChangePlayer(...)
    return B_Reprisal_ChangePlayer:new(...)
end

B_Reprisal_ChangePlayer = {
    Name = "Reprisal_ChangePlayer",
    Description = {
        en = "Reprisal: Changes the owner of the entity or a battalion.",
        de = "Vergeltung: Aendert den Besitzer einer Entity oder eines Battalions.",
        fr = "R??tribution : Change le propri??taire d'une entit?? ou d'un bataillon.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",     de = "Entity",   fr = "Entit??", },
        { ParameterType.Custom,     en = "Player",     de = "Spieler",  fr = "Joueur", },
    },
}

function B_Reprisal_ChangePlayer:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_ChangePlayer:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Player = tostring(_Parameter);
    end
end

function B_Reprisal_ChangePlayer:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    if Logic.IsLeader(eID) == 1 then
        Logic.ChangeSettlerPlayerID(eID, self.Player);
    else
        Logic.ChangeEntityPlayerID(eID, self.Player);
    end
end

function B_Reprisal_ChangePlayer:GetCustomData(_Index)
    if _Index == 1 then
        return {"0", "1", "2", "3", "4", "5", "6", "7", "8"}
    end
end

function B_Reprisal_ChangePlayer:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reprisal_ChangePlayer);

-- -------------------------------------------------------------------------- --

---
-- ??ndert die Sichtbarkeit eines Entity.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=boolean] _Visible    Sichtbarkeit an/aus
--
-- @within Reprisal
--
function Reprisal_SetVisible(...)
    return B_Reprisal_SetVisible:new(...)
end

B_Reprisal_SetVisible = {
    Name = "Reprisal_SetVisible",
    Description = {
        en = "Reprisal: Changes the visibility of an entity. If the entity is a spawner the spawned entities will be affected.",
        de = "Vergeltung: Setzt die Sichtbarkeit einer Entity. Handelt es sich um einen Spawner werden auch die gespawnten Entities beeinflusst.",
        fr = "R??tribution: fixe la visibilit?? d'une Entit??. S'il s'agit d'un spawn, les Entities spawn??es sont ??galement affect??es.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",      de = "Entity",   fr = "Entit??", },
        { ParameterType.Custom,     en = "Visible",     de = "Sichtbar", fr = "Visible", },
    },
}

function B_Reprisal_SetVisible:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetVisible:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Visible = API.ToBoolean(_Parameter)
    end
end

function B_Reprisal_SetVisible:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end

    local eID = GetID(self.Entity);
    local pID = Logic.EntityGetPlayer(eID);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);

    if string.find(tName, "^S_") or string.find(tName, "^B_NPC_Bandits")
    or string.find(tName, "^B_NPC_Barracks") then
        local spawned = {Logic.GetSpawnedEntities(eID)};
        for i=1, #spawned do
            if Logic.IsLeader(spawned[i]) == 1 then
                local soldiers = {Logic.GetSoldiersAttachedToLeader(spawned[i])};
                for j=2, #soldiers do
                    Logic.SetVisible(soldiers[j], self.Visible);
                end
            else
                Logic.SetVisible(spawned[i], self.Visible);
            end
        end
    else
        if Logic.IsLeader(eID) == 1 then
            local soldiers = {Logic.GetSoldiersAttachedToLeader(eID)};
            for j=2, #soldiers do
                Logic.SetVisible(soldiers[j], self.Visible);
            end
        else
            Logic.SetVisible(eID, self.Visible);
        end
    end
end

function B_Reprisal_SetVisible:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetVisible:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reprisal_SetVisible);

-- -------------------------------------------------------------------------- --

---
-- Macht das Entity verwundbar oder unverwundbar.
--
-- Bei einem Battalion wirkt sich das Behavior auf alle Soldaten und den
-- (unsichtbaren) Leader aus. Wird das Behavior auf ein Spawner Entity 
-- angewendet, werden die gespawnten Entities genommen.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=boolean] _Vulnerable Verwundbarkeit an/aus
--
-- @within Reprisal
--
function Reprisal_SetVulnerability(...)
    return B_Reprisal_SetVulnerability:new(...);
end

B_Reprisal_SetVulnerability = {
    Name = "Reprisal_SetVulnerability",
    Description = {
        en = "Reprisal: Changes the vulnerability of the entity. If the entity is a spawner the spawned entities will be affected.",
        de = "Vergeltung: Macht eine Entity verwundbar oder unverwundbar. Handelt es sich um einen Spawner, sind die gespawnten Entities betroffen.",
        fr = "R??tribution: rend une Entit?? vuln??rable ou invuln??rable. S'il s'agit d'un spawn, les Entities spawn??es sont affect??es.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",             de = "Entity",     fr = "Entit??", },
        { ParameterType.Custom,     en = "Vulnerability",      de = "Verwundbar", fr = "Vuln??rabilit??", },
    },
}

function B_Reprisal_SetVulnerability:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetVulnerability:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Vulnerability = API.ToBoolean(_Parameter)
    end
end

function B_Reprisal_SetVulnerability:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);
    local EntitiesToCheck = {eID};
    if string.find(tName, "S_") or string.find(tName, "B_NPC_Bandits")
    or string.find(tName, "B_NPC_Barracks") then
        EntitiesToCheck = {Logic.GetSpawnedEntities(eID)};
    end
    local MethodToUse = "MakeInvulnerable";
    if self.Vulnerability then
        MethodToUse = "MakeVulnerable";
    end
    for i= 1, #EntitiesToCheck, 1 do
        if Logic.IsLeader(EntitiesToCheck[i]) == 1 then
            local Soldiers = {Logic.GetSoldiersAttachedToLeader(EntitiesToCheck[i])};
            for j=2, #Soldiers, 1 do
                _G[MethodToUse](Soldiers[j]);
            end
        end
        _G[MethodToUse](EntitiesToCheck[i]);
    end
end

function B_Reprisal_SetVulnerability:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetVulnerability:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reprisal_SetVulnerability);

-- -------------------------------------------------------------------------- --

---
-- ??ndert das Model eines Entity.
--
-- In Verbindung mit Reward_SetVisible oder Reprisal_SetVisible k??nnen
-- Script Entites ein neues Model erhalten und sichtbar gemacht werden.
-- Das hat den Vorteil, das Script Entities nicht ??berbaut werden k??nnen.
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=string] _Model      Neues Model
--
-- @within Reprisal
--
function Reprisal_SetModel(...)
    return B_Reprisal_SetModel:new(...);
end

B_Reprisal_SetModel = {
    Name = "Reprisal_SetModel",
    Description = {
        en = "Reprisal: Changes the model of the entity. Be careful, some models crash the game.",
        de = "Vergeltung: ??ndert das Model einer Entity. Achtung: Einige Modelle f??hren zum Absturz.",
        fr = "R??tribution: modifie le mod??le d'une entit??. Attention: certains mod??les entra??nent un crash.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",    de = "Entity", fr = "Entit??", },
        { ParameterType.Custom,     en = "Model",     de = "Model",  fr = "Mod??le", },
    },
}

function B_Reprisal_SetModel:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetModel:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Model = _Parameter;
    end
end

function B_Reprisal_SetModel:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    Logic.SetModel(eID, Models[self.Model]);
end

-- Hinweis: Kann nicht durch Aufruf der Methode von B_Goal_FetchItems
-- vereinfacht werden, weil man im Editor keine Methoden aufrufen kann!
function B_Reprisal_SetModel:GetCustomData(_Index)
    if _Index == 1 then
        return ModuleBehaviorCollection.Global:GetPossibleModels();
    end
end

function B_Reprisal_SetModel:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    if not Models[self.Model] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": model '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reprisal_SetModel);

-- -------------------------------------------------------------------------- --
-- Rewards                                                                    --
-- -------------------------------------------------------------------------- --

---
-- ??ndert die Position eines Siedlers oder eines Geb??udes.
--
-- Optional kann das Entity in einem bestimmten Abstand zum Ziel platziert
-- werden und das Ziel anschauen. Die Entfernung darf nicht kleiner sein
-- als 50!
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=string] _Target     Skriptname des Ziels
-- @param[type=number] _LookAt     Gegen??berstellen
-- @param[type=number] _Distance   Relative Entfernung (nur mit _LookAt)
--
-- @within Reward
--
function Reward_SetPosition(...)
    return B_Reward_SetPosition:new(...);
end

B_Reward_SetPosition = Swift.LuaBase:CopyTable(B_Reprisal_SetPosition);
B_Reward_SetPosition.Name = "Reward_SetPosition";
B_Reward_SetPosition.Description.en = "Reward: Places an entity relative to the position of another. The entity can look the target.";
B_Reward_SetPosition.Description.de = "Lohn: Setzt eine Entity relativ zur Position einer anderen. Die Entity kann zum Ziel ausgerichtet werden.";
B_Reward_SetPosition.Description.fr = "R??compense: D??finit une Entity vis-??-vis de la position d'une autre. L'entit?? peut ??tre orient??e vers la cible.";
B_Reward_SetPosition.GetReprisalTable = nil;

B_Reward_SetPosition.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

Swift:RegisterBehavior(B_Reward_SetPosition);

-- -------------------------------------------------------------------------- --

---
-- ??ndert den Eigent??mer des Entity oder des Battalions.
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=number] _NewOwner   PlayerID des Eigent??mers
--
-- @within Reward
--
function Reward_ChangePlayer(...)
    return B_Reward_ChangePlayer:new(...);
end

B_Reward_ChangePlayer = Swift.LuaBase:CopyTable(B_Reprisal_ChangePlayer);
B_Reward_ChangePlayer.Name = "Reward_ChangePlayer";
B_Reward_ChangePlayer.Description.en = "Reward: Changes the owner of the entity or a battalion.";
B_Reward_ChangePlayer.Description.de = "Lohn: ??ndert den Besitzer einer Entity oder eines Battalions.";
B_Reward_ChangePlayer.Description.fr = "R??compense: Change le propri??taire d'une entit?? ou d'un bataillon.";
B_Reward_ChangePlayer.GetReprisalTable = nil;

B_Reward_ChangePlayer.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

Swift:RegisterBehavior(B_Reward_ChangePlayer);

-- -------------------------------------------------------------------------- --

---
-- Bewegt einen Siedler relativ zu einem Zielpunkt.
--
-- Der Siedler wird sich zum Ziel ausrichten und in der angegeben Distanz
-- und dem angegebenen Winkel Position beziehen.
--
-- <p><b>Hinweis:</b> Funktioniert ??hnlich wie MoveEntityToPositionToAnotherOne.
-- </p>
--
-- @param[type=string] _ScriptName  Skriptname des Entity
-- @param[type=string] _Destination Skriptname des Ziels
-- @param[type=number] _Distance    Entfernung
-- @param[type=number] _Angle       Winkel
--
-- @within Reward
--
function Reward_MoveToPosition(...)
    return B_Reward_MoveToPosition:new(...);
end

B_Reward_MoveToPosition = {
    Name = "Reward_MoveToPosition",
    Description = {
        en = "Reward: Moves an entity relative to another entity. If angle is zero the entities will be standing directly face to face.",
        de = "Lohn: Bewegt eine Entity relativ zur Position einer anderen. Wenn Winkel 0 ist, stehen sich die Entities direkt gegen??ber.",
        fr = "R??compense: D??place une entit?? par rapport ?? la position d'une autre. Si l'angle est ??gal ?? 0, les entit??s sont directement oppos??es.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Settler",     de = "Siedler",     fr = "Settler" },
        { ParameterType.ScriptName, en = "Destination", de = "Ziel",        fr = "Destination" },
        { ParameterType.Number,     en = "Distance",    de = "Entfernung",  fr = "Distance" },
        { ParameterType.Number,     en = "Angle",       de = "Winkel",      fr = "Angle" },
    },
}

function B_Reward_MoveToPosition:GetRewardTable()
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_MoveToPosition:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Target = _Parameter;
    elseif (_Index == 2) then
        self.Distance = _Parameter * 1;
    elseif (_Index == 3) then
        self.Angle = _Parameter * 1;
    end
end

function B_Reward_MoveToPosition:CustomFunction(_Quest)
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        return;
    end
    self.Angle = self.Angle or 0;

    local entity = GetID(self.Entity);
    local target = GetID(self.Target);
    local orientation = Logic.GetEntityOrientation(target);
    local x,y,z = Logic.EntityGetPos(target);
    if Logic.IsBuilding(target) == 1 then
        x, y = Logic.GetBuildingApproachPosition(target);
        orientation = orientation -90;
    end
    x = x + self.Distance * math.cos( math.rad(orientation+self.Angle) );
    y = y + self.Distance * math.sin( math.rad(orientation+self.Angle) );
    Logic.MoveSettler(entity, x, y);
    self.EntityMovingJob = API.StartJob( function(_entityID, _targetID)
        if Logic.IsEntityMoving(_entityID) == false then
            LookAt(_entityID, _targetID);
            return true;
        end
    end, entity, target);
end

function B_Reward_MoveToPosition:Reset(_Quest)
    if self.EntityMovingJob then
        API.EndJob(self.EntityMovingJob);
    end
end

function B_Reward_MoveToPosition:Debug(_Quest)
    if tonumber(self.Distance) == nil or self.Distance < 50 then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Distance is nil or to short!");
        return true;
    elseif not IsExisting(self.Entity) or not IsExisting(self.Target) then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Mover entity or target entity does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reward_MoveToPosition);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler gewinnt das Spiel mit einem animierten Siegesfest.
--
-- Wenn nach dem Sieg weiter gespielt wird, wird das Fest gel??scht.
--
-- <h5>Multiplayer</h5>
-- Nicht f??r Multiplayer geeignet.
--
-- @within Reward
--
function Reward_VictoryWithParty()
    return B_Reward_VictoryWithParty:new();
end

B_Reward_VictoryWithParty = {
    Name = "Reward_VictoryWithParty",
    Description = {
        en = "Reward: (Singleplayer) The player wins the game with an animated festival on the market. Continue playing deleates the festival.",
        de = "Lohn: (Einzelspieler) Der Spieler gewinnt das Spiel mit einer animierten Siegesfeier. Bei weiterspielen wird das Fest gel??scht.",
        fr = "R??compense: (Joueur unique) Le joueur gagne la partie avec une f??te de la victoire anim??e. Si le joueur continue ?? jouer, la f??te est effac??e.",
    },
    Parameter = {}
};

function B_Reward_VictoryWithParty:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction}};
end

function B_Reward_VictoryWithParty:AddParameter(_Index, _Parameter)
end

function B_Reward_VictoryWithParty:CustomFunction(_Quest)
    if Framework.IsNetworkGame() then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Can not be used in multiplayer!");
        return;
    end
    Victory(g_VictoryAndDefeatType.VictoryMissionComplete);
    local pID = _Quest.ReceivingPlayer;

    local market = Logic.GetMarketplace(pID);
    if IsExisting(market) then
        local pos = GetPosition(market)
        Logic.CreateEffect(EGL_Effects.FXFireworks01,pos.X,pos.Y,0);
        Logic.CreateEffect(EGL_Effects.FXFireworks02,pos.X,pos.Y,0);

        local Generated = self:GenerateParty(pID);
        ModuleBehaviorCollection.Global.VictoryWithPartyEntities[pID] = Generated;

        Logic.ExecuteInLuaLocalState(string.format(
            [[
            if IsExisting(%d) then
                CameraAnimation.AllowAbort = false
                CameraAnimation.QueueAnimation(CameraAnimation.SetCameraToEntity, %d)
                CameraAnimation.QueueAnimation(CameraAnimation.StartCameraRotation, 5)
                CameraAnimation.QueueAnimation(CameraAnimation.Stay ,9999)
            end

            GUI_Window.ContinuePlayingClicked_Orig_Reward_VictoryWithParty = GUI_Window.ContinuePlayingClicked
            GUI_Window.ContinuePlayingClicked = function()
                GUI_Window.ContinuePlayingClicked_Orig_Reward_VictoryWithParty()
                
                local PlayerID = GUI.GetPlayerID()
                GUI.SendScriptCommand("B_Reward_VictoryWithParty:ClearParty(" ..PlayerID.. ")")

                CameraAnimation.AllowAbort = true
                CameraAnimation.Abort()
            end
            ]],
            market,
            market
        ));
    end
end

function B_Reward_VictoryWithParty:ClearParty(_PlayerID)
    if ModuleBehaviorCollection.Global.VictoryWithPartyEntities[_PlayerID] then
        for k, v in pairs(ModuleBehaviorCollection.Global.VictoryWithPartyEntities[_PlayerID]) do
            DestroyEntity(v);
        end
        ModuleBehaviorCollection.Global.VictoryWithPartyEntities[_PlayerID] = nil;
    end
end

function B_Reward_VictoryWithParty:GenerateParty(_PlayerID)
    local GeneratedEntities = {};
    local Marketplace = Logic.GetMarketplace(_PlayerID);
    if Marketplace ~= nil and Marketplace ~= 0 then
        local MarketX, MarketY = Logic.GetEntityPosition(Marketplace);
        local ID = Logic.CreateEntity(Entities.D_X_Garland, MarketX, MarketY, 0, _PlayerID)
        table.insert(GeneratedEntities, ID);
        for j=1, 10 do
            for k=1,10 do
                local SettlersX = MarketX -700+ (j*150);
                local SettlersY = MarketY -700+ (k*150);
                
                local rand = Logic.GetRandom(100);
                
                if rand > 70 then
                    local SettlerType = API.GetRandomSettlerType();
                    local Orientation = Logic.GetRandom(360);
                    local WorkerID = Logic.CreateEntityOnUnblockedLand(SettlerType, SettlersX, SettlersY, Orientation, _PlayerID);
                    Logic.SetTaskList(WorkerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH);
                    table.insert(GeneratedEntities, WorkerID);
                end
            end
        end
    end
    return GeneratedEntities;
end

function B_Reward_VictoryWithParty:Debug(_Quest)
    return false;
end

Swift:RegisterBehavior(B_Reward_VictoryWithParty);

-- -------------------------------------------------------------------------- --

---
-- ??ndert die Sichtbarkeit eines Entity.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=boolean] _Visible    Sichtbarkeit an/aus
--
-- @within Reprisal
--
function Reward_SetVisible(...)
    return B_Reward_SetVisible:new(...)
end

B_Reward_SetVisible = Swift.LuaBase:CopyTable(B_Reprisal_SetVisible);
B_Reward_SetVisible.Name = "Reward_SetVisible";
B_Reward_SetVisible.Description.en = "Reward: Changes the visibility of an entity. If the entity is a spawner the spawned entities will be affected.";
B_Reward_SetVisible.Description.de = "Lohn: Setzt die Sichtbarkeit einer Entity. Handelt es sich um einen Spawner werden auch die gespawnten Entities beeinflusst.";
B_Reward_SetVisible.Description.fr = "R??compense: D??finit la visibilit?? d'une Entity. S'il s'agit d'un spawn, les entit??s spawn??es sont ??galement influenc??es.";
B_Reward_SetVisible.GetReprisalTable = nil;

B_Reward_SetVisible.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

Swift:RegisterBehavior(B_Reward_SetVisible);

-- -------------------------------------------------------------------------- --

---
-- Macht das Entity verwundbar oder unverwundbar.
--
-- Bei einem Battalion wirkt sich das Behavior auf alle Soldaten und den
-- (unsichtbaren) Leader aus. Wird das Behavior auf ein Spawner Entity 
-- angewendet, werden die gespawnten Entities genommen.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=boolean] _Vulnerable Verwundbarkeit an/aus
--
-- @within Reward
--
function Reward_SetVulnerability(...)
    return B_Reward_SetVulnerability:new(...);
end

B_Reward_SetVulnerability = Swift.LuaBase:CopyTable(B_Reprisal_SetVulnerability);
B_Reward_SetVulnerability.Name = "Reward_SetVulnerability";
B_Reward_SetVulnerability.Description.en = "Reward: Changes the vulnerability of the entity. If the entity is a spawner the spawned entities will be affected.";
B_Reward_SetVulnerability.Description.de = "Lohn: Macht eine Entity verwundbar oder unverwundbar. Handelt es sich um einen Spawner, sind die gespawnten Entities betroffen.";
B_Reward_SetVulnerability.Description.fr = "R??compense: Rend une Entit?? vuln??rable ou invuln??rable. S'il s'agit d'un spawn, les entit??s spawn??es sont affect??es.";
B_Reward_SetVulnerability.GetReprisalTable = nil;

B_Reward_SetVulnerability.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

Swift:RegisterBehavior(B_Reward_SetVulnerability);

-- -------------------------------------------------------------------------- --

---
-- ??ndert das Model eines Entity.
--
-- In Verbindung mit Reward_SetVisible oder Reprisal_SetVisible k??nnen
-- Script Entites ein neues Model erhalten und sichtbar gemacht werden.
-- Das hat den Vorteil, das Script Entities nicht ??berbaut werden k??nnen.
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=string] _Model      Neues Model
--
-- @within Reward
--
function Reward_SetModel(...)
    return B_Reward_SetModel:new(...);
end

B_Reward_SetModel = Swift.LuaBase:CopyTable(B_Reprisal_SetModel);
B_Reward_SetModel.Name = "Reward_SetModel";
B_Reward_SetModel.Description.en = "Reward: Changes the model of the entity. Be careful, some models crash the game.";
B_Reward_SetModel.Description.de = "Lohn: ??ndert das Model einer Entity. Achtung: Einige Modelle f??hren zum Absturz.";
B_Reward_SetModel.Description.fr = "R??compense: Modifie le mod??le d'une entit??. Attention : certains mod??les entra??nent un plantage.";
B_Reward_SetModel.GetReprisalTable = nil;

B_Reward_SetModel.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

Swift:RegisterBehavior(B_Reward_SetModel);

-- -------------------------------------------------------------------------- --

---
-- Gibt oder entzieht einem KI-Spieler die Kontrolle ??ber ein Entity.
--
-- @param[type=string]  _ScriptName Skriptname des Entity
-- @param[type=boolean] _Controlled Durch KI kontrollieren an/aus
--
-- @within Reward
--
function Reward_AI_SetEntityControlled(...)
    return B_Reward_AI_SetEntityControlled:new(...);
end

B_Reward_AI_SetEntityControlled = {
    Name = "Reward_AI_SetEntityControlled",
    Description = {
        en = "Reward: Bind or Unbind an entity or a battalion to/from an AI player. The AI player must be activated!",
        de = "Lohn: Die KI kontrolliert die Entity oder der KI die Kontrolle entziehen. Die KI muss aktiv sein!",
        fr = "R??compense: L'IA contr??le l'entit?? ou retirer le contr??le ?? l'IA. L'IA doit ??tre active !",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",            de = "Entity",                 fr = "Entit??", },
        { ParameterType.Custom,     en = "AI control entity", de = "KI kontrolliert Entity", fr = "L'IA contr??le l'entit??", },
    },
}

function B_Reward_AI_SetEntityControlled:GetRewardTable()
    return { Reward.Custom, { self, self.CustomFunction } }
end

function B_Reward_AI_SetEntityControlled:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Hidden = API.ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SetEntityControlled:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    local pID = Logic.EntityGetPlayer(eID);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);
    if string.find(tName, "S_") or string.find(tName, "B_NPC_Bandits")
    or string.find(tName, "B_NPC_Barracks") then
        local spawned = {Logic.GetSpawnedEntities(eID)};
        for i=1, #spawned do
            if Logic.IsLeader(spawned[i]) == 1 then
                AICore.HideEntityFromAI(pID, spawned[i], not self.Hidden);
            end
        end
    else
        AICore.HideEntityFromAI(pID, eID, not self.Hidden);
    end
end

function B_Reward_AI_SetEntityControlled:GetCustomData(_Index)
    if _Index == 1 then
        return { "false", "true" }
    end
end

function B_Reward_AI_SetEntityControlled:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Reward_AI_SetEntityControlled);

-- -------------------------------------------------------------------------- --
-- Trigger                                                                    --
-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald mindestens X von Y Quests fehlgeschlagen sind.
--
-- @param[type=number] _MinAmount Mindestens zu verlieren (max. 5)
-- @param[type=number] _QuestAmount Anzahl gepr??fter Quests (max. 5 und >= _MinAmount)
-- @param[type=string] _Quest1      Name des 1. Quest
-- @param[type=string] _Quest2      Name des 2. Quest
-- @param[type=string] _Quest3      Name des 3. Quest
-- @param[type=string] _Quest4      Name des 4. Quest
-- @param[type=string] _Quest5      Name des 5. Quest
--
-- @within Trigger
--
function Trigger_OnAtLeastXOfYQuestsFailed(...)
    return B_Trigger_OnAtLeastXOfYQuestsFailed:new(...);
end

B_Trigger_OnAtLeastXOfYQuestsFailed = {
    Name = "Trigger_OnAtLeastXOfYQuestsFailed",
    Description = {
        en = "Trigger: if at least X of Y given quests has been finished successfully.",
        de = "Ausl??ser: wenn X von Y angegebener Quests fehlgeschlagen sind.",
        fr = "D??clencheur: lorsque X des Y qu??tes indiqu??es ont ??chou??.",
    },
    Parameter = {
        { ParameterType.Custom,    en = "Least Amount", de = "Mindest Anzahl",  fr = "Nombre minimum" },
        { ParameterType.Custom,    en = "Quest Amount", de = "Quest Anzahl",    fr = "Nombre de qu??tes" },
        { ParameterType.QuestName, en = "Quest name 1", de = "Questname 1",     fr = "Nom de la qu??te 1" },
        { ParameterType.QuestName, en = "Quest name 2", de = "Questname 2",     fr = "Nom de la qu??te 2" },
        { ParameterType.QuestName, en = "Quest name 3", de = "Questname 3",     fr = "Nom de la qu??te 3" },
        { ParameterType.QuestName, en = "Quest name 4", de = "Questname 4",     fr = "Nom de la qu??te 4" },
        { ParameterType.QuestName, en = "Quest name 5", de = "Questname 5",     fr = "Nom de la qu??te 5" },
    },
}

function B_Trigger_OnAtLeastXOfYQuestsFailed:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.LeastAmount = tonumber(_Parameter)
    elseif (_Index == 1) then
        self.QuestAmount = tonumber(_Parameter)
    elseif (_Index == 2) then
        self.QuestName1 = _Parameter
    elseif (_Index == 3) then
        self.QuestName2 = _Parameter
    elseif (_Index == 4) then
        self.QuestName3 = _Parameter
    elseif (_Index == 5) then
        self.QuestName4 = _Parameter
    elseif (_Index == 6) then
        self.QuestName5 = _Parameter
    end
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:CustomFunction()
    local least = 0
    for i = 1, self.QuestAmount do
		local QuestID = GetQuestID(self["QuestName"..i]);
        if IsValidQuest(QuestID) then
			if (Quests[QuestID].Result == QuestResult.Failure) then
				least = least + 1
				if least >= self.LeastAmount then
					return true
				end
			end
        end
    end
    return false
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:Debug(_Quest)
    local leastAmount = self.LeastAmount
    local questAmount = self.QuestAmount
    if leastAmount <= 0 or leastAmount >5 then
        error(_Quest.Identifier .. ":" .. self.Name .. ": LeastAmount is wrong")
        return true
    elseif questAmount <= 0 or questAmount > 5 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": QuestAmount is wrong")
        return true
    elseif leastAmount > questAmount then
        error(_Quest.Identifier.. ": " ..self.Name .. ": LeastAmount is greater than QuestAmount")
        return true
    end
    for i = 1, questAmount do
        if not IsValidQuest(self["QuestName"..i]) then
            error(_Quest.Identifier.. ": " ..self.Name .. ": Quest ".. self["QuestName"..i] .. " not found")
            return true
        end
    end
    return false
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:GetCustomData(_Index)
    if (_Index == 0) or (_Index == 1) then
        return {"1", "2", "3", "4", "5"}
    end
end

Swift:RegisterBehavior(B_Trigger_OnAtLeastXOfYQuestsFailed)

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald die Munition in der Kriegsmaschine ersch??pft ist.
--
-- @param[type=string] _ScriptName Skriptname des Entity
--
-- @within Trigger
--
function Trigger_AmmunitionDepleted(...)
    return B_Trigger_AmmunitionDepleted:new(...);
end

B_Trigger_AmmunitionDepleted = {
    Name = "Trigger_AmmunitionDepleted",
    Description = {
        en = "Trigger: if the ammunition of the entity is depleted.",
        de = "Ausl??ser: wenn die Munition der Entity aufgebraucht ist.",
        fr = "D??clencheur: lorsque les munitions de l'entit?? sont ??puis??es.",
    },
    Parameter = {
        { ParameterType.Scriptname, en = "Script name", de = "Skriptname", fr = "Nom de l'entit??" },
    },
}

function B_Trigger_AmmunitionDepleted:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_AmmunitionDepleted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Scriptname = _Parameter
    end
end

function B_Trigger_AmmunitionDepleted:CustomFunction()
    if not IsExisting(self.Scriptname) then
        return false;
    end

    local EntityID = GetID(self.Scriptname);
    if Logic.GetAmmunitionAmount(EntityID) > 0 then
        return false;
    end

    return true;
end

function B_Trigger_AmmunitionDepleted:Debug(_Quest)
    if not IsExisting(self.Scriptname) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": '"..self.Scriptname.."' is destroyed!");
        return true
    end
    return false
end

Swift:RegisterBehavior(B_Trigger_AmmunitionDepleted)

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, wenn exakt einer von beiden Quests erfolgreich ist.
--
-- @param[type=string] _QuestName1 Name des ersten Quest
-- @param[type=string] _QuestName2 Name des zweiten Quest
--
-- @within Trigger
--
function Trigger_OnExactOneQuestIsWon(...)
    return B_Trigger_OnExactOneQuestIsWon:new(...);
end

B_Trigger_OnExactOneQuestIsWon = {
    Name = "Trigger_OnExactOneQuestIsWon",
    Description = {
        en = "Trigger: if one of two given quests has been finished successfully, but NOT both.",
        de = "Ausl??ser: wenn eine von zwei angegebenen Quests (aber NICHT beide) erfolgreich abgeschlossen wurde.",
        fr = "D??clencheur: lorsque l'une des deux qu??tes indiqu??es (mais PAS les deux) a ??t?? accomplie avec succ??s.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la qu??te 1", },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la qu??te 2", },
    },
}

function B_Trigger_OnExactOneQuestIsWon:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnExactOneQuestIsWon:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnExactOneQuestIsWon:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if Quest2 and Quest1 then
        local Quest1Succeed = (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Success);
        local Quest2Succeed = (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Success);
        if (Quest1Succeed and not Quest2Succeed) or (not Quest1Succeed and Quest2Succeed) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnExactOneQuestIsWon:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        error(_Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Trigger_OnExactOneQuestIsWon);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, wenn exakt einer von beiden Quests fehlgeschlagen ist.
--
-- @param[type=string] _QuestName1 Name des ersten Quest
-- @param[type=string] _QuestName2 Name des zweiten Quest
--
-- @within Trigger
--
function Trigger_OnExactOneQuestIsLost(...)
    return B_Trigger_OnExactOneQuestIsLost:new(...);
end

B_Trigger_OnExactOneQuestIsLost = {
    Name = "Trigger_OnExactOneQuestIsLost",
    Description = {
        en = "Trigger: If one of two given quests has been lost, but NOT both.",
        de = "Ausl??ser: Wenn einer von zwei angegebenen Quests (aber NICHT beide) fehlschl??gt.",
        fr = "D??clencheur: Si l'une des deux qu??tes indiqu??es (mais PAS les deux) ??choue.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la qu??te 1", },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la qu??te 2", },
    },
}

function B_Trigger_OnExactOneQuestIsLost:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnExactOneQuestIsLost:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnExactOneQuestIsLost:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if Quest2 and Quest1 then
        local Quest1Succeed = (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Failure);
        local Quest2Succeed = (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Failure);
        if (Quest1Succeed and not Quest2Succeed) or (not Quest1Succeed and Quest2Succeed) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnExactOneQuestIsLost:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        error(_Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

Swift:RegisterBehavior(B_Trigger_OnExactOneQuestIsLost);

