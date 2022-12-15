--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

API = {};
SCP = {Core = {}};

QSB = {};
QSB.Version = "4.0.0 (ALPHA 1.0.0)";

---
-- Stellt wichtige Kernfunktionen bereit.
--
-- <h5>Behobene Fehler</h5>
--
-- Die QSB kommt mit einigen Bugfixes mit, die Fehler im Spiel beheben.
--
-- <ul>
-- <li>NPC-Lagerhäuser können jetzt Salz und Farbe einlagern.</li>
-- <li>Die NPC-Kasernen von Mitteleuropa respawnen jetzt Soldaten.</li>
-- <li>Werden Waren im Zuge eines Quests gesandt, wird bei den Zielgebäuden von
-- der Position des Eingangs ausgegangen anstatt von der Gebäudemitte. Dadurch
-- schlagen Lieferungen bei bestimmten Lagerhäusern nicht mehr fehl.</li>
-- <li>Bei interaktiven Objekten können jetzt auch nur zwei Rohstoffe anstatt
-- von Gold und einem Rohstoff als Kosten benutzt werden.</li>
-- <li>Spezielle Script Entities werden nicht mehr fälschlich mitgezählt.</li>
-- </ul>
--
-- <h5>Scripting Values</h5>
-- Bei den Scripting Values handelt es sich um einige Werte, die direkt im
-- Arbeitsspeicher manipuliert werden können und Auswirkungen auf Entities
-- haben.
--
-- Liste der derzeit unterstützten Werte:
-- <ul>
-- <li><b>QSB.ScriptingValue.Destination.X</b><br>
-- Gibt die Z-Koordinate des Bewegungsziels als Float zurück.</li>
-- <li><b>QSB.ScriptingValue.Destination.Y</b><br>
-- Gibt die Y-Koordinate des Bewegungsziels als Float zurück.</li>
-- <li><b>QSB.ScriptingValue.Health</b><br>
-- Setzt die Gesundheit eines Entity ohne Folgeaktionen zu triggern.</li>
-- <li><b>QSB.ScriptingValue.Player</b><br>
-- Setzt den Besitzer des Entity ohne Plausibelitätsprüfungen.</li>
-- <li><b>QSB.ScriptingValue.Size</b><br>
-- Setzt den Größenfaktor eines Entities als Float.</li>
-- <li><b>QSB.ScriptingValue.Visible</b><br>
-- Sichtbarkeit eines Entities abfragen (801280 == sichtbar)</li>
-- <li><b>QSB.ScriptingValue.NPC</b><br>
-- NPC-Flag eines Siedlers setzen (0 = inaktiv, 1 - 4 = aktiv)</li>
-- </ul>
--
-- <h5>Platzhalter</h5>
--
-- <u>Mehrsprachige Texte:</u>
-- Anstatt eines Strings wird ein Table mit dem gleichen Text in verschiedenen
-- Sprachen angegeben. Der richtige Text wird anhand der eingestellten Sprache
-- gewählt. Wenn nichts vorgegeben wird, ist die Systemsprache voreingestellt.
-- Als Standard für nichtdeutsche Sprachen wird Englisch verwendet, wenn für
-- die Sprache selbst kein Text vorhanden ist. Es muss also immer wenigstens
-- English (en) und Deutsch (de) vorhanden sein. <br>
-- Einige Features lokalisieren Texte automatisch. <br>
-- (Siehe dazu: <a href="#API.Localize">API.Localize</a>)
--
-- <u>Platzhalter in Texten:</u>
-- In Texten können vordefinierte Farben, Namen für Entity-Typen und benannte
-- Entities, sowie Inhalte von Variablen ersetzt werden. Dies wird von einigen
-- QSB-Features automatisch vorgenommen. Es kann Mittels API-Funktion auch
-- manuell angestoßen werden. <br>
-- (Siehe dazu: <a href="#API.ConvertPlaceholders">API.ConvertPlaceholders</a>)
--
-- <h5>Entwicklungsmodus</h5>
--
-- Die QSB kann verschiedene Optionen zum schnelleren Testen und finden von
-- fehlern aktivieren. <br>
-- (Siehe dazu: <a href="#API.ActivateDebugMode">API.ActivateDebugMode</a>)
--
-- <b>Befehle:</b><br>
-- <i>Diese Befehle können über die Konsole (SHIFT + ^) eingegeben werden, wenn
-- der Debug Mode aktiviert ist.</i><br>
-- <table border="1">
-- <tr>
-- <td><b>Befehl</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>restartmap</td>
-- <td>Map sofort neu starten</td>
-- </tr>
-- <tr>
-- <td>&gt; [Befehl]</td>
-- <td>Einen Lua Befehl im globalen Skript ausführen.
-- (Die Zeichen", ', {, } können nicht verwendet werden)</td>
-- </tr>
-- <tr>
-- <td>&gt;&gt; [Befehl]</td>
-- <td>Einen Lua Befehl im lokalen Skript ausführen.
-- (Die Zeichen", ', {, } können nicht verwendet werden)</td>
-- </tr>
-- <tr>
-- <td>&lt; [Pfad]</td>
-- <td>Lua-Datei zur Laufzeit ins globale Skript laden.</td>
-- </tr>
-- <tr>
-- <td>&lt;&lt; [Pfad]</td>
-- <td>Lua-Datei zur Laufzeit ins lokale Skript laden.</td>
-- </tr>
-- </table>
--
-- <b>Cheats:</b><br>
-- <i>Bei aktivierten Debug Mode können diese Cheat Codes verwendet werden.</i><br>
-- <table border="1">
-- <tr>
-- <td><b>Cheat</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>SHIFT + ^</td>
-- <td>Konsole öffnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + ALT + R</td>
-- <td>Map sofort neu starten.</td>
-- </tr>
-- <td>CTRL + C</td>
-- <td>Zeitanzeige an/aus</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + A</td>
-- <td>Clutter (Gräser) anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + C</td>
-- <td>Grasobjekte anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + E</td>
-- <td>Laubbäume anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + F</td>
-- <td>FoW anzeigen (an/aus) <i>Gebiete werden dauerhaft erkundet!</i></td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + G</td>
-- <td>GUI anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + H</td>
-- <td>Steine und Tannen anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + R</td>
-- <td>Straßen anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + S</td>
-- <td>Schatten anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + T</td>
-- <td>Boden anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + U</td>
-- <td>FoW anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + W</td>
-- <td>Wasser anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + X</td>
-- <td>Render Mode des Wassers umschalten (Einfach und komplex)</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + Y</td>
-- <td>Himmel anzeigen (an/aus)</td>
-- </tr>
-- <tr>
-- <td>ALT + F10</td>
-- <td>Selektiertes Gebäude anzünden</td>
-- </tr>
-- <tr>
-- <td>ALT + F11</td>
-- <td>Selektierte Einheit verwunden</td>
-- </tr>
-- <tr>
-- <td>ALT + F12</td>
-- <td>Alle Rechte freigeben / wieder sperren</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + 1</td>
-- <td>FPS-Anzeige</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 4</td>
-- <td>Bogenschützen unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 5</td>
-- <td>Schwertkämpfer unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 6</td>
-- <td>Katapultkarren unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 7</td>
-- <td>Ramme unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 8</td>
-- <td>Belagerungsturm unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 9</td>
-- <td>Katapult unter der Maus spawnen</td>
-- </tr>
-- <tr>
-- <td>(Num) +</td>
-- <td>Spiel beschleunigen</td>
-- </tr>
-- <tr>
-- <td>(Num) -</td>
-- <td>Spiel verlangsamen</td>
-- </tr>
-- <tr>
-- <td>(Num) *</td>
-- <td>Geschwindigkeit zurücksetzen</td>
-- </tr>
-- <tr>
-- <td>CTRL + F1</td>
-- <td>+ 50 Gold</td>
-- </tr>
-- <tr>
-- <td>CTRL + F2</td>
-- <td>+ 10 Holz</td>
-- </tr>
-- <tr>
-- <td>CTRL + F3</td>
-- <td>+ 10 Stein</td>
-- </tr>
-- <tr>
-- <td>CTRL + F4</td>
-- <td>+ 10 Getreide</td>
-- </tr>
-- <tr>
-- <td>CTRL + F5</td>
-- <td>+ 10 Milch</td>
-- </tr>
-- <tr>
-- <td>CTRL + F6</td>
-- <td>+ 10 Kräuter</td>
-- </tr>
-- <tr>
-- <td>CTRL + F7</td>
-- <td>+ 10 Wolle</td>
-- </tr>
-- <tr>
-- <td>CTRL + F8</td>
-- <td>+ 10 auf alle Waren</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F1</td>
-- <td>+ 10 Honig</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F2</td>
-- <td>+ 10 Eisen</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F3</td>
-- <td>+ 10 Fisch</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F4</td>
-- <td>+ 10 Wild</td>
-- </tr>
-- <tr>
-- <td>ALT + F5</td>
-- <td>Bedürfnis nach Nahrung in Gebäude aktivieren</td>
-- </tr>
-- <tr>
-- <td>ALT + F6</td>
-- <td>Bedürfnis nach Kleidung in Gebäude aktivieren</td>
-- </tr>
-- <tr>
-- <td>ALT + F7</td>
-- <td>Bedürfnis nach Hygiene in Gebäude aktivieren</td>
-- </tr>
-- <tr>
-- <td>ALT + F8</td>
-- <td>Bedürfnis nach Unterhaltung in Gebäude aktivieren</td>
-- </tr>
-- <tr>
-- <td>CTRL + F9</td>
-- <td>Nahrung für selektiertes Gebäude erhöhen</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F9</td>
-- <td>Nahrung für selektiertes Gebäude verringern</td>
-- </tr>
-- <tr>
-- <td>CTRL + F10</td>
-- <td>Kleidung für selektiertes Gebäude erhöhen</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F10</td>
-- <td>Kleidung für selektiertes Gebäude verringern</td>
-- </tr>
-- <tr>
-- <td>CTRL + F11</td>
-- <td>Hygiene für selektiertes Gebäude erhöhen</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F11</td>
-- <td>Hygiene für selektiertes Gebäude verringern</td>
-- </tr>
-- <tr>
-- <td>CTRL + F12</td>
-- <td>Unterhaltung für selektiertes Gebäude erhöhen</td>
-- </tr>
-- <tr>
-- <td>SHIFT + F12</td>
-- <td>Unterhaltung für selektiertes Gebäude verringern</td>
-- </tr>
-- <tr>
-- <td>ALT + CTRL + F10</td>
-- <td>Einnahmen des selektierten Gebäudes erhöhen</td>
-- </tr>
-- <tr>
-- <td>ALT + (Num) 1</td>
-- <td>Burg selektiert → Gold verringern, Werkstatt selektiert → Ware verringern</td>
-- </tr>
-- <tr>
-- <td>ALT + (Num) 2</td>
-- <td>Burg selektiert → Gold erhöhen, Werkstatt selektiert → Ware erhöhen</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 1</td>
-- <td>Kontrolle über Spieler 1</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 2</td>
-- <td>Kontrolle über Spieler 2</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 3</td>
-- <td>Kontrolle über Spieler 3</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 4</td>
-- <td>Kontrolle über Spieler 4</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 5</td>
-- <td>Kontrolle über Spieler 5</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 6</td>
-- <td>Kontrolle über Spieler 6</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 7</td>
-- <td>Kontrolle über Spieler 7</td>
-- </tr>
-- <tr>
-- <td>CTRL + ALT + 8</td>
-- <td>Kontrolle über Spieler 8</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 0</td>
-- <td>Kamera durchschalten</td>
-- </tr>
-- <tr>
-- <td>CTRL + (Num) 1</td>
-- <td>Kamerasprünge im RTS-Mode</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + V</td>
-- <td>Territorien anzeigen</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + B</td>
-- <td>Blocking anzeigen</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + N</td>
-- <td>Gitter verstecken</td>
-- </tr>
-- <tr>
-- <td>CTRL + SHIFT + F9</td>
-- <td>DEBUG-Ausgabe einschalten</td>
-- </tr>
-- <tr>
-- <td>ALT + F9</td>
-- <td>Zufälligen Arbeiter verheiraten</td>
-- </tr>
-- </table>
--
-- @set sort=true
-- @within Beschreibung
--

ParameterType = ParameterType or {};
g_QuestBehaviorVersion = 1;
g_QuestBehaviorTypes = {};

g_GameExtraNo = 0;
if Framework then
    g_GameExtraNo = Framework.GetGameExtraNo();
elseif MapEditor then
    g_GameExtraNo = MapEditor.GetGameExtraNo();
end

---
-- Events, um auf Ereignisse zu reagieren.
--
-- <h5>Was sind Script Events</h5>
--
-- Um dem Mapper das (z.T. fehlerbehaftete) Überschreiben von Game Callbacks
-- oder anlegen von (echten) Triggern zu ersparen, wurden die Script Events
-- eingeführt. Sie vereinheitlichen alle diese Operationen. Ein Event kann
-- von einem Modul oder in den Skripten des Anwenders über einen Event Listener
-- oder ein spezielles Game Callback gefangen werden.
--
-- Ein Event zu fangen bedeutet auf ein eingetretenes Ereignis - z.B. Wenn ein
-- Spielstand geladen wurde - zu reagieren. Events werden immer sowohl im
-- globalen als auch lokalen Skript ausgelöst, wenn ein entsprechendes Ereignis
-- aufgetreten ist, anstatt vieler Callbacks, die auf eine spezifische Umgebung
-- beschränkt sind.
--
-- Module bringen manchmal Events mit. Jedes Modul, welches ein neues Event
-- einführt, wird es in seiner API-Beschreibung aufgführen.
--
-- <u>Script Events, die von der QSB direkt bereitgestellt werden:</u>
--
-- @field ChatOpened       Das Chatfenster wird angezeigt (Parameter: PlayerID)
-- @field ChatClosed       Die Chateingabe wird bestätigt (Parameter: Text, PlayerID)
-- @field LanguageSet      Die Sprache wurde geändert (Parameter: OldLanguage, NewLanguage)
-- @field QuestFailure     Ein Quest schlug fehl (Parameter: QuestID)
-- @field QuestInterrupt   Ein Quest wurde unterbrochen (Parameter: QuestID)
-- @field QuestReset       Ein Quest wurde zurückgesetzt (Parameter: QuestID)
-- @field QuestSuccess     Ein Quest wurde erfolgreich abgeschlossen (Parameter: QuestID)
-- @field QuestTrigger     Ein Quest wurde aktiviert (Parameter: QuestID)
-- @field LoadscreenClosed Der Ladebildschirm wurde beendet.
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

QSB.Environment = {
    GLOBAL = 1,
    LOCAL  = 2,
}

QSB.GameVersion = {
    ORIGINAL        = 1,
    HISTORY_EDITION = 2,
}

QSB.GameVariant = {
    VANILLA   = 1,
    COMMUNITY = 2,
}

-- -------------------------------------------------------------------------- --

Revision = {
    ModuleRegister = {},
    BehaviorRegister = {},
};

function Revision:LoadKernel()
    self.Environment = (GUI and QSB.Environment.LOCAL) or QSB.Environment.GLOBAL;
    self.GameVersion = (Network.IsNATReady and QSB.GameVersion.HISTORY_EDITION) or QSB.GameVersion.ORIGINAL;
    self.GameVariant = (Entities.U_PolarBear and QSB.GameVariant.COMMUNITY) or QSB.GameVariant.VANILLA;

    self.LuaBase:Initalize();
    self.Logging:Initalize();
    self.Job:Initalize();
    self.Event:Initalize();
    self.Save:Initalize();
    self.Chat:Initalize();
    self.Text:Initalize();
    self.Bugfix:Initalize();
    self.Utils:Initalize();
    self.Quest:Initalize();
    self.Debug:Initalize();
    self.Behavior:Initalize();

    self:SetupSaveGameHandler();
    self:SetupEscapeHandler();
    self:SetupLoadscreenHandler();
    self:SetupQsbLoadedHandler();
    self:SetupRandomSeedHandler();

    self:LoadExternFiles();
    self:LoadBehaviors();
end

-- -------------------------------------------------------------------------- --
-- File Loading

function Revision:LoadExternFiles()
    if Mission_LoadFiles then
        local FilesList = Mission_LoadFiles();
        for i= 1, #FilesList, 1 do
            if type(FilesList[i]) == "function" then
                FilesList[i]();
            else
                Script.Load(FilesList[i]);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Multiplayer

function Revision:SetupRandomSeedHandler()
    if self.Environment == QSB.Environment.GLOBAL then
        Revision.Event:CreateScriptCommand("Cmd_ProclaimateRandomSeed", function(_Seed)
            if Revision.MP_Seed_Set then
                return;
            end
            Revision.MP_Seed_Set = true;
            math.randomseed(_Seed);
            local void = math.random(1, 100);
            Logic.ExecuteInLuaLocalState(string.format(
                [[math.randomseed(%d); math.random(1, 100);]],
                _Seed
            ));
            info("Created seed: " .._Seed);
        end);
    end
end

function Revision:CreateRandomSeed()
    for PlayerID = 1, 8 do
        -- Find first human player to generate random seed
        if Logic.PlayerGetIsHumanFlag(PlayerID) and Logic.PlayerGetGameState(PlayerID) ~= 0 then
            -- If the player ID of the local client matches the ID of the first
            -- human player create the seed and broadcast it to all players
            if GUI.GetPlayerID() == PlayerID then
                local Seed = self:BuildRandomSeed(PlayerID);
                if Framework.IsNetworkGame() then
                    Revision.Event:DispatchScriptCommand(QSB.ScriptCommands.ProclaimateRandomSeed, 0, Seed);
                else
                    math.randomseed(Seed);
                    math.random(1, 100);
                    GUI.SendScriptCommand(string.format(
                        [[math.randomseed(%d); math.random(1, 100);]],
                        Seed
                    ));
                end
            end
            break;
        end
    end
end

function Revision:BuildRandomSeed(_PlayerID)
    local PlayerName = Logic.GetPlayerName(_PlayerID);
    local MapName = Framework.GetCurrentMapName();
    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    local SeedString = Framework.GetMapGUID(MapName, MapType);
    local DateText = Framework.GetSystemTimeDateString();
    SeedString = SeedString .. PlayerName .. " " .. DateText;
    local Seed = 0;
    for s in SeedString:gmatch(".") do
        Seed = Seed + ((tonumber(s) ~= nil and tonumber(s)) or s:byte());
    end
    return Seed;
end

-- -------------------------------------------------------------------------- --
-- Save Game

function Revision:SetupQsbLoadedHandler()
    if self.Environment == QSB.Environment.GLOBAL then
        Revision.Event:CreateScriptCommand("Cmd_GlobalQsbLoaded", function()
            if Mission_MP_OnQsbLoaded and not Revision.MP_FMA_Loaded and Framework.IsNetworkGame() then
                Logic.ExecuteInLuaLocalState([[
                    if Mission_MP_LocalOnQsbLoaded then
                        Mission_MP_LocalOnQsbLoaded();
                    end
                ]]);
                Revision.MP_FMA_Loaded = true;
                Mission_MP_OnQsbLoaded();
            end
        end);
    end
end

function Revision:SetupSaveGameHandler()
    QSB.ScriptEvents.SaveGameLoaded = self.Event:CreateScriptEvent("Event_SaveGameLoaded");

    if self.Environment == QSB.Environment.GLOBAL then
        Mission_OnSaveGameLoaded_Orig_Revision = Mission_OnSaveGameLoaded;
        Mission_OnSaveGameLoaded = function()
            Mission_OnSaveGameLoaded_Orig_Revision();
            Revision:OnSaveGameLoaded();
        end
    end
end

function Revision:OnSaveGameLoaded()
    -- Trigger in local script
    if self.Environment == QSB.Environment.GLOBAL then
        Logic.ExecuteInLuaLocalState("Revision:OnSaveGameLoaded()");
    end
    -- Call shared
    self.LuaBase:OnSaveGameLoaded();
    self.Logging:OnSaveGameLoaded();
    self.Job:OnSaveGameLoaded();
    self.Event:OnSaveGameLoaded();
    self.Save:OnSaveGameLoaded();
    self.Chat:OnSaveGameLoaded();
    self.Text:OnSaveGameLoaded();
    self.Bugfix:OnSaveGameLoaded();
    self.Utils:OnSaveGameLoaded();
    self.Quest:OnSaveGameLoaded();
    self.Debug:OnSaveGameLoaded();
    self.Behavior:OnSaveGameLoaded();
    -- Call local
    if self.Environment == QSB.Environment.LOCAL then
        self:SetEscapeKeyTrigger();
        self:CreateRandomSeed();
    end
    -- Send event
    self.Event:DispatchScriptEvent(QSB.ScriptEvents.SaveGameLoaded);
end

-- -------------------------------------------------------------------------- --
-- Module Registration

function Revision:LoadModules()
    for i= 1, #self.ModuleRegister, 1 do
        if self.Environment == QSB.Environment.GLOBAL then
            self.ModuleRegister[i].Local = nil;
            if self.ModuleRegister[i].Global.OnGameStart then
                self.ModuleRegister[i].Global:OnGameStart();
            end
        end
        if self.Environment == QSB.Environment.LOCAL then
            self.ModuleRegister[i].Global = nil;
            if self.ModuleRegister[i].Local.OnGameStart then
                self.ModuleRegister[i].Local:OnGameStart();
            end
        end
    end
end

function Revision:RegisterModule(_Module)
    if (type(_Module) ~= "table") then
        assert(false, "Modules must be tables!");
        return;
    end
    if _Module.Properties == nil or _Module.Properties.Name == nil then
        assert(false, "Expected name for Module!");
        return;
    end
    table.insert(self.ModuleRegister, _Module);
end

function Revision:IsModuleRegistered(_Name)
    for k, v in pairs(self.ModuleRegister) do
        return v.Properties and v.Properties.Name == _Name;
    end
end

-- -------------------------------------------------------------------------- --
-- Behavior Registration

function Revision:LoadBehaviors()
    for i= 1, #self.BehaviorRegister, 1 do
        local Behavior = self.BehaviorRegister[i];

        if not _G["B_" .. Behavior.Name].new then
            _G["B_" .. Behavior.Name].new = function(self, ...)
                local arg = {...};
                local behavior = table.copy(self);
                -- Raw parameters
                behavior.i47ya_6aghw_frxil = {};
                -- Overhead parameters
                behavior.v12ya_gg56h_al125 = {};
                for i= 1, #arg, 1 do
                    table.insert(behavior.v12ya_gg56h_al125, arg[i]);
                    if self.Parameter and self.Parameter[i] ~= nil then
                        behavior:AddParameter(i-1, arg[i]);
                    else
                        table.insert(behavior.i47ya_6aghw_frxil, arg[i]);
                    end
                end
                return behavior;
            end
        end
    end
end

function Revision:RegisterBehavior(_Behavior)
    if self.Environment == QSB.Environment.LOCAL then
        return;
    end
    if type(_Behavior) ~= "table" or _Behavior.Name == nil then
        assert(false, "Behavior is invalid!");
        return;
    end
    if _Behavior.RequiresExtraNo and _Behavior.RequiresExtraNo > g_GameExtraNo then
        return;
    end
    if not _G["B_" .. _Behavior.Name] then
        error(string.format("Behavior %s does not exist!", _Behavior.Name));
        return;
    end

    for i= 1, #g_QuestBehaviorTypes, 1 do
        if g_QuestBehaviorTypes[i].Name == _Behavior.Name then
            return;
        end
    end
    table.insert(g_QuestBehaviorTypes, _Behavior);
    table.insert(self.BehaviorRegister, _Behavior);
end

-- -------------------------------------------------------------------------- --
-- Escape Capture

function Revision:SetupEscapeHandler()
    QSB.ScriptEvents.EscapePressed = self.Event:CreateScriptEvent("Event_EscapePressed");
    if self.Environment == QSB.Environment.LOCAL then
        self:SetEscapeKeyTrigger();
    end
end

function Revision:SetEscapeKeyTrigger()
    Input.KeyBindDown(Keys.Escape, "Revision:OnPlayerPressedEscape()", 30, false);
end

function Revision:OnPlayerPressedEscape()
    -- Global
    Revision.Event:DispatchScriptCommand(
        QSB.ScriptCommands.SendScriptEvent,
        0,
        "EscapePressed",
        GUI.GetPlayerID()
    );
    -- Local
    Revision.Event:DispatchScriptCommand(QSB.ScriptEvents.EscapePressed, 0, GUI.GetPlayerID());
end

-- -------------------------------------------------------------------------- --
-- Loadscreen

function Revision:SetupLoadscreenHandler()
    QSB.ScriptEvents.LoadscreenClosed = self.Event:CreateScriptEvent("Event_LoadscreenClosed");
    if self.Environment == QSB.Environment.GLOBAL then
        self.Event:CreateScriptCommand(
            "Cmd_RegisterLoadscreenHidden",
            function()
                API.SendScriptEvent(QSB.ScriptEvents.LoadscreenClosed);
                Logic.ExecuteInLuaLocalState([[
                    API.SendScriptEvent(QSB.ScriptEvents.LoadscreenClosed)
                ]]);
            end
        );
        return;
    end

    self.Job:CreateEventJob(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            if XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 0 then
                Revision.Event:DispatchScriptCommand(
                    QSB.ScriptCommands.RegisterLoadscreenHidden,
                    GUI.GetPlayerID()
                );
                return true;
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Installiert Revision.
--
-- @within Base
-- @local
--
function API.Install()
    Revision:LoadKernel();
    Revision:LoadModules();
    collectgarbage("collect");
end

---
-- Startet die Map sofort neu.
--
-- <b>Achtung</b>: Die Funktion Framework.RestartMap kann nicht mehr verwendet
-- werden, da es sonst zu Fehlern mit dem Ladebildschirm kommt!
--
-- @within Werkzeugkasten
--
function API.RestartMap()
    Camera.RTS_FollowEntity(0);
    Framework.SetLoadScreenNeedButton(1);
    Framework.RestartMap();
end

---
-- Prüft, ob das laufende Spiel eine Multiplayerpartie in der History Edition
-- ist.
--
-- <b>Hinweis</b>: Es ist unmöglich, dass Original und History Edition in einer
-- Partie aufeinander treffen, da die alten Server längst abgeschaltet und die
-- Option zum LAN-Spiel in der HE nicht verfügbar ist.
--
-- @return[type=boolean] Spiel ist History Edition
-- @within Multiplayer
--
function API.IsHistoryEditionNetworkGame()
    return Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION and Framework.IsNetworkGame();
end

---
-- Gibt den Slot zurück, den der Spieler einnimmt. Hat der Spieler keinen
-- Slot okkupiert oder ist nicht menschlich, wird -1 zurückgegeben.
--
-- <h5>Multiplayer</h5>
-- Nur für Multiplayer ausgelegt! Nicht im Singleplayer nutzen!
--
-- @return[type=number] ID des Player
-- @return[type=number] Slot ID des Player
-- @within Multiplayer
--
function API.GetPlayerSlotID(_PlayerID)
    for i= 1, 8 do
        if Network.IsNetworkSlotIDUsed(i) then
            local CurrentPlayerID = Logic.GetSlotPlayerID(i);
            if  Logic.PlayerGetIsHumanFlag(CurrentPlayerID)
            and CurrentPlayerID == _PlayerID then
                return i;
            end
        end
    end
    return -1;
end

---
-- Gibt den Spieler zurück, welcher den Slot okkupiert. Hat der Slot keinen
-- Spieler oder ist der Spieler nicht menschlich, wird -1 zurückgegeben.
--
-- <h5>Multiplayer</h5>
-- Nur für Multiplayer ausgelegt! Nicht im Singleplayer nutzen!
--
-- @return[type=number] Slot ID des Player
-- @return[type=number] ID des Player
-- @within Multiplayer
--
function API.GetSlotPlayerID(_SlotID)
    if Network.IsNetworkSlotIDUsed(_SlotID) then
        local CurrentPlayerID = Logic.GetSlotPlayerID(_SlotID);
        if Logic.PlayerGetIsHumanFlag(CurrentPlayerID)  then
            return CurrentPlayerID;
        end
    end
    return -1;
end

---
-- Gibt eine Liste aller Spieler im Spiel zurück.
--
-- <h5>Multiplayer</h5>
-- Nur für Multiplayer ausgelegt! Nicht im Singleplayer nutzen!
--
-- @return[type=table] Liste der aktiven Spieler
-- @within Multiplayer
--
function API.GetActivePlayers()
    local PlayerList = {};
    for i= 1, 8 do
        if Network.IsNetworkSlotIDUsed(i) then
            local PlayerID = Logic.GetSlotPlayerID(i);
            if Logic.PlayerGetIsHumanFlag(PlayerID) and Logic.PlayerGetGameState(PlayerID) ~= 0 then
                table.insert(PlayerList, PlayerID);
            end
        end
    end
    return PlayerList;
end

---
-- Gibt alle Spieler zurück, auf die gerade gewartet wird.
--
-- <h5>Multiplayer</h5>
-- Nur für Multiplayer ausgelegt! Nicht im Singleplayer nutzen!
--
-- @return[type=table] Liste der aktiven Spieler
-- @within Multiplayer
--
function API.GetDelayedPlayers()
    local PlayerList = {};
    for k, v in pairs(API.GetActivePlayers()) do
        if Network.IsWaitingForNetworkSlotID(API.GetPlayerSlotID(v)) then
            table.insert(PlayerList, v);
        end
    end
    return PlayerList;
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Erweitert die Lua-Basisfunktionen um weitere Funktionen.
-- @set sort=true
-- @local
--

Revision.LuaBase = {};

QSB.Metatable = {Init = false, Weak = {}, Metas = {}, Key = 0};

function Revision.LuaBase:Initalize()
    self:OverrideTable();
    self:OverrideString();
    self:OverrideMath();
end

function Revision.LuaBase:OnSaveGameLoaded()
    self:OverrideTable();
    self:OverrideString();
    self:OverrideMath();
end

function Revision.LuaBase:OverrideTable()
    table.compare = function(t1, t2, fx)
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        fx = fx or function(t1, t2)
            return tostring(t1) < tostring(t2);
        end
        assert(type(fx) == "function");
        return fx(t1, t2);
    end

    table.equals = function(t1, t2)
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        for k, v in pairs(t1) do
            if type(v) == "table" then
                if not t2[k] or not table.equals(t2[k], v) then
                    return false;
                end
            elseif type(v) ~= "thread" and type(v) ~= "userdata" then
                if not t2[k] or t2[k] ~= v then
                    return false;
                end
            end
        end
        return true;
    end

    table.contains = function (t, e)
        assert(type(t) == "table");
        for k, v in pairs(t) do
            if v == e then
                return true;
            end
        end
        return false;
    end

    table.length = function(t)
        local c = 0;
        for k, v in pairs(t) do
            if tonumber(k) then
                c = c +1;
            end
        end
        return c;
    end

    table.size = function(t)
        local c = 0;
        for k, v in pairs(t) do
            -- Ignore n if set
            if k ~= "n" or (k == "n" and type(v) ~= "number") then
                c = c +1;
            end
        end
        return c;
    end

    table.isEmpty = function(t)
        return table.size(t) == 0;
    end

    table.copy = function (t1, t2)
        t2 = t2 or {};
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        return Revision.LuaBase:CopyTable(t1, t2);
    end

    table.invert = function (t1)
        assert(type(t1) == "table");
        local t2 = {};
        for i= table.length(t1), 1, -1 do
            table.insert(t2, t1[i]);
        end
        return t2;
    end

    table.push = function (t, e)
        assert(type(t) == "table");
        table.insert(t, 1, e);
    end

    table.pop = function (t)
        assert(type(t) == "table");
        return table.remove(t, 1);
    end

    table.tostring = function(t)
        return Revision.LuaBase:ConvertTableToString(t);
    end

    table.insertAll = function(t, ...)
        for i= 1, #arg do
            if not table.contains(t, arg[i]) then
                table.insert(t, arg[i]);
            end
        end
        return t;
    end

    table.removeAll = function(t, ...)
        for i= 1, #arg do
            for k, v in pairs(t) do
                if type(v) == "table" and type(arg[i]) then
                    if table.equals(v, arg[i]) then
                        t[k] = nil;
                    end
                else
                    if v == arg[i] then
                        t[k] = nil;
                    end
                end
            end
        end
        -- Set n as table remove would do
        t.n = table.length(t);
        return t;
    end

    table.setMetatable = function(t, meta)
        assert(type(t) == "table");
        assert(type(meta) == "table" or meta == nil);

        local oldmeta = meta;
        meta = {};
        for k,v in pairs(oldmeta) do
            meta[k] = v;
        end
        oldmeta = getmetatable(t);
        setmetatable(t, meta);
        local k = 0;
        if oldmeta and oldmeta.KeySave and t == QSB.Metatable.Weak[oldmeta.KeySave] then
            k = oldmeta.KeySave;
            if meta == nil then
                QSB.Metatable.Weak[k] = nil;
                QSB.Metatablele.Metas[k] = nil;
                return;
            end
        else
            k = QSB.Metatable.Key + 1;
            QSB.Metatable.Key = k;
        end
        QSB.Metatable.Weak[k] = t;
        QSB.Metatable.Metas[k] = meta;
        meta.KeySave = k;
    end

    table.restoreMetatables = function()
        for k, tab in pairs(QSB.Metatable.Weak) do
            setmetatable(tab, QSB.Metatable.Metas[k]);
        end
        setmetatable(QSB.Metatable.Weak, {__mode = "v"});
        setmetatable(QSB.Metatable.Metas, {__mode = "v"});
    end
    table.restoreMetatables();
end

function Revision.LuaBase:OverrideString()
    string.contains = function (self, s)
        return self:find(s) ~= nil;
    end

    string.indexOf = function (self, s)
        return self:find(s);
    end

    string.slice = function(self, _sep)
        _sep = _sep or "%s";
        if self then
            local t = {};
            for str in self:gmatch("([^".._sep.."]+)") do
                table.insert(t, str);
            end
            return t;
        end
    end

    string.join = function(self, ...)
        local s = "";
        local parts = {self, unpack(arg)};
        for i= 1, #parts do
            if type("part") == "table" then
                s = s .. string.join(unpack(parts[i]));
            else
                s = s .. tostring(parts[i]);
            end
        end
        return s;
    end

    string.replace = function(self, p, r)
        return self:gsub(p, r, 1);
    end

    string.replaceAll = function(self, p, r)
        return self:gsub(p, r);
    end
end

function Revision.LuaBase:OverrideMath()
    math.lerp = function(s, c, e)
        local f = (c - s) / e;
        return (f > 1 and 1) or f;
    end

    math.qmod = function(a, b)
        return a - math.floor(a/b)*b;
    end
end

function Revision.LuaBase:ConvertTableToString(_Table)
    assert(type(_Table) == "table");
    local String = "{";
    for k, v in pairs(_Table) do
        local key;
        if (tonumber(k)) then
            key = ""..k;
        else
            key = "\""..k.."\"";
        end
        if type(v) == "table" then
            String = String .. "[" .. key .. "] = " .. table.tostring(v) .. ", ";
        elseif type(v) == "number" then
            String = String .. "[" .. key .. "] = " .. v .. ", ";
        elseif type(v) == "string" then
            String = String .. "[" .. key .. "] = \"" .. v .. "\", ";
        elseif type(v) == "boolean" or type(v) == "nil" then
            String = String .. "[" .. key .. "] = " .. tostring(v) .. ", ";
        else
            String = String .. "[" .. key .. "] = \"" .. tostring(v) .. "\", ";
        end
    end
    String = String .. "}";
    return String;
end

function Revision.LuaBase:CopyTable(_Table1, _Table2)
    _Table1 = _Table1 or {};
    _Table2 = _Table2 or {};
    for k, v in pairs(_Table1) do
        if "table" == type(v) then
            _Table2[k] = _Table2[k] or {};
            for kk, vv in pairs(self:CopyTable(v, _Table2[k])) do
                _Table2[k][kk] = _Table2[k][kk] or vv;
            end
        else
            _Table2[k] = v;
        end
    end
    return _Table2;
end

function Revision.LuaBase:ToBoolean(_Input)
    if type(_Input) == "boolean" then
        return _Input;
    end
    if _Input == 1 or string.find(string.lower(tostring(_Input)), "^[1tjy\\+].*$") then
        return true;
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Wandelt underschiedliche Darstellungen einer Boolean in eine echte um.
--
-- Jeder String, der mit j, t, y oder + beginnt, wird als true interpretiert.
-- Alles andere als false.
--
-- Ist die Eingabe bereits ein Boolean wird es direkt zurückgegeben.
--
-- @param _Value Wahrheitswert
-- @return[type=boolean] Wahrheitswert
-- @within Base
-- @local
--
-- @usage local Bool = API.ToBoolean("+")  --> Bool = true
-- local Bool = API.ToBoolean("1")  --> Bool = true
-- local Bool = API.ToBoolean(1)  --> Bool = true
-- local Bool = API.ToBoolean("no") --> Bool = false
--
function API.ToBoolean(_Value)
    return Revision.LuaBase:ToBoolean(_Value);
end

---
-- Schreibt ein genaues Abbild der Table ins Log. Funktionen, Threads und
-- Metatables werden als Adresse geschrieben.
--
-- @param[type=table]  _Table Tabelle, die gedumpt wird
-- @param[type=string] _Name Optionaler Name im Log
-- @within Base
-- @local
-- @usage
-- Table = {1, 2, 3, {a = true}}
-- API.DumpTable(Table)
--
function API.DumpTable(_Table, _Name)
    local Start = "{";
    if _Name then
        Start = _Name.. " = \n" ..Start;
    end
    Framework.WriteToLog(Start);

    for k, v in pairs(_Table) do
        if type(v) == "table" then
            Framework.WriteToLog("[" ..k.. "] = ");
            API.DumpTable(v);
        elseif type(v) == "string" then
            Framework.WriteToLog("[" ..k.. "] = \"" ..v.. "\"");
        else
            Framework.WriteToLog("[" ..k.. "] = " ..tostring(v));
        end
    end
    Framework.WriteToLog("}");
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Interne Funktionalität zum Schreiben von Ausgaben ins Log.
--
-- @set sort=true
-- @local
--

Revision.Logging = {
    FileLogLevel = 3,
    LogLevel = 2,
};

QSB.LogLevel = {
    ALL     = 4;
    INFO    = 3;
    WARNING = 2;
    ERROR   = 1;
    OFF     = 0;
}

function Revision.Logging:Initalize()
end

function Revision.Logging:OnSaveGameLoaded()
end

function Revision.Logging:Log(_Text, _Level, _Verbose)
    if self.FileLogLevel >= _Level then
        local Level = _Text:sub(1, _Text:find(":"));
        local Text = _Text:sub(_Text:find(":")+1);
        Text = string.format(
            " (%s) %s%s",
            (Revision.Environment == QSB.Environment.LOCAL and "local") or "global",
            Framework.GetSystemTimeDateString(),
            Text
        )
        Framework.WriteToLog(Level .. Text);
    end
    if _Verbose then
        if Revision.Environment == QSB.Environment.GLOBAL then
            if self.LogLevel >= _Level then
                Logic.ExecuteInLuaLocalState(string.format(
                    [[GUI.AddStaticNote("%s")]],
                    _Text
                ));
            end
            return;
        end
        if self.LogLevel >= _Level then
            GUI.AddStaticNote(_Text);
        end
    end
end

function Revision.Logging:SetLogLevel(_ScreenLogLevel, _FileLogLevel)
    if Revision.Environment == QSB.Environment.GLOBAL then
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Logging.FileLogLevel = %d]],
            (_FileLogLevel or 0)
        ));
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Logging.LogLevel = %d]],
            (_ScreenLogLevel or 0)
        ));
        self.FileLogLevel = (_FileLogLevel or 0);
        self.LogLevel = (_ScreenLogLevel or 0);
    end
end

function debug(_Text, _Silent)
    Revision.Logging:Log("DEBUG: " .._Text, QSB.LogLevel.ALL, not _Silent);
end
function info(_Text, _Silent)
    Revision.Logging:Log("INFO: " .._Text, QSB.LogLevel.INFO, not _Silent);
end
function warn(_Text, _Silent)
    Revision.Logging:Log("WARNING: " .._Text, QSB.LogLevel.WARNING, not _Silent);
end
function error(_Text, _Silent)
    Revision.Logging:Log("ERROR: " .._Text, QSB.LogLevel.ERROR, not _Silent);
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Setzt, ab wann Log-Nachrichten geschrieben werden.
--
-- Es wird zwischen der Ausgabe am Bildschirm und dem Wegschreiben ins Log
-- unterschieden. Die Anzeige am Bildschirm kann strenger eingestellt sein,
-- als das Speichern in der Log-Datei.
--
-- Mögliche Level:
-- <table border=1>
-- <tr>
-- <td><b>Name</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>QSB.LogLevel.ALL</td>
-- <td>Alle Stufen ausgeben (Debug, Info, Warning, Error)</td>
-- </tr>
-- <tr>
-- <td>QSB.LogLevel.INFO</td>
-- <td>Erst ab Stufe Info ausgeben (Info, Warning, Error)</td>
-- </tr>
-- <tr>
-- <td>QSB.LogLevel.WARNING</td>
-- <td>Erst ab Stufe Warning ausgeben (Warning, Error)</td>
-- </tr>
-- <tr>
-- <td>QSB.LogLevel.ERROR</td>
-- <td>Erst ab Stufe Error ausgeben (Error)</td>
-- </tr>
-- <tr>
-- <td>QSB.LogLevel.OFF</td>
-- <td>Keine Meldungen ausgeben</td>
-- </tr>
-- </table>
--
-- @param[type=number] _ScreenLogLevel Level für Bildschirmausgabe
-- @param[type=number] _FileLogLevel   Level für Dateiausgaabe
-- @within Base
-- @local
--
-- @usage
-- API.SetLogLevel(QSB.LogLevel.ERROR, QSB.LogLevel.WARNING);
--
function API.SetLogLevel(_ScreenLogLevel, _FileLogLevel)
    Revision.Logging:SetLogLevel(_ScreenLogLevel, _FileLogLevel);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Kommunikation von Komponenten über Events aus dem Skript.
--
-- @set sort=true
-- @local
--

Revision.Event = {
    ScriptEventRegister   = {};
    ScriptEventListener   = {};
    ScriptCommandRegister = {};
};

QSB.ScriptCommandSequence = 2;
QSB.ScriptCommands = {};
QSB.ScriptEvents = {};

function Revision.Event:Initalize()
    self:OverrideSoldierPayment();
    if Revision.Environment == QSB.Environment.GLOBAL then
        self:CreateScriptCommand("Cmd_SendScriptEvent", function(_Event, ...)
            assert(QSB.ScriptEvents[_Event] ~= nil);
            API.SendScriptEvent(QSB.ScriptEvents[_Event], unpack(arg));
        end);
    end
end

function Revision.Event:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Script Commands

function Revision.Event:OverrideSoldierPayment()
    GameCallback_SetSoldierPaymentLevel_Orig_Revision = GameCallback_SetSoldierPaymentLevel;
    GameCallback_SetSoldierPaymentLevel = function(_PlayerID, _Level)
        if _Level <= 2 then
            return GameCallback_SetSoldierPaymentLevel_Orig_Revision(_PlayerID, _Level);
        end
        Revision.Event:ProcessScriptCommand(_PlayerID, _Level);
    end
end

function Revision.Event:CreateScriptCommand(_Name, _Function)
    if Revision.Environment == QSB.Environment.LOCAL then
        return 0;
    end
    QSB.ScriptCommandSequence = QSB.ScriptCommandSequence +1;
    local ID = QSB.ScriptCommandSequence;
    local Name = _Name;
    if string.find(_Name, "^Cmd_") then
        Name = string.sub(_Name, 5);
    end
    self.ScriptCommandRegister[ID] = {Name, _Function};
    Logic.ExecuteInLuaLocalState(string.format(
        [[
            local ID = %d
            local Name = "%s"
            Revision.Event.ScriptCommandRegister[ID] = Name
            QSB.ScriptCommands[Name] = ID
        ]],
        ID,
        Name
    ));
    QSB.ScriptCommands[Name] = ID;
    return ID;
end

function Revision.Event:DispatchScriptCommand(_ID, ...)
    if Revision.Environment == QSB.Environment.GLOBAL then
        return;
    end
    assert(_ID ~= nil);
    if self.ScriptCommandRegister[_ID] then
        local PlayerID = GUI.GetPlayerID();
        local NamePlayerID = PlayerID +4;
        local PlayerName = Logic.GetPlayerName(NamePlayerID);
        local Parameters = self:EncodeScriptCommandParameters(unpack(arg));

        if Framework.IsNetworkGame() and Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION then
            GUI.SetPlayerName(NamePlayerID, Parameters);
            GUI.SetSoldierPaymentLevel(_ID);
        else
            GUI.SendScriptCommand(string.format(
                [[Revision.Event:ProcessScriptCommand(%d, %d, "%s")]],
                arg[1],
                _ID,
                Parameters
            ));
        end
        debug(string.format(
            "Dispatching script command %s to global.",
            self.ScriptCommandRegister[_ID]
        ), true);

        if Framework.IsNetworkGame() and Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION then
            GUI.SetPlayerName(NamePlayerID, PlayerName);
            GUI.SetSoldierPaymentLevel(PlayerSoldierPaymentLevel[PlayerID]);
        end
    end
end

function Revision.Event:ProcessScriptCommand(_PlayerID, _ID, _ParameterString)
    if not self.ScriptCommandRegister[_ID] then
        return;
    end
    local PlayerName = _ParameterString;
    if Framework.IsNetworkGame() and Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION then
        PlayerName = Logic.GetPlayerName(_PlayerID +4);
    end
    local Parameters = self:DecodeScriptCommandParameters(PlayerName);
    local PlayerID = table.remove(Parameters, 1);
    if PlayerID ~= 0 and PlayerID ~= _PlayerID then
        return;
    end
    debug(string.format(
        "Processing script command %s in global.",
        self.ScriptCommandRegister[_ID][1]
    ), true);
    self.ScriptCommandRegister[_ID][2](unpack(Parameters));
end

function Revision.Event:EncodeScriptCommandParameters(...)
    local Query = "";
    for i= 1, #arg do
        local Parameter = arg[i];
        if type(Parameter) == "string" then
            Parameter = string.replaceAll(Parameter, '#', "<<<HT>>>");
            Parameter = string.replaceAll(Parameter, '"', "<<<QT>>>");
            if Parameter:len() == 0 then
                Parameter = "<<<ES>>>";
            end
        elseif type(Parameter) == "table" then
            Parameter = "{" ..table.concat(Parameter, ",") .."}";
        end
        if string.len(Query) > 0 then
            Query = Query .. "#";
        end
        Query = Query .. tostring(Parameter);
    end
    return Query;
end

function Revision.Event:DecodeScriptCommandParameters(_Query)
    local Parameters = {};
    for k, v in pairs(string.slice(_Query, "#")) do
        local Value = v;
        Value = string.replaceAll(Value, "<<<HT>>>", '#');
        Value = string.replaceAll(Value, "<<<QT>>>", '"');
        Value = string.replaceAll(Value, "<<<ES>>>", '');
        if Value == nil then
            Value = nil;
        elseif Value == "true" or Value == "false" then
            Value = Value == "true";
        elseif string.indexOf(Value, "{") == 1 then
            local ValueTable = string.slice(string.sub(Value, 2, string.len(Value)-1), ",");
            Value = {};
            for i= 1, #ValueTable do
                Value[i] = (tonumber(ValueTable[i]) ~= nil and tonumber(ValueTable[i]) or ValueTable);
            end
        elseif tonumber(Value) ~= nil then
            Value = tonumber(Value);
        end
        table.insert(Parameters, Value);
    end
    return Parameters;
end

-- -------------------------------------------------------------------------- --
-- Script Events

function Revision.Event:CreateScriptEvent(_Name)
    for i= 1, #self.ScriptEventRegister, 1 do
        if self.ScriptEventRegister[i] == _Name then
            return 0;
        end
    end
    local ID = #self.ScriptEventRegister+1;
    debug(string.format("Create script event %s", _Name), true);
    self.ScriptEventRegister[ID] = _Name;
    return ID;
end

function Revision.Event:DispatchScriptEvent(_ID, ...)
    if not self.ScriptEventRegister[_ID] then
        return;
    end
    -- Dispatch module events
    for i= 1, #Revision.ModuleRegister, 1 do
        local Env = (Revision.Environment == QSB.Environment.GLOBAL and "Global") or "Local";
        if Revision.ModuleRegister[i][Env] and Revision.ModuleRegister[i][Env].OnEvent then
            Revision.ModuleRegister[i][Env]:OnEvent(_ID, unpack(arg));
        end
    end
    -- Call event game callback
    if GameCallback_QSB_OnEventReceived then
        GameCallback_QSB_OnEventReceived(_ID, unpack(arg));
    end
    -- Call event listeners
    if self.ScriptEventListener[_ID] then
        for k, v in pairs(self.ScriptEventListener[_ID]) do
            if tonumber(k) then
                v(unpack(arg));
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- API

function API.RegisterScriptCommand(_Name, _Function)
    return Revision.Event:CreateScriptCommand(_Name, _Function);
end

function API.BroadcastScriptCommand(_NameOrID, ...)
    local ID = _NameOrID;
    if type(ID) == "string" then
        for i= 1, #Revision.Event.ScriptCommandRegister, 1 do
            if Revision.Event.ScriptCommandRegister[i][1] == _NameOrID then
                ID = i;
            end
        end
    end
    assert(type(ID) == "number");
    if not GUI then
        return;
    end
    Revision.Event:DispatchScriptCommand(ID, 0, unpack(arg));
end

-- Does this function makes any sense? Calling the synchronization but only for
-- one player seems to be stupid...
function API.SendScriptCommand(_NameOrID, ...)
    local ID = _NameOrID;
    if type(ID) == "string" then
        for i= 1, #Revision.Event.ScriptCommandRegister, 1 do
            if Revision.Event.ScriptCommandRegister[i][1] == _NameOrID then
                ID = i;
            end
        end
    end
    assert(type(ID) == "number");
    if not GUI then
        return;
    end
    Revision.Event:DispatchScriptCommand(ID, GUI.GetPlayerID(), unpack(arg));
end

---
-- Legt ein neues Script Event an.
--
-- @param[type=string]   _Name     Identifier des Event
-- @return[type=number] ID des neuen Script Event
-- @within Event
-- @local
--
-- @usage
-- local EventID = API.RegisterScriptEvent("MyNewEvent");
--
function API.RegisterScriptEvent(_Name)
    return Revision.Event:CreateScriptEvent(_Name);
end

---
-- Sendet das Script Event mit der übergebenen ID und überträgt optional
-- Parameter.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nicht benutzt werden, um Script Events
-- synchron oder asynchron aus dem lokalen im globalen Skript auszuführen.
--
-- @param[type=number] _EventID ID des Event
-- @param              ... Optionale Parameter (nil, string, number, boolean, (array) table)
-- @within Event
-- @local
--
-- @usage
-- API.SendScriptEvent(SomeEventID, Param1, Param2, ...);
--
function API.SendScriptEvent(_EventID, ...)
    Revision.Event:DispatchScriptEvent(_EventID, unpack(arg));
end

---
-- Triggerd ein Script Event im globalen Skript aus dem lokalen Skript.
--
-- Das Event wird synchron für alle Spieler gesendet.
--
-- @param[type=number] _EventName Name des Event
-- @param              ... Optionale Parameter (nil, string, number, boolean, (array) table)
-- @within Event
-- @local
--
-- @usage
-- API.SendScriptEventToGlobal("SomeEventName", Param1, Param2, ...);
--
function API.BroadcastScriptEventToGlobal(_EventName, ...)
    if not GUI then
        return;
    end
    Revision.Event:DispatchScriptCommand(
        QSB.ScriptCommands.SendScriptEvent,
        0,
        _EventName,
        unpack(arg)
    );
end

---
-- Triggerd ein Script Event im globalen Skript aus dem lokalen Skript.
--
-- Das Event wird asynchron für den kontrollierenden Spieler gesendet.
--
-- @param[type=number] _EventName Name des Event
-- @param              ... Optionale Parameter (nil, string, number, boolean, (array) table)
-- @within Event
-- @local
--
-- @usage
-- API.SendScriptEventToGlobal("SomeEventName", Param1, Param2, ...);
--
function API.SendScriptEventToGlobal(_EventName, ...)
    if not GUI then
        return;
    end
    Revision.Event:DispatchScriptCommand(
        QSB.ScriptCommands.SendScriptEvent,
        GUI.GetPlayerID(),
        _EventName,
        unpack(arg)
    );
end

---
-- Erstellt einen neuen Listener für das Event.
--
-- An den Listener werden die gleichen Parameter übergeben, die für das Event
-- auch bei GameCallback_QSB_OnEventReceived übergeben werden.
--
-- <b>Hinweis</b>: Event Listener für ein spezifisches Event werden nach
-- GameCallback_QSB_OnEventReceived aufgerufen.
--
-- @param[type=number]   _EventID  ID des Event
-- @param[type=function] _Function Listener Funktion
-- @return[type=number] ID des Listener
-- @within Event
-- @see API.RemoveScriptEventListener
--
-- @usage
-- local ListenerID = API.AddScriptEventListener(QSB.ScriptEvents.SaveGameLoaded, function()
--     Logic.DEBUG_AddNote("A save has been loaded!");
-- end);
--
function API.AddScriptEventListener(_EventID, _Function)
    if not Revision.Event.ScriptEventListener[_EventID] then
        Revision.Event.ScriptEventListener[_EventID] = {
            IDSequence = 0;
        }
    end
    local Data = Revision.Event.ScriptEventListener[_EventID];
    assert(type(_Function) == "function");
    Revision.Event.ScriptEventListener[_EventID].IDSequence = Data.IDSequence +1;
    Revision.Event.ScriptEventListener[_EventID][Data.IDSequence] = _Function;
    return Data.IDSequence;
end

---
-- Entfernt einen Listener von dem Event.
--
-- @param[type=number] _EventID ID des Event
-- @param[type=number] _ID      ID des Listener
-- @within Event
-- @see API.AddScriptEventListener
--
function API.RemoveScriptEventListener(_EventID, _ID)
    if Revision.Event.ScriptEventListener[_EventID] then
        Revision.Event.ScriptEventListener[_EventID][_ID] = nil;
    end
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Bietet erweiterte Möglichkeiten mit Jobs erweitern.
-- @set sort=true
-- @local
--

Revision.Job = {
    EventJobMappingID = 0;
    EventJobMapping = {},
    EventJobs = {},

    SecondsSinceGameStart = 0;
    LastTimeStamp = 0;
};

function Revision.Job:Initalize()
    self:StartJobs();
end

function Revision.Job:OnSaveGameLoaded()
end

function Revision.Job:StartJobs()
    -- Update Real time variable
    self:CreateEventJob(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            Revision.Job:RealtimeController();
        end
    )
end

function Revision.Job:CreateEventJob(_Type, _Function, ...)
    self.EventJobMappingID = self.EventJobMappingID +1;
    local ID = Trigger.RequestTrigger(
        _Type,
        "",
        "QSB_EventJob_EventJobExecutor",
        1,
        {},
        {self.EventJobMappingID}
    );
    self.EventJobs[ID] = {ID, true, _Function, arg};
    self.EventJobMapping[self.EventJobMappingID] = ID;
    return ID;
end

function Revision.Job:EventJobExecutor(_MappingID)
    local ID = self.EventJobMapping[_MappingID];
    if ID and self.EventJobs[ID] and self.EventJobs[ID][2] then
        local Parameter = self.EventJobs[ID][4];
        if self.EventJobs[ID][3](unpack(Parameter)) then
            self.EventJobs[ID][2] = false;
        end
    end
end

function Revision.Job:RealtimeController()
    if not self.LastTimeStamp then
        self.LastTimeStamp = math.floor(Framework.TimeGetTime());
    end
    local CurrentTimeStamp = math.floor(Framework.TimeGetTime());

    if self.LastTimeStamp ~= CurrentTimeStamp then
        self.LastTimeStamp = CurrentTimeStamp;
        self.SecondsSinceGameStart = self.SecondsSinceGameStart +1;
    end
end

-- -------------------------------------------------------------------------- --
-- Helper Jobs

function QSB_EventJob_EventJobExecutor(_MappingID)
    Revision.Job:EventJobExecutor(_MappingID);
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Gibt die real vergangene Zeit seit dem Spielstart in Sekunden zurück.
-- @return[type=number] Vergangene reale Zeit
-- @within Job
--
-- @usage
-- local RealTime = API.RealTimeGetSecondsPassedSinceGameStart();
--
function API.RealTimeGetSecondsPassedSinceGameStart()
    return Revision.Job.SecondsSinceGameStart;
end

---
-- Erzeugt einen neuen Event-Job.
--
-- <b>Hinweis</b>: Nur wenn ein Event Job mit dieser Funktion gestartet wird,
-- können ResumeJob und YieldJob auf den Job angewendet werden.
--
-- <b>Hinweis</b>: Events.LOGIC_EVENT_ENTITY_CREATED funktioniert nicht!
--
-- <b>Hinweis</b>: Wird ein Table als Argument an den Job übergeben, wird eine
-- Kopie angelegt um Speicherprobleme zu verhindern. Es handelt sich also um
-- eine neue Table und keine Referenz!
--
-- @param[type=number]   _EventType Event-Typ
-- @param _Function      Funktion (Funktionsreferenz oder String)
-- @param ...            Optionale Argumente des Job
-- @return[type=number] ID des Jobs
-- @within Job
--
-- @usage
-- API.StartJobByEventType(
--     Events.LOGIC_EVENT_EVERY_SECOND,
--     FunctionRefToCall
-- );
--
function API.StartJobByEventType(_EventType, _Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartJobByEventType: Can not find function!");
        return;
    end
    return Revision.Job:CreateEventJob(_EventType, _Function, unpack(arg));
end

---
-- Führt eine Funktion ein mal pro Sekunde aus. Die weiteren Argumente werden an
-- die Funktion übergeben.
--
-- Die Funktion kann als Referenz, Inline oder als String übergeben werden.
--
-- @param _Function Funktion (Funktionsreferenz oder String)
-- @param ...       Liste von Argumenten
-- @return[type=number] Job ID
-- @within Job
--
-- @usage
-- -- Führt eine Funktion nach 15 Sekunden aus.
-- API.StartJob(function(_Time, _EntityType)
--     if Logic.GetTime() > _Time + 15 then
--         MachWas(_EntityType);
--         return true;
--     end
-- end, Logic.GetTime(), Entities.U_KnightHealing)
--
-- -- Startet einen Job
-- StartSimpleJob("MeinJob");
--
function API.StartJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartJob: _Function must be a function!");
        return;
    end
    return API.StartJobByEventType(Events.LOGIC_EVENT_EVERY_SECOND, Function, unpack(arg));
end
StartSimpleJob = API.StartJob;
StartSimpleJobEx = API.StartJob;

---
-- Führt eine Funktion ein mal pro Turn aus. Ein Turn entspricht einer 1/10
-- Sekunde in der Spielzeit. Die weiteren Argumente werden an die Funktion
-- übergeben.
--
-- Die Funktion kann als Referenz, Inline oder als String übergeben werden.
--
-- @param _Function Funktion (Funktionsreferenz oder String)
-- @param ...       Liste von Argumenten
-- @return[type=number] Job ID
-- @within Job
-- @see API.StartJob
--
function API.StartHiResJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartHiResJob: _Function must be a function!");
        return;
    end
    return API.StartJobByEventType(Events.LOGIC_EVENT_EVERY_TURN, Function, unpack(arg));
end
StartSimpleHiResJob = API.StartHiResJob;
StartSimpleHiResJobEx = API.StartHiResJob;

---
-- Beendet den Job mit der übergebenen ID endgültig.
--
-- @param[type=number] _JobID ID des Jobs
-- @within Job
--
-- @usage
-- API.EndJob(AnyJobID);
--
function API.EndJob(_JobID)
    if Revision.Job.EventJobs[_JobID] then
        Trigger.UnrequestTrigger(Revision.Job.EventJobs[_JobID][1]);
        Revision.Job.EventJobs[_JobID] = nil;
        return;
    end
    EndJob(_JobID);
end

---
-- Gibt zurück, ob der Job mit der übergebenen ID aktiv ist.
--
-- @param[type=number] _JobID ID des Jobs
-- @return[type=boolean] Job ist aktiv
-- @within Job
--
-- @usage
-- if API.JobIsRunning(AnyJobID) then
--     -- Mach was
-- end;
--
function API.JobIsRunning(_JobID)
    if Revision.Job.EventJobs[_JobID] then
        return Revision.Job.EventJobs[_JobID][2] == true;
    end
    return JobIsRunning(_JobID);
end

---
-- Aktiviert einen pausierten Job.
--
-- @param[type=number] _JobID ID des Jobs
-- @within Job
--
-- @usage
-- API.ResumeJob(AnyJobID);
--
function API.ResumeJob(_JobID)
    if Revision.Job.EventJobs[_JobID] then
        if Revision.Job.EventJobs[_JobID][2] ~= true then
            Revision.Job.EventJobs[_JobID][2] = true;
        end
        return;
    end
    error("API.ResumeJob: Job " ..tostring(_JobID).. " can not be resumed!");
end

---
-- Pausiert einen aktivien Job.
--
-- @param[type=number] _JobID ID des Jobs
-- @within Job
--
-- @usage
-- API.YieldJob(AnyJobID);
--
function API.YieldJob(_JobID)
    if Revision.Job.EventJobs[_JobID] then
        if Revision.Job.EventJobs[_JobID][2] == true then
            Revision.Job.EventJobs[_JobID][2] = false;
        end
        return;
    end
    error("API.YieldJob: Job " ..tostring(_JobID).. " can not be paused!");
end

---
-- Wartet die angebene Zeit in Sekunden und führt anschließend die Funktion aus.
--
-- Die Funktion kann als Referenz, Inline oder als String übergeben werden.
--
-- <b>Achtung</b>: Die Ausführung erfolgt asynchron. Das bedeutet, dass das
-- Skript weiterläuft.
--
-- @param[type=number] _Waittime   Wartezeit in Sekunden
-- @param[type=function] _Function Callback-Funktion
-- @param ... Liste der Argumente
-- @return[type=number] ID der Verzögerung
-- @within Job
--
-- @usage
-- API.StartDelay(
--     30,
--     function()
--         Logic.DEBUG_AddNote("Zeit abgelaufen!");
--     end
-- )
--
function API.StartDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartDelay: _Function must be a function!");
        return;
    end
    return API.StartJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetTime() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end

---
-- Wartet die angebene Zeit in Turns und führt anschließend die Funktion aus.
--
-- Die Funktion kann als Referenz, Inline oder als String übergeben werden.
--
-- <b>Achtung</b>: Die Ausführung erfolgt asynchron. Das bedeutet, dass das
-- Skript weiterläuft.
--
-- @param[type=number] _Waittime   Wartezeit in Turns
-- @param[type=function] _Function Callback-Funktion
-- @param ... Liste der Argumente
-- @return[type=number] ID der Verzögerung
-- @within Job
--
-- @usage
-- API.StartHiResDelay(
--     30,
--     function()
--         Logic.DEBUG_AddNote("Zeit abgelaufen!");
--     end
-- )
--
function API.StartHiResDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartHiResDelay: _Function must be a function!");
        return;
    end
    return API.StartHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetCurrentTurn() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end

---
-- Wartet die angebene Zeit in realen Sekunden und führt anschließend die
-- Funktion aus.
--
-- Die Funktion kann als Referenz, Inline oder als String übergeben werden.
--
-- <b>Achtung</b>: Die Ausführung erfolgt asynchron. Das bedeutet, dass das
-- Skript weiterläuft.
--
-- @param[type=number] _Waittime   Wartezeit in realen Sekunden
-- @param[type=function] _Function Callback-Funktion
-- @param ... Liste der Argumente
-- @return[type=number] ID der Verzögerung
-- @within Job
--
-- @usage
-- API.StartRealTimeDelay(
--     30,
--     function()
--         Logic.DEBUG_AddNote("Zeit abgelaufen!");
--     end
-- )
--
function API.StartRealTimeDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    if type(Function) ~= "function" then
        error("API.StartRealTimeDelay: _Function must be a function!");
        return;
    end
    return API.StartHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if (Revision.Job.SecondsSinceGameStart >= _StartTime + _Delay) then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Revision.Job.SecondsSinceGameStart,
        _Waittime,
        _Function,
        {...}
    );
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Speichern und Laden von Spielständen kontrollieren.
-- @set sort=true
-- @local
--

Revision.Save = {
    HistoryEditionQuickSave = false,
    SavingDisabled = false,
    LoadingDisabled = false,
};

function Revision.Save:Initalize()
    self:SetupQuicksaveKeyCallback();
    self:SetupQuicksaveKeyTrigger();
end

function Revision.Save:OnSaveGameLoaded()
    self:SetupQuicksaveKeyTrigger();
    self:UpdateLoadButtons();
    self:UpdateSaveButtons();
end

-- -------------------------------------------------------------------------- --
-- HE Quicksave

function Revision.Save:SetupQuicksaveKeyTrigger()
    if Revision.Environment == QSB.Environment.LOCAL then
        Revision.Job:CreateEventJob(
            Events.LOGIC_EVENT_EVERY_TURN,
            function()
                Input.KeyBindDown(
                    Keys.ModifierControl + Keys.S,
                    "KeyBindings_SaveGame(true)",
                    2,
                    false
                );
                return true;
            end
        );
    end
end

function Revision.Save:SetupQuicksaveKeyCallback()
    if Revision.Environment == QSB.Environment.LOCAL then
        KeyBindings_SaveGame_Orig_Revision = KeyBindings_SaveGame;
        KeyBindings_SaveGame = function(...)
            if not Revision.Save.HistoryEditionQuickSave and not arg[1] then
                return;
            end
            KeyBindings_SaveGame_Orig_Revision();
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Disable Save

function Revision.Save:DisableSaving(_Flag)
    self.SavingDisabled = _Flag == true;
    if Revision.Environment == QSB.Environment.GLOBAL then
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Save:DisableSaving(%s)]],
            tostring(_Flag)
        ))
    else
        self:UpdateSaveButtons();
    end
end

function Revision.Save:UpdateSaveButtons()
    if Revision.Environment == QSB.Environment.LOCAL then
        local VisibleFlag = (self.SavingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickSave", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/SaveGame", VisibleFlag);
    end
end

-- -------------------------------------------------------------------------- --
-- Disable Load

function Revision.Save:DisableLoading(_Flag)
    self.LoadingDisabled = _Flag == true;
    if Revision.Environment == QSB.Environment.GLOBAL then
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Save:DisableLoading(%s)]],
            tostring(_Flag)
        ))
    else
        self:UpdateLoadButtons();
    end
end

function Revision.Save:UpdateLoadButtons()
    if Revision.Environment == QSB.Environment.LOCAL then
        local VisibleFlag = (self.LoadingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/LoadGame", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickLoad", VisibleFlag);
    end
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Deaktiviert das automatische Speichern der History Edition.
-- @param[type=boolean] _Flag Auto-Speichern ist deaktiviert
-- @within Spielstand
--
function API.DisableAutoSave(_Flag)
    if Revision.Environment == QSB.Environment.GLOBAL then
        Revision.Save.HistoryEditionQuickSave = _Flag == true;
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Save.HistoryEditionQuickSave = %s]],
            tostring(_Flag == true)
        ))
    end
end

---
-- Deaktiviert das Speichern des Spiels.
-- @param[type=boolean] _Flag Speichern ist deaktiviert
-- @within Spielstand
--
function API.DisableSaving(_Flag)
    Revision.Save:DisableSaving(_Flag);
end

---
-- Deaktiviert das Laden von Spielständen.
-- @param[type=boolean] _Flag Laden ist deaktiviert
-- @within Spielstand
--
function API.DisableLoading(_Flag)
    Revision.Save:DisableLoading(_Flag);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Steuerung des Chat als Eingabefenster.
-- @set sort=true
-- @local
--

Revision.Chat = {
    DebugInput = {};
};

function Revision.Chat:Initalize()
    QSB.ScriptEvents.ChatOpened = Revision.Event:CreateScriptEvent("Event_ChatOpened");
    QSB.ScriptEvents.ChatClosed = Revision.Event:CreateScriptEvent("Event_ChatClosed");
    for i= 1, 8 do
        self.DebugInput[i] = {};
    end
end

function Revision.Chat:OnSaveGameLoaded()
end

function Revision.Chat:ShowTextInput(_PlayerID, _AllowDebug)
    if  Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION
    and Framework.IsNetworkGame() then
        return;
    end
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Chat:ShowTextInput(%d, %s)]],
            _PlayerID,
            tostring(_AllowDebug == true)
        ))
        return;
    end
    _PlayerID = _PlayerID or GUI.GetPlayerID();
    self:PrepareInputVariable(_PlayerID);
    self:ShowInputBox(_PlayerID, _AllowDebug == true);
end

function Revision.Chat:ShowInputBox(_PlayerID, _Debug)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.DebugInput[_PlayerID] = _Debug == true;

    Revision.Job:CreateEventJob(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            -- Open chat
            Input.ChatMode();
            XGUIEng.SetText("/InGame/Root/Normal/ChatInput/ChatInput", "");
            XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 1);
            XGUIEng.SetFocus("/InGame/Root/Normal/ChatInput/ChatInput");
            -- Send event to global script
            Revision.Event:DispatchScriptCommand(
                QSB.ScriptCommands.SendScriptEvent,
                GUI.GetPlayerID(),
                "ChatOpened",
                _PlayerID
            );
            -- Send event to local script
            Revision.Event:DispatchScriptEvent(
                QSB.ScriptEvents.ChatOpened,
                _PlayerID
            );
            -- Slow down game time. We can not set the game time to 0 because
            -- then Logic.ExecuteInLuaLocalState and GUI.SendScriptCommand do
            -- not work anymore.
            if not Framework.IsNetworkGame() then
                Game.GameTimeSetFactor(GUI.GetPlayerID(), 0.0000001);
            end
            return true;
        end
    )
end

function Revision.Chat:PrepareInputVariable(_PlayerID)
    if Revision.Environment == QSB.Environment.GLOBAL then
        return;
    end

    GUI_Chat.Abort_Orig_Revision = GUI_Chat.Abort_Orig_Revision or GUI_Chat.Abort;
    GUI_Chat.Confirm_Orig_Revision = GUI_Chat.Confirm_Orig_Revision or GUI_Chat.Confirm;

    GUI_Chat.Confirm = function()
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 0);
        local ChatMessage = XGUIEng.GetText("/InGame/Root/Normal/ChatInput/ChatInput");
        local IsDebug = Revision.Chat.DebugInput[_PlayerID];
        Revision.ChatBoxInput = ChatMessage;
        Revision.Chat:SendInputToGlobalScript(ChatMessage, IsDebug);
        g_Chat.JustClosed = 1;
        if not Framework.IsNetworkGame() then
            Game.GameTimeSetFactor(_PlayerID, 1);
        end
        Input.GameMode();
        if  ChatMessage:len() > 0
        and Framework.IsNetworkGame()
        and not IsDebug then
            GUI.SendChatMessage(
                ChatMessage,
                _PlayerID,
                g_Chat.CurrentMessageType,
                g_Chat.CurrentWhisperTarget
            );
        end
    end

    if not Framework.IsNetworkGame() then
        GUI_Chat.Abort = function()
        end
    end
end

function Revision.Chat:SendInputToGlobalScript(_Text, _Debug)
    _Text = (_Text == nil and "") or _Text;
    local PlayerID = GUI.GetPlayerID();
    -- Send chat input to global script
    Revision.Event:DispatchScriptCommand(
        QSB.ScriptCommands.SendScriptEvent,
        0,
        "ChatClosed",
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Send chat input to local script
    Revision.Event:DispatchScriptEvent(
        QSB.ScriptEvents.ChatClosed,
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Reset debug flag
    self.DebugInput[PlayerID] = false;
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Offnet das Chatfenster für eine Eingabe.
--
-- <b>Hinweis</b>: Im Multiplayer kann der Chat nicht über Skript gesteuert
-- werden.
-- 
-- @param[type=number]  _PlayerID   Spieler für den der Chat geöffnet wird
-- @param[type=boolean] _AllowDebug Debug Eingaben werden bearbeitet
-- @within Chat
--
function API.ShowTextInput(_PlayerID, _AllowDebug)
    Revision.Chat:ShowTextInput(_PlayerID, _AllowDebug);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Multilinguale Texte und Platzhalterersetzung in Texten.
-- @set sort=true
-- @local
--

Revision.Text = {
    Languages = {
        {"de", "Deutsch", "en"},
        {"en", "English", "en"},
        {"fr", "Français", "en"},
    },

    Colors = {
        red     = "{@color:255,80,80,255}",
        blue    = "{@color:104,104,232,255}",
        yellow  = "{@color:255,255,80,255}",
        green   = "{@color:80,180,0,255}",
        white   = "{@color:255,255,255,255}",
        black   = "{@color:0,0,0,255}",
        grey    = "{@color:140,140,140,255}",
        azure   = "{@color:0,160,190,255}",
        orange  = "{@color:255,176,30,255}",
        amber   = "{@color:224,197,117,255}",
        violet  = "{@color:180,100,190,255}",
        pink    = "{@color:255,170,200,255}",
        scarlet = "{@color:190,0,0,255}",
        magenta = "{@color:190,0,89,255}",
        olive   = "{@color:74,120,0,255}",
        sky     = "{@color:145,170,210,255}",
        tooltip = "{@color:51,51,120,255}",
        lucid   = "{@color:0,0,0,0}",
        none    = "{@color:none}"
    },

    Placeholders = {
        Names = {},
        EntityTypes = {},
    },
}

QSB.Language = "de";

function Revision.Text:Initalize()
    QSB.ScriptEvents.LanguageSet = Revision.Event:CreateScriptEvent("Event_LanguageSet");
    self:DetectLanguage();
end

function Revision.Text:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Language

function Revision.Text:DetectLanguage()
    local DefaultLanguage = Network.GetDesiredLanguage();
    if DefaultLanguage ~= "de" and DefaultLanguage ~= "fr" then
        DefaultLanguage = "en";
    end
    QSB.Language = DefaultLanguage;
end

function Revision.Text:OnLanguageChanged(_PlayerID, _GUI_PlayerID, _Language)
    self:ChangeSystemLanguage(_PlayerID, _Language, _GUI_PlayerID);
end

function Revision.Text:ChangeSystemLanguage(_PlayerID, _Language, _GUI_PlayerID)
    local OldLanguage = QSB.Language;
    local NewLanguage = _Language;
    if _GUI_PlayerID == nil or _GUI_PlayerID == _PlayerID then
        QSB.Language = _Language;
    end

    Revision.Event:DispatchScriptEvent(QSB.ScriptEvents.LanguageSet, OldLanguage, NewLanguage);
    Logic.ExecuteInLuaLocalState(string.format(
        [[
            local OldLanguage = "%s"
            local NewLanguage = "%s"
            if GUI.GetPlayerID() == %d then
                QSB.Language = NewLanguage
            end
            Revision.Event:DispatchScriptEvent(QSB.ScriptEvents.LanguageSet, OldLanguage, NewLanguage)
        ]],
        OldLanguage,
        NewLanguage,
        _PlayerID
    ));
end

function Revision.Text:Localize(_Text)
    local LocalizedText;
    if type(_Text) == "table" then
        LocalizedText = {};
        if _Text.en == nil and _Text[QSB.Language] == nil then
            for k,v in pairs(_Text) do
                if type(v) == "table" then
                    LocalizedText[k] = self:Localize(v);
                end
            end
        else
            if _Text[QSB.Language] then
                LocalizedText = _Text[QSB.Language];
            else
                for k, v in pairs(self.Languages) do
                    if v[1] == QSB.Language and v[3] ~= nil then
                        LocalizedText = _Text[v[3]];
                        break;
                    end
                end
            end
            if type(LocalizedText) == "table" then
                LocalizedText = "ERROR_NO_TEXT";
            end
        end
    else
        LocalizedText = tostring(_Text);
    end
    return LocalizedText;
end

-- -------------------------------------------------------------------------- --
-- Placeholder

function Revision.Text:ConvertPlaceholders(_Text)
    local s1, e1, s2, e2;
    while true do
        local Before, Placeholder, After, Replacement, s1, e1, s2, e2;
        if _Text:find("{n:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{n:");
            Replacement = self.Placeholders.Names[Placeholder];
            _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
        elseif _Text:find("{t:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{t:");
            Replacement = self.Placeholders.EntityTypes[Placeholder];
            _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
        elseif _Text:find("{v:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{v:");
            Replacement = self:ReplaceValuePlaceholder(Placeholder);
            _Text = Before .. self:Localize(Replacement or ("v:" ..tostring(Placeholder).. ": not found")) .. After;
        end
        if s1 == nil or e1 == nil or s2 == nil or e2 == nil then
            break;
        end
    end
    _Text = self:ReplaceColorPlaceholders(_Text);
    return _Text;
end

function Revision.Text:SplicePlaceholderText(_Text, _Start)
    local s1, e1 = _Text:find(_Start);
    local s2, e2 = _Text:find("}", e1);

    local Before      = _Text:sub(1, s1-1);
    local Placeholder = _Text:sub(e1+1, s2-1);
    local After       = _Text:sub(e2+1);
    return Before, Placeholder, After, s1, e1, s2, e2;
end

function Revision.Text:ReplaceColorPlaceholders(_Text)
    for k, v in pairs(self.Colors) do
        _Text = _Text:gsub("{" ..k.. "}", v);
    end
    return _Text;
end

function Revision.Text:ReplaceValuePlaceholder(_Text)
    local Ref = _G;
    local Slice = string.slice(_Text, "%.");
    for i= 1, #Slice do
        local KeyOrIndex = Slice[i];
        local Index = tonumber(KeyOrIndex);
        if Index ~= nil then
            KeyOrIndex = Index;
        end
        if not Ref[KeyOrIndex] then
            return nil;
        end
        Ref = Ref[KeyOrIndex];
    end
    return Ref;
end

-- Slices a string of commands into multiple strings by resolving %% and % as
-- command delimiters.
-- * && separates entries from another and makes them different inputs
-- * & copys parameters for all commands chained with it
--
-- Example:
-- foo & bar 1 2 3 && muh 4
--
-- Result:
-- foo 1 2 3
-- bar 1 2 3
-- muh 4
function Revision.Text:CommandTokenizer(_Input)
    local Commands = {};
    if _Input == nil then
        return Commands;
    end
    local DAmberCommands = {_Input};
    local AmberCommands = {};

    -- parse && delimiter
    local s, e = string.find(_Input, "%s+&&%s+");
    if s then
        DAmberCommands = {};
        while (s) do
            local tmp = string.sub(_Input, 1, s-1);
            table.insert(DAmberCommands, tmp);
            _Input = string.sub(_Input, e+1);
            s, e = string.find(_Input, "%s+&&%s+");
        end
        if string.len(_Input) > 0 then 
            table.insert(DAmberCommands, _Input);
        end
    end

    -- parse & delimiter
    for i= 1, #DAmberCommands, 1 do
        local s, e = string.find(DAmberCommands[i], "%s+&%s+");
        if s then
            local LastCommand = "";
            while (s) do
                local tmp = string.sub(DAmberCommands[i], 1, s-1);
                table.insert(AmberCommands, LastCommand .. tmp);
                if string.find(tmp, " ") then
                    LastCommand = string.sub(tmp, 1, string.find(tmp, " ")-1) .. " ";
                end
                DAmberCommands[i] = string.sub(DAmberCommands[i], e+1);
                s, e = string.find(DAmberCommands[i], "%s+&%s+");
            end
            if string.len(DAmberCommands[i]) > 0 then 
                table.insert(AmberCommands, LastCommand .. DAmberCommands[i]);
            end
        else
            table.insert(AmberCommands, DAmberCommands[i]);
        end
    end

    -- parse spaces
    for i= 1, #AmberCommands, 1 do
        local CommandLine = {};
        local s, e = string.find(AmberCommands[i], "%s+");
        if s then
            while (s) do
                local tmp = string.sub(AmberCommands[i], 1, s-1);
                table.insert(CommandLine, tmp);
                AmberCommands[i] = string.sub(AmberCommands[i], e+1);
                s, e = string.find(AmberCommands[i], "%s+");
            end
            table.insert(CommandLine, AmberCommands[i]);
        else
            table.insert(CommandLine, AmberCommands[i]);
        end
        table.insert(Commands, CommandLine);
    end

    return Commands;
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Ermittelt den lokalisierten Text anhand der eingestellten Sprache der QSB.
--
-- Wird ein normaler String übergeben, wird dieser sofort zurückgegeben.
-- Bei einem Table mit einem passenden Sprach-Key (de, en, fr, ...) wird die
-- entsprechende Sprache zurückgegeben. Sollte ein Nested Table übergeben
-- werden, werden alle Texte innerhalb des Tables rekursiv übersetzt als Table
-- zurückgegeben. Alle anderen Werte sind nicht in der Rückgabe enthalten.
--
-- @param[type=table] _Text Table mit Übersetzungen
-- @return Übersetzten Text oder Table mit Texten
-- @within Text
--
-- @usage
-- -- Beispiel #1: Table lokalisieren
-- local Text = API.Localize({de = "Deutsch", en = "English"});
-- -- Rückgabe: "Deutsch"
--
-- @usage
-- -- Beispiel #2: Mehrstufige (Nested) Tables
-- -- (Nested Tables sind in dem Fall mit Vorsicht zu genießen!)
-- API.Localize{{de = "Deutsch", en = "English"}, {{1,2,3,4, de = "A", en = "B"}}}
-- -- Rückgabe: {"Deutsch", {"A"}}
--
function API.Localize(_Text)
    return Revision.Text:Localize(_Text);
end

---
-- Schreibt eine Nachricht in das Debug Window. Der Text erscheint links am
-- Bildschirm und ist nicht statisch.
-- 
-- <i>Platzhalter werden automatisch im aufrufenden Environment ersetzt.</i><br>
-- <i>Multilinguale Texte werden automatisch im aufrufenden Environment übersetzt.</i>
--
-- <b>Hinweis:</b> Texte werden automatisch lokalisiert und Platzhalter ersetzt.
--
-- @param[type=string] _Text Anzeigetext
-- @within Text
--
-- @usage
-- API.Note("Das ist eine flüchtige Information!");
--
function API.Note(_Text)
    _Text = Revision.Text:ConvertPlaceholders(Revision.Text:Localize(_Text));
    if not GUI then
        Logic.DEBUG_AddNote(_Text);
        return;
    end
    GUI.AddNote(_Text);
end

---
-- Schreibt eine Nachricht in das Debug Window. Der Text erscheint links am
-- Bildschirm und verbleibt dauerhaft am Bildschirm.
-- 
-- <i>Platzhalter werden automatisch im aufrufenden Environment ersetzt.</i><br>
-- <i>Multilinguale Texte werden automatisch im aufrufenden Environment übersetzt.</i>
--
-- <b>Hinweis:</b> Texte werden automatisch lokalisiert und Platzhalter ersetzt.
--
-- @param[type=string] _Text Anzeigetext
-- @within Text
--
-- @usage
-- API.StaticNote("Das ist eine dauerhafte Information!");
--
function API.StaticNote(_Text)
    _Text = Revision.Text:ConvertPlaceholders(Revision.Text:Localize(_Text));
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[GUI.AddStaticNote("%s")]],
            _Text
        ));
        return;
    end
    GUI.AddStaticNote(_Text);
end

---
-- Schreibt eine Nachricht unten in das Nachrichtenfenster. Die Nachricht
-- verschwindet nach einigen Sekunden.
-- 
-- <i>Platzhalter werden automatisch im aufrufenden Environment ersetzt.</i><br>
-- <i>Multilinguale Texte werden automatisch im aufrufenden Environment übersetzt.</i>
--
-- <b>Hinweis:</b> Texte werden automatisch lokalisiert und Platzhalter ersetzt.
--
-- @param[type=string] _Text  Anzeigetext
-- @param[type=string] _Sound (Optional) Soundeffekt der Nachricht
-- @within Text
--
-- @usage
-- -- Beispiel #1: Einfache Nachricht
-- API.Message("Das ist eine Nachricht!");
--
-- @usage
-- -- Beispiel #2: Nachricht und Ton
-- API.Message("Das ist eine WERTVOLLE Nachricht!", "ui/menu_left_gold_pay");
--
function API.Message(_Text, _Sound)
    _Text = Revision.Text:ConvertPlaceholders(Revision.Text:Localize(_Text));
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.Message("%s", %s)]],
            _Text,
            _Sound
        ));
        return;
    end
    _Text = ModuleRequester:ConvertPlaceholders(API.Localize(_Text));
    if _Sound then
        _Sound = _Sound:gsub("/", "\\");
    end
    Message(_Text, _Sound);
end

---
-- Löscht alle Nachrichten im Debug Window.
--
-- @within Text
--
-- @usage
-- API.ClearNotes();
--
function API.ClearNotes()
    if not GUI then
        Logic.ExecuteInLuaLocalState([[API.ClearNotes()]]);
        return;
    end
    GUI.ClearNotes();
end

---
-- Ersetzt alle Platzhalter im Text oder in der Table.
--
-- Mögliche Platzhalter:
-- <ul>
-- <li>{n:xyz} - Ersetzt einen Skriptnamen mit dem zuvor gesetzten Wert.</li>
-- <li>{t:xyz} - Ersetzt einen Typen mit dem zuvor gesetzten Wert.</li>
-- <li>{v:xyz} - Ersetzt mit dem Inhalt der angegebenen Variable. Der Wert muss
-- in der Umgebung vorhanden sein, in der er ersetzt wird.</li>
-- </ul>
--
-- Außerdem werden einige Standardfarben ersetzt.
-- <pre>{COLOR}</pre>
-- Ersetze {COLOR} in deinen Texten mit einer der gelisteten Farben.
--
-- <table border="1">
-- <tr><th><b>Platzhalter</b></th><th><b>Farbe</b></th><th><b>RGBA</b></th></tr>
--
-- <tr><td>red</td>     <td>Rot</td>           <td>255,80,80,255</td></tr>
-- <tr><td>blue</td>    <td>Blau</td>          <td>104,104,232,255</td></tr>
-- <tr><td>yellow</td>  <td>Gelp</td>          <td>255,255,80,255</td></tr>
-- <tr><td>green</td>   <td>Grün</td>          <td>80,180,0,255</td></tr>
-- <tr><td>white</td>   <td>Weiß</td>          <td>255,255,255,255</td></tr>
-- <tr><td>black</td>   <td>Schwarz</td>       <td>0,0,0,255</td></tr>
-- <tr><td>grey</td>    <td>Grau</td>          <td>140,140,140,255</td></tr>
-- <tr><td>azure</td>   <td>Azurblau</td>      <td>255,176,30,255</td></tr>
-- <tr><td>orange</td>  <td>Orange</td>        <td>255,176,30,255</td></tr>
-- <tr><td>amber</td>   <td>Bernstein</td>     <td>224,197,117,255</td></tr>
-- <tr><td>violet</td>  <td>Violett</td>       <td>180,100,190,255</td></tr>
-- <tr><td>pink</td>    <td>Rosa</td>          <td>255,170,200,255</td></tr>
-- <tr><td>scarlet</td> <td>Scharlachrot</td>  <td>190,0,0,255</td></tr>
-- <tr><td>magenta</td> <td>Magenta</td>       <td>190,0,89,255</td></tr>
-- <tr><td>olive</td>   <td>Olivgrün</td>      <td>74,120,0,255</td></tr>
-- <tr><td>sky</td>     <td>Himmelsblau</td>   <td>145,170,210,255</td></tr>
-- <tr><td>tooltip</td> <td>Tooltip-Blau</td>  <td>51,51,120,255</td></tr>
-- <tr><td>lucid</td>   <td>Transparent</td>   <td>0,0,0,0</td></tr>
-- <tr><td>none</td>    <td>Standardfarbe</td> <td>(Abhängig vom Widget)</td></tr>
-- </table>
--
-- @param[type=string] _Message Text
-- @return Ersetzter Text
-- @within Text
--
-- @usage
-- -- Beispiel #1: Vordefinierte Farbe austauschen
-- local Replaced = API.ConvertPlaceholders("{scarlet}Dieser Text ist jetzt rot!");
--
-- @usage
-- -- Beispiel #2: Skriptnamen austauschen
-- local Replaced = API.ConvertPlaceholders("{n:placeholder2} wurde ersetzt!");
--
-- @usage
-- -- Beispiel #3: Typen austauschen
-- local Replaced = API.ConvertPlaceholders("{t:U_KnightHealing} wurde ersetzt!");
--
-- @usage
-- -- Beispiel #4: Variable austauschen
-- local Replaced = API.ConvertPlaceholders("{v:MyVariable.1.MyValue} wurde ersetzt!");
--
function API.ConvertPlaceholders(_Message)
    if type(_Message) == "table" then
        for k, v in pairs(_Message) do
            _Message[k] = Revision.Text:ConvertPlaceholders(v);
        end
        return API.Localize(_Message);
    elseif type(_Message) == "string" then
        return Revision.Text:ConvertPlaceholders(_Message);
    else
        return _Message;
    end
end

---
-- Fügt einen Platzhalter für den angegebenen Namen hinzu.
--
-- Innerhalb des Textes wird der Plathalter wie folgt geschrieben:
-- <pre>{n:SOME_NAME}</pre>
-- SOME_NAME muss mit dem Namen ersetzt werden.
--
-- @param[type=string] _Name        Name, der ersetzt werden soll
-- @param[type=string] _Replacement Wert, der ersetzt wird
-- @within Text
--
-- @usage
-- API.AddNamePlaceholder("Scriptname", "Horst");
-- API.AddNamePlaceholder("Scriptname", {de = "Kuchen", en = "Cake"});
--
function API.AddNamePlaceholder(_Name, _Replacement)
    if type(_Replacement) == "function" or type(_Replacement) == "thread" then
        error("API.AddNamePlaceholder: Only strings, numbers, or tables are allowed!");
        return;
    end
    Revision.Text.Placeholders.Names[_Name] = _Replacement;
end

---
-- Fügt einen Platzhalter für einen Entity-Typ hinzu.
--
-- Innerhalb des Textes wird der Plathalter wie folgt geschrieben:
-- <pre>{t:ENTITY_TYP}</pre>
-- ENTITY_TYP muss mit einem Entity-Typ ersetzt werden. Der Typ wird ohne
-- Entities. davor geschrieben.
--
-- @param[type=string] _Type        Typname, der ersetzt werden soll
-- @param[type=string] _Replacement Wert, der ersetzt wird
-- @within Text
--
-- @usage
-- API.AddNamePlaceholder("U_KnightHealing", "Arroganze Ziege");
-- API.AddNamePlaceholder("B_Castle_SE", {de = "Festung des Bösen", en = "Fortress of Evil"});
--
function API.AddEntityTypePlaceholder(_Type, _Replacement)
    if Entities[_Type] == nil then
        error("API.AddEntityTypePlaceholder: EntityType does not exist!");
        return;
    end
    Revision.Text.Placeholders.EntityTypes[_Type] = _Replacement;
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Es werden einige Fehler im Spiel behoben.
--
-- @set sort=true
-- @local
--

Revision.Bugfix = {};

function Revision.Bugfix:Initalize()
    if Revision.Environment == QSB.Environment.GLOBAL then
        self:FixResourceSlotsInStorehouses();
        self:OverrideConstructionCompleteCallback();
        self:OverrideIsMerchantArrived();
        self:OverrideIsObjectiveCompleted();
    end
    if Revision.Environment == QSB.Environment.LOCAL then
        self:FixInteractiveObjectClicked();
    end
end

function Revision.Bugfix:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Luxury for NPCs

function Revision.Bugfix:FixResourceSlotsInStorehouses()
    for i= 1, 8 do
        local StoreHouseID = Logic.GetStoreHouse(i);
        if StoreHouseID ~= 0 then
            Logic.AddGoodToStock(StoreHouseID, Goods.G_Salt, 0, true, true);
            Logic.AddGoodToStock(StoreHouseID, Goods.G_Dye, 0, true, true);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Respawning for ME barracks

function Revision.Bugfix:OverrideConstructionCompleteCallback()
    GameCallback_OnBuildingConstructionComplete_Orig_QSB_Core = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        GameCallback_OnBuildingConstructionComplete_Orig_QSB_Core(_PlayerID, _EntityID);
        local EntityType = Logic.GetEntityType(_EntityID);
        if EntityType == Entities.B_NPC_Barracks_ME then
            Logic.RespawnResourceSetMaxSpawn(_EntityID, 0.01);
            Logic.RespawnResourceSetMinSpawn(_EntityID, 0.01);
        end
    end

    for k, v in pairs(Logic.GetEntitiesOfType(Entities.B_NPC_Barracks_ME)) do
        Logic.RespawnResourceSetMaxSpawn(v, 0.01);
        Logic.RespawnResourceSetMinSpawn(v, 0.01);
    end
end

-- -------------------------------------------------------------------------- --
-- Delivery checkpoint

function Revision.Bugfix:OverrideIsMerchantArrived()
    function QuestTemplate:IsMerchantArrived(objective)
        if objective.Data[3] ~= nil then
            if objective.Data[3] == 1 then
                if objective.Data[5].ID ~= nil then
                    objective.Data[3] = objective.Data[5].ID;
                    DeleteQuestMerchantWithID(objective.Data[3]);
                    if MapCallback_DeliverCartSpawned then
                        MapCallback_DeliverCartSpawned(self, objective.Data[3], objective.Data[1]);
                    end
                end
            elseif Logic.IsEntityDestroyed(objective.Data[3]) then
                DeleteQuestMerchantWithID(objective.Data[3]);
                objective.Data[3] = nil;
                objective.Data[5].ID = nil;
            else
                local Target = objective.Data[6] and objective.Data[6] or self.SendingPlayer;
                local StorehouseID = Logic.GetStoreHouse(Target);
                local MarketplaceID = Logic.GetStoreHouse(Target);
                local HeadquartersID = Logic.GetStoreHouse(Target);
                local HasArrived = nil;

                if StorehouseID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(StorehouseID);
                    HasArrived = API.GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                if MarketplaceID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(MarketplaceID);
                    HasArrived = HasArrived or API.GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                if HeadquartersID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(HeadquartersID);
                    HasArrived = HasArrived or API.GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                return HasArrived;
            end
        end
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- IO costs

function Revision.Bugfix:FixInteractiveObjectClicked()
    GUI_Interaction.InteractiveObjectClicked = function()
        local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber];
        if ObjectID == nil or not Logic.InteractiveObjectGetAvailability(ObjectID) then
            return;
        end
        local PlayerID = GUI.GetPlayerID();
        local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
        local CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources");

        -- Check activation costs
        local Affordable = true;
        if Affordable and Costs ~= nil and Costs[1] ~= nil then
            if Costs[1] == Goods.G_Gold then
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
            end
            if Costs[1] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
                error("Only resources can be used as costs for objects!");
                Affordable = false;
            end
            Affordable = Affordable and GetPlayerGoodsInSettlement(Costs[1], PlayerID, false) >= Costs[2];
        end
        if Affordable and Costs ~= nil and Costs[3] ~= nil then
            if Costs[3] == Goods.G_Gold then
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
            end
            if Costs[3] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[3]) ~= GoodCategories.GC_Resource then
                error("Only resources can be used as costs for objects!");
                Affordable = false;
            end
            Affordable = Affordable and GetPlayerGoodsInSettlement(Costs[3], PlayerID, false) >= Costs[4];
        end
        if not Affordable then
            Message(CanNotBuyString);
            return;
        end

        -- Check click override
        if not GUI_Interaction.InteractionClickOverride
        or not GUI_Interaction.InteractionClickOverride(ObjectID) then
            Sound.FXPlay2DSound( "ui\\menu_click");
        end
        -- Check feedback speech override
        if not GUI_Interaction.InteractionSpeechFeedbackOverride
        or not GUI_Interaction.InteractionSpeechFeedbackOverride(ObjectID) then
            GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil);
        end
        -- Check action override and perform action
        if not Mission_Callback_OverrideObjectInteraction
        or not Mission_Callback_OverrideObjectInteraction(ObjectID, PlayerID, Costs) then
            GUI.ExecuteObjectInteraction(ObjectID, PlayerID);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Destroy all units

function Revision.Bugfix:OverrideIsObjectiveCompleted()
    QuestTemplate.IsObjectiveCompleted_Orig_QSB_Kernel = QuestTemplate.IsObjectiveCompleted;
    QuestTemplate.IsObjectiveCompleted = function(self, objective)
        local objectiveType = objective.Type;
        if objective.Completed ~= nil then
            return objective.Completed;
        end
        local data = objective.Data;

        -- Solves the problem that special entities and construction sites
        -- let the script beleave that the player is still alive.
        if objectiveType == Objective.DestroyAllPlayerUnits then
            local PlayerEntities = GetPlayerEntities(data, 0);
            local IllegalEntities = {};

            for i= #PlayerEntities, 1, -1 do
                local Type = Logic.GetEntityType(PlayerEntities[i]);
                if Logic.IsEntityInCategory(PlayerEntities[i], EntityCategories.AttackableBuilding) == 0 or Logic.IsEntityInCategory(PlayerEntities[i], EntityCategories.Wall) == 0 then
                    if Logic.IsConstructionComplete(PlayerEntities[i]) == 0 then
                        table.insert(IllegalEntities, PlayerEntities[i]);
                    end
                end
                local IndestructableEntities = {Entities.XD_ScriptEntity, Entities.S_AIHomePosition, Entities.S_AIAreaDefinition};
                if table.contains(IndestructableEntities, Type) then
                    table.insert(IllegalEntities, PlayerEntities[i]);
                end
            end

            if #PlayerEntities == 0 or #PlayerEntities - #IllegalEntities == 0 then
                objective.Completed = true;
            end
        elseif objectiveType == Objective.Distance then
            objective.Completed = Revision.Behavior:IsQuestPositionReached(self, objective);
        else
            return self:IsObjectiveCompleted_Orig_QSB_Kernel(objective);
        end
    end
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Eine Sammlung von nützlichen Hilfsfunktionen.
-- @set sort=true
-- @local
--

Revision.Utils = {}

QSB.RefillAmounts = {};
QSB.CustomVariable = {};

function Revision.Utils:Initalize()
    QSB.ScriptEvents.CustomValueChanged = Revision.Event:CreateScriptEvent("Event_CustomValueChanged");
    if Revision.Environment == QSB.Environment.GLOBAL then
        self:OverwriteGeologistRefill();
    end
end

function Revision.Utils:OnSaveGameLoaded()
end

function Revision.Utils:OverwriteGeologistRefill()
    if Framework.GetGameExtraNo() >= 1 then
        GameCallback_OnGeologistRefill_Orig_QSB_Kernel = GameCallback_OnGeologistRefill;
        GameCallback_OnGeologistRefill = function(_PlayerID, _TargetID, _GeologistID)
            GameCallback_OnGeologistRefill_Orig_QSB_Kernel(_PlayerID, _TargetID, _GeologistID);
            if QSB.RefillAmounts[_TargetID] then
                local RefillAmount = QSB.RefillAmounts[_TargetID];
                local RefillRandom = RefillAmount + math.random(1, math.floor((RefillAmount * 0.2) + 0.5));
                Logic.SetResourceDoodadGoodAmount(_TargetID, RefillRandom);
                if RefillRandom > 0 then
                    if Logic.GetResourceDoodadGoodType(_TargetID) == Goods.G_Iron then
                        Logic.SetModel(_TargetID, Models.Doodads_D_SE_ResourceIron);
                    else
                        Logic.SetModel(_TargetID, Models.R_ResorceStone_Scaffold);
                    end
                end
            end
        end
    end
end

function Revision.Utils:TriggerEntityKilledCallbacks(_Entity, _Attacker)
    local DefenderID = GetID(_Entity);
    local AttackerID = GetID(_Attacker or 0);
    if AttackerID == 0 or DefenderID == 0 or Logic.GetEntityHealth(DefenderID) > 0 then
        return;
    end
    local x, y, z     = Logic.EntityGetPos(DefenderID);
    local DefPlayerID = Logic.EntityGetPlayer(DefenderID);
    local DefType     = Logic.GetEntityType(DefenderID);
    local AttPlayerID = Logic.EntityGetPlayer(AttackerID);
    local AttType     = Logic.GetEntityType(AttackerID);

    GameCallback_EntityKilled(DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType);
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_Feedback_EntityKilled(%d, %d, %d, %d,%d, %d, %f, %f)",
        DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType, x, y
    ));
end

function Revision.Utils:GetCustomVariable(_Name)
    return QSB.CustomVariable[_Name];
end

function Revision.Utils:SetCustomVariable(_Name, _Value)
    Revision.Utils:UpdateCustomVariable(_Name, _Value);
    local Value = tostring(_Value);
    if type(_Value) ~= "number" then
        Value = [["]] ..Value.. [["]];
    end
    if GUI then
        Revision.Event:DispatchScriptCommand(QSB.ScriptCommands.UpdateCustomVariable, 0, _Name, Value);
    else
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Utils:UpdateCustomVariable("%s", %s)]],
            _Name,
            Value
        ));
    end
end

function Revision.Utils:UpdateCustomVariable(_Name, _Value)
    if QSB.CustomVariable[_Name] then
        local Old = QSB.CustomVariable[_Name];
        QSB.CustomVariable[_Name] = _Value;
        Revision.Event:DispatchScriptEvent(
            QSB.ScriptEvents.CustomValueChanged,
            _Name,
            Old,
            _Value
        );
    else
        QSB.CustomVariable[_Name] = _Value;
        Revision.Event:DispatchScriptEvent(
            QSB.ScriptEvents.CustomValueChanged,
            _Name,
            nil,
            _Value
        );
    end
end

---
-- Rundet eine Dezimalzahl kaufmännisch ab.
--
-- Zusätzlich können die Dezimalstellen beschränkt werden. Alle überschüssigen
-- Dezimalstellen werden abgeschnitten.
--
-- @param[type=string] _Value         Zu rundender Wert
-- @param[type=string] _DecimalDigits Maximale Dezimalstellen
-- @return[type=number] Abgerundete Zahl
-- @within Werkzeugkasten
--
function API.Round(_Value, _DecimalDigits)
    _DecimalDigits = _DecimalDigits or 2;
    _DecimalDigits = (_DecimalDigits < 0 and 0) or _DecimalDigits;
    local Value = tostring(_Value);
    if tonumber(Value) == nil then
        return 0;
    end
    local s,e = Value:find(".", 1, true);
    if e then
        local Overhead = nil;
        if Value:len() > e + _DecimalDigits then
            if _DecimalDigits > 0 then
                local TmpNum;
                if tonumber(Value:sub(e+_DecimalDigits+1, e+_DecimalDigits+1)) >= 5 then
                    TmpNum = tonumber(Value:sub(e+1, e+_DecimalDigits)) +1;
                    Overhead = (_DecimalDigits == 1 and TmpNum == 10);
                else
                    TmpNum = tonumber(Value:sub(e+1, e+_DecimalDigits));
                end
                Value = Value:sub(1, e-1);
                if (tostring(TmpNum):len() >= _DecimalDigits) then
                    Value = Value .. "." ..TmpNum;
                end
            else
                local NewValue = tonumber(Value:sub(1, e-1));
                if tonumber(Value:sub(e+_DecimalDigits+1, e+_DecimalDigits+1)) >= 5 then
                    NewValue = NewValue +1;
                end
                Value = NewValue;
            end
        else
            Value = (Overhead and (tonumber(Value) or 0) +1) or
                     Value .. string.rep("0", Value:len() - (e + _DecimalDigits))
        end
    end
    return tonumber(Value);
end

---
-- Speichert den Wert der Custom Variable im globalen und lokalen Skript.
--
-- Des weiteren wird in beiden Umgebungen ein Event ausgelöst, wenn der Wert
-- gesetzt wird. Das Event bekommt den Namen der Variable, den alten Wert und
-- den neuen Wert übergeben.
--
-- @param[type=boolean] _Name  Name der Custom Variable
-- @param               _Value Neuer Wert
-- @within Werkzeugkasten
-- @local
--
-- @usage
-- local Value = API.ObtainCustomVariable("MyVariable", 0);
--
function API.SaveCustomVariable(_Name, _Value)
    Revision.Utils:SetCustomVariable(_Name, _Value);
end

---
-- Gibt den aktuellen Wert der Custom Variable zurück oder den Default-Wert.
-- @param[type=boolean] _Name    Name der Custom Variable
-- @param               _Default (Optional) Defaultwert falls leer
-- @return Wert
-- @within Werkzeugkasten
-- @local
--
-- @usage
-- local Value = API.ObtainCustomVariable("MyVariable", 0);
--
function API.ObtainCustomVariable(_Name, _Default)
    local Value = QSB.CustomVariable[_Name];
    if not Value and _Default then
        Value = _Default;
    end
    return Value;
end

-- -------------------------------------------------------------------------- --
-- Entity

---
-- Ersetzt ein Entity mit einem neuen eines anderen Typs. Skriptname,
-- Rotation, Position und Besitzer werden übernommen.
--
-- Für Siedler wird automatisch die Tasklist TL_NPC_IDLE gesetzt, damit
-- sie nicht versteinert in der Landschaft rumstehen.
--
-- <b>Hinweis</b>: Die Entity-ID ändert sich und beim Ersetzen von
-- Spezialgebäuden kann eine Niederlage erfolgen.
--
-- @param _Entity      Entity (Skriptname oder ID)
-- @param[type=number] _Type     Neuer Typ
-- @param[type=number] _NewOwner (optional) Neuer Besitzer
-- @return[type=number] Entity-ID des Entity
-- @within Werkzeugkasten
-- @usage
-- API.ReplaceEntity("Stein", Entities.XD_ScriptEntity)
--
function API.ReplaceEntity(_Entity, _Type, _NewOwner)
    local ID1 = GetID(_Entity);
    if ID1 == 0 then
        return;
    end
    local pos = GetPosition(ID1);
    local player = _NewOwner or Logic.EntityGetPlayer(ID1);
    local orientation = Logic.GetEntityOrientation(ID1);
    local name = Logic.GetEntityName(ID1);
    DestroyEntity(ID1);
    local ID2 = Logic.CreateEntity(_Type, pos.X, pos.Y, orientation, player);
    Logic.SetEntityName(ID2, name);
    if Logic.IsSettler(ID2) == 1 then
        Logic.SetTaskList(ID2, TaskLists.TL_NPC_IDLE);
    end
    return ID2;
end
ReplaceEntity = API.ReplaceEntity;

---
-- Gibt den Typen des Entity zurück.
--
-- @param _Entity Entity (Scriptname oder ID)
-- @return[type=number] Typ des Entity
-- @within Werkzeugkasten
--
function API.GetEntityType(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID > 0 then
        return Logic.GetEntityType(EntityID);
    end
    error("API.EntityGetType: _Entity (" ..tostring(_Entity).. ") must be a leader with soldiers!");
    return 0;
end

---
-- Gibt den Typnamen des Entity zurück.
--
-- @param _Entity Entity (Scriptname oder ID)
-- @return[type=string] Typname des Entity
-- @within Werkzeugkasten
--
function API.GetEntityTypeName(_Entity)
    if not IsExisting(_Entity) then
        error("API.GetEntityTypeName: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return;
    end
    return Logic.GetEntityTypeName(API.GetEntityType(_Entity));
end

---
-- Setzt das Entity oder das Battalion verwundbar oder unverwundbar.
--
-- @param               _Entity Entity (Scriptname oder ID)
-- @param[type=boolean] _Flag Verwundbar
-- @within Werkzeugkasten
-- @local
--
function API.SetEntityVulnerableFlag(_Entity, _Flag)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    local VulnerabilityFlag = (_Flag and 1) or 0;
    if EntityID > 0 then
        if API.CountSoldiersOfGroup(EntityID) > 0 then
            for k, v in pairs(API.GetGroupSoldiers(EntityID)) do
                Logic.SetEntityInvulnerabilityFlag(v, VulnerabilityFlag);
            end
        end
        Logic.SetEntityInvulnerabilityFlag(EntityID, VulnerabilityFlag);
    end
end

MakeVulnerable = function(_Entity)
    API.SetEntityVulnerableFlag(_Entity, false);
end
MakeInvulnerable = function(_Entity)
    API.SetEntityVulnerableFlag(_Entity, true);
end

---
-- Sendet einen Handelskarren zu dem Spieler. Startet der Karren von einem
-- Gebäude, wird immer die Position des Eingangs genommen.
--
-- @param _Position                        Position (Skriptname oder Entity-ID)
-- @param[type=number] _PlayerID           Zielspieler
-- @param[type=number] _GoodType           Warentyp
-- @param[type=number] _Amount             Warenmenge
-- @param[type=number] _CartOverlay        (optional) Overlay für Goldkarren
-- @param[type=boolean] _IgnoreReservation (optional) Marktplatzreservation ignorieren
-- @param[type=boolean] _Overtake          (optional) Mit Position austauschen
-- @return[type=number] Entity-ID des erzeugten Wagens
-- @within Werkzeugkasten
-- @usage
-- -- API-Call
-- API.SendCart(Logic.GetStoreHouse(1), 2, Goods.G_Grain, 45)
--
function API.SendCart(_Position, _PlayerID, _GoodType, _Amount, _CartOverlay, _IgnoreReservation, _Overtake)
    local OriginalID = GetID(_Position);
    if not IsExisting(OriginalID) then
        return;
    end
    local ID;
    local x,y,z = Logic.EntityGetPos(OriginalID);
    local ResourceCategory = Logic.GetGoodCategoryForGoodType(_GoodType);
    local Orientation = Logic.GetEntityOrientation(OriginalID);
    local ScriptName = Logic.GetEntityName(OriginalID);
    if Logic.IsBuilding(OriginalID) == 1 then
        x,y = Logic.GetBuildingApproachPosition(OriginalID);
        Orientation = Logic.GetEntityOrientation(OriginalID)-90;
    end

    -- Macht Waren lagerbar im Lagerhaus
    if ResourceCategory == GoodCategories.GC_Resource or _GoodType == Goods.G_None then
        local TypeName = Logic.GetGoodTypeName(_GoodType);
        local SHID = Logic.GetStoreHouse(_PlayerID);
        local HQID = Logic.GetHeadquarters(_PlayerID);
        if SHID ~= 0 and Logic.GetIndexOnInStockByGoodType(SHID, _GoodType) == -1 then
            if _GoodType ~= Goods.G_Gold or (_GoodType == Goods.G_Gold and HQID == 0) then
                info(
                    "API.SendCart: creating stock for " ..TypeName.. " in" ..
                    "storehouse of player " .._PlayerID.. "."
                );
                Logic.AddGoodToStock(SHID, _GoodType, 0, true, true);
            end
        end
    end

    info("API.SendCart: Creating cart ("..
        tostring(_Position) ..","..
        tostring(_PlayerID) ..","..
        Logic.GetGoodTypeName(_GoodType) ..","..
        tostring(_Amount) ..","..
        tostring(_CartOverlay) ..","..
        tostring(_IgnoreReservation) ..
    ")");

    if ResourceCategory == GoodCategories.GC_Resource then
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_ResourceMerchant, x, y, Orientation, _PlayerID);
    elseif _GoodType == Goods.G_Medicine then
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_Medicus, x, y, Orientation,_PlayerID);
    elseif _GoodType == Goods.G_Gold or _GoodType == Goods.G_None or _GoodType == Goods.G_Information then
        if _CartOverlay then
            ID = Logic.CreateEntityOnUnblockedLand(_CartOverlay, x, y, Orientation, _PlayerID);
        else
            ID = Logic.CreateEntityOnUnblockedLand(Entities.U_GoldCart, x, y, Orientation, _PlayerID);
        end
    else
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_Marketer, x, y, Orientation, _PlayerID);
    end
    info("API.SendCart: Executing hire merchant...");
    Logic.HireMerchant(ID, _PlayerID, _GoodType, _Amount, _PlayerID, _IgnoreReservation);
    if _Overtake and Logic.IsBuilding(OriginalID) == 0 then
        info("API.SendCart: Cart replaced original.");
        Logic.SetEntityName(ID, ScriptName);
        DestroyEntity(OriginalID);
    end
    info("API.SendCart: Cart has been send successfully.");
    return ID
end

---
-- Gibt die relative Gesundheit des Entity zurück.
--
-- <b>Hinweis</b>: Der Wert wird als Prozentwert zurückgegeben. Das bedeutet,
-- der Wert liegt zwischen 0 und 100.
--
-- @param _Entity Entity (Scriptname oder ID)
-- @return[type=number] Aktuelle Gesundheit
-- @within Werkzeugkasten
--
function API.GetEntityHealth(_Entity)
    local EntityID = GetID(_Entity);
    if IsExisting(EntityID) then
        local MaxHealth = Logic.GetEntityMaxHealth(EntityID);
        local Health    = Logic.GetEntityHealth(EntityID);
        return (Health/MaxHealth) * 100;
    end
    error("API.GetEntityHealth: _Entity (" ..tostring(_Entity).. ") does not exist!");
    return 0;
end

---
-- Setzt die Gesundheit des Entity. Optional kann die Gesundheit relativ zur
-- maximalen Gesundheit geändert werden.
--
-- @param               _Entity   Entity (Scriptname oder ID)
-- @param[type=number]  _Health   Neue aktuelle Gesundheit
-- @param[type=boolean] _Relative (Optional) Relativ zur maximalen Gesundheit
-- @within Werkzeugkasten
--
function API.ChangeEntityHealth(_Entity, _Health, _Relative)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    if EntityID > 0 then
        local MaxHealth = Logic.GetEntityMaxHealth(EntityID);
        if type(_Health) ~= "number" or _Health < 0 then
            error("API.ChangeEntityHealth: _Health " ..tostring(_Health).. "must be 0 or greater!");
            return
        end
        _Health = (_Health > MaxHealth and MaxHealth) or _Health;
        if Logic.IsLeader(EntityID) == 1 then
            for k, v in pairs(API.GetGroupSoldiers(EntityID)) do
                API.ChangeEntityHealth(v, _Health, _Relative);
            end
        else
            local OldHealth = Logic.GetEntityHealth(EntityID);
            local NewHealth = _Health;
            if _Relative then
                _Health = (_Health < 0 and 0) or _Health;
                _Health = (_Health > 100 and 100) or _Health;
                NewHealth = math.ceil((MaxHealth) * (_Health/100));
            end
            if NewHealth > OldHealth then
                Logic.HealEntity(EntityID, NewHealth - OldHealth);
            elseif NewHealth < OldHealth then
                Logic.HurtEntity(EntityID, OldHealth - NewHealth);
            end
        end
        return;
    end
    error("API.ChangeEntityHealth: _Entity (" ..tostring(_Entity).. ") does not exist!");
end

---
-- Gibt alle Kategorien zurück, zu denen das Entity gehört.
--
-- @param              _Entity Entity (Skriptname oder ID)
-- @return[type=table] Kategorien des Entity
-- @within Werkzeugkasten
--
function API.GetEntityCategoyList(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.GetEntityCategoyList: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return {};
    end
    return API.GetEntityTypeCategoyList(Logic.GetEntityType(EntityID));
end

---
-- Gibt alle Kategorien zurück, zu denen der Entity-Typ gehört.
--
-- @param              _Type Typ des Entity
-- @return[type=table] Kategorien des Entity
-- @within Werkzeugkasten
--
function API.GetEntityTypeCategoyList(_Type)
    local Categories = {};
    for k, v in pairs(EntityCategories) do
        if Logic.IsEntityTypeInCategory(_Type, v) == 1 then
            Categories[#Categories+1] = v;
        end
    end
    return Categories;
end

---
-- Prüft, ob das Entity mindestens eine der Kategorien hat.
--
-- @param              _Entity Entity (Skriptname oder ID)
-- @param[type=number] ...     Liste mit Kategorien
-- @return[type=boolean] Entity hat Kategorie
-- @within Werkzeugkasten
--
function API.IsEntityInAtLeastOneCategory(_Entity, ...)
    local EntityID = GetID(_Entity);
    if EntityID > 0 then
        for k, v in pairs(arg) do
            if table.contains(API.GetEntityCategoyList(_Entity), v) then
                return true;
            end
        end
        return;
    end
    error("API.IsEntityInAtLeastOneCategory: _Entity (" ..tostring(_Entity).. ") does not exist!");
    return false;
end

---
-- Gibt die aktuelle Tasklist des Entity zurück.
--
-- @param _Entity Entity (Scriptname oder ID)
-- @return[type=number] Tasklist
-- @within Werkzeugkasten
--
function API.GetEntityTaskList(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.GetEntityTaskList: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return 0;
    end
    local CurrentTask = Logic.GetCurrentTaskList(EntityID) or "";
    return TaskLists[CurrentTask];
end

---
-- Weist dem Entity ein Neues Model zu.
--
-- @param              _Entity  Entity (Scriptname oder ID)
-- @param[type=number] _NewModel Neues Model
-- @param[type=number] _AnimSet  (optional) Animation Set
-- @within Werkzeugkasten
--
function API.SetEntityModel(_Entity, _NewModel, _AnimSet)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.SetEntityModel: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return;
    end
    if type(_NewModel) ~= "number" or _NewModel < 1 then
        error("API.SetEntityModel: _NewModel (" ..tostring(_NewModel).. ") is wrong!");
        return;
    end
    if _AnimSet and (type(_AnimSet) ~= "number" or _AnimSet < 1) then
        error("API.SetEntityModel: _AnimSet (" ..tostring(_AnimSet).. ") is wrong!");
        return;
    end
    if not _AnimSet then
        Logic.SetModel(EntityID, _NewModel);
    else
        Logic.SetModelAndAnimSet(EntityID, _NewModel, _AnimSet);
    end
end

---
-- Setzt die aktuelle Tasklist des Entity.
--
-- @param              _Entity  Entity (Scriptname oder ID)
-- @param[type=number] _NewTask Neuer Task
-- @within Werkzeugkasten
--
function API.SetEntityTaskList(_Entity, _NewTask)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.SetEntityTaskList: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return;
    end
    if type(_NewTask) ~= "number" or _NewTask < 1 then
        error("API.SetEntityTaskList: _NewTask (" ..tostring(_NewTask).. ") is wrong!");
        return;
    end
    Logic.SetTaskList(EntityID, _NewTask);
end

---
-- Gibt die Menge an Rohstoffen des Entity zurück. Optional kann
-- eine neue Menge gesetzt werden.
--
-- @param _Entity  Entity (Scriptname oder ID)
-- @return[type=number] Menge an Rohstoffen
-- @within Werkzeugkasten
--
function API.GetResourceAmount(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID > 0 then
        return Logic.GetResourceDoodadGoodAmount(EntityID);
    end
    error("API.GetResourceAmount: _Entity (" ..tostring(_Entity).. ") does not exist!");
    return 0;
end

---
-- Setzt die Menge an Rohstoffen und die durchschnittliche Auffüllmenge
-- in einer Mine.
--
-- @param              _Entity       Rohstoffvorkommen (Skriptname oder ID)
-- @param[type=number] _StartAmount  Menge an Rohstoffen
-- @param[type=number] _RefillAmount Minimale Nachfüllmenge (> 0)
-- @within Werkzeugkasten
--
-- @usage
-- API.SetResourceAmount("mine1", 250, 150);
--
function API.SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
    if GUI or not IsExisting(_Entity) then
        return;
    end
    assert(type(_StartAmount) == "number");
    assert(type(_RefillAmount) == "number");

    local EntityID = GetID(_Entity);
    if not IsExisting(EntityID) or Logic.GetResourceDoodadGoodType(EntityID) == 0 then
        return;
    end
    if Logic.GetResourceDoodadGoodAmount(EntityID) == 0 then
        EntityID = API.ReplaceEntity(EntityID, Logic.GetEntityType(EntityID));
    end
    Logic.SetResourceDoodadGoodAmount(EntityID, _StartAmount);
    if _RefillAmount then
        QSB.RefillAmounts[EntityID] = _RefillAmount;
    end
end

---
-- Gibt dem Entity einen eindeutigen Skriptnamen und gibt ihn zurück.
-- Hat das Entity einen Namen, bleibt dieser unverändert und wird
-- zurückgegeben.
-- @param[type=number] _EntityID Entity ID
-- @return[type=string] Skriptname
-- @within Werkzeugkasten
--
function API.CreateEntityName(_EntityID)
    if type(_EntityID) == "string" then
        return _EntityID;
    else
        assert(type(_EntityID) == "number");
        local name = Logic.GetEntityName(_EntityID);
        if (type(name) ~= "string" or name == "" ) then
            QSB.GiveEntityNameCounter = (QSB.GiveEntityNameCounter or 0)+ 1;
            name = "AutomaticScriptName_"..QSB.GiveEntityNameCounter;
            Logic.SetEntityName(_EntityID, name);
        end
        return name;
    end
end

-- Mögliche (zufällige) Siedler, getrennt in männlich und weiblich.
QSB.PossibleSettlerTypes = {
    Male = {
        Entities.U_BannerMaker,
        Entities.U_Baker,
        Entities.U_Barkeeper,
        Entities.U_Blacksmith,
        Entities.U_Butcher,
        Entities.U_BowArmourer,
        Entities.U_BowMaker,
        Entities.U_CandleMaker,
        Entities.U_Carpenter,
        Entities.U_DairyWorker,
        Entities.U_Pharmacist,
        Entities.U_Tanner,
        Entities.U_SmokeHouseWorker,
        Entities.U_Soapmaker,
        Entities.U_SwordSmith,
        Entities.U_Weaver,
    },
    Female = {
        Entities.U_BathWorker,
        Entities.U_SpouseS01,
        Entities.U_SpouseS02,
        Entities.U_SpouseS03,
        Entities.U_SpouseF01,
        Entities.U_SpouseF02,
        Entities.U_SpouseF03,
    }
}

---
-- Wählt aus einer festen Liste von Typen einen zufälligen Siedler-Typ aus.
-- Es werden nur Stadtsiedler zurückgegeben. Sie können männlich oder
-- weiblich sein.
--
-- @return[type=number] Zufälliger Typ
-- @within Werkzeugkasten
-- @local
--
function API.GetRandomSettlerType()
    local Gender = (math.random(1, 2) == 1 and "Male") or "Female";
    local Type   = math.random(1, #QSB.PossibleSettlerTypes[Gender]);
    return QSB.PossibleSettlerTypes[Gender][Type];
end

---
-- Wählt aus einer Liste von Typen einen zufälligen männlichen Siedler aus. Es
-- werden nur Stadtsiedler zurückgegeben.
--
-- @return[type=number] Zufälliger Typ
-- @within Werkzeugkasten
-- @local
--
function API.GetRandomMaleSettlerType()
    local Type = math.random(1, #QSB.PossibleSettlerTypes.Male);
    return QSB.PossibleSettlerTypes.Male[Type];
end

---
-- Wählt aus einer Liste von Typen einen zufälligen weiblichen Siedler aus. Es
-- werden nur Stadtsiedler zurückgegeben.
--
-- @return[type=number] Zufälliger Typ
-- @within Werkzeugkasten
-- @local
--
function API.GetRandomFemaleSettlerType()
    local Type = math.random(1, #QSB.PossibleSettlerTypes.Female);
    return QSB.PossibleSettlerTypes.Female[Type];
end

---
-- Bestimmt die Distanz zwischen zwei Punkten. Es können Entity-IDs,
-- Skriptnamen oder Positionstables angegeben werden.
--
-- Wenn die Distanz nicht bestimmt werden kann, wird -1 zurückgegeben.
--
-- @param _pos1 Erste Vergleichsposition (Skriptname, ID oder Positions-Table)
-- @param _pos2 Zweite Vergleichsposition (Skriptname, ID oder Positions-Table)
-- @return[type=number] Entfernung zwischen den Punkten
-- @within Position
-- @usage
-- local Distance = API.GetDistance("HQ1", Logic.GetKnightID(1))
--
function API.GetDistance( _pos1, _pos2 )
    if (type(_pos1) == "string") or (type(_pos1) == "number") then
        _pos1 = GetPosition(_pos1);
    end
    if (type(_pos2) == "string") or (type(_pos2) == "number") then
        _pos2 = GetPosition(_pos2);
    end
    if type(_pos1) ~= "table" or type(_pos2) ~= "table" then
        warn("API.GetDistance: Distance could not be calculated!");
        return -1;
    end
    local xDistance = (_pos1.X - _pos2.X);
    local yDistance = (_pos1.Y - _pos2.Y);
    return math.sqrt((xDistance^2) + (yDistance^2));
end
GetDistance = API.GetDistance;

-- -------------------------------------------------------------------------- --
-- Group

---
-- Gibt die Mänge an Soldaten zurück, die dem Entity unterstehen
--
-- @param _Entity Entity (Skriptname oder ID)
-- @return[type=number] Menge an Soldaten
-- @within Werkzeugkasten
--
function API.CountSoldiersOfGroup(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.CountSoldiersOfGroup: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return 0;
    end
    if Logic.IsLeader(EntityID) == 0 then
        return 0;
    end
    local SoldierTable = {Logic.GetSoldiersAttachedToLeader(EntityID)};
    return SoldierTable[1];
end

---
-- Gibt die IDs aller Soldaten zurück, die zum Battalion gehören.
--
-- @param _Entity Entity (Skriptname oder ID)
-- @return[type=table] Liste aller Soldaten
-- @within Werkzeugkasten
--
function API.GetGroupSoldiers(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.GetGroupSoldiers: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return {};
    end
    if Logic.IsLeader(EntityID) == 0 then
        return {};
    end
    local SoldierTable = {Logic.GetSoldiersAttachedToLeader(EntityID)};
    table.remove(SoldierTable, 1);
    return SoldierTable;
end

---
-- Gibt den Leader des Soldaten zurück.
--
-- @param _Entity Entity (Skriptname oder ID)
-- @return[type=number] Menge an Soldaten
-- @within Werkzeugkasten
--
function API.GetGroupLeader(_Entity)
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.GetGroupLeader: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return 0;
    end
    if Logic.IsEntityInCategory(EntityID, EntityCategories.Soldier) == 0 then
        return 0;
    end
    return Logic.SoldierGetLeaderEntityID(EntityID);
end

---
-- Heilt das Entity um die angegebene Menge an Gesundheit.
--
-- @param               _Entity   Entity (Scriptname oder ID)
-- @param[type=number]  _Amount   Geheilte Gesundheit
-- @within Werkzeugkasten
--
function API.GroupHeal(_Entity, _Amount)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    if EntityID == 0 or Logic.IsLeader(EntityID) == 1 then
        error("API.GroupHeal: _Entity (" ..tostring(_Entity).. ") must be an existing leader!");
        return;
    end
    if type(_Amount) ~= "number" or _Amount < 0 then
        error("API.GroupHeal: _Amount (" ..tostring(_Amount).. ") must greatier than 0!");
        return;
    end
    API.ChangeEntityHealth(EntityID, Logic.GetEntityHealth(EntityID) + _Amount);
end

---
-- Verwundet ein Entity oder ein Battallion um die angegebene
-- Menge an Schaden. Bei einem Battalion wird der Schaden solange
-- auf Soldaten aufgeteilt, bis er komplett verrechnet wurde.
--
-- @param               _Entity   Entity (Scriptname oder ID)
-- @param[type=number] _Damage   Schaden
-- @param[type=string] _Attacker Angreifer
-- @within Werkzeugkasten
--
function API.GroupHurt(_Entity, _Damage, _Attacker)
    if GUI then
        return;
    end
    local EntityID = GetID(_Entity);
    if EntityID == 0 then
        error("API.GroupHurt: _Entity (" ..tostring(_Entity).. ") does not exist!");
        return;
    end
    if API.IsEntityInAtLeastOneCategory(EntityID, EntityCategories.Soldier) then
        API.GroupHurt(API.GetGroupLeader(EntityID), _Damage);
        return;
    end

    local EntityToHurt = EntityID;
    local IsLeader = Logic.IsLeader(EntityToHurt) == 1;
    if IsLeader then
        EntityToHurt = API.GetGroupSoldiers(EntityToHurt)[1];
    end
    if type(_Damage) ~= "number" or _Damage < 0 then
        error("API.GroupHurt: _Damage (" ..tostring(_Damage).. ") must be greater than 0!");
        return;
    end

    if EntityToHurt then
        local Health = Logic.GetEntityHealth(EntityToHurt);
        if Health <= _Damage then
            _Damage = _Damage - Health;
            Logic.HurtEntity(EntityToHurt, Health);
            Revision.Utils:TriggerEntityKilledCallbacks(EntityToHurt, _Attacker);
            if IsLeader and _Damage > 0 then
                API.GroupHurt(EntityToHurt, _Damage);
            end
        else
            Logic.HurtEntity(EntityToHurt, _Damage);
            Revision.Utils:TriggerEntityKilledCallbacks(EntityToHurt, _Attacker);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Object

---
-- Aktiviert ein Interaktives Objekt.
--
-- @param[type=string] _ScriptName Skriptname des Objektes
-- @param[type=number] _State      State des Objektes
-- @within Werkzeugkasten
--
function API.InteractiveObjectActivate(_ScriptName, _State)
    _State = _State or 0;
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, _State);
    end
end
InteractiveObjectActivate = API.InteractiveObjectActivate;

---
-- Deaktiviert ein interaktives Objekt.
--
-- @param[type=string] _ScriptName Scriptname des Objektes
-- @within Werkzeugkasten
--
function API.InteractiveObjectDeactivate(_ScriptName)
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, 2);
    end
end
InteractiveObjectDeactivate = API.InteractiveObjectDeactivate;

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Grundlegende Steuerung von Quests mittels Funktionen und Events.
-- @set sort=true
-- @local
--

Revision.Quest = {}

function Revision.Quest:Initalize()
    QSB.ScriptEvents.QuestFailure = Revision.Event:CreateScriptEvent("Event_QuestFailure");
    QSB.ScriptEvents.QuestInterrupt = Revision.Event:CreateScriptEvent("Event_QuestInterrupt");
    QSB.ScriptEvents.QuestReset = Revision.Event:CreateScriptEvent("Event_QuestReset");
    QSB.ScriptEvents.QuestSuccess = Revision.Event:CreateScriptEvent("Event_QuestSuccess");
    QSB.ScriptEvents.QuestTrigger = Revision.Event:CreateScriptEvent("Event_QuestTrigger");

    if Revision.Environment == QSB.Environment.GLOBAL then
        self:OverrideQuestSystemGlobal();
    end
end

function Revision.Quest:OnSaveGameLoaded()
end

function Revision.Quest:OverrideQuestSystemGlobal()
    QuestTemplate.Trigger_Orig_QSB_Core = QuestTemplate.Trigger
    QuestTemplate.Trigger = function(_quest)
        QuestTemplate.Trigger_Orig_QSB_Core(_quest);
        for i=1,_quest.Objectives[0] do
            if _quest.Objectives[i].Type == Objective.Custom2 and _quest.Objectives[i].Data[1].SetDescriptionOverwrite then
                local Desc = _quest.Objectives[i].Data[1]:SetDescriptionOverwrite(_quest);
                Revision.Quest:ChangeCustomQuestCaptionText(Desc, _quest);
                break;
            end
        end
        Revision.Quest:SendQuestStateEvent(_quest.Identifier, "QuestTrigger");
    end

    QuestTemplate.Interrupt_Orig_QSB_Core = QuestTemplate.Interrupt;
    QuestTemplate.Interrupt = function(_Quest)
        _Quest:Interrupt_Orig_QSB_Core();

        for i=1, _Quest.Objectives[0] do
            if _Quest.Objectives[i].Type == Objective.Custom2 and _Quest.Objectives[i].Data[1].Interrupt then
                _Quest.Objectives[i].Data[1]:Interrupt(_Quest, i);
            end
        end
        for i=1, _Quest.Triggers[0] do
            if _Quest.Triggers[i].Type == Triggers.Custom2 and _Quest.Triggers[i].Data[1].Interrupt then
                _Quest.Triggers[i].Data[1]:Interrupt(_Quest, i);
            end
        end

        Revision.Quest:SendQuestStateEvent(_Quest.Identifier, "QuestInterrupt");
    end

    QuestTemplate.Fail_Orig_QSB_Core = QuestTemplate.Fail;
    QuestTemplate.Fail = function(_Quest)
        _Quest:Fail_Orig_QSB_Core();
        Revision.Quest:SendQuestStateEvent(_Quest.Identifier, "QuestFailure");
    end

    QuestTemplate.Success_Orig_QSB_Core = QuestTemplate.Success;
    QuestTemplate.Success = function(_Quest)
        _Quest:Success_Orig_QSB_Core();
        Revision.Quest:SendQuestStateEvent(_Quest.Identifier, "QuestSuccess");
    end
end

function Revision.Quest:SendQuestStateEvent(_QuestName, _StateName)
    local QuestID = API.GetQuestID(_QuestName);
    if Quests[QuestID] then
        Revision.Event:DispatchScriptEvent(QSB.ScriptEvents[_StateName], QuestID);
        Logic.ExecuteInLuaLocalState(string.format(
            [[Revision.Event:DispatchScriptEvent(QSB.ScriptEvents["%s"], %d)]],
            _StateName,
            QuestID
        ));
    end
end

function Revision.Quest:ChangeCustomQuestCaptionText(_Text, _Quest)
    if _Quest and _Quest.Visible then
        _Quest.QuestDescription = _Text;
        Logic.ExecuteInLuaLocalState([[
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/BGDeco",0)
            local identifier = "]].._Quest.Identifier..[["
            for i=1, Quests[0] do
                if Quests[i].Identifier == identifier then
                    local text = Quests[i].QuestDescription
                    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/Text", "]].._Text..[[")
                    break
                end
            end
        ]]);
    end
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Gibt die ID des Quests mit dem angegebenen Namen zurück. Existiert der
-- Quest nicht, wird nil zurückgegeben.
--
-- @param[type=string] _Name Name des Quest
-- @return[type=number] ID des Quest
-- @within Quest
--
function API.GetQuestID(_Name)
    if type(_Name) == "number" then
        return _Name;
    end
    for k, v in pairs(Quests) do
        if v and k > 0 then
            if v.Identifier == _Name then
                return k;
            end
        end
    end
end
GetQuestID = API.GetQuestID;

---
-- Prüft, ob zu der angegebenen ID ein Quest existiert. Wird ein Questname
-- angegeben wird dessen Quest-ID ermittelt und geprüft.
--
-- @param[type=number] _QuestID ID oder Name des Quest
-- @return[type=boolean] Quest existiert
-- @within Quest
--
function API.IsValidQuest(_QuestID)
    return Quests[_QuestID] ~= nil or Quests[API.GetQuestID(_QuestID)] ~= nil;
end
IsValidQuest = API.IsValidQuest;

---
-- Prüft den angegebenen Questnamen auf verbotene Zeichen.
--
-- @param[type=number] _Name Name des Quest
-- @return[type=boolean] Name ist gültig
-- @within Quest
--
function API.IsValidQuestName(_Name)
    return string.find(_Name, "^[A-Za-z0-9_ @ÄÖÜäöüß]+$") ~= nil;
end
IsValidQuestName = API.IsValidQuestName;

---
-- Lässt den Quest fehlschlagen.
--
-- Der Status wird auf Over und das Resultat auf Failure gesetzt.
--
-- @param[type=string]  _QuestName Name des Quest
-- @param[type=boolean] _NoMessage Meldung nicht anzeigen
-- @within Quest
--
function API.FailQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("fail quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Fail();
        -- Note: Event is send in QuestTemplate:Fail()!
    end
end

---
-- Startet den Quest neu.
--
-- Der Quest muss beendet sein um ihn wieder neu zu starten. Wird ein Quest
-- neu gestartet, müssen auch alle Trigger wieder neu ausgelöst werden, außer
-- der Quest wird manuell getriggert.
--
-- @param[type=string]  _QuestName Name des Quest
-- @param[type=boolean] _NoMessage Meldung nicht anzeigen
-- @within Quest
--
function API.RestartQuest(_QuestName, _NoMessage)
    -- All changes on default behavior must be considered in this function.
    -- When a default behavior is changed in a module this function must be
    -- changed as well.

    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("restart quest " .._QuestName);
        end

        if Quest.Objectives then
            local questObjectives = Quest.Objectives;
            for i = 1, questObjectives[0] do
                local objective = questObjectives[i];
                objective.Completed = nil
                local objectiveType = objective.Type;

                if objectiveType == Objective.Deliver then
                    local data = objective.Data;
                    data[3] = nil;
                    data[4] = nil;
                    data[5] = nil;
                    data[9] = nil;

                elseif g_GameExtraNo and g_GameExtraNo >= 1 and objectiveType == Objective.Refill then
                    objective.Data[2] = nil;

                elseif objectiveType == Objective.Protect or objectiveType == Objective.Object then
                    local data = objective.Data;
                    for j=1, data[0], 1 do
                        data[-j] = nil;
                    end

                elseif objectiveType == Objective.DestroyEntities and objective.Data[1] == 2 and objective.DestroyTypeAmount then
                    objective.Data[3] = objective.DestroyTypeAmount;
                elseif objectiveType == Objective.DestroyEntities and objective.Data[1] == 3 then
                    objective.Data[4] = nil;
                    objective.Data[5] = nil;

                elseif objectiveType == Objective.Distance then
                    if objective.Data[1] == -65565 then
                        objective.Data[4].NpcInstance = nil;
                    end

                elseif objectiveType == Objective.Custom2 and objective.Data[1].Reset then
                    objective.Data[1]:Reset(Quest, i);
                end
            end
        end

        local function resetCustom(_type, _customType)
            local Quest = Quest;
            local behaviors = Quest[_type];
            if behaviors then
                for i = 1, behaviors[0] do
                    local behavior = behaviors[i];
                    if behavior.Type == _customType then
                        local behaviorDef = behavior.Data[1];
                        if behaviorDef and behaviorDef.Reset then
                            behaviorDef:Reset(Quest, i);
                        end
                    end
                end
            end
        end

        resetCustom("Triggers", Triggers.Custom2);
        resetCustom("Rewards", Reward.Custom);
        resetCustom("Reprisals", Reprisal.Custom);

        Quest.Result = nil;
        local OldQuestState = Quest.State;
        Quest.State = QuestState.NotTriggered;
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..Quest.Index..")");
        if OldQuestState == QuestState.Over then
            Quest.Job = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "Quest_Loop", 1, 0, {Quest.QueueID});
        end
        -- Note: Send the event
        Revision.Event:DispatchScriptEvent(QSB.ScriptEvents.QuestReset, QuestID);
        Logic.ExecuteInLuaLocalState(string.format(
            "Revision.Event:DispatchScriptEvent(QSB.ScriptEvents.QuestReset, %d)",
            QuestID
        ));
        return QuestID, Quest;
    end
end

---
-- Startet den Quest sofort, sofern er existiert.
--
-- Dabei ist es unerheblich, ob die Bedingungen zum Start erfüllt sind.
--
-- @param[type=string]  _QuestName Name des Quest
-- @param[type=boolean] _NoMessage Meldung nicht anzeigen
-- @within Quest
--
function API.StartQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("start quest " .._QuestName);
        end
        Quest:SetMsgKeyOverride();
        Quest:SetIconOverride();
        Quest:Trigger();
        -- Note: Event is send in QuestTemplate:Trigger()!
    end
end

---
-- Unterbricht den Quest.
--
-- Der Status wird auf Over und das Resultat auf Interrupt gesetzt. Sind Marker
-- gesetzt, werden diese entfernt.
--
-- @param[type=string]  _QuestName Name des Quest
-- @param[type=boolean] _NoMessage Meldung nicht anzeigen
-- @within Quest
--
function API.StopQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("interrupt quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Interrupt(-1);
        -- Note: Event is send in QuestTemplate:Interrupt()!
    end
end

---
-- Gewinnt den Quest.
--
-- Der Status wird auf Over und das Resultat auf Success gesetzt.
--
-- @param[type=string]  _QuestName Name des Quest
-- @param[type=boolean] _NoMessage Meldung nicht anzeigen
-- @within Quest
--
function API.WinQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("win quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Success();
        -- Note: Event is send in QuestTemplate:Success()!
    end
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Stellt Cheats und Befehle für einfacheres Testen bereit.
--
-- @set sort=true
-- @within Beschreibung
-- @local
--

Revision.Debug = {
    CheckAtRun           = false;
    TraceQuests          = false;
    DevelopingCheats     = false;
    DevelopingShell      = false;
};

function Revision.Debug:Initalize()
    QSB.ScriptEvents.DebugChatConfirmed = Revision.Event:CreateScriptEvent("Event_DebugChatConfirmed");
    QSB.ScriptEvents.DebugConfigChanged = Revision.Event:CreateScriptEvent("Event_DebugConfigChanged");

    if Revision.Environment == QSB.Environment.LOCAL then
        self:InitalizeQsbDebugHotkeys();

        API.AddScriptEventListener(
            QSB.ScriptEvents.ChatClosed,
            function(...)
                Revision.Debug:ProcessDebugInput(unpack(arg));
            end
        );
    end
end

function Revision.Debug:OnSaveGameLoaded()
    if Revision.Environment == QSB.Environment.LOCAL then
        self:InitalizeQuestTrace();
        self:InitalizeDebugWidgets();
        self:InitalizeQsbDebugHotkeys();
    end
end

function Revision.Debug:ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell)
    if Revision.Environment == QSB.Environment.LOCAL then
        return;
    end

    self.CheckAtRun       = _CheckAtRun == true;
    self.TraceQuests      = _TraceQuests == true;
    self.DevelopingCheats = _DevelopingCheats == true;
    self.DevelopingShell  = _DevelopingShell == true;

    Revision.Event:DispatchScriptEvent(
        QSB.ScriptEvents.DebugModeStatusChanged,
        self.CheckAtRun,
        self.TraceQuests,
        self.DevelopingCheats,
        self.DevelopingShell
    );
    self:InitalizeQuestTrace();

    Logic.ExecuteInLuaLocalState(string.format(
        [[
            Revision.Debug.CheckAtRun       = %s;
            Revision.Debug.TraceQuests      = %s;
            Revision.Debug.DevelopingCheats = %s;
            Revision.Debug.DevelopingShell  = %s;

            Revision.Event:DispatchScriptEvent(
                QSB.ScriptEvents.DebugModeStatusChanged,
                Revision.Debug.CheckAtRun,
                Revision.Debug.TraceQuests,
                Revision.Debug.DevelopingCheats,
                Revision.Debug.DevelopingShell
            );
            Revision.Debug:InitalizeDebugWidgets();
        ]],
        tostring(self.CheckAtRun),
        tostring(self.TraceQuests),
        tostring(self.DevelopingCheats),
        tostring(self.DevelopingShell)
    ));
end

function Revision.Debug:InitalizeQuestTrace()
    DEBUG_EnableQuestDebugKeys();
    DEBUG_QuestTrace(self.TraceQuests == true);
end

function Revision.Debug:InitalizeDebugWidgets()
    if Network.IsNATReady ~= nil and Framework.IsNetworkGame() then
        return;
    end
    if self.DevelopingCheats then
        KeyBindings_EnableDebugMode(1);
        KeyBindings_EnableDebugMode(2);
        KeyBindings_EnableDebugMode(3);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 1);
        self.GameClock = true;
    else
        KeyBindings_EnableDebugMode(0);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 0);
        self.GameClock = false;
    end
end

function Revision.Debug:InitalizeQsbDebugHotkeys()
    if Framework.IsNetworkGame() then
        return;
    end
    -- Restart map
    Input.KeyBindDown(
        Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.R,
        "Revision.Debug:ProcessDebugShortcut('RestartMap')",
        30,
        false
    );
    -- Open chat
    Input.KeyBindDown(
        Keys.ModifierShift + Keys.OemPipe,
        "Revision.Debug:ProcessDebugShortcut('Terminal')",
        30,
        false
    );
end

function Revision.Debug:ProcessDebugShortcut(_Type, _Params)
    if self.DevelopingCheats then
        if _Type == "RestartMap" then
            API.RestartMap();
        elseif _Type == "Terminal" then
            API.ShowTextInput(GUI.GetPlayerID(), true);
        end
    end
end

function Revision.Debug:ProcessDebugInput(_Input, _PlayerID, _DebugAllowed)
    if _DebugAllowed then
        if _Input:lower():find("^restartmap") then
            self:ProcessDebugShortcut("RestartMap");
        elseif _Input:lower():find("^clear") then
            GUI.ClearNotes();
        elseif _Input:lower():find("^version") then
            local Slices = _Input:slice(" ");
            if Slices[2] then
                for i= 1, #Revision.ModuleRegister do
                    if Revision.ModuleRegister[i].Properties.Name ==  Slices[2] then
                        GUI.AddStaticNote("Version: " ..Revision.ModuleRegister[i].Properties.Version);
                    end
                end
                return;
            end
            GUI.AddStaticNote("Version: " ..QSB.Version);
        elseif _Input:find("^> ") then
            GUI.SendScriptCommand(_Input:sub(3), true);
        elseif _Input:find("^>> ") then
            GUI.SendScriptCommand(string.format(
                "Logic.ExecuteInLuaLocalState(\"%s\")",
                _Input:sub(4)
            ), true);
        elseif _Input:find("^< ") then
            GUI.SendScriptCommand(string.format(
                [[Script.Load("%s")]],
                _Input:sub(3)
            ));
        elseif _Input:find("^<< ") then
            Script.Load(_Input:sub(4));
        end
    end
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Aktiviert oder deaktiviert Optionen des Debug Mode.
--
-- <b>Hinweis:</b> Du kannst alle Optionen unbegrenzt oft beliebig ein-
-- und ausschalten.
--
-- <ul>
-- <li><u>Prüfung zum Spielbeginn</u>: <br>
-- Quests werden auf konsistenz geprüft, bevor sie starten. </li>
-- <li><u>Questverfolgung</u>: <br>
-- Jede Statusänderung an einem Quest löst eine Nachricht auf dem Bildschirm
-- aus, die die Änderung wiedergibt. </li>
-- <li><u>Eintwickler Cheaks</u>: <br>
-- Aktivier die Entwickler Cheats. </li>
-- <li><u>Debug Chat-Eingabe</u>: <br>
-- Die Chat-Eingabe kann zur Eingabe von Befehlen genutzt werden. </li>
-- </ul>
--
-- @param[type=boolean] _CheckAtRun       Custom Behavior prüfen an/aus
-- @param[type=boolean] _TraceQuests      Quest Trace an/aus
-- @param[type=boolean] _DevelopingCheats Cheats an/aus
-- @param[type=boolean] _DevelopingShell  Eingabeaufforderung an/aus
-- @within Debug
--
function API.ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell)
    Revision.Debug:ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Scripting Values lesen und schreiben.
-- @set sort=true
-- @local
--

Revision.ScriptingValue = {
    SV = {
        Game = "Vanilla",
        Vanilla = {
            Destination = {X = 19, Y= 20},
            Health      = -41,
            Player      = -71,
            Size        = -45,
            Visible     = -50,
            NPC         = 6,
        },
        HistoryEdition = {
            Destination = {X = 17, Y= 18},
            Health      = -38,
            Player      = -68,
            Size        = -42,
            Visible     = -47,
            NPC         = 6,
        }
    }
}

function Revision.ScriptingValue:Initalize()
    if Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION then
        self.SV.Game = "HistoryEdition";
    end
    QSB.ScriptingValue = self.SV[self.SV.Game];
end

function Revision.ScriptingValue:OnSaveGameLoaded()
    -- Porting savegames between game versions
    -- (Not recommended but we try to support it)
    if Revision.GameVersion == QSB.GameVersion.HISTORY_EDITION then
        self.SV.Game = "HistoryEdition";
    end
    QSB.ScriptingValue = self.SV[self.SV.Game];
end

QSB.ScriptingValue = {};

-- -------------------------------------------------------------------------- --
-- Conversion Methods

function Revision.ScriptingValue:BitsInteger(num)
    local t = {};
    while num > 0 do
        rest = math.qmod(num, 2);
        table.insert(t,1,rest);
        num=(num-rest)/2;
    end
    table.remove(t, 1);
    return t;
end

function Revision.ScriptingValue:BitsFraction(num, t)
    for i = 1, 48 do
        num = num * 2;
        if(num >= 1) then
            table.insert(t, 1);
            num = num - 1;
        else
            table.insert(t, 0);
        end
        if(num == 0) then
            return t;
        end
    end
    return t;
end

function Revision.ScriptingValue:IntegerToFloat(num)
    if(num == 0) then
        return 0;
    end
    local sign = 1;
    if (num < 0) then
        num = 2147483648 + num;
        sign = -1;
    end
    local frac = math.qmod(num, 8388608);
    local headPart = (num-frac)/8388608;
    local expNoSign = math.qmod(headPart, 256);
    local exp = expNoSign-127;
    local fraction = 1;
    local fp = 0.5;
    local check = 4194304;
    for i = 23, 0, -1 do
        if (frac - check) > 0 then
            fraction = fraction + fp;
            frac = frac - check;
        end
        check = check / 2;
        fp = fp / 2;
    end
    return fraction * math.pow(2, exp) * sign;
end

function Revision.ScriptingValue:FloatToInteger(fval)
    if(fval == 0) then
        return 0;
    end
    local signed = false;
    if (fval < 0) then
        signed = true;
        fval = fval * -1;
    end
    local outval = 0;
    local bits;
    local exp = 0;
    if fval >= 1 then
        local intPart = math.floor(fval);
        local fracPart = fval - intPart;
        bits = self:BitsInteger(intPart);
        exp = #bits;
        self:BitsFraction(fracPart, bits);
    else
        bits = {};
        self:BitsFraction(fval, bits);
        while(bits[1] == 0) do
            exp = exp - 1;
            table.remove(bits, 1);
        end
        exp = exp - 1;
        table.remove(bits, 1);
    end
    local bitVal = 4194304;
    local start = 1;
    for bpos = start, 23 do
        local bit = bits[bpos];
        if(not bit) then
            break;
        end
        if(bit == 1) then
            outval = outval + bitVal;
        end
        bitVal = bitVal / 2;
    end
    outval = outval + (exp+127)*8388608;
    if(signed) then
        outval = outval - 2147483648;
    end
    return outval;
end

-- -------------------------------------------------------------------------- --
-- API

---
-- Gibt den Wert auf dem übergebenen Index für das Entity zurück.
--
-- @param[type=number] _Entity Entity
-- @param[type=number] _SV     Typ der Scripting Value
-- @return[type=number] Ermittelter Wert
-- @within ScriptingValue
--
-- @usage
-- local PlayerID = API.GetInteger("HansWurst", QSB.ScriptingValue.Player);
--
function API.GetInteger(_Entity, _SV)
    local ID = GetID(_Entity);
    if not IsExisting(ID) then
        return;
    end
    return Logic.GetEntityScriptingValue(ID, _SV);
end

---
-- Gibt den Wert auf dem übergebenen Index für das Entity zurück.
--
-- @param[type=number] _Entity Entity
-- @param[type=number] _SV     Typ der Scripting Value
-- @return[type=number] Ermittelter Wert
-- @within ScriptingValue
--
-- @usage
-- local Size = API.GetFloat("HansWurst", QSB.ScriptingValue.Size);
--
function API.GetFloat(_Entity, _SV)
    local ID = GetID(_Entity);
    if not IsExisting(ID) then
        return;
    end
    local Value = Logic.GetEntityScriptingValue(ID, _SV);
    return API.ConvertIntegerToFloat(Value);
end

---
-- Setzt den Wert auf dem übergebenen Index für das Entity.
-- 
-- @param[type=number] _Entity Entity
-- @param[type=number] _SV     Typ der Scripting Value
-- @param[type=number] _Value  Zu setzender Wert
-- @within ScriptingValue
--
-- @usage
-- API.SetInteger("HansWurst", QSB.ScriptingValue.Player, 2);
--
function API.SetInteger(_Entity, _SV, _Value)
    local ID = GetID(_Entity);
    if GUI or not IsExisting(ID) then
        return;
    end
    Logic.SetEntityScriptingValue(ID, _SV, _Value);
end

---
-- Setzt den Wert auf dem übergebenen Index für das Entity.
--
-- @param[type=number] _Entity Entity
-- @param[type=number] _SV     Typ der Scripting Value
-- @param[type=number] _Value  Zu setzender Wert
-- @within ScriptingValue
--
-- @usage
-- API.SetFloat("HansWurst", QSB.ScriptingValue.Size, 1.5);
--
function API.SetFloat(_Entity, _SV, _Value)
    local ID = GetID(_Entity);
    if GUI or not IsExisting(ID) then
        return;
    end
    Logic.SetEntityScriptingValue(ID, _SV, API.ConvertFloatToInteger(_Value));
end

---
-- Konvertirert den Wert in eine Ganzzahl.
--
-- @param[type=number] _Value Gleitkommazahl
-- @return[type=number] Konvertierte Ganzzahl
-- @within ScriptingValue
--
-- @usage
-- local Converted = API.ConvertIntegerToFloat(Value)
--
function API.ConvertIntegerToFloat(_Value)
    return Revision.ScriptingValue:IntegerToFloat(_Value);
end

---
-- Konvertirert den Wert in eine Gleitkommazahl.
--
-- @param[type=number] _Value Gleitkommazahl
-- @return[type=number] Konvertierte Ganzzahl
-- @within ScriptingValue
--
-- @usage
-- local Converted = API.ConvertFloatToInteger(Value)
--
function API.ConvertFloatToInteger(_Value)
    return Revision.ScriptingValue:FloatToInteger(_Value);
end
--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Eine Sammlung von vielen Behavior.
-- @set sort=true
-- @local
--

Revision.Behavior = {
    QuestCounter = 0,
    Text = {
        -- FIXME: Remove
        DestroySoldiers = {
            de = "{center}SOLDATEN ZERSTÖREN {cr}{cr}von der Partei: %s{cr}{cr}Anzahl: %d",
            en = "{center}DESTROY SOLDIERS {cr}{cr}from faction: %s{cr}{cr}Amount: %d",
            fr = "{center}DESTRUCTION DE SOLDATS {cr}{cr}De la faction : %s{cr}{cr}Nombre : %d",
        },
        ActivateBuff = {
            Pattern = {
                de = "BONUS AKTIVIEREN{cr}{cr}%s",
                en = "ACTIVATE BUFF{cr}{cr}%s",
                fr = "ACTIVER BONUS{cr}{cr}%s",
            },
            BuffsVanilla = {
                ["Buff_Spice"]                  = {de = "Salz", en = "Salt", fr = "Sel"},
                ["Buff_Colour"]                 = {de = "Farben", en = "Color", fr = "Couleurs"},
                ["Buff_Entertainers"]           = {de = "Entertainer", en = "Entertainer", fr = "Artistes"},
                ["Buff_FoodDiversity"]          = {de = "Vielfältige Nahrung", en = "Food diversity", fr = "Diversité alimentaire"},
                ["Buff_ClothesDiversity"]       = {de = "Vielfältige Kleidung", en = "Clothes diversity", fr = "Diversité vestimentaire"},
                ["Buff_HygieneDiversity"]       = {de = "Vielfältige Reinigung", en = "Hygiene diversity", fr = "Diversité hygiénique"},
                ["Buff_EntertainmentDiversity"] = {de = "Vielfältige Unterhaltung", en = "Entertainment diversity", fr = "Diversité des dievertissements"},
                ["Buff_Sermon"]                 = {de = "Predigt", en = "Sermon", fr = "Sermon"},
                ["Buff_Festival"]               = {de = "Fest", en = "Festival", fr = "Festival"},
                ["Buff_ExtraPayment"]           = {de = "Sonderzahlung", en = "Extra payment", fr = "Paiement supplémentaire"},
                ["Buff_HighTaxes"]              = {de = "Hohe Steuern", en = "High taxes", fr = "Hautes taxes"},
                ["Buff_NoPayment"]              = {de = "Kein Sold", en = "No payment", fr = "Aucun paiement"},
                ["Buff_NoTaxes"]                = {de = "Keine Steuern", en = "No taxes", fr = "Aucune taxes"},
            },
            BuffsEx1 = {
                ["Buff_Gems"]              = {de = "Edelsteine", en = "Gems", fr = "Gemmes"},
                ["Buff_MusicalInstrument"] = {de = "Musikinstrumente", en = "Musical instruments", fr = "Instruments musicaux"},
                ["Buff_Olibanum"]          = {de = "Weihrauch", en = "Olibanum", fr = "Encens"},
            }
        },
        SoldierCount = {
            Pattern = {
                de = "SOLDATENANZAHL {cr}Partei: %s{cr}{cr}%s %d",
                en = "SOLDIER COUNT {cr}Faction: %s{cr}{cr}%s %d",
                fr = "NOMBRE DE SOLDATS {cr}Faction: %s{cr}{cr}%s %d",
            },
            Relation = {
                ["true"]  = {de = "Weniger als ", en = "Less than ", fr = "Moins de"},
                ["false"] = {de = "Mindestens ", en = "At least ", fr = "Au moins"},
            }
        },
        Festivals = {
            Pattern = {
                de = "FESTE FEIERN {cr}{cr}Partei: %s{cr}{cr}Anzahl: %d",
                en = "HOLD PARTIES {cr}{cr}Faction: %s{cr}{cr}Amount: %d",
                fr = "FESTIVITÉS {cr}{cr}Faction: %s{cr}{cr}Nombre : %d",
            },
        }
    }
}

-- FIXME: Remove
QSB.DestroyedSoldiers = {};
QSB.EffectNameToID = {};
QSB.InitalizedObjekts = {};

function Revision.Behavior:Initalize()
    if Revision.Environment == QSB.Environment.GLOBAL then
        self:OverrideQuestMarkers();
    end
    if Revision.Environment == QSB.Environment.LOCAL then
        self:OverrideDisplayQuestObjective();
    end
end

function Revision.Behavior:OnSaveGameLoaded()
end

function Revision.Behavior:OverrideQuestMarkers()
    QuestTemplate.RemoveQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    DestroyQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end
    QuestTemplate.ShowQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    ShowQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end

    function ShowQuestMarker(_Entity)
        local eID = GetID(_Entity);
        local x,y = Logic.GetEntityPosition(eID);
        local Marker = EGL_Effects.E_Questmarker_low;
        if Logic.IsBuilding(eID) == 1 then
            Marker = EGL_Effects.E_Questmarker;
        end
        DestroyQuestMarker(_Entity);
        Questmarkers[eID] = Logic.CreateEffect(Marker, x, y, 0);
    end
    function DestroyQuestMarker(_Entity)
        local eID = GetID(_Entity);
        if Questmarkers[eID] ~= nil then
            Logic.DestroyEffect(Questmarkers[eID]);
            Questmarkers[eID] = nil;
        end
    end
end

function Revision.Behavior:OverrideDisplayQuestObjective()
    GUI_Interaction.DisplayQuestObjective_Orig_QSB_Kernel = GUI_Interaction.DisplayQuestObjective
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        if QuestType == Objective.Distance then
            if Quest.Objectives[1].Data[1] == -65566 then
                Quest.Objectives[1].Data[1] = Logic.GetKnightID(Quest.ReceivingPlayer);
            end
        end
        GUI_Interaction.DisplayQuestObjective_Orig_QSB_Kernel(_QuestIndex, _MessageKey);
    end
end

function Revision.Behavior:IsQuestPositionReached(_Quest, _Objective)
    local IDdata2 = GetID(_Objective.Data[1]);
    if IDdata2 == -65566 then
        _Objective.Data[1] = Logic.GetKnightID(_Quest.ReceivingPlayer);
        IDdata2 = _Objective.Data[1];
    end
    local IDdata3 = GetID(_Objective.Data[2]);
    _Objective.Data[3] = _Objective.Data[3] or 2500;
    if not (Logic.IsEntityDestroyed(IDdata2) or Logic.IsEntityDestroyed(IDdata3)) then
        if Logic.GetDistanceBetweenEntities(IDdata2,IDdata3) <= _Objective.Data[3] then
            DestroyQuestMarker(IDdata3);
            return true;
        end
    else
        DestroyQuestMarker(IDdata3);
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- DEBUG

---
-- Aktiviert den Debug.
--
-- @param[type=boolean] _CheckAtRun Prüfe Quests zur Laufzeit
-- @param[type=boolean] _TraceQuests Aktiviert Questverfolgung
-- @param[type=boolean] _DevelopingCheats Aktiviert Cheats
-- @param[type=boolean] _DevelopingShell Aktiviert Eingabe
--
-- @within Reward
-- @see API.ActivateDebugMode
--
function Reward_DEBUG(...)
    return B_Reward_DEBUG:new(...);
end

B_Reward_DEBUG = {
    Name = "Reward_DEBUG",
    Description = {
        en = "Reward: Start the debug mode. See documentation for more information.",
        de = "Lohn: Startet den Debug-Modus. Für mehr Informationen siehe Dokumentation.",
        fr = "Récompense: Démarre le mode de débug. Pour plus d'informations, voir la documentation.",
    },
    Parameter = {
        { ParameterType.Custom,     en = "Check quest while runtime",   de = "Quests zur Laufzeit prüfen",  fr = "Vérifier les quêtes au cours de l'exécution" },
        { ParameterType.Custom,     en = "Use quest trace",             de = "Questverfolgung",             fr = "Suivi de quête" },
        { ParameterType.Custom,     en = "Activate developing cheats",  de = "Cheats aktivieren",           fr = "Activer les cheats" },
        { ParameterType.Custom,     en = "Activate developing shell",   de = "Eingabe aktivieren",          fr = "Activer la saisie" },
    },
}

function B_Reward_DEBUG:GetRewardTable(_Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_DEBUG:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.CheckWhileRuntime = API.ToBoolean(_Parameter);
    elseif (_Index == 1) then
        self.UseQuestTrace = API.ToBoolean(_Parameter);
    elseif (_Index == 2) then
        self.DevelopingCheats = API.ToBoolean(_Parameter);
    elseif (_Index == 3) then
        self.DevelopingShell = API.ToBoolean(_Parameter);
    end
end

function B_Reward_DEBUG:CustomFunction(_Quest)
    API.ActivateDebugMode(self.CheckWhileRuntime, self.UseQuestTrace, self.DevelopingCheats, self.DevelopingShell);
end

function B_Reward_DEBUG:GetCustomData(_Index)
    return {"true","false"};
end

Revision:RegisterBehavior(B_Reward_DEBUG);

-- -------------------------------------------------------------------------- --
-- GOALS

---
-- Ein Interaktives Objekt muss benutzt werden.
--
-- @param _ScriptName Skriptname des interaktiven Objektes
--
-- @within Goal
--
function Goal_ActivateObject(...)
    return B_Goal_ActivateObject:new(...);
end

B_Goal_ActivateObject = {
    Name = "Goal_ActivateObject",
    Description = {
        en = "Goal: Activate an interactive object",
        de = "Ziel: Aktiviere ein interaktives Objekt",
        fr = "Objectif: activer un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Object name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_ActivateObject:GetGoalTable()
    return {Objective.Object, { self.ScriptName } }
end

function B_Goal_ActivateObject:AddParameter(_Index, _Parameter)
   if _Index == 0 then
        self.ScriptName = _Parameter
   end
end

function B_Goal_ActivateObject:GetMsgKey()
    return "Quest_Object_Activate"
end

Revision:RegisterBehavior(B_Goal_ActivateObject);

-- -------------------------------------------------------------------------- --

---
-- Einem Spieler müssen Rohstoffe oder Waren gesendet werden.
--
-- In der Regel wird zum Auftraggeber gesendet. Es ist aber möglich auch zu
-- einem anderen Zielspieler schicken zu lassen. Wird ein Wagen gefangen
-- genommen, dann muss erneut geschickt werden. Optional kann dem Spieler
-- auch erlaubt werden, den Karren zurückzuerobern.
--
-- @param _GoodType      Typ der Ware
-- @param _GoodAmount    Menga der Ware
-- @param _OtherTarget   Anderes Ziel als Auftraggeber
-- @param _IgnoreCapture Wagen kann zurückerobert werden
--
-- @within Goal
--
function Goal_Deliver(...)
    return B_Goal_Deliver:new(...)
end

B_Goal_Deliver = {
    Name = "Goal_Deliver",
    Description = {
        en = "Goal: Deliver goods to quest giver or to another player.",
        de = "Ziel: Liefere Waren zum Auftraggeber oder zu einem anderen Spieler.",
        fr = "Objectif: livrer des marchandises au mandant ou à un autre joueur.",
    },
    Parameter = {
        { ParameterType.Custom, en = "Type of good", de = "Ressourcentyp", fr = "Type de ressources" },
        { ParameterType.Number, en = "Amount of good", de = "Ressourcenmenge", fr = "Quantité de ressources" },
        { ParameterType.Custom, en = "To different player", de = "Anderer Empfänger", fr = "Autre bénéficiaire" },
        { ParameterType.Custom, en = "Ignore capture", de = "Abfangen ignorieren", fr = "Ignorer une interception" },
    },
}

function B_Goal_Deliver:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Deliver, GoodType, self.GoodAmount, self.OverrideTarget, self.IgnoreCapture }
end

function B_Goal_Deliver:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    elseif (_Index == 2) then
        self.OverrideTarget = tonumber(_Parameter)
    elseif (_Index == 3) then
        self.IgnoreCapture = API.ToBoolean(_Parameter)
    end
end

function B_Goal_Deliver:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        table.insert( Data, "-" )
        for i = 1, 8 do
            table.insert( Data, i )
        end
    elseif _Index == 3 then
        table.insert( Data, "true" )
        table.insert( Data, "false" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_Deliver:GetMsgKey()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    local GC = Logic.GetGoodCategoryForGoodType( GoodType )

    local tMapping = {
        [GoodCategories.GC_Clothes] = "Quest_Deliver_GC_Clothes",
        [GoodCategories.GC_Entertainment] = "Quest_Deliver_GC_Entertainment",
        [GoodCategories.GC_Food] = "Quest_Deliver_GC_Food",
        [GoodCategories.GC_Gold] = "Quest_Deliver_GC_Gold",
        [GoodCategories.GC_Hygiene] = "Quest_Deliver_GC_Hygiene",
        [GoodCategories.GC_Medicine] = "Quest_Deliver_GC_Medicine",
        [GoodCategories.GC_Water] = "Quest_Deliver_GC_Water",
        [GoodCategories.GC_Weapon] = "Quest_Deliver_GC_Weapon",
        [GoodCategories.GC_Resource] = "Quest_Deliver_Resources",
    }

    if GC then
        local Key = tMapping[GC]
        if Key then
            return Key
        end
    end
    return "Quest_Deliver_Goods"
end

Revision:RegisterBehavior(B_Goal_Deliver);

-- -------------------------------------------------------------------------- --

---
-- Es muss ein bestimmter Diplomatiestatus zu einer anderen Patei erreicht
-- werden. Der Status kann eine Verbesserung oder eine Verschlechterung zum
-- aktuellen Status sein.
--
-- Die Relation kann entweder auf kleiner oder gleich (<=), größer oder gleich
-- (>=), oder exakte Gleichheit (==) eingestellt werden. Exakte GLeichheit ist
-- wegen der Gefahr eines Soft Locks mit Vorsicht zu genießen.
--
-- @param _PlayerID Partei, die Entdeckt werden muss
-- @param _Relation Größer-Kleiner-Relation
-- @param _State    Diplomatiestatus
--
-- @within Goal
--
function Goal_Diplomacy(...)
    return B_Goal_Diplomacy:new(...);
end

B_Goal_Diplomacy = {
    Name = "Goal_Diplomacy",
    Description = {
        en = "Goal: A diplomatic state must b reached. Can be lower than current state or higher.",
        de = "Ziel: Die Beziehungen zu einem Spieler müssen entweder verbessert oder verschlechtert werden.",
        fr = "Objectif: les relations avec un joueur doivent être soit améliorées, soit détériorées.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Party", de = "Partei", fr = "Faction" },
        { ParameterType.Custom,   en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Custom,   en = "Diplomacy state", de = "Diplomatische Beziehung", fr = "Relations diplomatiques" },
    },
    DiploNameMap = {
        [DiplomacyStates.Allied]             = {de = "Verbündeter",    en = "Allied",               fr = "Allié"},
        [DiplomacyStates.TradeContact]       = {de = "Handelspartner", en = "Trade Contact",        fr = "Partenaire commercial"},
        [DiplomacyStates.EstablishedContact] = {de = "Bekannt",        en = "Established Contact",  fr = "Contact établi"},
        [DiplomacyStates.Undecided]          = {de = "Unbekannt",      en = "Undecided",            fr = "Inconnu"},
        [DiplomacyStates.Enemy]              = {de = "Feind",          en = "Enemy",                fr = "Ennemi"},
    },
    TextPattern = {
        de = "DIPLOMATIESTATUS ERREICHEN {cr}{cr}Status: %s{cr}Zur Partei: %s",
        en = "DIPLOMATIC STATE {cr}{cr}State: %s{cr}To player: %s",
        fr = "ATTEINDRE LE STATUT DE DIPLOMATIQUE {cr}{cr}Statut : %s{cr}Avec la faction : %s",
    },
}

function B_Goal_Diplomacy:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_Diplomacy:ChangeCaption(_Quest)
    local PlayerName = GetPlayerName(self.PlayerID) or "";
    local Text = string.format(
        Revision:Localize(self.TextPattern),
        Revision:Localize(self.DiploNameMap[self.DiplState]),
        PlayerName
    );
    Revision:ChangeCustomQuestCaptionText(Text, _Quest);
end

function B_Goal_Diplomacy:CustomFunction(_Quest)
    self:ChangeCaption(_Quest);
    if self.Relation == "<=" then
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) <= self.DiplState then
            return true;
        end
    elseif self.Relation == ">=" then
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) >= self.DiplState then
            return true;
        end
    else
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) == self.DiplState then
            return true;
        end
    end
end

function B_Goal_Diplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Relation = _Parameter;
    elseif (_Index == 2) then
        self.DiplState = DiplomacyStates[_Parameter];
    end
end

function B_Goal_Diplomacy:GetIcon()
    return {6, 3};
end

function B_Goal_Diplomacy:GetCustomData(_Index)
    if _Index == 1 then
        return {">=", "<=", "=="};
    elseif _Index == 2 then
        return {"Allied", "TradeContact", "EstablishedContact", "Undecided", "Enemy"};
    end
end

Revision:RegisterBehavior(B_Goal_Diplomacy);

-- -------------------------------------------------------------------------- --

---
-- Das Heimatterritorium des Spielers muss entdeckt werden.
--
-- Das Heimatterritorium ist immer das, wo sich Burg oder Lagerhaus der
-- zu entdeckenden Partei befinden.
--
-- @param _PlayerID ID der zu entdeckenden Partei
--
-- @within Goal
--
function Goal_DiscoverPlayer(...)
    return B_Goal_DiscoverPlayer:new(...);
end

B_Goal_DiscoverPlayer = {
    Name = "Goal_DiscoverPlayer",
    Description = {
        en = "Goal: Discover the home territory of another player.",
        de = "Ziel: Entdecke das Heimatterritorium eines Spielers.",
        fr = "Objectif: Découvrir le territoire d'origine d'un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DiscoverPlayer:GetGoalTable()
    return {Objective.Discover, 2, { self.PlayerID } }
end

function B_Goal_DiscoverPlayer:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DiscoverPlayer:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_Discover",
        [PlayerCategories.City] = "Quest_Discover_City",
        [PlayerCategories.Cloister] = "Quest_Discover_Cloister",
        [PlayerCategories.Harbour] = "Quest_Discover",
        [PlayerCategories.Village] = "Quest_Discover_Village",
    }
    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_Discover"
end

Revision:RegisterBehavior(B_Goal_DiscoverPlayer);

-- -------------------------------------------------------------------------- --

---
-- Ein Territorium muss erstmalig vom Auftragnehmer betreten werden.
--
-- Wenn ein Spieler zuvor mit seinen Einheiten auf dem Territorium war, ist
-- es bereits entdeckt und das Ziel sofort erfüllt.
--
-- @param _Territory Name oder ID des Territorium
--
-- @within Goal
--
function Goal_DiscoverTerritory(...)
    return B_Goal_DiscoverTerritory:new(...);
end

B_Goal_DiscoverTerritory = {
    Name = "Goal_DiscoverTerritory",
    Description = {
        en = "Goal: Discover a territory",
        de = "Ziel: Entdecke ein Territorium",
        fr = "Objectif : Découvrir un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryName, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_DiscoverTerritory:GetGoalTable()
    return { Objective.Discover, 1, { self.TerritoryID  } }
end

function B_Goal_DiscoverTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
        assert( self.TerritoryID > 0 )
    end
end

function B_Goal_DiscoverTerritory:GetMsgKey()
    return "Quest_Discover_Territory"
end

Revision:RegisterBehavior(B_Goal_DiscoverTerritory);

-- -------------------------------------------------------------------------- --

---
-- Eine andere Partei muss besiegt werden.
--
-- Die Partei gilt als besiegt, wenn ein Hauptgebäude (Burg, Kirche, Lager)
-- zerstört wurde.
-- 
-- <b>Achtung:</b> Bei Banditen ist dieses Behavior wenig sinnvoll, da sie
-- nicht durch zerstörung ihres Hauptzeltes vernichtet werden. Hier bietet
-- sich Goal_DestroyAllPlayerUnits an.
--
-- @param _PlayerID ID des Spielers
--
-- @within Goal
--
function Goal_DestroyPlayer(...)
    return B_Goal_DestroyPlayer:new(...);
end

B_Goal_DestroyPlayer = {
    Name = "Goal_DestroyPlayer",
    Description = {
        en = "Goal: Destroy a player (destroy a main building)",
        de = "Ziel: Zerstöre einen Spieler (ein Hauptgebäude muss zerstört werden).",
        fr = "Objectif : Détruire un joueur (un bâtiment principal doit être détruit).",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyPlayer:GetGoalTable()
    assert( self.PlayerID <= 8 and self.PlayerID >= 1, "Error in " .. self.Name .. ": GetGoalTable: PlayerID is invalid")
    return { Objective.DestroyPlayers, self.PlayerID }
end

function B_Goal_DestroyPlayer:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyPlayer:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_DestroyPlayers_Bandits",
        [PlayerCategories.City] = "Quest_DestroyPlayers_City",
        [PlayerCategories.Cloister] = "Quest_DestroyPlayers_Cloister",
        [PlayerCategories.Harbour] = "Quest_DestroyEntities_Building",
        [PlayerCategories.Village] = "Quest_DestroyPlayers_Village",
    }

    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_DestroyEntities_Building"
end

Revision:RegisterBehavior(B_Goal_DestroyPlayer)

-- -------------------------------------------------------------------------- --

---
-- Es sollen Informationen aus der Burg gestohlen werden.
--
-- Der Spieler muss einen Dieb entsenden um Informationen aus der Burg zu
-- stehlen. 
--
-- <b>Achtung:</b> Das ist nur bei Feinden möglich!
--
-- @param _PlayerID ID der Partei
--
-- @within Goal
--
function Goal_StealInformation(...)
    return B_Goal_StealInformation:new(...);
end

B_Goal_StealInformation = {
    Name = "Goal_StealInformation",
    Description = {
        en = "Goal: Steal information from another players castle",
        de = "Ziel: Stehle Informationen aus der Burg eines Spielers",
        fr = "Objectif : voler des informations du château d'un joueur",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_StealInformation:GetGoalTable()

    local Target = Logic.GetHeadquarters(self.PlayerID)
    if not Target or Target == 0 then
        Target = Logic.GetStoreHouse(self.PlayerID)
    end
    assert( Target and Target ~= 0 )
    return {Objective.Steal, 1, { Target } }

end

function B_Goal_StealInformation:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end

end

function B_Goal_StealInformation:GetMsgKey()
    return "Quest_Steal_Info"

end

Revision:RegisterBehavior(B_Goal_StealInformation);

-- -------------------------------------------------------------------------- --

---
-- Alle Einheiten des Spielers müssen zerstört werden.
--
-- <b>Achtung</b>: Bei normalen Parteien, welche ein Dorf oder eine Stadt
-- besitzen, ist Goal_DestroyPlayer besser geeignet!
--
-- @param _PlayerID ID des Spielers
--
-- @within Goal
--
function Goal_DestroyAllPlayerUnits(...)
    return B_Goal_DestroyAllPlayerUnits:new(...);
end

B_Goal_DestroyAllPlayerUnits = {
    Name = "Goal_DestroyAllPlayerUnits",
    Description = {
        en = "Goal: Destroy all units owned by player (be careful with script entities)",
        de = "Ziel: Zerstöre alle Einheiten eines Spielers (vorsicht mit Script-Entities)",
        fr = "Objectif: Détruire toutes les unités d'un joueur (attention aux entités de script)",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyAllPlayerUnits:GetGoalTable()
    return { Objective.DestroyAllPlayerUnits, self.PlayerID }
end

function B_Goal_DestroyAllPlayerUnits:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyAllPlayerUnits:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_DestroyPlayers_Bandits",
        [PlayerCategories.City] = "Quest_DestroyPlayers_City",
        [PlayerCategories.Cloister] = "Quest_DestroyPlayers_Cloister",
        [PlayerCategories.Harbour] = "Quest_DestroyEntities_Building",
        [PlayerCategories.Village] = "Quest_DestroyPlayers_Village",
    }

    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_DestroyEntities"
end

Revision:RegisterBehavior(B_Goal_DestroyAllPlayerUnits);

-- -------------------------------------------------------------------------- --

---
-- Ein benanntes Entity muss zerstört werden.
--
-- Ein Entity gilt als zerstört, wenn es nicht mehr existiert oder während
-- der Laufzeit des Quests seine Entity-ID oder den Besitzer verändert.
--
-- <b>Achtung</b>: Helden können nicht direkt zerstört werden. Bei ihnen
-- genügt es, wenn sie sich "in die Burg zurückziehen".
--
-- @param _ScriptName Skriptname des Ziels
--
-- @within Goal
--
function Goal_DestroyScriptEntity(...)
    return B_Goal_DestroyScriptEntity:new(...);
end

B_Goal_DestroyScriptEntity = {
    Name = "Goal_DestroyScriptEntity",
    Description = {
        en = "Goal: Destroy an entity",
        de = "Ziel: Zerstöre eine Entität",
        fr = "Objectif : Détruire une entité",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_DestroyScriptEntity:GetGoalTable()
    return {Objective.DestroyEntities, 1, { self.ScriptName } }
end

function B_Goal_DestroyScriptEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_DestroyScriptEntity:GetMsgKey()
    if Logic.IsEntityAlive(self.ScriptName) then
        local ID = GetID(self.ScriptName)
        if ID and ID ~= 0 then
            ID = Logic.GetEntityType( ID )
            if ID and ID ~= 0 then
                if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
                    return "Quest_DestroyEntities_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableAnimal ) == 1 then
                    return "Quest_DestroyEntities_Predators"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
                    return "Quest_Destroy_Leader"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Military ) == 1
                    or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableSettler ) == 1
                    or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1  then

                    return "Quest_DestroyEntities_Unit"
                end
            end
        end
    end
    return "Quest_DestroyEntities"
end

Revision:RegisterBehavior(B_Goal_DestroyScriptEntity);

-- -------------------------------------------------------------------------- --

---
-- Eine Menge an Entities eines Typs müssen zerstört werden.
--
-- <b>Achtung</b>: Wenn Raubtiere zerstört werden sollen, muss Spieler 0
-- als Besitzer angegeben werden.
--
-- @param _EntityType Typ des Entity
-- @param _Amount     Menge an Entities des Typs
-- @param _PlayerID   Besitzer des Entity
--
-- @within Goal
--
function Goal_DestroyType(...)
    return B_Goal_DestroyType:new(...);
end

B_Goal_DestroyType = {
    Name = "Goal_DestroyType",
    Description = {
        en = "Goal: Destroy entity types",
        de = "Ziel: Zerstöre Entitätstypen",
        fr = "Objectif: Détruire les types d'entités",
    },
    Parameter = {
        { ParameterType.Custom, en = "Type name", de = "Typbezeichnung", fr = "Désignation du type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.Custom, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyType:GetGoalTable()
    return {Objective.DestroyEntities, 2, Entities[self.EntityName], self.Amount, self.PlayerID }
end

function B_Goal_DestroyType:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
        self.DestroyTypeAmount = self.Amount
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyType:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Entities ) do
            if string.find( k, "^[ABU]_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        for i = 0, 8 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Goal_DestroyType:GetMsgKey()
    local ID = self.EntityName
    if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
        return "Quest_DestroyEntities_Building"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableAnimal ) == 1 then
        return "Quest_DestroyEntities_Predators"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
        return "Quest_Destroy_Leader"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Military ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableSettler ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1  then

        return "Quest_DestroyEntities_Unit"
    end
    return "Quest_DestroyEntities"
end

Revision:RegisterBehavior(B_Goal_DestroyType);

-- -------------------------------------------------------------------------- --

---
-- Eine Entfernung zwischen zwei Entities muss erreicht werden.
--
-- Je nach angegebener Relation muss die Entfernung unter- oder überschritten
-- werden, um den Quest zu gewinnen.
--
-- @param _ScriptName1  Erstes Entity
-- @param _ScriptName2  Zweites Entity
-- @param _Relation     Relation
-- @param _Distance     Entfernung
--
-- @within Goal
--
function Goal_EntityDistance(...)
    return B_Goal_EntityDistance:new(...);
end

B_Goal_EntityDistance = {
    Name = "Goal_EntityDistance",
    Description = {
        en = "Goal: Distance between two entities",
        de = "Ziel: Zwei Entities sollen zueinander eine Entfernung über- oder unterschreiten.",
        fr = "Objectif: deux entités doivent se trouver à une distance supérieure ou inférieure l'une de l'autre.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity 1", de = "Entity 1", fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2", de = "Entity 2", fr = "Entité 2" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Distance", de = "Entfernung", fr = "Distance" },
    },
}

function B_Goal_EntityDistance:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_EntityDistance:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity1 = _Parameter
    elseif (_Index == 1) then
        self.Entity2 = _Parameter
    elseif (_Index == 2) then
        self.bRelSmallerThan = _Parameter == "<"
    elseif (_Index == 3) then
        self.Distance = _Parameter * 1
    end
end

function B_Goal_EntityDistance:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.Entity1 ) or Logic.IsEntityDestroyed( self.Entity2 ) then
        return false
    end
    local ID1 = GetID( self.Entity1 )
    local ID2 = GetID( self.Entity2 )
    local InRange = Logic.CheckEntitiesDistance( ID1, ID2, self.Distance )
    if ( self.bRelSmallerThan and InRange ) or ( not self.bRelSmallerThan and not InRange ) then
        return true
    end
end

function B_Goal_EntityDistance:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        table.insert( Data, ">" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_EntityDistance:Debug(_Quest)
    if not IsExisting(self.Entity1) or not IsExisting(self.Entity2) then
        error(_Quest.Identifier.. ": " ..self.Name..": At least 1 of the entities for distance check don't exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_EntityDistance);

-- -------------------------------------------------------------------------- --

---
-- Der Primary Knight des angegebenen Spielers muss sich dem Ziel nähern.
--
-- Die Distanz, die unterschritten werden muss, kann frei bestimmt werden.
-- Wird die Distanz 0 belassen, wird sie automatisch 2500.
--
-- @param _ScriptName Skriptname des Ziels
-- @param _Disctande  (optional) Entfernung zum Ziel
--
-- @within Goal
--
function Goal_KnightDistance(...)
    return B_Goal_KnightDistance:new(...);
end

B_Goal_KnightDistance = {
    Name = "Goal_KnightDistance",
    Description = {
        en = "Goal: Bring the knight close to a given entity. If the distance is left at 0 it will automatically set to 2500.",
        de = "Ziel: Bringe den Ritter nah an eine bestimmte Entität. Wird die Entfernung 0 gelassen, ist sie automatisch 2500.",
        fr = "Objectif : Rapproche le chevalier d'une entité donnée. Si la distance est laissée à 0, elle est automatiquement de 2500.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target", de = "Ziel", fr = "Cible" },
        { ParameterType.Number, en = "Distance", de = "Entfernung", fr = "Distance" },
    },
}

function B_Goal_KnightDistance:GetGoalTable()
    return {Objective.Distance, -65566, self.Target, self.Distance, true}
end

function B_Goal_KnightDistance:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Target = _Parameter;
    elseif (_Index == 1) then
        if _Parameter == nil or _Parameter == "" then
            _Parameter = 0;
        end
        self.Distance = _Parameter * 1;
        if self.Distance == 0 then
            self.Distance = 2500;
        end
    end
end

Revision:RegisterBehavior(B_Goal_KnightDistance);

---
-- Eine bestimmte Anzahl an Einheiten einer Kategorie muss sich auf dem
-- Territorium befinden.
--
-- Es kann entweder gefordert werden, weniger als die angegebene Menge auf
-- dem Territorium zu haben (z.B. "<"" 1 für 0) oder mindestens so
-- viele Entities (z.B. ">=" 5 für mindestens 5).
--
-- @param _Territory  TerritoryID oder TerritoryName
-- @param _PlayerID   PlayerID der Einheiten
-- @param _Category   Kategorie der Einheiten
-- @param _Relation   Mengenrelation (< oder >=)
-- @param _Amount     Menge an Einheiten
--
-- @within Goal
--
function Goal_UnitsOnTerritory(...)
    return B_Goal_UnitsOnTerritory:new(...);
end

B_Goal_UnitsOnTerritory = {
    Name = "Goal_UnitsOnTerritory",
    Description = {
        en = "Goal: Place a certain amount of units on a territory",
        de = "Ziel: Platziere eine bestimmte Anzahl Einheiten auf einem Gebiet",
        fr = "Objectif: placer un certain nombre d'unités sur un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryNameWithUnknown, en = "Territory", de = "Territorium", fr = "Territoire" },
        { ParameterType.Custom,  en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom,  en = "Category", de = "Kategorie", fr = "Catégorie" },
        { ParameterType.Custom,  en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number,  en = "Number of units", de = "Anzahl Einheiten", fr = "Quantité d'unitées" },
    },
}

function B_Goal_UnitsOnTerritory:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_UnitsOnTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if self.TerritoryID == nil then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    elseif (_Index == 1) then
        self.PlayerID = tonumber(_Parameter) * 1
    elseif (_Index == 2) then
        self.Category = _Parameter
    elseif (_Index == 3) then
        self.bRelSmallerThan = (tostring(_Parameter) == "true" or tostring(_Parameter) == "<")
    elseif (_Index == 4) then
        self.NumberOfUnits = _Parameter * 1
    end
end

function B_Goal_UnitsOnTerritory:CustomFunction(_Quest)
    local PlayerEntities;
    if API.SearchEntitiesOfCategoryInTerritory then
        local PlayerID = (self.PlayerID == -1 and nil) or self.PlayerID;
        PlayerEntities = API.SearchEntitiesOfCategoryInTerritory(self.TerritoryID, EntityCategories[self.Category], PlayerID);
    else
        PlayerEntities = self:GetEntities(self.TerritoryID, self.PlayerID, EntityCategories[self.Category]);
    end
    if self.bRelSmallerThan == false and #PlayerEntities >= self.NumberOfUnits then
        return true;
    elseif self.bRelSmallerThan == true and #PlayerEntities < self.NumberOfUnits then
        return true;
    end
end

function B_Goal_UnitsOnTerritory:GetEntities(_TerritoryID, _PlayerID, _Category)
    local PlayerEntities = {};
    local Units = {};
    if (_PlayerID == -1) then
        for i=0,8 do
            local NumLast = 0;
            repeat
                Units = {Logic.GetEntitiesOfCategoryInTerritory(_TerritoryID, i, _PlayerID, NumLast)};
                PlayerEntities = Array_Append(PlayerEntities, Units);
                NumLast = NumLast + #Units;
            until #Units == 0;
        end
    else
        local NumLast = 0;
        repeat
            Units = { Logic.GetEntitiesOfCategoryInTerritory(_TerritoryID, _PlayerID, _Category, NumLast)};
            PlayerEntities = Array_Append(PlayerEntities, Units);
            NumLast = NumLast + #Units;
        until #Units == 0;
    end
    return PlayerEntities;
end

function B_Goal_UnitsOnTerritory:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, -1 )
        for i = 1, 8 do
            table.insert( Data, i )
        end
    elseif _Index == 2 then
        for k, v in pairs( EntityCategories ) do
            if not string.find( k, "^G_" ) and k ~= "SheepPasture" then
                table.insert( Data, k )
            end
        end
        table.sort( Data );
    elseif _Index == 3 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_UnitsOnTerritory:Debug(_Quest)
    local territories = {Logic.GetTerritories()}
    if tonumber(self.TerritoryID) == nil or self.TerritoryID < 0 or not table.contains(territories, self.TerritoryID) then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid territoryID!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 0 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    elseif not EntityCategories[self.Category] then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid entity category!");
        return true;
    elseif tonumber(self.NumberOfUnits) == nil or self.NumberOfUnits < 0 then
        error(_Quest.Identifier.. ": " ..self.Name..": amount is negative or nil!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_UnitsOnTerritory);

-- -------------------------------------------------------------------------- --

---
-- Der angegebene Spieler muss einen Buff aktivieren.
--
-- <u>Buffs "Aufstieg eines Königreich"</u>
-- <li>Buff_Spice: Salz</li>
-- <li>Buff_Colour: Farben</li>
-- <li>Buff_Entertainers: Entertainer anheuern</li>
-- <li>Buff_FoodDiversity: Vielfältige Nahrung</li>
-- <li>Buff_ClothesDiversity: Vielfältige Kleidung</li>
-- <li>Buff_HygieneDiversity: Vielfältige Hygiene</li>
-- <li>Buff_EntertainmentDiversity: Vielfältige Unterhaltung</li>
-- <li>Buff_Sermon: Predigt halten</li>
-- <li>Buff_Festival: Fest veranstalten</li>
-- <li>Buff_ExtraPayment: Bonussold auszahlen</li>
-- <li>Buff_HighTaxes: Hohe Steuern verlangen</li>
-- <li>Buff_NoPayment: Sold streichen</li>
-- <li>Buff_NoTaxes: Keine Steuern verlangen</li>
-- <br/>
-- <u>Buffs "Reich des Ostens"</u>
-- <li>Buff_Gems: Edelsteine</li>
-- <li>Buff_MusicalInstrument: Musikinstrumente</li>
-- <li>Buff_Olibanum: Weihrauch</li>
--
-- @param _PlayerID Spieler, der den Buff aktivieren muss
-- @param _Buff     Buff, der aktiviert werden soll
--
-- @within Goal
--
function Goal_ActivateBuff(...)
    return B_Goal_ActivateBuff:new(...);
end

B_Goal_ActivateBuff = {
    Name = "Goal_ActivateBuff",
    Description = {
        en = "Goal: Activate a buff",
        de = "Ziel: Aktiviere einen Buff",
        fr = "Objectif: Activer un bonus",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom, en = "Buff", de = "Buff", fr = "Bonus" },
    },
}

function B_Goal_ActivateBuff:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_ActivateBuff:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.BuffName = _Parameter
        self.Buff = Buffs[_Parameter]
    end
end

function B_Goal_ActivateBuff:CustomFunction(_Quest)
   if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local tMapping = Revision.LuaBase:CopyTable(Revision.Behavior.Text.ActivateBuff.BuffsVanilla);
        if g_GameExtraNo >= 1 then
            tMapping = Revision.LuaBase:CopyTable(Revision.Behavior.Text.ActivateBuff.BuffsEx1, tMapping);
        end
        Revision:ChangeCustomQuestCaptionText(
            string.format(
                Revision:Localize(Revision.Behavior.Text.ActivateBuff.Pattern),
                Revision:Localize(tMapping[self.BuffName])
            ),
            _Quest
        );
    end

    local Buff = Logic.GetBuff( self.PlayerID, self.Buff )
    if Buff and Buff ~= 0 then
        return true
    end
end

function B_Goal_ActivateBuff:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        Data = {
            "Buff_Spice",
            "Buff_Colour",
            "Buff_Entertainers",
            "Buff_FoodDiversity",
            "Buff_ClothesDiversity",
            "Buff_HygieneDiversity",
            "Buff_EntertainmentDiversity",
            "Buff_Sermon",
            "Buff_Festival",
            "Buff_ExtraPayment",
            "Buff_HighTaxes",
            "Buff_NoPayment",
            "Buff_NoTaxes"
        }

        if g_GameExtraNo >= 1 then
            table.insert(Data, "Buff_Gems")
            table.insert(Data, "Buff_MusicalInstrument")
            table.insert(Data, "Buff_Olibanum")
        end

        table.sort( Data )
    else
        assert( false )
    end
    return Data
end

function B_Goal_ActivateBuff:GetIcon()
    local tMapping = {
        [Buffs.Buff_Spice]                  = "Goods.G_Salt",
        [Buffs.Buff_Colour]                 = "Goods.G_Dye",
        [Buffs.Buff_Entertainers]           = "Entities.U_Entertainer_NA_FireEater", --{5, 12},
        [Buffs.Buff_FoodDiversity]          = "Needs.Nutrition", --{1, 1},
        [Buffs.Buff_ClothesDiversity]       = "Needs.Clothes", --{1, 2},
        [Buffs.Buff_HygieneDiversity]       = "Needs.Hygiene", --{16, 1},
        [Buffs.Buff_EntertainmentDiversity] = "Needs.Entertainment", --{1, 4},
        [Buffs.Buff_Sermon]                 = "Technologies.R_Sermon", --{4, 14},
        [Buffs.Buff_Festival]               = "Technologies.R_Festival", --{4, 15},
        [Buffs.Buff_ExtraPayment]           = {1,8},
        [Buffs.Buff_HighTaxes]              = {1,6},
        [Buffs.Buff_NoPayment]              = {1,8},
        [Buffs.Buff_NoTaxes]                = {1,6},
    }
    if g_GameExtraNo and g_GameExtraNo >= 1 then
        tMapping[Buffs.Buff_Gems] = "Goods.G_Gems"
        tMapping[Buffs.Buff_MusicalInstrument] = "Goods.G_MusicalInstrument"
        tMapping[Buffs.Buff_Olibanum] = "Goods.G_Olibanum"
    end
    return tMapping[self.Buff]
end

function B_Goal_ActivateBuff:Debug(_Quest)
    if not self.Buff then
        error(_Quest.Identifier.. ": " ..self.Name..": buff '" ..self.BuffName.. "' does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_ActivateBuff);

-- -------------------------------------------------------------------------- --

---
-- Zwei Punkte auf der Spielwelt müssen mit einer Straße verbunden werden.
--
-- @param _Position1 Erster Endpunkt der Straße
-- @param _Position2 Zweiter Endpunkt der Straße
-- @param _OnlyRoads Keine Wege akzeptieren
--
-- @within Goal
--
function Goal_BuildRoad(...)
    return B_Goal_BuildRoad:new(...)
end

B_Goal_BuildRoad = {
    Name = "Goal_BuildRoad",
    Description = {
        en = "Goal: Connect two points with a street or a road",
        de = "Ziel: Verbinde zwei Punkte mit einer Strasse oder einem Weg.",
        fr = "Objectif: Relier deux points par une route ou un chemin.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity 1",       de = "Entity 1",     fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2",       de = "Entity 2",     fr = "Entité 2" },
        { ParameterType.Custom,     en = "Only roads",     de = "Nur Strassen", fr = "Que des Routes" },
    },
}

function B_Goal_BuildRoad:GetGoalTable()
    -- {BehaviorType, {EntityID1, EntityID2, BeSmalerThan, Length, RoadsOnly}}
    -- -> Length wird nicht mehr benutzt. Sorgte für Promleme im Spiel
    return { Objective.BuildRoad, { GetID( self.Entity1 ), GetID( self.Entity2 ), false, 0, self.bRoadsOnly } }
end

function B_Goal_BuildRoad:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity1 = _Parameter
    elseif (_Index == 1) then
        self.Entity2 = _Parameter
    elseif (_Index == 2) then
        self.bRoadsOnly = API.ToBoolean(_Parameter)
    end
end

function B_Goal_BuildRoad:GetCustomData( _Index )
    local Data
    if _Index == 2 then
        Data = {"true","false"}
    end
    return Data
end

function B_Goal_BuildRoad:Debug(_Quest)
    if not IsExisting(self.Entity1) or not IsExisting(self.Entity2) then
        error(_Quest.Identifier.. ": " ..self.Name..": first or second entity does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_BuildRoad);

-- -------------------------------------------------------------------------- --


---
-- Eine Mauer muss gebaut werden um die Bewegung eines Spielers einzuschränken.
-- 
-- Einschränken bedeutet, dass sich der angegebene Spieler nicht von Punkt A
-- nach Punkt B bewegen kann, weil eine Mauer im Weg ist. Die Punkte sind
-- frei wählbar. In den meisten Fällen reicht es, Marktplätze anzugeben.
--
-- Beispiel: Spieler 3 ist der Feind von Spieler 1, aber Bekannt mit Spieler 2.
-- Wenn er sich nicht mehr zwischen den Marktplätzen von Spieler 1 und 2
-- bewegen kann, weil eine Mauer dazwischen ist, ist das Ziel erreicht.
--
-- <b>Achtung:</b> Bei Monsun kann dieses Ziel fälschlicher Weise als erfüllt
-- gewertet werden, wenn der Weg durch Wasser blockiert wird!
--
-- @param _PlayerID  PlayerID, die blockiert wird
-- @param _Position1 Erste Position
-- @param _Position2 Zweite Position
--
-- @within Goal
--
function Goal_BuildWall(...)
    return B_Goal_BuildWall:new(...)
end

B_Goal_BuildWall = {
    Name = "Goal_BuildWall",
    Description = {
        en = "Goal: Build a wall between 2 positions bo stop the movement of an (hostile) player.",
        de = "Ziel: Baue eine Mauer zwischen 2 Punkten, die die Bewegung eines (feindlichen) Spielers zwischen den Punkten verhindert.",
        fr = "Objectif: Construire un mur entre 2 points qui empêche le déplacement d'un joueur (ennemi) entre les points.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Enemy", de = "Feind", fr = "Ennemi" },
        { ParameterType.ScriptName, en = "Entity 1", de = "Entity 1", fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2", de = "Entity 2", fr = "Entité 2" },
    },
}

function B_Goal_BuildWall:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_BuildWall:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.EntityName1 = _Parameter
    elseif (_Index == 2) then
        self.EntityName2 = _Parameter
    end
end

function B_Goal_BuildWall:CustomFunction(_Quest)
    local eID1 = GetID(self.EntityName1)
    local eID2 = GetID(self.EntityName2)

    if not IsExisting(eID1) then
        return false
    end
    if not IsExisting(eID2) then
        return false
    end
    local x,y,z = Logic.EntityGetPos(eID1)
    if Logic.IsBuilding(eID1) == 1 then
        x,y = Logic.GetBuildingApproachPosition(eID1)
    end
    local Sector1 = Logic.GetPlayerSectorAtPosition(self.PlayerID, x, y)
    local x,y,z = Logic.EntityGetPos(eID2)
    if Logic.IsBuilding(eID2) == 1 then
        x,y = Logic.GetBuildingApproachPosition(eID2)
    end
    local Sector2 = Logic.GetPlayerSectorAtPosition(self.PlayerID, x, y)
    if Sector1 ~= Sector2 then
        return true
    end
    return nil
end

function B_Goal_BuildWall:GetMsgKey()
    return "Quest_Create_Wall"
end

function B_Goal_BuildWall:GetIcon()
    return {3,9}
end

function B_Goal_BuildWall:Debug(_Quest)
    if not IsExisting(self.EntityName1) or not IsExisting(self.EntityName2) then
        error(_Quest.Identifier.. ": " ..self.Name..": first or second entity does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end

    if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) > -1 and not self.WarningPrinted then
        warn(_Quest.Identifier.. ": " ..self.Name..": player %d is neighter enemy or unknown to quest receiver!");
        self.WarningPrinted = true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_BuildWall);

-- -------------------------------------------------------------------------- --

---
-- Ein bestimmtes Territorium muss vom Auftragnehmer eingenommen werden.
--
-- @param _Territory Territorium-ID oder Territoriumname
--
-- @within Goal
--
function Goal_Claim(...)
    return B_Goal_Claim:new(...)
end

B_Goal_Claim = {
    Name = "Goal_Claim",
    Description = {
        en = "Goal: Claim a territory",
        de = "Ziel: Erobere ein Territorium",
        fr = "Objectif: Conquérir un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryName, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_Claim:GetGoalTable()
    return { Objective.Claim, 1, self.TerritoryID }
end

function B_Goal_Claim:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    end
end

function B_Goal_Claim:GetMsgKey()
    return "Quest_Claim_Territory"
end

Revision:RegisterBehavior(B_Goal_Claim);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Menge an Territorien besitzen.
-- Das Heimatterritorium des Spielers wird mitgezählt!
--
-- @param _Amount Anzahl Territorien
--
-- @within Goal
--
function Goal_ClaimXTerritories(...)
    return B_Goal_ClaimXTerritories:new(...)
end

B_Goal_ClaimXTerritories = {
    Name = "Goal_ClaimXTerritories",
    Description = {
        en = "Goal: Claim the given number of territories, all player territories are counted",
        de = "Ziel: Erobere die angegebene Anzahl Territorien, alle spielereigenen Territorien werden gezählt",
        fr = "Objectif: conquérir le nombre de territoires indiqué, tous les territoires des joueurs sont comptabilisés.",
    },
    Parameter = {
        { ParameterType.Number, en = "Territories" , de = "Territorien", fr = "Territoire" }
    },
}

function B_Goal_ClaimXTerritories:GetGoalTable()
    return { Objective.Claim, 2, self.TerritoriesToClaim }
end

function B_Goal_ClaimXTerritories:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoriesToClaim = _Parameter * 1
    end
end

function B_Goal_ClaimXTerritories:GetMsgKey()
    return "Quest_Claim_Territory"
end

Revision:RegisterBehavior(B_Goal_ClaimXTerritories);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss auf dem Territorium einen Entitytyp erstellen.
--
-- Dieses Behavior eignet sich für Aufgaben vom Schlag "Baue X Getreidefarmen
-- Auf Territorium >".
--
-- @param _Type      Typ des Entity
-- @param _Amount    Menge an Entities
-- @param _Territory Territorium
--
-- @within Goal
--
function Goal_Create(...)
    return B_Goal_Create:new(...);
end

B_Goal_Create = {
    Name = "Goal_Create",
    Description = {
        en = "Goal: Create Buildings/Units on a specified territory",
        de = "Ziel: Erstelle Einheiten/Gebäude auf einem bestimmten Territorium.",
        fr = "Objectif: créer des unités/bâtiments sur un territoire donné.",
    },
    Parameter = {
        { ParameterType.Entity, en = "Type name", de = "Typbezeichnung", fr = "Désignation du type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.TerritoryNameWithUnknown, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_Create:GetGoalTable()
    return { Objective.Create, assert( Entities[self.EntityName] ), self.Amount, self.TerritoryID }
end

function B_Goal_Create:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    elseif (_Index == 2) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    end
end

function B_Goal_Create:GetMsgKey()
    return Logic.IsEntityTypeInCategory( Entities[self.EntityName], EntityCategories.AttackableBuilding ) == 1 and "Quest_Create_Building" or "Quest_Create_Unit"
end

Revision:RegisterBehavior(B_Goal_Create);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Menge von Rohstoffen produzieren.
--
-- @param _Type   Typ des Rohstoffs
-- @param _Amount Menge an Rohstoffen
--
-- @within Goal
--
function Goal_Produce(...)
    return B_Goal_Produce:new(...);
end

B_Goal_Produce = {
    Name = "Goal_Produce",
    Description = {
        en = "Goal: Produce an amount of goods",
        de = "Ziel: Produziere eine Anzahl einer bestimmten Ware.",
        fr = "Objectif: produire un certain nombre d'une marchandise donnée."
    },
    Parameter = {
        { ParameterType.RawGoods, en = "Type of good", de = "Ressourcentyp", fr = "Type de ressources" },
        { ParameterType.Number, en = "Amount of good", de = "Anzahl der Ressource", fr = "Quantité de ressources" },
    },
}

function B_Goal_Produce:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Produce, GoodType, self.GoodAmount }
end

function B_Goal_Produce:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Goal_Produce:GetMsgKey()
    return "Quest_Produce"
end

Revision:RegisterBehavior(B_Goal_Produce);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler muss eine bestimmte Menge einer Ware erreichen.
--
-- @param _Type     Typ der Ware
-- @param _Amount   Menge an Waren
-- @param _Relation Mengenrelation
--
-- @within Goal
--
function Goal_GoodAmount(...)
    return B_Goal_GoodAmount:new(...);
end

B_Goal_GoodAmount = {
    Name = "Goal_GoodAmount",
    Description = {
        en = "Goal: Obtain an amount of goods - either by trading or producing them",
        de = "Ziel: Beschaffe eine Anzahl Waren - entweder durch Handel oder durch eigene Produktion.",
        fr = "Objectif: Se procurer un certain nombre de marchandises - soit par le commerce, soit par sa propre production."
    },
    Parameter = {
        { ParameterType.Custom, en = "Type of good", de = "Warentyp", fr = "TYpe de marchandises" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
    },
}

function B_Goal_GoodAmount:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Produce, GoodType, self.GoodAmount, self.bRelSmallerThan }
end

function B_Goal_GoodAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    elseif  (_Index == 2) then
        self.bRelSmallerThan = _Parameter == "<" or tostring(_Parameter) == "true"
    end
end

function B_Goal_GoodAmount:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

Revision:RegisterBehavior(B_Goal_GoodAmount);

-- -------------------------------------------------------------------------- --

---
-- Die Siedler des Spielers dürfen nicht aufgrund des Bedürfnisses streiken.
--
-- <u>Bedürfnisse</u>
-- <ul>
-- <li>Clothes: Kleidung</li>
-- <li>Entertainment: Unterhaltung</li>
-- <li>Nutrition: Nahrung</li>
-- <li>Hygiene: Hygiene</li>
-- <li>Medicine: Medizin</li>
-- </ul>
--
-- @param _PlayerID ID des Spielers
-- @param _Need     Bedürfnis
--
-- @within Goal
--
function Goal_SatisfyNeed(...)
    return B_Goal_SatisfyNeed:new(...);
end

B_Goal_SatisfyNeed = {
    Name = "Goal_SatisfyNeed",
    Description = {
        en = "Goal: Satisfy a need",
        de = "Ziel: Erfuelle ein Beduerfnis",
        fr = "Objectif: Répondre à un besoin",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Need, en = "Need", de = "Beduerfnis", fr = "Besoin" },
    },
}

function B_Goal_SatisfyNeed:GetGoalTable()
    return { Objective.SatisfyNeed, Needs[self.Need], self.PlayerID }

end

function B_Goal_SatisfyNeed:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Need = _Parameter
    end

end

function B_Goal_SatisfyNeed:GetMsgKey()
    local tMapping = {
        [Needs.Clothes] = "Quest_SatisfyNeed_Clothes",
        [Needs.Entertainment] = "Quest_SatisfyNeed_Entertainment",
        [Needs.Nutrition] = "Quest_SatisfyNeed_Food",
        [Needs.Hygiene] = "Quest_SatisfyNeed_Hygiene",
        [Needs.Medicine] = "Quest_SatisfyNeed_Medicine",
    }

    local Key = tMapping[Needs[self.Need]]
    if Key then
        return Key
    end

    -- No default message
end

Revision:RegisterBehavior(B_Goal_SatisfyNeed);

-- -------------------------------------------------------------------------- --

---
-- Der angegebene Spieler muss eine Menge an Siedlern in der Stadt haben.
--
-- @param _Amount   Menge an Siedlern
-- @param _PlayerID ID des Spielers (Default: 1)
--
-- @within Goal
--
function Goal_SettlersNumber(...)
    return B_Goal_SettlersNumber:new(...);
end

B_Goal_SettlersNumber = {
    Name = "Goal_SettlersNumber",
    Description = {
        en = "Goal: Get a given amount of settlers",
        de = "Ziel: Erreiche eine bestimmte Anzahl Siedler.",
        fr = "Objectif: atteindre un certain nombre de Settlers.",
    },
    Parameter = {
        { ParameterType.Number,   en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_SettlersNumber:GetGoalTable()
    return {Objective.SettlersNumber, self.PlayerID or 1, self.SettlersAmount };
end

function B_Goal_SettlersNumber:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SettlersAmount = _Parameter * 1;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    end
end

function B_Goal_SettlersNumber:GetMsgKey()
    return "Quest_NumberSettlers";
end

Revision:RegisterBehavior(B_Goal_SettlersNumber);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Menge von Ehefrauen in der Stadt haben.
--
-- @param _Amount Menge an Ehefrauen
--
-- @within Goal
--
function Goal_Spouses(...)
    return B_Goal_Spouses:new(...);
end

B_Goal_Spouses = {
    Name = "Goal_Spouses",
    Description = {
        en = "Goal: Get a given amount of spouses",
        de = "Ziel: Erreiche eine bestimmte Ehefrauenanzahl",
        fr = "Objectif: Atteindre un certain nombre d'épouses",
    },
    Parameter = {
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
    },
}

function B_Goal_Spouses:GetGoalTable()
    return {Objective.Spouses, self.SpousesAmount }
end

function B_Goal_Spouses:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SpousesAmount = _Parameter * 1
    end
end

function B_Goal_Spouses:GetMsgKey()
    return "Quest_NumberSpouses"
end

Revision:RegisterBehavior(B_Goal_Spouses);

-- -------------------------------------------------------------------------- --

---
-- Ein Spieler muss eine Menge an Soldaten haben.
--
-- <u>Relationen</u>
-- <ul>
-- <li>>= - Anzahl als Mindestmenge</li>
-- <li>< - Weniger als Anzahl</li>
-- </ul>
--
-- Dieses Behavior kann verwendet werden um die Menge an feindlichen
-- Soldaten zu zählen oder die Menge an Soldaten des Spielers.
--
-- @param _PlayerID ID des Spielers
-- @param _Relation Mengenrelation
-- @param _Amount   Menge an Soldaten
--
-- @within Goal
--
function Goal_SoldierCount(...)
    return B_Goal_SoldierCount:new(...);
end

B_Goal_SoldierCount = {
    Name = "Goal_SoldierCount",
    Description = {
        en = "Goal: Create a specified number of soldiers",
        de = "Ziel: Erreiche eine Anzahl grösser oder kleiner der angegebenen Menge Soldaten.",
        fr = "Objectif: Atteindre un nombre de soldats supérieur ou inférieur à la quantité indiquée.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Number of soldiers", de = "Anzahl Soldaten", fr = "Nombre de soldats" },
    },
}

function B_Goal_SoldierCount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_SoldierCount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.bRelSmallerThan = tostring(_Parameter) == "true" or tostring(_Parameter) == "<"
    elseif (_Index == 2) then
        self.NumberOfUnits = _Parameter * 1
    end
end

function B_Goal_SoldierCount:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local Relation = tostring(self.bRelSmallerThan);
        local PlayerName = GetPlayerName(self.PlayerID) or "";
        Revision:ChangeCustomQuestCaptionText(
            string.format(
                Revision:Localize(Revision.Behavior.Text.SoldierCount.Pattern),
                PlayerName,
                Revision:Localize(Revision.Behavior.Text.SoldierCount.Relation[Relation]),
                self.NumberOfUnits
            ),
            _Quest
        );
    end

    local NumSoldiers = Logic.GetCurrentSoldierCount( self.PlayerID )
    if ( self.bRelSmallerThan and NumSoldiers < self.NumberOfUnits ) then
        return true
    elseif ( not self.bRelSmallerThan and NumSoldiers >= self.NumberOfUnits ) then
        return true
    end
    return nil
end

function B_Goal_SoldierCount:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then

        table.insert( Data, ">=" )
        table.insert( Data, "<" )

    else
        assert( false )
    end
    return Data
end

function B_Goal_SoldierCount:GetIcon()
    return {7,11}
end

function B_Goal_SoldierCount:GetMsgKey()
    return "Quest_Create_Unit"
end

function B_Goal_SoldierCount:Debug(_Quest)
    if tonumber(self.NumberOfUnits) == nil or self.NumberOfUnits < 0 then
        error(_Quest.Identifier.. ": " ..self.Name..": amount can not be below 0!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_SoldierCount);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss wenigstens einen bestimmten Titel erreichen.
--
-- Folgende Titel können verwendet werden:
-- <table border="1">
-- <tr>
-- <td><b>Titel</b></td>
-- <td><b>Übersetzung</b></td>
-- </tr>
-- <tr>
-- <td>Knight</td>
-- <td>Ritter</td>
-- </tr>
-- <tr>
-- <td>Mayor</td>
-- <td>Landvogt</td>
-- </tr>
-- <tr>
-- <td>Baron</td>
-- <td>Baron</td>
-- </tr>
-- <tr>
-- <td>Earl</td>
-- <td>Graf</td>
-- </tr>
-- <tr>
-- <td>Marquees</td>
-- <td>Marktgraf</td>
-- </tr>
-- <tr>
-- <td>Duke</td>
-- <td>Herzog</td>
-- </tr>
-- </tr>
-- <tr>
-- <td>Archduke</td>
-- <td>Erzherzog</td>
-- </tr>
-- <table>
--
-- @param _Title Titel, der erreicht werden muss
--
-- @within Goal
--
function Goal_KnightTitle(...)
    return B_Goal_KnightTitle:new(...);
end

B_Goal_KnightTitle = {
    Name = "Goal_KnightTitle",
    Description = {
        en = "Goal: Reach a specified knight title",
        de = "Ziel: Erreiche einen vorgegebenen Titel",
        fr = "Objectif: atteindre un titre donné",
    },
    Parameter = {
        { ParameterType.Custom, en = "Knight title", de = "Titel", fr = "Titre" },
    },
}

function B_Goal_KnightTitle:GetGoalTable()
    return {Objective.KnightTitle, assert( KnightTitles[self.KnightTitle] ) }
end

function B_Goal_KnightTitle:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.KnightTitle = _Parameter
    end
end

function B_Goal_KnightTitle:GetMsgKey()
    return "Quest_KnightTitle"
end

function B_Goal_KnightTitle:GetCustomData( _Index )
    return {"Knight", "Mayor", "Baron", "Earl", "Marquees", "Duke", "Archduke"}
end

Revision:RegisterBehavior(B_Goal_KnightTitle);

-- -------------------------------------------------------------------------- --

---
-- Der angegebene Spieler muss mindestens die Menge an Festen feiern.
--
-- Ein Fest wird gewertet, sobald die Metfässer auf dem Markt erscheinen. Diese
-- Metfässer erscheinen im normalen Spielverlauf nur durch ein Fest!
--
-- <b>Achtung</b>: Wenn ein Spieler aus einem anderen Grund Metfässer besitzt,
-- wird dieses Behavior nicht mehr richtig funktionieren!
--
-- @param _PlayerID ID des Spielers
-- @param _Amount   Menge an Festen
--
-- @within Goal
--
function Goal_Festivals(...)
    return B_Goal_Festivals:new(...);
end

B_Goal_Festivals = {
    Name = "Goal_Festivals",
    Description = {
        en = "Goal: The player has to start the given number of festivals.",
        de = "Ziel: Der Spieler muss eine gewisse Anzahl Feste gestartet haben.",
        fr = "Objectif: Le joueur doit avoir lancé un certain nombre de festivités."
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Number, en = "Number of festivals", de = "Anzahl Feste", fr = "Nombre de festivités" }
    }
};

function B_Goal_Festivals:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_Festivals:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.PlayerID = tonumber(_Parameter);
    else
        assert(_Index == 1, "Error in " .. self.Name .. ": AddParameter: Index is invalid.");
        self.NeededFestivals = tonumber(_Parameter);
    end
end

function B_Goal_Festivals:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local PlayerName = GetPlayerName(self.PlayerID) or "";
        Revision:ChangeCustomQuestCaptionText(
            string.format(
                Revision:Localize(Revision.Behavior.Text.Festivals.Pattern),
                PlayerName, self.NeededFestivals
            ), 
            _Quest
        );
    end

    if Logic.GetStoreHouse( self.PlayerID ) == 0  then
        return false
    end
    local tablesOnFestival = {Logic.GetPlayerEntities(self.PlayerID, Entities.B_TableBeer, 5,0)}
    local amount = 0
    for k=2, #tablesOnFestival do
        local tableID = tablesOnFestival[k]
        if Logic.GetIndexOnOutStockByGoodType(tableID, Goods.G_Beer) ~= -1 then
            local goodAmountOnMarketplace = Logic.GetAmountOnOutStockByGoodType(tableID, Goods.G_Beer)
            amount = amount + goodAmountOnMarketplace
        end
    end
    if not self.FestivalStarted and amount > 0 then
        self.FestivalStarted = true
        self.FestivalCounter = (self.FestivalCounter and self.FestivalCounter + 1) or 1
        if self.FestivalCounter >= self.NeededFestivals then
            self.FestivalCounter = nil
            return true
        end
    elseif amount == 0 then
        self.FestivalStarted = false
    end
end

function B_Goal_Festivals:Debug(_Quest)
    if Logic.GetStoreHouse( self.PlayerID ) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.PlayerID .. " is dead :-(")
        return true
    elseif GetPlayerCategoryType(self.PlayerID) ~= PlayerCategories.City then
        error(_Quest.Identifier.. ": " ..self.Name .. ":  Player "..  self.PlayerID .. " is no city")
        return true
    elseif self.NeededFestivals < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Festivals is negative")
        return true
    end
    return false
end

function B_Goal_Festivals:Reset()
    self.FestivalCounter = nil
    self.FestivalStarted = nil
end

function B_Goal_Festivals:GetIcon()
    return {4,15}
end

Revision:RegisterBehavior(B_Goal_Festivals)

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Einheit gefangen nehmen.
--
-- @param _ScriptName Ziel
--
-- @within Goal
--
function Goal_Capture(...)
    return B_Goal_Capture:new(...)
end

B_Goal_Capture = {
    Name = "Goal_Capture",
    Description = {
        en = "Goal: Capture a cart.",
        de = "Ziel: Ein Karren muss erobert werden.",
        fr = "Objectif: un chariot doit être conquis.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_Capture:GetGoalTable()
    return { Objective.Capture, 1, { self.ScriptName } }
end

function B_Goal_Capture:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_Capture:GetMsgKey()
   local ID = GetID(self.ScriptName)
   if Logic.IsEntityAlive(ID) then
        ID = Logic.GetEntityType( ID )
        if ID and ID ~= 0 then
            if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
                return "Quest_Capture_Cart"

            elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SiegeEngine ) == 1 then
                return "Quest_Capture_SiegeEngine"

            elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Worker ) == 1
                or Logic.IsEntityTypeInCategory( ID, EntityCategories.Spouse ) == 1
                or Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then

                return "Quest_Capture_VIPOfPlayer"

            end
        end
    end
end

Revision:RegisterBehavior(B_Goal_Capture);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Menge von Einheiten eines Typs von einem
-- Spieler gefangen nehmen.
--
-- @param _Typ      Typ, der gefangen werden soll
-- @param _Amount   Menge an Einheiten
-- @param _PlayerID Besitzer der Einheiten
--
-- @within Goal
--
function Goal_CaptureType(...)
    return B_Goal_CaptureType:new(...)
end

B_Goal_CaptureType = {
    Name = "Goal_CaptureType",
    Description = {
        en = "Goal: Capture specified entity types",
        de = "Ziel: Nimm bestimmte Entitätstypen gefangen",
        fr = "Objectif: capturer certains types d'entités",
    },
    Parameter = {
        { ParameterType.Custom,     en = "Type name",   de = "Typbezeichnung",  fr = "Désignation du type" },
        { ParameterType.Number,     en = "Amount",      de = "Anzahl",          fr = "Quantité" },
        { ParameterType.PlayerID,   en = "Player",      de = "Spieler",         fr = "Joueur" },
    },
}

function B_Goal_CaptureType:GetGoalTable()
    return { Objective.Capture, 2, Entities[self.EntityName], self.Amount, self.PlayerID }
end

function B_Goal_CaptureType:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_CaptureType:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Entities ) do
            if string.find( k, "^U_.+Cart" ) or Logic.IsEntityTypeInCategory( v, EntityCategories.AttackableMerchant ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        for i = 0, 8 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Goal_CaptureType:GetMsgKey()

    local ID = self.EntityName
    if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
        return "Quest_Capture_Cart"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SiegeEngine ) == 1 then
        return "Quest_Capture_SiegeEngine"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Worker ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.Spouse ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then

        return "Quest_Capture_VIPOfPlayer"
    end
end

Revision:RegisterBehavior(B_Goal_CaptureType);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss das angegebene Entity beschützen.
--
-- Wird ein Wagen zerstört oder in das Lagerhaus / die Burg eines Feindes
-- gebracht, schlägt das Ziel fehl.
--
-- @param _ScriptName Zu beschützendes Entity
--
-- @within Goal
--
function Goal_Protect(...)
    return B_Goal_Protect:new(...)
end

B_Goal_Protect = {
    Name = "Goal_Protect",
    Description = {
        en = "Goal: Protect an entity (entity needs a script name",
        de = "Ziel: Beschütze eine Entität (Entität benötigt einen Skriptnamen)",
        fr = "Objectif : Protéger une entité (l'entité nécessite un nom de script)"
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_Protect:GetGoalTable()
    return {Objective.Protect, { self.ScriptName }}
end

function B_Goal_Protect:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_Protect:GetMsgKey()
    if Logic.IsEntityAlive(self.ScriptName) then
        local ID = GetID(self.ScriptName)
        if ID and ID ~= 0 then
            ID = Logic.GetEntityType( ID )
            if ID and ID ~= 0 then
                if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
                    return "Quest_Protect_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SpecialBuilding ) == 1 then
                    local tMapping = {
                        [PlayerCategories.City]        = "Quest_Protect_City",
                        [PlayerCategories.Cloister]    = "Quest_Protect_Cloister",
                        [PlayerCategories.Village]    = "Quest_Protect_Village",
                    }
                    local PlayerCategory = GetPlayerCategoryType( Logic.EntityGetPlayer(GetID(self.ScriptName)) )
                    if PlayerCategory then
                        local Key = tMapping[PlayerCategory]
                        if Key then
                            return Key
                        end
                    end
                    return "Quest_Protect_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
                    return "Quest_Protect_Knight"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
                    return "Quest_Protect_Cart"
                end
            end
        end
    end
    return "Quest_Protect"
end

Revision:RegisterBehavior(B_Goal_Protect);

-- -------------------------------------------------------------------------- --

---
-- Der Auftragnehmer muss eine Mine mit einem Geologen wieder auffüllen.
--
-- <b>Achtung</b>: Dieses Behavior ist nur in "Reich des Ostens" verfügbar.
--
-- @param _ScriptName Skriptname der Mine
--
-- @within Goal
--
function Goal_Refill(...)
    return B_Goal_Refill:new(...)
end

B_Goal_Refill = {
    Name = "Goal_Refill",
    Description = {
        en = "Goal: Refill an object using a geologist",
        de = "Ziel: Eine Mine soll durch einen Geologen wieder aufgefuellt werden.",
        fr = "Objectif: Une mine doit être réalimentée par un géologue.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
   RequiresExtraNo = 1,
}

function B_Goal_Refill:GetGoalTable()
    return { Objective.Refill, { GetID(self.ScriptName) } }
end

function B_Goal_Refill:GetIcon()
    return {8,1,1}
end

function B_Goal_Refill:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

if g_GameExtraNo > 0 then
    Revision:RegisterBehavior(B_Goal_Refill);
end

-- -------------------------------------------------------------------------- --

---
-- Eine bestimmte Menge an Rohstoffen in einer Mine muss erreicht werden.
--
-- Dieses Behavior eignet sich besonders für den Einsatz als versteckter
-- Quest um eine Reaktion auszulösen, wenn z.B. eine Mine leer ist.
--
-- <u>Relationen</u>
-- <ul>
-- <li>> - Mehr als Anzahl</li>
-- <li>< - Weniger als Anzahl</li>
-- </ul>
--
-- @param _ScriptName Skriptname der Mine
-- @param _Relation   Mengenrelation
-- @param _Amount     Menge an Rohstoffen
--
-- @within Goal
--
function Goal_ResourceAmount(...)
    return B_Goal_ResourceAmount:new(...)
end

B_Goal_ResourceAmount = {
    Name = "Goal_ResourceAmount",
    Description = {
        en = "Goal: Reach a specified amount of resources in a doodad",
        de = "Ziel: In einer Mine soll weniger oder mehr als eine angegebene Anzahl an Rohstoffen sein.",
        fr = "Objectif: Dans une mine, il doit y avoir moins ou plus de matières premières qu'un nombre indiqué.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité" },
    },
}

function B_Goal_ResourceAmount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_ResourceAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.bRelSmallerThan = _Parameter == "<"
    elseif (_Index == 2) then
        self.Amount = _Parameter * 1
    end
end

function B_Goal_ResourceAmount:CustomFunction(_Quest)
    local ID = GetID(self.ScriptName)
    if ID and ID ~= 0 and Logic.GetResourceDoodadGoodType(ID) ~= 0 then
        local HaveAmount = Logic.GetResourceDoodadGoodAmount(ID)
        if ( self.bRelSmallerThan and HaveAmount < self.Amount ) or ( not self.bRelSmallerThan and HaveAmount >= self.Amount ) then
            return true
        end
    end
    return nil
end

function B_Goal_ResourceAmount:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_ResourceAmount:Debug(_Quest)
    if not IsExisting(self.ScriptName) then
        error(_Quest.Identifier.. ": " ..self.Name..": entity '" ..self.ScriptName.. "' does not exist!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name..": error at amount! (nil or below 0)");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_ResourceAmount);

-- -------------------------------------------------------------------------- --

---
-- Der Quest schlägt sofort fehl.
--
-- @within Goal
--
function Goal_InstantFailure()
    return B_Goal_InstantFailure:new()
end

B_Goal_InstantFailure = {
    Name = "Goal_InstantFailure",
    Description = {
        en = "Goal: Instant failure, the goal returns false.",
        de = "Ziel: Direkter Misserfolg, das Goal sendet false.",
        fr = "Objectif: échec direct, le goal envoie false.",
    },
}

function B_Goal_InstantFailure:GetGoalTable()
    return {Objective.DummyFail};
end

Revision:RegisterBehavior(B_Goal_InstantFailure);

-- -------------------------------------------------------------------------- --

---
-- Der Quest wird sofort erfüllt.
--
-- @within Goal
--
function Goal_InstantSuccess()
    return B_Goal_InstantSuccess:new()
end

B_Goal_InstantSuccess = {
    Name = "Goal_InstantSuccess",
    Description = {
        en = "Goal: Instant success, the goal returns true.",
        de = "Ziel: Direkter Erfolg, das Goal sendet true.",
        fr = "Objectif: succès direct, le goal envoie false."
    },
}

function B_Goal_InstantSuccess:GetGoalTable()
    return {Objective.Dummy};
end

Revision:RegisterBehavior(B_Goal_InstantSuccess);

-- -------------------------------------------------------------------------- --

---
-- Der Zustand des Quests ändert sich niemals
--
-- Wenn ein Zeitlimit auf dem Quest liegt, wird dieses Behavior nicht
-- fehlschlagen sondern automatisch erfüllt.
--
-- @within Goal
--
function Goal_NoChange()
    return B_Goal_NoChange:new()
end

B_Goal_NoChange = {
    Name = "Goal_NoChange",
    Description = {
        en = "Goal: The quest state doesn't change. Use reward functions of other quests to change the state of this quest.",
        de = "Ziel: Der Questzustand wird nicht verändert. Ein Reward einer anderen Quest sollte den Zustand dieser Quest verändern.",
        fr = "Objectif: L'état de la quête n'est pas modifié. Une récompense d'une autre quête doit modifier l'état de cette quête.",
    },
}

function B_Goal_NoChange:GetGoalTable()
    return { Objective.NoChange }
end

Revision:RegisterBehavior(B_Goal_NoChange);

-- -------------------------------------------------------------------------- --

---
-- Führt eine Funktion im Skript als Goal aus.
--
-- Die Funktion muss entweder true, false oder nichts zurückgeben.
-- <ul>
-- <li>true: Erfolgreich abgeschlossen</li>
-- <li>false: Fehlschlag</li>
-- <li>nichts: Zustand unbestimmt</li>
-- </ul>
--
-- Anstelle eines Strings kann beim Einsatz im Skript eine Funktionsreferenz
-- übergeben werden. In diesem Fall werden alle weiteren Parameter direkt an
-- die Funktion weitergereicht.
--
-- @param _FunctionName Name der Funktion
--
-- @within Goal
--
function Goal_MapScriptFunction(...)
    return B_Goal_MapScriptFunction:new(...);
end

B_Goal_MapScriptFunction = {
    Name = "Goal_MapScriptFunction",
    Description = {
        en = "Goal: Calls a function within the global map script. Return 'true' means success, 'false' means failure and 'nil' doesn't change anything.",
        de = "Ziel: Ruft eine Funktion im globalen Skript auf, die einen Wahrheitswert zurueckgibt. Rueckgabe 'true' gilt als erfuellt, 'false' als gescheitert und 'nil' ändert nichts.",
        fr = "Objectif: Appelle une fonction dans le script global qui renvoie une valeur de vérité. Le retour 'true' est considéré comme rempli, 'false' comme échoué et 'nil' ne change rien.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Goal_MapScriptFunction:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_MapScriptFunction:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.FuncName = _Parameter
    end
end

function B_Goal_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        return self.FuncName(unpack(self.i47ya_6aghw_frxil));
    end
    return _G[self.FuncName](self, _Quest);
end

function B_Goal_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        error(_Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        error(_Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_MapScriptFunction);

-- -------------------------------------------------------------------------- --

---
-- Eine benutzerdefinierte Variable muss einen bestimmten Wert haben.
--
-- Custom Variables können ausschließlich Zahlen enthalten. Bevor eine
-- Variable in einem Goal abgefragt werden kann, muss sie zuvor mit
-- Reprisal_CustomVariables oder Reward_CutsomVariables initialisiert
-- worden sein.
--
-- <p>Vergleichsoperatoren</p>
-- <ul>
-- <li>== - Werte müssen gleich sein</li>
-- <li>~= - Werte müssen ungleich sein</li>
-- <li>> - Variablenwert größer Vergleichswert</li>
-- <li>>= - Variablenwert größer oder gleich Vergleichswert</li>
-- <li>< - Variablenwert kleiner Vergleichswert</li>
-- <li><= - Variablenwert kleiner oder gleich Vergleichswert</li>
-- </ul>
--
-- @param _Name     Name der Variable
-- @param _Relation Vergleichsoperator
-- @param _Value    Wert oder andere Custom Variable mit wert.
--
-- @within Goal
--
function Goal_CustomVariables(...)
    return B_Goal_CustomVariables:new(...);
end

B_Goal_CustomVariables = {
    Name = "Goal_CustomVariables",
    Description = {
        en = "Goal: A customised variable has to assume a certain value.",
        de = "Ziel: Eine benutzerdefinierte Variable muss einen bestimmten Wert annehmen.",
        fr = "Objectif: une variable définie par l'utilisateur doit prendre une certaine valeur.",
    },
    Parameter = {
        { ParameterType.Default, en = "Name of Variable", de = "Variablenname", fr = "Nom de la variable" },
        { ParameterType.Custom,  en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Default, en = "Value or variable", de = "Wert oder Variable", fr = "Valeur ou variable" }
    }
};

function B_Goal_CustomVariables:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Relation = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        self.Value = (value == nil and tostring(_Parameter)) or value;
    end
end

function B_Goal_CustomVariables:CustomFunction()
    local Value1 = API.ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = API.ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Relation == "==" then
        if Value1 == Value2 then
            return true;
        end
    elseif self.Relation == "~=" then
        if Value1 == Value2 then
            return true;
        end
    elseif self.Relation == "<" then
        if Value1 < Value2 then
            return true;
        end
    elseif self.Relation == "<=" then
        if Value1 <= Value2 then
            return true;
        end
    elseif self.Relation == ">=" then
        if Value1 >= Value2 then
            return true;
        end
    else
        if Value1 > Value2 then
            return true;
        end
    end
    return nil;
end

function B_Goal_CustomVariables:GetCustomData( _Index )
    return {"==", "~=", "<=", "<", ">", ">="};
end

function B_Goal_CustomVariables:Debug(_Quest)
    local relations = {"==", "~=", "<=", "<", ">", ">="}
    local results    = {true, false, nil}

    if not API.ObtainCustomVariable("BehaviorVariable_" ..self.VariableName) then
        warn(_Quest.Identifier.. ": " ..self.Name..": variable '"..self.VariableName.."' do not exist!");
    end
    if not table.contains(relations, self.Relation) then
        error(_Quest.Identifier.. ": " ..self.Name..": '"..self.Relation.."' is an invalid relation!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Goal_CustomVariables)

-- -------------------------------------------------------------------------- --

---
-- Der Spieler kann durch regelmäßiges Begleichen eines Tributes bessere
-- Diplomatie zu einem Spieler erreichen.
--
-- Die Zeit zum Bezahlen des Tributes muss immer kleiner sein als die
-- Wiederholungsperiode.
--
-- <b>Hinweis</b>: Je mehr Zeit sich der Spieler lässt um den Tribut zu
-- begleichen, desto mehr wird sich der Start der nächsten Periode verzögern.
--
-- @param _GoldAmount Menge an Gold
-- @param _Periode    Zahlungsperiode in Sekunden
-- @param _Time       Zeitbegrenzung in Sekunden
-- @param _StartMsg   Vorschlagnachricht
-- @param _SuccessMsg Erfolgsnachricht
-- @param _FailureMsg Fehlschlagnachricht
-- @param _Restart    Nach nichtbezahlen neu starten
--
-- @within Goal
--
function Goal_TributeDiplomacy(...)
    return B_Goal_TributeDiplomacy:new(...);
end

B_Goal_TributeDiplomacy = {
    Name = "Goal_TributeDiplomacy",
    Description = {
        en = "Goal: AI requests periodical tribute for better Diplomacy",
        de = "Ziel: Die KI fordert einen regelmässigen Tribut fuer bessere Diplomatie. Der Questgeber ist der fordernde Spieler.",
        fr = "Objectif: L'IA demande un tribut régulier pour une meilleure diplomatie. Le donneur de quête est le joueur qui exige."
    },
    Parameter = {
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité", },
        { ParameterType.Number, en = "Time till next peyment in seconds", de = "Zeit bis zur Forderung in Sekunden", fr = "Temps jusqu'à la demande en secondes", },
        { ParameterType.Number, en = "Time to pay tribute in seconds", de = "Zeit bis zur Zahlung in Sekunden", fr = "Délai avant paiement en secondes", },
        { ParameterType.Default, en = "Start Message for TributQuest", de = "Startnachricht der Tributquest", fr = "Message de début de quête de tribut", },
        { ParameterType.Default, en = "Success Message for TributQuest", de = "Erfolgsnachricht der Tributquest", fr = "Message de réussite de la quête de tribut", },
        { ParameterType.Default, en = "Failure Message for TributQuest", de = "Niederlagenachricht der Tributquest", fr = "Message de défaite de la quête de tribut", },
        { ParameterType.Custom, en = "Restart if failed to pay", de = "Nicht-bezahlen beendet die Quest", fr = "Ne pas payer met fin à la quête", },
    },
}

function B_Goal_TributeDiplomacy:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_TributeDiplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 1) then
        self.PeriodLength = _Parameter * 1;
    elseif (_Index == 2) then
        self.TributTime = _Parameter * 1;
    elseif (_Index == 3) then
        self.StartMsg = _Parameter;
    elseif (_Index == 4) then
        self.SuccessMsg = _Parameter;
    elseif (_Index == 5) then
        self.FailureMsg = _Parameter;
    elseif (_Index == 6) then
        self.RestartAtFailure = API.ToBoolean(_Parameter);
    end
end

function B_Goal_TributeDiplomacy:GetTributeQuest(_Quest)
    if not self.InternTributeQuest then
        local Language = QSB.Language;
        local StartMsg = self.StartMsg;
        if type(StartMsg) == "table" then
            StartMsg = StartMsg[Language];
        end
        local SuccessMsg = self.SuccessMsg;
        if type(SuccessMsg) == "table" then
            SuccessMsg = SuccessMsg[Language];
        end
        local FailureMsg = self.FailureMsg;
        if type(FailureMsg) == "table" then
            FailureMsg = FailureMsg[Language];
        end

        Revision.Behavior.QuestCounter = Revision.Behavior.QuestCounter+1;

        local QuestID, Quest = QuestTemplate:New (
            _Quest.Identifier.."_TributeDiplomacyQuest_" ..Revision.Behavior.QuestCounter,
            _Quest.SendingPlayer,
            _Quest.ReceivingPlayer,
            {{ Objective.Deliver, {Goods.G_Gold, self.Amount}}},
            {{ Triggers.Time, 0 }},
            self.TributTime, nil, nil, nil, nil, true, true, nil,
            StartMsg,
            SuccessMsg,
            FailureMsg
        );
        self.InternTributeQuest = Quest;
    end
end

function B_Goal_TributeDiplomacy:CheckTributeQuest(_Quest)
    if self.InternTributeQuest and self.InternTributeQuest.State == QuestState.Over and not self.RestartQuest then
        if self.InternTributeQuest.Result ~= QuestResult.Success then
            SetDiplomacyState( _Quest.ReceivingPlayer, _Quest.SendingPlayer, DiplomacyStates.Enemy);
            if not self.RestartAtFailure then
                return false;
            end
        else
            SetDiplomacyState(_Quest.ReceivingPlayer, _Quest.SendingPlayer, DiplomacyStates.TradeContact);
        end
        self.RestartQuest = true;
        self.Time = Logic.GetTime();
    end
end

function B_Goal_TributeDiplomacy:CheckTributePlayer(_Quest)
    local storeHouse = Logic.GetStoreHouse(_Quest.SendingPlayer);
    if (storeHouse == 0 or Logic.IsEntityDestroyed(storeHouse)) then
        if self.InternTributeQuest and self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end
        return true;
    end
end

function B_Goal_TributeDiplomacy:TributQuestRestarter(_Quest)
    if self.InternTributeQuest and self.Time and self.RestartQuest and ((Logic.GetTime() - self.Time) >= self.PeriodLength) then
        self.InternTributeQuest.Objectives[1].Completed = nil;
        self.InternTributeQuest.Objectives[1].Data[3] = nil;
        self.InternTributeQuest.Objectives[1].Data[4] = nil;
        self.InternTributeQuest.Objectives[1].Data[5] = nil;
        self.InternTributeQuest.Result = nil;
        self.InternTributeQuest.State = QuestState.NotTriggered;
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..self.InternTributeQuest.Index..")");
        StartSimpleJobEx(_G[QuestTemplate.Loop], self.InternTributeQuest.QueueID);
        self.RestartQuest = nil;
    end
end

function B_Goal_TributeDiplomacy:CustomFunction(_Quest)
    -- Tribut Quest erzeugen
    self:GetTributeQuest(_Quest);
    -- Status des Tributes prüfen.
    if self:CheckTributeQuest(_Quest) == false then
        return false;
    end
    -- Status des fordernden Spielers prüfen.
    if self:CheckTributePlayer(_Quest) == true then
        return true;
    end
    -- Quest neu starten, falls nötig.
    self:TributQuestRestarter(_Quest);
end

function B_Goal_TributeDiplomacy:Debug(_Quest)
    if self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount is negative!");
        return true;
    end
    if self.PeriodLength < self.TributTime then
        error(_Quest.Identifier.. ": " ..self.Name .. ": TributTime too long!");
        return true;
    end
end

function B_Goal_TributeDiplomacy:Reset(_Quest)
    self.Time = nil;
    self.InternTributeQuest = nil;
    self.RestartQuest = nil;
end

function B_Goal_TributeDiplomacy:Interrupt(_Quest)
    if self.InternTributeQuest ~= nil then
        if self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end
    end
end

function B_Goal_TributeDiplomacy:GetCustomData(_Index)
    if (_Index == 6) then
        return {"true", "false"};
    end
end

Revision:RegisterBehavior(B_Goal_TributeDiplomacy);

-- -------------------------------------------------------------------------- --

---
-- Erlaubt es dem Spieler ein Territorium zu "mieten".
--
-- Zerstört der Spieler den Außenposten, schlägt der Quest fehl und das
-- Territorium wird an den Vermieter übergeben. Wenn der Spieler die Pacht
-- nicht bezahlt, geht der Besitz an den Vermieter über.
--
-- Die Zeit zum Bezahlen des Tributes muss immer kleiner sein als die
-- Wiederholungsperiode.
--
-- <b>Hinweis</b>: Je mehr Zeit sich der Spieler lässt um den Tribut zu
-- begleichen, desto mehr wird sich der Start der nächsten Periode verzögern.
--
-- @param _Territory  Name des Territorium
-- @param _PlayerID   PlayerID des Zahlungsanforderer
-- @param _Cost       Menge an Gold
-- @param _Periode    Zahlungsperiode in Sekunden
-- @param _Time       Zeitbegrenzung in Sekunden
-- @param _StartMsg   Vorschlagnachricht
-- @param _SuccessMsg Erfolgsnachricht
-- @param _FailMsg    Fehlschlagnachricht
-- @param _HowOften   Anzahl an Zahlungen (0 = endlos)
-- @param _OtherOwner Eroberung durch Dritte beendet Quest
-- @param _Abort      Nach nichtbezahlen abbrechen
--
-- @within Goal
--
function Goal_TributeClaim(...)
    return B_Goal_TributeClaim:new(...);
end

B_Goal_TributeClaim = {
    Name = "Goal_TributeClaim",
    Description = {
        en = "Goal: AI requests periodical tribute for a specified territory. The quest sender is the demanding player.",
        de = "Ziel: Die KI fordert einen regelmässigen Tribut fuer ein Territorium. Der Questgeber ist der fordernde Spieler.",
        fr = "Objectif: L'IA demande un tribut régulier pour un territoire. Le donneur de quête est le joueur qui exige.",
    },
    Parameter = {
        { ParameterType.TerritoryName, en = "Territory", de = "Territorium", fr = "Territoire", },
        { ParameterType.PlayerID, en = "PlayerID", de = "PlayerID", fr = "PlayerID", },
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité", },
        { ParameterType.Number, en = "Length of Period in seconds", de = "Sekunden bis zur nächsten Forderung", fr = "secondes jusqu'à la prochaine demande", },
        { ParameterType.Number, en = "Time to pay Tribut in seconds", de = "Zeit bis zur Zahlung in Sekunden", fr = "Délai avant paiement en secondes", },
        { ParameterType.Default, en = "Start Message for TributQuest", de = "Startnachricht der Tributquest", fr = "Message de début de quête de tribut", },
        { ParameterType.Default, en = "Success Message for TributQuest", de = "Erfolgsnachricht der Tributquest", fr = "Message de réussite de la quête de tribut", },
        { ParameterType.Default, en = "Failure Message for TributQuest", de = "Niederlagenachricht der Tributquest", fr = "Message de défaite de la quête de tribut", },
        { ParameterType.Number, en = "How often to pay (0 = forerver)", de = "Anzahl der Tributquests (0 = unendlich)", fr = "Nombre de quêtes de tribut (0 = infini)", },
        { ParameterType.Custom, en = "Other Owner cancels the Quest", de = "Anderer Spieler kann Quest beenden", fr = "Un autre joueur peut terminer une quête", },
        { ParameterType.Custom, en = "About if a rate is not payed", de = "Nicht-bezahlen beendet die Quest", fr = "Ne pas payer met fin à la quête", },
    },
}

function B_Goal_TributeClaim:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_TributeClaim:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        if type(_Parameter) == "string" then
            _Parameter = GetTerritoryIDByName(_Parameter);
        end
        self.TerritoryID = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 2) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 3) then
        self.PeriodLength = _Parameter * 1;
    elseif (_Index == 4) then
        self.TributTime = _Parameter * 1;
    elseif (_Index == 5) then
        self.StartMsg = _Parameter;
    elseif (_Index == 6) then
        self.SuccessMsg = _Parameter;
    elseif (_Index == 7) then
        self.FailureMsg = _Parameter;
    elseif (_Index == 8) then
        self.HowOften = _Parameter * 1;
    elseif (_Index == 9) then
        self.OtherOwnerCancels = API.ToBoolean(_Parameter);
    elseif (_Index == 10) then
        self.DontPayCancels = API.ToBoolean(_Parameter);
    end
end

function B_Goal_TributeClaim:CureOutpost(_Quest)
    local Outpost = Logic.GetTerritoryAcquiringBuildingID(self.TerritoryID);
    if IsExisting(Outpost) and API.GetEntityHealth(Outpost) < 25 and Logic.IsBuildingBeingKnockedDown(Outpost) == false then
        while (Logic.GetEntityHealth(Outpost) < Logic.GetEntityMaxHealth(Outpost) * 0.6) do
            Logic.HealEntity(Outpost, 1);
        end
    end
end

function B_Goal_TributeClaim:RestartTributeQuest(_Quest)
    if self.InternTributeQuest then
        self.InternTributeQuest.Objectives[1].Completed = nil;
        self.InternTributeQuest.Objectives[1].Data[3] = nil;
        self.InternTributeQuest.Objectives[1].Data[4] = nil;
        self.InternTributeQuest.Objectives[1].Data[5] = nil;
        self.InternTributeQuest.Result = nil;
        self.InternTributeQuest.State = QuestState.NotTriggered;
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..self.InternTributeQuest.Index..")");
        StartSimpleJobEx(_G[QuestTemplate.Loop], self.InternTributeQuest.QueueID);
    end
end

function B_Goal_TributeClaim:CreateTributeQuest(_Quest)
    if not self.InternTributeQuest then
        local Language = QSB.Language;
        local StartMsg = self.StartMsg;
        if type(StartMsg) == "table" then
            StartMsg = StartMsg[Language];
        end
        local SuccessMsg = self.SuccessMsg;
        if type(SuccessMsg) == "table" then
            SuccessMsg = SuccessMsg[Language];
        end
        local FailureMsg = self.FailureMsg;
        if type(FailureMsg) == "table" then
            FailureMsg = FailureMsg[Language];
        end

        Revision.Behavior.QuestCounter = Revision.Behavior.QuestCounter+1;

        local OnFinished = function()
            self.Time = Logic.GetTime();
        end
        local QuestID, Quest = QuestTemplate:New(
            _Quest.Identifier.."_TributeClaimQuest" ..Revision.Behavior.QuestCounter,
            self.PlayerID,
            _Quest.ReceivingPlayer,
            {{ Objective.Deliver, {Goods.G_Gold, self.Amount}}},
            {{ Triggers.Time, 0 }},
            self.TributTime, nil, nil, OnFinished, nil, true, true, nil,
            StartMsg,
            SuccessMsg,
            FailureMsg
        );
        self.InternTributeQuest = Quest;
    end
end

function B_Goal_TributeClaim:OnTributeFailed(_Quest)
    local Outpost = Logic.GetTerritoryAcquiringBuildingID(self.TerritoryID);
    if IsExisting(Outpost) then
        Logic.ChangeEntityPlayerID(Outpost, self.PlayerID);
    end
    Logic.SetTerritoryPlayerID(self.TerritoryID, self.PlayerID);
    self.InternTributeQuest.State = false;
    self.Time = nil;

    if self.DontPayCancels then
        _Quest:Interrupt();
    end
end

function B_Goal_TributeClaim:OnTributePaid(_Quest)
    local Outpost = Logic.GetTerritoryAcquiringBuildingID(self.TerritoryID);
    if self.InternTributeQuest.Result == QuestResult.Success then
        if Logic.GetTerritoryPlayerID(self.TerritoryID) == self.PlayerID then
            if IsExisting(Outpost) then
                Logic.ChangeEntityPlayerID(Outpost, _Quest.ReceivingPlayer);
            end
            Logic.SetTerritoryPlayerID(self.TerritoryID, _Quest.ReceivingPlayer);
        end
    end
    if self.Time and Logic.GetTime() >= self.Time + self.PeriodLength then
        if self.HowOften and self.HowOften ~= 0 then
            self.TributeCounter = (self.TributeCounter or 0) +1;
            if self.TributeCounter >= self.HowOften then
                return false;
            end
        end
        self:RestartTributeQuest();
        self.Time = nil;
    end
end

function B_Goal_TributeClaim:CustomFunction(_Quest)
    self:CreateTributeQuest(_Quest);
    self:CureOutpost(_Quest);

    if Logic.GetTerritoryPlayerID(self.TerritoryID) == _Quest.ReceivingPlayer
    or Logic.GetTerritoryPlayerID(self.TerritoryID) == self.PlayerID then
        if self.OtherOwner then
            self:RestartTributeQuest();
            self.OtherOwner = nil;
        end

        -- Quest abgeschlossen
        if self.InternTributeQuest.State == QuestState.Over then
            if self.InternTributeQuest.Result == QuestResult.Failure then
                self:OnTributeFailed(_Quest);
            else
                self:OnTributePaid(_Quest);
            end

        elseif self.InternTributeQuest.State == false then
            if self.Time and Logic.GetTime() >= self.Time + self.PeriodLength then
                self:RestartTributeQuest(_Quest);
            end
        end

    -- Keiner besitzt das Territorium -> Abbruch
    elseif Logic.GetTerritoryPlayerID(self.TerritoryID) == 0 and self.InternTributeQuest then
        if self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end

    -- Anderer Besitzer -> Abbruch
    elseif Logic.GetTerritoryPlayerID(self.TerritoryID) ~= self.PlayerID then
        if self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end
        if self.OtherOwnerCancels then
            _Quest:Interrupt();
        end
        self.OtherOwner = true;
    end

    --Fordernder Spieler existiert nicht -> Abbruch
    local storeHouse = Logic.GetStoreHouse(self.PlayerID);
    if (storeHouse == 0 or Logic.IsEntityDestroyed(storeHouse)) then
        if self.InternTributeQuest and self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end
        return true;
    end
end

function B_Goal_TributeClaim:Debug(_Quest)
    if self.TerritoryID == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Unknown Territory");
        return true;
    end
    if not self.Quest and Logic.GetStoreHouse(self.PlayerID) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.PlayerID .. " is dead. :-(");
        return true;
    end
    if self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount is negative");
        return true;
    end
    if self.PeriodLength < self.TributTime or self.PeriodLength < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Period Length is wrong");
        return true;
    end
    if self.HowOften < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": HowOften is negative");
        return true;
    end
end

function B_Goal_TributeClaim:Reset(_Quest)
    self.InternTributeQuest = nil;
    self.Time = nil;
    self.OtherOwner = nil;
end

function B_Goal_TributeClaim:Interrupt(_Quest)
    if type(self.InternTributeQuest) == "table" then
        if self.InternTributeQuest.State == QuestState.Active then
            self.InternTributeQuest:Interrupt();
        end
    end
end

function B_Goal_TributeClaim:GetCustomData(_Index)
    if (_Index == 9) or (_Index == 10) then
        return {"false", "true"};
    end
end

Revision:RegisterBehavior(B_Goal_TributeClaim);

-- -------------------------------------------------------------------------- --
-- REPRISALS

---
-- Deaktiviert ein interaktives Objekt.
--
-- @param _ScriptName Skriptname des interaktiven Objektes
--
-- @within Reprisal
--
function Reprisal_ObjectDeactivate(...)
    return B_Reprisal_InteractiveObjectDeactivate:new(...);
end

B_Reprisal_InteractiveObjectDeactivate = {
    Name = "Reprisal_InteractiveObjectDeactivate",
    Description = {
        en = "Reprisal: Deactivates an interactive object",
        de = "Vergeltung: Deaktiviert ein interaktives Objekt",
        fr = "Rétribution: désactive un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object", de = "Interaktives Objekt", fr = "Object interactif" },
    },
}

function B_Reprisal_InteractiveObjectDeactivate:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_InteractiveObjectDeactivate:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.ScriptName = _Parameter
    end

end

function B_Reprisal_InteractiveObjectDeactivate:CustomFunction(_Quest)
    InteractiveObjectDeactivate(self.ScriptName);
end

function B_Reprisal_InteractiveObjectDeactivate:Debug(_Quest)
    if not Logic.IsInteractiveObject(GetID(self.ScriptName)) then
        warn(_Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' is not a interactive object!");
        self.WarningPrinted = true;
    end
    local eID = GetID(self.ScriptName);
    if QSB.InitalizedObjekts[eID] and QSB.InitalizedObjekts[eID] == _Quest.Identifier then
        error(_Quest.Identifier.. ": " ..self.Name..": you can not deactivate in the same quest the object is initalized!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_InteractiveObjectDeactivate);

-- -------------------------------------------------------------------------- --

---
-- Aktiviert ein interaktives Objekt.
--
-- Der Status bestimmt, wie das Objekt aktiviert wird.
-- <ul>
-- <li>0: Kann nur mit Helden aktiviert werden</li>
-- <li>1: Kann immer aktiviert werden</li>
-- <li>2: Kann niemals aktiviert werden</li>
-- </ul>
--
-- @param _ScriptName Skriptname des interaktiven Objektes
-- @param _State      Status des Objektes
--
-- @within Reprisal
--
function Reprisal_ObjectActivate(...)
    return B_Reprisal_InteractiveObjectActivate:new(...);
end

B_Reprisal_InteractiveObjectActivate = {
    Name = "Reprisal_InteractiveObjectActivate",
    Description = {
        en = "Reprisal: Activates an interactive object",
        de = "Vergeltung: Aktiviert ein interaktives Objekt",
        fr = "Retribution : active un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object",  de = "Interaktives Objekt", fr = "Object interactif" },
        { ParameterType.Custom,     en = "Availability",        de = "Nutzbarkeit",         fr = "Utilisabilité" },
    },
}

function B_Reprisal_InteractiveObjectActivate:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_InteractiveObjectActivate:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        local parameter = 0
        if _Parameter == "Always" or 1 then
            parameter = 1
        end
        self.UsingState = parameter * 1
    end
end

function B_Reprisal_InteractiveObjectActivate:CustomFunction(_Quest)
    InteractiveObjectActivate(self.ScriptName, self.UsingState);
end

function B_Reprisal_InteractiveObjectActivate:GetCustomData( _Index )
    if _Index == 1 then
        return {"Knight only", "Always"}
    end
end

function B_Reprisal_InteractiveObjectActivate:Debug(_Quest)
    if not Logic.IsInteractiveObject(GetID(self.ScriptName)) then
        warn(_Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' is not a interactive object!");
        self.WarningPrinted = true;
    end
    local eID = GetID(self.ScriptName);
    if QSB.InitalizedObjekts[eID] and QSB.InitalizedObjekts[eID] == _Quest.Identifier then
        error(_Quest.Identifier.. ": " ..self.Name..": you can not activate in the same quest the object is initalized!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_InteractiveObjectActivate);

-- -------------------------------------------------------------------------- --

---
-- Der diplomatische Status zwischen Sender und Empfänger verschlechtert sich
-- um eine Stufe.
--
-- @within Reprisal
--
function Reprisal_DiplomacyDecrease()
    return B_Reprisal_SlightlyDiplomacyDecrease:new();
end

B_Reprisal_SlightlyDiplomacyDecrease = {
    Name = "Reprisal_SlightlyDiplomacyDecrease",
    Description = {
        en = "Reprisal: Diplomacy decreases slightly to another player.",
        de = "Vergeltung: Der Diplomatiestatus zum Auftraggeber wird um eine Stufe verringert.",
        fr = "Rétribution: le statut diplomatique avec le mandant est réduit d'un niveau.",
    },
}

function B_Reprisal_SlightlyDiplomacyDecrease:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_SlightlyDiplomacyDecrease:CustomFunction(_Quest)
    local Sender = _Quest.SendingPlayer;
    local Receiver = _Quest.ReceivingPlayer;
    local State = GetDiplomacyState(Receiver, Sender);
    if State > -2 then
        SetDiplomacyState(Receiver, Sender, State-1);
    end
end

function B_Reprisal_SlightlyDiplomacyDecrease:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

Revision:RegisterBehavior(B_Reprisal_SlightlyDiplomacyDecrease);

-- -------------------------------------------------------------------------- --

---
-- Änder den Diplomatiestatus zwischen zwei Spielern.
--
-- @param _Party1   ID der ersten Partei
-- @param _Party2   ID der zweiten Partei
-- @param _State    Neuer Diplomatiestatus
--
-- @within Reprisal
--
function Reprisal_Diplomacy(...)
    return B_Reprisal_Diplomacy:new(...);
end

B_Reprisal_Diplomacy = {
    Name = "Reprisal_Diplomacy",
    Description = {
        en = "Reprisal: Sets Diplomacy state of two Players to a stated value.",
        de = "Vergeltung: Setzt den Diplomatiestatus zweier Spieler auf den angegebenen Wert.",
        fr = "Rétribution: Définit le statut diplomatique de deux joueurs sur la valeur indiquée.",
    },
    Parameter = {
        { ParameterType.PlayerID,         en = "PlayerID 1", de = "Spieler 1", fr = "Joueur 1" },
        { ParameterType.PlayerID,         en = "PlayerID 2", de = "Spieler 2", fr = "Joueur 2" },
        { ParameterType.DiplomacyState,   en = "Relation",   de = "Beziehung", fr = "Relation diplomatique" },
    },
}

function B_Reprisal_Diplomacy:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_Diplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID1 = _Parameter * 1
    elseif (_Index == 1) then
        self.PlayerID2 = _Parameter * 1
    elseif (_Index == 2) then
        self.Relation = DiplomacyStates[_Parameter]
    end
end

function B_Reprisal_Diplomacy:CustomFunction(_Quest)
    SetDiplomacyState(self.PlayerID1, self.PlayerID2, self.Relation);
end

function B_Reprisal_Diplomacy:Debug(_Quest)
    if not tonumber(self.PlayerID1) or self.PlayerID1 < 1 or self.PlayerID1 > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": PlayerID 1 is invalid!");
        return true;
    elseif not tonumber(self.PlayerID2) or self.PlayerID2 < 1 or self.PlayerID2 > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": PlayerID 2 is invalid!");
        return true;
    elseif not tonumber(self.Relation) or self.Relation < -2 or self.Relation > 2 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": '"..self.Relation.."' is a invalid diplomacy state!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_Diplomacy);

-- -------------------------------------------------------------------------- --

---
-- Ein benanntes Entity wird entfernt.
--
-- <b>Hinweis</b>: Das Entity wird durch ein XD_ScriptEntity ersetzt. Es
-- behält Name, Besitzer und Ausrichtung.
--
-- @param _ScriptName Skriptname des Entity
--
-- @within Reprisal
--
function Reprisal_DestroyEntity(...)
    return B_Reprisal_DestroyEntity:new(...);
end

B_Reprisal_DestroyEntity = {
    Name = "Reprisal_DestroyEntity",
    Description = {
        en = "Reprisal: Replaces an entity with an invisible script entity, which retains the entities name.",
        de = "Vergeltung: Ersetzt eine Entity mit einer unsichtbaren Script-Entity, die den Namen übernimmt.",
        fr = "Rétribution: remplace une entité par une entité de script invisible qui prend son nom.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity", de = "Entity", fr = "Entité" },
    },
}

function B_Reprisal_DestroyEntity:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_DestroyEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Reprisal_DestroyEntity:CustomFunction(_Quest)
    ReplaceEntity(self.ScriptName, Entities.XD_ScriptEntity);
end

function B_Reprisal_DestroyEntity:Debug(_Quest)
    if not IsExisting(self.ScriptName) then
        warn(_Quest.Identifier .. ": " ..self.Name..": '" ..self.ScriptName.. "' is already destroyed!");
        self.WarningPrinted = true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_DestroyEntity);

-- -------------------------------------------------------------------------- --

---
-- Zerstört einen über ein Behavior erzeugten Effekt.
--
-- @param _EffectName Name des Effekts
--
-- @within Reprisal
--
function Reprisal_DestroyEffect(...)
    return B_Reprisal_DestroyEffect:new(...);
end

B_Reprisal_DestroyEffect = {
    Name = "Reprisal_DestroyEffect",
    Description = {
        en = "Reprisal: Destroys an effect",
        de = "Vergeltung: Zerstört einen Effekt",
        fr = "Rétribution: détruit un effet",
    },
    Parameter = {
        { ParameterType.Default, en = "Effect name", de = "Effektname", fr = "Nom de l'effet" },
    }
}

function B_Reprisal_DestroyEffect:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.EffectName = _Parameter;
    end
end

function B_Reprisal_DestroyEffect:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } };
end

function B_Reprisal_DestroyEffect:CustomFunction(_Quest)
    if not QSB.EffectNameToID[self.EffectName] or not Logic.IsEffectRegistered(QSB.EffectNameToID[self.EffectName]) then
        return;
    end
    Logic.DestroyEffect(QSB.EffectNameToID[self.EffectName]);
end

function B_Reprisal_DestroyEffect:Debug(_Quest)
    if not QSB.EffectNameToID[self.EffectName] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Effect " .. self.EffectName .. " never created")
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_DestroyEffect);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler verliert das Spiel.
--
-- @within Reprisal
--
function Reprisal_Defeat()
    return B_Reprisal_Defeat:new()
end

B_Reprisal_Defeat = {
    Name = "Reprisal_Defeat",
    Description = {
        en = "Reprisal: The player loses the game.",
        de = "Vergeltung: Der Spieler verliert das Spiel.",
        fr = "Rétribution: le joueur perd la partie.",
    },
}

function B_Reprisal_Defeat:GetReprisalTable()
    return {Reprisal.Defeat};
end

Revision:RegisterBehavior(B_Reprisal_Defeat);

-- -------------------------------------------------------------------------- --

---
-- Zeigt die Niederlagedekoration am Quest an.
--
-- Es handelt sich dabei um reine Optik! Der Spieler wird nicht verlieren.
--
-- @within Reprisal
--
function Reprisal_FakeDefeat()
    return B_Reprisal_FakeDefeat:new();
end

B_Reprisal_FakeDefeat = {
    Name = "Reprisal_FakeDefeat",
    Description = {
        en = "Reprisal: Displays a defeat icon for a quest",
        de = "Vergeltung: Zeigt ein Niederlage Icon fuer eine Quest an",
        fr = "Rétribution: affiche une icône de défaite pour une quête",
    },
}

function B_Reprisal_FakeDefeat:GetReprisalTable()
    return { Reprisal.FakeDefeat }
end

Revision:RegisterBehavior(B_Reprisal_FakeDefeat);

-- -------------------------------------------------------------------------- --

---
-- Ein Entity wird durch ein neues anderen Typs ersetzt.
--
-- Das neue Entity übernimmt Skriptname, Besitzer  und Ausrichtung des 
-- alten Entity.
--
-- @param _Entity Skriptname oder ID des Entity
-- @param _Type   Neuer Typ des Entity
-- @param _Owner  Besitzer des Entity
--
-- @within Reprisal
--
function Reprisal_ReplaceEntity(...)
    return B_Reprisal_ReplaceEntity:new(...);
end

B_Reprisal_ReplaceEntity = {
    Name = "Reprisal_ReplaceEntity",
    Description = {
        en = "Reprisal: Replaces an entity with a new one of a different type. The playerID can be changed too.",
        de = "Vergeltung: Ersetzt eine Entity durch eine neue anderen Typs. Es kann auch die Spielerzugehörigkeit geändert werden.",
        fr = "Rétribution: remplace une entité par une nouvelle entité d'un autre type. Il est également possible de changer l'appartenance d'un joueur.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target", de = "Ziel", fr = "Cible" },
        { ParameterType.Custom, en = "New Type", de = "Neuer Typ", fr = "Nouveau type" },
        { ParameterType.Custom, en = "New playerID", de = "Neue Spieler ID", fr = "Nouvelle ID de joueur" },
    },
}

function B_Reprisal_ReplaceEntity:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_ReplaceEntity:AddParameter(_Index, _Parameter)
   if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.NewType = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = tonumber(_Parameter);
    end
end

function B_Reprisal_ReplaceEntity:CustomFunction(_Quest)
    local eID = GetID(self.ScriptName);
    local pID = self.PlayerID;
    if pID == Logic.EntityGetPlayer(eID) then
        pID = nil;
    end
    ReplaceEntity(self.ScriptName, Entities[self.NewType], pID);
end

function B_Reprisal_ReplaceEntity:GetCustomData(_Index)
    local Data = {}
    if _Index == 1 then
        for k, v in pairs( Entities ) do
            local name = {"^M_","^XS_","^X_","^XT_","^Z_", "^XB_"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        Data = {"-","0","1","2","3","4","5","6","7","8",}
    end
    return Data
end

function B_Reprisal_ReplaceEntity:Debug(_Quest)
    if not Entities[self.NewType] then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid entity type!");
        return true;
    elseif self.PlayerID ~= nil and (self.PlayerID < 1 or self.PlayerID > 8) then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end

    if not IsExisting(self.ScriptName) then
        self.WarningPrinted = true;
        warn(_Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' does not exist!");
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_ReplaceEntity);

-- -------------------------------------------------------------------------- --

---
-- Startet einen Quest neu.
--
-- @param _QuestName Name des Quest
--
-- @within Reprisal
--
function Reprisal_QuestRestart(...)
    return B_Reprisal_QuestRestart:new(...)
end

B_Reprisal_QuestRestart = {
    Name = "Reprisal_QuestRestart",
    Description = {
        en = "Reprisal: Restarts a (completed) quest so it can be triggered and completed again",
        de = "Vergeltung: Startet eine (beendete) Quest neu, damit diese neu ausgelöst und beendet werden kann",
        fr = "Rétribution : relance une quête (terminée) pour qu'elle puisse être redéclenchée et terminée à nouveau",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestRestart:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestRestart:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestRestart:CustomFunction(_Quest)
    API.RestartQuest(self.QuestName, true);
end

function B_Reprisal_QuestRestart:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestRestart);

-- -------------------------------------------------------------------------- --

---
-- Lässt einen Quest fehlschlagen.
--
-- @param _QuestName Name des Quest
--
-- @within Reprisal
--
function Reprisal_QuestFailure(...)
    return B_Reprisal_QuestFailure:new(...)
end

B_Reprisal_QuestFailure = {
    Name = "Reprisal_QuestFailure",
    Description = {
        en = "Reprisal: Lets another active quest fail",
        de = "Vergeltung: Lässt eine andere aktive Quest fehlschlagen",
        fr = "Rétribution: fait échouer une autre quête active",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestFailure:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestFailure:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestFailure:CustomFunction(_Quest)
    API.FailQuest(self.QuestName, true);
end

function B_Reprisal_QuestFailure:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid quest!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestFailure);

-- -------------------------------------------------------------------------- --

---
-- Wertet einen Quest als erfolgreich.
--
-- @param _QuestName Name des Quest
--
-- @within Reprisal
--
function Reprisal_QuestSuccess(...)
    return B_Reprisal_QuestSuccess:new(...)
end

B_Reprisal_QuestSuccess = {
    Name = "Reprisal_QuestSuccess",
    Description = {
        en = "Reprisal: Completes another active quest successfully",
        de = "Vergeltung: Beendet eine andere aktive Quest erfolgreich",
        fr = "Rétribution: Réussir une autre quête active",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestSuccess:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestSuccess:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestSuccess:CustomFunction(_Quest)
    API.WinQuest(self.QuestName, true);
end

function B_Reprisal_QuestSuccess:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestSuccess);

-- -------------------------------------------------------------------------- --

---
-- Triggert einen Quest.
--
-- @param _QuestName Name des Quest
--
-- @within Reprisal
--
function Reprisal_QuestActivate(...)
    return B_Reprisal_QuestActivate:new(...)
end

B_Reprisal_QuestActivate = {
    Name = "Reprisal_QuestActivate",
    Description = {
        en = "Reprisal: Activates another quest that is not triggered yet.",
        de = "Vergeltung: Aktiviert eine andere Quest die noch nicht ausgelöst wurde.",
        fr = "Rétribution: Active une autre quête qui n'a pas encore été déclenchée.",
    },
    Parameter = {
        {ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête", },
    },
}

function B_Reprisal_QuestActivate:GetReprisalTable()
    return {Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_QuestActivate:AddParameter(_Index, _Parameter)
    if (_Index==0) then
        self.QuestName = _Parameter
    else
        assert(false, "Error in " .. self.Name .. ": AddParameter: Index is invalid")
    end
end

function B_Reprisal_QuestActivate:CustomFunction(_Quest)
    API.StartQuest(self.QuestName, true);
end

function B_Reprisal_QuestActivate:Debug(_Quest)
    if not IsValidQuest(self.QuestName) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Quest: "..  self.QuestName .. " does not exist");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestActivate)

-- -------------------------------------------------------------------------- --

---
-- Unterbricht einen Quest.
--
-- @param _QuestName Name des Quest
--
-- @within Reprisal
--
function Reprisal_QuestInterrupt(...)
    return B_Reprisal_QuestInterrupt:new(...)
end

B_Reprisal_QuestInterrupt = {
    Name = "Reprisal_QuestInterrupt",
    Description = {
        en = "Reprisal: Interrupts another active quest without success or failure",
        de = "Vergeltung: Beendet eine andere aktive Quest ohne Erfolg oder Misserfolg",
        fr = "Rétribution : termine une autre quête active sans succès ni échec",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestInterrupt:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestInterrupt:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestInterrupt:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then

        local QuestID = GetQuestID(self.QuestName)
        local Quest = Quests[QuestID]
        if Quest.State == QuestState.Active then
            API.StopQuest(self.QuestName, true);
        end
    end
end

function B_Reprisal_QuestInterrupt:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestInterrupt);

-- -------------------------------------------------------------------------- --

---
-- Unterbricht einen Quest, selbst wenn dieser noch nicht ausgelöst wurde.
--
-- @param _QuestName   Name des Quest
-- @param _EndetQuests Bereits beendete unterbrechen
--
-- @within Reprisal
--
function Reprisal_QuestForceInterrupt(...)
    return B_Reprisal_QuestForceInterrupt:new(...)
end

B_Reprisal_QuestForceInterrupt = {
    Name = "Reprisal_QuestForceInterrupt",
    Description = {
        en = "Reprisal: Interrupts another quest (even when it isn't active yet) without success or failure",
        de = "Vergeltung: Beendet eine andere Quest, auch wenn diese noch nicht aktiv ist ohne Erfolg oder Misserfolg",
        fr = "Rétribution: Termine une autre quête, même si elle n'est pas encore active, sans succès ni échec.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
        { ParameterType.Custom, en = "Ended quests", de = "Beendete Quests", fr = "Quêtes terminées" },
    },
}

function B_Reprisal_QuestForceInterrupt:GetReprisalTable()

    return { Reprisal.Custom,{self, self.CustomFunction} }

end

function B_Reprisal_QuestForceInterrupt:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.InterruptEnded = API.ToBoolean(_Parameter)
    end

end

function B_Reprisal_QuestForceInterrupt:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end
function B_Reprisal_QuestForceInterrupt:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then

        local QuestID = GetQuestID(self.QuestName)
        local Quest = Quests[QuestID]
        if self.InterruptEnded or Quest.State ~= QuestState.Over then
            Quest:Interrupt()
        end
    end
end

function B_Reprisal_QuestForceInterrupt:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_QuestForceInterrupt);

-- -------------------------------------------------------------------------- --

---
-- Ändert den Wert einer benutzerdefinierten Variable.
--
-- Benutzerdefinierte Variablen können ausschließlich Zahlen sein. Nutze
-- dieses Behavior bevor die Variable in einem Goal oder Trigger abgefragt
-- wird, um sie zu initialisieren!
--
-- <p>Operatoren</p>
-- <ul>
-- <li>= - Variablenwert wird auf den Wert gesetzt</li>
-- <li>- - Variablenwert mit Wert Subtrahieren</li>
-- <li>+ - Variablenwert mit Wert addieren</li>
-- <li>* - Variablenwert mit Wert multiplizieren</li>
-- <li>/ - Variablenwert mit Wert dividieren</li>
-- <li>^ - Variablenwert mit Wert potenzieren</li>
-- </ul>
--
-- @param _Name     Name der Variable
-- @param _Operator Rechen- oder Zuweisungsoperator
-- @param _Value    Wert oder andere Custom Variable
--
-- @within Reprisal
--
function Reprisal_CustomVariables(...)
    return B_Reprisal_CustomVariables:new(...);
end

B_Reprisal_CustomVariables = {
    Name = "Reprisal_CustomVariables",
    Description = {
        en = "Reprisal: Executes a mathematical operation with this variable. The other operand can be a number or another custom variable.",
        de = "Vergeltung: Führt eine mathematische Operation mit der Variable aus. Der andere Operand kann eine Zahl oder eine Custom-Varible sein.",
        fr = "Rétribution: effectue une opération mathématique sur la variable. L'autre opérateur peut être un nombre ou une variable personnalisée.",
    },
    Parameter = {
        { ParameterType.Default, en = "Name of variable", de = "Variablenname", fr = "Nom de la variable" },
        { ParameterType.Custom,  en = "Operator", de = "Operator", fr = "Operateur" },
        { ParameterType.Default,  en = "Value or variable", de = "Wert oder Variable", fr = "Valeur ou variable" }
    }
};

function B_Reprisal_CustomVariables:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Operator = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        self.Value = (value == nil and tostring(_Parameter)) or value;
    end
end

function B_Reprisal_CustomVariables:CustomFunction()
    local Value1 = API.ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = API.ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Operator == "=" then
        Value1 = Value2;
    elseif self.Operator == "+" then
        Value1 = Value1 + Value2;
    elseif self.Operator == "-" then
        Value1 = Value1 - Value2;
    elseif self.Operator == "*" then
        Value1 = Value1 * Value2;
    elseif self.Operator == "/" then
        Value1 = Value1 / Value2;
    elseif self.Operator == "^" then
        Value1 = Value1 % Value2;
    end
    API.SaveCustomVariable("BehaviorVariable_"..self.VariableName, Value1);
end

function B_Reprisal_CustomVariables:GetCustomData( _Index )
    return {"=", "+", "-", "*", "/", "^"};
end

function B_Reprisal_CustomVariables:Debug(_Quest)
    local operators = {"=", "+", "-", "*", "/", "^"};
    if not table.contains(operators, self.Operator) then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid operator!");
        return true;
    elseif self.VariableName == "" then
        error(_Quest.Identifier.. ": " ..self.Name..": missing name for variable!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_CustomVariables)

-- -------------------------------------------------------------------------- --

---
-- Führt eine Funktion im Skript als Reprisal aus.
--
-- Wird ein Funktionsname als String übergeben, wird die Funktion mit den
-- Daten des Behavors und des zugehörigen Quest aufgerufen (Standard).
--
-- Wird eine Funktionsreferenz angegeben, wird die Funktion zusammen mit allen
-- optionalen Parametern aufgerufen, als sei es ein gewöhnlicher Aufruf im
-- Skript.
-- <pre> Reprisal_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
-- -- entspricht: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
-- <b>Achtung:</b> Nicht über den Assistenten verfügbar!
--
-- @param _Function Name der Funktion oder Funktionsreferenz
--
-- @within Reprisal
--
function Reprisal_MapScriptFunction(...)
    return B_Reprisal_MapScriptFunction:new(...);
end

B_Reprisal_MapScriptFunction = {
    Name = "Reprisal_MapScriptFunction",
    Description = {
        en = "Reprisal: Calls a function within the global map script if the quest has failed.",
        de = "Vergeltung: Ruft eine Funktion im globalen Kartenskript auf, wenn die Quest fehlschlägt.",
        fr = "Rétribution: lance une fonction dans le script global de la carte en cas d'échec de la quête.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Reprisal_MapScriptFunction:GetReprisalTable()
    return {Reprisal.Custom, {self, self.CustomFunction}};
end

function B_Reprisal_MapScriptFunction:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.FuncName = _Parameter;
    end
end

function B_Reprisal_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        self.FuncName(unpack(self.i47ya_6aghw_frxil));
        return;
    end
    _G[self.FuncName](self, _Quest);
end

function B_Reprisal_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        error(_Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        error(_Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_MapScriptFunction);

-- -------------------------------------------------------------------------- --

---
-- Erlaubt oder verbietet einem Spieler ein Recht.
--
-- @param _PlayerID   ID des Spielers
-- @param _Lock       Sperren/Entsperren
-- @param _Technology Name des Rechts
--
-- @within Reprisal
--
function Reprisal_Technology(...)
    return B_Reprisal_Technology:new(...);
end

B_Reprisal_Technology = {
    Name = "Reprisal_Technology",
    Description = {
        en = "Reprisal: Locks or unlocks a technology for the given player",
        de = "Vergeltung: Sperrt oder erlaubt eine Technolgie fuer den angegebenen Player",
        fr = "Rétribution: bloque ou autorise une technologie pour le joueur spécifié",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "PlayerID", de = "SpielerID", fr = "PlayerID" },
        { ParameterType.Custom,   en = "Un / Lock", de = "Sperren/Erlauben", fr = "Bloquer/Autoriser" },
        { ParameterType.Custom,   en = "Technology", de = "Technologie"; fr = "Technologie" },
    },
}

function B_Reprisal_Technology:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_Technology:AddParameter(_Index, _Parameter)
    if (_Index ==0) then
        self.PlayerID = _Parameter*1
    elseif (_Index == 1) then
        self.LockType = _Parameter == "Lock"
    elseif (_Index == 2) then
        self.Technology = _Parameter
    end
end

function B_Reprisal_Technology:CustomFunction(_Quest)
    if self.PlayerID
    and Logic.GetStoreHouse(self.PlayerID) ~= 0
    and Technologies[self.Technology]
    then
        if self.LockType  then
            LockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        else
            UnLockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        end
    else
        return false
    end
end

function B_Reprisal_Technology:GetCustomData(_Index)
    local Data = {}
    if (_Index == 1) then
        Data[1] = "Lock"
        Data[2] = "UnLock"
    elseif (_Index == 2) then
        for k, v in pairs( Technologies ) do
            table.insert( Data, k )
        end
    end
    return Data
end

function B_Reprisal_Technology:Debug(_Quest)
    if not Technologies[self.Technology] then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid technology type!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_Technology);

-- -------------------------------------------------------------------------- --
-- REWARDS

---
-- Erlaubt oder verbietet einem Spieler ein Recht.
--
-- @param _PlayerID   ID des Spielers
-- @param _Lock       Sperren/Entsperren
-- @param _Technology Name des Rechts
--
-- @within Reprisal
--
function Reprisal_Technology(...)
    return B_Reprisal_Technology:new(...);
end

B_Reprisal_Technology = {
    Name = "Reprisal_Technology",
    Description = {
        en = "Reprisal: Locks or unlocks a technology for the given player",
        de = "Vergeltung: Sperrt oder erlaubt eine Technolgie fuer den angegebenen Player",
        fr = "Rétribution: bloque ou autorise une technologie pour le joueur spécifié",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "PlayerID",   de = "SpielerID",          fr = "PlayerID", },
        { ParameterType.Custom,   en = "Un / Lock",  de = "Sperren/Erlauben",   fr = "Bloquer/Autoriser", },
        { ParameterType.Custom,   en = "Technology", de = "Technologie",        fr = "Technologie" },
    },
}

function B_Reprisal_Technology:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_Technology:AddParameter(_Index, _Parameter)
    if (_Index ==0) then
        self.PlayerID = _Parameter*1
    elseif (_Index == 1) then
        self.LockType = _Parameter == "Lock"
    elseif (_Index == 2) then
        self.Technology = _Parameter
    end
end

function B_Reprisal_Technology:CustomFunction(_Quest)
    if self.PlayerID
    and Logic.GetStoreHouse(self.PlayerID) ~= 0
    and Technologies[self.Technology]
    then
        if self.LockType  then
            LockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        else
            UnLockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        end
    else
        return false
    end
end

function B_Reprisal_Technology:GetCustomData(_Index)
    local Data = {}
    if (_Index == 1) then
        Data[1] = "Lock"
        Data[2] = "UnLock"
    elseif (_Index == 2) then
        for k, v in pairs( Technologies ) do
            table.insert( Data, k )
        end
    end
    return Data
end

function B_Reprisal_Technology:Debug(_Quest)
    if not Technologies[self.Technology] then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid technology type!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reprisal_Technology);

-- -------------------------------------------------------------------------- --
-- Rewards                                                                    --
-- -------------------------------------------------------------------------- --

---
-- Deaktiviert ein interaktives Objekt
--
-- @param _ScriptName Skriptname des interaktiven Objektes
--
-- @within Reward
--
function Reward_ObjectDeactivate(...)
    return B_Reward_InteractiveObjectDeactivate:new(...);
end

B_Reward_InteractiveObjectDeactivate = Revision.LuaBase:CopyTable(B_Reprisal_InteractiveObjectDeactivate);
B_Reward_InteractiveObjectDeactivate.Name             = "Reward_InteractiveObjectDeactivate";
B_Reward_InteractiveObjectDeactivate.Description.en   = "Reward: Deactivates an interactive object";
B_Reward_InteractiveObjectDeactivate.Description.de   = "Lohn: Deaktiviert ein interaktives Objekt";
B_Reward_InteractiveObjectDeactivate.Description.fr   = "Récompense: Désactive un objet interactif";
B_Reward_InteractiveObjectDeactivate.GetReprisalTable = nil;

B_Reward_InteractiveObjectDeactivate.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_InteractiveObjectDeactivate);

-- -------------------------------------------------------------------------- --

---
-- Aktiviert ein interaktives Objekt.
--
-- Der Status bestimmt, wie das objekt aktiviert wird.
-- <ul>
-- <li>0: Kann nur mit Helden aktiviert werden</li>
-- <li>1: Kann immer aktiviert werden</li>
-- <li>2: Kann niemals aktiviert werden</li>
-- </ul>
--
-- @param _ScriptName Skriptname des interaktiven Objektes
-- @param _State Status des Objektes
--
-- @within Reward
--
function Reward_ObjectActivate(...)
    return B_Reward_InteractiveObjectActivate:new(...);
end

B_Reward_InteractiveObjectActivate = Revision.LuaBase:CopyTable(B_Reprisal_InteractiveObjectActivate);
B_Reward_InteractiveObjectActivate.Name             = "Reward_InteractiveObjectActivate";
B_Reward_InteractiveObjectActivate.Description.en   = "Reward: Activates an interactive object";
B_Reward_InteractiveObjectActivate.Description.de   = "Lohn: Aktiviert ein interaktives Objekt";
B_Reward_InteractiveObjectActivate.Description.fr   = "Récompense: Active un objet interactif";
B_Reward_InteractiveObjectActivate.GetReprisalTable = nil;

B_Reward_InteractiveObjectActivate.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} };
end

Revision:RegisterBehavior(B_Reward_InteractiveObjectActivate);

-- -------------------------------------------------------------------------- --

---
-- Initialisiert ein interaktives Objekt.
--
-- Interaktive Objekte können Kosten und Belohnungen enthalten, müssen sie
-- jedoch nicht. Ist eine Wartezeit angegeben, kann das Objekt erst nach
-- Ablauf eines Cooldowns benutzt werden.
--
-- @param _ScriptName Skriptname des interaktiven Objektes
-- @param _Distance   Entfernung zur Aktivierung
-- @param _Time       Wartezeit bis zur Aktivierung
-- @param _RType1     Warentyp der Belohnung
-- @param _RAmount    Menge der Belohnung
-- @param _CType1     Typ der 1. Ware
-- @param _CAmount1   Menge der 1. Ware
-- @param _CType2     Typ der 2. Ware
-- @param _CAmount2   Menge der 2. Ware
-- @param _Status     Aktivierung (0: Held, 1: immer, 2: niemals)
--
-- @within Reward
--
function Reward_ObjectInit(...)
    return B_Reward_ObjectInit:new(...);
end

B_Reward_ObjectInit = {
    Name = "Reward_ObjectInit",
    Description = {
        en = "Reward: Setup an interactive object with costs and rewards.",
        de = "Lohn: Initialisiert ein interaktives Objekt mit seinen Kosten und Schätzen.",
        fr = "Récompense: Initialise un objet interactif avec ses coûts et ses trésors.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object", de = "Interaktives Objekt",  fr = "Obejct interactif" },
        { ParameterType.Number,     en = "Distance to use",    de = "Nutzungsentfernung",   fr = "Distance d'utilisation" },
        { ParameterType.Number,     en = "Waittime",           de = "Wartezeit",            fr = "Temps d'attente" },
        { ParameterType.Custom,     en = "Reward good",        de = "Belohnungsware",       fr = "Produits de récompense" },
        { ParameterType.Number,     en = "Reward amount",      de = "Anzahl",               fr = "Quantité" },
        { ParameterType.Custom,     en = "Cost good 1",        de = "Kostenware 1",         fr = "Marchandise de coût 1" },
        { ParameterType.Number,     en = "Cost amount 1",      de = "Anzahl 1",             fr = "Quantité 1" },
        { ParameterType.Custom,     en = "Cost good 2",        de = "Kostenware 2",         fr = "Marchandise de coût 2" },
        { ParameterType.Number,     en = "Cost amount 2",      de = "Anzahl 2",             fr = "Quantité 2" },
        { ParameterType.Custom,     en = "Availability",       de = "Verfügbarkeit",        fr = "Disponibilité" },
    },
}

function B_Reward_ObjectInit:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_ObjectInit:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.Distance = _Parameter * 1
    elseif (_Index == 2) then
        self.Waittime = _Parameter * 1
    elseif (_Index == 3) then
        self.RewardType = _Parameter
    elseif (_Index == 4) then
        self.RewardAmount = _Parameter * 1
    elseif (_Index == 5) then
        self.FirstCostType = _Parameter
    elseif (_Index == 6) then
        self.FirstCostAmount = _Parameter * 1
    elseif (_Index == 7) then
        self.SecondCostType = _Parameter
    elseif (_Index == 8) then
        self.SecondCostAmount = _Parameter * 1
    elseif (_Index == 9) then
        local parameter = nil
        if _Parameter == "Always" or _Parameter == 1 then
            parameter = 1
        elseif _Parameter == "Never" or _Parameter == 2 then
            parameter = 2
        elseif _Parameter == "Knight only" or _Parameter == 0 then
            parameter = 0
        end
        self.UsingState = parameter
    end
end

function B_Reward_ObjectInit:CustomFunction(_Quest)
    local eID = GetID(self.ScriptName);
    if eID == 0 then
        return;
    end
    QSB.InitalizedObjekts[eID] = _Quest.Identifier;

    Logic.InteractiveObjectClearCosts(eID);
    Logic.InteractiveObjectClearRewards(eID);

    Logic.InteractiveObjectSetInteractionDistance(eID, self.Distance);
    Logic.InteractiveObjectSetTimeToOpen(eID, self.Waittime);

    if self.RewardType and self.RewardType ~= "-" then
        Logic.InteractiveObjectAddRewards(eID, Goods[self.RewardType], self.RewardAmount);
    end
    if self.FirstCostType and self.FirstCostType ~= "-" then
        Logic.InteractiveObjectAddCosts(eID, Goods[self.FirstCostType], self.FirstCostAmount);
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        Logic.InteractiveObjectAddCosts(eID, Goods[self.SecondCostType], self.SecondCostAmount);
    end

    Logic.InteractiveObjectSetAvailability(eID,true);
    if self.UsingState then
        for i=1, 8 do
            Logic.InteractiveObjectSetPlayerState(eID,i, self.UsingState);
        end
    end

    Logic.InteractiveObjectSetRewardResourceCartType(eID,Entities.U_ResourceMerchant);
    Logic.InteractiveObjectSetRewardGoldCartType(eID,Entities.U_GoldCart);
    Logic.InteractiveObjectSetCostResourceCartType(eID,Entities.U_ResourceMerchant);
    Logic.InteractiveObjectSetCostGoldCartType(eID, Entities.U_GoldCart);
    RemoveInteractiveObjectFromOpenedList(eID);
    table.insert(HiddenTreasures,eID);
end

function B_Reward_ObjectInit:GetCustomData( _Index )
    if _Index == 3 or _Index == 5 or _Index == 7 then
        local Data = {
            "-",
            "G_Beer",
            "G_Bread",
            "G_Broom",
            "G_Carcass",
            "G_Cheese",
            "G_Clothes",
            "G_Dye",
            "G_Gold",
            "G_Grain",
            "G_Herb",
            "G_Honeycomb",
            "G_Iron",
            "G_Leather",
            "G_Medicine",
            "G_Milk",
            "G_RawFish",
            "G_Salt",
            "G_Sausage",
            "G_SmokedFish",
            "G_Soap",
            "G_Stone",
            "G_Water",
            "G_Wood",
            "G_Wool",
        }

        if g_GameExtraNo >= 1 then
            Data[#Data+1] = "G_Gems"
            Data[#Data+1] = "G_MusicalInstrument"
            Data[#Data+1] = "G_Olibanum"
        end
        return Data
    elseif _Index == 9 then
        return {"-", "Knight only", "Always", "Never",}
    end
end

function B_Reward_ObjectInit:Debug(_Quest)
    if Logic.IsInteractiveObject(GetID(self.ScriptName)) == false then
        error(_Quest.Identifier.. ": " ..self.Name..": '"..self.ScriptName.."' is not a interactive object!");
        return true;
    end
    if self.UsingState ~= 1 and self.Distance < 50 then
        warn(_Quest.Identifier.. ": " ..self.Name..": distance is maybe too short!");
    end
    if self.Waittime < 0 then
        error(_Quest.Identifier.. ": " ..self.Name..": waittime must be equal or greater than 0!");
        return true;
    end
    if self.RewardType and self.RewardType ~= "-" then
        if not Goods[self.RewardType] then
            error(_Quest.Identifier.. ": " ..self.Name..": '"..self.RewardType.."' is invalid good type!");
            return true;
        elseif self.RewardAmount < 1 then
            error(_Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    if self.FirstCostType and self.FirstCostType ~= "-" then
        if not Goods[self.FirstCostType] then
            error(_Quest.Identifier.. ": " ..self.Name..": '"..self.FirstCostType.."' is invalid good type!");
            return true;
        elseif self.FirstCostAmount < 1 then
            error(_Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        if not Goods[self.SecondCostType] then
            error(_Quest.Identifier.. ": " ..self.Name..": '"..self.SecondCostType.."' is invalid good type!");
            return true;
        elseif self.SecondCostAmount < 1 then
            error(_Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_ObjectInit);

-- -------------------------------------------------------------------------- --

---
-- Änder den Diplomatiestatus zwischen zwei Spielern.
--
-- @param _Party1   ID der ersten Partei
-- @param _Party2   ID der zweiten Partei
-- @param _State    Neuer Diplomatiestatus
--
-- @within Reward
--
function Reward_Diplomacy(...)
    return B_Reward_Diplomacy:new(...);
end

B_Reward_Diplomacy = Revision.LuaBase:CopyTable(B_Reprisal_Diplomacy);
B_Reward_Diplomacy.Name             = "Reward_Diplomacy";
B_Reward_Diplomacy.Description.en   = "Reward: Sets Diplomacy state of two Players to a stated value.";
B_Reward_Diplomacy.Description.de   = "Lohn: Setzt den Diplomatiestatus zweier Spieler auf den angegebenen Wert.";
B_Reward_Diplomacy.Description.fr   = "Récompense: Définit le statut diplomatique de deux joueurs sur la valeur indiquée.";
B_Reward_Diplomacy.GetReprisalTable = nil;

B_Reward_Diplomacy.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_Diplomacy);

-- -------------------------------------------------------------------------- --

---
-- Verbessert die diplomatischen Beziehungen zwischen Sender und Empfänger
-- um einen Grad.
--
-- @within Reward
--
function Reward_DiplomacyIncrease()
    return B_Reward_SlightlyDiplomacyIncrease:new();
end

B_Reward_SlightlyDiplomacyIncrease = {
    Name = "Reward_SlightlyDiplomacyIncrease",
    Description = {
        en = "Reward: Diplomacy increases slightly to another player",
        de = "Lohn: Verbesserung des Diplomatiestatus zu einem anderen Spieler",
        fr = "Récompense: Amélioration du statut diplomatique avec un autre joueur",
    },
}

function B_Reward_SlightlyDiplomacyIncrease:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SlightlyDiplomacyIncrease:CustomFunction(_Quest)
    local Sender = _Quest.SendingPlayer;
    local Receiver = _Quest.ReceivingPlayer;
    local State = GetDiplomacyState(Receiver, Sender);
    if State < 2 then
        SetDiplomacyState(Receiver, Sender, State+1);
    end
end

function B_Reward_SlightlyDiplomacyIncrease:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

Revision:RegisterBehavior(B_Reward_SlightlyDiplomacyIncrease);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt Handelsangebote im Lagerhaus des angegebenen Spielers.
--
-- Sollen Angebote gelöscht werden, muss "-" als Ware ausgewählt werden.
--
-- <b>Achtung:</b> Stadtlagerhäuser können keine Söldner anbieten!
--
-- @param _PlayerID Partei, die Anbietet
-- @param _Amount1  Menge des 1. Angebot
-- @param _Type1    Ware oder Typ des 1. Angebot
-- @param _Amount2  Menge des 2. Angebot
-- @param _Type2    Ware oder Typ des 2. Angebot
-- @param _Amount3  Menge des 3. Angebot
-- @param _Type3    Ware oder Typ des 3. Angebot
-- @param _Amount4  Menge des 4. Angebot
-- @param _Type4    Ware oder Typ des 4. Angebot
--
-- @within Reward
--
function Reward_TradeOffers(...)
    return B_Reward_Merchant:new(...);
end

B_Reward_Merchant = {
    Name = "Reward_Merchant",
    Description = {
        en = "Reward: Deletes all existing offers for a merchant and sets new offers, if given",
        de = "Lohn: Löscht alle Angebote eines Händlers und setzt neue, wenn angegeben",
        fr = "Récompense: Supprime toutes les offres d'un commerçant et en place de nouvelles si elles sont indiquées.",
    },
    Parameter = {
        { ParameterType.Custom, en = "PlayerID", de = "PlayerID",  fr = "PlayerID" },
        { ParameterType.Custom, en = "Amount 1", de = "Menge 1",   fr = "Quantité 1" },
        { ParameterType.Custom, en = "Offer 1",  de = "Angebot 1", fr = "Offre 1" },
        { ParameterType.Custom, en = "Amount 2", de = "Menge 2",   fr = "Quantité 2" },
        { ParameterType.Custom, en = "Offer 2",  de = "Angebot 2", fr = "Offre 2" },
        { ParameterType.Custom, en = "Amount 3", de = "Menge 3",   fr = "Quantité 3" },
        { ParameterType.Custom, en = "Offer 3",  de = "Angebot 3", fr = "Offr 3e" },
        { ParameterType.Custom, en = "Amount 4", de = "Menge 4",   fr = "Quantité 4" },
        { ParameterType.Custom, en = "Offer 4",  de = "Angebot 4", fr = "Offre 4" },
    },
}

function B_Reward_Merchant:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_Merchant:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 1) then
        _Parameter = _Parameter or 0;
        self.AmountOffer1 = _Parameter * 1;
    elseif (_Index == 2) then
        self.Offer1 = _Parameter
    elseif (_Index == 3) then
        _Parameter = _Parameter or 0;
        self.AmountOffer2 = _Parameter * 1;
    elseif (_Index == 4) then
        self.Offer2 = _Parameter
    elseif (_Index == 5) then
        _Parameter = _Parameter or 0;
        self.AmountOffer3 = _Parameter * 1;
    elseif (_Index == 6) then
        self.Offer3 = _Parameter
    elseif (_Index == 7) then
        _Parameter = _Parameter or 0;
        self.AmountOffer4 = _Parameter * 1;
    elseif (_Index == 8) then
        self.Offer4 = _Parameter
    end
end

function B_Reward_Merchant:CustomFunction()
    if (self.PlayerID > 1) and (self.PlayerID < 9) then
        local Storehouse = Logic.GetStoreHouse(self.PlayerID)
        Logic.RemoveAllOffers(Storehouse)
        for i =  1,4 do
            if self["Offer"..i] and self["Offer"..i] ~= "-" then
                if Goods[self["Offer"..i]] then
                    AddOffer(Storehouse, self["AmountOffer"..i], Goods[self["Offer"..i]])
                elseif Logic.IsEntityTypeInCategory(Entities[self["Offer"..i]], EntityCategories.Military) == 1 then
                    AddMercenaryOffer(Storehouse, self["AmountOffer"..i], Entities[self["Offer"..i]])
                else
                    AddEntertainerOffer (Storehouse , Entities[self["Offer"..i]])
                end
            end
        end
    end
end

function B_Reward_Merchant:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID ) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.PlayerID .. " is dead. :-(")
        return true
    end
end

function B_Reward_Merchant:GetCustomData(_Index)
    local Players = { 1,2,3,4,5,6,7,8 }
    local Amount = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local Offers = {"-",
                    "G_Beer",
                    "G_Bow",
                    "G_Bread",
                    "G_Broom",
                    "G_Candle",
                    "G_Carcass",
                    "G_Cheese",
                    "G_Clothes",
                    "G_Cow",
                    "G_Grain",
                    "G_Herb",
                    "G_Honeycomb",
                    "G_Iron",
                    "G_Leather",
                    "G_Medicine",
                    "G_Milk",
                    "G_RawFish",
                    "G_Sausage",
                    "G_Sheep",
                    "G_SmokedFish",
                    "G_Soap",
                    "G_Stone",
                    "G_Sword",
                    "G_Wood",
                    "G_Wool",
                    "G_Salt",
                    "G_Dye",
                    "U_AmmunitionCart",
                    "U_BatteringRamCart",
                    "U_CatapultCart",
                    "U_SiegeTowerCart",
                    "U_MilitaryBandit_Melee_ME",
                    "U_MilitaryBandit_Melee_SE",
                    "U_MilitaryBandit_Melee_NA",
                    "U_MilitaryBandit_Melee_NE",
                    "U_MilitaryBandit_Ranged_ME",
                    "U_MilitaryBandit_Ranged_NA",
                    "U_MilitaryBandit_Ranged_NE",
                    "U_MilitaryBandit_Ranged_SE",
                    "U_MilitaryBow_RedPrince",
                    "U_MilitaryBow",
                    "U_MilitarySword_RedPrince",
                    "U_MilitarySword",
                    "U_Entertainer_NA_FireEater",
                    "U_Entertainer_NA_StiltWalker",
                    "U_Entertainer_NE_StrongestMan_Barrel",
                    "U_Entertainer_NE_StrongestMan_Stone",
                    }
    if g_GameExtraNo and g_GameExtraNo >= 1 then
        table.insert(Offers, "G_Gems")
        table.insert(Offers, "G_Olibanum")
        table.insert(Offers, "G_MusicalInstrument")
        table.insert(Offers, "G_MilitaryBandit_Ranged_AS")
        table.insert(Offers, "G_MilitaryBandit_Melee_AS")
        table.insert(Offers, "U_MilitarySword_Khana")
        table.insert(Offers, "U_MilitaryBow_Khana")
    end
    if (_Index == 0) then
        return Players
    elseif (_Index == 1) or (_Index == 3) or (_Index == 5) or (_Index == 7) then
        return Amount
    elseif (_Index == 2) or (_Index == 4) or (_Index == 6) or (_Index == 8) then
        return Offers
    end
end

Revision:RegisterBehavior(B_Reward_Merchant)

-- -------------------------------------------------------------------------- --

---
-- Ein benanntes Entity wird entfernt.
--
-- <b>Hinweis</b>: Das Entity wird durch ein XD_ScriptEntity ersetzt. Es
-- behält Name, Besitzer und Ausrichtung.
--
-- @param _ScriptName Skriptname des Entity
--
-- @within Reward
--
function Reward_DestroyEntity(...)
    return B_Reward_DestroyEntity:new(...);
end

B_Reward_DestroyEntity = Revision.LuaBase:CopyTable(B_Reprisal_DestroyEntity);
B_Reward_DestroyEntity.Name = "Reward_DestroyEntity";
B_Reward_DestroyEntity.Description.en = "Reward: Replaces an entity with an invisible script entity, which retains the entities name.";
B_Reward_DestroyEntity.Description.de = "Lohn: Ersetzt eine Entity mit einer unsichtbaren Script-Entity, die den Namen übernimmt.";
B_Reward_DestroyEntity.Description.fr = "Récompense: Remplace une entité par une entité de script invisible qui prend le nom.";
B_Reward_DestroyEntity.GetReprisalTable = nil;

B_Reward_DestroyEntity.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_DestroyEntity);

-- -------------------------------------------------------------------------- --

---
-- Zerstört einen über ein Behavior erzeugten Effekt.
--
-- @param _EffectName Name des Effekts
--
-- @within Reward
--
function Reward_DestroyEffect(...)
    return B_Reward_DestroyEffect:new(...);
end

B_Reward_DestroyEffect = Revision.LuaBase:CopyTable(B_Reprisal_DestroyEffect);
B_Reward_DestroyEffect.Name = "Reward_DestroyEffect";
B_Reward_DestroyEffect.Description.en = "Reward: Destroys an effect.";
B_Reward_DestroyEffect.Description.de = "Lohn: Zerstört einen Effekt.";
B_Reward_DestroyEffect.Description.fr = "Récompense: Détruit un effet.";
B_Reward_DestroyEffect.GetReprisalTable = nil;

B_Reward_DestroyEffect.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

Revision:RegisterBehavior(B_Reward_DestroyEffect);

-- -------------------------------------------------------------------------- --

---
-- Ersetzt ein Entity mit einem Batallion.
--
-- Ist die Position ein Gebäude, werden die Battalione am Eingang erzeugt und
-- Das Entity wird nicht ersetzt.
--
-- Das erzeugte Battalion kann vor der KI des Besitzers versteckt werden.
--
-- @param _Position    Skriptname des Entity
-- @param _PlayerID    PlayerID des Battalion
-- @param _UnitType    Einheitentyp der Soldaten
-- @param _Orientation Ausrichtung in °
-- @param _Soldiers    Anzahl an Soldaten
-- @param _HideFromAI  Vor KI verstecken
--
-- @within Reward
--
function Reward_CreateBattalion(...)
    return B_Reward_CreateBattalion:new(...);
end

B_Reward_CreateBattalion = {
    Name = "Reward_CreateBattalion",
    Description = {
        en = "Reward: Replaces a script entity with a battalion, which retains the entities name",
        de = "Lohn: Ersetzt eine Script-Entity durch ein Bataillon, welches den Namen der Script-Entity übernimmt",
        fr = "Récompense: Remplace une entité de script par un bataillon qui prend le nom de l'entité de script.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation du type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Number,     en = "Number of soldiers",          de = "Anzahl Soldaten",         fr = "Nombre de Soldats" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'IA" },
    },
}

function B_Reward_CreateBattalion:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateBattalion:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 4) then
        self.SoldierCount = _Parameter * 1
    elseif (_Index == 5) then
        self.HideFromAI = API.ToBoolean(_Parameter)
    end
end

function B_Reward_CreateBattalion:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, self.SoldierCount )
    local posID = GetID(self.ScriptNameEntity)
    if Logic.IsBuilding(posID) == 0 then
        DestroyEntity(self.ScriptNameEntity)
        Logic.SetEntityName( NewID, self.ScriptNameEntity )
    end
    if self.HideFromAI then
        AICore.HideEntityFromAI( self.PlayerID, NewID, true )
    end
end

function B_Reward_CreateBattalion:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        for k, v in pairs( Entities ) do
            if Logic.IsEntityTypeInCategory( v, EntityCategories.Soldier ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 5 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateBattalion:Debug(_Quest)
    if not Entities[self.UnitKey] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": playerID is wrong!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.SoldierCount) == nil or self.SoldierCount < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": you can not create a empty batallion!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_CreateBattalion);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt eine Menga von Battalionen an der Position.
--
-- Die erzeugten Battalione können vor der KI ihres Besitzers versteckt werden.
--
-- @param _Amount      Anzahl erzeugter Battalione
-- @param _Position    Skriptname des Entity
-- @param _PlayerID    PlayerID des Battalion
-- @param _UnitType    Einheitentyp der Soldaten
-- @param _Orientation Ausrichtung in °
-- @param _Soldiers    Anzahl an Soldaten
-- @param _HideFromAI  Vor KI verstecken
--
-- @within Reward
--
function Reward_CreateSeveralBattalions(...)
    return B_Reward_CreateSeveralBattalions:new(...);
end

B_Reward_CreateSeveralBattalions = {
    Name = "Reward_CreateSeveralBattalions",
    Description = {
        en = "Reward: Creates a given amount of battalions",
        de = "Lohn: Erstellt eine gegebene Anzahl Bataillone",
        fr = "Récompense: Crée un nombre donné de bataillons",
    },
    Parameter = {
        { ParameterType.Number,     en = "Amount",                      de = "Anzahl",                  fr = "Quantité" },
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Quentité de Script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Number,     en = "Number of soldiers",          de = "Anzahl Soldaten",         fr = "Nombre de soldats" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateSeveralBattalions:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateSeveralBattalions:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1
    elseif (_Index == 1) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 3) then
        self.UnitKey = _Parameter
    elseif (_Index == 4) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 5) then
        self.SoldierCount = _Parameter * 1
    elseif (_Index == 6) then
        self.HideFromAI = API.ToBoolean(_Parameter)
    end
end

function B_Reward_CreateSeveralBattalions:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local tID = GetID(self.ScriptNameEntity)
    local x,y,z = Logic.EntityGetPos(tID);
    if Logic.IsBuilding(tID) == 1 then
        x,y = Logic.GetBuildingApproachPosition(tID)
    end

    for i=1, self.Amount do
        local NewID = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], x, y, self.Orientation, self.PlayerID, self.SoldierCount )
        Logic.SetEntityName( NewID, self.ScriptNameEntity .. "_" .. i )
        if self.HideFromAI then
            AICore.HideEntityFromAI( self.PlayerID, NewID, true )
        end
    end
end

function B_Reward_CreateSeveralBattalions:GetCustomData( _Index )
    local Data = {}
    if _Index == 3 then
        for k, v in pairs( Entities ) do
            if Logic.IsEntityTypeInCategory( v, EntityCategories.Soldier ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 6 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateSeveralBattalions:Debug(_Quest)
    if not Entities[self.UnitKey] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": playerDI is wrong!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.SoldierCount) == nil or self.SoldierCount < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": you can not create a empty batallion!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_CreateSeveralBattalions);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt einen Effekt an der angegebenen Position.
--
-- Der Effekt kann über seinen Namen jeder Zeit gelöscht werden.
--
-- <b>Achtung</b>: Feuereffekte sind bekannt dafür Abstürzue zu verursachen.
-- Vermeide sie entweder ganz oder unterbinde das Speichern, solange ein
-- solcher Effekt aktiv ist!
--
-- @param _EffectName  Einzigartiger Effektname
-- @param _TypeName    Typ des Effekt
-- @param _PlayerID    PlayerID des Effekt
-- @param _Location    Position des Effekt
-- @param _Orientation Ausrichtung in °
--
-- @within Reward
--
function Reward_CreateEffect(...)
    return B_Reward_CreateEffect:new(...);
end

B_Reward_CreateEffect = {
    Name = "Reward_CreateEffect",
    Description = {
        en = "Reward: Creates an effect at a specified position",
        de = "Lohn: Erstellt einen Effekt an der angegebenen Position",
        fr = "Récompense: Crée un effet à la position indiquée",
    },
    Parameter = {
        { ParameterType.Default,    en = "Effect name", de = "Effektname",      fr = "Nom de l'effet" },
        { ParameterType.Custom,     en = "Type name",   de = "Typbezeichnung",  fr = "Designation de type" },
        { ParameterType.PlayerID,   en = "Player",      de = "Spieler",         fr = "Joueur" },
        { ParameterType.ScriptName, en = "Location",    de = "Ort",             fr = "Lieu" },
        { ParameterType.Number,     en = "Orientation (in degrees)(-1: from locating entity)", de = "Ausrichtung (in Grad)(-1: von Positionseinheit)", fr = "Orientation (en degrés)(-1 : de l'unité de position)" },
    }
}

function B_Reward_CreateEffect:AddParameter(_Index, _Parameter)

    if _Index == 0 then
        self.EffectName = _Parameter;
    elseif _Index == 1 then
        self.Type = EGL_Effects[_Parameter];
    elseif _Index == 2 then
        self.PlayerID = _Parameter * 1;
    elseif _Index == 3 then
        self.Location = _Parameter;
    elseif _Index == 4 then
        self.Orientation = _Parameter * 1;
    end

end

function B_Reward_CreateEffect:GetRewardTable()
    return { Reward.Custom, { self, self.CustomFunction } };
end

function B_Reward_CreateEffect:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed(self.Location) then
        return;
    end
    local entity = assert(GetID(self.Location), _Quest.Identifier .. "Error in " .. self.Name .. ": CustomFunction: Entity is invalid");
    if QSB.EffectNameToID[self.EffectName] and Logic.IsEffectRegistered(QSB.EffectNameToID[self.EffectName]) then
        return;
    end

    local posX, posY = Logic.GetEntityPosition(entity);
    local orientation = tonumber(self.Orientation);
    local effect = Logic.CreateEffectWithOrientation(self.Type, posX, posY, orientation, self.PlayerID);
    if self.EffectName ~= "" then
        QSB.EffectNameToID[self.EffectName] = effect;
    end
end

function B_Reward_CreateEffect:Debug(_Quest)
    if QSB.EffectNameToID[self.EffectName] and Logic.IsEffectRegistered(QSB.EffectNameToID[self.EffectName]) then
        error(_Quest.Identifier.. ": " ..self.Name..": effect already exists!");
        return true;
    elseif not IsExisting(self.Location) then
        error(_Quest.Identifier.. ": " ..self.Name..": location '" ..self.Location.. "' is missing!");
        return true;
    elseif self.PlayerID and (self.PlayerID < 0 or self.PlayerID > 8) then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid playerID!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid orientation!");
        return true;
    end
end

function B_Reward_CreateEffect:GetCustomData(_Index)
    assert(_Index == 1, "Error in " .. self.Name .. ": GetCustomData: Index is invalid.");
    local types = {};
    for k, v in pairs(EGL_Effects) do
        table.insert(types, k);
    end
    table.sort(types);
    return types;
end

Revision:RegisterBehavior(B_Reward_CreateEffect);

-- -------------------------------------------------------------------------- --

---
-- Ersetzt ein Entity mit dem Skriptnamen durch ein neues Entity.
--
-- Ist die Position ein Gebäude, werden die Entities am Eingang erzeugt und
-- die Position wird nicht ersetzt.
--
-- Das erzeugte Entity kann vor der KI des Besitzers versteckt werden.
--
-- @param _ScriptName  Skriptname des Entity
-- @param _PlayerID    PlayerID des Effekt
-- @param _TypeName    Typname des Entity
-- @param _Orientation Ausrichtung in °
-- @param _HideFromAI  Vor KI verstecken
--
-- @within Reward
--
function Reward_CreateEntity(...)
    return B_Reward_CreateEntity:new(...);
end

B_Reward_CreateEntity = {
    Name = "Reward_CreateEntity",
    Description = {
        en = "Reward: Replaces an entity by a new one of a given type",
        de = "Lohn: Ersetzt eine Entity durch eine neue gegebenen Typs",
        fr = "Récompense: Remplace une entité par une nouvelle entité de type donné",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateEntity:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 4) then
        self.HideFromAI = API.ToBoolean(_Parameter)
    end
end

function B_Reward_CreateEntity:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID;
    if Logic.IsEntityTypeInCategory( self.UnitKey, EntityCategories.Soldier ) == 1 then
        NewID     = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, 1 )
        local l,s = Logic.GetSoldiersAttachedToLeader(NewID)
        Logic.SetOrientation(s, API.Round(self.Orientation))
    else
        NewID = Logic.CreateEntityOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID )
    end
    local posID = GetID(self.ScriptNameEntity)
    if Logic.IsBuilding(posID) == 0 then
        DestroyEntity(self.ScriptNameEntity)
        Logic.SetEntityName( NewID, self.ScriptNameEntity )
    end
    if self.HideFromAI then
        AICore.HideEntityFromAI( self.PlayerID, NewID, true )
    end
end

function B_Reward_CreateEntity:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        for k, v in pairs( Entities ) do
            local name = {"^M_*","^XS_*","^X_*","^XT_*","^Z_*"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )

    elseif _Index == 4 or _Index == 5 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateEntity:Debug(_Quest)
    if not Entities[self.UnitKey] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 0 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": playerID is not valid!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_CreateEntity);

-- -------------------------------------------------------------------------- --

-- Kompatibelität
B_Reward_CreateSettler = Revision.LuaBase:CopyTable(B_Reward_CreateEntity);
B_Reward_CreateSettler.Name = "Reward_CreateSettler";
B_Reward_CreateSettler.Description.en = "Reward: Replaces an entity by a new one of a given type";
B_Reward_CreateSettler.Description.de = "Lohn: Ersetzt eine Entity durch eine neue gegebenen Typs";
B_Reward_CreateSettler.Description.fr = "Récompense: Remplace une entité par une nouvelle entité de type donné";
Revision:RegisterBehavior(B_Reward_CreateSettler);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt mehrere Entities an der angegebenen Position.
--
-- Die erzeugten Entities können vor der KI ihres Besitzers versteckt werden.
--
-- @param _Amount      Anzahl an Entities
-- @param _ScriptName  Skriptname des Entity
-- @param _PlayerID    PlayerID des Effekt
-- @param _TypeName    Einzigartiger Effektname
-- @param _Orientation Ausrichtung in °
-- @param _HideFromAI  Vor KI verstecken
--
-- @within Reward
--
function Reward_CreateSeveralEntities(...)
    return B_Reward_CreateSeveralEntities:new(...);
end

B_Reward_CreateSeveralEntities = {
    Name = "Reward_CreateSeveralEntities",
    Description = {
        en = "Reward: Creating serveral battalions at the position of a entity. They retains the entities name and a _[index] suffix",
        de = "Lohn: Erzeugt mehrere Entities an der Position der Entity. Sie übernimmt den Namen der Script Entity und den Suffix _[index]",
        fr = "Récompense: Crée plusieurs Entities à la position de l'Entity. Elle reprend le nom de l'entité script et le suffixe _[index].",
    },
    Parameter = {
        { ParameterType.Number,     en = "Amount",                      de = "Anzahl",                  fr = "Quantité" },
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Designation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateSeveralEntities:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateSeveralEntities:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1
    elseif (_Index == 1) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 3) then
        self.UnitKey = _Parameter
    elseif (_Index == 4) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 5) then
        self.HideFromAI = API.ToBoolean(_Parameter)
    end
end

function B_Reward_CreateSeveralEntities:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID;
    for i=1, self.Amount do
        if Logic.IsEntityTypeInCategory( self.UnitKey, EntityCategories.Soldier ) == 1 then
            NewID     = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, 1 )
            local l,s = Logic.GetSoldiersAttachedToLeader(NewID)
            Logic.SetOrientation(s, API.Round(self.Orientation))
        else
            NewID = Logic.CreateEntityOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID )
        end
        Logic.SetEntityName( NewID, self.ScriptNameEntity .. "_" .. i )
        if self.HideFromAI then
            AICore.HideEntityFromAI( self.PlayerID, NewID, true )
        end
    end
end

function B_Reward_CreateSeveralEntities:GetCustomData( _Index )
    local Data = {}
    if _Index == 3 then
        for k, v in pairs( Entities ) do
            local name = {"^M_*","^XS_*","^X_*","^XT_*","^Z_*"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )

    elseif _Index == 5 or _Index == 6 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data

end

function B_Reward_CreateSeveralEntities:Debug(_Quest)
    if not Entities[self.UnitKey] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_CreateSeveralEntities);

-- -------------------------------------------------------------------------- --

---
-- Bewegt einen Siedler, einen Helden oder ein Battalion zum angegebenen 
-- Zielort.
--
-- @param _Settler     Einheit, die bewegt wird
-- @param _Destination Bewegungsziel
--
-- @within Reward
--
function Reward_MoveSettler(...)
    return B_Reward_MoveSettler:new(...);
end

B_Reward_MoveSettler = {
    Name = "Reward_MoveSettler",
    Description = {
        en = "Reward: Moves a (NPC) settler to a destination. Must not be AI controlled, or it won't move",
        de = "Lohn: Bewegt einen (NPC) Siedler zu einem Zielort. Darf keinem KI Spieler gehören, ansonsten wird sich der Siedler nicht bewegen",
        fr = "Récompense: Déplace un settler (NPC) vers une destination. Ne doit pas appartenir à un joueur IA, sinon le settler ne se déplacera pas.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Settler", de = "Siedler", fr = "Settler" },
        { ParameterType.ScriptName, en = "Destination", de = "Ziel", fr = "Destination" },
    },
}

function B_Reward_MoveSettler:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_MoveSettler:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameUnit = _Parameter
    elseif (_Index == 1) then
        self.ScriptNameDest = _Parameter
    end
end

function B_Reward_MoveSettler:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.ScriptNameUnit ) or Logic.IsEntityDestroyed( self.ScriptNameDest ) then
        return false
    end
    local DestID = GetID( self.ScriptNameDest )
    local DestX, DestY = Logic.GetEntityPosition( DestID )
    if Logic.IsBuilding( DestID ) == 1 then
        DestX, DestY = Logic.GetBuildingApproachPosition( DestID )
    end
    Logic.MoveSettler( GetID( self.ScriptNameUnit ), DestX, DestY )
end

function B_Reward_MoveSettler:Debug(_Quest)
    if not IsExisting(self.ScriptNameUnit) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": mover entity does not exist!");
        return true;
    elseif not IsExisting(self.ScriptNameDest) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": destination does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_MoveSettler);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler gewinnt das Spiel.
--
-- @within Reward
--
function Reward_Victory()
    return B_Reward_Victory:new()
end

B_Reward_Victory = {
    Name = "Reward_Victory",
    Description = {
        en = "Reward: The player wins the game.",
        de = "Lohn: Der Spieler gewinnt das Spiel.",
        fr = "Récompense: Le Joueur gagne la partie.",
    },
}

function B_Reward_Victory:GetRewardTable()
    return {Reward.Victory};
end

Revision:RegisterBehavior(B_Reward_Victory);

-- -------------------------------------------------------------------------- --

---
-- Der Spieler verliert das Spiel.
--
--
-- @within Reward
--
function Reward_Defeat()
    return B_Reward_Defeat:new()
end

B_Reward_Defeat = {
    Name = "Reward_Defeat",
    Description = {
        en = "Reward: The player loses the game.",
        de = "Lohn: Der Spieler verliert das Spiel.",
        fr = "Récompense: le Joueur perd la partie.",
    },
}

function B_Reward_Defeat:GetRewardTable()
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_Defeat:CustomFunction(_Quest)
    _Quest:TerminateEventsAndStuff()
    Logic.ExecuteInLuaLocalState("GUI_Window.MissionEndScreenSetVictoryReasonText(".. g_VictoryAndDefeatType.DefeatMissionFailed ..")")
    Defeated(_Quest.ReceivingPlayer)
end

Revision:RegisterBehavior(B_Reward_Defeat);

-- -------------------------------------------------------------------------- --

---
-- Zeigt die Siegdekoration an dem Quest an.
--
-- Dies ist reine Optik! Der Spieler wird dadurch nicht das Spiel gewinnen.
--
-- @within Reward
--
function Reward_FakeVictory()
    return B_Reward_FakeVictory:new();
end

B_Reward_FakeVictory = {
    Name = "Reward_FakeVictory",
    Description = {
        en = "Reward: Display a victory icon for a quest",
        de = "Lohn: Zeigt ein Siegesicon fuer diese Quest",
        fr = "Récompense: Affiche une icône de victoire pour cette quête",
    },
}

function B_Reward_FakeVictory:GetRewardTable()
    return { Reward.FakeVictory }
end

Revision:RegisterBehavior(B_Reward_FakeVictory);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt eine Armee, die das angegebene Territorium angreift.
--
-- Die Armee wird versuchen Gebäude auf dem Territrium zu zerstören.
-- <ul>
-- <li>Außenposten: Die Armee versucht den Außenposten zu zerstören</li>
-- <li>Stadt: Die Armee versucht das Lagerhaus zu zerstören</li>
-- </ul>
--
-- @param _PlayerID   PlayerID der Angreifer
-- @param _SpawnPoint Skriptname des Entstehungspunkt
-- @param _Territory  Zielterritorium
-- @param _Sword      Anzahl Schwertkämpfer (Battalion)
-- @param _Bow        Anzahl Bogenschützen (Battalion)
-- @param _Cata       Anzahl Katapulte
-- @param _Towers     Anzahl Belagerungstürme
-- @param _Rams       Anzahl Rammen
-- @param _Ammo       Anzahl Munitionswagen
-- @param _Type       Typ der Soldaten
-- @param _Reuse      Freie Truppen wiederverwenden
--
-- @within Reward
--
function Reward_AI_SpawnAndAttackTerritory(...)
    return B_Reward_AI_SpawnAndAttackTerritory:new(...);
end

B_Reward_AI_SpawnAndAttackTerritory = {
    Name = "Reward_AI_SpawnAndAttackTerritory",
    Description = {
        en = "Reward: Spawns AI troops and attacks a territory (Hint: Use for hidden quests as a surprise)",
        de = "Lohn: Erstellt KI Truppen und greift ein Territorium an (Tipp: Fuer eine versteckte Quest als Ueberraschung verwenden)",
        fr = "Récompense: Créez des troupes d'IA et attaquez un territoire (astuce : utilisez une surprise pour une quête cachée).",
    },
    Parameter = {
        { ParameterType.PlayerID,       en = "AI Player",       de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName,     en = "Spawn point",     de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.TerritoryName,  en = "Territory",       de = "Territorium",                 fr = "Territoire" },
        { ParameterType.Number,         en = "Sword",           de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,         en = "Bow",             de = "Bogen",                       fr = "Archer" },
        { ParameterType.Number,         en = "Catapults",       de = "Katapulte",                   fr = "Catapultes" },
        { ParameterType.Number,         en = "Siege towers",    de = "Belagerungstuerme",           fr = "Tours de siège" },
        { ParameterType.Number,         en = "Rams",            de = "Rammen",                      fr = "Bélier" },
        { ParameterType.Number,         en = "Ammo carts",      de = "Munitionswagen",              fr = "Chariot à munitions" },
        { ParameterType.Custom,         en = "Soldier type",    de = "Soldatentyp",                 fr = "Type de soldat" },
        { ParameterType.Custom,         en = "Reuse troops",    de = "Verwende bestehende Truppen", fr = "Utiliser les troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndAttackTerritory:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndAttackTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    elseif (_Index == 3) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 4) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 5) then
        self.NumCatapults = _Parameter * 1
    elseif (_Index == 6) then
        self.NumSiegeTowers = _Parameter * 1
    elseif (_Index == 7) then
        self.NumRams = _Parameter * 1
    elseif (_Index == 8) then
        self.NumAmmoCarts = _Parameter * 1
    elseif (_Index == 9) then
        if _Parameter == "Normal" or _Parameter == false then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == true then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 10) then
        self.ReuseTroops = API.ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SpawnAndAttackTerritory:GetCustomData( _Index )
    local Data = {}
    if _Index == 9 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end
    elseif _Index == 10 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_AI_SpawnAndAttackTerritory:CustomFunction(_Quest)
    local TargetID = Logic.GetTerritoryAcquiringBuildingID( self.TerritoryID )
    if TargetID ~= 0 then
        AIScript_SpawnAndAttackCity(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.NumSword,
            self.NumBow,
            self.NumCatapults,
            self.NumSiegeTowers,
            self.NumRams,
            self.NumAmmoCarts,
            self.TroopType,
            self.ReuseTroops
        )
    end
end

function B_Reward_AI_SpawnAndAttackTerritory:Debug(_Quest)
    if self.AIPlayerID < 2 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif self.TerritoryID == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Territory unknown")
        return true
    elseif self.NumSword < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    elseif self.NumCatapults < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Catapults is negative")
        return true
    elseif self.NumSiegeTowers < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": SiegeTowers is negative")
        return true
    elseif self.NumRams < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Rams is negative")
        return true
    elseif self.NumAmmoCarts < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": AmmoCarts is negative")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_AI_SpawnAndAttackTerritory);

-- -------------------------------------------------------------------------- --

---
-- Erzeugt eine Armee, die sich zum Zielpunkt bewegt und das Gebiet angreift.
--
-- Dabei werden die Soldaten alle erreichbaren Gebäude in Brand stecken. Ist
-- Das Zielgebiet eingemauert, können die Soldaten nicht angreifen und werden
-- sich zurückziehen.
--
-- @param _PlayerID   PlayerID des Angreifers
-- @param _SpawnPoint Skriptname des Entstehungspunktes
-- @param _Target     Skriptname des Ziels
-- @param _Radius     Aktionsradius um das Ziel
-- @param _Sword      Anzahl Schwertkämpfer (Battalione)
-- @param _Bow        Anzahl Bogenschützen (Battalione)
-- @param _Soldier    Typ der Soldaten
-- @param _Reuse      Freie Truppen wiederverwenden
--
-- @within Reward
--
function Reward_AI_SpawnAndAttackArea(...)
    return B_Reward_AI_SpawnAndAttackArea:new(...);
end

B_Reward_AI_SpawnAndAttackArea = {
    Name = "Reward_AI_SpawnAndAttackArea",
    Description = {
        en = "Reward: Spawns AI troops and attacks everything within the specified area, except the players main buildings",
        de = "Lohn: Erstellt KI Truppen und greift ein angegebenes Gebiet an, aber nicht die Hauptgebauede eines Spielers",
        fr = "Récompense: Crée des troupes IA et attaque une zone spécifiée, mais pas les bâtiments principaux d'un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "AI Player",       de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName, en = "Spawn point",     de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.ScriptName, en = "Target",          de = "Ziel",                        fr = "Cible" },
        { ParameterType.Number,     en = "Radius",          de = "Radius",                      fr = "Rayon" },
        { ParameterType.Number,     en = "Sword",           de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,     en = "Bow",             de = "Bogen",                       fr = "Archer" },
        { ParameterType.Custom,     en = "Soldier type",    de = "Soldatentyp",                 fr = "Type de soldats" },
        { ParameterType.Custom,     en = "Reuse troops",    de = "Verwende bestehende Truppen", fr = "Utiliser des troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndAttackArea:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndAttackArea:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TargetName = _Parameter
    elseif (_Index == 3) then
        self.Radius = _Parameter * 1
    elseif (_Index == 4) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 5) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 6) then
        if _Parameter == "Normal" or _Parameter == false then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == true then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 7) then
        self.ReuseTroops = API.ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SpawnAndAttackArea:GetCustomData( _Index )
    local Data = {}
    if _Index == 6 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end
    elseif _Index == 7 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_AI_SpawnAndAttackArea:CustomFunction(_Quest)
    if Logic.IsEntityAlive( self.TargetName ) and Logic.IsEntityAlive( self.Spawnpoint ) then
        local TargetID = GetID( self.TargetName )
        AIScript_SpawnAndRaidSettlement(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.Radius,
            self.NumSword,
            self.NumBow,
            self.TroopType,
            self.ReuseTroops
        )
    end
end

function B_Reward_AI_SpawnAndAttackArea:Debug(_Quest)
    if self.AIPlayerID < 2 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif Logic.IsEntityDestroyed(self.TargetName) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.TargetName .. " is missing")
        return true
    elseif self.Radius < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Radius is to small or negative")
        return true
    elseif self.NumSword < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_AI_SpawnAndAttackArea);

-- -------------------------------------------------------------------------- --

---
-- Erstellt eine Armee, die das Zielgebiet verteidigt.
--
-- @param _PlayerID     PlayerID des Angreifers
-- @param _SpawnPoint   Skriptname des Entstehungspunktes
-- @param _Target       Skriptname des Ziels
-- @param _Radius       Bewachtes Gebiet
-- @param _Time         Dauer der Bewachung (-1 für unendlich)
-- @param _Sword        Anzahl Schwertkämpfer (Battalione)
-- @param _Bow          Anzahl Bogenschützen (Battalione)
-- @param _CaptureCarts Soldaten greifen Karren an
-- @param _Type         Typ der Soldaten
-- @param _Reuse        Freie Truppen wiederverwenden
--
-- @within Reward
--
function Reward_AI_SpawnAndProtectArea(...)
    return B_Reward_AI_SpawnAndProtectArea:new(...);
end

B_Reward_AI_SpawnAndProtectArea = {
    Name = "Reward_AI_SpawnAndProtectArea",
    Description = {
        en = "Reward: Spawns AI troops and defends a specified area",
        de = "Lohn: Erstellt KI Truppen und verteidigt ein angegebenes Gebiet",
        fr = "Récompense: Crée des troupes d'IA et défend un territoire donné",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "AI Player",               de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName, en = "Spawn point",             de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.ScriptName, en = "Target",                  de = "Ziel",                        fr = "Cible" },
        { ParameterType.Number,     en = "Radius",                  de = "Radius",                      fr = "Rayon" },
        { ParameterType.Number,     en = "Time (-1 for infinite)",  de = "Zeit (-1 fuer unendlich)",    fr = "Temps (-1 pour infini)" },
        { ParameterType.Number,     en = "Sword",                   de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,     en = "Bow",                     de = "Bogen",                       fr = "Archer" },
        { ParameterType.Custom,     en = "Capture tradecarts",      de = "Handelskarren angreifen",     fr = "Attaquer les chariots de commerce" },
        { ParameterType.Custom,     en = "Soldier type",            de = "Soldatentyp",                 fr = "Type de soldat" },
        { ParameterType.Custom,     en = "Reuse troops",            de = "Verwende bestehende Truppen", fr = "Utiliser les troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndProtectArea:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndProtectArea:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TargetName = _Parameter
    elseif (_Index == 3) then
        self.Radius = _Parameter * 1
    elseif (_Index == 4) then
        self.Time = _Parameter * 1
    elseif (_Index == 5) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 6) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 7) then
        self.CaptureTradeCarts = API.ToBoolean(_Parameter)
    elseif (_Index == 8) then
        if _Parameter == "Normal" or _Parameter == true then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == false then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 9) then
        self.ReuseTroops = API.ToBoolean(_Parameter)
    end

end

function B_Reward_AI_SpawnAndProtectArea:GetCustomData( _Index )

    local Data = {}
    if _Index == 7 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    elseif _Index == 8 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end

    elseif _Index == 9 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )

    else
        assert( false )
    end

    return Data

end

function B_Reward_AI_SpawnAndProtectArea:CustomFunction(_Quest)
    if Logic.IsEntityAlive( self.TargetName ) and Logic.IsEntityAlive( self.Spawnpoint ) then
        local TargetID = GetID( self.TargetName )
        AIScript_SpawnAndProtectArea(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.Radius,
            self.NumSword,
            self.NumBow,
            self.Time,
            self.TroopType,
            self.ReuseTroops,
            self.CaptureTradeCarts
        )
    end
end

function B_Reward_AI_SpawnAndProtectArea:Debug(_Quest)
    if self.AIPlayerID < 2 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif Logic.IsEntityDestroyed(self.TargetName) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.TargetName .. " is missing")
        return true
    elseif self.Radius < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Radius is to small or negative")
        return true
    elseif self.Time < -1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Time is smaller than -1")
        return true
    elseif self.NumSword < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_AI_SpawnAndProtectArea);

-- -------------------------------------------------------------------------- --

---
-- Ändert die Konfiguration eines KI-Spielers.
--
-- Optionen:
-- <ul>
-- <li>Courage/FEAR: Angstfaktor (0 bis ?)</li>
-- <li>Reconstruction/BARB: Wiederaufbau von Gebäuden (0 oder 1)</li>
-- <li>Build Order/BPMX: Buildorder ausführen (Nummer der Build Order)</li>
-- <li>Conquer Outposts/FCOP: Außenposten einnehmen (0 oder 1)</li>
-- <li>Mount Outposts/FMOP: Eigene Außenposten bemannen (0 oder 1)</li>
-- <li>max. Bowmen/FMBM: Maximale Anzahl an Bogenschützen (min. 1)</li>
-- <li>max. Swordmen/FMSM: Maximale Anzahl an Schwerkkämpfer (min. 1) </li>
-- <li>max. Rams/FMRA: Maximale Anzahl an Rammen (min. 1)</li>
-- <li>max. Catapults/FMCA: Maximale Anzahl an Katapulten (min. 1)</li>
-- <li>max. Ammunition Carts/FMAC: Maximale Anzahl an Minitionswagen (min. 1)</li>
-- <li>max. Siege Towers/FMST: Maximale Anzahl an Belagerungstürmen (min. 1)</li>
-- <li>max. Wall Catapults/FMBA: Maximale Anzahl an Mauerkatapulten (min. 1)</li>
-- </ul>
--
-- @param _PlayerID PlayerID des KI
-- @param _Fact     Konfigurationseintrag
-- @param _Value    Neuer Wert
--
-- @within Reward
--
function Reward_AI_SetNumericalFact(...)
    return B_Reward_AI_SetNumericalFact:new(...);
end

B_Reward_AI_SetNumericalFact = {
    Name = "Reward_AI_SetNumericalFact",
    Description = {
        en = "Reward: Sets a numerical fact for the AI player",
        de = "Lohn: Setzt eine Verhaltensregel fuer den KI-Spieler. ",
        fr = "Récompense: Définit une règle de comportement pour le joueur IA.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "AI Player",      de = "KI Spieler",         fr = "Joueur AI" },
        { ParameterType.Custom,   en = "Numerical Fact", de = "Verhaltensregel",    fr = "Règle de conduite" },
        { ParameterType.Number,   en = "Value",          de = "Wert",               fr = "Valeur" },
    },
}

function B_Reward_AI_SetNumericalFact:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SetNumericalFact:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        -- mapping of numerical facts
        local fact = {
            ["Courage"]               = "FEAR",
            ["Reconstruction"]        = "BARB",
            ["Build Order"]           = "BPMX",
            ["Conquer Outposts"]      = "FCOP",
            ["Mount Outposts"]        = "FMOP",
            ["max. Bowmen"]           = "FMBM",
            ["max. Swordmen"]         = "FMSM",
            ["max. Rams"]             = "FMRA",
            ["max. Catapults"]        = "FMCA",
            ["max. Ammunition Carts"] = "FMAC",
            ["max. Siege Towers"]     = "FMST",
            ["max. Wall Catapults"]   = "FMBA",
            ["FEAR"]                  = "FEAR", -- > 0
            ["BARB"]                  = "BARB", -- 1 or 0
            ["BPMX"]                  = "BPMX", -- >= 0
            ["FCOP"]                  = "FCOP", -- 1 or 0
            ["FMOP"]                  = "FMOP", -- 1 or 0
            ["FMBM"]                  = "FMBM", -- >= 0
            ["FMSM"]                  = "FMSM", -- >= 0
            ["FMRA"]                  = "FMRA", -- >= 0
            ["FMCA"]                  = "FMCA", -- >= 0
            ["FMAC"]                  = "FMAC", -- >= 0
            ["FMST"]                  = "FMST", -- >= 0
            ["FMBA"]                  = "FMBA", -- >= 0
        }
        self.NumericalFact = fact[_Parameter]
    elseif (_Index == 2) then
        self.Value = _Parameter * 1
    end
end

function B_Reward_AI_SetNumericalFact:CustomFunction(_Quest)
    AICore.SetNumericalFact(self.AIPlayerID, self.NumericalFact, self.Value)
end

function B_Reward_AI_SetNumericalFact:GetCustomData(_Index)
    if (_Index == 1) then
        return {
            "Courage",
            "Reconstruction",
            "Build Order",
            "Conquer Outposts",
            "Mount Outposts",
            "max. Bowmen",
            "max. Swordmen",
            "max. Rams",
            "max. Catapults",
            "max. Ammunition Carts",
            "max. Siege Towers",
            "max. Wall Catapults",
        };
    end
end

function B_Reward_AI_SetNumericalFact:Debug(_Quest)
    if Logic.GetStoreHouse(self.AIPlayerID) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong or dead!");
        return true;
    elseif not self.NumericalFact then
        error(_Quest.Identifier.. ": " ..self.Name .. ": invalid numerical fact choosen!");
        return true;
    else
        if self.NumericalFact == "BARB" or self.NumericalFact == "FCOP" or self.NumericalFact == "FMOP" then
            if self.Value ~= 0 and self.Value ~= 1 then
                error(_Quest.Identifier.. ": " ..self.Name .. ": BARB, FCOP, FMOP: value must be 1 or 0!");
                return true;
            end
        elseif self.NumericalFact == "FEAR" then
            if self.Value <= 0 then
                error(_Quest.Identifier.. ": " ..self.Name .. ": FEAR: value must greater than 0!");
                return true;
            end
        else
            if self.Value < 0 then
                error(_Quest.Identifier.. ": " ..self.Name .. ": value must always greater than or equal 0!");
                return true;
            end
        end
    end
    return false
end

Revision:RegisterBehavior(B_Reward_AI_SetNumericalFact);

-- -------------------------------------------------------------------------- --

---
-- Stellt den Aggressivitätswert des KI-Spielers nachträglich ein.
--
-- @param _PlayerID         PlayerID des KI-Spielers
-- @param _Aggressiveness   Aggressivitätswert (1 bis 3)
--
-- @within Reward
--
function Reward_AI_Aggressiveness(...)
    return B_Reward_AI_Aggressiveness:new(...);
end

B_Reward_AI_Aggressiveness = {
    Name = "Reward_AI_Aggressiveness",
    Description = {
        en = "Reward: Sets the AI player's aggressiveness.",
        de = "Lohn: Setzt die Aggressivität des KI-Spielers fest.",
        fr = "Récompense: Définit l'agressivité du joueur IA.",
    },
    Parameter =
    {
        { ParameterType.PlayerID, en = "AI player", de = "KI-Spieler", fr = "Joueur AI" },
        { ParameterType.Custom, en = "Aggressiveness (1-3)", de = "Aggressivität (1-3)", fr = "Agressivité (1-3)" }
    }
};

function B_Reward_AI_Aggressiveness:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction} };
end

function B_Reward_AI_Aggressiveness:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.AIPlayer = _Parameter * 1;
    elseif _Index == 1 then
        self.Aggressiveness = tonumber(_Parameter);
    end
end

function B_Reward_AI_Aggressiveness:CustomFunction()
    local player = (PlayerAIs[self.AIPlayer]
        or AIPlayerTable[self.AIPlayer]
        or AIPlayer:new(self.AIPlayer, AIPlayerProfile_City));
    PlayerAIs[self.AIPlayer] = player;
    if self.Aggressiveness >= 2 then
        player.ProfileLoop = AIProfile_Skirmish;
        player.Skirmish = player.Skirmish or {};
        player.Skirmish.Claim_MinTime = SkirmishDefault.Claim_MinTime + (self.Aggressiveness - 2) * 390;
        player.Skirmish.Claim_MaxTime = player.Skirmish.Claim_MinTime * 2;
    else
        player.ProfileLoop = AIPlayerProfile_City;
    end
end

function B_Reward_AI_Aggressiveness:Debug(_Quest)
    if self.AIPlayer < 1 or Logic.GetStoreHouse(self.AIPlayer) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayer .. " is wrong");
        return true;
    end
end

function B_Reward_AI_Aggressiveness:GetCustomData(_Index)
    return { "1", "2", "3" };
end

Revision:RegisterBehavior(B_Reward_AI_Aggressiveness)

-- -------------------------------------------------------------------------- --

---
-- Stellt den Feind des Skirmish-KI ein.
--
-- Der Skirmish-KI (maximale Aggressivität) kann nur einen Spieler als Feind
-- behandeln. Für gewöhnlich ist dies der menschliche Spieler.
--
-- @param _PlayerID      PlayerID des KI
-- @param _EnemyPlayerID PlayerID des Feindes
--
-- @within Reward
--
function Reward_AI_SetEnemy(...)
    return B_Reward_AI_SetEnemy:new(...);
end

B_Reward_AI_SetEnemy = {
    Name = "Reward_AI_SetEnemy",
    Description = {
        en = "Reward:Sets the enemy of an AI player (the AI only handles one enemy properly).",
        de = "Lohn: Legt den Feind eines KI-Spielers fest (die KI behandelt nur einen Feind korrekt).",
        fr = "Récompense: Définit l'ennemi d'un joueur IA (l'IA ne traite correctement qu'un seul ennemi).",
    },
    Parameter =
    {
        { ParameterType.PlayerID, en = "AI player", de = "KI-Spieler", fr = "Joueur AI" },
        { ParameterType.PlayerID, en = "Enemy", de = "Feind", fr = "Ennemi" }
    }
};

function B_Reward_AI_SetEnemy:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction} };
end

function B_Reward_AI_SetEnemy:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.AIPlayer = _Parameter * 1;
    elseif _Index == 1 then
        self.Enemy = _Parameter * 1;
    end
end

function B_Reward_AI_SetEnemy:CustomFunction()
    local player = PlayerAIs[self.AIPlayer];
    if player and player.Skirmish then
        player.Skirmish.Enemy = self.Enemy;
    end
end

function B_Reward_AI_SetEnemy:Debug(_Quest)
    if self.AIPlayer < 1 or self.AIPlayer > 8 or Logic.PlayerGetIsHumanFlag(self.AIPlayer) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayer .. " is wrong");
        return true;
    end
    return false;
end
Revision:RegisterBehavior(B_Reward_AI_SetEnemy)

-- -------------------------------------------------------------------------- --

---
-- Ein Entity wird durch ein neues anderen Typs ersetzt.
--
-- Das neue Entity übernimmt Skriptname, Besitzer und Ausrichtung des
-- alten Entity.
--
-- @param _Entity Skriptname oder ID des Entity
-- @param _Type   Neuer Typ des Entity
-- @param _Owner  Besitzer des Entity
--
-- @within Reward
--
function Reward_ReplaceEntity(...)
    return B_Reward_ReplaceEntity:new(...);
end

B_Reward_ReplaceEntity = Revision.LuaBase:CopyTable(B_Reprisal_ReplaceEntity);
B_Reward_ReplaceEntity.Name = "Reward_ReplaceEntity";
B_Reward_ReplaceEntity.Description.en = "Reward: Replaces an entity with a new one of a different type. The playerID can be changed too.";
B_Reward_ReplaceEntity.Description.de = "Lohn: Ersetzt eine Entity durch eine neue anderen Typs. Es kann auch die Spielerzugehörigkeit geändert werden.";
B_Reward_ReplaceEntity.Description.fr = "Récompense: Remplace une entité par une nouvelle entité d'un autre type. Il est également possible de changer l'appartenance d'un joueur.";
B_Reward_ReplaceEntity.GetReprisalTable = nil;

B_Reward_ReplaceEntity.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_ReplaceEntity);

-- -------------------------------------------------------------------------- --

---
-- Setzt die Menge von Rohstoffen in einer Mine.
--
-- <b>Achtung:</b> Im Reich des Ostens darf die Mine nicht eingestürzt sein!
-- Außerdem bringt dieses Behavior die Nachfüllmechanik durcheinander.
--
-- @param _ScriptName Skriptname der Mine
-- @param _Amount     Menge an Rohstoffen
--
-- @within Reward
--
function Reward_SetResourceAmount(...)
    return B_Reward_SetResourceAmount:new(...);
end

B_Reward_SetResourceAmount = {
    Name = "Reward_SetResourceAmount",
    Description = {
        en = "Reward: Set the current and maximum amount of a resource doodad (the amount can also set to 0)",
        de = "Lohn: Setzt die aktuellen sowie maximalen Resourcen in einem Doodad (auch 0 ist möglich)",
        fr = "Récompense: Définit les ressources actuelles ainsi que les ressources maximales dans un Doodad (0 est également possible)",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Ressource", de = "Resource", fr = "Ressources" },
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité" },
    },
}

function B_Reward_SetResourceAmount:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SetResourceAmount:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    end

end

function B_Reward_SetResourceAmount:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.ScriptName ) then
        return false
    end
    local EntityID = GetID( self.ScriptName )
    if Logic.GetResourceDoodadGoodType( EntityID ) == 0 then
        return false
    end
    Logic.SetResourceDoodadGoodAmount( EntityID, self.Amount )
end

function B_Reward_SetResourceAmount:Debug(_Quest)
    if not IsExisting(self.ScriptName) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": resource entity does not exist!")
        return true
    elseif not type(self.Amount) == "number" or self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": resource amount can not be negative!")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_SetResourceAmount);

-- -------------------------------------------------------------------------- --

---
-- Fügt dem Lagerhaus des Auftragnehmers eine Menge an Rohstoffen hinzu. Die
-- Rohstoffe werden direkt ins Lagerhaus bzw. die Schatzkammer gelegt.
--
-- @param _Type   Rohstofftyp
-- @param _Amount Menge an Rohstoffen
--
-- @within Reward
--
function Reward_Resources(...)
    return B_Reward_Resources:new(...);
end

B_Reward_Resources = {
    Name = "Reward_Resources",
    Description = {
        en = "Reward: The player receives a given amount of Goods in his store.",
        de = "Lohn: Legt der Partei die angegebenen Rohstoffe ins Lagerhaus.",
        fr = "Récompense: Placez les matières premières indiquées dans l'entrepôt de la faction.",
    },
    Parameter = {
        { ParameterType.RawGoods,   en = "Type of good",    de = "Resourcentyp",        fr = "Type de ressources" },
        { ParameterType.Number,     en = "Amount of good",  de = "Anzahl der Resource", fr = "Nombre de ressources" },
    },
}

function B_Reward_Resources:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Reward_Resources:GetRewardTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Reward.Resources, GoodType, self.GoodAmount }
end

Revision:RegisterBehavior(B_Reward_Resources);

-- -------------------------------------------------------------------------- --

---
-- Entsendet einen Karren zum angegebenen Spieler.
--
-- Wenn der Spawnpoint ein Gebäude ist, wird der Wagen am Eingang erstellt.
-- Andernfalls kann der Spawnpoint gelöscht werden und der Wagen übernimmt
-- dann den Skriptnamen.
--
-- @param _ScriptName    Skriptname des Spawnpoint
-- @param _Owner         Empfänger der Lieferung
-- @param _Type          Typ des Wagens
-- @param _Good          Typ der Ware
-- @param _Amount        Menge an Waren
-- @param _OtherPlayer   Anderer Empfänger als Auftraggeber
-- @param _NoReservation Platzreservation auf dem Markt ignorieren (Sinnvoll?)
-- @param _Replace       Spawnpoint ersetzen
--
-- @within Reward
--
function Reward_SendCart(...)
    return B_Reward_SendCart:new(...);
end

B_Reward_SendCart = {
    Name = "Reward_SendCart",
    Description = {
        en = "Reward: Sends a cart to a player. It spawns at a building or by replacing an entity. The cart can replace the entity if it's not a building.",
        de = "Lohn: Sendet einen Karren zu einem Spieler. Der Karren wird an einem Gebäude oder einer Entity erstellt. Er ersetzt die Entity, wenn diese kein Gebäude ist.",
        fr = "Récompense: Envoie un chariot à un joueur. Le chariot est créé sur un bâtiment ou une entité. Elle remplace l'entité si celle-ci n'est pas un bâtiment.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",           de = "Script Entity",               fr = "Entité de Script" },
        { ParameterType.PlayerID,   en = "Owning player",           de = "Besitzer",                    fr = "Propriétaire" },
        { ParameterType.Custom,     en = "Type name",               de = "Typbezeichnung",              fr = "Désignation du type" },
        { ParameterType.Custom,     en = "Good type",               de = "Warentyp",                    fr = "Type de marchandise" },
        { ParameterType.Number,     en = "Amount",                  de = "Anzahl",                      fr = "Quantité" },
        { ParameterType.Custom,     en = "Override target player",  de = "Anderer Zielspieler",         fr = "Autre joueur destinataire" },
        { ParameterType.Custom,     en = "Ignore reservations",     de = "Ignoriere Reservierungen",    fr = "Ignorer les réservations" },
        { ParameterType.Custom,     en = "Replace entity",          de = "Entity ersetzen",             fr = "Remplacer une entité" },
    },
}

function B_Reward_SendCart:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SendCart:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.GoodType = _Parameter
    elseif (_Index == 4) then
        self.GoodAmount = _Parameter * 1
    elseif (_Index == 5) then
        self.OverrideTargetPlayer = tonumber(_Parameter)
    elseif (_Index == 6) then
        self.IgnoreReservation = API.ToBoolean(_Parameter)
    elseif (_Index == 7) then
        self.ReplaceEntity = API.ToBoolean(_Parameter)
    end
end

function B_Reward_SendCart:CustomFunction(_Quest)

    if not IsExisting( self.ScriptNameEntity ) then
        return false;
    end

    local ID = API.SendCart(self.ScriptNameEntity, self.PlayerID, Goods[self.GoodType], self.GoodAmount, Entities[self.UnitKey], self.IgnoreReservation);

    if self.ReplaceEntity and Logic.IsBuilding(GetID(self.ScriptNameEntity)) == 0 then
        DestroyEntity(self.ScriptNameEntity);
        Logic.SetEntityName(ID, self.ScriptNameEntity);
    end
    if self.OverrideTargetPlayer then
        Logic.ResourceMerchant_OverrideTargetPlayerID(ID,self.OverrideTargetPlayer);
    end
end

function B_Reward_SendCart:GetCustomData( _Index )
    local Data = {};
    if _Index == 2 then
        Data = { "U_ResourceMerchant", "U_Medicus", "U_Marketer", "U_ThiefCart", "U_GoldCart", "U_Noblemen_Cart", "U_RegaliaCart" };
    elseif _Index == 3 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k );
            end
        end
        table.sort( Data );
    elseif _Index == 5 then
        table.insert( Data, "-" );
        for i = 1, 8 do
            table.insert( Data, i );
        end
    elseif _Index == 6 then
        table.insert( Data, "false" );
        table.insert( Data, "true" );
    elseif _Index == 7 then
        table.insert( Data, "false" );
        table.insert( Data, "true" );
    end
    return Data;
end

function B_Reward_SendCart:Debug(_Quest)
    if not IsExisting(self.ScriptNameEntity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": got a invalid playerID!");
        return true;
    elseif not Entities[self.UnitKey] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity type '"..self.UnitKey.."' is invalid!");
        return true;
    elseif not Goods[self.GoodType] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": good type '"..self.GoodType.."' is invalid!");
        return true;
    elseif not tonumber(self.GoodAmount) or self.GoodAmount < 1 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": good amount can not be below 1!");
        return true;
    elseif tonumber(self.OverrideTargetPlayer) and (self.OverrideTargetPlayer < 1 or self.OverrideTargetPlayer > 8) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": overwrite target player with invalid playerID!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_SendCart);

-- -------------------------------------------------------------------------- --

---
-- Gibt dem Auftragnehmer eine Menge an Einheiten.
--
-- Die Einheiten erscheinen an der Burg. Hat der Spieler keine Burg, dann
-- erscheinen sie vorm Lagerhaus.
--
-- @param _Type   Typ der Einheit
-- @param _Amount Menge an Einheiten
--
-- @within Reward
--
function Reward_Units(...)
    return B_Reward_Units:new(...)
end

B_Reward_Units = {
    Name = "Reward_Units",
    Description = {
        en = "Reward: Units",
        de = "Lohn: Einheiten",
        fr = "Récompense: Unités",
    },
    Parameter = {
        { ParameterType.Entity, en = "Type name", de = "Typbezeichnung", fr ="Désignation de type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr ="Quantité" },
    },
}

function B_Reward_Units:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    end
end

function B_Reward_Units:GetRewardTable()
    return { Reward.Units, assert( Entities[self.EntityName] ), self.Amount }
end

Revision:RegisterBehavior(B_Reward_Units);

-- -------------------------------------------------------------------------- --

---
-- Startet einen Quest neu.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestRestart(...)
    return B_Reward_QuestRestart:new(...)
end

B_Reward_QuestRestart = Revision.LuaBase:CopyTable(B_Reprisal_QuestRestart);
B_Reward_QuestRestart.Name = "Reward_QuestRestart";
B_Reward_QuestRestart.Description.en = "Reward: Restarts a (completed) quest so it can be triggered and completed again.";
B_Reward_QuestRestart.Description.de = "Lohn: Startet eine (beendete) Quest neu, damit diese neu ausgelöst und beendet werden kann.";
B_Reward_QuestRestart.Description.fr = "Récompense: Redémarre une quête (terminée) pour qu'elle puisse être redéclenchée et terminée.";
B_Reward_QuestRestart.GetReprisalTable = nil;

B_Reward_QuestRestart.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestRestart);

-- -------------------------------------------------------------------------- --

---
-- Lässt einen Quest fehlschlagen.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestFailure(...)
    return B_Reward_QuestFailure:new(...)
end

B_Reward_QuestFailure = Revision.LuaBase:CopyTable(B_Reprisal_QuestFailure);
B_Reward_QuestFailure.Name = "Reward_QuestFailure";
B_Reward_QuestFailure.Description.en = "Reward: Lets another active quest fail.";
B_Reward_QuestFailure.Description.de = "Lohn: Lässt eine andere aktive Quest fehlschlagen.";
B_Reward_QuestFailure.Description.fr = "Récompense: Fait échouer une autre quête active.";
B_Reward_QuestFailure.GetReprisalTable = nil;

B_Reward_QuestFailure.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestFailure);

-- -------------------------------------------------------------------------- --

---
-- Wertet einen Quest als erfolgreich.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestSuccess(...)
    return B_Reward_QuestSuccess:new(...)
end

B_Reward_QuestSuccess = Revision.LuaBase:CopyTable(B_Reprisal_QuestSuccess);
B_Reward_QuestSuccess.Name = "Reward_QuestSuccess";
B_Reward_QuestSuccess.Description.en = "Reward: Completes another active quest successfully.";
B_Reward_QuestSuccess.Description.de = "Lohn: Beendet eine andere aktive Quest erfolgreich.";
B_Reward_QuestSuccess.Description.fr = "Récompense: Termine avec succès une autre quête active.";
B_Reward_QuestSuccess.GetReprisalTable = nil;

B_Reward_QuestSuccess.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestSuccess);

-- -------------------------------------------------------------------------- --

---
-- Triggert einen Quest.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestActivate(...)
    return B_Reward_QuestActivate:new(...)
end

B_Reward_QuestActivate = Revision.LuaBase:CopyTable(B_Reprisal_QuestActivate);
B_Reward_QuestActivate.Name = "Reward_QuestActivate";
B_Reward_QuestActivate.Description.en = "Reward: Activates another quest that is not triggered yet.";
B_Reward_QuestActivate.Description.de = "Lohn: Aktiviert eine andere Quest die noch nicht ausgelöst wurde.";
B_Reward_QuestActivate.Description.fr = "Récompense: Active une autre quête qui n'a pas encore été déclenchée.";
B_Reward_QuestActivate.GetReprisalTable = nil;

B_Reward_QuestActivate.GetRewardTable = function(self, _Quest)
    return {Reward.Custom, {self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestActivate)

-- -------------------------------------------------------------------------- --

---
-- Unterbricht einen Quest.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestInterrupt(...)
    return B_Reward_QuestInterrupt:new(...)
end

B_Reward_QuestInterrupt = Revision.LuaBase:CopyTable(B_Reprisal_QuestInterrupt);
B_Reward_QuestInterrupt.Name = "Reward_QuestInterrupt";
B_Reward_QuestInterrupt.Description.en = "Reward: Interrupts another active quest without success or failure.";
B_Reward_QuestInterrupt.Description.de = "Lohn: Beendet eine andere aktive Quest ohne Erfolg oder Misserfolg.";
B_Reward_QuestInterrupt.Description.fr = "Récompense: Termine une autre quête active sans succès ni échec.";
B_Reward_QuestInterrupt.GetReprisalTable = nil;

B_Reward_QuestInterrupt.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestInterrupt);

-- -------------------------------------------------------------------------- --

---
-- Unterbricht einen Quest, selbst wenn dieser noch nicht ausgelöst wurde.
--
-- @param _QuestName   Name des Quest
-- @param _EndetQuests Bereits beendete unterbrechen
--
-- @within Reward
--
function Reward_QuestForceInterrupt(...)
    return B_Reward_QuestForceInterrupt:new(...)
end

B_Reward_QuestForceInterrupt = Revision.LuaBase:CopyTable(B_Reprisal_QuestForceInterrupt);
B_Reward_QuestForceInterrupt.Name = "Reward_QuestForceInterrupt";
B_Reward_QuestForceInterrupt.Description.en = "Reward: Interrupts another quest (even when it isn't active yet) without success or failure.";
B_Reward_QuestForceInterrupt.Description.de = "Lohn: Beendet eine andere Quest, auch wenn diese noch nicht aktiv ist ohne Erfolg oder Misserfolg.";
B_Reward_QuestForceInterrupt.Description.fr = "Récompense: Termine une autre quête, même si elle n'est pas encore active, sans succès ni échec.";
B_Reward_QuestForceInterrupt.GetReprisalTable = nil;

B_Reward_QuestForceInterrupt.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_QuestForceInterrupt);

-- -------------------------------------------------------------------------- --

---
-- Ändert den Wert einer benutzerdefinierten Variable.
--
-- Benutzerdefinierte Variablen können ausschließlich Zahlen sein. Nutze
-- dieses Behavior bevor die Variable in einem Goal oder Trigger abgefragt
-- wird, um sie zu initialisieren!
--
-- <p>Operatoren</p>
-- <ul>
-- <li>= - Variablenwert wird auf den Wert gesetzt</li>
-- <li>- - Variablenwert mit Wert Subtrahieren</li>
-- <li>+ - Variablenwert mit Wert addieren</li>
-- <li>* - Variablenwert mit Wert multiplizieren</li>
-- <li>/ - Variablenwert mit Wert dividieren</li>
-- <li>^ - Variablenwert mit Wert potenzieren</li>
-- </ul>
--
-- @param _Name     Name der Variable
-- @param _Operator Rechen- oder Zuweisungsoperator
-- @param _Value    Wert oder andere Custom Variable
--
-- @within Reward
--
function Reward_CustomVariables(...)
    return B_Reward_CustomVariables:new(...);
end

B_Reward_CustomVariables = Revision.LuaBase:CopyTable(B_Reprisal_CustomVariables);
B_Reward_CustomVariables.Name = "Reward_CustomVariables";
B_Reward_CustomVariables.Description.en = "Reward: Executes a mathematical operation with this variable. The other operand can be a number or another custom variable.";
B_Reward_CustomVariables.Description.de = "Lohn: Führt eine mathematische Operation mit der Variable aus. Der andere Operand kann eine Zahl oder eine Custom-Varible sein.";
B_Reward_CustomVariables.Description.fr = "Récompense: Effectue une opération mathématique sur la variable. L'autre opérateur peut être un nombre ou une variable personnalisée.";
B_Reward_CustomVariables.GetReprisalTable = nil;

B_Reward_CustomVariables.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} };
end

Revision:RegisterBehavior(B_Reward_CustomVariables)

-- -------------------------------------------------------------------------- --

---
-- Führt eine Funktion im Skript als Reward aus.
--
-- Wird ein Funktionsname als String übergeben, wird die Funktion mit den
-- Daten des Behavors und des zugehörigen Quest aufgerufen (Standard).
--
-- Wird eine Funktionsreferenz angegeben, wird die Funktion zusammen mit allen
-- optionalen Parametern aufgerufen, als sei es ein gewöhnlicher Aufruf im
-- Skript.
-- <pre>Reward_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
-- -- entspricht: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
-- <b>Achtung:</b> Nicht über den Assistenten verfügbar!
--
-- @param _FunctionName Name der Funktion oder Funktionsreferenz
--
-- @within Reward
--
function Reward_MapScriptFunction(...)
    return B_Reward_MapScriptFunction:new(...);
end

B_Reward_MapScriptFunction = Revision.LuaBase:CopyTable(B_Reprisal_MapScriptFunction);
B_Reward_MapScriptFunction.Name = "Reward_MapScriptFunction";
B_Reward_MapScriptFunction.Description.en = "Reward: Calls a function within the global map script if the quest has failed.";
B_Reward_MapScriptFunction.Description.de = "Lohn: Ruft eine Funktion im globalen Kartenskript auf, wenn die Quest fehlschlägt.";
B_Reward_MapScriptFunction.Description.fr = "Récompense: Invoque une fonction dans le script global de la carte en cas d'échec de la quête.";
B_Reward_MapScriptFunction.GetReprisalTable = nil;

B_Reward_MapScriptFunction.GetRewardTable = function(self, _Quest)
    return {Reward.Custom, {self, self.CustomFunction}};
end

Revision:RegisterBehavior(B_Reward_MapScriptFunction);

-- -------------------------------------------------------------------------- --

---
-- Erlaubt oder verbietet einem Spieler ein Recht.
--
-- @param _PlayerID   ID des Spielers
-- @param _Lock       Sperren/Entsperren
-- @param _Technology Name des Rechts
--
-- @within Reward
--
function Reward_Technology(...)
    return B_Reward_Technology:new(...);
end

B_Reward_Technology = Revision.LuaBase:CopyTable(B_Reprisal_Technology);
B_Reward_Technology.Name = "Reward_Technology";
B_Reward_Technology.Description.en = "Reward: Locks or unlocks a technology for the given player.";
B_Reward_Technology.Description.de = "Lohn: Sperrt oder erlaubt eine Technolgie fuer den angegebenen Player.";
B_Reward_Technology.Description.fr = "Récompense: Bloque ou autorise une technologie pour le joueur spécifié.";
B_Reward_Technology.GetReprisalTable = nil;

B_Reward_Technology.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

Revision:RegisterBehavior(B_Reward_Technology);

---
-- Gibt dem Auftragnehmer eine Anzahl an Prestigepunkten.
--
-- Prestige hat i.d.R. keine Funktion und wird nur als Zusatzpunkte in der
-- Statistik angezeigt.
--
-- @param _Amount Menge an Prestige
--
-- @within Reward
--
function Reward_PrestigePoints(...)
    return B_Reward_PrestigePoints:mew(...);
end

B_Reward_PrestigePoints  = {
    Name = "Reward_PrestigePoints",
    Description = {
        en = "Reward: Prestige",
        de = "Lohn: Prestige",
        fr = "Récompense: Prestige",
    },
    Parameter = {
        { ParameterType.Number, en = "Points", de = "Punkte", fr = "Points" },
    },
}

function B_Reward_PrestigePoints :AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Points = _Parameter
    end
end

function B_Reward_PrestigePoints :GetRewardTable()
    return { Reward.PrestigePoints, self.Points }
end

Revision:RegisterBehavior(B_Reward_PrestigePoints);

-- -------------------------------------------------------------------------- --

---
-- Besetzt einen Außenposten mit Soldaten.
--
-- @param _ScriptName Skriptname des Außenposten
-- @param _Type       Soldatentyp
--
-- @within Reward
--
function Reward_AI_MountOutpost(...)
    return B_Reward_AI_MountOutpost:new(...);
end

B_Reward_AI_MountOutpost = {
    Name = "Reward_AI_MountOutpost",
    Description = {
        en = "Reward: Places a troop of soldiers on a named outpost.",
        de = "Lohn: Platziert einen Trupp Soldaten auf einem Aussenposten der KI.",
        fr = "Récompense: Place un groupe de soldats sur un avant-poste de l'IA.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name",   de = "Skriptname",  fr = "Nom de l'entité" },
        { ParameterType.Custom,     en = "Soldiers type", de = "Soldatentyp", fr = "Type de soldat" },
    },
}

function B_Reward_AI_MountOutpost:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_MountOutpost:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.Scriptname = _Parameter
    else
        self.SoldiersType = _Parameter
    end
end

function B_Reward_AI_MountOutpost:CustomFunction(_Quest)
    local outpostID = assert(
        not Logic.IsEntityDestroyed(self.Scriptname) and GetID(self.Scriptname),
       _Quest.Identifier .. ": Error in " .. self.Name .. ": CustomFunction: Outpost is invalid"
    )
    local AIPlayerID = Logic.EntityGetPlayer(outpostID)
    local ax, ay = Logic.GetBuildingApproachPosition(outpostID)
    local TroopID = Logic.CreateBattalionOnUnblockedLand(Entities[self.SoldiersType], ax, ay, 0, AIPlayerID, 0)
    AICore.HideEntityFromAI(AIPlayerID, TroopID, true)
    Logic.CommandEntityToMountBuilding(TroopID, outpostID)
end

function B_Reward_AI_MountOutpost:GetCustomData(_Index)
    if _Index == 1 then
        local Data = {}
        for k,v in pairs(Entities) do
            if string.find(k, "U_MilitaryBandit") or string.find(k, "U_MilitarySword") or string.find(k, "U_MilitaryBow") then
                Data[#Data+1] = k
            end
        end
        return Data
    end
end

function B_Reward_AI_MountOutpost:Debug(_Quest)
    if Logic.IsEntityDestroyed(self.Scriptname) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Outpost " .. self.Scriptname .. " is missing")
        return true
    end
end

Revision:RegisterBehavior(B_Reward_AI_MountOutpost)

-- -------------------------------------------------------------------------- --

---
-- Startet einen Quest neu und lößt ihn sofort aus.
--
-- @param _QuestName Name des Quest
--
-- @within Reward
--
function Reward_QuestRestartForceActive(...)
    return B_Reward_QuestRestartForceActive:new(...);
end

B_Reward_QuestRestartForceActive = {
    Name = "Reward_QuestRestartForceActive",
    Description = {
        en = "Reward: Restarts a (completed) quest and triggers it immediately.",
        de = "Lohn: Startet eine (beendete) Quest neu und triggert sie sofort.",
        fr = "Récompense: Redémarre une quête (terminée) et la déclenche immédiatement.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la quête" },
    },
}

function B_Reward_QuestRestartForceActive:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_QuestRestartForceActive:AddParameter(_Index, _Parameter)
    self.QuestName = _Parameter
end

function B_Reward_QuestRestartForceActive:CustomFunction(_Quest)
    local QuestID, Quest = self:ResetQuest(_Quest);
    if QuestID then
        Quest:SetMsgKeyOverride();
        Quest:SetIconOverride();
        Quest:Trigger();
    end
end

B_Reward_QuestRestartForceActive.ResetQuest = B_Reward_QuestRestart.CustomFunction;
function B_Reward_QuestRestartForceActive:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Quest: "..  self.QuestName .. " does not exist");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Reward_QuestRestartForceActive)

-- -------------------------------------------------------------------------- --

---
-- Baut das angegebene Gabäude um eine Stufe aus. Das Gebäude wird durch einen
-- Arbeiter um eine Stufe erweitert. Der Arbeiter muss zuerst aus dem Lagerhaus
-- kommen und sich zum Gebäude bewegen.
--
-- <b>Achtung:</b> Ein Gebäude muss erst fertig ausgebaut sein, bevor ein
-- weiterer Ausbau begonnen werden kann!
--
-- @param _ScriptName Skriptname des Gebäudes
--
-- @within Reward
--
function Reward_UpgradeBuilding(...)
    return B_Reward_UpgradeBuilding:new(...);
end

B_Reward_UpgradeBuilding = {
    Name = "Reward_UpgradeBuilding",
    Description = {
        en = "Reward: Upgrades a building",
        de = "Lohn: Baut ein Gebäude aus",
        fr = "Récompense: Améliore un Bâtiment",
    },
    Parameter =    {
        { ParameterType.ScriptName, en = "Building", de = "Gebäude", fr = "Bâtiment" }
    }
};

function B_Reward_UpgradeBuilding:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction}};
end

function B_Reward_UpgradeBuilding:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.Building = _Parameter;
    end
end

function B_Reward_UpgradeBuilding:CustomFunction(_Quest)
    local building = GetID(self.Building);
    if building ~= 0
    and Logic.IsBuilding(building) == 1
    and Logic.IsBuildingUpgradable(building, true)
    and Logic.IsBuildingUpgradable(building, false)
    then
        Logic.UpgradeBuilding(building);
    end
end

function B_Reward_UpgradeBuilding:Debug(_Quest)
    local building = GetID(self.Building);
    if not (building ~= 0
            and Logic.IsBuilding(building) == 1
            and Logic.IsBuildingUpgradable(building, true)
            and Logic.IsBuildingUpgradable(building, false) )
    then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Building is wrong")
        return true
    end
end

Revision:RegisterBehavior(B_Reward_UpgradeBuilding)

---
-- Setzt das Upgrade Level des angegebenen Gebäudes.
--
-- Ein Geböude erhält sofort eine neue Stufe, ohne dass ein Arbeiter kommen
-- und es ausbauen muss. Für eine Werkstatt wird ein neuer Arbeiter gespawnt.
--
-- @param _ScriptName Skriptname des Gebäudes
-- @param _Level Upgrade Level
--
-- @within Reward
--
function Reward_SetBuildingUpgradeLevel(...)
    return B_Reward_SetBuildingUpgradeLevel:new(...);
end

B_Reward_SetBuildingUpgradeLevel = {
	Name = "Reward_SetBuildingUpgradeLevel",
	Description = {
		en = "Reward: Sets the upgrade level of the specified building.",
		de = "Lohn: Legt das Upgrade-Level eines Gebaeudes fest.",
        fr = "Récompense: Définit le niveau d'amélioration d'un bâtiment.",
	},
	Parameter = {
		{ ParameterType.ScriptName, en = "Building",        de = "Gebäude",         fr = "Bâtiment" },
		{ ParameterType.Custom,     en = "Upgrade level",   de = "Upgrade-Level",   fr = "Niveau d'amélioration" },
	}
};
 
function B_Reward_SetBuildingUpgradeLevel:GetRewardTable()
	return {Reward.Custom, self, self.CustomFunction};
end
 
function B_Reward_SetBuildingUpgradeLevel:AddParameter(_Index, _Parameter)
	if _Index == 0 then
		self.Building = _Parameter;
	elseif _Index == 1 then
		self.UpgradeLevel = tonumber(_Parameter);
	end
end
 
function B_Reward_SetBuildingUpgradeLevel:CustomFunction()
	local building = Logic.GetEntityIDByName(self.Building);
	local upgradeLevel = Logic.GetUpgradeLevel(building);
	local maxUpgradeLevel = Logic.GetMaxUpgradeLevel(building);
	if building ~= 0 
	and Logic.IsBuilding(building) == 1 
	and (Logic.IsBuildingUpgradable(building, true) 
	or (maxUpgradeLevel ~= 0 
	and maxUpgradeLevel == upgradeLevel)) 
	then
		Logic.SetUpgradableBuildingState(building, math.min(self.UpgradeLevel, maxUpgradeLevel), 0);
	end
end

function B_Reward_SetBuildingUpgradeLevel:Debug(_Quest)
	local building = Logic.GetEntityIDByName( self.Building )
	local maxUpgradeLevel = Logic.GetMaxUpgradeLevel(building);
	if not building or Logic.IsBuilding(building) == 0  then
		error(_Quest.Identifier.. ": " ..self.Name .. ": Building " .. self.Building .. " is missing or no building.")
		return true
	elseif not self.UpgradeLevel or self.UpgradeLevel < 0 then
		error(_Quest.Identifier.. ": " ..self.Name .. ": Upgrade level is wrong")
		return true
	end
end

function B_Reward_SetBuildingUpgradeLevel:GetCustomData(_Index)
    if _Index == 1 then
        return { "0", "1", "2", "3" };
    end
end

Revision:RegisterBehavior(B_Reward_SetBuildingUpgradeLevel);

-- -------------------------------------------------------------------------- --
-- TRIGGERS

---
-- Starte den Quest, wenn ein anderer Spieler entdeckt wurde.
--
-- Ein Spieler ist dann entdeckt, wenn sein Heimatterritorium aufgedeckt wird.
--
-- @param _PlayerID Zu entdeckender Spieler
--
-- @within Trigger
--
function Trigger_PlayerDiscovered(...)
    return B_Trigger_PlayerDiscovered:new(...);
end

B_Trigger_PlayerDiscovered = {
    Name = "Trigger_PlayerDiscovered",
    Description = {
        en = "Trigger: if a given player has been discovered",
        de = "Auslöser: wenn ein angegebener Spieler entdeckt wurde",
        fr = "Déclencheur: lorsqu'un joueur spécifié est découvert",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Trigger_PlayerDiscovered:GetTriggerTable()
    return {Triggers.PlayerDiscovered, self.PlayerID}
end

function B_Trigger_PlayerDiscovered:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1;
    end
end

Revision:RegisterBehavior(B_Trigger_PlayerDiscovered);

-- -------------------------------------------------------------------------- --

---
-- Starte den Quest, wenn zwischen dem Empfänger und der angegebenen Partei
-- der geforderte Diplomatiestatus herrscht.
--
-- @param _PlayerID ID der Partei
-- @param _State    Diplomatie-Status
--
-- @within Trigger
--
function Trigger_OnDiplomacy(...)
    return B_Trigger_OnDiplomacy:new(...);
end

B_Trigger_OnDiplomacy = {
    Name = "Trigger_OnDiplomacy",
    Description = {
        en = "Trigger: if diplomatic relations have been established with a player",
        de = "Auslöser: wenn ein angegebener Diplomatie-Status mit einem Spieler erreicht wurde.",
        fr = "Déclencheur: lorsqu'un statut diplomatique spécifié a été atteint avec un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID,       en = "Player",      de = "Spieler",     fr = "Joueur" },
        { ParameterType.DiplomacyState, en = "Relation",    de = "Beziehung",   fr = "Relation diplomatique" },
    },
}

function B_Trigger_OnDiplomacy:GetTriggerTable()
    return {Triggers.Diplomacy, self.PlayerID, assert( DiplomacyStates[self.DiplState] ) }
end

function B_Trigger_OnDiplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.DiplState = _Parameter
    end
end

Revision:RegisterBehavior(B_Trigger_OnDiplomacy);

-- -------------------------------------------------------------------------- --

---
-- Starte den Quest, sobald ein Bedürfnis nicht erfüllt wird.
--
-- @param _PlayerID ID des Spielers
-- @param _Need     Bedürfnis
-- @param _Amount   Menge an skreikenden Siedlern
--
-- @within Trigger
--
function Trigger_OnNeedUnsatisfied(...)
    return B_Trigger_OnNeedUnsatisfied:new(...);
end

B_Trigger_OnNeedUnsatisfied = {
    Name = "Trigger_OnNeedUnsatisfied",
    Description = {
        en = "Trigger: if a specified need is unsatisfied",
        de = "Auslöser: wenn ein bestimmtes Beduerfnis nicht befriedigt ist.",
        fr = "Déclencheur: lorsqu'un certain besoin n'est pas satisfait.",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "Player",              de = "Spieler",             fr = "Joueur" },
        { ParameterType.Need,       en = "Need",                de = "Beduerfnis",          fr = "Besoin" },
        { ParameterType.Number,     en = "Workers on strike",   de = "Streikende Arbeiter", fr = "Travailleurs en grève" },
    },
}

function B_Trigger_OnNeedUnsatisfied:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnNeedUnsatisfied:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Need = _Parameter
    elseif (_Index == 2) then
        self.WorkersOnStrike = _Parameter * 1
    end
end

function B_Trigger_OnNeedUnsatisfied:CustomFunction(_Quest)
    return Logic.GetNumberOfStrikingWorkersPerNeed( self.PlayerID, Needs[self.Need] ) >= self.WorkersOnStrike
end

function B_Trigger_OnNeedUnsatisfied:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": " .. self.PlayerID .. " does not exist.")
        return true
    elseif not Needs[self.Need] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": " .. self.Need .. " does not exist.")
        return true
    elseif self.WorkersOnStrike < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": WorkersOnStrike value negative")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_OnNeedUnsatisfied);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, wenn die angegebene Mine erschöpft ist.
--
-- @param _ScriptName Skriptname der Mine
--
-- @within Trigger
--
function Trigger_OnResourceDepleted(...)
    return B_Trigger_OnResourceDepleted:new(...);
end

B_Trigger_OnResourceDepleted = {
    Name = "Trigger_OnResourceDepleted",
    Description = {
        en = "Trigger: if a resource is (temporarily) depleted",
        de = "Auslöser: wenn eine Ressource (zeitweilig) verbraucht ist",
        fr = "Déclencheur: lorsqu'une ressource est (temporairement) consommée",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de script" },
    },
}

function B_Trigger_OnResourceDepleted:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnResourceDepleted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Trigger_OnResourceDepleted:CustomFunction(_Quest)
    local ID = GetID(self.ScriptName)
    return not ID or ID == 0 or Logic.GetResourceDoodadGoodType(ID) == 0 or Logic.GetResourceDoodadGoodAmount(ID) == 0
end

Revision:RegisterBehavior(B_Trigger_OnResourceDepleted);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald der angegebene Spieler eine Menge an Rohstoffen
-- im Lagerhaus hat.
--
-- @param  _PlayerID ID des Spielers
-- @param  _Type     Typ des Rohstoffes
-- @param _Amount    Menge an Rohstoffen
--
-- @within Trigger
--
function Trigger_OnAmountOfGoods(...)
    return B_Trigger_OnAmountOfGoods:new(...);
end

B_Trigger_OnAmountOfGoods = {
    Name = "Trigger_OnAmountOfGoods",
    Description = {
        en = "Trigger: if the player has gathered a given amount of resources in his storehouse",
        de = "Auslöser: wenn der Spieler eine bestimmte Menge einer Ressource in seinem Lagerhaus hat",
        fr = "Déclencheur: lorsque le joueur a une certaine quantité d'une ressource dans son entrepôt",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "Player",          de = "Spieler",             fr = "Joueur" },
        { ParameterType.RawGoods,   en = "Type of good",    de = "Resourcentyp",        fr = "Type de ressources" },
        { ParameterType.Number,     en = "Amount of good",  de = "Anzahl der Resource", fr = "Quantité de ressources" },
    },
}

function B_Trigger_OnAmountOfGoods:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnAmountOfGoods:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 2) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Trigger_OnAmountOfGoods:CustomFunction(_Quest)
    local StoreHouseID = Logic.GetStoreHouse(self.PlayerID)
    if (StoreHouseID == 0) then
        return false
    end
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    local GoodAmount = Logic.GetAmountOnOutStockByGoodType(StoreHouseID, GoodType)
    if (GoodAmount >= self.GoodAmount)then
        return true
    end
    return false
end

function B_Trigger_OnAmountOfGoods:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": " .. self.PlayerID .. " does not exist.")
        return true
    elseif not Goods[self.GoodTypeName] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Good type is wrong.")
        return true
    elseif self.GoodAmount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Good amount is negative.")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_OnAmountOfGoods);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald ein anderer aktiv ist.
--
-- @param _QuestName Name des Quest
-- @param _Time      Wartezeit
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestActive(...)
    return B_Trigger_OnQuestActiveWait:new(...);
end
Trigger_OnQuestActiveWait = Trigger_OnQuestActive;

B_Trigger_OnQuestActiveWait = {
    Name = "Trigger_OnQuestActiveWait",
    Description = {
        en = "Trigger: if a given quest has been activated. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest aktiviert wurde. Optional mit Wartezeit",
        fr = "Déclencheur: lorsqu'une quête indiquée a été activée. En option avec délai d'attente",
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestActiveWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestActiveWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestActiveWait:CustomFunction(_Quest)
    local QuestID = GetQuestID(self.QuestName)
    if QuestID ~= nil then
        assert(type(QuestID) == "number");

        if (Quests[QuestID].State == QuestState.Active) then
            self.WasActivated = self.WasActivated or true;
        end
        if self.WasActivated then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestActiveWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        error(_Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestActiveWait:Interrupt(_Quest)
    -- does this realy matter after interrupt?
    -- self.WaitTimeTimer = nil;
    -- self.WasActivated = nil;
end

function B_Trigger_OnQuestActiveWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
    self.WasActivated = nil;
end

Revision:RegisterBehavior(B_Trigger_OnQuestActiveWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestActive = Revision.LuaBase:CopyTable(B_Trigger_OnQuestActiveWait);
B_Trigger_OnQuestActive.Name = "Trigger_OnQuestActive";
B_Trigger_OnQuestActive.Description.en = "Trigger: Starts the quest after another has been activated.";
B_Trigger_OnQuestActive.Description.de = "Auslöser: Startet den Quest, wenn ein anderer aktiviert wird.";
B_Trigger_OnQuestActive.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre est activée.";
B_Trigger_OnQuestActive.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestActive:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

Revision:RegisterBehavior(B_Trigger_OnQuestActive);

-- -------------------------------------------------------------------------- --

---
-- Startet einen Quest, sobald ein anderer fehlschlägt.
--
-- @param _QuestName Name des Quest
-- @param _Time      Wartezeit
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestFailure(...)
    return B_Trigger_OnQuestFailureWait:new(...);
end
Trigger_OnQuestFailureWait = Trigger_OnQuestFailure;

B_Trigger_OnQuestFailureWait = {
    Name = "Trigger_OnQuestFailureWait",
    Description = {
        en = "Trigger: if a given quest has failed. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest fehlgeschlagen ist. Optional mit Wartezeit",
        fr = "Déclencheur: lorsqu'une quête indiquée a échoué. En option avec délai d'attente",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,    en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestFailureWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestFailureWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestFailureWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].Result == QuestResult.Failure) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestFailureWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        error(_Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestFailureWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestFailureWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

Revision:RegisterBehavior(B_Trigger_OnQuestFailureWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestFailure = Revision.LuaBase:CopyTable(B_Trigger_OnQuestFailureWait);
B_Trigger_OnQuestFailure.Name = "Trigger_OnQuestFailure";
B_Trigger_OnQuestFailure.Description.en = "Trigger: Starts the quest after another has failed.";
B_Trigger_OnQuestFailure.Description.de = "Auslöser: Startet den Quest, wenn ein anderer fehlschlägt.";
B_Trigger_OnQuestFailure.Description.fr = "Déclencheur: Lance la quête lorsqu'une autre échoue.";
B_Trigger_OnQuestFailure.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestFailure:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

Revision:RegisterBehavior(B_Trigger_OnQuestFailure);

-- -------------------------------------------------------------------------- --

---
-- Startet einen Quest, wenn ein anderer noch nicht ausgelöst wurde.
--
-- @param _QuestName Name des Quest
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestNotTriggered(...)
    return B_Trigger_OnQuestNotTriggered:new(...);
end

B_Trigger_OnQuestNotTriggered = {
    Name = "Trigger_OnQuestNotTriggered",
    Description = {
        en = "Trigger: if a given quest is not yet active. Should be used in combination with other triggers.",
        de = "Auslöser: wenn eine angegebene Quest noch inaktiv ist. Sollte mit weiteren Triggern kombiniert werden.",
        fr = "Déclencheur: lorsqu'une quête indiquée est encore inactive. Doit être combiné avec d'autres déclencheurs."
    },
    Parameter = {
        { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
    },
}

function B_Trigger_OnQuestNotTriggered:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestNotTriggered:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Trigger_OnQuestNotTriggered:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.NotTriggered) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnQuestNotTriggered:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_OnQuestNotTriggered);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald ein anderer unterbrochen wurde.
--
-- @param _QuestName Name des Quest
-- @param _Time      Wartezeit
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestInterrupted(...)
    return B_Trigger_OnQuestInterruptedWait:new(...);
end
Trigger_OnQuestInterruptedWait = Trigger_OnQuestInterrupted;

B_Trigger_OnQuestInterruptedWait = {
    Name = "Trigger_OnQuestInterruptedWait",
    Description = {
        en = "Trigger: if a given quest has been interrupted. Should be used in combination with other triggers.",
        de = "Auslöser: wenn eine angegebene Quest abgebrochen wurde. Sollte mit weiteren Triggern kombiniert werden.",
        fr = "Déclencheur: lorsqu'une quête indiquée a été interrompue. Doit être combiné avec d'autres déclencheurs."
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente"},
    },
}

function B_Trigger_OnQuestInterruptedWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestInterruptedWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestInterruptedWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.Over and Quests[QuestID].Result == QuestResult.Interrupted) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestInterruptedWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        error(_Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestInterruptedWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestInterruptedWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

Revision:RegisterBehavior(B_Trigger_OnQuestInterruptedWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestInterrupted = Revision.LuaBase:CopyTable(B_Trigger_OnQuestInterruptedWait);
B_Trigger_OnQuestInterrupted.Name = "Trigger_OnQuestInterrupted";
B_Trigger_OnQuestInterrupted.Description.en = "Trigger: Starts the quest after another is interrupted.";
B_Trigger_OnQuestInterrupted.Description.de = "Auslöser: Startet den Quest, wenn ein anderer abgebrochen wurde.";
B_Trigger_OnQuestInterrupted.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre a été annulée.";
B_Trigger_OnQuestInterrupted.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestInterrupted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

Revision:RegisterBehavior(B_Trigger_OnQuestInterrupted);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald ein anderer bendet wurde.
--
-- Dabei ist das Resultat egal. Der Quest kann entweder erfolgreich beendet
-- wurden oder fehlgeschlagen sein.
--
-- @param _QuestName Name des Quest
-- @param _Time      Wartezeit
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestOver(...)
    return B_Trigger_OnQuestOverWait:new(...);
end
Trigger_OnQuestOverWait = Trigger_OnQuestOver;

B_Trigger_OnQuestOverWait = {
    Name = "Trigger_OnQuestOverWait",
    Description = {
        en = "Trigger: if a given quest has been finished, regardless of its result. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest beendet wurde, unabhängig von deren Ergebnis. Wartezeit optional",
        fr = "Déclencheur: lorsqu'une quête indiquée est terminée, indépendamment de son résultat. Délai d'attente optionnel"
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente"},
    },
}

function B_Trigger_OnQuestOverWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestOverWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestOverWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.Over and Quests[QuestID].Result ~= QuestResult.Interrupted) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestOverWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        error(_Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestOverWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestOverWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

Revision:RegisterBehavior(B_Trigger_OnQuestOverWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestOver = Revision.LuaBase:CopyTable(B_Trigger_OnQuestOverWait);
B_Trigger_OnQuestOver.Name = "Trigger_OnQuestOver";
B_Trigger_OnQuestOver.Description.en = "Trigger: Starts the quest after another finished.";
B_Trigger_OnQuestOver.Description.de = "Auslöser: Startet den Quest, wenn ein anderer abgeschlossen wurde.";
B_Trigger_OnQuestOver.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre est terminée.";
B_Trigger_OnQuestOver.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestOver:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

Revision:RegisterBehavior(B_Trigger_OnQuestOver);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald ein anderer Quest erfolgreich abgeschlossen wurde.
--
-- @param _QuestName Name des Quest
-- @param _Time      Wartezeit
-- return Table mit Behavior
-- @within Trigger
--
function Trigger_OnQuestSuccess(...)
    return B_Trigger_OnQuestSuccessWait:new(...);
end
Trigger_OnQuestSuccessWait = Trigger_OnQuestSuccess;

B_Trigger_OnQuestSuccessWait = {
    Name = "Trigger_OnQuestSuccessWait",
    Description = {
        en = "Trigger: if a given quest has been finished successfully. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest erfolgreich abgeschlossen wurde. Wartezeit optional",
        fr = "Déclencheur: lorsqu'une quête indiquée a été accomplie avec succès. Délai d'attente optionnel",
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestSuccessWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestSuccessWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestSuccessWait:CustomFunction()
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].Result == QuestResult.Success) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestSuccessWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        error(_Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        error(_Quest.Identifier.. ": " ..self.Name..": waittime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestSuccessWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestSuccessWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

Revision:RegisterBehavior(B_Trigger_OnQuestSuccessWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestSuccess = Revision.LuaBase:CopyTable(B_Trigger_OnQuestSuccessWait);
B_Trigger_OnQuestSuccess.Name = "Trigger_OnQuestSuccess";
B_Trigger_OnQuestSuccess.Description.en = "Trigger: Starts the quest after another finished successfully.";
B_Trigger_OnQuestSuccess.Description.de = "Auslöser: Startet den Quest, wenn ein anderer erfolgreich abgeschlossen wurde.";
B_Trigger_OnQuestSuccess.Description.de = "Déclencheur: Démarre la quête lorsqu'une autre a été accomplie avec succès.";
B_Trigger_OnQuestSuccess.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestSuccess:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

Revision:RegisterBehavior(B_Trigger_OnQuestSuccess);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, wenn eine benutzerdefinierte Variable einen bestimmten
-- Wert angenommen hat.
--
-- Benutzerdefinierte Variablen müssen Zahlen sein. Bevor eine
-- Variable in einem Goal abgefragt werden kann, muss sie zuvor mit
-- Reprisal_CustomVariables oder Reward_CutsomVariables initialisiert
-- worden sein.
--
-- @param _Name     Name der Variable
-- @param _Relation Vergleichsoperator
-- @param _Value    Wert oder Custom Variable
--
-- @within Trigger
--
function Trigger_CustomVariables(...)
    return B_Trigger_CustomVariables:new(...);
end

B_Trigger_CustomVariables = {
    Name = "Trigger_CustomVariables",
    Description = {
        en = "Trigger: if the variable has a certain value.",
        de = "Auslöser: wenn die Variable einen bestimmen Wert eingenommen hat.",
        fr = "Déclencheur: lorsque la variable a pris une valeur déterminée."
    },
    Parameter = {
        { ParameterType.Default, en = "Name of Variable",   de = "Variablennamen",  fr = "Noms de variables" },
        { ParameterType.Custom,  en = "Relation",           de = "Relation",        fr = "Relation" },
        { ParameterType.Default, en = "Value",              de = "Wert",            fr = "Valeur" }
    }
};

function B_Trigger_CustomVariables:GetTriggerTable()
    return { Triggers.Custom2, {self, self.CustomFunction} };
end

function B_Trigger_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Relation = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        value = (value ~= nil and value) or _Parameter;
        self.Value = value
    end
end

function B_Trigger_CustomVariables:CustomFunction()
    local Value1 = API.ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = API.ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Relation == "==" then
        return Value1 == Value2;
    elseif self.Relation ~= "~=" then
        return Value1 ~= Value2;
    elseif self.Relation == ">" then
        return Value1 > Value2;
    elseif self.Relation == ">=" then
        return Value1 >= Value2;
    elseif self.Relation == "<=" then
        return Value1 <= Value2;
    else
        return Value1 < Value2;
    end
    return false;
end

function B_Trigger_CustomVariables:GetCustomData( _Index )
    if _Index == 1 then
        return {"==", "~=", "<=", "<", ">", ">="};
    end
end

function B_Trigger_CustomVariables:Debug(_Quest)
    local relations = {"==", "~=", "<=", "<", ">", ">="}
    local results    = {true, false, nil}

    if not API.ObtainCustomVariable("BehaviorVariable_" ..self.VariableName) then
        warn(_Quest.Identifier.. ": " ..self.Name..": variable '"..self.VariableName.."' do not exist!");
    end
    if not table.contains(relations, self.Relation) then
        error(_Quest.Identifier.. ": " ..self.Name..": '"..self.Relation.."' is an invalid relation!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_CustomVariables)

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest sofort.
--
-- @within Trigger
--
function Trigger_AlwaysActive()
    return B_Trigger_AlwaysActive:new()
end

B_Trigger_AlwaysActive = {
    Name = "Trigger_AlwaysActive",
    Description = {
        en = "Trigger: the map has been started.",
        de = "Auslöser: Start der Karte.",
        fr = "Déclencheur: Démarrage de la carte.",
    },
}

function B_Trigger_AlwaysActive:GetTriggerTable()
    return {Triggers.Time, 0 }
end

Revision:RegisterBehavior(B_Trigger_AlwaysActive);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest im angegebenen Monat.
--
-- @param _Month Monat
--
-- @within Trigger
--
function Trigger_OnMonth(...)
    return B_Trigger_OnMonth:new(...);
end

B_Trigger_OnMonth = {
    Name = "Trigger_OnMonth",
    Description = {
        en = "Trigger: a specified month",
        de = "Auslöser: ein bestimmter Monat",
        fr = "Déclencheur: un mois donné"
    },
    Parameter = {
        { ParameterType.Custom, en = "Month", de = "Monat", fr = "Mois" },
    },
}

function B_Trigger_OnMonth:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnMonth:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Month = _Parameter * 1
    end
end

function B_Trigger_OnMonth:CustomFunction(_Quest)
    return self.Month == Logic.GetCurrentMonth()
end

function B_Trigger_OnMonth:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for i = 1, 12 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Trigger_OnMonth:Debug(_Quest)
    if self.Month < 1 or self.Month > 12 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Month has the wrong value")
        return true
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_OnMonth);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest sobald der Monsunregen einsetzt.
--
-- <b>Achtung:</b> Dieses Behavior ist nur für Reich des Ostens verfügbar.
--
-- @within Trigger
--
function Trigger_OnMonsoon()
    return B_Trigger_OnMonsoon:new();
end

B_Trigger_OnMonsoon = {
    Name = "Trigger_OnMonsoon",
    Description = {
        en = "Trigger: on monsoon.",
        de = "Auslöser: wenn der Monsun beginnt.",
        fr = "Déclencheur: lorsque la mousson commence.",
    },
    RequiresExtraNo = 1,
}

function B_Trigger_OnMonsoon:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnMonsoon:CustomFunction(_Quest)
    if Logic.GetWeatherDoesShallowWaterFlood(0) then
        return true
    end
end

Revision:RegisterBehavior(B_Trigger_OnMonsoon);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest sobald der Timer abgelaufen ist.
--
-- Der Timer zählt immer vom Start der Map an.
--
-- @param _Time Zeit bis zum Start
--
-- @within Trigger
--
function Trigger_Time(...)
    return B_Trigger_Time:new(...);
end

B_Trigger_Time = {
    Name = "Trigger_Time",
    Description = {
        en = "Trigger: a given amount of time since map start",
        de = "Auslöser: eine gewisse Anzahl Sekunden nach Spielbeginn",
        fr = "Déclencheur: un certain nombre de secondes après le début du jeu",
    },
    Parameter = {
        { ParameterType.Number, en = "Time (sec.)", de = "Zeit (Sek.)", fr = "Temps (sec.)" },
    },
}

function B_Trigger_Time:GetTriggerTable()
    return {Triggers.Time, self.Time }
end

function B_Trigger_Time:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Time = _Parameter * 1
    end
end

Revision:RegisterBehavior(B_Trigger_Time);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest sobald das Wasser gefriert.
--
-- @within Trigger
--
function Trigger_OnWaterFreezes()
    return B_Trigger_OnWaterFreezes:new();
end

B_Trigger_OnWaterFreezes = {
    Name = "Trigger_OnWaterFreezes",
    Description = {
        en = "Trigger: if the water starts freezing",
        de = "Auslöser: wenn die Gewässer gefrieren",
        fr = "Déclencheur: lorsque les eaux gèlent",
    },
}

function B_Trigger_OnWaterFreezes:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnWaterFreezes:CustomFunction(_Quest)
    if Logic.GetWeatherDoesWaterFreeze(0) then
        return true
    end
end

Revision:RegisterBehavior(B_Trigger_OnWaterFreezes);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest niemals.
--
-- Quests, für die dieser Trigger gesetzt ist, müssen durch einen anderen
-- Quest über Reward_QuestActive oder Reprisal_QuestActive gestartet werden.
--
-- @within Trigger
--
function Trigger_NeverTriggered()
    return B_Trigger_NeverTriggered:new();
end

B_Trigger_NeverTriggered = {
    Name = "Trigger_NeverTriggered",
    Description = {
        en = "Trigger: Never triggers a Quest. The quest may be set active by Reward_QuestActivate or Reward_QuestRestartForceActive",
        de = "Auslöser: Löst nie eine Quest aus. Die Quest kann von Reward_QuestActivate oder Reward_QuestRestartForceActive aktiviert werden.",
        fr = "Déclencheur: Ne déclenche jamais de quête. La quête peut être activée par Reward_QuestActivate ou Reward_QuestRestartForceActive.",
    },
}

function B_Trigger_NeverTriggered:GetTriggerTable()

    return {Triggers.Custom2, {self, function() end} }

end

Revision:RegisterBehavior(B_Trigger_NeverTriggered)

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald wenigstens einer von zwei Quests fehlschlägt.
--
-- @param _QuestName1 Name des ersten Quest
-- @param _QuestName2 Name des zweiten Quest
--
-- @within Trigger
--
function Trigger_OnAtLeastOneQuestFailure(...)
    return B_Trigger_OnAtLeastOneQuestFailure:new(...);
end

B_Trigger_OnAtLeastOneQuestFailure = {
    Name = "Trigger_OnAtLeastOneQuestFailure",
    Description = {
        en = "Trigger: if one or both of the given quests have failed.",
        de = "Auslöser: wenn einer oder beide der angegebenen Aufträge fehlgeschlagen sind.",
        fr = "Déclencheur: si l'une des quêtes indiquées ou les deux ont échoué.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2" },
    },
}

function B_Trigger_OnAtLeastOneQuestFailure:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnAtLeastOneQuestFailure:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnAtLeastOneQuestFailure:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Failure)
    or (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Failure) then
        return true;
    end
    return false;
end

function B_Trigger_OnAtLeastOneQuestFailure:Debug(_Quest)
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

Revision:RegisterBehavior(B_Trigger_OnAtLeastOneQuestFailure);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald wenigstens einer von zwei Quests erfolgreich ist.
--
-- @param _QuestName1 Name des ersten Quest
-- @param _QuestName2 Name des zweiten Quest
--
-- @within Trigger
--
function Trigger_OnAtLeastOneQuestSuccess(...)
    return B_Trigger_OnAtLeastOneQuestSuccess:new(...);
end

B_Trigger_OnAtLeastOneQuestSuccess = {
    Name = "Trigger_OnAtLeastOneQuestSuccess",
    Description = {
        en = "Trigger: if one or both of the given quests are won.",
        de = "Auslöser: wenn einer oder beide der angegebenen Aufträge gewonnen wurden.",
        fr = "Déclencheur : si une ou les deux missions indiquées ont été gagnées.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2" },
    },
}

function B_Trigger_OnAtLeastOneQuestSuccess:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnAtLeastOneQuestSuccess:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnAtLeastOneQuestSuccess:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Success)
    or (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Success) then
        return true;
    end
    return false;
end

function B_Trigger_OnAtLeastOneQuestSuccess:Debug(_Quest)
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

Revision:RegisterBehavior(B_Trigger_OnAtLeastOneQuestSuccess);

-- -------------------------------------------------------------------------- --

---
-- Startet den Quest, sobald mindestens X von Y Quests erfolgreich sind.
--
-- @param _MinAmount   Mindestens zu erfüllen (max. 5)
-- @param _QuestAmount Anzahl geprüfter Quests (max. 5 und >= _MinAmount)
-- @param _Quest1      Name des 1. Quest
-- @param _Quest2      Name des 2. Quest
-- @param _Quest3      Name des 3. Quest
-- @param _Quest4      Name des 4. Quest
-- @param _Quest5      Name des 5. Quest
--
-- @within Trigger
--
function Trigger_OnAtLeastXOfYQuestsSuccess(...)
    return B_Trigger_OnAtLeastXOfYQuestsSuccess:new(...);
end

B_Trigger_OnAtLeastXOfYQuestsSuccess = {
    Name = "Trigger_OnAtLeastXOfYQuestsSuccess",
    Description = {
        en = "Trigger: if at least X of Y given quests has been finished successfully.",
        de = "Auslöser: wenn X von Y angegebener Quests erfolgreich abgeschlossen wurden.",
        fr = "Déclencheur: lorsque X des Y quêtes indiquées ont été accomplies avec succès.",
    },
    Parameter = {
        { ParameterType.Custom, en = "Least Amount", de = "Mindest Anzahl", fr = "Nombre minimum" },
        { ParameterType.Custom, en = "Quest Amount", de = "Quest Anzahl",   fr = "Nombre de quêtes" },
        { ParameterType.QuestName, en = "Quest name 1", de = "Questname 1", fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest name 2", de = "Questname 2", fr = "Nom de la quête 2" },
        { ParameterType.QuestName, en = "Quest name 3", de = "Questname 3", fr = "Nom de la quête 3" },
        { ParameterType.QuestName, en = "Quest name 4", de = "Questname 4", fr = "Nom de la quête 4" },
        { ParameterType.QuestName, en = "Quest name 5", de = "Questname 5", fr = "Nom de la quête 5" },
    },
}

function B_Trigger_OnAtLeastXOfYQuestsSuccess:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnAtLeastXOfYQuestsSuccess:AddParameter(_Index, _Parameter)
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

function B_Trigger_OnAtLeastXOfYQuestsSuccess:CustomFunction()
    local least = 0
    for i = 1, self.QuestAmount do
        local QuestID = GetQuestID(self["QuestName"..i]);
        if IsValidQuest(QuestID) then
			if (Quests[QuestID].Result == QuestResult.Success) then
				least = least + 1
				if least >= self.LeastAmount then
					return true
				end
			end
		end
    end
    return false
end

function B_Trigger_OnAtLeastXOfYQuestsSuccess:Debug(_Quest)
    local leastAmount = self.LeastAmount
    local questAmount = self.QuestAmount
    if leastAmount <= 0 or leastAmount >5 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": LeastAmount is wrong")
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

function B_Trigger_OnAtLeastXOfYQuestsSuccess:GetCustomData(_Index)
    if (_Index == 0) or (_Index == 1) then
        return {"1", "2", "3", "4", "5"}
    end
end

Revision:RegisterBehavior(B_Trigger_OnAtLeastXOfYQuestsSuccess)

-- -------------------------------------------------------------------------- --

---
-- Führt eine Funktion im Skript als Trigger aus.
--
-- Die Funktion muss entweder true or false zurückgeben.
--
-- Nur Skipt: Wird statt einem Funktionsnamen (String) eine Funktionsreferenz
-- übergeben, werden alle weiteren Parameter an die Funktion weitergereicht.
--
-- @param _FunctionName Name der Funktion
--
-- @within Trigger
--
function Trigger_MapScriptFunction(...)
    return B_Trigger_MapScriptFunction:new(...);
end

B_Trigger_MapScriptFunction = {
    Name = "Trigger_MapScriptFunction",
    Description = {
        en = "Trigger: Calls a function within the global map script. If the function returns true the quest will be started",
        de = "Auslöser: Ruft eine Funktion im globalen Skript auf. Wenn sie true sendet, wird die Quest gestartet.",
        fr = "Déclencheur: Appelle une fonction dans le script global. Si elle envoie true, la quête est lancée.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Trigger_MapScriptFunction:GetTriggerTable(_Quest)
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_MapScriptFunction:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.FuncName = _Parameter
    end
end

function B_Trigger_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        return self.FuncName(unpack(self.i47ya_6aghw_frxil));
    end
    return _G[self.FuncName](self, _Quest);
end

function B_Trigger_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        error(_Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        error(_Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

Revision:RegisterBehavior(B_Trigger_MapScriptFunction);

---
-- Startet den Quest, sobald ein Effekt zerstört wird oder verschwindet.
--
-- <b>Achtung</b>: Das Behavior kann nur auf Effekte angewand werden, die
-- über Effekt-Behavior erzeugt wurden.
--
-- @param _EffectName Name des Effekt
--
-- @within Trigger
--
function Trigger_OnEffectDestroyed(...)
    return B_Trigger_OnEffectDestroyed:new(...);
end

B_Trigger_OnEffectDestroyed = {
	Name = "Trigger_OnEffectDestroyed",
	Description = {
		en = "Trigger: Starts a quest after an effect was destroyed",
		de = "Auslöser: Startet eine Quest, nachdem ein Effekt zerstoert wurde",
        fr = "Déclencheur: Démarre une quête après la destruction d'un effet.",
	},
	Parameter = {
		{ ParameterType.Default, en = "Effect name", de = "Effektname", fr = "Nom de l'effet" },
	},
}

function B_Trigger_OnEffectDestroyed:GetTriggerTable()
	return { Triggers.Custom2, {self, self.CustomFunction} }
end

function B_Trigger_OnEffectDestroyed:AddParameter(_Index, _Parameter)
	if _Index == 0 then	
		self.EffectName = _Parameter
	end
end

function B_Trigger_OnEffectDestroyed:CustomFunction()
	return not QSB.EffectNameToID[self.EffectName] or not Logic.IsEffectRegistered(QSB.EffectNameToID[self.EffectName]);
end

function B_Trigger_OnEffectDestroyed:Debug(_Quest)
	if not QSB.EffectNameToID[self.EffectName] then
		error(_Quest.Identifier.. ": " ..self.Name .. ": Effect has never existed")
		return true
	end
end
Revision:RegisterBehavior(B_Trigger_OnEffectDestroyed)

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

if not MapEditor and not GUI then
    local MapTypeFolder = "externalmap";
    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName();
    if MapType ~= 3 then
        MapTypeFolder = "development";
    end

    gvMission = gvMission or {};
    gvMission.ContentPath      = "maps/" ..MapTypeFolder.. "/" ..Framework.GetCurrentMapName() .. "/";
    gvMission.MusicRootPath    = gvMission.ContentPath.. "music/";
    gvMission.PlaylistRootPath = "config/sound/";

    Logic.ExecuteInLuaLocalState([[
        gvMission = gvMission or {};
        gvMission.GlobalVariables = Logic.CreateReferenceToTableInGlobaLuaState("gvMission");
        gvMission.ContentPath      = "maps/]] ..MapTypeFolder.. [[/" ..Framework.GetCurrentMapName() .. "/";
        gvMission.MusicRootPath    = gvMission.ContentPath.. "music/";
        gvMission.PlaylistRootPath = "config/sound/";

        Script.Load(gvMission.ContentPath.. "questsystembehavior.lua");
        API.Install();
        if ModuleKnightTitleRequirements then
            InitKnightTitleTables();
        end
        
        -- Call directly for singleplayer
        if not Framework.IsNetworkGame() then
            Revision:CreateRandomSeed();
            if Mission_LocalOnQsbLoaded then
                Mission_LocalOnQsbLoaded();
            end

        -- Send asynchron command to player in multiplayer
        else
            function Revision_Selfload_ReadyTrigger()
                if table.getn(API.GetDelayedPlayers()) == 0 then
                    Revision:CreateRandomSeed();
                    Revision.Event:DispatchScriptCommand(QSB.ScriptCommands.GlobalQsbLoaded, 0);
                    return true;
                end
            end
            StartSimpleHiResJob("Revision_Selfload_ReadyTrigger")
        end        
    ]]);
    API.Install();
    if ModuleKnightTitleRequirements then
        InitKnightTitleTables();
    end
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleEntitySurveillance = {
    Properties = {
        Name = "ModuleEntitySurveillance",
    },

    Global = {
        RegisteredEntities = {},
        MineAmounts = {},
        AttackedEntities = {},
        OverkillEntities = {},
        DisableThiefStorehouseHeist = false,
        DisableThiefCathedralSabotage = false,
        DisableThiefCisternSabotage = false,

        -- TODO: Add predators?
        StaticSpawnerTypes = {
            "B_NPC_BanditsHQ_ME",
            "B_NPC_BanditsHQ_NA",
            "B_NPC_BanditsHQ_NE",
            "B_NPC_BanditsHQ_SE",
            "B_NPC_BanditsHutBig_ME",
            "B_NPC_BanditsHutBig_NA",
            "B_NPC_BanditsHutBig_NE",
            "B_NPC_BanditsHutBig_SE",
            "B_NPC_BanditsHutSmall_ME",
            "B_NPC_BanditsHutSmall_NA",
            "B_NPC_BanditsHutSmall_NE",
            "B_NPC_BanditsHutSmall_SE",
            "B_NPC_Barracks_ME",
            "B_NPC_Barracks_NA",
            "B_NPC_Barracks_NE",
            "B_NPC_Barracks_SE",
            "B_NPC_BanditsHQ_AS",
            "B_NPC_BanditsHutBig_AS",
            "B_NPC_BanditsHutSmall_AS",
            "B_NPC_Barracks_AS",
        },

        -- Those are "fluctuating" spawner entities that are keep appearing
        -- and disappearing depending of if they have resources spawned. They
        -- change their ID every time they do it. So scriptnames are a nono.
        DynamicSpawnerTypes = {
            "S_AxisDeer_AS",
            "S_Deer_ME",
            "S_FallowDeer_SE",
            "S_Gazelle_NA",
            "S_Herbs",
            "S_Moose_NE",
            "S_RawFish",
            "S_Reindeer_NE",
            "S_WildBoar",
            "S_Zebra_NA",
        },
    },
    Local = {},
    Shared = {},
}

-- Global ------------------------------------------------------------------- --

function ModuleEntitySurveillance.Global:OnGameStart()
    QSB.ScriptEvents.SettlerAttracted = API.RegisterScriptEvent("Event_SettlerAttracted");
    QSB.ScriptEvents.EntitySpawned = API.RegisterScriptEvent("Event_EntitySpawned");
    QSB.ScriptEvents.EntityDestroyed = API.RegisterScriptEvent("Event_EntityDestroyed");
    QSB.ScriptEvents.EntityHurt = API.RegisterScriptEvent("Event_EntityHurt");
    QSB.ScriptEvents.EntityKilled = API.RegisterScriptEvent("Event_EntityKilled");
    QSB.ScriptEvents.EntityOwnerChanged = API.RegisterScriptEvent("Event_EntityOwnerChanged");
    QSB.ScriptEvents.EntityResourceChanged = API.RegisterScriptEvent("Event_EntityResourceChanged");

    QSB.ScriptEvents.ThiefInfiltratedBuilding = API.RegisterScriptEvent("Event_ThiefInfiltratedBuilding");
    QSB.ScriptEvents.ThiefDeliverEarnings = API.RegisterScriptEvent("Event_ThiefDeliverEarnings");
    QSB.ScriptEvents.BuildingConstructed = API.RegisterScriptEvent("Event_BuildingConstructed");
    QSB.ScriptEvents.BuildingUpgradeCollapsed = API.RegisterScriptEvent("Event_BuildingUpgradeCollapsed");
    QSB.ScriptEvents.BuildingUpgraded = API.RegisterScriptEvent("Event_BuildingUpgraded");

    self:StartTriggers();
    self:OverrideCallback();
    self:OverrideLogic();
end

function ModuleEntitySurveillance.Global:OnEvent(_ID, _Event, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.SaveGameLoaded then
        self:OnSaveGameLoaded();
    elseif _ID == QSB.ScriptEvents.EntityHurt then
        self.AttackedEntities[arg[1]] = {arg[3], 100};
    end
end

function ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(_OldID, _OldOwnerID, _NewID, _NewOwnerID)
    _OldID = (type(_OldID) ~= "table" and {_OldID}) or _OldID;
    _NewID = (type(_NewID) ~= "table" and {_NewID}) or _NewID;
    assert(#_OldID == #_NewID, "Sums of entities with changed owner does not add up!");
    for i=1, #_OldID do
        API.SendScriptEvent(QSB.ScriptEvents.EntityOwnerChanged, _OldID[i], _OldOwnerID, _NewID[i], _NewOwnerID);
        Logic.ExecuteInLuaLocalState(string.format(
            "API.SendScriptEvent(QSB.ScriptEvents.EntityOwnerChanged, %d)",
            _OldID[i], _OldOwnerID, _NewID[i], _NewOwnerID
        ));
    end
end

function ModuleEntitySurveillance.Global:OnSaveGameLoaded()
    self:OverrideLogic();
end

function ModuleEntitySurveillance.Global:CleanTaggedAndDeadEntities()
    -- check if entity should no longer be considered attacked
    for k,v in pairs(self.AttackedEntities) do
        self.AttackedEntities[k][2] = v[2] - 1;
        if v[2] <= 0 then
            self.AttackedEntities[k] = nil;
        else
            -- Send killed event for knights
            if IsExisting(k) and IsExisting(v[1]) and Logic.IsKnight(k) then
                if not self.OverkillEntities[k] and Logic.KnightGetResurrectionProgress(k) ~= 1 then
                    local PlayerID1 = Logic.EntityGetPlayer(k);
                    local PlayerID2 = Logic.EntityGetPlayer(v[1]);
                    self:TriggerEntityKilledEvent(k, PlayerID1, v[1], PlayerID2);
                    self.OverkillEntities[k] = 50;
                    self.AttackedEntities[k] = nil;
                end
            end
        end
    end
    -- unregister overkill entities
    for k,v in pairs(self.OverkillEntities) do
        self.OverkillEntities[k] = v - 1;
        if v <= 0 then
            self.OverkillEntities[k] = nil;
        end
    end
end

function ModuleEntitySurveillance.Global:OverrideCallback()
    GameCallback_SettlerSpawned_Orig_QSB_EntityCore = GameCallback_SettlerSpawned;
    GameCallback_SettlerSpawned = function(_PlayerID, _EntityID)
        GameCallback_SettlerSpawned_Orig_QSB_EntityCore(_PlayerID, _EntityID);
        ModuleEntitySurveillance.Global:TriggerSettlerArrivedEvent(_PlayerID, _EntityID);
    end

    GameCallback_OnBuildingConstructionComplete_Orig_QSB_EntityCore = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        GameCallback_OnBuildingConstructionComplete_Orig_QSB_EntityCore(_PlayerID, _EntityID);
        ModuleEntitySurveillance.Global:TriggerConstructionCompleteEvent(_PlayerID, _EntityID);
    end

    GameCallback_FarmAnimalChangedPlayerID_Orig_QSB_EntityCore = GameCallback_FarmAnimalChangedPlayerID;
    GameCallback_FarmAnimalChangedPlayerID = function(_PlayerID, _NewEntityID, _OldEntityID)
        GameCallback_FarmAnimalChangedPlayerID_Orig_QSB_EntityCore(_PlayerID, _NewEntityID, _OldEntityID);
        local OldPlayerID = Logic.EntityGetPlayer(_OldEntityID);
        local NewPlayerID = Logic.EntityGetPlayer(_NewEntityID);
        ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, OldPlayerID, _NewEntityID, NewPlayerID);
    end

    GameCallback_EntityCaptured_Orig_QSB_EntityCore = GameCallback_EntityCaptured;
    GameCallback_EntityCaptured = function(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        GameCallback_EntityCaptured_Orig_QSB_EntityCore(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
    end

    GameCallback_CartFreed_Orig_QSB_EntityCore = GameCallback_CartFreed;
    GameCallback_CartFreed = function(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        GameCallback_CartFreed_Orig_QSB_EntityCore(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
        ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
    end

    GameCallback_OnThiefDeliverEarnings_Orig_QSB_EntityCore = GameCallback_OnThiefDeliverEarnings;
    GameCallback_OnThiefDeliverEarnings = function(_ThiefPlayerID, _ThiefID, _BuildingID, _GoodAmount)
        GameCallback_OnThiefDeliverEarnings_Orig_QSB_EntityCore(_ThiefPlayerID, _ThiefID, _BuildingID, _GoodAmount);
        local BuildingPlayerID = Logic.EntityGetPlayer(_BuildingID);
        ModuleEntitySurveillance.Global:TriggerThiefDeliverEarningsEvent(_ThiefID, _ThiefPlayerID, _BuildingID, BuildingPlayerID, _GoodAmount);
    end

    GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore = GameCallback_OnThiefStealBuilding;
    GameCallback_OnThiefStealBuilding = function(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
        ModuleEntitySurveillance.Global:TriggerThiefStealFromBuildingEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
    end

    GameCallback_OnBuildingUpgraded_Orig_QSB_EntityCore = GameCallback_OnBuildingUpgradeFinished;
	GameCallback_OnBuildingUpgradeFinished = function(_PlayerID, _EntityID, _NewUpgradeLevel)
		GameCallback_OnBuildingUpgraded_Orig_QSB_EntityCore(_PlayerID, _EntityID, _NewUpgradeLevel);
        ModuleEntitySurveillance.Global:TriggerUpgradeCompleteEvent(_PlayerID, _EntityID, _NewUpgradeLevel);
    end

    GameCallback_OnUpgradeLevelCollapsed_Orig_QSB_EntityCore = GameCallback_OnUpgradeLevelCollapsed;
    GameCallback_OnUpgradeLevelCollapsed = function(_PlayerID, _BuildingID, _NewUpgradeLevel)
        GameCallback_OnUpgradeLevelCollapsed_Orig_QSB_EntityCore(_PlayerID, _BuildingID, _NewUpgradeLevel);
        ModuleEntitySurveillance.Global:TriggerUpgradeCollapsedEvent(_PlayerID, _BuildingID, _NewUpgradeLevel);
    end
end

function ModuleEntitySurveillance.Global:OverrideLogic()
    self.Logic_ChangeEntityPlayerID = Logic.ChangeEntityPlayerID;
    Logic.ChangeEntityPlayerID = function(...)
        local OldID = {arg[1]};
        local OldPlayerID = Logic.EntityGetPlayer(arg[1]);
        local NewID = {self.Logic_ChangeEntityPlayerID(unpack(arg))};
        local NewPlayerID = Logic.EntityGetPlayer(NewID[1]);
        ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(OldID, OldPlayerID, NewID, NewPlayerID);
        return NewID;
    end

    self.Logic_ChangeSettlerPlayerID = Logic.ChangeSettlerPlayerID;
    Logic.ChangeSettlerPlayerID = function(...)
        local OldID = {arg[1]};
        OldID = Array_Append(OldID, API.GetGroupSoldiers(arg[1]));
        local OldPlayerID = Logic.EntityGetPlayer(arg[1]);
        local NewID = {self.Logic_ChangeSettlerPlayerID(unpack(arg))};
        NewID = Array_Append(NewID, API.GetGroupSoldiers(NewID[1]));
        local NewPlayerID = Logic.EntityGetPlayer(NewID[1]);
        ModuleEntitySurveillance.Global:TriggerEntityOnwershipChangedEvent(OldID, OldPlayerID, NewID, NewPlayerID);
        return NewID[1];
    end
end

function ModuleEntitySurveillance.Global:TriggerThiefDeliverEarningsEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount)
    API.SendScriptEvent(QSB.ScriptEvents.ThiefDeliverEarnings, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.ThiefDeliverEarnings, %d, %d, %d, %d, %d)",
        _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount
    ));
end

function ModuleEntitySurveillance.Global:TriggerThiefStealFromBuildingEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
    local HeadquartersID = Logic.GetHeadquarters(_BuildingPlayerID);
    local CathedralID = Logic.GetCathedral(_BuildingPlayerID);
    local StorehouseID = Logic.GetStoreHouse(_BuildingPlayerID);
    local IsVillageStorehouse = Logic.IsEntityInCategory(StorehouseID, EntityCategories.VillageStorehouse) == 0;
    local BuildingType = Logic.GetEntityType(_BuildingID);

    -- Aus Lagerhaus stehlen
    if StorehouseID == _BuildingID and (not IsVillageStorehouse or HeadquartersID == 0) then
        if not self.DisableThiefStorehouseHeist then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end
    -- Kirche sabotieren
    if CathedralID == _BuildingID then
        if not self.DisableThiefCathedralSabotage then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end
    -- Brunnen sabotieren
    if Framework.GetGameExtraNo() > 0 and BuildingType == Entities.B_Cistern then
        if not self.DisableThiefCisternSabotage then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end

    -- Send event
    API.SendScriptEvent(QSB.ScriptEvents.ThiefInfiltratedBuilding, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.ThiefInfiltratedBuilding, %d, %d, %d, %d)",
        _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID
    ));
end

function ModuleEntitySurveillance.Global:TriggerEntitySpawnedEvent(_EntityID, _SpawnerID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    API.SendScriptEvent(QSB.ScriptEvents.EntitySpawned, _EntityID, PlayerID, _SpawnerID);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.EntitySpawned, %d, %d, %d)",
        _EntityID, PlayerID, _SpawnerID
    ));
end

function ModuleEntitySurveillance.Global:TriggerSettlerArrivedEvent(_PlayerID, _EntityID)
    API.SendScriptEvent(QSB.ScriptEvents.SettlerAttracted, _EntityID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.SettlerAttracted, %d, %d)",
        _EntityID, _PlayerID
    ));
end

function ModuleEntitySurveillance.Global:TriggerEntityDestroyedEvent(_EntityID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.EntityDestroyed, _EntityID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.EntityDestroyed, %d, %d)",
        _EntityID, _PlayerID
    ));
end

function ModuleEntitySurveillance.Global:TriggerEntityKilledEvent(_EntityID1, _PlayerID1, _EntityID2, _PlayerID2)
    API.SendScriptEvent(QSB.ScriptEvents.EntityKilled, _EntityID1, _PlayerID1, _EntityID2, _PlayerID2);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.EntityKilled, %d, %d, %d, %d)",
        _EntityID1, _PlayerID1, _EntityID2, _PlayerID2
    ));
end

function ModuleEntitySurveillance.Global:TriggerConstructionCompleteEvent(_PlayerID, _EntityID)
    API.SendScriptEvent(QSB.ScriptEvents.BuildingConstructed, _EntityID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.BuildingConstructed, %d, %d)",
        _EntityID, _PlayerID
    ));
end

function ModuleEntitySurveillance.Global:TriggerUpgradeCompleteEvent(_PlayerID, _EntityID, _NewUpgradeLevel)
    API.SendScriptEvent(QSB.ScriptEvents.BuildingUpgraded, _EntityID, _PlayerID, _NewUpgradeLevel);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.BuildingUpgraded, %d, %d, %d)",
        _EntityID, _PlayerID, _NewUpgradeLevel
    ));
end

function ModuleEntitySurveillance.Global:TriggerUpgradeCollapsedEvent(_PlayerID, _EntityID, _NewUpgradeLevel)
    API.SendScriptEvent(QSB.ScriptEvents.BuildingUpgradeCollapsed, _EntityID, _PlayerID, _NewUpgradeLevel);
    Logic.ExecuteInLuaLocalState(string.format(
        "API.SendScriptEvent(QSB.ScriptEvents.BuildingUpgradeCollapsed, %d, %d, %d)",
        _EntityID, _PlayerID, _NewUpgradeLevel
    ));
end

function ModuleEntitySurveillance.Global:StartTriggers()
    API.StartHiResJob(function()
        if Logic.GetCurrentTurn() > 0 then
            ModuleEntitySurveillance.Global:CleanTaggedAndDeadEntities();
            ModuleEntitySurveillance.Global:CheckOnSpawnerEntities();
        end
    end);

    API.StartJob(function()
        local MineEntityTypes = {
            Entities.R_IronMine,
            Entities.R_StoneMine
        };
        for i= 1, #MineEntityTypes do
            local Mines = Logic.GetEntitiesOfType(MineEntityTypes[i]);
            for j= 1, #Mines do
                local Old = self.MineAmounts[Mines[j]];
                local New = Logic.GetResourceDoodadGoodAmount(Mines[j]);
                if Old and New and Old ~= New then
                    local Type = Logic.GetResourceDoodadGoodType(Mines[j]);
                    API.SendScriptEvent(QSB.ScriptEvents.EntityResourceChanged, Mines[j], Type, Old, New);
                    Logic.ExecuteInLuaLocalState(string.format(
                        [[API.SendScriptEvent(QSB.ScriptEvents.EntityResourceChanged, %d, %d, %d, %d)]],
                        Mines[j], Type, Old, New
                    ));
                end
                self.MineAmounts[Mines[j]] = New;
            end
        end
    end);

    API.StartJobByEventType(
        Events.LOGIC_EVENT_ENTITY_DESTROYED,
        function()
            local EntityID1 = Event.GetEntityID();
            local PlayerID1 = Logic.EntityGetPlayer(EntityID1);
            ModuleEntitySurveillance.Global:TriggerEntityDestroyedEvent(EntityID1, PlayerID1);
            if ModuleEntitySurveillance.Global.AttackedEntities[EntityID1] ~= nil then
                local EntityID2 = ModuleEntitySurveillance.Global.AttackedEntities[EntityID1][1];
                local PlayerID2 = Logic.EntityGetPlayer(EntityID2);
                ModuleEntitySurveillance.Global.AttackedEntities[EntityID1] = nil;
                ModuleEntitySurveillance.Global:TriggerEntityKilledEvent(EntityID1, PlayerID1, EntityID2, PlayerID2);
            end
        end
    );

    API.StartJobByEventType(
        Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
        function()
            local EntityID1 = Event.GetEntityID1();
            local PlayerID1 = Logic.EntityGetPlayer(EntityID1);
            local EntityID2 = Event.GetEntityID2();
            local PlayerID2 = Logic.EntityGetPlayer(EntityID2);

            API.SendScriptEvent(QSB.ScriptEvents.EntityHurt, EntityID2, PlayerID2, EntityID1, PlayerID1);
            Logic.ExecuteInLuaLocalState(string.format(
                [[API.SendScriptEvent(QSB.ScriptEvents.EntityHurt, %d, %d, %d, %d)]],
                EntityID2, PlayerID2, EntityID1, PlayerID1
            ));
        end
    );
end

function ModuleEntitySurveillance.Global:CheckOnSpawnerEntities()
    -- Get spawners
    local SpawnerEntities = {};
    for i= 1, #self.DynamicSpawnerTypes do
        if Entities[self.DynamicSpawnerTypes[i]] then
            if Logic.GetCurrentTurn() % 10 == i then
                for k, v in pairs(Logic.GetEntitiesOfType(Entities[self.DynamicSpawnerTypes[i]])) do
                    table.insert(SpawnerEntities, v);
                end
            end
        end
    end
    for i= 1, #self.StaticSpawnerTypes do
        if Entities[self.StaticSpawnerTypes[i]] then
            if Logic.GetCurrentTurn() % 10 == i then
                for k, v in pairs(Logic.GetEntitiesOfType(Entities[self.StaticSpawnerTypes[i]])) do
                    table.insert(SpawnerEntities, v);
                end
            end
        end
    end
    -- Check spawned entities
    for i= 1, #SpawnerEntities do
        for k, v in pairs{Logic.GetSpawnedEntities(SpawnerEntities[i])} do
            -- On Spawner entity spawned
            if not self.RegisteredEntities[v] then
                self:TriggerEntitySpawnedEvent(v, SpawnerEntities[i]);
                self.RegisteredEntities[v] = SpawnerEntities[i];
            end
        end
    end
end

-- Local -------------------------------------------------------------------- --

function ModuleEntitySurveillance.Local:OnGameStart()
    QSB.ScriptEvents.SettlerAttracted = API.RegisterScriptEvent("Event_SettlerAttracted");
    QSB.ScriptEvents.EntitySpawned = API.RegisterScriptEvent("Event_EntitySpawned");
    QSB.ScriptEvents.EntityDestroyed = API.RegisterScriptEvent("Event_EntityDestroyed");
    QSB.ScriptEvents.EntityHurt = API.RegisterScriptEvent("Event_EntityHurt");
    QSB.ScriptEvents.EntityKilled = API.RegisterScriptEvent("Event_EntityKilled");
    QSB.ScriptEvents.EntityOwnerChanged = API.RegisterScriptEvent("Event_EntityOwnerChanged");
    QSB.ScriptEvents.EntityResourceChanged = API.RegisterScriptEvent("Event_EntityResourceChanged");

    QSB.ScriptEvents.ThiefInfiltratedBuilding = API.RegisterScriptEvent("Event_ThiefInfiltratedBuilding");
    QSB.ScriptEvents.ThiefDeliverEarnings = API.RegisterScriptEvent("Event_ThiefDeliverEarnings");
    QSB.ScriptEvents.BuildingConstructed = API.RegisterScriptEvent("Event_BuildingConstructed");
    QSB.ScriptEvents.BuildingUpgradeCollapsed = API.RegisterScriptEvent("Event_BuildingUpgradeCollapsed");
    QSB.ScriptEvents.BuildingUpgraded = API.RegisterScriptEvent("Event_BuildingUpgraded");

    self:OverrideAfterBuildingPlacement();
end

function ModuleEntitySurveillance.Local:OnEvent(_ID, _Event, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- Shared ------------------------------------------------------------------- --

function ModuleEntitySurveillance.Shared:IterateOverEntities(_Filter, _TypeList)
    _TypeList = _TypeList or Entities;
    local ResultList = {};
    for _, v in pairs(_TypeList) do
        local AllEntitiesOfType = Logic.GetEntitiesOfType(v);
        for i= 1, #AllEntitiesOfType do
            if _Filter(AllEntitiesOfType[i]) then
                table.insert(ResultList, AllEntitiesOfType[i]);
            end
        end
    end
    return ResultList;
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleEntitySurveillance);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Ermöglicht, Entities suchen und auf bestimmte Ereignisse reagieren.
--
-- <h5>Entity Suche</h5>
-- TODO
--
-- <h5>Diebstahleffekte</h5>
-- Die Effekte von Diebstählen können deaktiviert und mittels Event neu
-- geschrieben werden.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field EntitySpawned Ein Entity wurde aus einem Spawner erzeugt. (Parameter: EntityID, PlayerID, SpawnerID)
-- @field SettlerAttracted Ein Siedler kommt in die Siedlung. (Parameter: EntityID, PlayerID)
-- @field EntityDestroyed Ein Entity wurde zerstört. Wird auch durch Spieler ändern ausgelöst! (Parameter: EntityID, PlayerID)
-- @field EntityHurt Ein Entity wurde angegriffen. (Parameter: AttackedEntityID, AttackedPlayerID, AttackingEntityID, AttackingPlayerID)
-- @field EntityKilled Ein Entity wurde getötet. (Parameter: KilledEntityID, KilledPlayerID, KillerEntityID, KillerPlayerID)
-- @field EntityOwnerChanged Ein Entity wechselt den Besitzer. (Parameter: OldIDList, OldPlayer, NewIDList, OldPlayer)
-- @field EntityResourceChanged Resourcen im Entity verändern sich. (Parameter: EntityID, GoodType, OldAmount, NewAmount)
-- @field BuildingConstructed Ein Gebäude wurde fertiggestellt. (Parameter: BuildingID, PlayerID)
-- @field BuildingUpgraded Ein Gebäude wurde aufgewertet. (Parameter: BuildingID, PlayerID, NewUpgradeLevel)
-- @field BuildingUpgradeCollapsed Eine Ausbaustufe eines Gebäudes wurde zerstört. (Parameter: BuildingID, PlayerID, NewUpgradeLevel)
-- @field ThiefInfiltratedBuilding Ein Dieb hat ein Gebäude infiltriert. (Parameter: ThiefID, PlayerID, BuildingID, BuildingPlayerID)
-- @field ThiefDeliverEarnings Ein Dieb liefert seine Beute ab. (Parameter: ThiefID, PlayerID, BuildingID, BuildingPlayerID, GoldAmount)
--
-- @within Event
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

-- -------------------------------------------------------------------------- --
-- Search

---
-- Findet <u>alle</u> Entities.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=number]  _PlayerID               (Optional) ID des Besitzers
-- @param[type=boolean] _WithoutDefeatResistant (Optional) Niederlageresistente Entities filtern
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see API.CommenceEntitySearch
--
-- @usage
-- -- ALLE Entities
-- local Result = API.SearchEntities();
-- -- Alle Entities von Spieler 5.
-- local Result = API.SearchEntities(5);
--
function API.SearchEntities(_PlayerID, _WithoutDefeatResistant)
    if _WithoutDefeatResistant == nil then
        _WithoutDefeatResistant = false;
    end
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _WithoutDefeatResistant then
            if (Logic.IsBuilding(_ID) or Logic.IsWall(_ID)) and Logic.IsConstructionComplete(_ID) == 0 then
                return false;
            end
            local Type = Logic.GetEntityType(_ID);
            local TypeName = Logic.GetEntityType(Type);
            if TypeName and (string.find(TypeName, "^S_") or string.find(TypeName, "^XD_")) then
                return false;
            end
        end
        return true;
    end
    return API.CommenceEntitySearch(Filter);
end

---
-- Findet alle Entities des Typs in einem Gebiet.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=number] _Area     Größe des Suchgebiet
-- @param              _Position Mittelpunkt (EntityID, Skriptname oder Table)
-- @param[type=number] _Type     Typ des Entity
-- @param[type=number] _PlayerID (Optional) ID des Besitzers
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see API.CommenceEntitySearch
--
-- @usage
-- local Result = API.SearchEntitiesInArea(5000, "Busches", Entities.R_HerbBush);
--
function API.SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return API.SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, nil);
end

---
-- Findet alle Entities der Kategorie in einem Gebiet.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=number] _Area     Größe des Suchgebiet
-- @param              _Position Mittelpunkt (EntityID, Skriptname oder Table)
-- @param[type=number] _Category Category des Entity
-- @param[type=number] _PlayerID (Optional) ID des Besitzers
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see API.CommenceEntitySearch
--
-- @usage
-- local Result = API.SearchEntitiesInArea(5000, "City", EntityCategories.CityBuilding, 2);
--
function API.SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return API.SearchEntitiesInArea(_Area, _Position, _PlayerID, nil, _Category);
end

-- Not supposed to be used directly!
function API.SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, _Category)
    local Position = _Position;
    if type(Position) ~= "table" then
        Position = GetPosition(Position);
    end
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if API.GetDistance(_ID, Position) > _Area then
            return false;
        end
        return true;
    end
    return API.CommenceEntitySearch(Filter);
end

---
-- Findet alle Entities des Typs in einem Territorium.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=number] _Territory Territorium für die Suche
-- @param[type=number] _Type      Typ des Entity
-- @param[type=number] _PlayerID  (Optional) ID des Besitzers
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see API.CommenceEntitySearch
--
-- @usage
-- local Result = API.SearchEntitiesInTerritory(7, Entities.R_HerbBush);
--
function API.SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return API.SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, nil);
end

---
-- Findet alle Entities der Kategorie in einem Territorium.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=number] _Territory Territorium für die Suche
-- @param[type=number] _Category  Category des Entity
-- @param[type=number] _PlayerID  (Optional) ID des Besitzers
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see API.CommenceEntitySearch
--
-- @usage
-- local Result = API.SearchEntitiesInTerritory(7, EntityCategories.CityBuilding, 6);
--
function API.SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return API.SearchEntitiesInTerritory(_Territory, _PlayerID, nil, _Category);
end

-- Not supposed to be used directly!
function API.SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, _Category)
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if _Territory and GetTerritoryUnderEntity(_ID) ~= _Territory then
            return false;
        end
        return true;
    end
    return API.CommenceEntitySearch(Filter);
end

---
-- Führt eine benutzerdefinierte Suche nach Entities aus.
--
-- <b>Achtung</b>: Die Reihenfolge der Abfragen im Filter hat direkten
-- Einfluss auf die Dauer der Suche. Während Abfragen auf den Besitzer oder
-- den Typ schnell gehen, dauern Gebietssuchen lange! Es ist daher klug, zuerst
-- Kriterien auszuschließen, die schnell bestimmt werden können!
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer kann diese Funktion nur in synchron
-- ausgeführtem Code benutzt werden, da es sonst zu Desyncs komm.
--
-- @param[type=function] _Filter Funktion zur Filterung
-- @return[type=table] Liste mit Ergebnissen
-- @within Suche
-- @see QSB.SearchPredicate
--
-- @usage
-- -- Es werden alle Kühe und Schafe von Spieler 1 gefunden, die nicht auf den
-- -- Territorien 7 und 15 sind.
-- local Result = API.CommenceEntitySearch(
--     function(_ID)
--         -- Nur Entities von Spieler 1 akzeptieren
--         if Logic.EntityGetPlayer(_ID) == 1 then
--             -- Nur Entities akzeptieren, die Kühe oder Schafe sind.
--             if Logic.IsEntityInCategory(_ID, EntityCategories.CattlePasture) == 1
--             or Logic.IsEntityInCategory(_ID, EntityCategories.SheepPasture) == 1 then
--                 -- Nur Entities akzeptieren, die nicht auf den Territorien 7 und 15 sind.
--                 local Territory = GetTerritoryUnderEntity(_ID);
--                 return Territory ~= 7 and Territory ~= 15;
--             end
--         end
--         return false;
--     end
-- );
--
function API.CommenceEntitySearch(_Filter)
    _Filter = _Filter or function(_ID)
        return true;
    end
    return ModuleEntitySurveillance.Shared:IterateOverEntities(_Filter);
end

-- Compatibility option
function API.GetEntitiesOfCategoryInTerritory(_PlayerID, _Category, _Territory)
    return API.SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID);
end

-- Compatibility option
-- Realy needed? Don't they throw the old version in the script anyway?
function API.GetEntitiesOfCategoriesInTerritories(_PlayerID, _Category, _Territory)
    local p = (type(_PlayerID) == "table" and _PlayerID) or {_PlayerID};
    local c = (type(_Category) == "table" and _Category) or {_Category};
    local t = (type(_Territory) == "table" and _Territory) or {_Territory};
    local PlayerEntities = {};
    for i=1, #p, 1 do
        for j=1, #c, 1 do
            for k=1, #t, 1 do
                local Units = API.SearchEntitiesOfCategoryInTerritory(t[k], c[j], p[i]);
                PlayerEntities = Array_Append(PlayerEntities, Units);
            end
        end
    end
    return PlayerEntities;
end

-- -------------------------------------------------------------------------- --
-- Thief

---
-- Deaktiviert die Standardaktion wenn ein Dieb in ein Lagerhaus eindringt.
--
-- <b>Hinweis</b>: Wird die Standardaktion deaktiviert, stielt der Dieb
-- stattdessen Informationen.
--
-- @param[type=boolean] _Flag Standardeffekt deaktiviert
-- @within Dieb
--
-- @usage
-- -- Deaktivieren
-- API.ThiefDisableStorehouseEffect(true);
-- -- Aktivieren
-- API.ThiefDisableStorehouseEffect(false);
--
function API.ThiefDisableStorehouseEffect(_Flag)
    ModuleEntitySurveillance.Global.DisableThiefStorehouseHeist = _Flag == true;
end

---
-- Deaktiviert die Standardaktion wenn ein Dieb in eine Kirche eindringt.
--
-- <b>Hinweis</b>: Wird die Standardaktion deaktiviert, stielt der Dieb
-- stattdessen Informationen.
--
-- @param[type=boolean] _Flag Standardeffekt deaktiviert
-- @within Dieb
--
-- @usage
-- -- Deaktivieren
-- API.ThiefDisableCathedralEffect(true);
-- -- Aktivieren
-- API.ThiefDisableCathedralEffect(false);
--
function API.ThiefDisableCathedralEffect(_Flag)
    ModuleEntitySurveillance.Global.DisableThiefCathedralSabotage = _Flag == true;
end

---
-- Deaktiviert die Standardaktion wenn ein Dieb einen Brunnen sabotiert.
--
-- <b>Hinweis</b>: Brunnen können nur im Addon gebaut und sabotiert werden.
--
-- @param[type=boolean] _Flag Standardeffekt deaktiviert
-- @within Dieb
--
-- @usage
-- -- Deaktivieren
-- API.ThiefDisableCisternEffect(true);
-- -- Aktivieren
-- API.ThiefDisableCisternEffect(false);
--
function API.ThiefDisableCisternEffect(_Flag)
    ModuleEntitySurveillance.Global.DisableThiefCisternSabotage = _Flag == true;
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleGUI = {
    Properties = {
        Name = "ModuleGUI",
        Version = "4.0.0 (ALPHA 1.0.0)"
    },

    Global = {
        CinematicElementID = 0,
        CinematicElementStatus = {},
        CinematicElementQueue = {},
    },
    Local = {
        CinematicElementStatus = {},
        ChatOptionsWasShown = false,
        MessageLogWasShown = false,
        PauseScreenShown = false,
        NormalModeHidden = false,
        BorderScrollDeactivated = false,

        HiddenWidgets = {},
        HotkeyDescriptions = {},
    },

    Shared = {};
}

QSB.FarClipDefault = {MIN = 0, MAX = 0};
QSB.CinematicElement = {};
QSB.CinematicElementTypes = {};
QSB.PlayerNames = {};

-- Global ------------------------------------------------------------------- --

function ModuleGUI.Global:OnGameStart()
    QSB.ScriptEvents.BuildingPlaced = API.RegisterScriptEvent("Event_BuildingPlaced");
    QSB.ScriptEvents.CinematicActivated = API.RegisterScriptEvent("Event_CinematicElementActivated");
    QSB.ScriptEvents.CinematicConcluded = API.RegisterScriptEvent("Event_CinematicElementConcluded");
    QSB.ScriptEvents.BorderScrollLocked = API.RegisterScriptEvent("Event_BorderScrollLocked");
    QSB.ScriptEvents.BorderScrollReset = API.RegisterScriptEvent("Event_BorderScrollReset");
    QSB.ScriptEvents.GameInterfaceShown = API.RegisterScriptEvent("Event_GameInterfaceShown");
    QSB.ScriptEvents.GameInterfaceHidden = API.RegisterScriptEvent("Event_GameInterfaceHidden");
    QSB.ScriptEvents.ImageScreenShown = API.RegisterScriptEvent("Event_ImageScreenShown");
    QSB.ScriptEvents.ImageScreenHidden = API.RegisterScriptEvent("Event_ImageScreenHidden");

    API.RegisterScriptCommand("Cmd_UpdateTexturePosition", function(_Category, _Key, _Value)
        g_TexturePositions = g_TexturePositions or {};
        g_TexturePositions[_Category] = g_TexturePositions[_Category] or {};
        g_TexturePositions[_Category][_Key] = _Value;
    end);

    for i= 1, 8 do
        self.CinematicElementStatus[i] = {};
        self.CinematicElementQueue[i] = {};
    end

    self:ShowInitialBlackscreen();
end

function ModuleGUI.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.CinematicActivated then
        -- Save cinematic state
        self.CinematicElementStatus[arg[2]][arg[1]] = 1;
        -- deactivate black background
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceDeactivateImageBackground(%d)",
            arg[2]
        ));
        -- activate GUI
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceActivateNormalInterface(%d)",
            arg[2]
        ));
    elseif _ID == QSB.ScriptEvents.CinematicConcluded then
        -- Save cinematic state
        if self.CinematicElementStatus[arg[2]][arg[1]] then
            self.CinematicElementStatus[arg[2]][arg[1]] = 2;
        end
        if #self.CinematicElementQueue[arg[2]] > 0 then
            -- activate black background
            Logic.ExecuteInLuaLocalState(string.format(
                [[ModuleGUI.Local:InterfaceActivateImageBackground(%d, "", 0, 0, 0, 255)]],
                arg[2]
            ));
            -- deactivate GUI
            Logic.ExecuteInLuaLocalState(string.format(
                "ModuleGUI.Local:InterfaceDeactivateNormalInterface(%d)",
                arg[2]
            ));
        end
    end
end

function ModuleGUI.Global:PushCinematicElementToQueue(_PlayerID, _Type, _Name, _Data)
    table.insert(self.CinematicElementQueue[_PlayerID], {_Type, _Name, _Data});
end

function ModuleGUI.Global:LookUpCinematicInQueue(_PlayerID)
    if #self.CinematicElementQueue[_PlayerID] > 0 then
        return self.CinematicElementQueue[_PlayerID][1];
    end
end

function ModuleGUI.Global:PopCinematicElementFromQueue(_PlayerID)
    if #self.CinematicElementQueue[_PlayerID] > 0 then
        return table.remove(self.CinematicElementQueue[_PlayerID], 1);
    end
end

function ModuleGUI.Global:GetNewCinematicElementID()
    self.CinematicElementID = self.CinematicElementID +1;
    return self.CinematicElementID;
end

function ModuleGUI.Global:GetCinematicElementStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicElementStatus[i][_InfoID] then
            return self.CinematicElementStatus[i][_InfoID];
        end
    end
    return 0;
end

function ModuleGUI.Global:ActivateCinematicElement(_PlayerID)
    local ID = self:GetNewCinematicElementID();
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.CinematicActivated, %d, %d);
          if GUI.GetPlayerID() == %d then
            ModuleGUI.Local.SavingWasDisabled = Revision.Save.SavingDisabled == true;
            API.DisableSaving(true);
          end]],
        ID,
        _PlayerID,
        _PlayerID
    ))
    API.SendScriptEvent(QSB.ScriptEvents.CinematicActivated, ID, _PlayerID);
    return ID;
end

function ModuleGUI.Global:ConcludeCinematicElement(_ID, _PlayerID)
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.CinematicConcluded, %d, %d);
          if GUI.GetPlayerID() == %d then
            if not ModuleGUI.Local.SavingWasDisabled then
                API.DisableSaving(false);
            end
            ModuleGUI.Local.SavingWasDisabled = false;
          end]],
        _ID,
        _PlayerID,
        _PlayerID
    ))
    API.SendScriptEvent(QSB.ScriptEvents.CinematicConcluded, _ID, _PlayerID);
end

function ModuleGUI.Global:ShowInitialBlackscreen()
    if not Framework.IsNetworkGame() then
        Logic.ExecuteInLuaLocalState([[
            XGUIEng.PopPage();
            API.ActivateColoredScreen(GUI.GetPlayerID(), 0, 0, 0, 255);
            API.DeactivateNormalInterface(GUI.GetPlayerID());
            XGUIEng.PushPage("/LoadScreen/LoadScreen", false);
        ]]);
    end
end

-- Local -------------------------------------------------------------------- --

function ModuleGUI.Local:OnGameStart()
    QSB.ScriptEvents.BuildingPlaced = API.RegisterScriptEvent("Event_BuildingPlaced");
    QSB.ScriptEvents.CinematicActivated = API.RegisterScriptEvent("Event_CinematicElementActivated");
    QSB.ScriptEvents.CinematicConcluded = API.RegisterScriptEvent("Event_CinematicElementConcluded");
    QSB.ScriptEvents.BorderScrollLocked = API.RegisterScriptEvent("Event_BorderScrollLocked");
    QSB.ScriptEvents.BorderScrollReset  = API.RegisterScriptEvent("Event_BorderScrollReset");
    QSB.ScriptEvents.GameInterfaceShown = API.RegisterScriptEvent("Event_GameInterfaceShown");
    QSB.ScriptEvents.GameInterfaceHidden = API.RegisterScriptEvent("Event_GameInterfaceHidden");
    QSB.ScriptEvents.ImageScreenShown = API.RegisterScriptEvent("Event_ImageScreenShown");
    QSB.ScriptEvents.ImageScreenHidden = API.RegisterScriptEvent("Event_ImageScreenHidden");

    for i= 1, 8 do
        self.CinematicElementStatus[i] = {};
    end
    self:PostTexturePositionsToGlobal();
    self:OverrideAfterBuildingPlacement();
    self:OverrideInterfaceUpdateForCinematicMode();
    self:OverrideInterfaceThroneroomForCinematicMode();
    self:OverrideMissionGoodCounter();
    self:OverrideUpdateClaimTerritory();
    self:SetupHackRegisterHotkey();
    self:ResetFarClipPlane();
end

function ModuleGUI.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
        if not Framework.IsNetworkGame() then
            self:InterfaceDeactivateImageBackground(GUI.GetPlayerID());
            self:InterfaceActivateNormalInterface(GUI.GetPlayerID());
        end
    elseif _ID == QSB.ScriptEvents.CinematicActivated then
        self.CinematicElementStatus[arg[2]][arg[1]] = 1;
    elseif _ID == QSB.ScriptEvents.CinematicConcluded then
        for i= 1, 8 do
            if self.CinematicElementStatus[i][arg[1]] then
                self.CinematicElementStatus[i][arg[1]] = 2;
            end
        end
    elseif _ID == QSB.ScriptEvents.SaveGameLoaded then
        self:ResetFarClipPlane();
        self:UpdateHiddenWidgets();
    end
end

-- -------------------------------------------------------------------------- --

function ModuleGUI.Local:OverrideAfterBuildingPlacement()
    GameCallback_GUI_AfterBuildingPlacement_Orig_EntityEventCore = GameCallback_GUI_AfterBuildingPlacement;
    GameCallback_GUI_AfterBuildingPlacement = function ()
        GameCallback_GUI_AfterBuildingPlacement_Orig_EntityEventCore();

        local x,y = GUI.Debug_GetMapPositionUnderMouse();
        API.StartHiResDelay(0, function()
            local Results = {Logic.GetPlayerEntitiesInArea(GUI.GetPlayerID(), 0, x, y, 50, 16)};
            for i= 2, Results[1] +1 do
                if  Results[i]
                and Results[i] ~= 0
                and Logic.IsBuilding(Results[i]) == 1
                and Logic.IsConstructionComplete(Results[i]) == 0
                then
                    API.BroadcastScriptEventToGlobal("BuildingPlaced", Results[i], Logic.EntityGetPlayer(Results[i]));
                    API.SendScriptEvent(QSB.ScriptEvents.BuildingPlaced, Results[i], Logic.EntityGetPlayer(Results[i]));
                end
            end
        end, x, y);
    end
end

-- -------------------------------------------------------------------------- --

function ModuleGUI.Local:PostTexturePositionsToGlobal()
    API.StartJob(function()
        if Logic.GetTime() > 1 then
            for k, v in pairs(g_TexturePositions) do
                for kk, vv in pairs(v) do
                    API.SendScriptCommand(
                        QSB.ScriptCommands.UpdateTexturePosition,
                        GUI.GetPlayerID(),
                        k,
                        kk,
                        vv
                    );
                end
            end
            return true;
        end
    end);
end

-- -------------------------------------------------------------------------- --

function ModuleGUI.Local:DisplayInterfaceButton(_Widget, _Hide)
    self.HiddenWidgets[_Widget] = _Hide == true;
    XGUIEng.ShowWidget(_Widget, (_Hide == true and 0) or 1);
end

function ModuleGUI.Local:UpdateHiddenWidgets()
    for k, v in pairs(self.HiddenWidgets) do
        XGUIEng.ShowWidget(k, 0);
    end
end

function ModuleGUI.Local:OverrideMissionGoodCounter()
    StartMissionGoodOrEntityCounter = function(_Icon, _AmountToReach)
        local IconWidget = "/InGame/Root/Normal/MissionGoodOrEntityCounter/Icon";
        local CounterWidget = "/InGame/Root/Normal/MissionGoodOrEntityCounter";
        if type(_Icon[3]) == "string" or _Icon[3] > 2 then
            ModuleGUI.Local:SetIcon(IconWidget, _Icon, 64, _Icon[3]);
        else
            SetIcon(IconWidget, _Icon);
        end
        g_MissionGoodOrEntityCounterAmountToReach = _AmountToReach;
        g_MissionGoodOrEntityCounterIcon = _Icon;
        XGUIEng.ShowWidget(CounterWidget, 1);
    end
end

function ModuleGUI.Local:OverrideUpdateClaimTerritory()
    GUI_Knight.ClaimTerritoryUpdate_Orig_QSB_Interface = GUI_Knight.ClaimTerritoryUpdate;
    GUI_Knight.ClaimTerritoryUpdate = function()
        GUI_Knight.ClaimTerritoryUpdate_Orig_QSB_Interface();
        local Key = "/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory";
        if ModuleGUI.Local.HiddenWidgets[Key] == true then
            XGUIEng.ShowWidget(Key, 0);
            return true;
        end
    end
end

function ModuleGUI.Local:SetPlayerPortraitByPrimaryKnight(_PlayerID)
    local KnightID = Logic.GetKnightID(_PlayerID);
    local HeadModelName = "H_NPC_Generic_Trader";
    if KnightID ~= 0 then
        local KnightType = Logic.GetEntityType(KnightID);
        local KnightTypeName = Logic.GetEntityTypeName(KnightType);
        HeadModelName = "H" .. string.sub(KnightTypeName, 2, 8) .. "_" .. string.sub(KnightTypeName, 9);

        if not Models["Heads_" .. HeadModelName] then
            HeadModelName = "H_NPC_Generic_Trader";
        end
    end
    g_PlayerPortrait[_PlayerID] = HeadModelName;
end

function ModuleGUI.Local:SetPlayerPortraitBySettler(_PlayerID, _Portrait)
    local PortraitMap = {
        ["U_KnightChivalry"]           = "H_Knight_Chivalry",
        ["U_KnightHealing"]            = "H_Knight_Healing",
        ["U_KnightPlunder"]            = "H_Knight_Plunder",
        ["U_KnightRedPrince"]          = "H_Knight_RedPrince",
        ["U_KnightSabatta"]            = "H_Knight_Sabatt",
        ["U_KnightSong"]               = "H_Knight_Song",
        ["U_KnightTrading"]            = "H_Knight_Trading",
        ["U_KnightWisdom"]             = "H_Knight_Wisdom",
        ["U_NPC_Amma_NE"]              = "H_NPC_Amma",
        ["U_NPC_Castellan_ME"]         = "H_NPC_Castellan_ME",
        ["U_NPC_Castellan_NA"]         = "H_NPC_Castellan_NA",
        ["U_NPC_Castellan_NE"]         = "H_NPC_Castellan_NE",
        ["U_NPC_Castellan_SE"]         = "H_NPC_Castellan_SE",
        ["U_MilitaryBandit_Ranged_ME"] = "H_NPC_Mercenary_ME",
        ["U_MilitaryBandit_Melee_NA"]  = "H_NPC_Mercenary_NA",
        ["U_MilitaryBandit_Melee_NE"]  = "H_NPC_Mercenary_NE",
        ["U_MilitaryBandit_Melee_SE"]  = "H_NPC_Mercenary_SE",
        ["U_NPC_Monk_ME"]              = "H_NPC_Monk_ME",
        ["U_NPC_Monk_NA"]              = "H_NPC_Monk_NA",
        ["U_NPC_Monk_NE"]              = "H_NPC_Monk_NE",
        ["U_NPC_Monk_SE"]              = "H_NPC_Monk_SE",
        ["U_NPC_Villager01_ME"]        = "H_NPC_Villager01_ME",
        ["U_NPC_Villager01_NA"]        = "H_NPC_Villager01_NA",
        ["U_NPC_Villager01_NE"]        = "H_NPC_Villager01_NE",
        ["U_NPC_Villager01_SE"]        = "H_NPC_Villager01_SE",
    }

    if g_GameExtraNo > 0 then
        PortraitMap["U_KnightPraphat"]           = "H_Knight_Praphat";
        PortraitMap["U_KnightSaraya"]            = "H_Knight_Saraya";
        PortraitMap["U_KnightKhana"]             = "H_Knight_Khana";
        PortraitMap["U_MilitaryBandit_Melee_AS"] = "H_NPC_Mercenary_AS";
        PortraitMap["U_NPC_Castellan_AS"]        = "H_NPC_Castellan_AS";
        PortraitMap["U_NPC_Villager_AS"]         = "H_NPC_Villager_AS";
        PortraitMap["U_NPC_Monk_AS"]             = "H_NPC_Monk_AS";
        PortraitMap["U_NPC_Monk_Khana"]          = "H_NPC_Monk_Khana";
    end

    local HeadModelName = "H_NPC_Generic_Trader";
    local EntityID = GetID(_Portrait);
    if EntityID ~= 0 then
        local EntityType = Logic.GetEntityType(EntityID);
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);
        HeadModelName = PortraitMap[EntityTypeName] or "H_NPC_Generic_Trader";
        if not HeadModelName then
            HeadModelName = "H_NPC_Generic_Trader";
        end
    end
    g_PlayerPortrait[_PlayerID] = HeadModelName;
end

function ModuleGUI.Local:SetPlayerPortraitByModelName(_PlayerID, _Portrait)
    if not Models["Heads_" .. tostring(_Portrait)] then
        _Portrait = "H_NPC_Generic_Trader";
    end
    g_PlayerPortrait[_PlayerID] = _Portrait;
end

function ModuleGUI.Local:SetIcon(_WidgetID, _Coordinates, _Size, _Name)
    _Size = _Size or 64;
    _Coordinates[3] = _Coordinates[3] or 0;
    if _Name == nil then
        return SetIcon(_WidgetID, _Coordinates, _Size);
    end
    assert(_Size == 44 or _Size == 64 or _Size == 128);
    if _Size == 44 then
        _Name = _Name.. ".png";
    end
    if _Size == 64 then
        _Name = _Name.. "big.png";
    end
    if _Size == 128 then
        _Name = _Name.. "verybig.png";
    end

    local u0, u1, v0, v1;
    u0 = (_Coordinates[1] - 1) * _Size;
    v0 = (_Coordinates[2] - 1) * _Size;
    u1 = (_Coordinates[1]) * _Size;
    v1 = (_Coordinates[2]) * _Size;
    State = 1;
    if XGUIEng.IsButton(_WidgetID) == 1 then
        State = 7;
    end
    XGUIEng.SetMaterialAlpha(_WidgetID, State, 255);
    XGUIEng.SetMaterialTexture(_WidgetID, State, _Name);
    XGUIEng.SetMaterialUV(_WidgetID, State, u0, v0, u1, v1);
end

function ModuleGUI.Local:TooltipNormal(_title, _text, _disabledText)
    if _title and _title:find("[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _title = XGUIEng.GetStringTableText(_title);
    end
    if _text and _text:find("[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _text = XGUIEng.GetStringTableText(_text);
    end
    _disabledText = _disabledText or "";
    if _disabledText and _disabledText:find("[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _disabledText = XGUIEng.GetStringTableText(_disabledText);
    end

    local TooltipContainerPath = "/InGame/Root/Normal/TooltipNormal";
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath);
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name");
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text");
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG");
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn");
    local PositionWidget = XGUIEng.GetCurrentWidgetID();

    local title = (_title and _title) or "";
    local text = (_text and _text) or "";
    local disabled = "";
    if XGUIEng.IsButtonDisabled(PositionWidget) == 1 and _disabledText then
        disabled = disabled .. "{cr}{@color:255,32,32,255}" .. _disabledText;
    end

    XGUIEng.SetText(TooltipNameWidget, "{center}" .. title);
    XGUIEng.SetText(TooltipDescriptionWidget, text .. disabled);
    local Height = XGUIEng.GetTextHeight(TooltipDescriptionWidget, true);
    local W, H = XGUIEng.GetWidgetSize(TooltipDescriptionWidget);
    XGUIEng.SetWidgetSize(TooltipDescriptionWidget, W, Height);

    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget);
    local TooltipContainerSizeWidgets = {TooltipBGWidget};
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget);
    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer);
end

function ModuleGUI.Local:TooltipCosts(_title,_text,_disabledText,_costs,_inSettlement)
    _costs = _costs or {};
    local Costs = {};
    -- This transforms the content of a metatable to a new table so that the
    -- internal script does correctly render the costs.
    for i= 1, 4, 1 do
        Costs[i] = _costs[i];
    end
    if _title and _title:find("[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _title = XGUIEng.GetStringTableText(_title);
    end
    if _text and _text:find("[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _text = XGUIEng.GetStringTableText(_text);
    end
    if _disabledText and _disabledText:find("^[A-Za-z0-9]+/[A-Za-z0-9]+$") then
        _disabledText = XGUIEng.GetStringTableText(_disabledText);
    end

    local TooltipContainerPath = "/InGame/Root/Normal/TooltipBuy";
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath);
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name");
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text");
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG");
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn");
    local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs");
    local PositionWidget = XGUIEng.GetCurrentWidgetID();

    local title = (_title and _title) or "";
    local text = (_text and _text) or "";
    local disabled = "";
    if XGUIEng.IsButtonDisabled(PositionWidget) == 1 and _disabledText then
        disabled = disabled .. "{cr}{@color:255,32,32,255}" .. _disabledText;
    end

    XGUIEng.SetText(TooltipNameWidget, "{center}" .. title);
    XGUIEng.SetText(TooltipDescriptionWidget, text .. disabled);
    local Height = XGUIEng.GetTextHeight(TooltipDescriptionWidget, true);
    local W, H = XGUIEng.GetWidgetSize(TooltipDescriptionWidget);
    XGUIEng.SetWidgetSize(TooltipDescriptionWidget, W, Height);

    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget);
    GUI_Tooltip.SetCosts(TooltipCostsContainer, Costs, _inSettlement);
    local TooltipContainerSizeWidgets = {TooltipContainer, TooltipCostsContainer, TooltipBGWidget};
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, nil, true);
    GUI_Tooltip.OrderTooltip(TooltipContainerSizeWidgets, TooltipFadeInContainer, TooltipCostsContainer, PositionWidget, TooltipBGWidget);
    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer);
end

function ModuleGUI.Local:SetupHackRegisterHotkey()
    function g_KeyBindingsOptions:OnShow()
        if Game ~= nil then
            XGUIEng.ShowWidget("/InGame/KeyBindingsMain/Backdrop", 1);
        else
            XGUIEng.ShowWidget("/InGame/KeyBindingsMain/Backdrop", 0);
        end

        if g_KeyBindingsOptions.Descriptions == nil then
            g_KeyBindingsOptions.Descriptions = {};
            DescRegister("MenuInGame");
            DescRegister("MenuDiplomacy");
            DescRegister("MenuProduction");
            DescRegister("MenuPromotion");
            DescRegister("MenuWeather");
            DescRegister("ToggleOutstockInformations");
            DescRegister("JumpMarketplace");
            DescRegister("JumpMinimapEvent");
            DescRegister("BuildingUpgrade");
            DescRegister("BuildLastPlaced");
            DescRegister("BuildStreet");
            DescRegister("BuildTrail");
            DescRegister("KnockDown");
            DescRegister("MilitaryAttack");
            DescRegister("MilitaryStandGround");
            DescRegister("MilitaryGroupAdd");
            DescRegister("MilitaryGroupSelect");
            DescRegister("MilitaryGroupStore");
            DescRegister("MilitaryToggleUnits");
            DescRegister("UnitSelect");
            DescRegister("UnitSelectToggle");
            DescRegister("UnitSelectSameType");
            DescRegister("StartChat");
            DescRegister("StopChat");
            DescRegister("QuickSave");
            DescRegister("QuickLoad");
            DescRegister("TogglePause");
            DescRegister("RotateBuilding");
            DescRegister("ExitGame");
            DescRegister("Screenshot");
            DescRegister("ResetCamera");
            DescRegister("CameraMove");
            DescRegister("CameraMoveMouse");
            DescRegister("CameraZoom");
            DescRegister("CameraZoomMouse");
            DescRegister("CameraRotate");

            for k,v in pairs(ModuleGUI.Local.HotkeyDescriptions) do
                if v then
                    v[1] = (type(v[1]) == "table" and API.Localize(v[1])) or v[1];
                    v[2] = (type(v[2]) == "table" and API.Localize(v[2])) or v[2];
                    table.insert(g_KeyBindingsOptions.Descriptions, 1, v);
                end
            end
        end
        XGUIEng.ListBoxPopAll(g_KeyBindingsOptions.Widget.ShortcutList);
        XGUIEng.ListBoxPopAll(g_KeyBindingsOptions.Widget.ActionList);
        for Index, Desc in ipairs(g_KeyBindingsOptions.Descriptions) do
            XGUIEng.ListBoxPushItem(g_KeyBindingsOptions.Widget.ShortcutList, Desc[1]);
            XGUIEng.ListBoxPushItem(g_KeyBindingsOptions.Widget.ActionList,   Desc[2]);
        end
    end
end

-- -------------------------------------------------------------------------- --

function ModuleGUI.Local:SetFarClipPlane(_View)
    Camera.Cutscene_SetFarClipPlane(_View, _View);
    Display.SetFarClipPlaneMinAndMax(_View, _View);
end

function ModuleGUI.Local:ResetFarClipPlane()
    Camera.Cutscene_SetFarClipPlane(QSB.FarClipDefault.MAX);
    Display.SetFarClipPlaneMinAndMax(
        QSB.FarClipDefault.MIN,
        QSB.FarClipDefault.MAX
    );
end

function ModuleGUI.Local:GetCinematicElementStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicElementStatus[i][_InfoID] then
            return self.CinematicElementStatus[i][_InfoID];
        end
    end
    return 0;
end

function ModuleGUI.Local:OverrideInterfaceUpdateForCinematicMode()
    GameCallback_GameSpeedChanged_Orig_ModuleGUIInterface = GameCallback_GameSpeedChanged;
    GameCallback_GameSpeedChanged = function(_Speed)
        if not ModuleGUI.Local.PauseScreenShown then
            GameCallback_GameSpeedChanged_Orig_ModuleGUIInterface(_Speed);
        end
    end

    MissionTimerUpdate_Orig_ModuleGUIInterface = MissionTimerUpdate;
    MissionTimerUpdate = function()
        MissionTimerUpdate_Orig_ModuleGUIInterface();
        if ModuleGUI.Local.NormalModeHidden
        or ModuleGUI.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0);
        end
    end

    MissionGoodOrEntityCounterUpdate_Orig_ModuleGUIInterface = MissionGoodOrEntityCounterUpdate;
    MissionGoodOrEntityCounterUpdate = function()
        MissionGoodOrEntityCounterUpdate_Orig_ModuleGUIInterface();
        if ModuleGUI.Local.NormalModeHidden
        or ModuleGUI.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0);
        end
    end

    MerchantButtonsUpdater_Orig_ModuleGUIInterface = GUI_Merchant.ButtonsUpdater;
    GUI_Merchant.ButtonsUpdater = function()
        MerchantButtonsUpdater_Orig_ModuleGUIInterface();
        if ModuleGUI.Local.NormalModeHidden
        or ModuleGUI.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 0);
        end
    end

    if GUI_Tradepost then
        TradepostButtonsUpdater_Orig_ModuleGUIInterface = GUI_Tradepost.ButtonsUpdater;
        GUI_Tradepost.ButtonsUpdater = function()
            TradepostButtonsUpdater_Orig_ModuleGUIInterface();
            if ModuleGUI.Local.NormalModeHidden
            or ModuleGUI.Local.PauseScreenShown then
                XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 0);
            end
        end
    end
end

function ModuleGUI.Local:OverrideInterfaceThroneroomForCinematicMode()
    GameCallback_Camera_StartButtonPressed = function(_PlayerID)
    end
    OnStartButtonPressed = function()
        GameCallback_Camera_StartButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_BackButtonPressed = function(_PlayerID)
    end
    OnBackButtonPressed = function()
        GameCallback_Camera_BackButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_SkipButtonPressed = function(_PlayerID)
    end
    OnSkipButtonPressed = function()
        GameCallback_Camera_SkipButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_ThroneRoomLeftClick = function(_PlayerID)
    end
    ThroneRoomLeftClick = function()
        GameCallback_Camera_ThroneRoomLeftClick(GUI.GetPlayerID());
    end

    GameCallback_Camera_ThroneroomCameraControl = function(_PlayerID)
    end
    ThroneRoomCameraControl = function()
        GameCallback_Camera_ThroneroomCameraControl(GUI.GetPlayerID());
    end
end

function ModuleGUI.Local:InterfaceActivateImageBackground(_PlayerID, _Graphic, _R, _G, _B, _A)
    if _PlayerID ~= GUI.GetPlayerID() or self.PauseScreenShown then
        return;
    end
    self.PauseScreenShown = true;

    XGUIEng.PushPage("/InGame/Root/Normal/PauseScreen", false);
    XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen", 1);
    if _Graphic and _Graphic ~= "" then
        local Size = {GUI.GetScreenSize()};
        local u0, v0, u1, v1 = 0, 0, 1, 1;
        if Size[1]/Size[2] < 1.6 then
            u0 = u0 + (u0 / 0.125);
            u1 = u1 - (u1 * 0.125);
        end
        XGUIEng.SetMaterialTexture("/InGame/Root/Normal/PauseScreen", 0, _Graphic);
        XGUIEng.SetMaterialUV("/InGame/Root/Normal/PauseScreen", 0, u0, v0, u1, v1);
    end
    XGUIEng.SetMaterialColor("/InGame/Root/Normal/PauseScreen", 0, _R, _G, _B, _A);
    API.SendScriptEventToGlobal("ImageScreenShown", _PlayerID);
    API.SendScriptEvent(QSB.ScriptEvents.ImageScreenShown, _PlayerID);
end

function ModuleGUI.Local:InterfaceDeactivateImageBackground(_PlayerID)
    if _PlayerID ~= GUI.GetPlayerID() or not self.PauseScreenShown then
        return;
    end
    self.PauseScreenShown = false;

    XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen", 0);
    XGUIEng.SetMaterialTexture("/InGame/Root/Normal/PauseScreen", 0, "");
    XGUIEng.SetMaterialColor("/InGame/Root/Normal/PauseScreen", 0, 40, 40, 40, 180);
    XGUIEng.PopPage();
    API.SendScriptEventToGlobal("ImageScreenHidden", _PlayerID);
    API.SendScriptEvent(QSB.ScriptEvents.ImageScreenHidden, _PlayerID);
end

function ModuleGUI.Local:InterfaceDeactivateBorderScroll(_PlayerID, _PositionID)
    if _PlayerID ~= GUI.GetPlayerID() or self.BorderScrollDeactivated then
        return;
    end
    self.BorderScrollDeactivated = true;
    if _PositionID then
        Camera.RTS_FollowEntity(_PositionID);
    end
    Camera.RTS_SetBorderScrollSize(0);
    Camera.RTS_SetZoomWheelSpeed(0);

    API.SendScriptEventToGlobal("BorderScrollLocked", _PlayerID, (_PositionID or 0));
    API.SendScriptEvent(QSB.ScriptEvents.BorderScrollLocked, _PlayerID, _PositionID);
end

function ModuleGUI.Local:InterfaceActivateBorderScroll(_PlayerID)
    if _PlayerID ~= GUI.GetPlayerID() or not self.BorderScrollDeactivated then
        return;
    end
    self.BorderScrollDeactivated = false;
    Camera.RTS_FollowEntity(0);
    Camera.RTS_SetBorderScrollSize(3.0);
    Camera.RTS_SetZoomWheelSpeed(4.2);

    API.SendScriptEventToGlobal("BorderScrollReset", _PlayerID);
    API.SendScriptEvent(QSB.ScriptEvents.BorderScrollReset, _PlayerID);
end

function ModuleGUI.Local:InterfaceDeactivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or self.NormalModeHidden then
        return;
    end
    self.NormalModeHidden = true;

    XGUIEng.PushPage("/InGame/Root/Normal/NotesWindow", false);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/TextMessages", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopRight", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar/UpdateFunction", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestLogButton", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestTimers", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0);
    HideOtherMenus();
    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignTopLeft/GameClock") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 0);
        self.GameClockWasShown = true;
    end
    if XGUIEng.IsWidgetShownEx("/InGame/Root/Normal/ChatOptions/Background") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions", 0);
        self.ChatOptionsWasShown = true;
    end
    if XGUIEng.IsWidgetShownEx("/InGame/Root/Normal/MessageLog/Name") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog", 0);
        self.MessageLogWasShown = true;
    end
    if g_GameExtraNo > 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 0);
    end

    API.SendScriptEventToGlobal("GameInterfaceHidden", GUI.GetPlayerID());
    API.SendScriptEvent(QSB.ScriptEvents.GameInterfaceHidden, GUI.GetPlayerID());
end

function ModuleGUI.Local:InterfaceActivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or not self.NormalModeHidden then
        return;
    end
    self.NormalModeHidden = false;

    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar/UpdateFunction", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestLogButton", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestTimers", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message", 1);
    XGUIEng.PopPage();

    -- Timer
    if g_MissionTimerEndTime then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 1);
    end
    -- Counter
    if g_MissionGoodOrEntityCounterAmountToReach then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 1);
    end
    -- Debug Clock
    if self.GameClockWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 1);
        self.GameClockWasShown = false;
    end
    -- Chat Options
    if self.ChatOptionsWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions", 1);
        self.ChatOptionsWasShown = false;
    end
    -- Message Log
    if self.MessageLogWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog", 1);
        self.MessageLogWasShown = false;
    end
    -- Handelsposten
    if g_GameExtraNo > 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 1);
    end

    API.SendScriptEventToGlobal("GameInterfaceShown", GUI.GetPlayerID());
    API.SendScriptEvent(QSB.ScriptEvents.GameInterfaceShown, GUI.GetPlayerID());
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleGUI);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

---
-- Funktionen zur Veränderung der Benutzeroberfläche.
--
-- <h5>Cinematic Event</h5>
-- <b>Ein Kinoevent hat nichts mit den Script Events zu tun!</b> <br>
-- Es handelt sich um eine Markierung, ob für einen Spieler gerade ein Ereignis
-- stattfindet, das das normale Spielinterface manipuliert und den normalen
-- Spielfluss einschränkt. Es wird von der QSB benutzt um festzustellen, ob
-- bereits ein solcher veränderter Zustand aktiv ist und entsorechend darauf
-- zu reagieren, damit sichergestellt ist, dass beim Zurücksetzen des normalen
-- Zustandes keine Fehler passieren.
-- 
-- Der Anwender braucht sich damit nicht zu befassen, es sei denn man plant
-- etwas, das mit Kinoevents kollidieren kann. Wenn ein Feature ein Kinoevent
-- auslöst, ist dies in der Dokumentation ausgewiesen.
-- 
-- Während eines Kinoevent kann zusätzlich nicht gespeichert werden.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

QSB.CinematicElement = {};

CinematicElement = {
    NotTriggered = 0,
    Active = 1,
    Concluded = 2,
}

---
-- Events, auf die reagiert werden kann.
--
-- @field BuildingPlaced      Ein Gebäude wurde in Auftrag gegeben. (Parameter: EntityID, PlayerID)
-- @field CinematicActivated  Ein Kinoevent wurde aktiviert (Parameter: KinoEventID, PlayerID)
-- @field CinematicConcluded  Ein Kinoevent wurde deaktiviert (Parameter: KinoEventID, PlayerID)
-- @field BorderScrollLocked  Scrollen am Bildschirmrand wurde gesperrt (Parameter: PlayerID)
-- @field BorderScrollReset   Scrollen am Bildschirmrand wurde freigegeben (Parameter: PlayerID)
-- @field GameInterfaceShown  Die Spieloberfläche wird angezeigt (Parameter: PlayerID)
-- @field GameInterfaceHidden Die Spieloberfläche wird ausgeblendet (Parameter: PlayerID)
-- @field ImageScreenShown    Der schwarze Hintergrund wird angezeigt (Parameter: PlayerID)
-- @field ImageScreenHidden   Der schwarze Hintergrund wird ausgeblendet (Parameter: PlayerID)
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

-- Just to be compatible with the old version.
function API.ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
    API.ActivateImageScreen(_PlayerID, "", _Red or 0, _Green or 0, _Blue or 0, _Alpha);
end

-- Just to be compatible with the old version.
function API.DeactivateColoredScreen(_PlayerID)
    API.DeactivateImageScreen(_PlayerID)
end

---
-- Blendet eine Graphic über der Spielwelt aber hinter dem Interface ein.
-- Die Grafik muss im 16:9-Format sein. Bei 4:3-Auflösungen wird
-- links und rechts abgeschnitten.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=string] _Image Pfad zur Grafik
-- @param[type=number] _Red   (Optional) Rotwert (Standard: 255)
-- @param[type=number] _Green (Optional) Grünwert (Standard: 255)
-- @param[type=number] _Blue  (Optional) Blauwert (Standard: 255)
-- @param[type=number] _Alpha (Optional) Alphawert (Standard: 255)
-- @within Anwenderfunktionen
--
function API.ActivateImageScreen(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[ModuleGUI.Local:InterfaceActivateImageBackground(%d, "%s", %d, %d, %d, %d)]],
            _PlayerID,
            _Image,
            (_Red ~= nil and _Red) or 255,
            (_Green ~= nil and _Green) or 255,
            (_Blue ~= nil and _Blue) or 255,
            (_Alpha ~= nil and _Alpha) or 255
        ));
        return;
    end
    ModuleGUI.Local:InterfaceActivateImageBackground(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha);
end

---
-- Deaktiviert ein angezeigtes Bild, wenn dieses angezeigt wird.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.DeactivateImageScreen(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceDeactivateImageBackground(%d)",
            _PlayerID
        ));
        return;
    end
    ModuleGUI.Local:InterfaceDeactivateImageBackground(_PlayerID);
end

---
-- Zeigt das normale Interface an.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.ActivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceActivateNormalInterface(%d)",
            _PlayerID
        ));
        return;
    end
    ModuleGUI.Local:InterfaceActivateNormalInterface(_PlayerID);
end

---
-- Blendet das normale Interface aus.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.DeactivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceDeactivateNormalInterface(%d)",
            _PlayerID
        ));
        return;
    end
    ModuleGUI.Local:InterfaceDeactivateNormalInterface(_PlayerID);
end

---
-- Akliviert border Scroll wieder und löst die Fixierung auf ein Entity auf.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.ActivateBorderScroll(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceActivateBorderScroll(%d)",
            _PlayerID
        ));
        return;
    end
    ModuleGUI.Local:InterfaceActivateBorderScroll(_PlayerID);
end

---
-- Deaktiviert Randscrollen und setzt die Kamera optional auf das Ziel
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _Position (Optional) Entity auf das die Kamera schaut
-- @within Anwenderfunktionen
--
function API.DeactivateBorderScroll(_PlayerID, _Position)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    local PositionID;
    if _Position then
        PositionID = GetID(_Position);
    end
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            "ModuleGUI.Local:InterfaceDeactivateBorderScroll(%d, %d)",
            _PlayerID,
            (PositionID or 0)
        ));
        return;
    end
    ModuleGUI.Local:InterfaceDeactivateBorderScroll(_PlayerID, PositionID);
end

---
-- Propagiert den Beginn des Kinoevent und bindet es an den Spieler.
--
-- <b>Hinweis:</b>Während des aktiven Kinoevent kann nicht gespeichert werden.
--
-- @param[type=string] _Name     Bezeichner
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.StartCinematicElement(_Name, _PlayerID)
    if GUI then
        return;
    end
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    QSB.CinematicElement[_PlayerID] = QSB.CinematicElement[_PlayerID] or {};
    local ID = ModuleGUI.Global:ActivateCinematicElement(_PlayerID);
    QSB.CinematicElement[_PlayerID][_Name] = ID;
end

---
-- Propagiert das Ende des Kinoevent.
--
-- @param[type=string] _Name     Bezeichner
-- @param[type=number] _PlayerID ID des Spielers
-- @within Anwenderfunktionen
--
function API.FinishCinematicElement(_Name, _PlayerID)
    if GUI then
        return;
    end
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    QSB.CinematicElement[_PlayerID] = QSB.CinematicElement[_PlayerID] or {};
    if QSB.CinematicElement[_PlayerID][_Name] then
        ModuleGUI.Global:ConcludeCinematicElement(QSB.CinematicElement[_PlayerID][_Name], _PlayerID);
    end
end

---
-- Gibt den Zustand des Kinoevent zurück.
--
-- @param _Identifier            Bezeichner oder ID
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=number] Zustand des Kinoevent
-- @within Anwenderfunktionen
--
function API.GetCinematicElement(_Identifier, _PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    QSB.CinematicElement[_PlayerID] = QSB.CinematicElement[_PlayerID] or {};
    if type(_Identifier) == "number" then
        if GUI then
            return ModuleGUI.Local:GetCinematicElementStatus(_Identifier);
        end
        return ModuleGUI.Global:GetCinematicElementStatus(_Identifier);
    end
    if QSB.CinematicElement[_PlayerID][_Identifier] then
        if GUI then
            return ModuleGUI.Local:GetCinematicElementStatus(QSB.CinematicElement[_PlayerID][_Identifier]);
        end
        return ModuleGUI.Global:GetCinematicElementStatus(QSB.CinematicElement[_PlayerID][_Identifier]);
    end
    return CinematicElement.NotTriggered;
end

---
-- Prüft ob gerade ein Kinoevent für den Spieler aktiv ist.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=boolean] Kinoevent ist aktiv
-- @within Anwenderfunktionen
--
function API.IsCinematicElementActive(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    QSB.CinematicElement[_PlayerID] = QSB.CinematicElement[_PlayerID] or {};
    for k, v in pairs(QSB.CinematicElement[_PlayerID]) do
        if API.GetCinematicElement(k, _PlayerID) == CinematicElement.Active then
            return true;
        end
    end
    return false;
end

---
-- Setzt einen Icon aus einer Icon Matrix.
--
-- Es ist möglich, eine benutzerdefinierte Icon Matrix zu verwenden.
-- Dafür müssen die Quellen nach gui_768, gui_920 und gui_1080 in der
-- entsprechenden Größe gepackt werden, da das Spiel für unterschiedliche
-- Auflösungen in verschiedene Verzeichnisse schaut.
-- 
-- Die Dateien müssen in <i>graphics/textures</i> liegen, was auf gleicher
-- Ebene ist, wie <i>maps/externalmap</i>.
-- Jede Map muss einen eigenen eindeutigen Namen für jede Grafik verwenden, da
-- diese Grafiken solange geladen werden, wie die Map im Verzeichnis liegt.
--
-- Es können 3 verschiedene Icon-Größen angegeben werden. Je nach dem welche
-- Größe gefordert wird, wird nach einer anderen Datei gesucht. Es entscheidet
-- der als Name angegebene Präfix.
-- <ul>
-- <li>keine: siehe 64</li>
-- <li>44: [Dateiname].png</li>
-- <li>64: [Dateiname]big.png</li>
-- <li>1200: [Dateiname]verybig.png</li>
-- </ul>
--
-- @param[type=string] _WidgetID Widgetpfad oder ID
-- @param[type=table]  _Coordinates Koordinaten [Format: {x, y, addon}]
-- @param[type=number] _Size (Optional) Größe des Icon
-- @param[type=string] _Name (Optional) Base Name der Icon Matrix
-- @within Anwenderfunktionen
--
-- @usage
-- -- Setzt eine Originalgrafik
-- API.SetIcon(AnyWidgetID, {1, 1, 1});
--
-- -- Setzt eine benutzerdefinierte Grafik
-- API.SetIcon(AnyWidgetID, {8, 5}, nil, "meinetollenicons");
-- -- (Es wird als Datei gesucht: meinetolleniconsbig.png)
--
-- -- Setzt eine benutzerdefinierte Grafik
-- API.SetIcon(AnyWidgetID, {8, 5}, 128, "meinetollenicons");
-- -- (Es wird als Datei gesucht: meinetolleniconsverybig.png)
--
function API.SetIcon(_WidgetID, _Coordinates, _Size, _Name)
    if not GUI then
        return;
    end
    _Coordinates = _Coordinates or {10, 14};
    ModuleGUI.Local:SetIcon(_WidgetID, _Coordinates, _Size, _Name);
end

---
-- Ändert den Beschreibungstext eines Button oder eines Icon.
--
-- Wichtig ist zu beachten, dass diese Funktion in der Tooltip-Funktion des
-- Button oder Icon ausgeführt werden muss.
--
-- Die Funktion kann auch mit deutsch/english lokalisierten Tabellen als
-- Text gefüttert werden. In diesem Fall wird der deutsche Text genommen,
-- wenn es sich um eine deutsche Spielversion handelt. Andernfalls wird
-- immer der englische Text verwendet.
--
-- @param[type=string] _title        Titel des Tooltip
-- @param[type=string] _text         Text des Tooltip
-- @param[type=string] _disabledText Textzusatz wenn inaktiv
-- @within Anwenderfunktionen
--
function API.SetTooltipNormal(_title, _text, _disabledText)
    if not GUI then
        return;
    end
    ModuleGUI.Local:TooltipNormal(_title, _text, _disabledText);
end

---
-- Ändert den Beschreibungstext und die Kosten eines Button.
--
-- Wichtig ist zu beachten, dass diese Funktion in der Tooltip-Funktion des
-- Button oder Icon ausgeführt werden muss.
--
-- @see API.SetTooltipNormal
--
-- @param[type=string]  _title        Titel des Tooltip
-- @param[type=string]  _text         Text des Tooltip
-- @param[type=string]  _disabledText Textzusatz wenn inaktiv
-- @param[type=table]   _costs        Kostentabelle
-- @param[type=boolean] _inSettlement Kosten in Siedlung suchen
-- @within Anwenderfunktionen
--
function API.SetTooltipCosts(_title,_text,_disabledText,_costs,_inSettlement)
    if not GUI then
        return;
    end
    ModuleGUI.Local:TooltipCosts(_title,_text,_disabledText,_costs,_inSettlement);
end

---
-- Gibt den Namen des Territoriums zurück.
--
-- @param[type=number] _TerritoryID ID des Territoriums
-- @return[type=string]  Name des Territorium
-- @within Anwenderfunktionen
--
function API.GetTerritoryName(_TerritoryID)
    local Name = Logic.GetTerritoryName(_TerritoryID);
    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    if MapType == 1 or MapType == 3 then
        return Name;
    end

    local MapName = Framework.GetCurrentMapName();
    local StringTable = "Map_" .. MapName;
    local TerritoryName = string.gsub(Name, " ","");
    TerritoryName = XGUIEng.GetStringTableText(StringTable .. "/Territory_" .. TerritoryName);
    if TerritoryName == "" then
        TerritoryName = Name .. "(key?)";
    end
    return TerritoryName;
end
GetTerritoryName = API.GetTerritoryName;

---
-- Gibt den Namen des Spielers zurück.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=string]  Name des Spielers
-- @within Anwenderfunktionen
--
function API.GetPlayerName(_PlayerID)
    local PlayerName = Logic.GetPlayerName(_PlayerID);
    local name = QSB.PlayerNames[_PlayerID];
    if name ~= nil and name ~= "" then
        PlayerName = name;
    end

    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    local MutliplayerMode = Framework.GetMultiplayerMapMode(Framework.GetCurrentMapName(), MapType);

    if MutliplayerMode > 0 then
        return PlayerName;
    end
    if MapType == 1 or MapType == 3 then
        local PlayerNameTmp, PlayerHeadTmp, PlayerAITmp = Framework.GetPlayerInfo(_PlayerID);
        if PlayerName ~= "" then
            return PlayerName;
        end
        return PlayerNameTmp;
    end
end
GetPlayerName_OrigName = GetPlayerName;
GetPlayerName = API.GetPlayerName;

---
-- Gibt dem Spieler einen neuen Namen.
--
-- <b>hinweis</b>: Die Änderung des Spielernamens betrifft sowohl die Anzeige
-- bei den Quests als auch im Diplomatiemenü.
--
-- @param[type=number] _playerID ID des Spielers
-- @param[type=string] _name Name des Spielers
-- @within Anwenderfunktionen
--
function API.SetPlayerName(_playerID,_name)
    assert(type(_playerID) == "number");
    assert(type(_name) == "string");
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SetPlayerName(%d, "%s")]],
            _playerID,
            _name
        ));
    end
    GUI_MissionStatistic.PlayerNames[_playerID] = _name
    QSB.PlayerNames[_playerID] = _name;
end
SetPlayerName = API.SetPlayerName;

---
-- Setzt eine andere Spielerfarbe.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _Color Spielerfarbe
-- @param[type=number] _Logo Logo (optional)
-- @param[type=number] _Pattern Pattern (optional)
-- @within Anwenderfunktionen
--
function API.SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
    if GUI then
        return;
    end
    g_ColorIndex["ExtraColor1"] = g_ColorIndex["ExtraColor1"] or 16;
    g_ColorIndex["ExtraColor2"] = g_ColorIndex["ExtraColor2"] or 17;

    local Col     = (type(_Color) == "string" and g_ColorIndex[_Color]) or _Color;
    local Logo    = _Logo or -1;
    local Pattern = _Pattern or -1;

    Logic.PlayerSetPlayerColor(_PlayerID, Col, Logo, Pattern);
    Logic.ExecuteInLuaLocalState([[
        Display.UpdatePlayerColors()
        GUI.RebuildMinimapTerrain()
        GUI.RebuildMinimapTerritory()
    ]]);
end

---
-- Setzt das Portrait eines Spielers.
--
-- Dabei gibt es 3 verschiedene Varianten:
-- <ul>
-- <li>Wenn _Portrait nicht gesetzt wird, wird das Portrait des Primary
-- Knight genommen.</li>
-- <li>Wenn _Portrait ein existierendes Entity ist, wird anhand des Typs
-- das Portrait bestimmt.</li>
-- <li>Wenn _Portrait der Modellname eines Portrait ist, wird der Wert
-- als Portrait gesetzt.</li>
-- </ul>
--
-- Wenn kein Portrait bestimmt werden kann, wird H_NPC_Generic_Trader verwendet.
--
-- <b>Trivia</b>: Diese Funktionalität wird Umgangssprachlich als "Kopf
-- tauschen" oder "Kopf wechseln" bezeichnet.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=string] _Portrait Name des Models
-- @within Anwenderfunktionen
--
-- @usage
-- -- Kopf des Primary Knight
-- API.SetPlayerPortrait(2);
-- -- Kopf durch Entity bestimmen
-- API.SetPlayerPortrait(2, "amma");
-- -- Kopf durch Modelname setzen
-- API.SetPlayerPortrait(2, "H_NPC_Monk_AS");
--
function API.SetPlayerPortrait(_PlayerID, _Portrait)
    if not _PlayerID or type(_PlayerID) ~= "number" or (_PlayerID < 1 or _PlayerID > 8) then
        error("API.SetPlayerPortrait: Invalid player ID!");
        return;
    end
    if not GUI then
        local Portrait = (_Portrait ~= nil and "'" .._Portrait.. "'") or "nil";
        Logic.ExecuteInLuaLocalState("API.SetPlayerPortrait(" .._PlayerID.. ", " ..Portrait.. ")")
        return;
    end

    if _Portrait == nil then
        ModuleGUI.Local:SetPlayerPortraitByPrimaryKnight(_PlayerID);
        return;
    end
    if _Portrait ~= nil and IsExisting(_Portrait) then
        ModuleGUI.Local:SetPlayerPortraitBySettler(_PlayerID, _Portrait);
        return;
    end
    ModuleGUI.Local:SetPlayerPortraitByModelName(_PlayerID, _Portrait);
end

---
-- Fügt eine Beschreibung zu einem benutzerdefinierten Hotkey hinzu.
--
-- Ist der Hotkey bereits vorhanden, wird -1 zurückgegeben.
--
-- <b>Hinweis</b>: Diese Funktionalität selbst muss mit Input.KeyBindDown oder
-- Input.KeyBindUp separat implementiert werden!
--
-- @param[type=string] _Key         Tastenkombination
-- @param[type=string] _Description Beschreibung des Hotkey
-- @return[type=number] Index oder Fehlercode
-- @within Anwenderfunktionen
-- @local
--
function API.AddShortcutEntry(_Key, _Description)
    if not GUI then
        return;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for i= 1, #ModuleGUI.Local.HotkeyDescriptions do
        if ModuleGUI.Local.HotkeyDescriptions[i][1] == _Key then
            return -1;
        end
    end
    local ID = #ModuleGUI.Local.HotkeyDescriptions+1;
    table.insert(ModuleGUI.Local.HotkeyDescriptions, {ID = ID, _Key, _Description});
    return #ModuleGUI.Local.HotkeyDescriptions;
end

---
-- Entfernt eine Beschreibung eines benutzerdefinierten Hotkeys.
--
-- @param[type=number] _ID Index in Table
-- @within Anwenderfunktionen
-- @local
--
function API.RemoveShortcutEntry(_ID)
    if not GUI then
        return;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for k, v in pairs(ModuleGUI.Local.HotkeyDescriptions) do
        if v.ID == _ID then
            ModuleGUI.Local.HotkeyDescriptions[k] = nil;
        end
    end
end

---
-- Graut die Minimap aus oder macht sie wieder verwendbar.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideMinimap(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideMinimap(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapOverlay",_Flag);
    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapTerrain",_Flag);
end

---
-- Versteckt den Umschaltknopf der Minimap oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideToggleMinimap(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideToggleMinimap(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/MinimapButton",_Flag);
end

---
-- Versteckt den Button des Diplomatiemenü oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideDiplomacyMenu(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideDiplomacyMenu(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/DiplomacyMenuButton",_Flag);
end

---
-- Versteckt den Button des Produktionsmenü oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideProductionMenu(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideProductionMenu(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/ProductionMenuButton",_Flag);
end

---
-- Versteckt den Button des Wettermenüs oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideWeatherMenu(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideWeatherMenu(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/WeatherMenuButton",_Flag);
end

---
-- Versteckt den Button zum Territorienkauf oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideBuyTerritory(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideBuyTerritory(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",_Flag);
end

---
-- Versteckt den Button der Heldenfähigkeit oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideKnightAbility(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideKnightAbility(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbilityProgress",_Flag);
    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",_Flag);
end

---
-- Versteckt den Button zur Heldenselektion oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideKnightButton(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideKnightButton(" ..tostring(_Flag).. ")");
        Logic.SetEntitySelectableFlag("..KnightID..", (_Flag and 0) or 1);
        return;
    end

    local KnightID = Logic.GetKnightID(GUI.GetPlayerID());
    if _Flag then
        GUI.DeselectEntity(KnightID);
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButtonProgress",_Flag);
    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButton",_Flag);
end

---
-- Versteckt den Button zur Selektion des Militärs oder blendet ihn ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideSelectionButton(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideSelectionButton(" ..tostring(_Flag).. ")");
        return;
    end
    API.HideKnightButton(_Flag);
    GUI.ClearSelection();

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/BattalionButton",_Flag);
end

---
-- Versteckt das Baumenü oder blendet es ein.
--
-- <p><b>Hinweis:</b> Diese Änderung bleibt auch nach dem Laden eines Spielstandes
-- aktiv und muss explizit zurückgenommen werden!</p>
--
-- @param[type=boolean] _Flag Widget versteckt
-- @within Anwenderfunktionen
--
function API.HideBuildMenu(_Flag)
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.HideBuildMenu(" ..tostring(_Flag).. ")");
        return;
    end

    ModuleGUI.Local:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/BuildMenu", _Flag);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleRequester = {
    Properties = {
        Name = "ModuleRequester",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {},
    Local  = {
        Chat = {
            Data = {},
            History = {},
            Visible = {},
            Widgets = {}
        },
        Requester = {
            ActionFunction = nil,
            ActionRequester = nil,
            Next = nil,
            Queue = {},
        },
    },

    Shared = {
        Text = {
            ChooseLanguage = {
                Title = {
                    de = "Wählt die Sprache",
                    en = "Chose your Tongue",
                    fr = "Sélectionnez la langue",
                },
                Text = {
                    de = "Wählt aus der Liste die Sprache aus, in die Handlungstexte übersetzt werden sollen.",
                    en = "Choose from the list below which language story texts shall be presented to you.",
                    fr = "Sélectionne dans la liste la langue dans laquelle les textes narratifs doivent être traduits.",
                }
            }
        };
    },
}

-- -------------------------------------------------------------------------- --
-- Global

function ModuleRequester.Global:OnGameStart()
end

function ModuleRequester.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

function ModuleRequester.Local:OnGameStart()
    for i= 1, 8 do
        self.Chat.Data[i] = {};
        self.Chat.History[i] = {};
        self.Chat.Visible[i] = false;
        self.Chat.Widgets[i] = {};
    end

    self:OverrideChatLog();
    self:DialogOverwriteOriginal();
    self:DialogAltF4Hotkey();
end

function ModuleRequester.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.SaveGameLoaded then
        self:DialogAltF4Hotkey();
    end
end

-- -------------------------------------------------------------------------- --
-- Requester

function ModuleRequester.Local:DialogAltF4Hotkey()
    StartSimpleJobEx(function ()
        if ModuleRequester.Local.LoadscreenClosed then
            Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "ModuleRequester.Local:DialogAltF4Action()", 2, false);
            return true;
        end
    end);
end

function ModuleRequester.Local:DialogAltF4Action()
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "", 30, false);
    self:OpenRequesterDialog(
        GUI.GetPlayerID(),
        XGUIEng.GetStringTableText("UI_Texts/MainMenuExitGame_center"),
        XGUIEng.GetStringTableText("UI_Texts/ConfirmQuitCurrentGame"),
        function (_Yes)
            if _Yes then
                Framework.ExitGame();
            end
            if not Framework.IsNetworkGame() then
                Game.GameTimeSetFactor(GUI.GetPlayerID(), 1);
            end
            ModuleRequester.Local:DialogAltF4Hotkey();
        end
    );
end

function ModuleRequester.Local:Callback(_PlayerID)
    if self.Requester.ActionFunction then
        self.Requester.ActionFunction(CustomGame.Knight + 1, _PlayerID);
    end
    self:OnDialogClosed();
end

function ModuleRequester.Local:CallbackRequester(_yes, _PlayerID)
    if self.Requester.ActionRequester then
        self.Requester.ActionRequester(_yes, _PlayerID);
    end
    self:OnDialogClosed();
end

function ModuleRequester.Local:OnDialogClosed()
    if not self.SavingWasDisabled then
        API.DisableSaving(false);
    end
    self.SavingWasDisabled = false;
    self.DialogWindowShown = false;
    self:DialogQueueStartNext();
end

function ModuleRequester.Local:DialogQueueStartNext()
    self.Requester.Next = table.remove(self.Requester.Queue, 1);

    API.StartHiResJob(function()
        local Entry = ModuleRequester.Local.Requester.Next;
        if Entry and Entry[1] and Entry[2] then
            local Methode = Entry[1];
            ModuleRequester.Local[Methode](ModuleRequester.Local, unpack(Entry[2]));
            ModuleRequester.Local.Requester.Next = nil;
        end
        return true;
    end);
end

function ModuleRequester.Local:DialogQueuePush(_Methode, _Args)
    local Entry = {_Methode, _Args};
    table.insert(self.Requester.Queue, Entry);
end

function ModuleRequester.Local:OpenDialog(_PlayerID, _Title, _Text, _Action)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        assert(type(_Title) == "string");
        assert(type(_Text) == "string");

        _Title = "{center}" .. Revision.Text:ConvertPlaceholders(_Title);
        _Text  = Revision.Text:ConvertPlaceholders(_Text);
        if string.len(_Text) < 35 then
            _Text = _Text .. "{cr}";
        end

        g_MapAndHeroPreview.SelectKnight = function(_Knight)
        end

        XGUIEng.ShowAllSubWidgets("/InGame/Dialog/BG",1);
        XGUIEng.ShowWidget("/InGame/Dialog/Backdrop",0);
        XGUIEng.ShowWidget(RequesterDialog,1);
        XGUIEng.ShowWidget(RequesterDialog_Yes,0);
        XGUIEng.ShowWidget(RequesterDialog_No,0);
        XGUIEng.ShowWidget(RequesterDialog_Ok,1);

        if type(_Action) == "function" then
            self.Requester.ActionFunction = _Action;
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
            Action = Action .. "; XGUIEng.PopPage()";
            Action = Action .. "; ModuleRequester.Local.Callback(ModuleRequester.Local, GUI.GetPlayerID())";
            XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);
        else
            self.Requester.ActionFunction = nil;
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
            Action = Action .. "; XGUIEng.PopPage()";
            Action = Action .. "; ModuleRequester.Local.Callback(ModuleRequester.Local, GUI.GetPlayerID())";
            XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);
        end

        XGUIEng.SetText(RequesterDialog_Message, "{center}" .. _Text);
        XGUIEng.SetText(RequesterDialog_Title, _Title);
        XGUIEng.SetText(RequesterDialog_Title.."White", _Title);
        XGUIEng.PushPage(RequesterDialog,false);

        if Revision.Save.SavingDisabled then
            self.SavingWasDisabled = true;
        end
        API.DisableSaving(true);
        self.DialogWindowShown = true;
    else
        self:DialogQueuePush("OpenDialog", {_PlayerID, _Title, _Text, _Action});
    end
end

function ModuleRequester.Local:OpenRequesterDialog(_PlayerID, _Title, _Text, _Action, _OkCancel)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        assert(type(_Title) == "string");
        assert(type(_Text) == "string");
        _Title = "{center}" .. _Title;

        self:OpenDialog(_PlayerID, _Title, _Text, _Action);
        XGUIEng.ShowWidget(RequesterDialog_Yes,1);
        XGUIEng.ShowWidget(RequesterDialog_No,1);
        XGUIEng.ShowWidget(RequesterDialog_Ok,0);

        if _OkCancel then
            XGUIEng.SetText(RequesterDialog_Yes, XGUIEng.GetStringTableText("UI_Texts/Ok_center"));
            XGUIEng.SetText(RequesterDialog_No, XGUIEng.GetStringTableText("UI_Texts/Cancel_center"));
        else
            XGUIEng.SetText(RequesterDialog_Yes, XGUIEng.GetStringTableText("UI_Texts/Yes_center"));
            XGUIEng.SetText(RequesterDialog_No, XGUIEng.GetStringTableText("UI_Texts/No_center"));
        end

        self.Requester.ActionRequester = nil;
        if _Action then
            assert(type(_Action) == "function");
            self.Requester.ActionRequester = _Action;
        end
        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; ModuleRequester.Local.CallbackRequester(ModuleRequester.Local, true, GUI.GetPlayerID())"
        XGUIEng.SetActionFunction(RequesterDialog_Yes, Action);
        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)"
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; ModuleRequester.Local.CallbackRequester(ModuleRequester.Local, false, GUI.GetPlayerID())"
        XGUIEng.SetActionFunction(RequesterDialog_No, Action);
    else
        self:DialogQueuePush("OpenRequesterDialog", {_PlayerID, _Title, _Text, _Action, _OkCancel});
    end
end

function ModuleRequester.Local:OpenSelectionDialog(_PlayerID, _Title, _Text, _Action, _List)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        self:OpenDialog(_PlayerID, _Title, _Text, _Action);

        local HeroComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.KnightsList);
        XGUIEng.ListBoxPopAll(HeroComboBoxID);
        for i=1,#_List do
            XGUIEng.ListBoxPushItem(HeroComboBoxID, _List[i] );
        end
        XGUIEng.ListBoxSetSelectedIndex(HeroComboBoxID, 0);
        CustomGame.Knight = 0;

        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)"
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; ModuleRequester.Local.Callback(ModuleRequester.Local, GUI.GetPlayerID())";
        XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);

        local Container = "/InGame/Singleplayer/CustomGame/ContainerSelection/";
        XGUIEng.SetText(Container .. "HeroComboBoxMain/HeroComboBox", "");
        if _List[1] then
            XGUIEng.SetText(Container .. "HeroComboBoxMain/HeroComboBox", _List[1]);
        end
        XGUIEng.PushPage(Container .. "HeroComboBoxContainer", false);
        XGUIEng.PushPage(Container .. "HeroComboBoxMain",false);
        XGUIEng.ShowWidget(Container .. "HeroComboBoxContainer", 0);
        local screen = {GUI.GetScreenSize()};
        local x1, y1 = XGUIEng.GetWidgetScreenPosition(RequesterDialog_Ok);
        XGUIEng.SetWidgetScreenPosition(Container .. "HeroComboBoxMain", x1-25, y1-(90*(screen[2]/1080)));
        XGUIEng.SetWidgetScreenPosition(Container .. "HeroComboBoxContainer", x1-25, y1-(20*(screen[2]/1080)));
    else
        self:DialogQueuePush("OpenSelectionDialog", {_PlayerID, _Title, _Text, _Action, _List});
    end
end

function ModuleRequester.Local:DialogOverwriteOriginal()
    OpenDialog_Orig_Windows = OpenDialog;
    OpenDialog = function(_Message, _Title, _IsMPError)
        if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            OpenDialog_Orig_Windows(_Title, _Message);
        end
    end

    OpenRequesterDialog_Orig_Windows = OpenRequesterDialog;
    OpenRequesterDialog = function(_Message, _Title, action, _OkCancel, no_action)
        if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            XGUIEng.SetActionFunction(RequesterDialog_Yes, Action);
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            XGUIEng.SetActionFunction(RequesterDialog_No, Action);
            OpenRequesterDialog_Orig_Windows(_Message, _Title, action, _OkCancel, no_action);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Chat Log

function ModuleRequester.Local:ShowTextWindow(_Data)
    _Data.PlayerID = _Data.PlayerID or 1;
    _Data.Button = _Data.Button or {};
    local PlayerID = GUI.GetPlayerID();
    if _Data.PlayerID ~= PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/ChatOptions") == 1 then
        self:UpdateChatLogText(_Data);
        return;
    end
    self.Chat.Data[PlayerID] = _Data;
    self:CloseTextWindow(PlayerID);
    self:AlterChatLog();

    XGUIEng.SetText("/InGame/Root/Normal/ChatOptions/ChatLog", _Data.Content);
    XGUIEng.SetText("/InGame/Root/Normal/MessageLog/Name","{center}" .._Data.Caption);
    if _Data.DisableClose then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions/Exit",0);
    end
    self:ShouldShowSlider(_Data.Content);
    XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions",1);
end

function ModuleRequester.Local:CloseTextWindow(_PlayerID)
    assert(_PlayerID ~= nil);
    local PlayerID = GUI.GetPlayerID();
    if _PlayerID ~= PlayerID then
        return;
    end
    GUI_Chat.CloseChatMenu();
end

function ModuleRequester.Local:UpdateChatLogText(_Data)
    XGUIEng.SetText("/InGame/Root/Normal/ChatOptions/ChatLog", _Data.Content);
end

function ModuleRequester.Local:AlterChatLog()
    local PlayerID = GUI.GetPlayerID();
    if self.Chat.Visible[PlayerID] then
        return;
    end
    self.Chat.Visible[PlayerID] = true;
    self.Chat.History[PlayerID] = table.copy(g_Chat.ChatHistory);
    g_Chat.ChatHistory = {};
    self:AlterChatLogDisplay();
end

function ModuleRequester.Local:RestoreChatLog()
    local PlayerID = GUI.GetPlayerID();
    if not self.Chat.Visible[PlayerID] then
        return;
    end
    self.Chat.Visible[PlayerID] = false;
    g_Chat.ChatHistory = {};
    for i= 1, #self.Chat.History[PlayerID] do
        GUI_Chat.ChatlogAddMessage(self.Chat.History[PlayerID][i]);
    end
    self:RestoreChatLogDisplay();
    self.Chat.History[PlayerID] = {};
    self.Chat.Widgets[PlayerID] = {};
    self.Chat.Data[PlayerID] = {};
end

function ModuleRequester.Local:UpdateToggleWhisperTarget()
    local PlayerID = GUI.GetPlayerID();
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    if not self.Chat.Data[PlayerID] or not self.Chat.Data[PlayerID].Button
    or not self.Chat.Data[PlayerID].Button.Action then
        XGUIEng.ShowWidget(MotherWidget.. "ToggleWhisperTarget",0);
        return;
    end
    local ButtonText = self.Chat.Data[PlayerID].Button.Text;
    XGUIEng.SetText(MotherWidget.. "ToggleWhisperTarget","{center}" ..ButtonText);
end

function ModuleRequester.Local:ShouldShowSlider(_Text)
    local stringlen = string.len(_Text);
    local iterator  = 1;
    local carreturn = 0;
    while (true)
    do
        local s,e = string.find(_Text, "{cr}", iterator);
        if not e then
            break;
        end
        if e-iterator <= 58 then
            stringlen = stringlen + 58-(e-iterator);
        end
        iterator = e+1;
    end
    if (stringlen + (carreturn*55)) > 1000 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions/ChatLogSlider",1);
    end
end

function ModuleRequester.Local:OverrideChatLog()
    GUI_Chat.ChatlogAddMessage_Orig_Requester = GUI_Chat.ChatlogAddMessage;
    GUI_Chat.ChatlogAddMessage = function(_Message)
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ChatlogAddMessage_Orig_Requester(_Message);
            return;
        end
        table.insert(ModuleRequester.Local.Chat.History[PlayerID], _Message);
    end

    GUI_Chat.DisplayChatLog_Orig_Requester = GUI_Chat.DisplayChatLog;
    GUI_Chat.DisplayChatLog = function()
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.DisplayChatLog_Orig_Requester();
        end
    end

    GUI_Chat.CloseChatMenu_Orig_Requester = GUI_Chat.CloseChatMenu;
    GUI_Chat.CloseChatMenu = function()
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.CloseChatMenu_Orig_Requester();
            return;
        end
        ModuleRequester.Local:RestoreChatLog();
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions",0);
    end

    GUI_Chat.ToggleWhisperTargetUpdate_Orig_Requester = GUI_Chat.ToggleWhisperTargetUpdate;
    GUI_Chat.ToggleWhisperTargetUpdate = function()
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ToggleWhisperTargetUpdate_Orig_Requester();
            return;
        end
        ModuleRequester.Local:UpdateToggleWhisperTarget();
    end

    GUI_Chat.CheckboxMessageTypeWhisperUpdate_Orig_Requester = GUI_Chat.CheckboxMessageTypeWhisperUpdate;
    GUI_Chat.CheckboxMessageTypeWhisperUpdate = function()
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.CheckboxMessageTypeWhisperUpdate_Orig_Requester();
            return;
        end
    end

    GUI_Chat.ToggleWhisperTarget_Orig_Requester = GUI_Chat.ToggleWhisperTarget;
    GUI_Chat.ToggleWhisperTarget = function()
        local PlayerID = GUI.GetPlayerID();
        if not ModuleRequester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ToggleWhisperTarget_Orig_Requester();
            return;
        end
        if ModuleRequester.Local.Chat.Data[PlayerID].Button.Action then
            local Data = ModuleRequester.Local.Chat.Data[PlayerID];
            ModuleRequester.Local.Chat.Data[PlayerID].Button.Action(Data);
        end
    end
end

function ModuleRequester.Local:AlterChatLogDisplay()
    local PlayerID = GUI.GetPlayerID();

    local w,h,x,y;
    local Widget;
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ToggleWhisperTarget");
    self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"];

    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ChatLog");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ChatLog");
    self.Chat.Widgets[PlayerID]["ChatLog"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ChatLog"];

    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ChatLogSlider");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ChatLogSlider");
    self.Chat.Widgets[PlayerID]["ChatLogSlider"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ChatLogSlider"];

    XGUIEng.ShowWidget(MotherWidget.. "ChatModeAllPlayers",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeTeam",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeWhisper",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatChooseModeCaption",0);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig/Info",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogCaption",0);
    XGUIEng.ShowWidget(MotherWidget.. "BGChoose",0);
    XGUIEng.ShowWidget(MotherWidget.. "BGChatLog",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogSlider",0);

    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog",1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/BG",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Close",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Slider",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Text",0);
    XGUIEng.SetText("/InGame/Root/Normal/MessageLog/Name","{center}Test");
    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/MessageLog",15,90);
    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/MessageLog/Name",0,0);
    XGUIEng.SetTextColor("/InGame/Root/Normal/MessageLog/Name",51,51,121,255);

    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLogSlider",46,600);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLogSlider",780,130);
    XGUIEng.SetWidgetSize(MotherWidget.. "Background/DialogBG/1 (2)/2",150,400);
    XGUIEng.SetWidgetPositionAndSize(MotherWidget.. "Background/DialogBG/1 (2)/3",400,500,350,400);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget",280,760);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLog",140,150);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLog",640,560);
end

function ModuleRequester.Local:RestoreChatLogDisplay()
    local PlayerID = GUI.GetPlayerID();

    local Widget;
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    Widget = self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ToggleWhisperTarget", Widget.W, Widget.H);
    Widget = self.Chat.Widgets[PlayerID]["ChatLog"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLog", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLog", Widget.W, Widget.H);
    Widget = self.Chat.Widgets[PlayerID]["ChatLogSlider"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLogSlider", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLogSlider", Widget.W, Widget.H);

    XGUIEng.ShowWidget(MotherWidget.. "ChatModeAllPlayers",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeTeam",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeWhisper",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatChooseModeCaption",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig/Info",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogCaption",1);
    XGUIEng.ShowWidget(MotherWidget.. "BGChoose",1);
    XGUIEng.ShowWidget(MotherWidget.. "BGChatLog",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogSlider",1);
    XGUIEng.ShowWidget(MotherWidget.. "ToggleWhisperTarget",1);

    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog",0);
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleRequester);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Stellt verschiedene Dialogfenster zur Verfügung.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Öffnet ein einfaches Textfenster mit dem angegebenen Text.
--
-- Die Länge des Textes ist nicht beschränkt. Überschreitet der Text die
-- Größe des Fensters, wird automatisch eine Bildlaufleiste eingeblendet.
--
-- <h5>Multiplayer</h5>
-- Im Multiplayer muss zwingend der Spieler angegeben werden, für den das
-- Fenster angezeigt werden soll.
--
-- @param[type=string] _Caption  Titel des Fenster
-- @param[type=string] _Content  Inhalt des Fenster
-- @param[type=number] _PlayerID Spieler, der das Fenster sieht
-- @within Anwenderfunktionen
--
-- @usage
-- local Text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr,"..
--              " sed diam nonumy eirmod tempor invidunt ut labore et dolore"..
--              " magna aliquyam erat, sed diam voluptua. At vero eos et"..
--              " accusam et justo duo dolores et ea rebum. Stet clita kasd"..
--              " gubergren, no sea takimata sanctus est Lorem ipsum dolor"..
--              " sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing"..
--              " elitr, sed diam nonumy eirmod tempor invidunt ut labore et"..
--              " dolore magna aliquyam erat, sed diam voluptua. At vero eos"..
--              " et accusam et justo duo dolores et ea rebum. Stet clita"..
--              " kasd gubergren, no sea takimata sanctus est Lorem ipsum"..
--              " dolor sit amet.";
-- API.TextWindow("Überschrift", Text);
--
function API.TextWindow(_Caption, _Content, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _Caption = API.Localize(_Caption);
    _Content = API.Localize(_Content);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.TextWindow("%s", "%s", %d)]],
            _Caption,
            _Content,
            _PlayerID
        ));
        return;
    end
    ModuleRequester.Local:ShowTextWindow {
        PlayerID = _PlayerID,
        Caption  = _Caption,
        Content  = _Content,
    };
end

---
-- Öffnet einen Info-Dialog. Sollte bereits ein Dialog zu sehen sein, wird
-- der Dialog der Dialogwarteschlange hinzugefügt.
--
-- An die Action wird der Spieler übergeben, der den Dialog bestätigt hat.
--
-- <b>Hinweis</b>: Kann nicht aus dem globalen Skript heraus benutzt werden.
--
-- @param[type=string]   _PlayerID (Optional) Empfangender Spieler
-- @param[type=string]   _Title    Titel des Dialog
-- @param[type=string]   _Text     Text des Dialog
-- @param                _Action   Funktionsreferenz
-- @within Anwenderfunktionen
--
-- @usage
-- API.DialogInfoBox("Wichtige Information", "Diese Information ist Spielentscheidend!");
--
function API.DialogInfoBox(_PlayerID, _Title, _Text, _Action)
    if not GUI then
        return;
    end
    if type(_PlayerID) ~= "number" then
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = API.Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = API.Localize(_Text);
    end
    return ModuleRequester.Local:OpenDialog(_PlayerID, _Title, _Text, _Action);
end

---
-- Öffnet einen Ja-Nein-Dialog. Sollte bereits ein Dialog zu sehen sein, wird
-- der Dialog der Dialogwarteschlange hinzugefügt.
--
-- Um die Entscheigung des Spielers abzufragen, wird ein Callback benötigt.
-- Das Callback bekommt eine Boolean übergeben, sobald der Spieler die
-- Entscheidung getroffen hat, plus die ID des Spielers.
--
-- <b>Hinweis</b>: Kann nicht aus dem globalen Skript heraus benutzt werden.
--
-- @param[type=string]   _PlayerID (Optional) Empfangender Spieler
-- @param[type=string]   _Title    Titel des Dialog
-- @param[type=string]   _Text     Text des Dialog
-- @param                _Action   Funktionsreferenz
-- @param[type=boolean]  _OkCancel Okay/Abbrechen statt Ja/Nein
-- @within Anwenderfunktionen
--
-- @usage
-- function YesNoAction(_Yes, _PlayerID)
--     if _Yes then GUI.AddNote("Ja wurde gedrückt"); end
-- end
-- API.DialogRequestBox("Frage", "Möchtest du das wirklich tun?", YesNoAction, false);
--
function API.DialogRequestBox(_PlayerID, _Title, _Text, _Action, _OkCancel)
    if not GUI then
        return;
    end
    if type(_PlayerID) ~= "number" then
        _OkCancel = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = API.Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = API.Localize(_Text);
    end
    return ModuleRequester.Local:OpenRequesterDialog(_PlayerID, _Title, _Text, _Action, _OkCancel);
end

---
-- Öffnet einen Auswahldialog. Sollte bereits ein Dialog zu sehen sein, wird
-- der Dialog der Dialogwarteschlange hinzugefügt.
--
-- In diesem Dialog wählt der Spieler eine Option aus einer Liste von Optionen
-- aus. Anschließend erhält das Callback den Index der selektierten Option und
-- die ID des Spielers, der den Dialog bestätigt hat.
--
-- <b>Hinweis</b>: Kann nicht aus dem globalen Skript heraus benutzt werden.
--
-- @param[type=string]   _PlayerID (Optional) Empfangender Spieler
-- @param[type=string]   _Title  Titel des Dialog
-- @param[type=string]   _Text   Text des Dialog
-- @param                _Action Funktionsreferenz
-- @param[type=table]    _List   Liste der Optionen
-- @within Anwenderfunktionen
--
-- @usage
-- function OptionsAction(_Idx, _PlayerID)
--     GUI.AddNote(_Idx.. " wurde ausgewählt!");
-- end
-- local List = {"Option A", "Option B", "Option C"};
-- API.DialogSelectBox("Auswahl", "Wähle etwas aus!", OptionsAction, List);
--
function API.DialogSelectBox(_PlayerID, _Title, _Text, _Action, _List)
    if not GUI then
        return;
    end
    if type(_PlayerID) ~= "number" then
        _List = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = API.Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = API.Localize(_Text);
    end
    _Text = _Text .. "{cr}";
    ModuleRequester.Local:OpenSelectionDialog(_PlayerID, _Title, _Text, _Action, _List);
end

---
-- Öffnet den Dialog für die Auswahl der Sprache. Deutsch, Englisch und
-- Französisch sind vorkonfiguriert.
--
-- @param[type=number] _PlayerID (optional) Nur für diesen Spieler anzeigen
-- @within Anwenderfunktionen
--
-- @usage
-- -- Für alle Spieler
-- API.DialogLanguageSelection();
-- -- Nur für Spieler 2 anzeigen
-- API.DialogLanguageSelection(2);
--
function API.DialogLanguageSelection(_PlayerID)
    _PlayerID = _PlayerID or -1
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.DialogLanguageSelection(%d)]],
            _PlayerID
        ));
        return;
    end
    if _PlayerID ~= -1 and GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    local DisplayedList = {};
    for i= 1, #Revision.Text.Languages do
        table.insert(DisplayedList, Revision.Text.Languages[i][2]);
    end
    local Action = function(_Selected)
        API.BroadcastScriptCommand(
            QSB.ScriptCommands.SetLanguageResult,
            GUI.GetPlayerID(),
            Revision.Text.Languages[_Selected][1]
        );
    end
    local Text = API.Localize(ModuleRequester.Shared.Text.ChooseLanguage);
    API.DialogSelectBox(GUI.GetPlayerID(), Text.Title, Text.Text, Action, DisplayedList);
end

---
-- Fügt eine neue Sprache zur Auswahl hinzu.
--
-- @param[type=string] _Shortcut Kürzel der Sprache (vgl. de, en, ...)
-- @param[type=string] _Name     Anzeigename der Sprache
-- @param[type=string] _Fallback Kürzel der Ausweichsprache
-- @within Anwenderfunktionen
--
-- @usage
-- API.DefineLanguage("sx", "Sächsich", "de")
--
function API.DefineLanguage(_Shortcut, _Name, _Fallback)
    assert(type(_Shortcut) == "string");
    assert(type(_Name) == "string");
    assert(type(_Fallback) == "string");
    for k, v in pairs(Revision.Text.Languages) do
        if v[1] == _Shortcut then
            return;
        end
    end
    table.insert(Revision.Text.Languages, {_Shortcut, _Name, _Fallback});
    Logic.ExecuteInLuaLocalState(string.format([[
        table.insert(Revision.Text.Languages, {"%s", "%s", "%s"})
    ]], _Shortcut, _Name, _Fallback));
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleSound = {
    Properties = {
        Name = "ModuleSound",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {},
    Local = {
        SoundBackup = {},
    },
}

-- Global Script ---------------------------------------------------------------

function ModuleSound.Global:OnGameStart()
end

function ModuleSound.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- Local Script ----------------------------------------------------------------

function ModuleSound.Local:OnGameStart()
end

function ModuleSound.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleSound.Local:AdjustSound(_Global, _Music, _Voice, _Atmo, _UI)
    self:SaveSound();
    if _Global then
        Sound.SetGlobalVolume(_Global);
    end
    if _Music then
        Sound.SetMusicVolume(_Music);
    end
    if _Voice then
        Sound.SetSpeechVolume(_Voice);
    end
    if _Atmo then
        Sound.SetFXSoundpointVolume(_Atmo);
        Sound.SetFXAtmoVolume(_Atmo);
    end
    if _UI then
        Sound.Set2DFXVolume(_UI);
        Sound.SetFXVolume(_UI);
    end
end

function ModuleSound.Local:SaveSound()
    if not self.SoundBackup.Saved then
        self.SoundBackup.Saved = true;
        self.SoundBackup.FXSP = Sound.GetFXSoundpointVolume();
        self.SoundBackup.FXAtmo = Sound.GetFXAtmoVolume();
        self.SoundBackup.FXVol = Sound.GetFXVolume();
        self.SoundBackup.Sound = Sound.GetGlobalVolume();
        self.SoundBackup.Music = Sound.GetMusicVolume();
        self.SoundBackup.Voice = Sound.GetSpeechVolume();
        self.SoundBackup.UI = Sound.Get2DFXVolume();
    end
end

function ModuleSound.Local:RestoreSound()
    if self.SoundBackup.Saved then
        Sound.SetFXSoundpointVolume(self.SoundBackup.FXSP);
        Sound.SetFXAtmoVolume(self.SoundBackup.FXAtmo);
        Sound.SetFXVolume(self.SoundBackup.FXVol);
        Sound.SetGlobalVolume(self.SoundBackup.Sound);
        Sound.SetMusicVolume(self.SoundBackup.Music);
        Sound.SetSpeechVolume(self.SoundBackup.Voice);
        Sound.Set2DFXVolume(self.SoundBackup.UI);
        self.SoundBackup = {};
    end
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleSound);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

---
-- Steuerung der Lautstärke und der Sound-Ausgabe.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Modulbeschreibung
-- @set sort=true
--

---
-- Startet eine Playlist, welche als XML angegeben ist.
--
-- Eine als XML definierte Playlist wird nicht als Voice abgespielt sondern
-- als Music. Als Musik werden MP3-Dateien verwendet. Diese können entweder
-- im Spiel vorhanden sein oder im Ordner <i>music/</i> im Root-Verzeichnis
-- des Spiels gespeichert werden. Die Playlist gehört ebenfalls ins Root-
-- Verzeichnis nach <i>config/sound/</i>.
--
-- Verzeichnisstruktur für eigene Musik:
-- <pre>map_xyz.s6xmap.unpacked
--|-- music/*
--|-- config/sound/*
--|-- maps/externalmap/map_xyz/*
--|-- ...</pre>
--
-- In der QSB sind bereits die Variablen <i>gvMission.MusicRootPath</i> und
-- <i>gvMission.PlaylistRootPath</i> mit den entsprechenden Pfaden vordefiniert.
--
-- Wenn du eigene Musik verwendest, achte darauf, einen möglichst eindeutigen
-- Namen zu verwenden. Und natürlich auch auf Urheberrecht!
--
-- Beispiel für eine Playlist:
-- <pre>
--&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
--&lt;PlayList&gt;
-- &lt;PlayListEntry&gt;
--   &lt;FileName&gt;Music\some_music_file.mp3&lt;/FileName&gt;
--   &lt;Type&gt;Loop&lt;/Type&gt;
-- &lt;/PlayListEntry&gt;
-- &lt;!-- Hier können weitere Einträge folgen. --&gt;
--&lt;/PlayList&gt;
--</pre>
-- Als Typ können "Loop" oder "Normal" gewählt werden. Normale Musik wird
-- einmalig abgespielt. Ein Loop läuft endlos weiter.
--
-- Außerdem kann zusätzlich zum Typ eine Abspielwahrscheinlichkeit mit
-- angegeben werden:
-- <pre>&lt;Chance&gt;10&lt;/Chance&gt;</pre>
-- Es sind Zahlen von 1 bis 100 möglich.
--
-- @param _Playlist Pfad zur Playlist
-- @param _PlayerID (Optional) ID des menschlichen Spielers
-- @within Anwenderfunktionen
--
-- @usage
-- API.StartEventPlaylist(gvMission.PlaylistRootPath .."my_playlist.xml");
--
function API.StartEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.StartEventPlaylist('%s', %d)", _Playlist, _PlayerID));
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStartEventPlaylist(_Playlist)
    end
end

---
-- Beendet eine Event Playlist.
--
-- @param _Playlist Pfad zur Playlist
-- @param _PlayerID (Optional) ID des menschlichen Spielers
-- @within Anwenderfunktionen
--
-- @usage
-- API.StopEventPlaylist("config/sound/my_playlist.xml");
--
function API.StopEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.StopEventPlaylist('%s', %d)", _Playlist, _PlayerID));
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStopEventPlaylist(_Playlist)
    end
end

---
-- Spielt einen 2D-Sound aus dem Spiel ab.
--
-- Ein 2D-Sound ist nicht positionsgebunden und ist immer zu hören, egal an
-- welcher Stelle auf der Map sich die Kamera befindet.
--
-- Wenn eigene Sounds verwendet werden sollen, müssen sie im WAV-Format
-- vorliegen und in die zwei Verzeichnisse für niedrige und hohe Qualität
-- kopiert werden.
--
-- Verzeichnisstruktur für eigene Sounds:
-- <pre>map_xyz.s6xmap.unpacked
--|-- sounds/high/ui/*
--|-- sounds/low/ui/*
--|-- maps/externalmap/map_xyz/*
--|-- ...</pre>
--
-- @param _Sound    Pfad des Sound
-- @param _PlayerID (Optional) ID des menschlichen Spielers
-- @within Anwenderfunktionen
--
-- @usage
-- API.Play2DSound("ui/menu_left_gold_pay");
--
function API.Play2DSound(_Sound, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.Play2DSound("%s", %d)]],
            _Sound,
            _PlayerID
        ));
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay2DSound(_Sound:gsub("/", "\\"));
    end
end
API.PlaySound = API.Play2DSound;

---
-- Spielt einen 3D-Sound aus dem Spiel ab.
--
-- Ein 3D-Sound wird an einer bestimmten Position abgespielt und ist nur in
-- einem begrenzten Bereich um die Position höhrbar.
--
-- Wenn eigene Sounds verwendet werden sollen, müssen sie im WAV-Format
-- vorliegen und in die zwei Verzeichnisse für niedrige und hohe Qualität
-- kopiert werden.
--
-- Verzeichnisstruktur für eigene Sounds:
-- <pre>map_xyz.s6xmap.unpacked
--|-- sounds/high/ui/*
--|-- sounds/low/ui/*
--|-- maps/externalmap/map_xyz/*
--|-- ...</pre>
--
-- @param _Sound    Pfad des Sound
-- @param _X        X-Position des Sound
-- @param _Y        Y-Position des Sound
-- @param _Z        Z-Position des Sound
-- @param _PlayerID (Optional) ID des menschlichen Spielers
-- @within Anwenderfunktionen
--
-- @usage
-- API.Play3DSound("Animals/cow_disease", 8500, 35800, 2000);
--
function API.Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _X = _X or 1;
    _Y = _Y or 1
    _Z = _Z or 0
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.Play3DSound("%s", %f, %f, %d)]],
            _Sound,
            _X,
            _Y,
            _PlayerID
        ));
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay3DSound(_Sound:gsub("/", "\\"), _X, _Y, _Z);
    end
end

---
-- Setzt die allgemeine Lautstärke. Die allgemeine Lautstärke beeinflusst alle
-- anderen Laufstärkeregler.
--
-- <b>Hinweis:</b> Es wird automatisch ein Backup der Einstellungen angelegt
-- wenn noch keins angelegt wurde.
--
-- @param _Volume Lautstärke
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundSetVolume(100);
--
function API.SoundSetVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.SoundSetVolume(%d)", _Volume));
        return;
    end
    ModuleSound.Local:AdjustSound(_Volume, nil, nil, nil, nil);
end

---
-- Setzt die Lautstärke der Musik.
--
-- <b>Hinweis:</b> Es wird automatisch ein Backup der Einstellungen angelegt
-- wenn noch keins angelegt wurde.
--
-- @param _Volume Lautstärke
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundSetMusicVolume(100);
--
function API.SoundSetMusicVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.SoundSetMusicVolume(%d)", _Volume));
        return;
    end
    ModuleSound.Local:AdjustSound(nil, _Volume, nil, nil, nil);
end

---
-- Setzt die Lautstärke der Stimmen.
--
-- <b>Hinweis:</b> Es wird automatisch ein Backup der Einstellungen angelegt
-- wenn noch keins angelegt wurde.
--
-- @param _Volume Lautstärke
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundSetVoiceVolume(100);
--
function API.SoundSetVoiceVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.SoundSetVoiceVolume(%d)", _Volume));
        return;
    end
    ModuleSound.Local:AdjustSound(nil, nil, _Volume, nil, nil);
end

---
-- Setzt die Lautstärke der Umgebung.
--
-- <b>Hinweis:</b> Es wird automatisch ein Backup der Einstellungen angelegt
-- wenn noch keins angelegt wurde.
--
-- @param _Volume Lautstärke
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundSetAtmoVolume(100);
--
function API.SoundSetAtmoVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.SoundSetAtmoVolume(%d)", _Volume));
        return;
    end
    ModuleSound.Local:AdjustSound(nil, nil, nil, _Volume, nil);
end

---
-- Setzt die Lautstärke des Interface.
--
-- <b>Hinweis:</b> Es wird automatisch ein Backup der Einstellungen angelegt
-- wenn noch keins angelegt wurde.
--
-- @param _Volume Lautstärke
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundSetUIVolume(100);
--
function API.SoundSetUIVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.SoundSetUIVolume(%d)", _Volume));
        return;
    end
    ModuleSound.Local:AdjustSound(nil, nil, nil, nil, _Volume);
end

---
-- Erstellt ein Backup der Soundeinstellungen, wenn noch keins erstellt wurde.
--
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- API.SoundSave();
--
function API.SoundSave()
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.SoundSave()");
        return;
    end
    ModuleSound.Local:SaveSound();
end

---
-- Stellt den Sound wieder her, sofern ein Backup erstellt wurde.
--
-- @within Anwenderfunktionen
--
-- @usage
-- API.SoundRestore();
--
function API.SoundRestore()
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.SoundRestore()");
        return;
    end
    ModuleSound.Local:RestoreSound();
end

---
-- Gibt eine MP3-Datei als Stimme wieder. Diese Funktion kann auch benutzt
-- werden um Geräusche abzuspielen.
--
-- @param[type=string] _File Abzuspielende Datei
-- @within Anwenderfunktionen
--
-- @usage
-- API.PlayVoice("music/puhdys_alt_wie_ein_baum.mp3");
--
function API.PlayVoice(_File)
    if not GUI then
        Logic.ExecuteInLuaLocalState(string.format("API.PlayVoice('%s')", _File));
        return;
    end
    API.StopVoice();
    Sound.PlayVoice("ImportantStuff", _File);
end

---
-- Stoppt alle als Stimme abgespielten aktiven Sounds.
--
-- @within Anwenderfunktionen
--
-- @usage
-- API.StopVoice();
--
function API.StopVoice()
    if not GUI then
        Logic.ExecuteInLuaLocalState("API.StopVoice()");
        return;
    end
    Sound.StopVoice("ImportantStuff");
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleTrade = {
    Properties = {
        Name = "ModuleTrade",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {
        Analysis = {
            PlayerOffersAmount = {
                [1] = {}, [2] = {}, [3] = {}, [4] = {},
                [5] = {}, [6] = {}, [7] = {}, [8] = {},
            };
        },
        Lambda = {},
        Event = {},
    },
    Local = {
        Lambda = {
            PurchaseTraderAbility = {},
            PurchaseBasePrice     = {},
            PurchaseInflation     = {},
            PurchaseAllowed       = {},
            SaleTraderAbility     = {},
            SaleBasePrice         = {},
            SaleDeflation         = {},
            SaleAllowed           = {},
        },
        ShowKnightTraderAbility = true;
    },

    Shared = {},
};

QSB.TraderTypes = {
    GoodTrader        = 0,
    MercenaryTrader   = 1,
    EntertainerTrader = 2,
    Unknown           = 3,
};

-- Global ------------------------------------------------------------------- --

function ModuleTrade.Global:OnGameStart()
    QSB.ScriptEvents.GoodsSold = API.RegisterScriptEvent("Event_GoodsSold");
    QSB.ScriptEvents.GoodsPurchased = API.RegisterScriptEvent("Event_GoodsPurchased");
    self:OverwriteBasePricesAndRefreshRates();
end

function ModuleTrade.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.GoodsPurchased then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.GoodsPurchased, %d, %d, %d, %d, %d, %d, %d)]],
            arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]
        ))
        self:PerformFakeTrade(arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]);
    elseif _ID == QSB.ScriptEvents.GoodsSold then
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.GoodsSold, %d, %d, %d, %d, %d, %d)]],
            arg[1], arg[2], arg[3], arg[4], arg[5], arg[6]
        ))
    end
end

function ModuleTrade.Global:OverwriteBasePricesAndRefreshRates()
    MerchantSystem.BasePrices[Entities.U_CatapultCart] = MerchantSystem.BasePrices[Entities.U_CatapultCart] or 1000;
    MerchantSystem.BasePrices[Entities.U_BatteringRamCart] = MerchantSystem.BasePrices[Entities.U_BatteringRamCart] or 450;
    MerchantSystem.BasePrices[Entities.U_SiegeTowerCart] = MerchantSystem.BasePrices[Entities.U_SiegeTowerCart] or 600;
    MerchantSystem.BasePrices[Entities.U_AmmunitionCart] = MerchantSystem.BasePrices[Entities.U_AmmunitionCart] or 150;
    MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] = MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] or 200;
    MerchantSystem.BasePrices[Entities.U_MilitarySword] = MerchantSystem.BasePrices[Entities.U_MilitarySword] or 200;
    MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince] or 350;
    MerchantSystem.BasePrices[Entities.U_MilitaryBow] = MerchantSystem.BasePrices[Entities.U_MilitaryBow] or 350;

    MerchantSystem.RefreshRates[Entities.U_CatapultCart] = MerchantSystem.RefreshRates[Entities.U_CatapultCart] or 270;
    MerchantSystem.RefreshRates[Entities.U_BatteringRamCart] = MerchantSystem.RefreshRates[Entities.U_BatteringRamCart] or 190;
    MerchantSystem.RefreshRates[Entities.U_SiegeTowerCart] = MerchantSystem.RefreshRates[Entities.U_SiegeTowerCart] or 220;
    MerchantSystem.RefreshRates[Entities.U_AmmunitionCart] = MerchantSystem.RefreshRates[Entities.U_AmmunitionCart] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.RefreshRates[Entities.U_MilitarySword_RedPrince] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitarySword] = MerchantSystem.RefreshRates[Entities.U_MilitarySword] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow] or 150;

    if g_GameExtraNo >= 1 then
        MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana] = MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana] or 350;
        MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] = MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] or 200;

        MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] or 150;
        MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = MerchantSystem.RefreshRates[Entities.U_MilitarySword_Khana] or 150;
    end
end

function ModuleTrade.Global:PerformFakeTrade(_OfferID, _TraderType, _Good, _Amount, _Price, _P1, _P2)
    local StoreHouse1 = Logic.GetStoreHouse(_P1);
    local StoreHouse2 = Logic.GetStoreHouse(_P2);

    -- Perform transaction
    local Orientation = Logic.GetEntityOrientation(StoreHouse2) - 90;
    if _TraderType == 0 then
        if Logic.GetGoodCategoryForGoodType(_Good) ~= GoodCategories.GC_Animal then
            API.SendCart(StoreHouse2, _P1, _Good, _Amount, nil, false);
        else
            StartSimpleJobEx(function(_Time, _SHID, _Good, _PlayerID)
                if Logic.GetTime() > _Time+5 then
                    return true;
                end
                local x,y = Logic.GetBuildingApproachPosition(_SHID);
                local Type = (_Good ~= Goods.G_Cow and Entities.A_X_Sheep01) or Entities.A_X_Cow01;
                Logic.CreateEntityOnUnblockedLand(Type, x, y, 0, _PlayerID);
            end, Logic.GetTime(), StoreHouse2, _Good, _P1);
        end
    elseif _TraderType == 1 then
        local x,y = Logic.GetBuildingApproachPosition(StoreHouse2);
        local ID  = Logic.CreateBattalionOnUnblockedLand(_Good, x, y, Orientation, _P1);
        Logic.MoveSettler(ID, x, y, -1);
    else
        local x,y = Logic.GetBuildingApproachPosition(StoreHouse2);
        Logic.HireEntertainer(_Good, _P1, x, y);
    end
    API.SendCart(StoreHouse1, _P2, Goods.G_Gold, _Price, nil, false);
    AddGood(Goods.G_Gold, (-1) * _Price, _P1);

    -- Alter offer amount
    local NewAmount = 0;
    local OfferInfo = self:GetStorehouseInformation(_P2);
    for i= 1, #OfferInfo[1] do
        if OfferInfo[1][i][3] == _Good and OfferInfo[1][i][5] > 0 then
            NewAmount = OfferInfo[1][i][5] -1;
        end
    end
    self:ModifyTradeOffer(_P2, _Good, NewAmount);

    -- Update local
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_MerchantInteraction(%d, %d, %d)",
        StoreHouse2,
        _P1,
        _OfferID
    ))
end

function ModuleTrade.Global:GetStorehouseInformation(_PlayerID)
    local BuildingID = Logic.GetStoreHouse(_PlayerID);

    local StorehouseData = {
        Player      = _PlayerID,
        Storehouse  = BuildingID,
        OfferCount  = 0,
        {},
    };

    local NumberOfMerchants = Logic.GetNumberOfMerchants(Logic.GetStoreHouse(_PlayerID));
    local AmountOfOffers = 0;

    if BuildingID ~= 0 then
        for Index = 0, NumberOfMerchants, 1 do
            local Offers = {Logic.GetMerchantOfferIDs(BuildingID, Index, _PlayerID)};
            for i= 1, #Offers, 1 do
                local type, goodAmount, offerAmount, prices = 0, 0, 0, 0;
                if Logic.IsGoodTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetGoodTraderOffer(BuildingID, Offers[i], _PlayerID);
                    if type == Goods.G_Sheep or type == Goods.G_Cow then
                        goodAmount = 5;
                    end
                elseif Logic.IsMercenaryTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetMercenaryOffer(BuildingID, Offers[i], _PlayerID);
                elseif Logic.IsEntertainerTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetEntertainerTraderOffer(BuildingID, Offers[i], _PlayerID);
                end

                AmountOfOffers = AmountOfOffers +1;
                local OfferData = {Index, Offers[i], type, goodAmount, offerAmount, prices};
                table.insert(StorehouseData[1], OfferData);
            end
        end
    end

    StorehouseData.OfferCount = AmountOfOffers;
    return StorehouseData;
end

function ModuleTrade.Global:GetOfferCount(_PlayerID)
    local Offers = self:GetStorehouseInformation(_PlayerID);
    if Offers then
        return Offers.OfferCount;
    end
    return 0;
end

function ModuleTrade.Global:GetOfferAndTrader(_PlayerID, _GoodOrEntityType)
    local Info = self:GetStorehouseInformation(_PlayerID);
    if Info then
        for j=1, #Info[1], 1 do
            if Info[1][j][3] == _GoodOrEntityType then
                return Info[1][j][2], Info[1][j][1], Info.Storehouse;
            end
        end
    end
    return -1, -1, -1;
end

function ModuleTrade.Global:GetTraderType(_BuildingID, _TraderID)
    if Logic.IsGoodTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.GoodTrader;
    elseif Logic.IsMercenaryTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.MercenaryTrader;
    elseif Logic.IsEntertainerTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.EntertainerTrader;
    else
        return QSB.TraderTypes.Unknown;
    end
end

function ModuleTrade.Global:RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
    local OfferID, TraderID, BuildingID = self:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    if not IsExisting(BuildingID) then
        return;
    end
    -- Trader IDs are mixed up in Logic.RemoveOffer
    local MappedTraderID = (TraderID == 1 and 2) or (TraderID == 2 and 1) or 0;
    Logic.RemoveOffer(BuildingID, MappedTraderID, OfferID);
end

function ModuleTrade.Global:RemoveTradeOfferByData(_Data, _Index)
    local OfferID = _Data[1][_Index][2];
    local TraderID = _Data[1][_Index][1];
    local BuildingID = _Data.Storehouse;
    if not IsExisting(BuildingID) then
        return;
    end
    -- Trader IDs are mixed up in Logic.RemoveOffer
    local MappedTraderID = (TraderID == 1 and 2) or (TraderID == 2 and 1) or 0;
    Logic.RemoveOffer(BuildingID, MappedTraderID, OfferID);
end

function ModuleTrade.Global:ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
    local OfferID, TraderID, BuildingID = self:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    if not IsExisting(BuildingID) then
        return;
    end

    -- Amount == -1 or amount == nil means maximum
    if _NewAmount == nil or _NewAmount == -1 then
        _NewAmount = self.Analysis.PlayerOffersAmount[_PlayerID][_GoodOrEntityType];
    end
    -- Values greater than the maximum will not respawn!
    if self.Analysis.PlayerOffersAmount[_PlayerID][_GoodOrEntityType] and self.Analysis.PlayerOffersAmount[_PlayerID][_GoodOrEntityType] < _NewAmount then
        _NewAmount = self.Analysis.PlayerOffersAmount[_PlayerID][_GoodOrEntityType];
    end
    Logic.ModifyTraderOffer(BuildingID, OfferID, _NewAmount, TraderID);
end

-- Local -------------------------------------------------------------------- --

function ModuleTrade.Local:OnGameStart()
    QSB.ScriptEvents.GoodsSold = API.RegisterScriptEvent("Event_GoodsSold");
    QSB.ScriptEvents.GoodsPurchased = API.RegisterScriptEvent("Event_GoodsPurchased");

    g_Merchant.BuyFromPlayer = {};

    if API.IsHistoryEditionNetworkGame() then
        return;
    end
    self:OverrideMerchantComputePurchasePrice();
    self:OverrideMerchantComputeSellingPrice();
    self:OverrideMerchantSellGoodsClicked();
    self:OverrideMerchantPurchaseOfferUpdate();
    self:OverrideMerchantPurchaseOfferClicked();
end

function ModuleTrade.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleTrade.Local:GetTraderType(_BuildingID, _TraderID)
    if Logic.IsGoodTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.GoodTrader;
    elseif Logic.IsMercenaryTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.MercenaryTrader;
    elseif Logic.IsEntertainerTrader(_BuildingID, _TraderID) == true then
        return QSB.TraderTypes.EntertainerTrader;
    else
        return QSB.TraderTypes.Unknown;
    end
end

function ModuleTrade.Local:OverrideMerchantPurchaseOfferUpdate()
    GUI_Merchant.OfferUpdate = function(_ButtonIndex)
        local CurrentWidgetID   = XGUIEng.GetCurrentWidgetID();
        local CurrentWidgetMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local PlayerID          = GUI.GetPlayerID();
        local BuildingID        = g_Merchant.ActiveMerchantBuilding;
        if BuildingID == 0
        or Logic.IsEntityDestroyed(BuildingID) == true then
            return;
        end
        if g_Merchant.Offers[_ButtonIndex] == nil then
            XGUIEng.ShowWidget(CurrentWidgetMotherID,0);
            return;
        else
            XGUIEng.ShowWidget(CurrentWidgetMotherID,1);
        end
        local TraderType = g_Merchant.Offers[_ButtonIndex].TraderType;
        local OfferIndex = g_Merchant.Offers[_ButtonIndex].OfferIndex;
        local GoodType, OfferGoodAmount, OfferAmount, AmountPrices = 0,0,0,0;
        if TraderType == g_Merchant.GoodTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetGoodTraderOffer(BuildingID,OfferIndex,PlayerID);
            if GoodType == Goods.G_Sheep
            or GoodType == Goods.G_Cow then
                OfferGoodAmount = 5;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType]);
        elseif TraderType == g_Merchant.MercenaryTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetMercenaryOffer(BuildingID,OfferIndex,PlayerID);
            local TypeName = Logic.GetEntityTypeName(GoodType);
            if GoodType == Entities.U_Thief then
                OfferGoodAmount = 1;
            elseif string.find(TypeName, "U_MilitarySword")
            or     string.find(TypeName, "U_MilitaryBow") then
                OfferGoodAmount = 6;
            elseif string.find(TypeName, "Cart") then
                OfferGoodAmount = 1;
            else
                OfferGoodAmount = OfferGoodAmount;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[GoodType]);
        elseif TraderType == g_Merchant.EntertainerTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetEntertainerTraderOffer(BuildingID,OfferIndex,PlayerID);
            if not (Logic.CanHireEntertainer(PlayerID) == true
            and Logic.EntertainerIsOnTheMap(GoodType) == false) then
                OfferAmount = 0;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[GoodType]);
        end

        local OfferAmountWidget = XGUIEng.GetWidgetPathByID(CurrentWidgetMotherID) .. "/OfferAmount";
        XGUIEng.SetText(OfferAmountWidget, "{center}" .. OfferAmount);
        local OfferGoodAmountWidget = XGUIEng.GetWidgetPathByID(CurrentWidgetMotherID) .. "/OfferGoodAmount";
        XGUIEng.SetText(OfferGoodAmountWidget, "{center}" .. OfferGoodAmount);

        if OfferAmount == 0 then
            XGUIEng.DisableButton(CurrentWidgetID,1);
        else
            XGUIEng.DisableButton(CurrentWidgetID,0);
        end
    end
end

function ModuleTrade.Local:OverrideMerchantPurchaseOfferClicked()
    -- Set special conditions
    local PurchaseAllowedLambda = function(_Type, _Good, _Amount, _Price, _P1, _P2)
        return true;
    end
    self.Lambda.PurchaseAllowed.Default = PurchaseAllowedLambda;

    local BuyLock = {Locked = false};

    GameCallback_MerchantInteraction = function(_BuildingID, _PlayerID, _OfferID)
        if _PlayerID == GUI.GetPlayerID() then
            BuyLock.Locked = false;
        end
    end

    GUI_Merchant.OfferClicked = function(_ButtonIndex)
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local PlayerID   = GUI.GetPlayerID();
        local BuildingID = g_Merchant.ActiveMerchantBuilding;
        if BuildingID == 0 or BuyLock.Locked then
            return;
        end
        local PlayersMarketPlaceID  = Logic.GetMarketplace(PlayerID);
        local TraderPlayerID        = Logic.EntityGetPlayer(BuildingID);
        local TraderType            = g_Merchant.Offers[_ButtonIndex].TraderType;
        local OfferIndex            = g_Merchant.Offers[_ButtonIndex].OfferIndex;

        local CanBeBought = true;
        local GoodType, OfferGoodAmount, OfferAmount, AmountPrices = 0,0,0,0;
        if TraderType == g_Merchant.GoodTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetGoodTraderOffer(BuildingID, OfferIndex, PlayerID);
            if Logic.GetGoodCategoryForGoodType(GoodType) == GoodCategories.GC_Resource then
                if Logic.GetPlayerUnreservedStorehouseSpace(PlayerID) < OfferGoodAmount then
                    CanBeBought = false;
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantStorehouseSpace");
                    Message(MessageText);
                end
            elseif Logic.GetGoodCategoryForGoodType(GoodType) == GoodCategories.GC_Animal then
                CanBeBought = true;
            else
                if Logic.CanFitAnotherMerchantOnMarketplace(PlayersMarketPlaceID) == false then
                    CanBeBought = false;
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantMarketplaceFull");
                    Message(MessageText);
                end
            end
        elseif TraderType == g_Merchant.EntertainerTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetEntertainerTraderOffer(BuildingID, OfferIndex, BuildingID);
            if Logic.CanFitAnotherEntertainerOnMarketplace(PlayersMarketPlaceID) == false then
                CanBeBought = false;
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantMarketplaceFull");
                Message(MessageText);
            end
        elseif TraderType == g_Merchant.MercenaryTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetMercenaryOffer(BuildingID, OfferIndex, PlayerID);
            local GoodTypeName        = Logic.GetEntityTypeName(GoodType);
            local CurrentSoldierCount = Logic.GetCurrentSoldierCount(PlayerID);
            local CurrentSoldierLimit = Logic.GetCurrentSoldierLimit(PlayerID);
            local SoldierSize;
            if GoodType == Entities.U_Thief then
                SoldierSize = 1;
            elseif string.find(GoodTypeName, "U_MilitarySword")
            or     string.find(GoodTypeName, "U_MilitaryBow") then
                SoldierSize = 6;
            elseif string.find(GoodTypeName, "Cart") then
                SoldierSize = 0;
            else
                SoldierSize = OfferGoodAmount;
            end
            if (CurrentSoldierCount + SoldierSize) > CurrentSoldierLimit then
                CanBeBought = false;
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SoldierLimitReached");
                Message(MessageText);
            end
        end

        -- Special sales conditions
        if CanBeBought then
            if ModuleTrade.Local.Lambda.PurchaseAllowed[TraderPlayerID] then
                CanBeBought = ModuleTrade.Local.Lambda.PurchaseAllowed[TraderPlayerID](TraderType, GoodType, OfferGoodAmount, PlayerID, TraderPlayerID);
            else
                CanBeBought = ModuleTrade.Local.Lambda.PurchaseAllowed.Default(TraderType, GoodType, OfferGoodAmount, PlayerID, TraderPlayerID);
            end
            if not CanBeBought then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericNotReadyYet");
                Message(MessageText);
                return;
            end
        end

        if CanBeBought == true then
            local Price = ComputePrice( BuildingID, OfferIndex, PlayerID, TraderType);
            local GoldAmountInCastle = GetPlayerGoodsInSettlement(Goods.G_Gold, PlayerID);
            local PlayerSectorType = PlayerSectorTypes.Civil;
            local IsReachable = CanEntityReachTarget(PlayerID, Logic.GetStoreHouse(TraderPlayerID), Logic.GetStoreHouse(PlayerID), nil, PlayerSectorType);
            if IsReachable == false then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable");
                Message(MessageText);
                return;
            end
            if Price <= GoldAmountInCastle then
                BuyLock.Locked = true;
                GUI.ChangeMerchantOffer(BuildingID, PlayerID, OfferIndex, Price);
                Sound.FXPlay2DSound("ui\\menu_click");
                if ModuleTrade.Local.ShowKnightTraderAbility then
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightTrading);
                end

                -- Manually log in local state
                g_Merchant.BuyFromPlayer[TraderPlayerID] = g_Merchant.BuyFromPlayer[TraderPlayerID] or {};
                g_Merchant.BuyFromPlayer[TraderPlayerID][GoodType] = (g_Merchant.BuyFromPlayer[TraderPlayerID][GoodType] or 0) +1;

                API.BroadcastScriptEventToGlobal(
                    "GoodsPurchased",
                    OfferIndex,
                    TraderType,
                    GoodType,
                    OfferGoodAmount,
                    Price,
                    PlayerID,
                    TraderPlayerID
                );
            else
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
                Message(MessageText);
            end
        end
    end
end

function ModuleTrade.Local:OverrideMerchantSellGoodsClicked()
    -- Set special conditions
    local SaleAllowedLambda = function(_Type, _Good, _Amount, _Price, _P1, _P2)
        return true;
    end
    self.Lambda.SaleAllowed.Default = SaleAllowedLambda;

    GUI_Trade.SellClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        if g_Trade.GoodAmount == 0 then
            return;
        end
        local PlayerID = GUI.GetPlayerID();
        local ButtonIndex = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID())));
        local TargetID = g_Trade.TargetPlayers[ButtonIndex];
        local PlayerSectorType = PlayerSectorTypes.Civil;
        if g_Trade.GoodType == Goods.G_Gold then
            PlayerSectorType = PlayerSectorTypes.Thief;
        end
        local IsReachable = CanEntityReachTarget(TargetID, Logic.GetStoreHouse(PlayerID), Logic.GetStoreHouse(TargetID), nil, PlayerSectorType);
        if IsReachable == false then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable");
            Message(MessageText);
            return;
        end
        if g_Trade.GoodType == Goods.G_Gold then
            -- FIXME: check for treasury space in castle?
        elseif Logic.GetGoodCategoryForGoodType(g_Trade.GoodType) == GoodCategories.GC_Resource then
            local SpaceForNewGoods = Logic.GetPlayerUnreservedStorehouseSpace(TargetID);
            if SpaceForNewGoods < g_Trade.GoodAmount then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionStorehouseSpace");
                Message(MessageText);
                return;
            end
        else
            if Logic.GetNumberOfTradeGatherers(PlayerID) >= 1 then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TradeGathererUnderway");
                Message(MessageText);
                return;
            end
            if Logic.CanFitAnotherMerchantOnMarketplace(Logic.GetMarketplace(TargetID)) == false then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionMarketplaceFull");
                Message(MessageText);
                return;
            end
        end

        -- Special sales conditions
        local CanBeSold = true;
        if ModuleTrade.Local.Lambda.SaleAllowed[TargetID] then
            CanBeSold = ModuleTrade.Local.Lambda.SaleAllowed[TargetID](g_Merchant.GoodTrader, g_Trade.GoodType, g_Trade.GoodAmount, PlayerID, TargetID);
        else
            CanBeSold = ModuleTrade.Local.Lambda.SaleAllowed.Default(g_Merchant.GoodTrader, g_Trade.GoodType, g_Trade.GoodAmount, PlayerID, TargetID);
        end
        if not CanBeSold then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericNotReadyYet");
            Message(MessageText);
            return;
        end

        local Price;
        local PricePerUnit;
        if Logic.PlayerGetIsHumanFlag(TargetID) then
            Price = 0;
            PricePerUnit = 0;
        else
            Price = GUI_Trade.ComputeSellingPrice(TargetID, g_Trade.GoodType, g_Trade.GoodAmount);
            PricePerUnit = Price / g_Trade.GoodAmount;
        end

        GUI.StartTradeGoodGathering(PlayerID, TargetID, g_Trade.GoodType, g_Trade.GoodAmount, PricePerUnit);
        GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil);
        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightTrading);

        if PricePerUnit ~= 0 then
            if g_Trade.SellToPlayers[TargetID] == nil then
                g_Trade.SellToPlayers[TargetID] = {};
            end
            if g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] == nil then
                g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.GoodAmount;
            else
                g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] + g_Trade.GoodAmount;
            end
            API.BroadcastScriptEventToGlobal(
                "GoodsSold",
                g_Merchant.GoodTrader,
                g_Trade.GoodType,
                g_Trade.GoodAmount,
                Price,
                PlayerID,
                TargetID
            );
        end
    end
end

function ModuleTrade.Local:OverrideMerchantComputePurchasePrice()
    -- Override factor of hero ability
    local AbilityTraderLambda = function(_TraderType, _OfferType, _BasePrice, _PlayerID, _TraderPlayerID)
        local Modifier = Logic.GetKnightTraderAbilityModifier(_PlayerID);
        return math.ceil(_BasePrice / Modifier);
    end
    self.Lambda.PurchaseTraderAbility.Default = AbilityTraderLambda;

    -- Override base price calculation
    local BasePriceLambda = function(_TraderType, _OfferType, _PlayerID, _TraderPlayerID)
        local BasePrice = MerchantSystem.BasePrices[_OfferType];
        return (BasePrice == nil and 3) or BasePrice;
    end
    self.Lambda.PurchaseBasePrice.Default = BasePriceLambda;

    -- Override max inflation
    local InflationLambda = function(_TraderType, _GoodType, _OfferCount, _Price, _PlayerID, _TraderPlayerID)
        _OfferCount = (_OfferCount > 8 and 8) or _OfferCount;
        local Result = _Price + (math.ceil(_Price / 4) * _OfferCount);
        return (Result < _Price and _Price) or Result;
    end
    self.Lambda.PurchaseInflation.Default = InflationLambda;

    -- Override function
    ComputePrice = function(BuildingID, OfferID, PlayerID, TraderType)
        local TraderPlayerID = Logic.EntityGetPlayer(BuildingID);
        local Type = Logic.GetGoodOfOffer(BuildingID, OfferID, PlayerID, TraderType);

        -- Calculate the base price
        local BasePrice;
        if ModuleTrade.Local.Lambda.PurchaseBasePrice[TraderPlayerID] then
            BasePrice = ModuleTrade.Local.Lambda.PurchaseBasePrice[TraderPlayerID](TraderType, Type, PlayerID, TraderPlayerID)
        else
            BasePrice = ModuleTrade.Local.Lambda.PurchaseBasePrice.Default(TraderType, Type, PlayerID, TraderPlayerID)
        end

        -- Calculate price
        local Price
        if ModuleTrade.Local.Lambda.PurchaseTraderAbility[TraderPlayerID] then
            Price = ModuleTrade.Local.Lambda.PurchaseTraderAbility[TraderPlayerID](TraderType, Type, BasePrice, PlayerID, TraderPlayerID)
        else
            Price = ModuleTrade.Local.Lambda.PurchaseTraderAbility.Default(TraderType, Type, BasePrice, PlayerID, TraderPlayerID)
        end

        -- Invoke price inflation
        local OfferCount = 0;
        if g_Merchant.BuyFromPlayer[TraderPlayerID] and g_Merchant.BuyFromPlayer[TraderPlayerID][Type] then
            OfferCount = g_Merchant.BuyFromPlayer[TraderPlayerID][Type];
        end
        local FinalPrice;
        if ModuleTrade.Local.Lambda.PurchaseInflation[TraderPlayerID] then
            FinalPrice = ModuleTrade.Local.Lambda.PurchaseInflation[TraderPlayerID](TraderType, Type, OfferCount, Price, PlayerID, TraderPlayerID);
        else
            FinalPrice = ModuleTrade.Local.Lambda.PurchaseInflation.Default(TraderType, Type, OfferCount, Price, PlayerID, TraderPlayerID);
        end
        return FinalPrice;
    end
end

function ModuleTrade.Local:OverrideMerchantComputeSellingPrice()
    -- Override factor of hero ability
    local AbilityTraderLambda = function(_TraderType, _OfferType, _BasePrice, _PlayerID, _TraderPlayerID)
        -- No change by default
        return _BasePrice;
    end
    self.Lambda.SaleTraderAbility.Default = AbilityTraderLambda;

    -- Override base price calculation
    local BasePriceLambda = function(_TraderType, _OfferType, _PlayerID, _TargetPlayerID)
        local BasePrice = MerchantSystem.BasePrices[_OfferType];
        return (BasePrice == nil and 3) or BasePrice;
    end
    self.Lambda.SaleBasePrice.Default = BasePriceLambda;

    -- Override max deflation
    local DeflationLambda = function(_TraderType, _OfferType, _WagonsSold, _Price, _PlayerID, _TargetPlayerID)
        return _Price - math.ceil(_Price / 4);
    end
    self.Lambda.SaleDeflation.Default = DeflationLambda;

    GUI_Trade.ComputeSellingPrice = function(_TargetPlayerID, _GoodType, _GoodAmount)
        if _GoodType == Goods.G_Gold then
            return 0;
        end
        local PlayerID = GUI.GetPlayerID();
        local Waggonload = MerchantSystem.Waggonload;

        -- Calculate the base price
        local BasePrice;
        if ModuleTrade.Local.Lambda.SaleBasePrice[_TargetPlayerID] then
            BasePrice = ModuleTrade.Local.Lambda.SaleBasePrice[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, PlayerID, _TargetPlayerID);
        else
            BasePrice = ModuleTrade.Local.Lambda.SaleBasePrice.Default(g_Merchant.GoodTrader, _GoodType, PlayerID, _TargetPlayerID);
        end

        -- Calculate price
        local Price = BasePrice;
        if ModuleTrade.Local.Lambda.SaleTraderAbility[_TargetPlayerID] then
            Price = ModuleTrade.Local.Lambda.SaleTraderAbility[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, BasePrice, PlayerID, _TargetPlayerID)
        else
            Price = ModuleTrade.Local.Lambda.SaleTraderAbility.Default(g_Merchant.GoodTrader, _GoodType, BasePrice, PlayerID, _TargetPlayerID)
        end

        local GoodsSoldToTargetPlayer = 0
        if  g_Trade.SellToPlayers[_TargetPlayerID] ~= nil
        and g_Trade.SellToPlayers[_TargetPlayerID][_GoodType] ~= nil then
            GoodsSoldToTargetPlayer = g_Trade.SellToPlayers[_TargetPlayerID][_GoodType];
        end
        local Modifier = math.ceil(Price / 4);
        local WaggonsToSell = math.ceil(_GoodAmount / Waggonload);
        local WaggonsSold = math.ceil(GoodsSoldToTargetPlayer / Waggonload);

        -- Calculate the max deflation
        local MaxToSubstract
        if ModuleTrade.Local.Lambda.SaleDeflation[_TargetPlayerID] then
            MaxToSubstract = ModuleTrade.Local.Lambda.SaleDeflation[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, WaggonsSold, Price, PlayerID, _TargetPlayerID);
        else
            MaxToSubstract = ModuleTrade.Local.Lambda.SaleDeflation.Default(g_Merchant.GoodTrader, _GoodType, WaggonsSold, Price, PlayerID, _TargetPlayerID);
        end

        local PriceToSubtract = 0;
        for i = 1, WaggonsToSell do
            PriceToSubtract = PriceToSubtract + math.min(WaggonsSold * Modifier, MaxToSubstract);
            WaggonsSold = WaggonsSold + 1;
        end

        return (WaggonsToSell * BasePrice) - PriceToSubtract;
    end
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleTrade);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

---
-- Es kann in den Ablauf von Kauf und Verkauf eingegriffen werden.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field GoodsPurchased Güter werden bei einem Händler gekauft (Parameter: OfferID, TraderType, GoodType, OfferGoodAmount, Price, PlayerID, TraderPlayerID)
-- @field GoodsSold      Güter werden im eigenen Lagerhaus verkauft (Parameter: TraderType, GoodType, GoodAmount, Price, PlayerID, TargetPlayerID)
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

---
-- Typen der Händler
--
-- @field GoodTrader        Es werden Güter verkauft
-- @field MercenaryTrader   Es werden Söldner verkauft
-- @field EntertainerTrader Es werden Entertainer verkauft
-- @field Unknown           Unbekannter Typ (Fehler)
--
QSB.TraderTypes = QSB.TraderTypes or {};

---
-- Setzt die Funktion zur Kalkulation des Einkaufspreisfaktors des Helden. Die
-- Änderung betrifft nur den angegebenen Spieler.
-- Die Funktion muss den angepassten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_BasePrice</td><td>number</td><td></td>Basispreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetTraderAbilityForPlayer(2, MyCalculationFunction);
--
function API.PurchaseSetTraderAbilityForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.PurchaseTraderAbility[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.PurchaseTraderAbility.Default = _Function;
    end
end

---
-- Setzt die allgemeine Funktion zur Kalkulation des Einkaufspreisfaktors des
-- Helden. Die Funktion muss den angepassten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_BasePrice</td><td>number</td><td></td>Basispreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetDefaultTraderAbility(MyCalculationFunction);
--
function API.PurchaseSetDefaultTraderAbility(_Function)
    API.PurchaseSetTraderAbilityForPlayer(nil, _Function);
end

---
-- Setzt die Funktion zur Bestimmung des Basispreis. Die Änderung betrifft nur
-- den angegebenen Spieler.
-- Die Funktion muss den Basispreis der Ware zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetBasePriceForPlayer(2, MyCalculationFunction);
--
function API.PurchaseSetBasePriceForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.PurchaseBasePrice[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.PurchaseBasePrice.Default = _Function;
    end
end

---
-- Setzt die Funktion zur Bestimmung des Basispreis.
-- Die Funktion muss den Basispreis der Ware zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetDefaultBasePrice(MyCalculationFunction);
--
function API.PurchaseSetDefaultBasePrice(_Function)
    API.PurchaseSetBasePriceForPlayer(nil, _Function);
end

---
-- Setzt die Funktion zur Berechnung der Preisinflation. Die Änderung betrifft
-- nur den angegebenen Spieler.
-- Die Funktion muss den von der Inflation beeinflussten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Anzahl bereits gekaufter Angebote</td></tr>
-- <tr><td>_Price</td><td>number</td><td></td>Einkaufspreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetInflationForPlayer(2, MyCalculationFunction);
--
function API.PurchaseSetInflationForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.PurchaseInflation[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.PurchaseInflation.Default = _Function;
    end
end

---
-- Setzt die Funktion zur Berechnung der Preisinflation.
-- Die Funktion muss den von der Inflation beeinflussten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Anzahl bereits gekaufter Angebote</td></tr>
-- <tr><td>_Price</td><td>number</td><td></td>Einkaufspreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetDefaultInflation(MyCalculationFunction);
--
function API.PurchaseSetDefaultInflation(_Function)
    API.PurchaseSetInflationForPlayer(nil, _Function)
end

---
-- Setzt eine Funktion zur Festlegung spezieller Ankaufsbedingungen. Diese
-- Bedingungen betreffen nur den angegebenen Spieler.
-- Die Funktion muss true zurückgeben, wenn gekauft werden darf.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Verkaufte Menge</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Evaluationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetConditionForPlayer(2, MyCalculationFunction);
--
function API.PurchaseSetConditionForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.PurchaseAllowed[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.PurchaseAllowed.Default = _Function;
    end
end

---
-- Setzt eine Funktion zur Festlegung spezieller Verkaufsbedingungen.
-- Die Funktion muss true zurückgeben, wenn verkauft werden darf.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Verkaufte Menge</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Evaluationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.PurchaseSetDefaultCondition(MyCalculationFunction);
--
function API.PurchaseSetDefaultCondition(_Function)
    API.PurchaseSetConditionForPlayer(nil, _Function)
end

---
-- Setzt die Funktion zur Kalkulation des Verkreisfaktors des Helden. Die
-- Änderung betrifft nur den angegebenen Spieler.
-- Die Funktion muss den angepassten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td></td>Typ des Händlers</tr>
-- <tr><td>_Good</td><td>number</td><td></td>Typ des Angebot</tr>
-- <tr><td>_BasePrice</td><td>number</td><td></td>Basispreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetTraderAbilityForPlayer(2, MyCalculationFunction);
--
function API.SaleSetTraderAbilityForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.SaleTraderAbility[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.SaleTraderAbility.Default = _Function;
    end
end

---
-- Setzt die allgemeine Funktion zur Kalkulation des Verkreisfaktors des Helden.
-- Die Funktion muss den angepassten Preis zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td></td>Typ des Händlers</tr>
-- <tr><td>_Good</td><td>number</td><td></td>Typ des Angebot</tr>
-- <tr><td>_BasePrice</td><td>number</td><td></td>Basispreis</tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Käufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Verkäufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetDefaultTraderAbility(MyCalculationFunction);
--
function API.SaleSetDefaultTraderAbility(_Function)
    API.SaleSetTraderAbilityForPlayer(nil, _Function);
end

---
-- Setzt die Funktion zur Bestimmung des Basispreis. Die Änderung betrifft nur
-- den angegebenen Spieler.
-- Die Funktion muss den Basispreis der Ware zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetBasePriceForPlayer(2, MyCalculationFunction);
--
function API.SaleSetBasePriceForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.SaleBasePrice[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.SaleBasePrice.Default = _Function;
    end
end

---
-- Setzt die Funktion zur Bestimmung des Basispreis.
-- Die Funktion muss den Basispreis der Ware zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetDefaultBasePrice(MyCalculationFunction);
--
function API.SaleSetDefaultBasePrice(_Function)
    API.SaleSetBasePriceForPlayer(nil, _Function);
end

---
-- Setzt die Funktion zur Berechnung des minimalen Verkaufserlös. Die Änderung
-- betrifft nur den angegebenen Spieler.
-- Die Funktion muss den von der Deflation beeinflussten Erlös zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_SaleCount</td><td>number</td><td>Amount of sold waggons</td></tr>
-- <tr><td>_Price</td><td>number</td><td>Verkaufspreis</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetDeflationForPlayer(2, MyCalculationFunction);
--
function API.SaleSetDeflationForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.SaleDeflation[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.SaleDeflation.Default = _Function;
    end
end

---
-- Setzt die Funktion zur Berechnung des minimalen Verkaufserlös.
-- Die Funktion muss den von der Deflation beeinflussten Erlös zurückgeben.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_SaleCount</td><td>number</td><td>Amount of sold waggons</td></tr>
-- <tr><td>_Price</td><td>number</td><td>Verkaufspreis</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Kalkulationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetDefaultDeflation(MyCalculationFunction);
--
function API.SaleSetDefaultDeflation(_Function)
    API.SaleSetDeflationForPlayer(nil, _Function);
end

---
-- Setzt eine Funktion zur Festlegung spezieller Verkaufsbedingungen. Diese
-- Bedingungen betreffen nur den angegebenen Spieler.
-- Die Funktion muss true zurückgeben, wenn verkauft werden darf.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Verkaufte Menge</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- <b>Hinweis</b>: Um den Standard wiederherzustellen, muss nil als Funktion
-- übergeben werden.
--
-- @param[type=number] _PlayerID Player ID des Händlers
-- @param[type=number] _Function Evaluationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetConditionForPlayer(2, MyCalculationFunction);
--
function API.SaleSetConditionForPlayer(_PlayerID, _Function)
    if not GUI then
        return;
    end
    if _PlayerID then
        ModuleTrade.Local.Lambda.SaleAllowed[_PlayerID] = _Function;
    else
        ModuleTrade.Local.Lambda.SaleAllowed.Default = _Function;
    end
end

---
-- Setzt eine Funktion zur Festlegung spezieller Verkaufsbedingungen.
-- Die Funktion muss true zurückgeben, wenn verkauft werden darf.
--
-- Parameter der Funktion:
-- <table border="1">
-- <tr><th><b>Parameter</b></th><th><b>Typ</b></th><th><b>Beschreibung</b></th></tr>
-- <tr><td>_Type</td><td>number</td><td>Typ des Händler</td></tr>
-- <tr><td>_Good</td><td>number</td><td>Typ des Angebot</td></tr>
-- <tr><td>_Amount</td><td>number</td><td>Verkaufte Menge</td></tr>
-- <tr><td>_PlayerID1</td><td>number</td><td>ID des Verkäufers</td></tr>
-- <tr><td>_PlayerID2</td><td>number</td><td>ID des Käufers</td></tr>
-- </table>
--
-- <b>Hinweis:</b> Die Funktion kann nur im lokalen Skript verwendet werden!
--
-- @param[type=number] _Function Evaluationsfunktion
-- @within Anwenderfunktionen
--
-- @usage
-- API.SaleSetDefaultCondition(MyCalculationFunction);
--
function API.SaleSetDefaultCondition(_Function)
    API.SaleSetConditionForPlayer(nil, _Function);
end

---
-- Lässt einen NPC-Spieler Waren anbieten.
--
-- @param[type=number] _VendorID    Spieler-ID des Verkäufers
-- @param[type=number] _OfferType   Typ der Angebote
-- @param[type=number] _OfferAmount Menge an Angeboten
-- @param[type=number] _RefreshRate (Optional) Regenerationsrate des Angebot
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Spieler 2 bietet Brot an
-- API.AddGoodOffer(2, Goods.G_Bread, 1, 2);
--
function API.AddGoodOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    _OfferType = (type(_OfferType) == "string" and Goods[_OfferType]) or _OfferType;
    local OfferID, TraderID = ModuleTrade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        warn(string.format(
            "Good offer for type %s already exists for player %d!",
            Logic.GetGoodTypeName(_OfferType),
            _VendorID
        ));
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);
    AddGoodToTradeBlackList(_VendorID, _OfferType);

    -- Good cart type
    local MarketerType = Entities.U_Marketer;
    if _OfferType == Goods.G_Medicine then
        MarketerType = Entities.U_Medicus;
    end
    -- Refresh rate
    if _RefreshRate == nil then
        _RefreshRate = MerchantSystem.RefreshRates[_OfferType] or 0;
    end

    local LogicOfferID = Logic.AddGoodTraderOffer(
        VendorStoreID,
        _OfferAmount,
        Goods.G_Gold,
        0,
        _OfferType,
        MerchantSystem.Waggonload,
        1,
        _RefreshRate,
        MarketerType,
        Entities.U_ResourceMerchant
    );
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    ));
    return LogicOfferID;
end
-- Compability option
function AddOffer(_Merchant, _NumberOfOffers, _GoodType, _RefreshRate)
    local VendorID = Logic.EntityGetPlayer(GetID(_Merchant));
    return API.AddGoodOffer(VendorID, _GoodType, _NumberOfOffers, _RefreshRate);
end

---
-- Lässt einen NPC-Spieler Söldner anbieten.
--
-- <b>Hinweis</b>: Stadtlagerhäuser können keine Söldner anbieten!
--
-- @param[type=number] _VendorID    Spieler-ID des Verkäufers
-- @param[type=number] _OfferType   Typ der Söldner
-- @param[type=number] _OfferAmount Menge an Söldnern
-- @param[type=number] _RefreshRate (Optional) Regenerationsrate des Angebot
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Spieler 2 bietet Sölder an
-- API.AddMercenaryOffer(2, Entities.U_MilitaryBandit_Melee_SE, 1, 3);
--
function API.AddMercenaryOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    _OfferType = (type(_OfferType) == "string" and Entities[_OfferType]) or _OfferType;
    local OfferID, TraderID = ModuleTrade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        warn(string.format(
            "Mercenary offer for type %s already exists for player %d!",
            Logic.GetEntityTypeName(_OfferType),
            _VendorID
        ));
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);

    -- Refresh rate
    if _RefreshRate == nil then
        _RefreshRate = MerchantSystem.RefreshRates[_OfferType] or 0;
    end
    -- Soldier count (Display hack for unusual mercenaries)
    local SoldierCount = 3;
    local TypeName = Logic.GetEntityTypeName(_OfferType);
    if string.find(TypeName, "MilitaryBow") or string.find(TypeName, "MilitarySword") then
        SoldierCount = 6;
    elseif string.find(TypeName,"Cart") then
        SoldierCount = 0;
    end

    local LogicOfferID = Logic.AddMercenaryTraderOffer(
        VendorStoreID,
        _OfferAmount,
        Goods.G_Gold,
        0,
        _OfferType,
        SoldierCount,
        1,
        _RefreshRate
    );
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    ));
    return LogicOfferID;
end
-- Compability option
function AddMercenaryOffer(_Mercenary, _Amount, _Type, _RefreshRate)
    local VendorID = Logic.EntityGetPlayer(GetID(_Mercenary));
    return API.AddMercenaryOffer(VendorID, _Type, _Amount, _RefreshRate);
end

---
-- Lässt einen NPC-Spieler einen Entertainer anbieten.
--
-- @param[type=number] _VendorID    Spieler-ID des Verkäufers
-- @param[type=number] _OfferType   Typ des Entertainer
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Spieler 2 bietet einen Feuerschlucker an
-- API.AddEntertainerOffer(2, Entities.U_Entertainer_NA_FireEater);
--
function API.AddEntertainerOffer(_VendorID, _OfferType)
    _OfferType = (type(_OfferType) == "string" and Entities[_OfferType]) or _OfferType;
    local OfferID, TraderID = ModuleTrade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        warn(string.format(
            "Entertainer offer for type %s already exists for player %d!",
            Logic.GetEntityTypeName(_OfferType),
            _VendorID
        ));
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);
    local LogicOfferID = Logic.AddEntertainerTraderOffer(
        VendorStoreID,
        1,
        Goods.G_Gold,
        0,
        _OfferType,
        1,
        0
    );
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    ));
    return LogicOfferID;
end
-- Compability option
function AddEntertainerOffer(_Merchant, _EntertainerType)
    local VendorID = Logic.EntityGetPlayer(GetID(_Merchant));
    return API.AddEntertainerOffer(VendorID, _EntertainerType);
end

---
-- Gibt die Angebotsinformationen des Spielers aus. In dem Table stehen
-- ID des Spielers, ID des Lagerhaus, Menge an Angeboten insgesamt und
-- alle Angebote der Händlertypen.
--
-- @param[type=number] _PlayerID Player ID
-- @return[type=table] Angebotsinformationen
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- local Info = API.GetOfferInformation(2);
--
-- -- Info enthält:
-- -- Info = {
-- --      Player = 2,
-- --      Storehouse = 26796.
-- --      OfferCount = 2,
-- --      {
-- --          Händler-ID, Angebots-ID, Angebotstyp, Wagenladung, Angebotsmenge
-- --          {0, 0, Goods.G_Gems, 9, 2},
-- --          {0, 1, Goods.G_Milk, 9, 4},
-- --      },
-- -- };
--
function API.GetOfferInformation(_PlayerID)
    if GUI then
        return;
    end
    return ModuleTrade.Global:GetStorehouseInformation(_PlayerID);
end

---
-- Gibt die Menge an Angeboten im Lagerhaus des Spielers zurück. Wenn
-- der Spieler kein Lagerhaus hat, wird 0 zurückgegeben.
--
-- @param[type=number] _PlayerID Player ID
-- @return[type=number] Anzahl angebote
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Angebote von Spieler 5 zählen
-- local Count = API.GetOfferCount(5);
--
function API.GetOfferCount(_PlayerID)
    if GUI then
        return;
    end
    return ModuleTrade.Global:GetOfferCount(_PlayerID);
end

---
-- Gibt zurück, ob das Angebot vom angegebenen Spieler im Lagerhaus zum
-- Verkauf angeboten wird.
--
-- @param[type=number] _PlayerID Player ID
-- @param[type=number] _GoodOrEntityType Warentyp oder Entitytyp
-- @return[type=boolean] Ware wird angeboten
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Wird die Ware angeboten?
-- if API.IsGoodOrUnitOffered(4, Goods.G_Bread) then
--     Logic.DEBUG_AddNote("Brot wird von Spieler 4 angeboten.");
-- end
--
function API.IsGoodOrUnitOffered(_PlayerID, _GoodOrEntityType)
    if GUI then
        return;
    end
    local OfferID, TraderID = ModuleTrade.Global:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    return OfferID ~= 1 and TraderID ~= 1;
end

---
-- Gibt die aktuelle Anzahl an Angeboten des Typs zurück.
--
-- @param[type=number] _PlayerID Player ID
-- @param[type=number] _GoodOrEntityType Warentyp oder Entitytyp
-- @return[type=number] Menge an Angeboten
-- @within Anwenderfunktionen
-- @local
--
-- @usage
-- -- Wie viel wird aktuell angeboten?
-- local CurrentAmount = API.IsGoodOrUnitOffered(4, Goods.G_Bread);
--
function API.GetTradeOfferWaggonAmount(_PlayerID, _GoodOrEntityType)
    local Amount = -1;
    local OfferInfo = ModuleTrade.Global:GetStorehouseInformation(_PlayerID);
    for i= 1, #OfferInfo[4] do
        if OfferInfo[4][i][3] == _GoodOrEntityType and OfferInfo[4][i][5] > 0 then
            Amount = OfferInfo[4][i][5];
        end
    end
    return Amount;
end

---
-- Entfernt das Angebot vom Lagerhaus des Spielers, wenn es vorhanden
-- ist. Es wird immer nur das erste Angebot des Typs entfernt.
--
-- @param[type=number] _PlayerID Player ID
-- @param[type=number] _GoodOrEntityType Warentyp oder Entitytyp
-- @within Anwenderfunktionen
--
-- @usage
-- -- Keinen Käse mehr verkaufen
-- API.RemoveTradeOffer(7, Goods.G_Cheese);
--
function API.RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
    if GUI then
        return;
    end
    return ModuleTrade.Global:RemoveTradeOffer(_PlayerID, _GoodOrEntityType);
end

---
-- Ändert die aktuelle Menge des Angebots im Händelrgebäude.
--
-- Es kann ein beliebiger positiver Wert gesetzt werden. Es gibt keine
-- Beschränkungen.
--
-- <b>Hinweis</b>: Wird eine höherer Wert gesetzt, als das ursprüngliche
-- Maximum, regenerieren sich die Angebote nicht, bis die zusätzlichen
-- Angebote verkauft wurden.
--
-- @param[type=number] _PlayerID Player ID
-- @param[type=number] _GoodOrEntityType ID des Händlers im Gebäude
-- @param[type=number] _NewAmount Neue Menge an Angeboten
-- @within Anwenderfunktionen
--
-- @usage
-- -- Beispiel #1: Angebote voll auffüllen
-- API.ModifyTradeOffer(7, Goods.G_Cheese, -1);
--
-- @usage
-- -- Beispiel #2: Angebote auffüllen
-- API.ModifyTradeOffer(7, Goods.G_Dye, 2);
--
function API.ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
    if GUI then
        return;
    end
    return ModuleTrade.Global:ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleBuildingButtons = {
    Properties = {
        Name = "ModuleBuildingButtons",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {},
    Local = {
        BuildingButtons = {
            BindingCounter = 0,
            Bindings = {},
            Configuration = {
                ["BuyAmmunitionCart"] = {
                    TypeExclusion = "^B_.*StoreHouse",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyBattallion"] = {
                    TypeExclusion = "^B_[CB]a[sr][tr][la][ec]",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["PlaceField"] = {
                    TypeExclusion = "^B_.*[BFH][aei][erv][kme]",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["StartFestival"] = {
                    TypeExclusion = "^B_Marketplace",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["StartTheatrePlay"] = {
                    TypeExclusion = "^B_Theatre",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["UpgradeTurret"] = {
                    TypeExclusion = "^B_WallTurret",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyBatteringRamCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyCatapultCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuySiegeTowerCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
            },
        },
    },

    Shared = {};
}

-- Global ------------------------------------------------------------------- --

function ModuleBuildingButtons.Global:OnGameStart()
    QSB.ScriptEvents.UpgradeCanceled = API.RegisterScriptEvent("Event_UpgradeCanceled");
    QSB.ScriptEvents.UpgradeStarted = API.RegisterScriptEvent("Event_UpgradeStarted");
    QSB.ScriptEvents.FestivalStarted = API.RegisterScriptEvent("Event_FestivalStarted");
    QSB.ScriptEvents.SermonStarted = API.RegisterScriptEvent("Event_SermonStarted");
    QSB.ScriptEvents.TheatrePlayStarted = API.RegisterScriptEvent("Event_TheatrePlayStarted");

    -- Building upgrade started event
    API.RegisterScriptCommand("Cmd_StartBuildingUpgrade", function(_BuildingID, _PlayerID)
        if Logic.IsBuildingBeingUpgraded(_BuildingID) then
            ModuleBuildingButtons.Global:SendStartBuildingUpgradeEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Building upgrade canceled event
    API.RegisterScriptCommand("Cmd_CancelBuildingUpgrade", function(_BuildingID, _PlayerID)
        if not Logic.IsBuildingBeingUpgraded(_BuildingID) then
            ModuleBuildingButtons.Global:SendCancelBuildingUpgradeEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Theatre play started event
    API.RegisterScriptCommand("Cmd_StartTheatrePlay", function(_BuildingID, _PlayerID)
        if Logic.GetTheatrePlayProgress(_BuildingID) ~= 0 then
            ModuleBuildingButtons.Global:SendTheatrePlayEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Festival started event
    API.RegisterScriptCommand("Cmd_StartRegularFestival", function(_PlayerID)
        if Logic.IsFestivalActive(_PlayerID) == true then
            ModuleBuildingButtons.Global:SendStartRegularFestivalEvent(_PlayerID);
        end
    end);
    -- Sermon started event
    API.RegisterScriptCommand("Cmd_StartSermon", function(_PlayerID)
        if Logic.IsSermonActive(_PlayerID) == true then
            ModuleBuildingButtons.Global:SendStartSermonEvent(_PlayerID);
        end
    end);
end

function ModuleBuildingButtons.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleBuildingButtons.Global:SendStartBuildingUpgradeEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.UpgradeStarted, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.UpgradeStarted, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendCancelBuildingUpgradeEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.UpgradeCanceled, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.UpgradeCanceled, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendTheatrePlayEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.TheatrePlayStarted, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.TheatrePlayStarted, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendStartRegularFestivalEvent(_PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.FestivalStarted, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.FestivalStarted, %d)]],
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendStartSermonEvent(_PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.SermonStarted, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.SermonStarted, %d)]],
        _PlayerID
    ));
end

-- Local -------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:OnGameStart()
    QSB.ScriptEvents.UpgradeCanceled = API.RegisterScriptEvent("Event_UpgradeCanceled");
    QSB.ScriptEvents.UpgradeStarted = API.RegisterScriptEvent("Event_UpgradeStarted");
    QSB.ScriptEvents.FestivalStarted = API.RegisterScriptEvent("Event_FestivalStarted");
    QSB.ScriptEvents.SermonStarted = API.RegisterScriptEvent("Event_SermonStarted");
    QSB.ScriptEvents.TheatrePlayStarted = API.RegisterScriptEvent("Event_TheatrePlayStarted");

    self:InitBackupPositions();
    self:OverrideOnSelectionChanged();
    self:OverrideBuyAmmunitionCart();
    self:OverrideBuyBattalion();
    self:OverrideBuySiegeEngineCart();
    self:OverridePlaceField();
    self:OverrideStartFestival();
    self:OverrideStartTheatrePlay();
    self:OverrideUpgradeTurret();
    self:OverrideUpgradeBuilding();
    self:OverrideStartSermon();
end

function ModuleBuildingButtons.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:OverrideOnSelectionChanged()
    GameCallback_GUI_SelectionChanged_Orig_Interface = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        GameCallback_GUI_SelectionChanged_Orig_Interface(_Source);
        ModuleBuildingButtons.Local:UnbindButtons();
        ModuleBuildingButtons.Local:BindButtons(GUI.GetSelectedEntity());
    end
end

function ModuleBuildingButtons.Local:OverrideBuyAmmunitionCart()
    GUI_BuildingButtons.BuyAmmunitionCartClicked_Orig_Interface = GUI_BuildingButtons.BuyAmmunitionCartClicked;
    GUI_BuildingButtons.BuyAmmunitionCartClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.BuyAmmunitionCartClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyAmmunitionCartUpdate_Orig_Interface = GUI_BuildingButtons.BuyAmmunitionCartUpdate;
    GUI_BuildingButtons.BuyAmmunitionCartUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {10, 4});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuyAmmunitionCartUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideBuyBattalion()
    GUI_BuildingButtons.BuyBattalionClicked_Orig_Interface = GUI_BuildingButtons.BuyBattalionClicked;
    GUI_BuildingButtons.BuyBattalionClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.BuyBattalionClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyBattalionMouseOver_Orig_Interface = GUI_BuildingButtons.BuyBattalionMouseOver;
    GUI_BuildingButtons.BuyBattalionMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName] then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuyBattalionMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyBattalionUpdate_Orig_Interface = GUI_BuildingButtons.BuyBattalionUpdate;
    GUI_BuildingButtons.BuyBattalionUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuyBattalionUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverridePlaceField()
    GUI_BuildingButtons.PlaceFieldClicked_Orig_Interface = GUI_BuildingButtons.PlaceFieldClicked;
    GUI_BuildingButtons.PlaceFieldClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.PlaceFieldClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.PlaceFieldMouseOver_Orig_Interface = GUI_BuildingButtons.PlaceFieldMouseOver;
    GUI_BuildingButtons.PlaceFieldMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.PlaceFieldMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.PlaceFieldUpdate_Orig_Interface = GUI_BuildingButtons.PlaceFieldUpdate;
    GUI_BuildingButtons.PlaceFieldUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.PlaceFieldUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideStartFestival()
    GUI_BuildingButtons.StartFestivalClicked = function(_FestivalIndex)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local Costs = {Logic.GetFestivalCost(PlayerID, _FestivalIndex)};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if EntityID ~= Logic.GetMarketplace(PlayerID) then
                return;
            end
            if CanBuyBoolean == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartFestival(PlayerID, _FestivalIndex);
                StartEventMusic(MusicSystem.EventFestivalMusic, PlayerID);
                StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightSong);
                GUI.AddBuff(Buffs.Buff_Festival);
                API.BroadcastScriptCommand(QSB.ScriptCommands.StartRegularFestival, PlayerID);
            else
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartFestivalMouseOver_Orig_Interface = GUI_BuildingButtons.StartFestivalMouseOver;
    GUI_BuildingButtons.StartFestivalMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.StartFestivalMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartFestivalUpdate_Orig_Interface = GUI_BuildingButtons.StartFestivalUpdate;
    GUI_BuildingButtons.StartFestivalUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {4, 15});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.StartFestivalUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideStartTheatrePlay()
    GUI_BuildingButtons.StartTheatrePlayClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0);
            local Amount = Logic.GetMaxAmountOnStock(EntityID);
            local Costs = {GoodType, Amount};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if Logic.CanStartTheatrePlay(EntityID) == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartTheatrePlay(EntityID);
                API.BroadcastScriptCommand(QSB.ScriptCommands.StartTheatrePlay, PlayerID);
            elseif CanBuyBoolean == false then
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartTheatrePlayMouseOver_Orig_Interface = GUI_BuildingButtons.StartTheatrePlayMouseOver;
    GUI_BuildingButtons.StartTheatrePlayMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.StartTheatrePlayMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartTheatrePlayUpdate_Orig_Interface = GUI_BuildingButtons.StartTheatrePlayUpdate;
    GUI_BuildingButtons.StartTheatrePlayUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {16, 2});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.StartTheatrePlayUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideUpgradeTurret()
    GUI_BuildingButtons.UpgradeTurretClicked_Orig_Interface = GUI_BuildingButtons.UpgradeTurretClicked;
    GUI_BuildingButtons.UpgradeTurretClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.UpgradeTurretClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.UpgradeTurretMouseOver_Orig_Interface = GUI_BuildingButtons.UpgradeTurretMouseOver;
    GUI_BuildingButtons.UpgradeTurretMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.UpgradeTurretMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.UpgradeTurretUpdate_Orig_Interface = GUI_BuildingButtons.UpgradeTurretUpdate;
    GUI_BuildingButtons.UpgradeTurretUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.UpgradeTurretUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideBuySiegeEngineCart()
    GUI_BuildingButtons.BuySiegeEngineCartClicked_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartClicked;
    GUI_BuildingButtons.BuySiegeEngineCartClicked = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuySiegeEngineCartClicked_Orig_Interface(_EntityType);
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuySiegeEngineCartMouseOver_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartMouseOver;
    GUI_BuildingButtons.BuySiegeEngineCartMouseOver = function(_EntityType, _Right)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuySiegeEngineCartMouseOver_Orig_Interface(_EntityType, _Right);
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuySiegeEngineCartUpdate_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartUpdate;
    GUI_BuildingButtons.BuySiegeEngineCartUpdate = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            if WidgetName == "BuyBatteringRamCart" then
                SetIcon(WidgetID, {9, 2});
            elseif WidgetName == "BuySiegeTowerCart" then
                SetIcon(WidgetID, {9, 3});
            elseif WidgetName == "BuyCatapultCart" then
                SetIcon(WidgetID, {9, 1});
            end
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuySiegeEngineCartUpdate_Orig_Interface(_EntityType);
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideUpgradeBuilding()
    GUI_BuildingButtons.UpgradeClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local EntityID = GUI.GetSelectedEntity();
        if Logic.CanCancelUpgradeBuilding(EntityID) then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.CancelBuildingUpgrade(EntityID);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1);
            API.BroadcastScriptCommand(QSB.ScriptCommands.CancelBuildingUpgrade, EntityID, GUI.GetPlayerID());
            return;
        end
        local Costs = GUI_BuildingButtons.GetUpgradeCosts();
        local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
        if CanBuyBoolean == true then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.UpgradeBuilding(EntityID, nil);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightWisdom);
            if WidgetID ~= 0 then
                SaveButtonPressed(WidgetID);
            end
            API.BroadcastScriptCommand(QSB.ScriptCommands.StartBuildingUpgrade, EntityID, GUI.GetPlayerID());
        else
            Message(CanNotBuyString);
        end
    end
end

function ModuleBuildingButtons.Local:OverrideStartSermon()
    function GUI_BuildingButtons.StartSermonClicked()
        local PlayerID = GUI.GetPlayerID();
        if Logic.CanSermonBeActivated(PlayerID) then
            GUI.ActivateSermon(PlayerID);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightHealing);
            GUI.AddBuff(Buffs.Buff_Sermon);
            local CathedralID = Logic.GetCathedral(PlayerID);
            local x, y = Logic.GetEntityPosition(CathedralID);
            local z = 0;
            Sound.FXPlay3DSound("buildings\\building_start_sermon", x, y, z);
            API.BroadcastScriptCommand(QSB.ScriptCommands.StartSermon, GUI.GetPlayerID());
        end
    end
end

-- -------------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:InitBackupPositions()
    for k, v in pairs(self.BuildingButtons.Configuration) do
        local x, y = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k);
        self.BuildingButtons.Configuration[k].OriginalPosition = {x, y};
    end
end

function ModuleBuildingButtons.Local:GetButtonsForOverwrite(_ID, _Amount)
    local Buttons = {};
    local Type = Logic.GetEntityType(_ID);
    local TypeName = Logic.GetEntityTypeName(Type);
    for k, v in pairs(self.BuildingButtons.Configuration) do
        if #Buttons == _Amount then
            break;
        end
        if not TypeName:find(v.TypeExclusion) then
            table.insert(Buttons, k);
        end
    end
    assert(#Buttons == _Amount);
    table.sort(Buttons);
    return Buttons;
end

function ModuleBuildingButtons.Local:AddButtonBinding(_Type, _X, _Y, _ActionFunction, _TooltipController, _UpdateController)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    if #self.BuildingButtons.Bindings[_Type] < 6 then
        self.BuildingButtons.BindingCounter = self.BuildingButtons.BindingCounter +1;
        table.insert(self.BuildingButtons.Bindings[_Type], {
            ID       = self.BuildingButtons.BindingCounter,
            Position = {_X, _Y},
            Action   = _ActionFunction,
            Tooltip  = _TooltipController,
            Update   = _UpdateController,
        });
        return self.BuildingButtons.BindingCounter;
    end
    return 0;
end

function ModuleBuildingButtons.Local:RemoveButtonBinding(_Type, _ID)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    for i= #self.BuildingButtons.Bindings[_Type], 1, -1 do
        if self.BuildingButtons.Bindings[_Type][i].ID == _ID then
            table.remove(self.BuildingButtons.Bindings[_Type], i);
        end
    end
end

function ModuleBuildingButtons.Local:BindButtons(_ID)
    if _ID == nil or _ID == 0 or (Logic.IsBuilding(_ID) == 0 and not Logic.IsWall(_ID)) then
        return self:UnbindButtons();
    end
    local Name = Logic.GetEntityName(_ID);
    local Type = Logic.GetEntityType(_ID);

    local Key;
    if self.BuildingButtons.Bindings[Name] then
        Key = Name;
    end
    -- TODO: Proper inclusion of categories
    -- The problem is, that an entity might have more than one category. So this
    -- makes direct mapping impossible...
    if not Key and self.BuildingButtons.Bindings[Type] then
        Key = Type;
    end
    if not Key and self.BuildingButtons.Bindings[0] then
        Key = 0;
    end

    if Key then
        local ButtonNames = self:GetButtonsForOverwrite(_ID, #self.BuildingButtons.Bindings[Key]);
        local DefaultPositionIndex = 0;
        for i= 1, #self.BuildingButtons.Bindings[Key] do
            self.BuildingButtons.Configuration[ButtonNames[i]].Bind = self.BuildingButtons.Bindings[Key][i];
            XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/" ..ButtonNames[i], 1);
            XGUIEng.DisableButton("/InGame/Root/Normal/BuildingButtons/" ..ButtonNames[i], 0);
            local Position = self.BuildingButtons.Bindings[Key][i].Position;
            if not Position[1] or not Position[2] then
                local AnchorPosition = {12, 296};
                Position[1] = AnchorPosition[1] + (64 * DefaultPositionIndex);
                Position[2] = AnchorPosition[2];
                DefaultPositionIndex = DefaultPositionIndex +1;
            end
            XGUIEng.SetWidgetLocalPosition(
                "/InGame/Root/Normal/BuildingButtons/" ..ButtonNames[i],
                Position[1],
                Position[2]
            );
        end
    end
end

function ModuleBuildingButtons.Local:UnbindButtons()
    for k, v in pairs(self.BuildingButtons.Configuration) do
        local Position = self.BuildingButtons.Configuration[k].OriginalPosition;
        if Position then
            XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k, Position[1], Position[2]);
        end
        self.BuildingButtons.Configuration[k].Bind = nil;
    end
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleBuildingButtons);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Zusätzliche Buttons im Gebäudemenü platzieren.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(0) Benutzerschnittstelle</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field UpgradeStarted     Ein Ausbau wurde gestartet. (Parameter: EntityID, PlayerID)
-- @field UpgradeCanceled    Ein Ausbau wurde abgebrochen. (Parameter: EntityID, PlayerID)
-- @field FestivalStarted    Ein Fest wurde gestartet. (Parameter: PlayerID)
-- @field SermonStarted      Eine Predigt wurde gestartet. (Parameter: PlayerID)
-- @field TheatrePlayStarted Ein Schauspiel wurde abgebrochen. (Parameter: EntityID, PlayerID)
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

---
-- Fügt einen allgemeinen Gebäudeschalter an der Position hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion.
--
-- Die Position wird lokal zur linken oberen Ecke des Fensters angegeben.
--
-- @param[type=number]   _X       X-Position des Button
-- @param[type=number]   _Y       Y-Position des Button
-- @param[type=function] _Action  Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update  Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
--
-- @usage
-- SpecialButtonID = API.AddBuildingButton(
--     -- Position (X, Y)
--     230, 180,
--     -- Aktion
--     function(_WidgetID, _BuildingID)
--         GUI.AddNote("Hier passiert etwas!");
--     end,
--     -- Tooltip
--     function(_WidgetID, _BuildingID)
--         -- Es MUSS ein Kostentooltip verwendet werden.
--         API.SetTooltipCosts("Beschreibung", "Das ist die Beschreibung!");
--     end,
--     -- Update
--     function(_WidgetID, _BuildingID)
--         -- Ausblenden, wenn noch in Bau
--         if Logic.IsConstructionComplete(_BuildingID) == 0 then
--             XGUIEng.ShowWidget(_WidgetID, 0);
--             return;
--         end
--         -- Deaktivieren, wenn ausgebaut wird.
--         if Logic.IsBuildingBeingUpgraded(_BuildingID) then
--             XGUIEng.DisableButton(_WidgetID, 1);
--         end
--         SetIcon(_WidgetID, {1, 1});
--     end
-- );
--
function API.AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    return ModuleBuildingButtons.Local:AddButtonBinding(0, _X, _Y, _Action, _Tooltip, _Update);
end

---
-- Fügt einen allgemeinen Gebäudeschalter hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion.
--
-- @param[type=function] _Action  Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update  Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
--
-- @usage
-- SpecialButtonID = API.AddBuildingButton(
--     -- Aktion
--     function(_WidgetID, _BuildingID)
--         GUI.AddNote("Hier passiert etwas!");
--     end,
--     -- Tooltip
--     function(_WidgetID, _BuildingID)
--         -- Es MUSS ein Kostentooltip verwendet werden.
--         API.SetTooltipCosts("Beschreibung", "Das ist die Beschreibung!");
--     end,
--     -- Update
--     function(_WidgetID, _BuildingID)
--         -- Ausblenden, wenn noch in Bau
--         if Logic.IsConstructionComplete(_BuildingID) == 0 then
--             XGUIEng.ShowWidget(_WidgetID, 0);
--             return;
--         end
--         -- Deaktivieren, wenn ausgebaut wird.
--         if Logic.IsBuildingBeingUpgraded(_BuildingID) then
--             XGUIEng.DisableButton(_WidgetID, 1);
--         end
--         SetIcon(_WidgetID, {1, 1});
--     end
-- );
--
function API.AddBuildingButton(_Action, _Tooltip, _Update)
    return API.AddBuildingButtonAtPosition(nil, nil, _Action, _Tooltip, _Update);
end

---
-- Fügt einen Gebäudeschalter für den Entity-Typ hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion. Wenn ein Typ einen Button zugewiesen bekommt, werden alle 
-- allgemeinen Buttons für den Typ ignoriert.
--
-- @param[type=number]   _Type    Typ des Gebäudes
-- @param[type=number]   _X       X-Position des Button
-- @param[type=number]   _Y       Y-Position des Button
-- @param[type=function] _Action  Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update  Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
-- @see API.AddBuildingButton
--
function API.AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    return ModuleBuildingButtons.Local:AddButtonBinding(_Type, _X, _Y, _Action, _Tooltip, _Update);
end

---
-- Fügt einen Gebäudeschalter für den Entity-Typ hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion. Wenn ein Typ einen Button zugewiesen bekommt, werden alle 
-- allgemeinen Buttons für den Typ ignoriert.
--
-- @param[type=number]   _Type    Typ des Gebäudes
-- @param[type=function] _Action  Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update  Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
-- @see API.AddBuildingButton
--
function API.AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    return API.AddBuildingButtonByTypeAtPosition(_Type, nil, nil, _Action, _Tooltip, _Update);
end

---
-- Fügt einen Gebäudeschalter für das Entity hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion. Wenn ein Entity einen Button zugewiesen bekommt, werden
-- alle allgemeinen Buttons und alle Buttons für Typen für das Entity ignoriert.
--
-- @param[type=function] _ScriptName Scriptname des Entity
-- @param[type=number]   _X          X-Position des Button
-- @param[type=number]   _Y          Y-Position des Button
-- @param[type=function] _Action     Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip    Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update     Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
-- @see API.AddBuildingButton
--
function API.AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    return ModuleBuildingButtons.Local:AddButtonBinding(_ScriptName, _X, _Y, _Action, _Tooltip, _Update);
end

---
-- Fügt einen Gebäudeschalter für das Entity hinzu.
--
-- Einem Gebäude können maximal 6 Buttons zugewiesen werden! Auf diese Weise
-- hinzugefügte Buttons sind prinzipiell immer sichtbar, abhängig von ihrer
-- Update-Funktion. Wenn ein Entity einen Button zugewiesen bekommt, werden
-- alle allgemeinen Buttons und alle Buttons für Typen für das Entity ignoriert.
--
-- @param[type=function] _ScriptName Scriptname des Entity
-- @param[type=function] _Action     Funktion für die Aktion beim Klicken
-- @param[type=function] _Tooltip    Funktion für die angezeigte Beschreibung
-- @param[type=function] _Update     Funktion für Anzeige und Verfügbarkeit
-- @return[type=number] ID des Bindung
-- @within Anwenderfunktionen
-- @see API.AddBuildingButton
--
function API.AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    return API.AddBuildingButtonByEntityAtPosition(_ScriptName, nil, nil, _Action, _Tooltip, _Update);
end

---
-- Entfernt einen allgemeinen Gebäudeschalter.
--
-- @param[type=number] _ID ID des Bindung
-- @within Anwenderfunktionen
-- @usage
-- API.DropBuildingButton(SpecialButtonID);
--
function API.DropBuildingButton(_ID)
    return ModuleBuildingButtons.Local:RemoveButtonBinding(0, _ID);
end

---
-- Entfernt einen Gebäudeschalter vom Gebäudetypen.
--
-- @param[type=number] _Type Typ des Gebäudes
-- @param[type=number] _ID   ID des Bindung
-- @within Anwenderfunktionen
-- @usage
-- API.DropBuildingButtonFromType(Entities.B_Bakery, SpecialButtonID);
--
function API.DropBuildingButtonFromType(_Type, _ID)
    return ModuleBuildingButtons.Local:RemoveButtonBinding(_Type, _ID);
end

---
-- Entfernt einen Gebäudeschalter vom benannten Gebäude.
--
-- @param[type=string] _ScriptName Skriptname des Entity
-- @param[type=number] _ID         ID des Bindung
-- @within Anwenderfunktionen
-- @usage
-- API.DropBuildingButtonFromEntity("Bakery", SpecialButtonID);
--
function API.DropBuildingButtonFromEntity(_ScriptName, _ID)
    return ModuleBuildingButtons.Local:RemoveButtonBinding(_ScriptName, _ID);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleNpcInteraction = {
    Properties = {
        Name = "ModuleNpcInteraction",
    },

    Global = {
        Interactions = {},
        NPC = {},
        UseMarker = true,
    };
    Local  = {};
    -- This is a shared structure but the values are asynchronous!
    Shared = {
        Text = {
            StartConversation = {
                de = "Gespräch beginnen",
                en = "Start conversation",
                fr = "Commencer la conversation",
            }
        }
    };
};

QSB.Npc = {
    LastNpcEntityID = 0,
    LastHeroEntityID = 0,
}

-- Global Script ------------------------------------------------------------ --

function ModuleNpcInteraction.Global:OnGameStart()
    QSB.ScriptEvents.NpcInteraction = API.RegisterScriptEvent("Event_NpcInteraction");

    self:OverrideQuestFunctions();

    API.StartHiResJob(function()
        if Logic.GetTime() > 1 then
            ModuleNpcInteraction.Global:InteractionTriggerController();
        end
    end);
    API.StartJob(function()
        ModuleNpcInteraction.Global:InteractableMarkerController();
    end);
end

function ModuleNpcInteraction.Global:OnEvent(_ID, _Event, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.NpcInteraction then
        QSB.Npc.LastNpcEntityID = arg[1];
        QSB.Npc.LastHeroEntityID = arg[2];
        self.Interactions[arg[1]] = self.Interactions[arg[1]] or {};
        if self.Interactions[arg[1]][arg[2]] then
            if Logic.GetCurrentTurn() <= self.Interactions[arg[1]][arg[2]] + 5 then
                return;
            end
        end
        self.Interactions[arg[1]][arg[2]] = Logic.GetCurrentTurn();
        self:PerformNpcInteraction(arg[3]);
    end
end

function ModuleNpcInteraction.Global:CreateNpc(_Data)
    self.NPC[_Data.Name] = {
        Name              = _Data.Name,
        Active            = true,
        Type              = _Data.Type or 1,
        Player            = _Data.Player or {1, 2, 3, 4, 5, 6, 7, 8},
        WrongPlayerAction = _Data.WrongPlayerAction,
        Hero              = _Data.Hero,
        WrongHeroAction   = _Data.WrongHeroAction,
        Distance          = _Data.Distance or 350,
        Condition         = _Data.Condition,
        Callback          = _Data.Callback,
        UseMarker         = self.UseMarker == true,
        MarkerID          = 0
    }
    self:UpdateNpc(_Data);
    return self.NPC[_Data.Name];
end

function ModuleNpcInteraction.Global:DestroyNpc(_Data)
    _Data.Active = false;
    self:UpdateNpc(_Data);
    self:DestroyMarker(_Data.Name);
    self.NPC[_Data.Name] = nil;
end

function ModuleNpcInteraction.Global:GetNpc(_ScriptName)
    return self.NPC[_ScriptName];
end

function ModuleNpcInteraction.Global:UpdateNpc(_Data)
    if not IsExisting(_Data.Name) then
        return;
    end
    if not self.NPC[_Data.Name] then
        local EntityID = GetID(_Data.Name);
        Logic.SetOnScreenInformation(EntityID, 0);
        return;
    end
    for k, v in pairs(_Data) do
        self.NPC[_Data.Name][k] = v;
    end
    self:CreateMarker(_Data.Name);
    if self.NPC[_Data.Name].Active then
        local EntityID = GetID(_Data.Name);
        Logic.SetOnScreenInformation(EntityID, self.NPC[_Data.Name].Type);
    else
        local EntityID = GetID(_Data.Name);
        Logic.SetOnScreenInformation(EntityID, 0);
    end
end

function ModuleNpcInteraction.Global:PerformNpcInteraction(_PlayerID)
    local ScriptName = Logic.GetEntityName(QSB.Npc.LastNpcEntityID);
    if self.NPC[ScriptName] then
        local Data = self.NPC[ScriptName];
        self:RotateActorsToEachother(_PlayerID);
        self:AdjustHeroTalkingDistance(Data.Distance);

        if not self:InteractionIsAppropriatePlayer(ScriptName, _PlayerID, QSB.Npc.LastHeroEntityID) then
            return;
        end
        Data.TalkedTo = QSB.Npc.LastHeroEntityID;

        if not self:InteractionIsAppropriateHero(ScriptName) then
            return;
        end

        if Data.Condition == nil or Data:Condition(_PlayerID, QSB.Npc.LastHeroEntityID) then
            Data.Active = false;
            if Data.Callback then
                Data:Callback(_PlayerID, QSB.Npc.LastHeroEntityID);
            end
        else
            Data.TalkedTo = 0;
        end

        self:UpdateNpc(Data);
    end
end

function ModuleNpcInteraction.Global:InteractionIsAppropriatePlayer(_ScriptName, _PlayerID, _HeroID)
    local Appropriate = true;
    if self.NPC[_ScriptName] then
        local Data = self.NPC[_ScriptName];
        if Data.Player ~= nil then
            if type(Data.Player) == "table" then
                Appropriate = table.contains(Data.Player, _PlayerID);
            else
                Appropriate = Data.Player == _PlayerID;
            end

            if not Appropriate then
                local LastTime = (Data.WrongHeroTick or 0) +1;
                local CurrentTime = Logic.GetTime();
                if Data.WrongPlayerAction and LastTime < CurrentTime then
                    self.NPC[_ScriptName].LastWongPlayerTick = CurrentTime;
                    Data:WrongPlayerAction(_PlayerID);
                end
            end
        end
    end
    return Appropriate;
end

function ModuleNpcInteraction.Global:InteractionIsAppropriateHero(_ScriptName)
    local Appropriate = true;
    if self.NPC[_ScriptName] then
        local Data = self.NPC[_ScriptName];
        if Data.Hero ~= nil then
            if type(Data.Hero) == "table" then
                Appropriate = table.contains(Data.Hero, Logic.GetEntityName(QSB.Npc.LastHeroEntityID));
            end
            Appropriate = Data.Hero == Logic.GetEntityName(QSB.Npc.LastHeroEntityID);

            if not Appropriate then
                local LastTime = (Data.WrongHeroTick or 0) +1;
                local CurrentTime = Logic.GetTime();
                if Data.WrongHeroAction and LastTime < CurrentTime then
                    self.NPC[_ScriptName].WrongHeroTick = CurrentTime;
                    Data:WrongHeroAction(QSB.Npc.LastHeroEntityID);
                end
            end
        end
    end
    return Appropriate;
end

function ModuleNpcInteraction.Global:RotateActorsToEachother(_PlayerID)
    local PlayerKnights = {};
    Logic.GetKnights(_PlayerID, PlayerKnights);
    for k, v in pairs(PlayerKnights) do
        local Target = API.GetEntityMovementTarget(v);
        local x, y, z = Logic.EntityGetPos(QSB.Npc.LastNpcEntityID);
        if math.floor(Target.X) == math.floor(x) and math.floor(Target.Y) == math.floor(y) then
            x, y, z = Logic.EntityGetPos(v);
            Logic.MoveEntity(v, x, y);
            API.LookAt(v, QSB.Npc.LastNpcEntityID);
        end
    end
    API.LookAt(QSB.Npc.LastHeroEntityID, QSB.Npc.LastNpcEntityID);
    API.LookAt(QSB.Npc.LastNpcEntityID, QSB.Npc.LastHeroEntityID);
end

function ModuleNpcInteraction.Global:AdjustHeroTalkingDistance(_Distance)
    local Distance = _Distance * API.GetEntityScale(QSB.Npc.LastNpcEntityID);
    if API.GetDistance(QSB.Npc.LastHeroEntityID, QSB.Npc.LastNpcEntityID) <= Distance * 0.7 then
        local Orientation = Logic.GetEntityOrientation(QSB.Npc.LastNpcEntityID);
        local x1, y1, z1 = Logic.EntityGetPos(QSB.Npc.LastHeroEntityID);
        local x2 = x1 + ((Distance * 0.5) * math.cos(math.rad(Orientation)));
        local y2 = y1 + ((Distance * 0.5) * math.sin(math.rad(Orientation)));
        local ID = Logic.CreateEntityOnUnblockedLand(Entities.XD_ScriptEntity, x2, y2, 0, 0);
        local x3, y3, z3 = Logic.EntityGetPos(ID);
        Logic.MoveSettler(QSB.Npc.LastHeroEntityID, x3, y3);
        API.StartHiResJob( function(_HeroID, _NPCID, _Time)
            if Logic.GetTime() > _Time +0.5 and Logic.IsEntityMoving(_HeroID) == false then
                API.Confront(_HeroID, _NPCID);
                return true;
            end
        end, QSB.Npc.LastHeroEntityID, QSB.Npc.LastNpcEntityID, Logic.GetTime());
    end
end

function ModuleNpcInteraction.Global:OverrideQuestFunctions()
    GameCallback_OnNPCInteraction_Orig_QSB_ModuleNpcInteraction = GameCallback_OnNPCInteraction;
    GameCallback_OnNPCInteraction = function(_EntityID, _PlayerID, _KnightID)
        GameCallback_OnNPCInteraction_Orig_QSB_ModuleNpcInteraction(_EntityID, _PlayerID, _KnightID);

        local ClosestKnightID = _KnightID or ModuleNpcInteraction.Global:GetClosestKnight(_EntityID, _PlayerID);
        API.SendScriptEvent(QSB.ScriptEvents.NpcInteraction, _EntityID, ClosestKnightID, _PlayerID);
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.NpcInteraction, %d, %d, %d)]],
            _EntityID,
            ClosestKnightID,
            _PlayerID
        ));
    end

    QuestTemplate.RemoveQuestMarkers_Orig_ModuleNpcInteraction = QuestTemplate.RemoveQuestMarkers
    QuestTemplate.RemoveQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[1] ~= -65565 then
                    QuestTemplate.RemoveQuestMarkers_Orig_ModuleNpcInteraction(self);
                else
                    if self.Objectives[i].Data[4] then
                        API.NpcDispose(self.Objectives[i].Data[4].NpcInstance);
                        self.Objectives[i].Data[4].NpcInstance = nil;
                    end
                end
            else
                QuestTemplate.RemoveQuestMarkers_Orig_ModuleNpcInteraction(self);
            end
        end
    end

    QuestTemplate.ShowQuestMarkers_Orig_ModuleNpcInteraction = QuestTemplate.ShowQuestMarkers
    QuestTemplate.ShowQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[1] ~= -65565 then
                    QuestTemplate.ShowQuestMarkers_Orig_ModuleNpcInteraction(self);
                else
                    if not self.Objectives[i].Data[4].NpcInstance then
                        self.Objectives[i].Data[4].NpcInstance = API.NpcCompose {
                            Name   = self.Objectives[i].Data[3],
                            Hero   = self.Objectives[i].Data[2],
                            Player = self.ReceivingPlayer,
                        }
                    end
                end
            end
        end
    end

    QuestTemplate.IsObjectiveCompleted_Orig_ModuleNpcInteraction = QuestTemplate.IsObjectiveCompleted;
    QuestTemplate.IsObjectiveCompleted = function(self, objective)
        local objectiveType = objective.Type;
        local data = objective.Data;
        if objective.Completed ~= nil then
            return objective.Completed;
        end

        if objectiveType ~= Objective.Distance then
            return self:IsObjectiveCompleted_Orig_ModuleNpcInteraction(objective);
        else
            if data[1] == -65565 then
                if not IsExisting(data[3]) then
                    error(data[3].. " is dead! :(");
                    objective.Completed = false;
                else
                    if API.NpcTalkedTo(data[4].NpcInstance, data[2], self.ReceivingPlayer) then
                        objective.Completed = true;
                    end
                end
            else
                return self:IsObjectiveCompleted_Orig_ModuleNpcInteraction(objective);
            end
        end
    end
end

function ModuleNpcInteraction.Global:GetClosestKnight(_EntityID, _PlayerID)
    local KnightIDs = {};
    Logic.GetKnights(_PlayerID, KnightIDs);
    return API.GetClosestToTarget(_EntityID, KnightIDs);
end

function ModuleNpcInteraction.Global:ToggleMarkerUsage(_Flag)
    self.UseMarker = _Flag == true;
    for k, v in pairs(self.NPC) do
        self.NPC[k].UseMarker = _Flag == true;
        self:HideMarker(k);
    end
end

function ModuleNpcInteraction.Global:CreateMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        local x,y,z = Logic.EntityGetPos(GetID(_ScriptName));
        local MarkerID = Logic.CreateEntity(Entities.XD_ScriptEntity, x, y, 0, 0);
        DestroyEntity(self.NPC[_ScriptName].MarkerID);
        self.NPC[_ScriptName].MarkerID = MarkerID;
        self:HideMarker(_ScriptName);
    end
end

function ModuleNpcInteraction.Global:DestroyMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        DestroyEntity(self.NPC[_ScriptName].MarkerID);
        self.NPC[_ScriptName].MarkerID = 0;
    end
end

function ModuleNpcInteraction.Global:HideMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        if IsExisting(self.NPC[_ScriptName].MarkerID) then
            Logic.SetModel(self.NPC[_ScriptName].MarkerID, Models.Effects_E_NullFX);
            Logic.SetVisible(self.NPC[_ScriptName].MarkerID, false);
        end
    end
end

function ModuleNpcInteraction.Global:ShowMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        if self.NPC[_ScriptName].UseMarker == true and IsExisting(self.NPC[_ScriptName].MarkerID) then
            local Size = API.GetEntityScale(_ScriptName);
            API.SetEntityScale(self.NPC[_ScriptName].MarkerID, Size);
            Logic.SetModel(self.NPC[_ScriptName].MarkerID, Models.Effects_E_Wealth);
            Logic.SetVisible(self.NPC[_ScriptName].MarkerID, true);
        end
    end
end

function ModuleNpcInteraction.Global:InteractionTriggerController()
    for PlayerID = 1, 8, 1 do
        local PlayersKnights = {};
        Logic.GetKnights(PlayerID, PlayersKnights);
        for i= 1, #PlayersKnights, 1 do
            if Logic.GetCurrentTaskList(PlayersKnights[i]) == "TL_NPC_INTERACTION" then
                local x1, y1 = Logic.EntityGetPos(PlayersKnights[i]);
                for k, v in pairs(self.NPC) do
                    if v.Distance >= 350 then
                        local Target = API.GetEntityMovementTarget(PlayersKnights[i]);
                        local x2, y2 = Logic.EntityGetPos(GetID(k));
                        if math.floor(Target.X) == math.floor(x2) and math.floor(Target.Y) == math.floor(y2) then
                            if IsExisting(k) and IsNear(PlayersKnights[i], k, v.Distance) then
                                GameCallback_OnNPCInteraction(GetID(k), PlayerID, PlayersKnights[i]);
                                return;
                            end
                        end
                    end
                end
            end
        end
    end
end

function ModuleNpcInteraction.Global:InteractableMarkerController()
    for k, v in pairs(self.NPC) do
        if v.Active then
            if v.UseMarker and IsExisting(v.MarkerID) and API.IsEntityVisible(v.MarkerID) then
                self:HideMarker(k);
            else
                self:ShowMarker(k);
            end
            local x1,y1,z1 = Logic.EntityGetPos(v.MarkerID);
            local x2,y2,z2 = Logic.EntityGetPos(GetID(k));
            if math.abs(x1-x2) > 20 or math.abs(y1-y2) > 20 then
                Logic.DEBUG_SetPosition(v.MarkerID, x2, y2);
            end
        end
    end
end

-- Local Script ------------------------------------------------------------- --

function ModuleNpcInteraction.Local:OnGameStart()
    QSB.ScriptEvents.NpcInteraction = API.RegisterScriptEvent("Event_NpcInteraction");

    self:OverrideQuestFunctions();
end

function ModuleNpcInteraction.Local:OnEvent(_ID, _Event, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.NpcInteraction then
        QSB.Npc.LastNpcEntityID = arg[1];
        QSB.Npc.LastHeroEntityID = arg[2];
    end
end

function ModuleNpcInteraction.Local:OverrideQuestFunctions()
    GUI_Interaction.DisplayQuestObjective_Orig_ModuleNpcInteraction = GUI_Interaction.DisplayQuestObjective
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local QuestIndexTemp = tonumber(_QuestIndex);
        if QuestIndexTemp then
            _QuestIndex = QuestIndexTemp;
        end

        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives";
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0);
        local QuestObjectiveContainer;
        local QuestTypeCaption;

        g_CurrentDisplayedQuestID = _QuestIndex;

        if QuestType == Objective.Distance then
            QuestObjectiveContainer = QuestObjectivesPath .. "/List";
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestInteraction");
            local ObjectList = {};

            if Quest.Objectives[1].Data[1] == -65565 then
                QuestObjectiveContainer = QuestObjectivesPath .. "/Distance";
                QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestMoveHere");
                SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{7,10});

                local MoverEntityID = GetID(Quest.Objectives[1].Data[2]);
                local MoverEntityType = Logic.GetEntityType(MoverEntityID);
                local MoverIcon = g_TexturePositions.Entities[MoverEntityType];
                if not MoverIcon then
                    MoverIcon = {7, 9};
                end
                SetIcon(QuestObjectiveContainer .. "/IconMover", MoverIcon);

                local TargetEntityID = GetID(Quest.Objectives[1].Data[3]);
                local TargetEntityType = Logic.GetEntityType(TargetEntityID);
                local TargetIcon = g_TexturePositions.Entities[TargetEntityType];
                if not TargetIcon then
                    TargetIcon = {14, 10};
                end

                local IconWidget = QuestObjectiveContainer .. "/IconTarget";
                local ColorWidget = QuestObjectiveContainer .. "/TargetPlayerColor";

                SetIcon(IconWidget, TargetIcon);
                XGUIEng.SetMaterialColor(ColorWidget, 0, 255, 255, 255, 0);

                SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{16,12});
                local caption = ModuleNpcInteraction.Shared.Text.StartConversation;
                QuestTypeCaption = API.Localize(caption);

                XGUIEng.SetText(QuestObjectiveContainer.."/Caption","{center}"..QuestTypeCaption);
                XGUIEng.ShowWidget(QuestObjectiveContainer, 1);
            else
                GUI_Interaction.DisplayQuestObjective_Orig_ModuleNpcInteraction(_QuestIndex, _MessageKey);
            end
        else
            GUI_Interaction.DisplayQuestObjective_Orig_ModuleNpcInteraction(_QuestIndex, _MessageKey);
        end
    end

    GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_ModuleNpcInteraction = GUI_Interaction.GetEntitiesOrTerritoryListForQuest
    GUI_Interaction.GetEntitiesOrTerritoryListForQuest = function( _Quest, _QuestType )
        local EntityOrTerritoryList = {}
        local IsEntity = true

        if _QuestType == Objective.Distance then
            if _Quest.Objectives[1].Data[1] == -65565 then
                local Entity = GetID(_Quest.Objectives[1].Data[3]);
                table.insert(EntityOrTerritoryList, Entity);
            else
                return GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_ModuleNpcInteraction(_Quest, _QuestType);
            end

        else
            return GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_ModuleNpcInteraction(_Quest, _QuestType);
        end
        return EntityOrTerritoryList, IsEntity
    end
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleNpcInteraction);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Dieses Modul erlaubt NPC-Charaktere interaktiv zu machen.
--
-- Ein NPC ist ein Charakter, der durch den Helden eines Spielers angesprochen
-- werden kann. Auf das Ansprechen kann eine beliebige Aktion folgen. Mittels
-- einer Bedingung kann festgelegt werden, wer mit dem NPC sprechen kann und
-- unter welchen Umständen es nicht möglich ist.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(1) Benutzerschnittstelle</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field NpcInteraction  (Parameter: NpcEntityID, HeroEntityID)
--
-- @within Event
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

---
-- Erstellt einen neuen NPC für den angegebenen Siedler.
--
-- Mögliche Einstellungen für den NPC:
-- <table border="1">
-- <tr>
-- <th><b>Eigenschaft</b></th>
-- <th><b>Beschreibung</b></th>
-- </tr>
-- <tr>
-- <td>Name</td>
-- <td>(string) Skriptname des NPC. Dieses Attribut wird immer benötigt!</td>
-- </tr>
-- <tr>
-- <td>Type</td>
-- <td>(number) Typ des NPC. Zahl zwischen 1 und 4 möglich. Bestimmt, falls
-- vorhanden, den Anzeigemodus des NPC Icon.</td>
-- </tr>
-- <tr>
-- <td>Condition</td>
-- <td>(function) Bedingung, um die Konversation auszuführen. Muss boolean zurückgeben.</td>
-- </tr>
-- <tr>
-- <td>Callback</td>
-- <td>(function) Funktion, die bei erfolgreicher Aktivierung ausgeführt wird.</td>
-- </tr>
-- <tr>
-- <td>Player</td>
-- <td>(number|table) Spieler, der/die mit dem NPC sprechen kann/können.</td>
-- </tr>
-- <tr>
-- <td>WrongPlayerAction</td>
-- <td>(function) Funktion, die für einen falschen Spieler ausgeführt wird.</td>
-- </tr>
-- <tr>
-- <td>Hero</td>
-- <td>(string) Skriptnamen von Helden, die mit dem NPC sprechen können.</td>
-- </tr>
-- <tr>
-- <td>WrongHeroAction</td>
-- <td>(function) Funktion, die für einen falschen Helden ausgeführt wird.</td>
-- </tr>
-- </table>
--
-- @param[type=table]  _Data Definition des NPC
-- @return[type=table] NPC Table
-- @within Anwenderfunktionen
--
-- @usage
-- -- Beispiel #1: Einfachen NPC erstellen
-- MyNpc = API.NpcCompose {
--     Name     = "HansWurst",
--     Callback = function(_Data)
--         local HeroID = QSB.LastHeroEntityID;
--         local NpcID = GetID(_Data.Name);
--         -- mach was tolles
--     end
-- }
--
-- @usage
-- -- Beispiel #2: NPC mit Bedingung erstellen
-- MyNpc = API.NpcCompose {
--     Name      = "HansWurst",
--     Condition = function(_Data)
--         local NpcID = GetID(_Data.Name);
--         -- prüfe irgend was
--         return MyConditon == true;
--     end
--     Callback  = function(_Data)
--         local HeroID = QSB.LastHeroEntityID;
--         local NpcID = GetID(_Data.Name);
--         -- mach was tolles
--     end
-- }
--
-- @usage
-- -- Beispiel #3: NPC auf Spieler beschränken
-- MyNpc = API.NpcCompose {
--     Name              = "HansWurst",
--     Player            = {1, 2},
--     WrongPlayerAction = function(_Data)
--         API.Note("Ich rede nicht mit Euch!");
--     end,
--     Callback          = function(_Data)
--         local HeroID = QSB.LastHeroEntityID;
--         local NpcID = GetID(_Data.Name);
--         -- mach was tolles
--     end
-- }
--
function API.NpcCompose(_Data)
    if GUI or not type(_Data) == "table" or not _Data.Name then
        return;
    end
    if not IsExisting(_Data.Name) then
        error("API.NpcCompose: '" .._Data.Name.. "' NPC does not exist!");
        return;
    end
    local Npc = ModuleNpcInteraction.Global:GetNpc(_Data.Name);
    if Npc ~= nil and Npc.Active then
        error("API.NpcCompose: '" .._Data.Name.. "' is already composed as NPC!");
        return;
    end
    if _Data.Type and (not type(_Data.Type) == "number" or (_Data.Type < 1 or _Data.Type > 4)) then
        error("API.NpcCompose: Type must be a value between 1 and 4!");
        return;
    end
    return ModuleNpcInteraction.Global:CreateNpc(_Data);
end

---
-- Entfernt den NPC komplett vom Entity. Das Entity bleibt dabei erhalten.
--
-- @param[type=table] _Data NPC Table
-- @within Anwenderfunktionen
-- @usage
-- API.NpcDispose(MyNpc);
--
function API.NpcDispose(_Data)
    if GUI then
        return;
    end
    if not IsExisting(_Data.Name) then
        error("API.NpcDispose: '" .._Data.Name.. "' NPC does not exist!");
        return;
    end
    if ModuleNpcInteraction.Global:GetNpc(_Data.Name) ~= nil then
        error("API.NpcDispose: '" .._Data.Name.. "' NPC must first be composed!");
        return;
    end

    ModuleNpcInteraction.Global:DestroyNpc(_Data);
end

---
-- Aktualisiert die Daten des NPC.
--
-- Mögliche Einstellungen für den NPC:
-- <table border="1">
-- <tr>
-- <th><b>Eigenschaft</b></th>
-- <th><b>Beschreibung</b></th>
-- </tr>
-- <tr>
-- <td>Name</td>
-- <td>(string) Skriptname des NPC. Dieses Attribut wird immer benötigt!</td>
-- </tr>
-- <tr>
-- <td>Type</td>
-- <td>(number) Typ des NPC. Zahl zwischen 1 und 4 möglich. Bestimmt, falls
-- vorhanden, den Anzeigemodus des NPC Icon.</td>
-- </tr>
-- <tr>
-- <td>Condition</td>
-- <td>(function) Bedingung, um die Konversation auszuführen. Muss boolean zurückgeben.</td>
-- </tr>
-- <tr>
-- <td>Callback</td>
-- <td>(function) Funktion, die bei erfolgreicher Aktivierung ausgeführt wird.</td>
-- </tr>
-- <tr>
-- <td>Player</td>
-- <td>(number) Spieler, die mit dem NPC sprechen können.</td>
-- </tr>
-- <tr>
-- <td>WrongPlayerAction</td>
-- <td>(function) Funktion, die für einen falschen Spieler ausgeführt wird.</td>
-- </tr>
-- <tr>
-- <td>Hero</td>
-- <td>(string) Skriptnamen von Helden, die mit dem NPC sprechen können.</td>
-- </tr>
-- <tr>
-- <td>WrongHeroAction</td>
-- <td>(function) Funktion, die für einen falschen Helden ausgeführt wird.</td>
-- </tr>
-- <tr>
-- <td>Active</td>
-- <td>(boolean) Steuert, ob der NPC aktiv ist.</td>
-- </tr>
-- </table>
--
-- @param[type=table] _Data NPC Table
-- @within Anwenderfunktionen
-- @usage
-- -- Einen NPC wieder aktivieren
-- MyNpc.Active = true;
-- MyNpc.TalkedTo = 0;
-- -- Die Aktion ändern
-- MyNpc.Callback = function(_Data)
--     -- mach was hier
-- end;
-- API.NpcUpdate(MyNpc);
--
function API.NpcUpdate(_Data)
    if GUI then
        return;
    end
    if not IsExisting(_Data.Name) then
        error("API.NpcUpdate: '" .._Data.Name.. "' NPC does not exist!");
        return;
    end
    if ModuleNpcInteraction.Global:GetNpc(_Data.Name) == nil then
        error("API.NpcUpdate: '" .._Data.Name.. "' NPC must first be composed!");
        return;
    end

    ModuleNpcInteraction.Global:UpdateNpc(_Data);
end

---
-- Prüft, ob der NPC gerade aktiv ist.
--
-- @param[type=table] _Data NPC Table
-- @return[type=boolean] NPC ist aktiv
-- @within Anwenderfunktionen
-- @usage
-- if API.NpcIsActive(MyNpc) then
--
function API.NpcIsActive(_Data)
    if GUI then
        return;
    end
    if not IsExisting(_Data.Name) then
        error("API.NpcIsActive: '" .._Data.Name.. "' NPC does not exist!");
        return;
    end
    local NPC = ModuleNpcInteraction.Global:GetNpc(_Data.Name);
    if NPC == nil then
        error("API.NpcIsActive: '" .._Data.Name.. "' NPC must first be composed!");
        return;
    end

    return NPC.Active == true and API.IsEntityActiveNpc(_Data.Name);
end

---
-- Prüft, ob ein NPC schon gesprochen hat und optional auch mit wem.
--
-- @param[type=table]  _Data     NPC Table
-- @param[type=string] _Hero     (Optional) Skriptname des Helden
-- @param[type=number] _PlayerID (Optional) Spieler ID
-- @within Anwenderfunktionen
-- 
-- @usage
-- -- Beispiel #1: Wurde mit NPC gesprochen
-- if API.NpcTalkedTo(MyNpc) then
-- 
-- @usage
-- -- Beispiel #2: Spieler hat mit NPC gesprochen
-- if API.NpcTalkedTo(MyNpc, nil, 1) then
-- 
-- @usage
-- -- Beispiel #3: Held des Spielers hat mit NPC gesprochen
-- if API.NpcTalkedTo(MyNpc, "Marcus", 1) then
--
function API.NpcTalkedTo(_Data, _Hero, _PlayerID)
    if GUI then
        return;
    end
    if not IsExisting(_Data.Name) then
        error("API.NpcTalkedTo: '" .._Data.Name.. "' NPC does not exist!");
        return;
    end
    if ModuleNpcInteraction.Global:GetNpc(_Data.Name) == nil then
        error("API.NpcTalkedTo: '" .._Data.Name.. "' NPC must first be composed!");
        return;
    end

    local NPC = ModuleNpcInteraction.Global:GetNpc(_Data.Name);
    local TalkedTo = NPC.TalkedTo ~= nil and NPC.TalkedTo ~= 0;
    if _Hero and TalkedTo then
        TalkedTo = NPC.TalkedTo == GetID(_Hero);
    end
    if _PlayerID and TalkedTo then
        TalkedTo = Logic.EntityGetPlayer(NPC.TalkedTo) == _PlayerID;
    end
    return TalkedTo;
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

--
-- Stellt neue Behavior für NPC.
--

---
-- Der Held muss einen Nichtspielercharakter ansprechen.
--
-- Es wird automatisch ein NPC erzeugt und überwacht, sobald der Quest
-- aktiviert wurde. Ein NPC darf nicht auf geblocktem Gebiet stehen oder
-- seine Enity-ID verändern.
--
-- <b>Hinweis</b>: Jeder Siedler kann zu jedem Zeitpunkt nur <u>einen</u> NPC 
-- haben. Wird ein weiterer NPC zugewiesen, wird der alte überschrieben und
-- der verknüpfte Quest funktioniert nicht mehr!
--
-- @param[type=string] _NpcName  Skriptname des NPC
-- @param[type=string] _HeroName (optional) Skriptname des Helden
-- @within Goal
--
function Goal_NPC(...)
    return B_Goal_NPC:new(...);
end

B_Goal_NPC = {
    Name             = "Goal_NPC",
    Description     = {
        en = "Goal: The hero has to talk to a non-player character.",
        de = "Ziel: Der Held muss einen Nichtspielercharakter ansprechen.",
        fr = "Objectif: le héros doit interpeller un personnage non joueur.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "NPC",  de = "NPC",  fr = "NPC" },
        { ParameterType.ScriptName, en = "Hero", de = "Held", fr = "Héro" },
    },
}

function B_Goal_NPC:GetGoalTable()
    return {Objective.Distance, -65565, self.Hero, self.NPC, self}
end

function B_Goal_NPC:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.NPC = _Parameter
    elseif (_Index == 1) then
        self.Hero = _Parameter
        if self.Hero == "-" then
            self.Hero = nil
        end
   end
end

function B_Goal_NPC:GetIcon()
    return {14,10}
end

Revision:RegisterBehavior(B_Goal_NPC);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleObjectInteraction = {
    Properties = {
        Name = "ModuleObjectInteraction",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {
        SlaveSequence = 0,
    };
    Local  = {};

    Shared = {
        Text = {}
    };
};

QSB.IO = {
    LastHeroEntityID = 0,
    LastObjectEntityID = 0
};

-- Global Script ------------------------------------------------------------ --

function ModuleObjectInteraction.Global:OnGameStart()
    QSB.ScriptEvents.ObjectClicked = API.RegisterScriptEvent("Event_ObjectClicked");
    QSB.ScriptEvents.ObjectInteraction = API.RegisterScriptEvent("Event_ObjectInteraction");
    QSB.ScriptEvents.ObjectReset = API.RegisterScriptEvent("Event_ObjectReset");
    QSB.ScriptEvents.ObjectDelete = API.RegisterScriptEvent("Event_ObjectDelete");

    IO = {};
    IO_UserDefindedNames = {};
    IO_SlaveToMaster = {};
    IO_SlaveState = {};

    self:OverrideObjectInteraction();
    self:StartObjectDestructionController();
    self:StartObjectConditionController();
    self:CreateDefaultObjectNames();
end

function ModuleObjectInteraction.Global:OnEvent(_ID, _Event, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.ObjectInteraction then
        self:OnObjectInteraction(arg[1], arg[2], arg[3]);
    elseif _ID == QSB.ScriptEvents.ChatClosed then
        if arg[3] then
            self:ProcessChatInput(arg[1]);
        end
    end
end

function ModuleObjectInteraction.Global:OnObjectInteraction(_ScriptName, _KnightID, _PlayerID)
    QSB.IO.LastObjectEntityID = GetID(_ScriptName);
    QSB.IO.LastHeroEntityID = _KnightID;

    if IO_SlaveToMaster[_ScriptName] then
        _ScriptName = IO_SlaveToMaster[_ScriptName];
    end
    if IO[_ScriptName] then
        IO[_ScriptName].IsUsed = true;
        Logic.ExecuteInLuaLocalState(string.format(
            [[
                local ScriptName = "%s"
                if IO[ScriptName] then
                    IO[ScriptName].IsUsed = true
                end
            ]],
            _ScriptName
        ));
        if IO[_ScriptName].Action then
            IO[_ScriptName]:Action(_PlayerID, _KnightID);
        end
    end
end

function ModuleObjectInteraction.Global:CreateObject(_Description)
    local ID = GetID(_Description.Name);
    if ID == 0 then
        return;
    end
    self:DestroyObject(_Description.Name);

    local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(ID));
    if TypeName and not TypeName:find("^I_X_") then
        self:CreateSlaveObject(_Description);
    end

    _Description.IsActive = true;
    _Description.IsUsed = false;
    _Description.Player = _Description.Player or {1, 2, 3, 4, 5, 6, 7, 8};
    IO[_Description.Name] = _Description;
    Logic.ExecuteInLuaLocalState(string.format(
        [[IO["%s"] = %s]],
        _Description.Name,
        table.tostring(IO[_Description.Name])
    ));
    self:SetupObject(_Description);
    return _Description;
end

function ModuleObjectInteraction.Global:DestroyObject(_ScriptName)
    if not IO[_ScriptName] then
        return;
    end
    if IO[_ScriptName].Slave then
        IO_SlaveToMaster[IO[_ScriptName].Slave] = nil;
        Logic.ExecuteInLuaLocalState(string.format(
            [[IO_SlaveToMaster["%s"] = nil]],
            IO[_ScriptName].Slave
        ));
        IO_SlaveState[IO[_ScriptName].Slave] = nil;
        DestroyEntity(IO[_ScriptName].Slave);
    end
    self:SetObjectState(_ScriptName, 2);
    API.SendScriptEvent(QSB.ScriptEvents.ObjectDelete, _ScriptName);
    Logic.ExecuteInLuaLocalState(string.format(
        [[
            local ScriptName = "%s"
            API.SendScriptEvent(QSB.ScriptEvents.ObjectDelete, ScriptName)
            IO[ScriptName] = nil
        ]],
        _ScriptName
    ));
    IO[_ScriptName] = nil;
end

function ModuleObjectInteraction.Global:CreateSlaveObject(_Object)
    local Name;
    for k, v in pairs(IO_SlaveToMaster) do
        if v == _Object.Name and IsExisting(k) then
            Name = k;
        end
    end
    if Name == nil then
        self.SlaveSequence = self.SlaveSequence +1;
        Name = "QSB_SlaveObject_" ..self.SlaveSequence;
    end

    local SlaveID = GetID(Name);
    if not IsExisting(Name) then
        local x,y,z = Logic.EntityGetPos(GetID(_Object.Name));
        SlaveID = Logic.CreateEntity(Entities.I_X_DragonBoatWreckage, x, y, 0, 0);
        Logic.SetModel(SlaveID, Models.Effects_E_Mosquitos);
        Logic.SetEntityName(SlaveID, Name);
        IO_SlaveToMaster[Name] = _Object.Name;
        Logic.ExecuteInLuaLocalState(string.format(
            [[IO_SlaveToMaster["%s"] = "%s"]],
            Name,
            _Object.Name
        ));
        _Object.Slave = Name;
    end
    IO_SlaveState[Name] = 1;
    return SlaveID;
end

function ModuleObjectInteraction.Global:SetupObject(_Object)
    local ID = GetID((_Object.Slave and _Object.Slave) or _Object.Name);
    Logic.InteractiveObjectClearCosts(ID);
    Logic.InteractiveObjectClearRewards(ID);
    Logic.InteractiveObjectSetInteractionDistance(ID, _Object.Distance);
    Logic.InteractiveObjectSetTimeToOpen(ID, _Object.Waittime);

    local RewardResourceCart = _Object.RewardResourceCartType or Entities.U_ResourceMerchant;
    Logic.InteractiveObjectSetRewardResourceCartType(ID, RewardResourceCart);
    local RewardGoldCart = _Object.RewardGoldCartType or Entities.U_GoldCart;
    Logic.InteractiveObjectSetRewardGoldCartType(ID, RewardGoldCart);
    local CostResourceCart = _Object.CostResourceCartType or Entities.U_ResourceMerchant;
    Logic.InteractiveObjectSetCostResourceCartType(ID, CostResourceCart);
    local CostGoldCart = _Object.CostGoldCartType or Entities.U_GoldCart;
    Logic.InteractiveObjectSetCostGoldCartType(ID, CostGoldCart);

    if GetNameOfKeyInTable(Entities, _Object.Replacement) then
        Logic.InteractiveObjectSetReplacingEntityType(ID, _Object.Replacement);
    end
    if _Object.Reward then
        Logic.InteractiveObjectAddRewards(ID, _Object.Reward[1], _Object.Reward[2]);
    end
    if _Object.Costs and _Object.Costs[1] then
        Logic.InteractiveObjectAddCosts(ID, _Object.Costs[1], _Object.Costs[2]);
    end
    if _Object.Costs and _Object.Costs[3] then
        Logic.InteractiveObjectAddCosts(ID, _Object.Costs[3], _Object.Costs[4]);
    end
    table.insert(HiddenTreasures, ID);
    API.InteractiveObjectActivate(Logic.GetEntityName(ID), _Object.State or 0);
end

function ModuleObjectInteraction.Global:ResetObject(_ScriptName)
    local ID = GetID((IO[_ScriptName].Slave and IO[_ScriptName].Slave) or _ScriptName);
    RemoveInteractiveObjectFromOpenedList(ID);
    table.insert(HiddenTreasures, ID);
    Logic.InteractiveObjectSetAvailability(ID, true);
    self:SetObjectState(ID, IO[_ScriptName].State or 0);
    IO[_ScriptName].IsUsed = false;
    IO[_ScriptName].IsActive = true;

    API.SendScriptEvent(QSB.ScriptEvents.ObjectReset, _ScriptName);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.ObjectReset, "%s")]],
        _ScriptName
    ));
end

function ModuleObjectInteraction.Global:SetObjectState(_ScriptName, _State, ...)
    arg = ((not arg or #arg == 0) and {1, 2, 3, 4, 5, 6, 7, 8}) or arg;
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, 2);
    end
    for i= 1, #arg, 1 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), arg[i], _State);
    end
    Logic.InteractiveObjectSetAvailability(GetID(_ScriptName), _State ~= 2);
end

function ModuleObjectInteraction.Global:CreateDefaultObjectNames()
    IO_UserDefindedNames["D_X_ChestClosed"]    = {
        de = "Schatztruhe",
        en = "Treasure Chest",
        fr = "Coffre au Trésor"
    };
    IO_UserDefindedNames["D_X_ChestOpenEmpty"] = {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    };

    Logic.ExecuteInLuaLocalState(string.format(
        [[IO_UserDefindedNames = %s]],
        table.tostring(IO_UserDefindedNames)
    ));
end

function ModuleObjectInteraction.Global:OverrideObjectInteraction()
    GameCallback_OnObjectInteraction = function(_EntityID, _PlayerID)
        OnInteractiveObjectOpened(_EntityID, _PlayerID);
        OnTreasureFound(_EntityID, _PlayerID);

        local ScriptName = Logic.GetEntityName(_EntityID);
        if IO_SlaveToMaster[ScriptName] then
            ScriptName = IO_SlaveToMaster[ScriptName];
        end
        local KnightIDs = {};
        Logic.GetKnights(_PlayerID, KnightIDs);
        local KnightID = API.GetClosestToTarget(_EntityID, KnightIDs);
        API.SendScriptEvent(QSB.ScriptEvents.ObjectInteraction, ScriptName, KnightID, _PlayerID);
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.ObjectInteraction, "%s", %d, %d)]],
            ScriptName,
            KnightID,
            _PlayerID
        ));
    end

    QuestTemplate.AreObjectsActivated = function(self, _ObjectList)
        for i=1, _ObjectList[0] do
            if not _ObjectList[-i] then
                _ObjectList[-i] = GetID(_ObjectList[i]);
            end
            local EntityName = Logic.GetEntityName(_ObjectList[-i]);
            if IO_SlaveToMaster[EntityName] then
                EntityName = IO_SlaveToMaster[EntityName];
            end

            if IO[EntityName] then
                if IO[EntityName].IsUsed ~= true then
                    return false;
                end
            elseif Logic.IsInteractiveObject(_ObjectList[-i]) then
                if not IsInteractiveObjectOpen(_ObjectList[-i]) then
                    return false;
                end
            end
        end
        return true;
    end
end

function ModuleObjectInteraction.Global:ProcessChatInput(_Text)
    local Commands = Revision.Text:CommandTokenizer(_Text);
    for i= 1, #Commands, 1 do
        if Commands[1] == "enableobject" then
            local State = (Commands[3] and tonumber(Commands[3])) or nil;
            local PlayerID = (Commands[4] and tonumber(Commands[4])) or nil;
            if not IsExisting(Commands[2]) then
                error("object " ..Commands[2].. " does not exist!");
                return;
            end
            API.InteractiveObjectActivate(Commands[2], State, PlayerID);
            info("activated object " ..Commands[2].. ".");
        elseif Commands[1] == "disableobject" then
            local PlayerID = (Commands[3] and tonumber(Commands[3])) or nil;
            if not IsExisting(Commands[2]) then
                error("object " ..Commands[2].. " does not exist!");
                return;
            end
            API.InteractiveObjectDeactivate(Commands[2], PlayerID);
            info("deactivated object " ..Commands[2].. ".");
        elseif Commands[1] == "initobject" then
            if not IsExisting(Commands[2]) then
                error("object " ..Commands[2].. " does not exist!");
                return;
            end
            API.SetupObject({
                Name     = Commands[2],
                Waittime = 0,
                State    = 0
            });
            info("quick initalization of object " ..Commands[2].. ".");
        end
    end
end

function ModuleObjectInteraction.Global:StartObjectDestructionController()
    API.StartJobByEventType(Events.LOGIC_EVENT_ENTITY_DESTROYED, function()
        local DestryoedEntityID = Event.GetEntityID();
        local SlaveName  = Logic.GetEntityName(DestryoedEntityID);
        local MasterName = IO_SlaveToMaster[SlaveName];
        if SlaveName and MasterName then
            local Object = IO[MasterName];
            if not Object then
                return;
            end
            info("slave " ..SlaveName.. " of master " ..MasterName.. " has been deleted!");
            info("try to create new slave...");
            IO_SlaveToMaster[SlaveName] = nil;
            Logic.ExecuteInLuaLocalState(string.format(
                [[IO_SlaveToMaster["%s"] = nil]],
                SlaveName
            ));
            local SlaveID = ModuleObjectInteraction.Global:CreateSlaveObject(Object);
            if not IsExisting(SlaveID) then
                error("failed to create slave!");
                return;
            end
            ModuleObjectInteraction.Global:SetupObject(Object);
            if Object.IsUsed == true or (IO_SlaveState[SlaveName] and IO_SlaveState[SlaveName] == 0) then
                API.InteractiveObjectDeactivate(Object.Slave);
            end
            info("new slave created for master " ..MasterName.. ".");
        end
    end);
end

function ModuleObjectInteraction.Global:StartObjectConditionController()
    API.StartHiResJob(function()
        for k, v in pairs(IO) do
            if v and not v.IsUsed and v.IsActive then
                IO[k].IsFullfilled = true;
                if IO[k].Condition then
                    local IsFulfulled = v:Condition();
                    IO[k].IsFullfilled = IsFulfulled;
                end
                Logic.ExecuteInLuaLocalState(string.format(
                    [[
                        local ScriptName = "%s"
                        if IO[ScriptName] then
                            IO[ScriptName].IsFullfilled = %s
                        end
                    ]],
                    k,
                    tostring(IO[k].IsFullfilled)
                ))
            end
        end
    end);
end

-- Local Script ------------------------------------------------------------- --

function ModuleObjectInteraction.Local:OnGameStart()
    QSB.ScriptEvents.ObjectClicked = API.RegisterScriptEvent("Event_ObjectClicked");
    QSB.ScriptEvents.ObjectInteraction = API.RegisterScriptEvent("Event_ObjectInteraction");
    QSB.ScriptEvents.ObjectReset = API.RegisterScriptEvent("Event_ObjectReset");
    QSB.ScriptEvents.ObjectDelete = API.RegisterScriptEvent("Event_ObjectDelete");

    IO = {};
    IO_UserDefindedNames = {};
    IO_SlaveToMaster = {};
    IO_SlaveState = {};

    self:OverrideGameFunctions();
end

function ModuleObjectInteraction.Local:OnEvent(_ID, _Event, _ScriptName, _KnightID, _PlayerID)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.ObjectReset then
        if IO[_ScriptName] then
            IO[_ScriptName].IsUsed = false;
        end
    elseif _ID == QSB.ScriptEvents.ObjectInteraction then
        QSB.IO.LastObjectEntityID = GetID(_ScriptName);
        QSB.IO.LastHeroEntityID = _KnightID;
    end
end

function ModuleObjectInteraction.Local:OverrideGameFunctions()
    g_CurrentDisplayedQuestID = 0;

    GUI_Interaction.InteractiveObjectClicked_Orig_ModuleObjectInteraction = GUI_Interaction.InteractiveObjectClicked;
    GUI_Interaction.InteractiveObjectClicked = function()
        local i = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local EntityID = g_Interaction.ActiveObjectsOnScreen[i];
        local PlayerID = GUI.GetPlayerID();
        if not EntityID then
            return;
        end
        local ScriptName = Logic.GetEntityName(EntityID);
        if IO_SlaveToMaster[ScriptName] then
            ScriptName = IO_SlaveToMaster[ScriptName];
        end
        if IO[ScriptName] then
            if not IO[ScriptName].IsFullfilled then
                local Text = XGUIEng.GetStringTableText("UI_ButtonDisabled/PromoteKnight");
                if IO[ScriptName].ConditionInfo then
                    Text = API.ConvertPlaceholders(API.Localize(IO[ScriptName].ConditionInfo));
                end
                Message(Text);
                return;
            end
            if type(IO[ScriptName].Costs) == "table" and #IO[ScriptName].Costs ~= 0 then
                local StoreHouseID = Logic.GetStoreHouse(PlayerID);
                local CastleID     = Logic.GetHeadquarters(PlayerID);
                if StoreHouseID == nil or StoreHouseID == 0 or CastleID == nil or CastleID == 0 then
                    API.Note("DEBUG: Player needs special buildings when using activation costs!");
                    return;
                end
            end
        end
        GUI_Interaction.InteractiveObjectClicked_Orig_ModuleObjectInteraction();

        -- Send additional click event
        -- This is supposed to be used in singleplayer only!
        if not Framework.IsNetworkGame() then
            local KnightIDs = {};
            Logic.GetKnights(PlayerID, KnightIDs);
            local KnightID = API.GetClosestToTarget(EntityID, KnightIDs);
            API.SendScriptEventToGlobal(QSB.ScriptEvents.ObjectClicked, ScriptName, KnightID, PlayerID);
            API.SendScriptEvent(QSB.ScriptEvents.ObjectClicked, ScriptName, KnightID, PlayerID);
        end
    end

    GUI_Interaction.InteractiveObjectUpdate = function()
        if g_Interaction.ActiveObjects == nil then
            return;
        end

        local PlayerID = GUI.GetPlayerID();
        for i = 1, #g_Interaction.ActiveObjects do
            local ObjectID = g_Interaction.ActiveObjects[i];
            local MasterObjectID = ObjectID;
            local ScriptName = Logic.GetEntityName(ObjectID);
            if IO_SlaveToMaster[ScriptName] then
                MasterObjectID = GetID(IO_SlaveToMaster[ScriptName]);
            end
            local X, Y = GUI.GetEntityInfoScreenPosition(MasterObjectID);
            local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize();
            if X ~= 0 and Y ~= 0 and X > -50 and Y > -50 and X < (ScreenSizeX + 50) and Y < (ScreenSizeY + 50) then
                if not table.contains(g_Interaction.ActiveObjectsOnScreen, ObjectID) then
                    table.insert(g_Interaction.ActiveObjectsOnScreen, ObjectID);
                end
            else
                for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                    if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                        table.remove(g_Interaction.ActiveObjectsOnScreen, i);
                    end
                end
            end
        end

        for i = 1, #g_Interaction.ActiveObjectsOnScreen do
            local Widget = "/InGame/Root/Normal/InteractiveObjects/" ..i;
            if XGUIEng.IsWidgetExisting(Widget) == 1 then
                local ObjectID       = g_Interaction.ActiveObjectsOnScreen[i];
                local MasterObjectID = ObjectID;
                local ScriptName     = Logic.GetEntityName(ObjectID);
                if IO_SlaveToMaster[ScriptName] then
                    MasterObjectID = GetID(IO_SlaveToMaster[ScriptName]);
                    ScriptName = Logic.GetEntityName(MasterObjectID);
                end
                local EntityType = Logic.GetEntityType(ObjectID);
                local X, Y = GUI.GetEntityInfoScreenPosition(MasterObjectID);
                local WidgetSize = {XGUIEng.GetWidgetScreenSize(Widget)};
                XGUIEng.SetWidgetScreenPosition(Widget, X - (WidgetSize[1]/2), Y - (WidgetSize[2]/2));
                local BaseCosts = {Logic.InteractiveObjectGetCosts(ObjectID)};
                local EffectiveCosts = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
                local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID);
                local HasSpace = Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID);
                local Disable = false;

                if BaseCosts[1] ~= nil and EffectiveCosts[1] == nil and IsAvailable == true then
                    Disable = true;
                end
                if HasSpace == false then
                    Disable = true
                end
                if Disable == false then
                    if IO[ScriptName] and type(IO[ScriptName].Player) == "table" then
                        Disable = not self:IsAvailableForGuiPlayer(ScriptName);
                    elseif IO[ScriptName] and type(IO[ScriptName].Player) == "number" then
                        Disable = IO[ScriptName].Player ~= PlayerID;
                    end
                end

                if Disable == true then
                    XGUIEng.DisableButton(Widget, 1);
                else
                    XGUIEng.DisableButton(Widget, 0);
                end
                if GUI_Interaction.InteractiveObjectUpdateEx1 ~= nil then
                    GUI_Interaction.InteractiveObjectUpdateEx1(Widget, EntityType);
                end
                XGUIEng.ShowWidget(Widget, 1);
            end
        end

        for i = #g_Interaction.ActiveObjectsOnScreen + 1, 2 do
            local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i;
            XGUIEng.ShowWidget(Widget, 0);
        end

        for i = 1, #g_Interaction.ActiveObjectsOnScreen do
            local Widget     = "/InGame/Root/Normal/InteractiveObjects/" ..i;
            local ObjectID   = g_Interaction.ActiveObjectsOnScreen[i];
            local ScriptName = Logic.GetEntityName(ObjectID);
            if IO_SlaveToMaster[ScriptName] then
                ScriptName = IO_SlaveToMaster[ScriptName];
            end
            if IO[ScriptName] and IO[ScriptName].Texture then
                local FileBaseName;
                local a = (IO[ScriptName].Texture[1]) or 14;
                local b = (IO[ScriptName].Texture[2]) or 10;
                local c = (IO[ScriptName].Texture[3]) or 0;
                if type(c) == "string" then
                    FileBaseName = c;
                    c = 0;
                end
                API.SetIcon(Widget, {a, b, c}, nil, FileBaseName);
            end
        end
    end

    GUI_Interaction.InteractiveObjectMouseOver_Orig_ModuleObjectInteraction = GUI_Interaction.InteractiveObjectMouseOver;
    GUI_Interaction.InteractiveObjectMouseOver = function()
        local PlayerID = GUI.GetPlayerID();
        local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber];
        local EntityType = Logic.GetEntityType(ObjectID);

        if g_GameExtraNo > 0 then
            local EntityTypeName = Logic.GetEntityTypeName(EntityType);
            if table.contains ({"R_StoneMine", "R_IronMine", "B_Cistern", "B_Well", "I_X_TradePostConstructionSite"}, EntityTypeName) then
                GUI_Interaction.InteractiveObjectMouseOver_Orig_ModuleObjectInteraction();
                return;
            end
        end
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);
        if string.find(EntityTypeName, "^I_X_") and tonumber(Logic.GetEntityName(ObjectID)) ~= nil then
            GUI_Interaction.InteractiveObjectMouseOver_Orig_ModuleObjectInteraction();
            return;
        end
        local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
        local ScriptName = Logic.GetEntityName(ObjectID);
        if IO_SlaveToMaster[ScriptName] then
            ScriptName = IO_SlaveToMaster[ScriptName];
        end

        local CheckSettlement;
        if IO[ScriptName] and IO[ScriptName].IsUsed ~= true then
            local Key = "InteractiveObjectAvailable";
            if (IO[ScriptName] and type(IO[ScriptName].Player) == "table" and not self:IsAvailableForGuiPlayer(ScriptName))
            or (IO[ScriptName] and type(IO[ScriptName].Player) == "number" and IO[ScriptName].Player ~= PlayerID)
            or Logic.InteractiveObjectGetAvailability(ObjectID) == false then
                Key = "InteractiveObjectNotAvailable";
            end
            local DisabledKey;
            if Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID) == false then
                DisabledKey = "InteractiveObjectAvailableReward";
            end
            local Title = IO[ScriptName].Title or ("UI_ObjectNames/" ..Key);
            Title = API.ConvertPlaceholders(API.Localize(Title));
            if Title and Title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                Title = XGUIEng.GetStringTableText(Title);
            end
            local Text = IO[ScriptName].Text or ("UI_ObjectDescription/" ..Key);
            Text = API.ConvertPlaceholders(API.Localize(Text));
            if Text and Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                Text = XGUIEng.GetStringTableText(Text);
            end
            local Disabled = IO[ScriptName].DisabledText or DisabledKey;
            if Disabled then
                Disabled = API.ConvertPlaceholders(API.Localize(Disabled));
                if Disabled and Disabled:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                    Disabled = XGUIEng.GetStringTableText(Disabled);
                end
            end
            Costs = IO[ScriptName].Costs;
            if Costs and Costs[1] and Costs[1] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
                CheckSettlement = true;
            end
            API.SetTooltipCosts(Title, Text, Disabled, Costs, CheckSettlement);
            return;
        end
        GUI_Interaction.InteractiveObjectMouseOver_Orig_ModuleObjectInteraction();
    end

    GUI_Interaction.DisplayQuestObjective_Orig_ModuleObjectInteraction = GUI_Interaction.DisplayQuestObjective
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local QuestIndexTemp = tonumber(_QuestIndex);
        if QuestIndexTemp then
            _QuestIndex = QuestIndexTemp;
        end

        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives";
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0);
        local QuestObjectiveContainer;
        local QuestTypeCaption;

        g_CurrentDisplayedQuestID = _QuestIndex;

        if QuestType == Objective.Object then
            QuestObjectiveContainer = QuestObjectivesPath .. "/List";
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestInteraction");
            local ObjectList = {};

            for i = 1, Quest.Objectives[1].Data[0] do
                local ObjectType;
                if Logic.IsEntityDestroyed(Quest.Objectives[1].Data[i]) then
                    ObjectType = g_Interaction.SavedQuestEntityTypes[_QuestIndex][i];
                else
                    ObjectType = Logic.GetEntityType(GetID(Quest.Objectives[1].Data[i]));
                end
                local ObjectEntityName = Logic.GetEntityName(Quest.Objectives[1].Data[i]);
                local ObjectName = "";
                if ObjectType ~= nil and ObjectType ~= 0 then
                    local ObjectTypeName = Logic.GetEntityTypeName(ObjectType)
                    ObjectName = Wrapped_GetStringTableText(_QuestIndex, "Names/" .. ObjectTypeName);
                    if ObjectName == "" then
                        ObjectName = Wrapped_GetStringTableText(_QuestIndex, "UI_ObjectNames/" .. ObjectTypeName);
                    end
                    if ObjectName == "" then
                        ObjectName = IO_UserDefindedNames[ObjectTypeName];
                    end
                    if ObjectName == nil then
                        ObjectName = IO_UserDefindedNames[ObjectEntityName];
                    end
                    if ObjectName == nil then
                        ObjectName = "Debug: ObjectName missing for " .. ObjectTypeName;
                    end
                end
                table.insert(ObjectList, API.Localize(API.ConvertPlaceholders(ObjectName)));
            end
            for i = 1, 4 do
                local String = ObjectList[i];
                if String == nil then
                    String = "";
                end
                XGUIEng.SetText(QuestObjectiveContainer .. "/Entry" .. i, "{center}" .. String);
            end

            SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{14, 10});
            XGUIEng.SetText(QuestObjectiveContainer.."/Caption","{center}"..QuestTypeCaption);
            XGUIEng.ShowWidget(QuestObjectiveContainer, 1);
        else
            GUI_Interaction.DisplayQuestObjective_Orig_ModuleObjectInteraction(_QuestIndex, _MessageKey);
        end
    end
end

function ModuleObjectInteraction.Local:IsAvailableForGuiPlayer(_ScriptName)
    local PlayerID = GUI.GetPlayerID();
    if IO[_ScriptName] and type(IO[_ScriptName].Player) == "table" then
        for i= 1, 8 do
            if IO[_ScriptName].Player[i] and IO[_ScriptName].Player[i] == PlayerID then
                return true;
            end
        end
        return false;
    end
    return true;
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleObjectInteraction);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Einfachere und erweitere Handhabe von Interaktiven Objekten.
--
-- <b>Befehle:</b><br>
-- <i>Diese Befehle können über die Konsole (SHIFT + ^) eingegeben werden, wenn
-- der Debug Mode aktiviert ist.</i><br>
-- <table border="1">
-- <tr>
-- <td><b>Befehl</b></td>
-- <td><b>Parameter</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>enableobject</td>
-- <td>ScriptName</td>
-- <td>Aktiviert das interaktive Objekt.</td>
-- </tr>
-- <tr>
-- <td>disableobject</td>
-- <td>ScriptName</td>
-- <td>Deaktiviert das interactive Objekt</td>
-- </tr>
-- <tr>
-- <td>initobject</td>
-- <td>ScriptName</td>
-- <td>Initialisiert ein interaktives Objekt grundlegend, sodass es benutzt werden kann.</td>
-- </tr>
-- </table>
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(1) Benutzerschnittstelle</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field ObjectClicked     Der Spieler klickt auf den Button des IO (Parameter: ScriptName, KnightID, PlayerID)
-- @field ObjectInteraction Es wird mit einem interaktiven Objekt interagiert (Parameter: ScriptName, KnightID, PlayerID)
-- @field ObjectDelete      Eine Interaktion wird von einem Objekt entfernt (Parameter: ScriptName)
-- @field ObjectReset       Der Zustand eines interaktiven Objekt wird zurückgesetzt (Parameter: ScriptName)
--
-- @within Event
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

---
-- Erzeugt ein einfaches interaktives Objekt.
--
-- Dabei können alle Entities als interaktive Objekte behandelt werden, nicht
-- nur die, die eigentlich dafür vorgesehen sind.
--
-- Die Parameter des interaktiven Objektes werden durch seine Beschreibung
-- festgelegt. Die Beschreibung ist eine Table, die bestimmte Werte für das
-- Objekt beinhaltet. Dabei müssen nicht immer alle Werte angegeben werden.
--
-- <b>Achtung</b>: Wird eine Straße über einem Objekt platziert, während die
-- Kosten bereits bezahlt und auf dem Weg sind, läuft die Aktivierung ins Leere.
-- Zwar wird das Objekt zurückgesetzt, doch die bereits geschickten Waren sind
-- dann futsch.
--
-- Mögliche Angaben:
-- <table border="1">
-- <tr>
-- <td><b>Feldname</b></td>
-- <td><b>Typ</b></td>
-- <td><b>Beschreibung</b></td>
-- <td><b>Optional</b></td>
-- </tr>
-- <tr>
-- <td>Name</td>
-- <td>string</td>
-- <td>Der Skriptname des Entity, das zum interaktiven Objekt wird.</td>
-- <td>nein</td>
-- </tr>
-- <tr>
-- <td>Texture</td>
-- <td>table</td>
-- <td>Angezeigtes Icon des Buttons. Die Icons können auf die Icons des Spiels
-- oder auf eigene Icons zugreifen.
-- <br>- Spiel-Icons: {x, y, Spielversion}
-- <br>- Benutzerdefinierte Icons: {x, y, Dateinamenpräfix}</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Title</td>
-- <td>string</td>
-- <td>Angezeigter Titel des Objekt</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Text</td>
-- <td>string</td>
-- <td>Angezeigte Beschreibung des Objekt</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Distance</td>
-- <td>number</td>
-- <td>Die minimale Entfernung zum Objekt, die ein Held benötigt um das
-- objekt zu aktivieren.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Player</td>
-- <td>number|table</td>
-- <td>Spieler, der/die das Objekt aktivieren kann/können.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Waittime</td>
-- <td>number</td>
-- <td>Die Zeit, die ein Held benötigt, um das Objekt zu aktivieren.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Replacement</td>
-- <td>number</td>
-- <td>Entity, mit der das Objekt nach Aktivierung ersetzt wird.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Costs</td>
-- <td></td>
-- <td>Eine Table mit dem Typ und der Menge der Kosten. (Format: {Typ, Menge, Typ, Menge})</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Reward</td>
-- <td>table</td>
-- <td>Der Warentyp und die Menge der gefundenen Waren im Objekt. (Format: {Typ, Menge})</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>State</td>
-- <td>number</td>
-- <td>Bestimmt, wie sich der Button des interaktiven Objektes verhält.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Condition</td>
-- <td>function</td>
-- <td>Eine zusätzliche Aktivierungsbedinung als Funktion.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>ConditionInfo</td>
-- <td>string</td>
-- <td>Nachricht, die angezeigt wird, wenn die Bedinung nicht erfüllt ist.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>Action</td>
-- <td>function</td>
-- <td>Eine Funktion, die nach der Aktivierung aufgerufen wird.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>RewardResourceCartType</td>
-- <td>number</td>
-- <td>Erlaubt, einen anderern Karren für Rohstoffkosten einstellen.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>RewardGoldCartType</td>
-- <td>number</td>
-- <td>Erlaubt, einen anderern Karren für Goldkosten einstellen.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>CostResourceCartType</td>
-- <td>number</td>
-- <td>Erlaubt, einen anderern Karren für Rohstoffbelohnungen einstellen.</td>
-- <td>ja</td>
-- </tr>
-- <tr>
-- <td>CostGoldCartType</td>
-- <td>number</td>
-- <td>Erlaubt, einen anderern Karren für Goldbelohnung einstellen.</td>
-- <td>ja</td>
-- </tr>
-- </table>
--
-- @param[type=table] _Description Beschreibung
-- @within Anwenderfunktionen
-- @see API.ResetObject
-- @see API.InteractiveObjectActivate
-- @see API.InteractiveObjectDeactivate
--
-- @usage
-- API.SetupObject {
--     Name     = "hut",
--     Distance = 1500,
--     Reward   = {Goods.G_Gold, 1000},
-- };
--
function API.SetupObject(_Description)
    if GUI then
        return;
    end
    return ModuleObjectInteraction.Global:CreateObject(_Description);
end
API.CreateObject = API.SetupObject;

---
-- Zerstört die Interation mit dem Objekt.
--
-- <b>Hinweis</b>: Das Entity selbst wird nicht zerstört.
--
-- @param[type=string] _ScriptName Skriptname des Objektes
-- @see API.SetupObject
-- @see API.ResetObject
-- @usage
-- API.DisposeObject("MyObject");
--
function API.DisposeObject(_ScriptName)
    if GUI or not IO[_ScriptName] then
        return;
    end
    ModuleObjectInteraction.Global:DestroyObject(_ScriptName);
end

---
-- Setzt das interaktive Objekt zurück. Dadurch verhält es sich, wie vor der
-- Aktivierung durch den Spieler.
--
-- <b>Hinweis</b>: Das Objekt muss wieder per Skript aktiviert werden, damit es
-- im Spiel ausgelöst werden.
--
-- @param[type=string] _ScriptName Skriptname des Objektes
-- @within Anwenderfunktionen
-- @see API.SetupObject
-- @see API.InteractiveObjectActivate
-- @see API.InteractiveObjectDeactivate
-- @usage
-- API.ResetObject("MyObject");
--
function API.ResetObject(_ScriptName)
    if GUI or not IO[_ScriptName] then
        return;
    end
    ModuleObjectInteraction.Global:ResetObject(_ScriptName);
    API.InteractiveObjectDeactivate(_ScriptName);
end

---
-- Aktiviert ein Interaktives Objekt, sodass es von den Spielern
-- aktiviert werden kann.
--
-- Optional kann das Objekt nur für einen bestimmten Spieler aktiviert werden.
--
-- Der State bestimmt, ob es immer aktiviert werden kann, oder ob der Spieler
-- einen Helden benutzen muss. Wird der Parameter weggelassen, muss immer ein
-- Held das Objekt aktivieren.
--
-- @param[type=string] _ScriptName Skriptname des Objektes
-- @param[type=number] _State      State des Objektes
-- @param[type=number] ...         (Optional) Liste mit PlayerIDs
-- @within Anwenderfunktionen
--
function API.InteractiveObjectActivate(_ScriptName, _State, ...)
    arg = arg or {1};
    if GUI then
        return;
    end
    if IO[_ScriptName] then
        local SlaveName = (IO[_ScriptName].Slave or _ScriptName);
        if IO[_ScriptName].Slave then
            IO_SlaveState[SlaveName] = 1;
            Logic.ExecuteInLuaLocalState(string.format(
                [[IO_SlaveState["%s"] = 1]],
                SlaveName
            ));
        end
        ModuleObjectInteraction.Global:SetObjectState(SlaveName, _State, unpack(arg));
        IO[_ScriptName].IsActive = true;
        Logic.ExecuteInLuaLocalState(string.format(
            [[IO["%s"].IsActive = true]],
            _ScriptName
        ));
    else
        ModuleObjectInteraction.Global:SetObjectState(_ScriptName, _State, unpack(arg));
    end
end
InteractiveObjectActivate = API.InteractiveObjectActivate;

---
-- Deaktiviert ein interaktives Objekt, sodass es nicht mehr von den Spielern
-- benutzt werden kann.
--
-- Optional kann das Objekt nur für einen bestimmten Spieler deaktiviert werden.
--
-- @param[type=string] _ScriptName Scriptname des Objektes
-- @param[type=number] ...         (Optional) Liste mit PlayerIDs
-- @within Anwenderfunktionen
--
function API.InteractiveObjectDeactivate(_ScriptName, ...)
    arg = arg or {1};
    if GUI then
        return;
    end
    if IO[_ScriptName] then
        local SlaveName = (IO[_ScriptName].Slave or _ScriptName);
        if IO[_ScriptName].Slave then
            IO_SlaveState[SlaveName] = 0;
            Logic.ExecuteInLuaLocalState(string.format(
                [[IO_SlaveState["%s"] = 0]],
                SlaveName
            ));
        end
        ModuleObjectInteraction.Global:SetObjectState(SlaveName, 2, unpack(arg));
        IO[_ScriptName].IsActive = false;
        Logic.ExecuteInLuaLocalState(string.format(
            [[IO["%s"].IsActive = false]],
            _ScriptName
        ));
    else
        ModuleObjectInteraction.Global:SetObjectState(_ScriptName, 2, unpack(arg));
    end
end
InteractiveObjectDeactivate = API.InteractiveObjectDeactivate;

---
-- Erzeugt eine Beschriftung für Custom Objects.
--
-- Im Questfenster werden die Namen von Custom Objects als ungesetzt angezeigt.
-- Mit dieser Funktion kann ein Name angelegt werden.
--
-- @param[type=string] _Key  Typname des Entity
-- @param              _Text Text der Beschriftung
-- @within Anwenderfunktionen
--
-- @usage
-- -- Beispiel #1: Einfache Beschriftung
-- API.InteractiveObjectSetName("D_X_ChestOpenEmpty", "Leere Schatztruhe");
--
-- @usage
-- -- Beispiel #1: Multilinguale Beschriftung
-- API.InteractiveObjectSetName("D_X_ChestClosed", {de = "Schatztruhe", en = "Treasure"});
--
function API.InteractiveObjectSetName(_Key, _Text)
    if GUI then
        return;
    end
    IO_UserDefindedNames[_Key] = _Text;
    Logic.ExecuteInLuaLocalState(string.format(
        [[IO_UserDefindedNames["%s"] = %s]],
        _Key,
        table.tostring(IO_UserDefindedNames)
    ));
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

--
-- Stellt neue Behavior für Objekte bereit.
--

---
-- Der Spieler muss bis zu 4 interaktive Objekte benutzen.
--
-- @param[type=string] _Object1 Erstes Objekt
-- @param[type=string] _Object2 (optional) Zweites Objekt
-- @param[type=string] _Object3 (optional) Drittes Objekt
-- @param[type=string] _Object4 (optional) Viertes Objekt
--
-- @within Goal
--
function Goal_ActivateSeveralObjects(...)
    return B_Goal_ActivateSeveralObjects:new(...);
end

B_Goal_ActivateSeveralObjects = {
    Name = "Goal_ActivateSeveralObjects",
    Description = {
        en = "Goal: Activate an interactive object",
        de = "Ziel: Aktiviere ein interaktives Objekt",
        fr = "Objectif: activer un objet interactif",
    },
    Parameter = {
        { ParameterType.Default, en = "Object name 1", de = "Skriptname 1", fr = "Nom de l'entité 1" },
        { ParameterType.Default, en = "Object name 2", de = "Skriptname 2", fr = "Nom de l'entité 2" },
        { ParameterType.Default, en = "Object name 3", de = "Skriptname 3", fr = "Nom de l'entité 3" },
        { ParameterType.Default, en = "Object name 4", de = "Skriptname 4", fr = "Nom de l'entité 4" },
    },
    ScriptNames = {};
}

function B_Goal_ActivateSeveralObjects:GetGoalTable()
    return {Objective.Object, { unpack(self.ScriptNames) } }
end

function B_Goal_ActivateSeveralObjects:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        assert(_Parameter ~= nil and _Parameter ~= "", "Goal_ActivateSeveralObjects: At least one IO needed!");
    end
    if _Parameter ~= nil and _Parameter ~= "" then
        table.insert(self.ScriptNames, _Parameter);
    end
end

function B_Goal_ActivateSeveralObjects:GetMsgKey()
    return "Quest_Object_Activate"
end

Revision:RegisterBehavior(B_Goal_ActivateSeveralObjects);

-- -------------------------------------------------------------------------- --

-- Überschreibt ObjectInit, sodass auch Custom Objects verwaltet werden können.
B_Reward_ObjectInit.CustomFunction = function(self, _Quest)
    local EntityID = GetID(self.ScriptName);
    if EntityID == 0 then
        return;
    end
    QSB.InitalizedObjekts[EntityID] = _Quest.Identifier;

    local GoodReward;
    if self.RewardType and self.RewardType ~= "-" then
        GoodReward = {Goods[self.RewardType], self.RewardAmount};
    end

    local GoodCosts;
    if self.FirstCostType and self.FirstCostType ~= "-" then
        GoodCosts = GoodReward or {};
        table.insert(GoodCosts, Goods[self.FirstCostType]);
        table.insert(GoodCosts, Goods[self.FirstCostAmount]);
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        GoodCosts = GoodReward or {};
        table.insert(GoodCosts, Goods[self.SecondCostType]);
        table.insert(GoodCosts, Goods[self.SecondCostAmount]);
    end

    API.SetupObject {
        Name                   = self.ScriptName,
        Distance               = self.Distance,
        Waittime               = self.Waittime,
        Reward                 = GoodReward,
        Costs                  = GoodCosts,
    };
    API.InteractiveObjectActivate(self.ScriptName, self.UsingState);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleKnightTitleRequirements = {
    Properties = {
        Name = "ModuleKnightTitleRequirements",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {};
    Local  = {};

    Shared = {};
};

QSB.RequirementTooltipTypes = {};
QSB.ConsumedGoodsCounter = {};

-- Global Script ------------------------------------------------------------ --

function ModuleKnightTitleRequirements.Global:OnGameStart()
    QSB.ScriptEvents.KnightTitleChanged = API.RegisterScriptEvent("Event_KnightTitleChanged");
    QSB.ScriptEvents.GoodsConsumed = API.RegisterScriptEvent("Event_GoodsConsumed");

    self:OverrideKnightTitleChanged();
    self:OverwriteConsumedGoods();
end

function ModuleKnightTitleRequirements.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.KnightTitleChanged then
        local Consume = QSB.ConsumedGoodsCounter[arg[1]];
        QSB.ConsumedGoodsCounter[arg[1]] = Consume or {};
        for k,v in pairs(QSB.ConsumedGoodsCounter[arg[1]]) do
            QSB.ConsumedGoodsCounter[arg[1]][k] = 0;
        end
    elseif _ID == QSB.ScriptEvents.GoodsConsumed then
        local PlayerID = Logic.EntityGetPlayer(arg[1]);
        self:RegisterConsumedGoods(PlayerID, arg[2]);
    end
end

function ModuleKnightTitleRequirements.Global:RegisterConsumedGoods(_PlayerID, _Good)
    QSB.ConsumedGoodsCounter[_PlayerID]        = QSB.ConsumedGoodsCounter[_PlayerID] or {};
    QSB.ConsumedGoodsCounter[_PlayerID][_Good] = QSB.ConsumedGoodsCounter[_PlayerID][_Good] or 0;
    QSB.ConsumedGoodsCounter[_PlayerID][_Good] = QSB.ConsumedGoodsCounter[_PlayerID][_Good] +1;
end

function ModuleKnightTitleRequirements.Global:OverrideKnightTitleChanged()
    GameCallback_KnightTitleChanged_Orig_QSB_Requirements = GameCallback_KnightTitleChanged;
    GameCallback_KnightTitleChanged = function(_PlayerID, _TitleID)
        GameCallback_KnightTitleChanged_Orig_QSB_Requirements(_PlayerID, _TitleID);

        -- Send event
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.KnightTitleChanged, %d, %d)]],
            _PlayerID, _TitleID
        ));
        API.SendScriptEvent(QSB.ScriptEvents.KnightTitleChanged, _PlayerID, _TitleID);
    end
end

function ModuleKnightTitleRequirements.Global:OverwriteConsumedGoods()
    GameCallback_ConsumeGood_Orig_QSB_Requirements = GameCallback_ConsumeGood;
    GameCallback_ConsumeGood = function(_Consumer, _Good, _Building)
        GameCallback_ConsumeGood_Orig_QSB_Requirements(_Consumer, _Good, _Building)

        -- Send event
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.GoodsConsumed, %d, %d, %d)]],
            _Consumer, _Good, _Building
        ));
        API.SendScriptEvent(QSB.ScriptEvents.GoodsConsumed, _Consumer, _Good, _Building);
    end
end

-- Local Script ------------------------------------------------------------- --

function ModuleKnightTitleRequirements.Local:OnGameStart()
    QSB.ScriptEvents.KnightTitleChanged = API.RegisterScriptEvent("Event_KnightTitleChanged");
    QSB.ScriptEvents.GoodsConsumed = API.RegisterScriptEvent("Event_GoodsConsumed");

    self:OverwriteTooltips();
    self:InitTexturePositions();
    self:OverwriteUpdateRequirements();
end

function ModuleKnightTitleRequirements.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.KnightTitleChanged then
        local Consume = QSB.ConsumedGoodsCounter[arg[1]];
        QSB.ConsumedGoodsCounter[arg[1]] = Consume or {};
        for k,v in pairs(QSB.ConsumedGoodsCounter[arg[1]]) do
            QSB.ConsumedGoodsCounter[arg[1]][k] = 0;
        end
    elseif _ID == QSB.ScriptEvents.GoodsConsumed then
        local PlayerID = Logic.EntityGetPlayer(arg[1]);
        self:RegisterConsumedGoods(PlayerID, arg[2]);
    end
end

function ModuleKnightTitleRequirements.Local:RegisterConsumedGoods(_PlayerID, _Good)
    QSB.ConsumedGoodsCounter[_PlayerID]        = QSB.ConsumedGoodsCounter[_PlayerID] or {};
    QSB.ConsumedGoodsCounter[_PlayerID][_Good] = QSB.ConsumedGoodsCounter[_PlayerID][_Good] or 0;
    QSB.ConsumedGoodsCounter[_PlayerID][_Good] = QSB.ConsumedGoodsCounter[_PlayerID][_Good] +1;
end

function ModuleKnightTitleRequirements.Local:InitTexturePositions()
    g_TexturePositions.EntityCategories[EntityCategories.GC_Food_Supplier]          = { 1, 1};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Clothes_Supplier]       = { 1, 2};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Hygiene_Supplier]       = {16, 1};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Entertainment_Supplier] = { 1, 4};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Luxury_Supplier]        = {16, 3};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Weapon_Supplier]        = { 1, 7};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Medicine_Supplier]      = { 2,10};
    g_TexturePositions.EntityCategories[EntityCategories.Outpost]                   = {12, 3};
    g_TexturePositions.EntityCategories[EntityCategories.Spouse]                    = { 5,15};
    g_TexturePositions.EntityCategories[EntityCategories.CattlePasture]             = { 3,16};
    g_TexturePositions.EntityCategories[EntityCategories.SheepPasture]              = { 4, 1};
    g_TexturePositions.EntityCategories[EntityCategories.Soldier]                   = { 7,12};
    g_TexturePositions.EntityCategories[EntityCategories.GrainField]                = {14, 2};
    g_TexturePositions.EntityCategories[EntityCategories.BeeHive]                   = { 2, 1};
    g_TexturePositions.EntityCategories[EntityCategories.OuterRimBuilding]          = { 3, 4};
    g_TexturePositions.EntityCategories[EntityCategories.CityBuilding]              = { 8, 1};
    g_TexturePositions.EntityCategories[EntityCategories.Leader]                    = { 7, 11};
    g_TexturePositions.EntityCategories[EntityCategories.Range]                     = { 9, 8};
    g_TexturePositions.EntityCategories[EntityCategories.Melee]                     = { 9, 7};
    g_TexturePositions.EntityCategories[EntityCategories.SiegeEngine]               = { 2,15};

    g_TexturePositions.Entities[Entities.B_Beehive]                                 = { 2, 1};
    g_TexturePositions.Entities[Entities.B_Cathedral_Big]                           = { 3,12};
    g_TexturePositions.Entities[Entities.B_CattlePasture]                           = { 3,16};
    g_TexturePositions.Entities[Entities.B_GrainField_ME]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_NA]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_NE]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_SE]                           = { 1,13};
    g_TexturePositions.Entities[Entities.U_MilitaryBallista]                        = {10, 5};
    g_TexturePositions.Entities[Entities.B_Outpost]                                 = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_ME]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_NA]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_NE]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_SE]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_SheepPasture]                            = { 4, 1};
    g_TexturePositions.Entities[Entities.U_SiegeEngineCart]                         = { 9, 4};
    g_TexturePositions.Entities[Entities.U_Trebuchet]                               = { 9, 1};
    if Framework.GetGameExtraNo() ~= 0 then
        g_TexturePositions.Entities[Entities.B_GrainField_AS]                       = { 1,13};
        g_TexturePositions.Entities[Entities.B_Outpost_AS]                          = {12, 3};
    end

    g_TexturePositions.Needs[Needs.Medicine]                                        = { 2,10};

    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_1]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_2]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_3]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_1]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_2]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_3]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_1]            = { 4, 6};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_2]            = { 4, 6};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_3]            = { 4, 6};

    g_TexturePositions.Buffs = g_TexturePositions.Buffs or {};

    g_TexturePositions.Buffs[Buffs.Buff_ClothesDiversity]                           = { 1, 2};
    g_TexturePositions.Buffs[Buffs.Buff_EntertainmentDiversity]                     = { 1, 4};
    g_TexturePositions.Buffs[Buffs.Buff_FoodDiversity]                              = { 1, 1};
    g_TexturePositions.Buffs[Buffs.Buff_HygieneDiversity]                           = { 1, 3};
    g_TexturePositions.Buffs[Buffs.Buff_Colour]                                     = { 5,11};
    g_TexturePositions.Buffs[Buffs.Buff_Entertainers]                               = { 5,12};
    g_TexturePositions.Buffs[Buffs.Buff_ExtraPayment]                               = { 1, 8};
    g_TexturePositions.Buffs[Buffs.Buff_Sermon]                                     = { 4,14};
    g_TexturePositions.Buffs[Buffs.Buff_Spice]                                      = { 5,10};
    g_TexturePositions.Buffs[Buffs.Buff_NoTaxes]                                    = { 1, 6};
    if Framework.GetGameExtraNo() ~= 0 then
        g_TexturePositions.Buffs[Buffs.Buff_Gems]                                   = { 1, 1, 1};
        g_TexturePositions.Buffs[Buffs.Buff_MusicalInstrument]                      = { 1, 3, 1};
        g_TexturePositions.Buffs[Buffs.Buff_Olibanum]                               = { 1, 2, 1};
    end

    g_TexturePositions.GoodCategories = g_TexturePositions.GoodCategories or {};

    g_TexturePositions.GoodCategories[GoodCategories.GC_Ammunition]                 = {10, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Animal]                     = { 4,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Clothes]                    = { 1, 2};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Document]                   = { 5, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Entertainment]              = { 1, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Food]                       = { 1, 1};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Gold]                       = { 1, 8};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Hygiene]                    = {16, 1};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Luxury]                     = {16, 3};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Medicine]                   = { 2,10};
    g_TexturePositions.GoodCategories[GoodCategories.GC_None]                       = {15,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_RawFood]                    = { 3, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_RawMedicine]                = { 2, 2};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Research]                   = { 5, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Resource]                   = { 3, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Tools]                      = { 4,12};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Water]                      = { 1,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Weapon]                     = { 8, 5};
end

function ModuleKnightTitleRequirements.Local:OverwriteUpdateRequirements()
    GUI_Knight.UpdateRequirements = function()
        local WidgetPos = ModuleKnightTitleRequirements.Local.RequirementWidgets;
        local RequirementsIndex = 1;

        local PlayerID = GUI.GetPlayerID();
        local CurrentTitle = Logic.GetKnightTitle(PlayerID);
        local NextTitle = CurrentTitle + 1;

        -- Headline
        local KnightID = Logic.GetKnightID(PlayerID);
        local KnightType = Logic.GetEntityType(KnightID);
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitle", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle));
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitleWhite", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle));

        -- show Settlers
        if KnightTitleRequirements[NextTitle].Settlers ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {5,16})
            local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfSettlersForKnightTitleExist(PlayerID, NextTitle)
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1)
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0)
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1)

            QSB.RequirementTooltipTypes[RequirementsIndex] = "Settlers";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- show rich buildings
        if KnightTitleRequirements[NextTitle].RichBuildings ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {8,4});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfRichBuildingsForKnightTitleExist(PlayerID, NextTitle);
            if NeededAmount == -1 then
                NeededAmount = Logic.GetNumberOfPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding);
            end
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "RichBuildings";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Castle
        if KnightTitleRequirements[NextTitle].Headquarters ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,7});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Headquarters);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "Headquarters";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Storehouse
        if KnightTitleRequirements[NextTitle].Storehouse ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,6});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Storehouse);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "Storehouse";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Cathedral
        if KnightTitleRequirements[NextTitle].Cathedrals ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,5});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Cathedrals);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "Cathedrals";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Volldekorierte Gebäude
        if KnightTitleRequirements[NextTitle].FullDecoratedBuildings ~= nil then
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist(PlayerID, NextTitle);
            local EntityCategory = KnightTitleRequirements[NextTitle].FullDecoratedBuildings;
            SetIcon(WidgetPos[RequirementsIndex].."/Icon"  , g_TexturePositions.Needs[Needs.Wealth]);

            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] , 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "FullDecoratedBuildings";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Stadtruf
        if KnightTitleRequirements[NextTitle].Reputation ~= nil then
            SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", {5,14});
            local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededCityReputationForKnightTitleExist(PlayerID, NextTitle);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            QSB.RequirementTooltipTypes[RequirementsIndex] = "Reputation";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Güter sammeln
        if KnightTitleRequirements[NextTitle].Goods ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Goods do
                local GoodType = KnightTitleRequirements[NextTitle].Goods[i][1];
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfGoodTypesForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "Goods" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Kategorien
        if KnightTitleRequirements[NextTitle].Category ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Category do
                local Category = KnightTitleRequirements[NextTitle].Category[i][1];
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.EntityCategories[Category]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                local EntitiesInCategory = {Logic.GetEntityTypesInCategory(Category)};
                if Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.GC_Weapon_Supplier) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Weapons" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.SiegeEngine) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "HeavyWeapons" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Spouse) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Spouse" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Worker) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Worker" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Soldier) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Soldiers" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Leader) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Leader" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Outpost) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Outposts" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.CattlePasture) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Cattle" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.SheepPasture) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Sheep" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.CityBuilding) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "CityBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.OuterRimBuilding) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "OuterRimBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.GrainField) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "FarmerBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.BeeHive) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "FarmerBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.AttackableBuilding) == 1 then
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "Buildings" .. i;
                else
                    QSB.RequirementTooltipTypes[RequirementsIndex] = "EntityCategoryDefault" .. i;
                end
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Entities
        if KnightTitleRequirements[NextTitle].Entities ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Entities do
                local EntityType = KnightTitleRequirements[NextTitle].Entities[i][1];
                local EntityTypeName = Logic.GetEntityTypeName(EntityType);
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Entities[EntityType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                local TopltipType = "Entities" .. i;
                if EntityTypeName == "B_Beehive" or EntityTypeName:find("GrainField") or EntityTypeName:find("Pasture") then
                    TopltipType = "FarmerBuilding" .. i;
                end
                QSB.RequirementTooltipTypes[RequirementsIndex] = TopltipType;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Güter konsumieren
        if KnightTitleRequirements[NextTitle].Consume ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Consume do
                local GoodType = KnightTitleRequirements[NextTitle].Consume[i][1];
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfConsumedGoodsForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "Consume" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Güter aus Gruppe produzieren
        if KnightTitleRequirements[NextTitle].Products ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Products do
                local Product = KnightTitleRequirements[NextTitle].Products[i][1];
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.GoodCategories[Product]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNumberOfProductsInCategoryExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "Products" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Bonus aktivieren
        if KnightTitleRequirements[NextTitle].Buff ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Buff do
                local Buff = KnightTitleRequirements[NextTitle].Buff[i];
                SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Buffs[Buff]);
                local IsFulfilled = DoNeededDiversityBuffForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "");
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "Buff" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Selbstdefinierte Bedingung
        if KnightTitleRequirements[NextTitle].Custom ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Custom do
                local FileBaseName;
                local Icon = table.copy(KnightTitleRequirements[NextTitle].Custom[i][2]);
                if type(Icon[3]) == "string" then
                    FileBaseName = Icon[3];
                    Icon[3] = 0;
                end
                API.SetIcon(WidgetPos[RequirementsIndex] .. "/Icon", Icon, nil, FileBaseName);
                local IsFulfilled, CurrentAmount, NeededAmount = DoCustomFunctionForKnightTitleSucceed(PlayerID, NextTitle, i);
                if CurrentAmount and NeededAmount then
                    XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                else
                    XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "");
                end
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "Custom" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Dekorationselemente
        if KnightTitleRequirements[NextTitle].DecoratedBuildings ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].DecoratedBuildings do
                local GoodType = KnightTitleRequirements[NextTitle].DecoratedBuildings[i][1];
                SetIcon(WidgetPos[RequirementsIndex].."/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                QSB.RequirementTooltipTypes[RequirementsIndex] = "DecoratedBuildings" ..i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Übrige ausblenden
        for i=RequirementsIndex, 6 do
            XGUIEng.ShowWidget(WidgetPos[i], 0);
        end
    end
end

function ModuleKnightTitleRequirements.Local:OverwriteTooltips()
    GUI_Tooltip.SetNameAndDescription_Orig_QSB_Requirements = GUI_Tooltip.SetNameAndDescription;
    GUI_Tooltip.SetNameAndDescription = function(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean)
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local Selected = GUI.GetSelectedEntity();
        local PlayerID = GUI.GetPlayerID();

        for k,v in pairs(ModuleKnightTitleRequirements.Local.RequirementWidgets) do
            if v .. "/Icon" == XGUIEng.GetWidgetPathByID(CurrentWidgetID) then
                local key = QSB.RequirementTooltipTypes[k];
                local num = tonumber(string.sub(key, string.len(key)));
                if num ~= nil then
                    key = string.sub(key, 1, string.len(key)-1);
                end
                ModuleKnightTitleRequirements.Local:RequirementTooltipWrapped(key, num);
                return;
            end
        end
        GUI_Tooltip.SetNameAndDescription_Orig_QSB_Requirements(_TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName, _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean);
    end

    GUI_Knight.RequiredGoodTooltip = function()
        local key = QSB.RequirementTooltipTypes[2];
        local num = tonumber(string.sub(key, string.len(key)));
        if num ~= nil then
            key = string.sub(key, 1, string.len(key)-1);
        end
        ModuleKnightTitleRequirements.Local:RequirementTooltipWrapped(key, num);
    end

    if Framework.GetGameExtraNo() ~= 0 then
        ModuleKnightTitleRequirements.Local.BuffTypeNames[Buffs.Buff_Gems] = {
            de = "Edelsteine beschaffen",
            en = "Obtain gems",
            fr = "Se procurer des Gemmes",
        }
        ModuleKnightTitleRequirements.Local.BuffTypeNames[Buffs.Buff_Olibanum] = {
            de = "Weihrauch beschaffen",
            en = "Obtain olibanum",
            fr = "Se procurer de l'encens",
        }
        ModuleKnightTitleRequirements.Local.BuffTypeNames[Buffs.Buff_MusicalInstrument] = {
            de = "Muskinstrumente beschaffen",
            en = "Obtain instruments",
            fr = "Se procurer des instruments de musique",
        }
    end
end

function ModuleKnightTitleRequirements.Local:RequirementTooltipWrapped(_key, _i)
    local PlayerID = GUI.GetPlayerID();
    local KnightTitle = Logic.GetKnightTitle(PlayerID);
    local Title = ""
    local Text = "";

    if _key == "Consume" or _key == "Goods" or _key == "DecoratedBuildings" then
        local GoodType     = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local GoodTypeName = Logic.GetGoodTypeName(GoodType);
        local GoodName     = XGUIEng.GetStringTableText("UI_ObjectNames/" .. GoodTypeName);

        if GoodName == nil then
            GoodName = "Goods." .. GoodTypeName;
        end
        Title = GoodName;
        Text  = ModuleKnightTitleRequirements.Local.Description[_key].Text;

    elseif _key == "Products" then
        local GoodCategoryNames = ModuleKnightTitleRequirements.Local.GoodCategoryNames;
        local Category = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local CategoryName = API.Localize(GoodCategoryNames[Category]);

        if CategoryName == nil then
            CategoryName = "ERROR: Name missng!";
        end
        Title = CategoryName;
        Text  = ModuleKnightTitleRequirements.Local.Description[_key].Text;

    elseif _key == "Entities" then
        local EntityType     = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);
        local EntityName = XGUIEng.GetStringTableText("Names/" .. EntityTypeName);

        if EntityName == nil then
            EntityName = "Entities." .. EntityTypeName;
        end

        Title = EntityName;
        Text  = ModuleKnightTitleRequirements.Local.Description[_key].Text;

    elseif _key == "Custom" then
        local Custom = KnightTitleRequirements[KnightTitle+1].Custom[_i];
        Title = Custom[3];
        Text  = Custom[4];

    elseif _key == "Buff" then
        local BuffTypeNames = ModuleKnightTitleRequirements.Local.BuffTypeNames;
        local BuffType = KnightTitleRequirements[KnightTitle+1][_key][_i];
        local BuffTitle = API.Localize(BuffTypeNames[BuffType]);

        if BuffTitle == nil then
            BuffTitle = "ERROR: Name missng!";
        end
        Title = BuffTitle;
        Text  = ModuleKnightTitleRequirements.Local.Description[_key].Text;

    else
        Title = ModuleKnightTitleRequirements.Local.Description[_key].Title;
        Text  = ModuleKnightTitleRequirements.Local.Description[_key].Text;
    end
    API.SetTooltipNormal(API.Localize(Title), API.Localize(Text), nil);
end

-- -------------------------------------------------------------------------- --

ModuleKnightTitleRequirements.Local.RequirementWidgets = {
    [1] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Settlers",
    [2] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Goods",
    [3] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/RichBuildings",
    [4] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Castle",
    [5] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Storehouse",
    [6] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Cathedral",
};

ModuleKnightTitleRequirements.Local.GoodCategoryNames = {
    [GoodCategories.GC_Ammunition]      = {de = "Munition",         en = "Ammunition",      fr = "Munition"},
    [GoodCategories.GC_Animal]          = {de = "Nutztiere",        en = "Livestock",       fr = "Animaux d'élevage"},
    [GoodCategories.GC_Clothes]         = {de = "Kleidung",         en = "Clothes",         fr = "Vêtements"},
    [GoodCategories.GC_Document]        = {de = "Dokumente",        en = "Documents",       fr = "Documents"},
    [GoodCategories.GC_Entertainment]   = {de = "Unterhaltung",     en = "Entertainment",   fr = "Divertissement"},
    [GoodCategories.GC_Food]            = {de = "Nahrungsmittel",   en = "Food",            fr = "Nourriture"},
    [GoodCategories.GC_Gold]            = {de = "Gold",             en = "Gold",            fr = "Or"},
    [GoodCategories.GC_Hygiene]         = {de = "Hygieneartikel",   en = "Hygiene",         fr = "Hygiène"},
    [GoodCategories.GC_Luxury]          = {de = "Dekoration",       en = "Decoration",      fr = "Décoration"},
    [GoodCategories.GC_Medicine]        = {de = "Medizin",          en = "Medicine",        fr = "Médecine"},
    [GoodCategories.GC_None]            = {de = "Nichts",           en = "None",            fr = "Rien"},
    [GoodCategories.GC_RawFood]         = {de = "Nahrungsmittel",   en = "Food",            fr = "Nourriture"},
    [GoodCategories.GC_RawMedicine]     = {de = "Medizin",          en = "Medicine",        fr = "Médecine"},
    [GoodCategories.GC_Research]        = {de = "Forschung",        en = "Research",        fr = "Recherche"},
    [GoodCategories.GC_Resource]        = {de = "Rohstoffe",        en = "Resource",        fr = "Ressources"},
    [GoodCategories.GC_Tools]           = {de = "Werkzeug",         en = "Tools",           fr = "Outils"},
    [GoodCategories.GC_Water]           = {de = "Wasser",           en = "Water",           fr = "Eau"},
    [GoodCategories.GC_Weapon]          = {de = "Waffen",           en = "Weapon",          fr = "Armes"},
};

ModuleKnightTitleRequirements.Local.BuffTypeNames = {
    [Buffs.Buff_ClothesDiversity]        = {de = "Vielfältige Kleidung",        en = "Clothes variety",         fr = "Diversité vestimentaire"},
    [Buffs.Buff_Colour]                  = {de = "Farben beschaffen",           en = "Obtain color",            fr = "Se procurer des couleurs"},
    [Buffs.Buff_Entertainers]            = {de = "Gaukler anheuern",            en = "Hire entertainer",        fr = "Engager des saltimbanques"},
    [Buffs.Buff_EntertainmentDiversity]  = {de = "Vielfältige Unterhaltung",    en = "Entertainment variety",   fr = "Diversité des divertissements"},
    [Buffs.Buff_ExtraPayment]            = {de = "Sonderzahlung",               en = "Extra payment",           fr = "Paiement supplémentaire"},
    [Buffs.Buff_Festival]                = {de = "Fest veranstalten",           en = "Hold Festival",           fr = "Organiser une fête"},
    [Buffs.Buff_FoodDiversity]           = {de = "Vielfältige Nahrung",         en = "Food variety",            fr = "Diversité alimentaire"},
    [Buffs.Buff_HygieneDiversity]        = {de = "Vielfältige Hygiene",         en = "Hygiene variety",         fr = "Diversité hygiénique"},
    [Buffs.Buff_NoTaxes]                 = {de = "Steuerbefreiung",             en = "No taxes",                fr = "Exonération fiscale"},
    [Buffs.Buff_Sermon]                  = {de = "Pregigt abhalten",            en = "Hold sermon",             fr = "Tenir des prêches"},
    [Buffs.Buff_Spice]                   = {de = "Salz beschaffen",             en = "Obtain salt",             fr = "Se procurer du sel"},
};

ModuleKnightTitleRequirements.Local.Description = {
    Settlers = {
        Title = {
            de = "Benötigte Siedler",
            en = "Needed settlers",
            fr = "Settlers nécessaires",
        },
        Text = {
            de = "- Benötigte Menge an Siedlern",
            en = "- Needed number of settlers",
            fr = "- Quantité de settlers nécessaire",
        },
    },

    RichBuildings = {
        Title = {
            de = "Reiche Häuser",
            en = "Rich city buildings",
            fr = "Bâtiments riches",
        },
        Text = {
            de = "- Menge an reichen Stadtgebäuden",
            en = "- Needed amount of rich city buildings",
            fr = "- Quantité de bâtiments de la ville riches",
        },
    },

    Goods = {
        Title = {
            de = "Waren lagern",
            en = "Store Goods",
            fr = "Entreposer des marchandises",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed amount",
            fr = "- Quantité nécessaire",
        },
    },

    FullDecoratedBuildings = {
        Title = {
            de = "Dekorierte Häuser",
            en = "Decorated City buildings",
            fr = "Bâtiments décorés",
        },
        Text = {
            de = "- Menge an voll dekorierten Gebäuden",
            en = "- Amount of full decoraded city buildings",
            fr = "- Quantité de bâtiments entièrement décorés",
        },
    },

    DecoratedBuildings = {
        Title = {
            de = "Dekoration",
            en = "Decoration",
            fr = "Décoration",
        },
        Text = {
            de = "- Menge an Dekorationsgütern in der Siedlung",
            en = "- Amount of decoration goods in settlement",
            fr = "- Quantité de biens de décoration dans la ville",
        },
    },

    Headquarters = {
        Title = {
            de = "Burgstufe",
            en = "Castle level",
            fr = "Niveau du château",
        },
        Text = {
            de = "- Benötigte Ausbauten der Burg",
            en = "- Needed castle upgrades",
            fr = "- Améliorations nécessaires du château",
        },
    },

    Storehouse = {
        Title = {
            de = "Lagerhausstufe",
            en = "Storehouse level",
            fr = "Niveau de l'entrepôt",
        },
        Text = {
            de = "- Benötigte Ausbauten des Lagerhauses",
            en = "- Needed storehouse upgrades",
            fr = "- Améliorations nécessaires de l'entrepôt",
        },
    },

    Cathedrals = {
        Title = {
            de = "Kirchenstufe",
            en = "Cathedral level",
            fr = "Niveau de la cathédrale",
        },
        Text = {
            de = "- Benötigte Ausbauten der Kirche",
            en = "- Needed cathedral upgrades",
            fr = "- Améliorations nécessaires de la cathédrale",
        },
    },

    Reputation = {
        Title = {
            de = "Ruf der Stadt",
            en = "City reputation",
            fr = "Réputation de la ville",
        },
        Text = {
            de = "- Benötigter Ruf der Stadt",
            en = "- Needed city reputation",
            fr = "- Réputation de la ville nécessaire",
        },
    },

    EntityCategoryDefault = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Anzahl",
            en = "- Needed amount",
            fr = "- Nombre requis",
        },
    },

    Cattle = {
        Title = {
            de = "Kühe",
            en = "Cattle",
            fr = "Vaches",
        },
        Text = {
            de = "- Benötigte Menge an Kühen",
            en = "- Needed amount of cattle",
            fr = "- Quantité de vaches nécessaire",
        },
    },

    Sheep = {
        Title = {
            de = "Schafe",
            en = "Sheeps",
            fr = "Moutons",
        },
        Text = {
            de = "- Benötigte Menge an Schafen",
            en = "- Needed amount of sheeps",
            fr = "- Quantité de moutons nécessaire",
        },
    },

    Outposts = {
        Title = {
            de = "Territorien",
            en = "Territories",
            fr = "Territoires",
        },
        Text = {
            de = "- Zu erobernde Territorien",
            en = "- Territories to claim",
            fr = "- Territoires à conquérir",
        },
    },

    CityBuilding = {
        Title = {
            de = "Stadtgebäude",
            en = "City buildings",
            fr = "Bâtiment de la ville",
        },
        Text = {
            de = "- Menge benötigter Stadtgebäude",
            en = "- Needed amount of city buildings",
            fr = "- Quantité de bâtiments urbains nécessaires",
        },
    },

    OuterRimBuilding = {
        Title = {
            de = "Rohstoffgebäude",
            en = "Gatherer",
            fr = "Cueilleur",
        },
        Text = {
            de = "- Menge benötigter Rohstoffgebäude",
            en = "- Needed amount of gatherer",
            fr = "- Quantité de bâtiments de matières premières nécessaires",
        },
    },

    FarmerBuilding = {
        Title = {
            de = "Farmeinrichtungen",
            en = "Farming structure",
            fr = "Installations de la ferme",
        },
        Text = {
            de = "- Menge benötigter Nutzfläche",
            en = "- Needed amount of farming structure",
            fr = "- Quantité de surface utile nécessaire",
        },
    },

    Consume = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Durch Siedler zu konsumierende Menge",
            en = "- Amount to be consumed by the settlers",
            fr = "- Quantité à consommer par les settlers",
        },
    },

    Products = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed amount",
            fr = "- Quantité nécessaire",
        },
    },

    Buff = {
        Title = {
            de = "Bonus aktivieren",
            en = "Activate Buff",
            fr = "Activer bonus",
        },
        Text = {
            de = "- Aktiviere diesen Bonus auf den Ruf der Stadt",
            en = "- Raise the city reputatition with this buff",
            fr = "- Active ce bonus sur la réputation de la ville",
        },
    },

    Leader = {
        Title = {
            de = "Batalione",
            en = "Battalions",
            fr = "Battalions",
        },
        Text = {
            de = "- Menge an Batalionen unterhalten",
            en = "- Battalions you need under your command",
            fr = "- Maintenir une quantité de bataillons",
        },
    },

    Soldiers = {
        Title = {
            de = "Soldaten",
            en = "Soldiers",
            fr = "Soldats",
        },
        Text = {
            de = "- Menge an Streitkräften unterhalten",
            en = "- Soldiers you need under your command",
            fr = "- Maintenir une quantité de forces armées",
        },
    },

    Worker = {
        Title = {
            de = "Arbeiter",
            en = "Workers",
            fr = "Travailleurs",
        },
        Text = {
            de = "- Menge an arbeitender Bevölkerung",
            en = "- Workers you need under your reign",
            fr = "- Quantité de population au travail",
        },
    },

    Entities = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed Amount",
            fr = "- Quantité nécessaire",
        },
    },

    Buildings = {
        Title = {
            de = "Gebäude",
            en = "Buildings",
            fr = "Bâtiments",
        },
        Text = {
            de = "- Gesamtmenge an Gebäuden",
            en = "- Amount of buildings",
            fr = "- Total des bâtiments",
        },
    },

    Weapons = {
        Title = {
            de = "Waffen",
            en = "Weapons",
            fr = "Armes",
        },
        Text = {
            de = "- Benötigte Menge an Waffen",
            en = "- Needed amount of weapons",
            fr = "- Quantité d'armes nécessaire",
        },
    },

    HeavyWeapons = {
        Title = {
            de = "Belagerungsgeräte",
            en = "Siege Engines",
            fr = "Matériel de siège",
        },
        Text = {
            de = "- Benötigte Menge an Belagerungsgeräten",
            en = "- Needed amount of siege engine",
            fr = "- Quantité de matériel de siège nécessaire",
        },
    },

    Spouse = {
        Title = {
            de = "Ehefrauen",
            en = "Spouses",
            fr = "Épouses",
        },
        Text = {
            de = "- Benötigte Anzahl Ehefrauen in der Stadt",
            en = "- Needed amount of spouses in your city",
            fr = "- Nombre d'épouses nécessaires dans la ville",
        },
    },
};

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleKnightTitleRequirements);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Ermöglicht das Anpassen der Aufstiegsbedingungen.
--
-- Die Aufstiegsbedingungen werden in der Funktion InitKnightTitleTables
-- angegeben und bearbeitet.
--
-- <b>Achtung</b>: es können maximal 6 Bedingungen angezeigt werden!
--
-- <p>Mögliche Aufstiegsbedingungen:
-- <ul>
-- <li><b>Entitytyp besitzen</b><br/>
-- Der Spieler muss eine bestimmte Anzahl von Entities eines Typs besitzen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Entities = {
--     {Entities.B_Bakery, 2},
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Entitykategorie besitzen</b><br/>
-- Der Spieler muss eine bestimmte Anzahl von Entities einer Kategorie besitzen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Category = {
--     {EntitiyCategories.CattlePasture, 10},
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Gütertyp besitzen</b><br/>
-- Der Spieler muss Rohstoffe oder Güter eines Typs besitzen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Goods = {
--     {Goods.G_RawFish, 35},
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Produkte erzeugen</b><br/>
-- Der Spieler muss Gebrauchsgegenstände für ein Bedürfnis bereitstellen. Hier
-- werden nicht die Warentypen sonderen deren Kategorie angegeben.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Products = {
--     {GoodCategories.GC_Clothes, 6},
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Güter konsumieren</b><br/>
-- Die Siedler müssen eine Menge einer bestimmten Waren konsumieren.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Consume = {
--     {Goods.G_Bread, 30},
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Buffs aktivieren</b><br/>
-- Der Spieler muss einen Buff aktivieren.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Buff = {
--     Buffs.Buff_FoodDiversity,
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Stadtruf erreichen</b><br/>
-- Der Ruf der Stadt muss einen bestimmten Wert erreichen oder überschreiten.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Reputation = 20
-- </code></pre>
--
-- <li><b>Anzahl an Dekorationen</b><br/>
-- Der Spieler muss mindestens die Anzahl der angegebenen Dekoration besitzen.
-- <code><pre>
-- KnightTitleRequirements[KnightTitles.Mayor].DecoratedBuildings = {
--     {Goods.G_Banner, 9 },
--     ...
-- }
-- </code></pre>
-- </li>
--
-- <li><b>Anzahl voll dekorierter Gebäude</b><br/>
-- Anzahl an Gebäuden, an die alle vier Dekorationen angebracht sein müssen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].FullDecoratedBuildings = 12
-- </code></pre>
-- </li>
--
-- <li><b>Spezialgebäude ausbauen</b><br/>
-- Ein Spezielgebäude muss ausgebaut werden.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Headquarters = 1
-- KnightTitleRequirements[KnightTitles.Mayor].Storehouse = 1
-- KnightTitleRequirements[KnightTitles.Mayor].Cathedrals = 1
-- </code></pre>
-- </li>
--
-- <li><b>Anzahl Siedler</b><br/>
-- Der Spieler benötigt eine Gesamtzahl an Siedlern.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Settlers = 40
-- </code></pre>
-- </li>
--
-- <li><b>Anzahl reiche Stadtgebäude</b><br/>
-- Eine Anzahl an Gebäuden muss durch Einnahmen Reichtum erlangen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].RichBuildings = 30
-- </code></pre>
-- </li>
--
-- <li><b>Benutzerdefiniert</b><br/>
-- Eine benutzerdefinierte Funktion, die entweder als Schalter oder als Zähler
-- fungieren kann und true oder false zurückgeben muss. Soll ein Zähler
-- angezeigt werden, muss nach dem Wahrheitswert der aktuelle und der maximale
-- Wert des Zählers folgen.
-- <pre><code>
-- KnightTitleRequirements[KnightTitles.Mayor].Custom = {
--     {SomeFunction, {1, 1}, "Überschrift", "Beschreibung"}
--     ...
-- }
--
-- -- Funktion prüft Schalter
-- function SomeFunction(_PlayerID, _NextTitle, _Index)
--     return gvMission.MySwitch == true;
-- end
-- -- Funktion prüft Zähler
-- function SomeFunction(_PlayerID, _NextTitle, _Index)
--     return gvMission.MyCounter == 6, gvMission.MyCounter, 6;
-- end
-- </code></pre>
-- </li>
-- </ul></p>
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(1) Benutzerschnittstelle</a></li>
-- </ul>
-- 
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field KnightTitleChanged Der Spieler hat einen neuen Titel erlangt (Parameter: PlayerID, TitleID)
-- @field GoodsConsumed      Güter werden von Siedlern konsumiert (Parameter: ConsumerID, GoodType, BuildingID)
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

-- Internal ----------------------------------------------------------------- --

---
-- Prüft, ob genug Entities in einer bestimmten Kategorie existieren.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Category == nil then
        return;
    end
    if _i then
        local EntityCategory = KnightTitleRequirements[_KnightTitle].Category[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Category[_i][2];

        local ReachedAmount = 0;
        if EntityCategory == EntityCategories.Spouse then
            ReachedAmount = Logic.GetNumberOfSpouses(_PlayerID);
        else
            local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategory)};
            for i=1, #Buildings do
                if Logic.IsBuilding(Buildings[i]) == 1 then
                    if Logic.IsConstructionComplete(Buildings[i]) == 1 then
                        ReachedAmount = ReachedAmount +1;
                    end
                else
                    ReachedAmount = ReachedAmount +1;
                end
            end
        end

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Category do
            bool, reach, need = DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob genug Entities eines bestimmten Typs existieren.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Entities == nil then
        return;
    end
    if _i then
        local EntityType = KnightTitleRequirements[_KnightTitle].Entities[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Entities[_i][2];
        local Buildings = GetPlayerEntities(_PlayerID, EntityType);

        local ReachedAmount = 0;
        for i=1, #Buildings do
            if Logic.IsBuilding(Buildings[i]) == 1 then
                if Logic.IsConstructionComplete(Buildings[i]) == 1 then
                    ReachedAmount = ReachedAmount +1;
                end
            else
                ReachedAmount = ReachedAmount +1;
            end
        end

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Entities do
            bool, reach, need = DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob es genug Einheiten eines Warentyps gibt.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoesNeededNumberOfGoodTypesForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Goods == nil then
        return;
    end
    if _i then
        local GoodType = KnightTitleRequirements[_KnightTitle].Goods[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Goods[_i][2];
        local ReachedAmount = GetPlayerGoodsInSettlement(GoodType, _PlayerID, true);

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Goods do
            bool, reach, need = DoesNeededNumberOfGoodTypesForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob die Siedler genug Einheiten einer Ware konsumiert haben.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoNeededNumberOfConsumedGoodsForKnightTitleExist = function( _PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Consume == nil then
        return;
    end
    if _i then
        QSB.ConsumedGoodsCounter[_PlayerID] = QSB.ConsumedGoodsCounter[_PlayerID] or {};

        local GoodType = KnightTitleRequirements[_KnightTitle].Consume[_i][1];
        local GoodAmount = QSB.ConsumedGoodsCounter[_PlayerID][GoodType] or 0;
        local NeededGoodAmount = KnightTitleRequirements[_KnightTitle].Consume[_i][2];
        if GoodAmount >= NeededGoodAmount then
            return true, GoodAmount, NeededGoodAmount;
        else
            return false, GoodAmount, NeededGoodAmount;
        end
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Consume do
            bool, reach, need = DoNeededNumberOfConsumedGoodsForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return false, reach, need
            end
        end
        return true, reach, need;
    end
end

---
-- Prüft, ob genug Waren der Kategorie hergestellt wurde.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoNumberOfProductsInCategoryExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Products == nil then
        return;
    end
    if _i then
        local GoodAmount = 0;
        local NeedAmount = KnightTitleRequirements[_KnightTitle].Products[_i][2];
        local GoodCategory = KnightTitleRequirements[_KnightTitle].Products[_i][1];
        local GoodsInCategory = {Logic.GetGoodTypesInGoodCategory(GoodCategory)};

        for i=1, #GoodsInCategory do
            GoodAmount = GoodAmount + GetPlayerGoodsInSettlement(GoodsInCategory[i], _PlayerID, true);
        end
        return (GoodAmount >= NeedAmount), GoodAmount, NeedAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Products do
            bool, reach, need = DoNumberOfProductsInCategoryExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob ein bestimmter Buff für den Spieler aktiv ist.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoNeededDiversityBuffForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Buff == nil then
        return;
    end
    if _i then
        local buff = KnightTitleRequirements[_KnightTitle].Buff[_i];
        if Logic.GetBuff(_PlayerID,buff) and Logic.GetBuff(_PlayerID,buff) ~= 0 then
            return true;
        end
        return false;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Buff do
            bool, reach, need = DoNeededDiversityBuffForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob die Custom Function true vermeldet.
--
-- <b>Hinweis</b>: Die Funktion wird innerhalb eines GUI Update aufgerufen.
-- Schreibe daher effizienten Lua Code!
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoCustomFunctionForKnightTitleSucceed = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Custom == nil then
        return;
    end
    if _i then
        return KnightTitleRequirements[_KnightTitle].Custom[_i][1](_PlayerID, _KnightTitle, _i);
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Custom do
            bool, reach, need = DoCustomFunctionForKnightTitleSucceed(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob genug Dekoration eines Typs angebracht wurde.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _i Button Index
-- @within Originalfunktionen
-- @local
--
DoNeededNumberOfDecoratedBuildingsForKnightTitleExist = function( _PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].DecoratedBuildings == nil then
        return
    end

    if _i then
        local CityBuildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}
        local DecorationGoodType = KnightTitleRequirements[_KnightTitle].DecoratedBuildings[_i][1]
        local NeededBuildingsWithDecoration = KnightTitleRequirements[_KnightTitle].DecoratedBuildings[_i][2]
        local BuildingsWithDecoration = 0

        for i=1, #CityBuildings do
            local BuildingID = CityBuildings[i]
            local GoodState = Logic.GetBuildingWealthGoodState(BuildingID, DecorationGoodType)
            if GoodState > 0 then
                BuildingsWithDecoration = BuildingsWithDecoration + 1
            end
        end

        if BuildingsWithDecoration >= NeededBuildingsWithDecoration then
            return true, BuildingsWithDecoration, NeededBuildingsWithDecoration
        else
            return false, BuildingsWithDecoration, NeededBuildingsWithDecoration
        end
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].DecoratedBuildings do
            bool, reach, need = DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

---
-- Prüft, ob die Spezialgebäude weit genug ausgebaut sind.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @param[type=number] _EntityCategory Entity Category
-- @within Originalfunktionen
-- @local
--
DoNeededSpecialBuildingUpgradeForKnightTitleExist = function( _PlayerID, _KnightTitle, _EntityCategory)
    local SpecialBuilding
    local SpecialBuildingName
    if _EntityCategory == EntityCategories.Headquarters then
        SpecialBuilding = Logic.GetHeadquarters(_PlayerID)
        SpecialBuildingName = "Headquarters"
    elseif _EntityCategory == EntityCategories.Storehouse then
        SpecialBuilding = Logic.GetStoreHouse(_PlayerID)
        SpecialBuildingName = "Storehouse"
    elseif _EntityCategory == EntityCategories.Cathedrals then
        SpecialBuilding = Logic.GetCathedral(_PlayerID)
        SpecialBuildingName = "Cathedrals"
    else
        return
    end
    if KnightTitleRequirements[_KnightTitle][SpecialBuildingName] == nil then
        return
    end
    local NeededUpgradeLevel = KnightTitleRequirements[_KnightTitle][SpecialBuildingName]
    if SpecialBuilding ~= nil then
        local SpecialBuildingUpgradeLevel = Logic.GetUpgradeLevel(SpecialBuilding)
        if SpecialBuildingUpgradeLevel >= NeededUpgradeLevel then
            return true, SpecialBuildingUpgradeLevel, NeededUpgradeLevel
        else
            return false, SpecialBuildingUpgradeLevel, NeededUpgradeLevel
        end
    else
        return false, 0, NeededUpgradeLevel
    end
end

---
-- Prüft, ob der Ruf der Stadt hoch genug ist.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @within Originalfunktionen
-- @local
--
DoesNeededCityReputationForKnightTitleExist = function(_PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].Reputation == nil then
        return;
    end
    local NeededAmount = KnightTitleRequirements[_KnightTitle].Reputation;
    if not NeededAmount then
        return;
    end
    local ReachedAmount = math.floor((Logic.GetCityReputation(_PlayerID) * 100) + 0.5);
    if ReachedAmount >= NeededAmount then
        return true, ReachedAmount, NeededAmount;
    end
    return false, ReachedAmount, NeededAmount;
end

---
-- Prüft, ob genug Gebäude vollständig dekoriert sind.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @within Originalfunktionen
-- @local
--
DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist = function( _PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].FullDecoratedBuildings == nil then
        return
    end
    local CityBuildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}
    local NeededBuildingsWithDecoration = KnightTitleRequirements[_KnightTitle].FullDecoratedBuildings
    local BuildingsWithDecoration = 0

    for i=1, #CityBuildings do
        local BuildingID = CityBuildings[i]
        local AmountOfWealthGoodsAtBuilding = 0

        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign  ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Candle) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Ornament  ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if AmountOfWealthGoodsAtBuilding >= 4 then
            BuildingsWithDecoration = BuildingsWithDecoration + 1
        end
    end

    if BuildingsWithDecoration >= NeededBuildingsWithDecoration then
        return true, BuildingsWithDecoration, NeededBuildingsWithDecoration
    else
        return false, BuildingsWithDecoration, NeededBuildingsWithDecoration
    end
end

---
-- Prüft, ob der Spieler befördert werden kann.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @param[type=number] _KnightTitle Nächster Titel
-- @within Originalfunktionen
-- @local
--
CanKnightBePromoted = function(_PlayerID, _KnightTitle)
    if _KnightTitle == nil then
        _KnightTitle = Logic.GetKnightTitle(_PlayerID) + 1;
    end

    if Logic.CanStartFestival(_PlayerID, 1) == true then
        if  KnightTitleRequirements[_KnightTitle] ~= nil
        and DoesNeededNumberOfSettlersForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfGoodsForKnightTitleExist( _PlayerID, _KnightTitle)  ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist( _PlayerID, _KnightTitle, EntityCategories.Headquarters) ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist( _PlayerID, _KnightTitle, EntityCategories.Storehouse) ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist( _PlayerID, _KnightTitle, EntityCategories.Cathedrals)  ~= false
        and DoNeededNumberOfRichBuildingsForKnightTitleExist( _PlayerID, _KnightTitle)  ~= false
        and DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfDecoratedBuildingsForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoesNeededCityReputationForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfGoodTypesForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoNeededDiversityBuffForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoCustomFunctionForKnightTitleSucceed( _PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfConsumedGoodsForKnightTitleExist( _PlayerID, _KnightTitle) ~= false
        and DoNumberOfProductsInCategoryExist( _PlayerID, _KnightTitle) ~= false then
            return true;
        end
    end
    return false;
end

---
-- Der Spieler gewinnt das Spiel
-- @within Originalfunktionen
-- @local
--
VictroryBecauseOfTitle = function()
    QuestTemplate:TerminateEventsAndStuff();
    Victory(g_VictoryAndDefeatType.VictoryMissionComplete);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

--
-- Definiert den Standard der Aufstiegsbedingungen für den Spieler.
--

---
-- Diese Funktion muss entweder in der QSB modifiziert oder sowohl im globalen
-- als auch im lokalen Skript überschrieben werden. Ideal ist laden des
-- angepassten Skriptes als separate Datei. Bei Modifikationen muss das Schema
-- für Aufstiegsbedingungen und Rechtevergabe immer beibehalten werden.
--
-- <b>Hinweis</b>: Diese Funktion wird <b>automatisch</b> vom Code ausgeführt.
-- Du rufst sie <b>niemals</b> selbst auf!
--
-- @within Originalfunktionen
--
-- @usage
-- -- Dies ist ein Beispiel zum herauskopieren. Hier sind die üblichen
-- -- Bedingungen gesetzt. Wenn du diese Funktion in dein Skript kopierst, muss
-- -- sie im globalen und lokalen Skript stehen oder dort geladen werden!
-- InitKnightTitleTables = function()
--     KnightTitles = {}
--     KnightTitles.Knight     = 0
--     KnightTitles.Mayor      = 1
--     KnightTitles.Baron      = 2
--     KnightTitles.Earl       = 3
--     KnightTitles.Marquees   = 4
--     KnightTitles.Duke       = 5
--     KnightTitles.Archduke   = 6
--
--     -- ---------------------------------------------------------------------- --
--     -- Rechte und Pflichten                                                   --
--     -- ---------------------------------------------------------------------- --
--
--     NeedsAndRightsByKnightTitle = {}
--
--     -- Ritter ------------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Knight] = {
--         ActivateNeedForPlayer,
--         {
--             Needs.Nutrition,                                    -- Bedürfnis: Nahrung
--             Needs.Medicine,                                     -- Bedürfnis: Medizin
--         },
--         ActivateRightForPlayer,
--         {
--             Technologies.R_Gathering,                           -- Recht: Rohstoffsammler
--             Technologies.R_Woodcutter,                          -- Recht: Holzfäller
--             Technologies.R_StoneQuarry,                         -- Recht: Steinbruch
--             Technologies.R_HuntersHut,                          -- Recht: Jägerhütte
--             Technologies.R_FishingHut,                          -- Recht: Fischerhütte
--             Technologies.R_CattleFarm,                          -- Recht: Kuhfarm
--             Technologies.R_GrainFarm,                           -- Recht: Getreidefarm
--             Technologies.R_SheepFarm,                           -- Recht: Schaffarm
--             Technologies.R_IronMine,                            -- Recht: Eisenmine
--             Technologies.R_Beekeeper,                           -- Recht: Imkerei
--             Technologies.R_HerbGatherer,                        -- Recht: Kräutersammler
--             Technologies.R_Nutrition,                           -- Recht: Nahrung
--             Technologies.R_Bakery,                              -- Recht: Bäckerei
--             Technologies.R_Dairy,                               -- Recht: Käserei
--             Technologies.R_Butcher,                             -- Recht: Metzger
--             Technologies.R_SmokeHouse,                          -- Recht: Räucherhaus
--             Technologies.R_Clothes,                             -- Recht: Kleidung
--             Technologies.R_Tanner,                              -- Recht: Ledergerber
--             Technologies.R_Weaver,                              -- Recht: Weber
--             Technologies.R_Construction,                        -- Recht: Konstruktion
--             Technologies.R_Wall,                                -- Recht: Mauer
--             Technologies.R_Pallisade,                           -- Recht: Palisade
--             Technologies.R_Trail,                               -- Recht: Pfad
--             Technologies.R_KnockDown,                           -- Recht: Abriss
--             Technologies.R_Sermon,                              -- Recht: Predigt
--             Technologies.R_SpecialEdition,                      -- Recht: Special Edition
--             Technologies.R_SpecialEdition_Pavilion,             -- Recht: Pavilion AeK SE
--         }
--     }
--
--     -- Landvogt ----------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Mayor] = {
--         ActivateNeedForPlayer,
--         {
--             Needs.Clothes,                                      -- Bedürfnis: KLeidung
--         },
--         ActivateRightForPlayer, {
--             Technologies.R_Hygiene,                             -- Recht: Hygiene
--             Technologies.R_Soapmaker,                           -- Recht: Seifenmacher
--             Technologies.R_BroomMaker,                          -- Recht: Besenmacher
--             Technologies.R_Military,                            -- Recht: Militär
--             Technologies.R_SwordSmith,                          -- Recht: Schwertschmied
--             Technologies.R_Barracks,                            -- Recht: Schwertkämpferkaserne
--             Technologies.R_Thieves,                             -- Recht: Diebe
--             Technologies.R_SpecialEdition_StatueFamily,         -- Recht: Familienstatue Aek SE
--         },
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--     -- Baron -------------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Baron] = {
--         ActivateNeedForPlayer,
--         {
--             Needs.Hygiene,                                      -- Bedürfnis: Hygiene
--         },
--         ActivateRightForPlayer, {
--             Technologies.R_SiegeEngineWorkshop,                 -- Recht: Belagerungswaffenschmied
--             Technologies.R_BatteringRam,                        -- Recht: Ramme
--             Technologies.R_Medicine,                            -- Recht: Medizin
--             Technologies.R_Entertainment,                       -- Recht: Unterhaltung
--             Technologies.R_Tavern,                              -- Recht: Taverne
--             Technologies.R_Festival,                            -- Recht: Fest
--             Technologies.R_Street,                              -- Recht: Straße
--             Technologies.R_SpecialEdition_Column,               -- Recht: Säule AeK SE
--         },
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--     -- Graf --------------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Earl] = {
--         ActivateNeedForPlayer,
--         {
--             Needs.Entertainment,                                -- Bedürfnis: Unterhaltung
--             Needs.Prosperity,                                   -- Bedürfnis: Reichtum
--         },
--         ActivateRightForPlayer, {
--             Technologies.R_BowMaker,                            -- Recht: Bogenmacher
--             Technologies.R_BarracksArchers,                     -- Recht: Bogenschützenkaserne
--             Technologies.R_Baths,                               -- Recht: Badehaus
--             Technologies.R_AmmunitionCart,                      -- Recht: Munitionswagen
--             Technologies.R_Prosperity,                          -- Recht: Reichtum
--             Technologies.R_Taxes,                               -- Recht: Steuern einstellen
--             Technologies.R_Ballista,                            -- Recht: Mauerkatapult
--             Technologies.R_SpecialEdition_StatueSettler,        -- Recht: Siedlerstatue AeK SE
--         },
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--     -- Marquees ----------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Marquees] = {
--         ActivateNeedForPlayer,
--         {
--             Needs.Wealth,                                       -- Bedürfnis: Verschönerung
--         },
--         ActivateRightForPlayer, {
--             Technologies.R_Theater,                             -- Recht: Theater
--             Technologies.R_Wealth,                              -- Recht: Schmuckgebäude
--             Technologies.R_BannerMaker,                         -- Recht: Bannermacher
--             Technologies.R_SiegeTower,                          -- Recht: Belagerungsturm
--             Technologies.R_SpecialEdition_StatueProduction,     -- Recht: Produktionsstatue AeK SE
--         },
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--     -- Herzog ------------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Duke] = {
--         ActivateNeedForPlayer, nil,
--         ActivateRightForPlayer, {
--             Technologies.R_Catapult,                            -- Recht: Katapult
--             Technologies.R_Carpenter,                           -- Recht: Tischler
--             Technologies.R_CandleMaker,                         -- Recht: Kerzenmacher
--             Technologies.R_Blacksmith,                          -- Recht: Schmied
--             Technologies.R_SpecialEdition_StatueDario,          -- Recht: Dariostatue AeK SE
--         },
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--     -- Erzherzog ---------------------------------------------------------------
--
--     NeedsAndRightsByKnightTitle[KnightTitles.Archduke] = {
--         ActivateNeedForPlayer,nil,
--         ActivateRightForPlayer, {
--             Technologies.R_Victory                              -- Sieg
--         },
--         -- VictroryBecauseOfTitle,                              -- Sieg wegen Titel
--         StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
--     }
--
--
--
--     -- Reich des Ostens --------------------------------------------------------
--
--     if g_GameExtraNo >= 1 then
--         local TechnologiesTableIndex = 4;
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Cistern);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Beautification_Brazier);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Beautification_Shrine);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],Technologies.R_Beautification_Pillar);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_StoneBench);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_Vase);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],Technologies.R_Beautification_Sundial);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],Technologies.R_Beautification_TriumphalArch);
--         table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],Technologies.R_Beautification_VictoryColumn);
--     end
--
--
--
--     -- ---------------------------------------------------------------------- --
--     -- Bedingungen                                                            --
--     -- ---------------------------------------------------------------------- --
--
--     KnightTitleRequirements = {}
--
--     -- Ritter ------------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Mayor] = {}
--     KnightTitleRequirements[KnightTitles.Mayor].Headquarters = 1
--     KnightTitleRequirements[KnightTitles.Mayor].Settlers = 10
--     KnightTitleRequirements[KnightTitles.Mayor].Products = {
--         {GoodCategories.GC_Clothes, 6},
--     }
--
--     -- Baron -------------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Baron] = {}
--     KnightTitleRequirements[KnightTitles.Baron].Settlers = 30
--     KnightTitleRequirements[KnightTitles.Baron].Headquarters = 1
--     KnightTitleRequirements[KnightTitles.Baron].Storehouse = 1
--     KnightTitleRequirements[KnightTitles.Baron].Cathedrals = 1
--     KnightTitleRequirements[KnightTitles.Baron].Products = {
--         {GoodCategories.GC_Hygiene, 12},
--     }
--
--     -- Graf --------------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Earl] = {}
--     KnightTitleRequirements[KnightTitles.Earl].Settlers = 50
--     KnightTitleRequirements[KnightTitles.Earl].Headquarters = 2
--     KnightTitleRequirements[KnightTitles.Earl].Goods = {
--         {Goods.G_Beer, 18},
--     }
--
--     -- Marquess ----------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Marquees] = {}
--     KnightTitleRequirements[KnightTitles.Marquees].Settlers = 70
--     KnightTitleRequirements[KnightTitles.Marquees].Headquarters = 2
--     KnightTitleRequirements[KnightTitles.Marquees].Storehouse = 2
--     KnightTitleRequirements[KnightTitles.Marquees].Cathedrals = 2
--     KnightTitleRequirements[KnightTitles.Marquees].RichBuildings = 20
--
--     -- Herzog ------------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Duke] = {}
--     KnightTitleRequirements[KnightTitles.Duke].Settlers = 90
--     KnightTitleRequirements[KnightTitles.Duke].Storehouse = 2
--     KnightTitleRequirements[KnightTitles.Duke].Cathedrals = 2
--     KnightTitleRequirements[KnightTitles.Duke].Headquarters = 3
--     KnightTitleRequirements[KnightTitles.Duke].DecoratedBuildings = {
--         {Goods.G_Banner, 9 },
--     }
--
--     -- Erzherzog ---------------------------------------------------------------
--
--     KnightTitleRequirements[KnightTitles.Archduke] = {}
--     KnightTitleRequirements[KnightTitles.Archduke].Settlers = 150
--     KnightTitleRequirements[KnightTitles.Archduke].Storehouse = 3
--     KnightTitleRequirements[KnightTitles.Archduke].Cathedrals = 3
--     KnightTitleRequirements[KnightTitles.Archduke].Headquarters = 3
--     KnightTitleRequirements[KnightTitles.Archduke].RichBuildings = 30
--     KnightTitleRequirements[KnightTitles.Archduke].FullDecoratedBuildings = 30
--
--     -- Einstellungen Aktivieren
--     CreateTechnologyKnightTitleTable()
-- end
--
InitKnightTitleTables = function()
    KnightTitles = {}
    KnightTitles.Knight     = 0
    KnightTitles.Mayor      = 1
    KnightTitles.Baron      = 2
    KnightTitles.Earl       = 3
    KnightTitles.Marquees   = 4
    KnightTitles.Duke       = 5
    KnightTitles.Archduke   = 6

    -- ---------------------------------------------------------------------- --
    -- Rechte und Pflichten                                                   --
    -- ---------------------------------------------------------------------- --

    NeedsAndRightsByKnightTitle = {}

    -- Ritter ------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Knight] = {
        ActivateNeedForPlayer,
        {
            Needs.Nutrition,                                    -- Bedürfnis: Nahrung
            Needs.Medicine,                                     -- Bedürfnis: Medizin
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Gathering,                           -- Recht: Rohstoffsammler
            Technologies.R_Woodcutter,                          -- Recht: Holzfäller
            Technologies.R_StoneQuarry,                         -- Recht: Steinbruch
            Technologies.R_HuntersHut,                          -- Recht: Jägerhütte
            Technologies.R_FishingHut,                          -- Recht: Fischerhütte
            Technologies.R_CattleFarm,                          -- Recht: Kuhfarm
            Technologies.R_GrainFarm,                           -- Recht: Getreidefarm
            Technologies.R_SheepFarm,                           -- Recht: Schaffarm
            Technologies.R_IronMine,                            -- Recht: Eisenmine
            Technologies.R_Beekeeper,                           -- Recht: Imkerei
            Technologies.R_HerbGatherer,                        -- Recht: Kräutersammler
            Technologies.R_Nutrition,                           -- Recht: Nahrung
            Technologies.R_Bakery,                              -- Recht: Bäckerei
            Technologies.R_Dairy,                               -- Recht: Käserei
            Technologies.R_Butcher,                             -- Recht: Metzger
            Technologies.R_SmokeHouse,                          -- Recht: Räucherhaus
            Technologies.R_Clothes,                             -- Recht: Kleidung
            Technologies.R_Tanner,                              -- Recht: Ledergerber
            Technologies.R_Weaver,                              -- Recht: Weber
            Technologies.R_Construction,                        -- Recht: Konstruktion
            Technologies.R_Wall,                                -- Recht: Mauer
            Technologies.R_Pallisade,                           -- Recht: Palisade
            Technologies.R_Trail,                               -- Recht: Pfad
            Technologies.R_KnockDown,                           -- Recht: Abriss
            Technologies.R_Sermon,                              -- Recht: Predigt
            Technologies.R_SpecialEdition,                      -- Recht: Special Edition
            Technologies.R_SpecialEdition_Pavilion,             -- Recht: Pavilion AeK SE
        }
    }

    -- Landvogt ----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Mayor] = {
        ActivateNeedForPlayer,
        {
            Needs.Clothes,                                      -- Bedürfnis: KLeidung
        },
        ActivateRightForPlayer, {
            Technologies.R_Hygiene,                             -- Recht: Hygiene
            Technologies.R_Soapmaker,                           -- Recht: Seifenmacher
            Technologies.R_BroomMaker,                          -- Recht: Besenmacher
            Technologies.R_Military,                            -- Recht: Militär
            Technologies.R_SwordSmith,                          -- Recht: Schwertschmied
            Technologies.R_Barracks,                            -- Recht: Schwertkämpferkaserne
            Technologies.R_Thieves,                             -- Recht: Diebe
            Technologies.R_SpecialEdition_StatueFamily,         -- Recht: Familienstatue Aek SE
        },
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }

    -- Baron -------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Baron] = {
        ActivateNeedForPlayer,
        {
            Needs.Hygiene,                                      -- Bedürfnis: Hygiene
        },
        ActivateRightForPlayer, {
            Technologies.R_SiegeEngineWorkshop,                 -- Recht: Belagerungswaffenschmied
            Technologies.R_BatteringRam,                        -- Recht: Ramme
            Technologies.R_Medicine,                            -- Recht: Medizin
            Technologies.R_Entertainment,                       -- Recht: Unterhaltung
            Technologies.R_Tavern,                              -- Recht: Taverne
            Technologies.R_Festival,                            -- Recht: Fest
            Technologies.R_Street,                              -- Recht: Straße
            Technologies.R_SpecialEdition_Column,               -- Recht: Säule AeK SE
        },
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }

    -- Graf --------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Earl] = {
        ActivateNeedForPlayer,
        {
            Needs.Entertainment,                                -- Bedürfnis: Unterhaltung
            Needs.Prosperity,                                   -- Bedürfnis: Reichtum
        },
        ActivateRightForPlayer, {
            Technologies.R_BowMaker,                            -- Recht: Bogenmacher
            Technologies.R_BarracksArchers,                     -- Recht: Bogenschützenkaserne
            Technologies.R_Baths,                               -- Recht: Badehaus
            Technologies.R_AmmunitionCart,                      -- Recht: Munitionswagen
            Technologies.R_Prosperity,                          -- Recht: Reichtum
            Technologies.R_Taxes,                               -- Recht: Steuern einstellen
            Technologies.R_Ballista,                            -- Recht: Mauerkatapult
            Technologies.R_SpecialEdition_StatueSettler,        -- Recht: Siedlerstatue AeK SE
        },
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }

    -- Marquees ----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Marquees] = {
        ActivateNeedForPlayer,
        {
            Needs.Wealth,                                       -- Bedürfnis: Verschönerung
        },
        ActivateRightForPlayer, {
            Technologies.R_Theater,                             -- Recht: Theater
            Technologies.R_Wealth,                              -- Recht: Schmuckgebäude
            Technologies.R_BannerMaker,                         -- Recht: Bannermacher
            Technologies.R_SiegeTower,                          -- Recht: Belagerungsturm
            Technologies.R_SpecialEdition_StatueProduction,     -- Recht: Produktionsstatue AeK SE
        },
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }

    -- Herzog ------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Duke] = {
        ActivateNeedForPlayer, nil,
        ActivateRightForPlayer, {
            Technologies.R_Catapult,                            -- Recht: Katapult
            Technologies.R_Carpenter,                           -- Recht: Tischler
            Technologies.R_CandleMaker,                         -- Recht: Kerzenmacher
            Technologies.R_Blacksmith,                          -- Recht: Schmied
            Technologies.R_SpecialEdition_StatueDario,          -- Recht: Dariostatue AeK SE
        },
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }

    -- Erzherzog ---------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Archduke] = {
        ActivateNeedForPlayer,nil,
        ActivateRightForPlayer, {
            Technologies.R_Victory                              -- Sieg
        },
        -- VictroryBecauseOfTitle,                              -- Sieg wegen Titel
        StartKnightsPromotionCelebration                        -- Beförderungsfest aktivieren
    }



    -- Reich des Ostens --------------------------------------------------------

    if g_GameExtraNo >= 1 then
        local TechnologiesTableIndex = 4;
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Cistern);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Beautification_Brazier);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Beautification_Shrine);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],Technologies.R_Beautification_Pillar);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_StoneBench);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_Vase);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],Technologies.R_Beautification_Sundial);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],Technologies.R_Beautification_TriumphalArch);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],Technologies.R_Beautification_VictoryColumn);
    end



    -- ---------------------------------------------------------------------- --
    -- Bedingungen                                                            --
    -- ---------------------------------------------------------------------- --

    KnightTitleRequirements = {}

    -- Ritter ------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Mayor] = {}
    KnightTitleRequirements[KnightTitles.Mayor].Headquarters = 1
    KnightTitleRequirements[KnightTitles.Mayor].Settlers = 10
    KnightTitleRequirements[KnightTitles.Mayor].Products = {
        {GoodCategories.GC_Clothes, 6},
    }

    -- Baron -------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Baron] = {}
    KnightTitleRequirements[KnightTitles.Baron].Settlers = 30
    KnightTitleRequirements[KnightTitles.Baron].Headquarters = 1
    KnightTitleRequirements[KnightTitles.Baron].Storehouse = 1
    KnightTitleRequirements[KnightTitles.Baron].Cathedrals = 1
    KnightTitleRequirements[KnightTitles.Baron].Products = {
        {GoodCategories.GC_Hygiene, 12},
    }

    -- Graf --------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Earl] = {}
    KnightTitleRequirements[KnightTitles.Earl].Settlers = 50
    KnightTitleRequirements[KnightTitles.Earl].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Earl].Goods = {
        {Goods.G_Beer, 18},
    }

    -- Marquess ----------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Marquees] = {}
    KnightTitleRequirements[KnightTitles.Marquees].Settlers = 70
    KnightTitleRequirements[KnightTitles.Marquees].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Marquees].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Marquees].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Marquees].RichBuildings = 20

    -- Herzog ------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Duke] = {}
    KnightTitleRequirements[KnightTitles.Duke].Settlers = 90
    KnightTitleRequirements[KnightTitles.Duke].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Duke].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Duke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Duke].DecoratedBuildings = {
        {Goods.G_Banner, 9 },
    }

    -- Erzherzog ---------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Archduke] = {}
    KnightTitleRequirements[KnightTitles.Archduke].Settlers = 150
    KnightTitleRequirements[KnightTitles.Archduke].Storehouse = 3
    KnightTitleRequirements[KnightTitles.Archduke].Cathedrals = 3
    KnightTitleRequirements[KnightTitles.Archduke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Archduke].RichBuildings = 30
    KnightTitleRequirements[KnightTitles.Archduke].FullDecoratedBuildings = 30

    -- Einstellungen Aktivieren
    CreateTechnologyKnightTitleTable()
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleQuest = {
    Properties = {
        Name = "ModuleQuest",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {
        ExternalTriggerConditions = {},
        ExternalTimerConditions = {},
        ExternalDecisionConditions = {},
        SegmentsOfQuest = {},
    },
    Local  = {},

    Shared = {},
}

QSB.SegmentResult = {
    Success = 1,
    Failure = 2,
    Ignore  = 3,
}

-- -------------------------------------------------------------------------- --
-- Global

function ModuleQuest.Global:OnGameStart()
    Quest_Loop = self.QuestLoop;
    self:OverrideKernelQuestApi();

    -- TODO: Stop goals for cinematics
    -- TODO: Stop triggers for cinematics
    -- TODO: Stop timers for cinematics
end

function ModuleQuest.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleQuest.Global:CreateNestedQuest(_Data)
    if not _Data.Segments then
        return;
    end
    -- Add behavior to check on segments
    table.insert(
        _Data,
        Goal_MapScriptFunction(self:GetCheckQuestSegmentsInlineGoal(), _Data.Name)
    )
    -- Create quest
    local Name = self:CreateSimpleQuest(_Data);
    if Name ~= nil then
        Quests[GetQuestID(Name)].Visible = false;
        self.SegmentsOfQuest[Name] = {};
        -- Create segments
        for i= 1, #_Data.Segments, 1 do
            self:CreateSegmentForSegmentedQuest(_Data.Segments[i], Name, i);
        end
    end
    return Name;
end

function ModuleQuest.Global:CreateSegmentForSegmentedQuest(_Data, _ParentName, _Index)
    local Name = _Data.Name or _ParentName.. "@Segment" .._Index;
    local Parent = Quests[GetQuestID(_ParentName)];

    local QuestDescription = {
        Name        = Name,
        Segments    = _Data.Segments,
        Result      = _Data.Result or QSB.SegmentResult.Success,
        Sender      = _Data.Sender or Parent.SendingPlayer,
        Receiver    = _Data.Receiver or Parent.ReceivingPlayer,
        Time        = _Data.Time,
        Suggestion  = _Data.Suggestion,
        Success     = _Data.Success,
        Failure     = _Data.Failure,
        Description = _Data.Description,
        Loop        = _Data.Loop,
        Callback    = _Data.Callback,
    };
    for i= 1, #_Data do
        table.insert(QuestDescription, _Data[i]);
    end

    table.insert(QuestDescription, Trigger_OnQuestActive(_ParentName, 0));
    if QuestDescription.Segments then
        self:CreateNestedQuest(QuestDescription);
    else
        self:CreateSimpleQuest(QuestDescription);
    end
    table.insert(self.SegmentsOfQuest[_ParentName], QuestDescription);
end

function ModuleQuest.Global:GetCheckQuestSegmentsInlineGoal()
    return function (_QuestName)
        local AllSegmentsConcluded = true;
        local SegmentList = ModuleQuest.Global.SegmentsOfQuest[_QuestName];
        for i= 1, #SegmentList, 1 do
            local SegmentQuest = Quests[GetQuestID(SegmentList[i].Name)];
            -- Non existing segment fails quest
            if not SegmentQuest then
                return false;
            end
            -- Not expectec result of segment fails quest
            if SegmentQuest.State == QuestState.Over and SegmentQuest.Result ~= QuestResult.Interrupted then
                if SegmentList[i].Result == QSB.SegmentResult.Success and SegmentQuest.Result ~= QuestResult.Success then
                    ModuleQuest.Global:AbortAllQuestSegments(_QuestName);
                    return false;
                end
                if SegmentList[i].Result == QSB.SegmentResult.Failure and SegmentQuest.Result ~= QuestResult.Failure then
                    ModuleQuest.Global:AbortAllQuestSegments(_QuestName);
                    return false;
                end
            end
            -- Check if segment is concluded
            if SegmentQuest.State ~= QuestState.Over then
                AllSegmentsConcluded = false;
            end
        end
        -- Success after all segments have been completed
        if AllSegmentsConcluded then
            return true;
        end
    end;
end

function ModuleQuest.Global:AbortAllQuestSegments(_QuestName)
    for i= 1, #self.SegmentsOfQuest[_QuestName], 1 do
        local SegmentName = self.SegmentsOfQuest[_QuestName][i].Name;
        if API.IsValidQuest(_QuestName) and Quests[GetQuestID(SegmentName)].State ~= QuestState.Over then
            API.StopQuest(SegmentName, true);
        end
    end
end

function ModuleQuest.Global:OverrideKernelQuestApi()
    API.FailQuest_Orig_ModuleQuest = API.FailQuest;
    API.FailQuest = function(_QuestName, _NoMessage)
        -- Fail segments of quest fist
        if ModuleQuest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(ModuleQuest.Global.SegmentsOfQuest[_QuestName]) do
                if API.IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    API.FailQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with failing
        API.FailQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    API.RestartQuest_Orig_ModuleQuest = API.RestartQuest;
    API.RestartQuest = function(_QuestName, _NoMessage)
        -- Restart segments of quest first
        if ModuleQuest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(ModuleQuest.Global.SegmentsOfQuest[_QuestName]) do
                if API.IsValidQuest(v.Name) then
                    API.StopQuest_Orig_ModuleQuest(v.Name, true);
                    API.RestartQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with restarting
        API.RestartQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    API.StartQuest_Orig_ModuleQuest = API.StartQuest;
    API.StartQuest = function(_QuestName, _NoMessage)
        -- Start segments of quest first
        if ModuleQuest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(ModuleQuest.Global.SegmentsOfQuest[_QuestName]) do
                if API.IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    API.StartQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with starting
        API.StartQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    API.StopQuest_Orig_ModuleQuest = API.StopQuest;
    API.StopQuest = function(_QuestName, _NoMessage)
        -- Stop segments of quest first
        if ModuleQuest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(ModuleQuest.Global.SegmentsOfQuest[_QuestName]) do
                if API.IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    API.StopQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with stopping
        API.StopQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    API.WinQuest_Orig_ModuleQuest = API.WinQuest;
    API.WinQuest = function(_QuestName, _NoMessage)
        -- Stop segments of quest first
        if ModuleQuest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(ModuleQuest.Global.SegmentsOfQuest[_QuestName]) do
                if API.IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    API.StopQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with winning
        API.WinQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end
end

function ModuleQuest.Global:CreateSimpleQuest(_Data)
    if not _Data.Name then
        QSB.AutomaticQuestNameCounter = (QSB.AutomaticQuestNameCounter or 0) +1;
        _Data.Name = string.format("AutoNamed_Quest_%d", QSB.AutomaticQuestNameCounter);
    end
    if not self:QuestValidateQuestName(_Data.Name) then
        error("Quest '"..tostring(_Data.Name).."': invalid questname! Contains forbidden characters!");
        return;
    end

    -- Fill quest data
    local QuestData = {
        _Data.Name,
        (_Data.Sender ~= nil and _Data.Sender) or 1,
        (_Data.Receiver ~= nil and _Data.Receiver) or 1,
        {},
        {},
        (_Data.Time ~= nil and _Data.Time) or 0,
        {},
        {},
        _Data.Callback,
        _Data.Loop,
        _Data.Visible == true or _Data.Suggestion ~= nil,
        _Data.EndMessage == true or (_Data.Failure ~= nil or _Data.Success ~= nil),
        API.ConvertPlaceholders((type(_Data.Description) == "table" and API.Localize(_Data.Description)) or _Data.Description),
        API.ConvertPlaceholders((type(_Data.Suggestion) == "table" and API.Localize(_Data.Suggestion)) or _Data.Suggestion),
        API.ConvertPlaceholders((type(_Data.Success) == "table" and API.Localize(_Data.Success)) or _Data.Success),
        API.ConvertPlaceholders((type(_Data.Failure) == "table" and API.Localize(_Data.Failure)) or _Data.Failure)
    };

    -- Validate data
    if not self:QuestValidateQuestData(QuestData) then
        error("ModuleQuest: Failed to vaidate quest data. Table has been copied to log.");
        API.DumpTable(QuestData, "Quest");
        return;
    end

    -- Behaviour
    for k,v in pairs(_Data) do
        if tonumber(k) ~= nil then
            if type(v) == "table" then
                if v.GetGoalTable then
                    table.insert(QuestData[4], v:GetGoalTable());

                    local Idx = #QuestData[4];
                    QuestData[4][Idx].Context            = v;
                    QuestData[4][Idx].FuncOverrideIcon   = QuestData[4][Idx].Context.GetIcon;
                    QuestData[4][Idx].FuncOverrideMsgKey = QuestData[4][Idx].Context.GetMsgKey;
                elseif v.GetReprisalTable then
                    table.insert(QuestData[8], v:GetReprisalTable());
                elseif v.GetRewardTable then
                    table.insert(QuestData[7], v:GetRewardTable());
                else
                    table.insert(QuestData[5], v:GetTriggerTable());
                end
            end
        end
    end

    -- Default goal
    if #QuestData[4] == 0 then
        table.insert(QuestData[4], {Objective.Dummy});
    end
    -- Default trigger
    if #QuestData[5] == 0 then
        table.insert(QuestData[5], {Triggers.Time, 0 });
    end
    -- Enough space behavior
    if QuestData[11] then
        table.insert(QuestData[5], self:GetFreeSpaceInlineTrigger());
    end

    -- Create quest
    local QuestID, Quest = QuestTemplate:New(unpack(QuestData, 1, 16));
    Quest.MsgTableOverride = _Data.MSGKeyOverwrite;
    Quest.IconOverride = _Data.IconOverwrite;
    Quest.QuestInfo = _Data.InfoText;
    Quest.Arguments = (_Data.Arguments ~= nil and table.copy(_Data.Arguments)) or {};
    return _Data.Name, Quests[0];
end

function ModuleQuest.Global:QuestValidateQuestData(_Data)
    return (
        (type(_Data[1]) == "string" and self:QuestValidateQuestName(_Data[1]) and Quests[GetQuestID(_Data[1])] == nil) and
        (type(_Data[2]) == "number" and _Data[2] >= 1 and _Data[2] <= 8) and
        (type(_Data[3]) == "number" and _Data[3] >= 1 and _Data[3] <= 8) and
        (type(_Data[6]) == "number" and _Data[6] >= 0) and
        ((_Data[9] ~= nil and type(_Data[9]) == "function") or (_Data[9] == nil)) and
        ((_Data[10] ~= nil and type(_Data[10]) == "function") or (_Data[10] == nil)) and
        (type(_Data[11]) == "boolean") and
        (type(_Data[12]) == "boolean") and
        ((_Data[13] ~= nil and type(_Data[13]) == "string") or (_Data[13] == nil)) and
        ((_Data[14] ~= nil and type(_Data[14]) == "string") or (_Data[14] == nil)) and
        ((_Data[15] ~= nil and type(_Data[15]) == "string") or (_Data[15] == nil)) and
        ((_Data[16] ~= nil and type(_Data[16]) == "string") or (_Data[16] == nil))
    );
end

function ModuleQuest.Global:QuestValidateQuestName(_Name)
    return string.find(_Name, "^[A-Za-z0-9_ @ÄÖÜäöüß]+$") ~= nil;
end

-- This prevents from triggering a quest when all slots are occupied. But the
-- mapper who uses this automation must also keep in mind that they might soft
-- lock the game if fully relying on this trigger without thinking! This is
-- only here to ensure functionality in case of errors and NOT to support the
-- sloth of mappers!
-- Also this technically is a bugfix but can not be put into the kernel.
function ModuleQuest.Global:GetFreeSpaceInlineTrigger()
    return {
        Triggers.Custom2, {
            {},
            function(_Data, _Quest)
                local VisbleQuests = 0;
                if Quests[0] > 0 then
                    for i= 1, Quests[0], 1 do
                        if Quests[i].State == QuestState.Active and Quests[i].Visible == true then
                            VisbleQuests = VisbleQuests +1;
                        end
                    end
                end
                return VisbleQuests < 6;
            end
        }
    };
end

-- -------------------------------------------------------------------------- --
-- Quest Loop

function ModuleQuest.Global.QuestLoop(_arguments)
    local self = JobQueue_GetParameter(_arguments);
    if self.LoopCallback ~= nil then
        self:LoopCallback();
    end
    if self.State == QuestState.NotTriggered then
        local triggered = true;
        -- Are triggers active?
        for i= 1, #ModuleQuest.Global.ExternalTriggerConditions, 1 do
            if not ModuleQuest.Global.ExternalTriggerConditions[i](self.ReceivingPlayer, self) then
                triggered = false;
                break;
            end
        end
        -- Normal condition
        if triggered then
            for i = 1, self.Triggers[0] do
                -- Write Trigger to Log
                local Text = ModuleQuest.Global:SerializeBehavior(self.Triggers[i], Triggers.Custom2, 4);
                if Text then
                    debug("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Check Trigger
                triggered = triggered and self:IsTriggerActive(self.Triggers[i]);
            end
        end
        if triggered then
            self:SetMsgKeyOverride();
            self:SetIconOverride();
            self:Trigger();
        end
    elseif self.State == QuestState.Active then
        -- Do timers tick?
        for i= 1, #ModuleQuest.Global.ExternalTimerConditions, 1 do
            if not ModuleQuest.Global.ExternalTimerConditions[i](self.ReceivingPlayer, self) then
                self.StartTime = self.StartTime +1;
                break;
            end
        end
        -- Are goals checked?
        local CheckBehavior = true;
        for i= 1, #ModuleQuest.Global.ExternalDecisionConditions, 1 do
            if not ModuleQuest.Global.ExternalDecisionConditions[i](self.ReceivingPlayer, self) then
                CheckBehavior = false;
                break;
            end
        end
        if CheckBehavior then
            local allTrue = true;
            local anyFalse = false;
            for i = 1, self.Objectives[0] do
                -- Write Trigger to Log
                local Text = ModuleQuest.Global:SerializeBehavior(self.Objectives[i], Objective.Custom2, 1);
                if Text then
                    debug("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Check Goal
                local completed = self:IsObjectiveCompleted(self.Objectives[i]);
                if self.Objectives[i].Type == Objective.Deliver and completed == nil then
                    if self.Objectives[i].Data[4] == nil then
                        self.Objectives[i].Data[4] = 0;
                    end
                    if self.Objectives[i].Data[3] ~= nil then
                        self.Objectives[i].Data[4] = self.Objectives[i].Data[4] + 1;
                    end
                    local st = self.StartTime;
                    local sd = self.Duration;
                    local dt = self.Objectives[i].Data[4];
                    local sum = self.StartTime + self.Duration - self.Objectives[i].Data[4];
                    if self.Duration > 0 and self.StartTime + self.Duration + self.Objectives[i].Data[4] < Logic.GetTime() then
                        completed = false;
                    end
                else
                    if self.Duration > 0 and self.StartTime + self.Duration < Logic.GetTime() then
                        if completed == nil and
                            (self.Objectives[i].Type == Objective.Protect or self.Objectives[i].Type == Objective.Dummy or self.Objectives[i].Type == Objective.NoChange) then
                            completed = true;
                        elseif completed == nil or self.Objectives[i].Type == Objective.DummyFail then
                            completed = false;
                    end
                    end
                end
                allTrue = (completed == true) and allTrue;
                anyFalse = completed == false or anyFalse;
            end
            if allTrue then
                self:Success();
            elseif anyFalse then
                self:Fail();
            end
        end
    else
        if self.IsEventQuest == true then
            Logic.ExecuteInLuaLocalState("StopEventMusic(nil, "..self.ReceivingPlayer..")");
        end
        if self.Result == QuestResult.Success then
            for i = 1, self.Rewards[0] do
                -- Write Trigger to Log
                local Text = ModuleQuest.Global:SerializeBehavior(self.Rewards[i], Reward.Custom, 3);
                if Text then
                    debug("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Add Reward
                self:AddReward(self.Rewards[i]);
            end
        elseif self.Result == QuestResult.Failure then
            for i = 1, self.Reprisals[0] do
                -- Write Trigger to Log
                local Text = ModuleQuest.Global:SerializeBehavior(self.Reprisals[i], Reprisal.Custom, 3);
                if Text then
                    debug("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Add Reward
                self:AddReprisal(self.Reprisals[i]);
            end
        end
        if self.EndCallback ~= nil then
            self:EndCallback();
        end
        return true;
    end
end

function ModuleQuest.Global:SerializeBehavior(_Data, _CustomType, _Typ)
    local BehaviorType = "Objective";
    local BehaTable = Objective;
    if _Typ == 2 then
        BehaviorType = "Reprisal";
        BehaTable = Reprisal;
    elseif _Typ == 3 then
        BehaviorType = "Reward";
        BehaTable = Reward;
    elseif _Typ == 4 then
        BehaviorType = "Trigger";
        BehaTable = Triggers;
    end

    local Info = "Running {";
    local Beha = GetNameOfKeyInTable(BehaTable, _Data.Type);

    if _Data.Type == _CustomType then
        local FunctionName = _Data.Data[1].FuncName;
        Info = Info.. BehaviorType.. "." ..Beha.. "";
        if FunctionName == nil then
            return;
        else
            Info = Info.. ", " ..tostring(FunctionName);
        end
        if _Data.Data and _Data.Data[1].i47ya_6aghw_frxil and #_Data.Data[1].i47ya_6aghw_frxil > 0 then
            for j= 1, #_Data.Data[1].i47ya_6aghw_frxil, 1 do
                Info = Info.. ", (" ..type(_Data.Data[1].i47ya_6aghw_frxil[j]).. ") " ..tostring(_Data.Data[1].i47ya_6aghw_frxil[j]);
            end
        end
    else
        Info = Info.. BehaviorType.. "." ..Beha.. "";
        if _Data.Data then
            if type(_Data.Data) == "table" then
                for j= 1, #_Data.Data do
                    Info = Info.. ", (" ..type(_Data.Data[j]).. ") " ..tostring(_Data.Data[j]);
                end
            else
                Info = Info.. ", (" ..type(_Data.Data).. ") " ..tostring(_Data.Data);
            end
        end
    end
    Info = Info.. "}";
    return Info;
end

-- -------------------------------------------------------------------------- --
-- Chat Commands

function ModuleQuest.Global:FindQuestNames(_Pattern, _ExactName)
    local FoundQuests = FindQuestsByName(_Pattern, _ExactName);
    if #FoundQuests == 0 then
        return {};
    end
    local NamesOfFoundQuests = {};
    for i= 1, #FoundQuests, 1 do
        table.insert(NamesOfFoundQuests, FoundQuests[i].Identifier);
    end
    return NamesOfFoundQuests;
end

function ModuleQuest.Global:ProcessChatInput(_Text, _PlayerID, _IsDebug)
    local Commands = Revision.Text:CommandTokenizer(_Text);
    for i= 1, #Commands, 1 do
        if Commands[1] == "fail" or Commands[1] == "restart"
        or Commands[1] == "start" or Commands[1] == "stop"
        or Commands[1] == "win" then
            local FoundQuests = self:FindQuestNames(Commands[2], true);
            if #FoundQuests ~= 1 then
                error("Unable to find quest containing '" ..Commands[2].. "'");
                return;
            end
            if Commands[1] == "fail" then
                API.FailQuest(FoundQuests[1]);
                info("fail quest '" ..FoundQuests[1].. "'");
            elseif Commands[1] == "restart" then
                API.RestartQuest(FoundQuests[1]);
                info("restart quest '" ..FoundQuests[1].. "'");
            elseif Commands[1] == "start" then
                API.StartQuest(FoundQuests[1]);
                info("trigger quest '" ..FoundQuests[1].. "'");
            elseif Commands[1] == "stop" then
                API.StopQuest(FoundQuests[1]);
                info("interrupt quest '" ..FoundQuests[1].. "'");
            elseif Commands[1] == "win" then
                API.WinQuest(FoundQuests[1]);
                info("win quest '" ..FoundQuests[1].. "'");
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

function ModuleQuest.Local:OnGameStart()
end

function ModuleQuest.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.ChatClosed then
        self:ProcessChatInput(arg[1], arg[2], arg[3]);
    end
end

function ModuleQuest.Local:ProcessChatInput(_Text, _PlayerID, _IsDebug)
    if not _IsDebug or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    -- FIXME: This will not work in Multiplayer (Does it need to?)
    GUI.SendScriptCommand(string.format(
        [[ModuleQuest.Global:ProcessChatInput("%s", %d, %s)]],
        _Text, _PlayerID, tostring(_IsDebug == true)
    ));
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleQuest);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Aufträge können über das Skript erstellt werden.
--
-- Normaler Weise werden Aufträge im Questassistenten erzeugt. Dies ist aber
-- statisch und das Kopieren von Aufträgen ist nicht möglich. Wenn Aufträge
-- im Skript erzeugt werden, verschwinden alle diese Nachteile. Aufträge
-- können im Skript kopiert und angepasst werden. Es ist ebenfalls machbar,
-- die Aufträge in Sequenzen zu erzeugen.
--
-- Außerdem können Aufträge ineinander verschachtelt werden. Diese sogenannten
-- Nested Quests vereinfachen die Schreibweise und die Verlinkung der Aufträge.
--
-- <b>Befehle:</b><br>
-- <i>Diese Befehle können über die Konsole (SHIFT + ^) eingegeben werden, wenn
-- der Debug Mode aktiviert ist.</i><br>
-- <table border="1">
-- <tr>
-- <td><b>Befehl</b></td>
-- <td><b>Parameter</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>stop</td>
-- <td>QuestName</td>
-- <td>Unterbricht den angegebenen Quest.</td>
-- </tr>
-- <tr>
-- <td>start</td>
-- <td>QuestName</td>
-- <td>Startet den angegebenen Quest.</td>
-- </tr>
-- <tr>
-- <td>win</td>
-- <td>QuestName</td>
-- <td>Schließt den angegebenen Quest erfolgreich ab.</td>
-- </tr>
-- <tr>
-- <td>fail</td>
-- <td>QuestName</td>
-- <td>Lässt den angegebenen Quest fehlschlagen</td>
-- </tr>
-- <tr>
-- <td>restart</td>
-- <td>QuestName</td>
-- <td>Startet den angegebenen Quest neu.</td>
-- </tr>
-- </table>
--
-- <h4>Bekannte Probleme</h4>
-- Jede Voice Message - <b>Quests sind ebenfalls Voice Messages</b> - hat die
-- Chance, dass die Message Queue des Spiels hängen bleibt und dann ein leeres
-- Fenster mit dem Titel "Rhian over the Sea Chapell" angezeigt wird, welches
-- das Portrait Window dauerhaft blockiert und verhindert, dass weitere Voice
-- Messages - <b>auch Quests</b> - angezeigt werden können.
--
-- Es wird dringend geraten, Quests <b>ausschließlich</b> zur Darstellung von
-- Aufgaben für den Spieler und für <b>nichts anderes</b> zu benutzen.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(1) Interface</a></li>
-- <li><a href="QSB_1_Requester.api.html">(1) Requester</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Die Abschlussarten eines Quest Segment.
--
-- @field Success Phase muss erfolgreich abgeschlossen werden.
-- @field Failure Phase muss fehlschlagen.
-- @field Ignore  Erfolg und Misserfolg werden geleichermaßen akzeptiert.
--
QSB.SegmentResult = QSB.SegmentResult or {}

---
-- Erstellt einen Quest.
--
-- Ein Auftrag braucht immer wenigstens ein Goal und einen Trigger um ihn
-- erstellen zu können. Hat ein Quest keinen Namen, erhält er automatisch
-- einen mit fortlaufender Nummerierung.
--
-- Ein Quest besteht aus verschiedenen Eigenschaften und Behavior, die nicht
-- alle zwingend gesetzt werden müssen. Behavior werden einfach nach den
-- Eigenschaften nacheinander angegeben.
-- <p><u>Eigenschaften:</u></p>
-- <ul>
-- <li>Name: Der eindeutige Name des Quests</li>
-- <li>Sender: PlayerID des Auftraggeber (Default 1)</li>
-- <li>Receiver: PlayerID des Auftragnehmer (Default 1)</li>
-- <li>Suggestion: Vorschlagnachricht des Quests</li>
-- <li>Success: Erfolgsnachricht des Quest</li>
-- <li>Failure: Fehlschlagnachricht des Quest</li>
-- <li>Description: Aufgabenbeschreibung (Nur bei Custom)</li>
-- <li>Time: Zeit bis zu, Fehlschlag/Abschluss</li>
-- <li>Loop: Funktion, die während der Laufzeit des Quests aufgerufen wird</li>
-- <li>Callback: Funktion, die nach Abschluss aufgerufen wird</li>
-- </ul>
--
-- @param[type=table] _Data Questdefinition
-- @return[type=string] Name des Quests
-- @return[type=number] Gesamtzahl Quests
-- @within Anwenderfunktionen
-- @see API.CreateNestedQuest
--
-- @usage
-- API.CreateQuest {
--     Name        = "UnimaginativeQuestname",
--     Suggestion  = "Wir müssen das Kloster finden.",
--     Success     = "Dies sind die berümten Heilermönche.",
--
--     Goal_DiscoverPlayer(4),
--     Reward_Diplomacy(1, 4, "EstablishedContact"),
--     Trigger_Time(0),
-- }
--
function API.CreateQuest(_Data)
    if GUI then
        return;
    end
    if _Data.Name and Quests[GetQuestID(_Data.Name)] then
        error("API.CreateQuest: A quest named " ..tostring(_Data.Name).. " already exists!");
        return;
    end
    return ModuleQuest.Global:CreateSimpleQuest(_Data);
end

---
-- Erstellt einen verschachtelten Auftrag.
--
-- Verschachtelte Aufträge (Nested Quests) vereinfachen aufschreiben und
-- zuordnen der zugeordneten Aufträge. Ein Nested Quest ist selbst unsichtbar
-- und hat mindestens ein ihm untergeordnetes Segment. Die Segmente eines
-- Nested Quest sind wiederum Quests.
--
-- Du kannst für Segmente die gleichen Einträge setzen, wie bei gewöhnlichen
-- Quests. Zudem kannst du auch ihnen einen Namen geben. Wenn du das nicht tust,
-- werden sie automatisch benannt. Der Name setzt sich dann zusammen aus dem
-- Namen des Nested Quest und ihrem Index (z.B. "ExampleName@Segment1").
--
-- Segmente haben ein erwartetes Ergebnis. Für gewöhnlich ist dies auf Erfolg
-- festgelegt. Du kanns es aber auch auf Fehlschlag ändern oder ganz ignorieren.
-- Ein Nested Quest ist abgeschlossen, wenn alle Segmente mit ihrem erwarteten
-- Ergebnis abgeschlossen wurden (Erfolg) oder mindestens einer ein anderes
-- Ergebnis als erwartet hatte (Fehlschlag).
--
-- Werden Status oder Resultat eines Quest über Funktionen verändert (zb.
-- API.StopQuest oder "stop" Konsolenbefehl), dann werden die Segmente
-- ebenfalls beeinflusst.
--
-- Es ist nicht zwingend notwendig, einen Trigger für die Segmente zu setzen.
-- Alle Segmente starten automatisch sobald der Nested Quest startet. Du kannst
-- weitere Trigger zu Segmenten hinzufügen, um dieses Verhalten nach deinen
-- Bedürfnissen abzuändern (z.B. auf ein vorangegangenes Segment triggern).
--
-- Nested Quests können auch ineinander verschachtelt werden. Man kann also
-- innerhalb eines verschachtelten Auftrags eine weitere Ebene Verschachtelung
-- aufmachen.
--
-- @param[type=table] _Data Daten des Quest
-- @return[type=string] Name des Nested Quest oder nil bei Fehler
-- @within Anwenderfunktionen
-- @see QSB.SegmentResult
-- @see API.CreateQuest
--
-- @usage
-- API.CreateNestedQuest {
--     Name        = "MainQuest",
--     Segments    = {
--         {
--             Suggestion  = "Wir benötigen einen höheren Titel!",
--
--             Goal_KnightTitle("Mayor"),
--         },
--         {
--             -- Mit dem Typ Ignore wird ein Fehlschlag ignoriert.
--             Result      = QSB.SegmentResult.Ignore,
--
--             Suggestion  = "Wir benötigen außerdem mehr Asche! Und das sofort...",
--             Success     = "Geschafft!",
--             Failure     = "Versagt!",
--             Time        = 3 * 60,
--
--             Goal_Produce("G_Gold", 5000),
--
--             Trigger_OnQuestSuccess("MainQuest@Segment1", 1),
--             -- Segmented Quest wird gewonnen.
--             Reward_QuestSuccess("MainQuest"),
--         },
--         {
--             Suggestion  = "Dann versuchen wir es mit Eisen...",
--             Success     = "Geschafft!",
--             Failure     = "Versagt!",
--             Time        = 3 * 60,
--
--             Trigger_OnQuestFailure("MainQuest@Segment2"),
--             Goal_Produce("G_Iron", 50),
--         }
--     },
--
--     -- Wenn ein Quest nicht das erwartete Ergebnis hat, Fehlschlag.
--     Reprisal_Defeat(),
--     -- Wenn alles erfüllt wird, ist das Spiel gewonnen.
--     Reward_VictoryWithParty(),
-- };
--
function API.CreateNestedQuest(_Data)
    if GUI or type(_Data) ~= "table" then
        return;
    end
    if _Data.Segments == nil or #_Data.Segments == 0 then
        error(string.format("API.CreateNestedQuest: Segmented quest '%s' is missing it's segments!", tostring(_Data.Name)));
        return;
    end
    return ModuleQuest.Global:CreateNestedQuest(_Data);
end

---
-- Fügt eine Prüfung hinzu, ob Quests getriggert werden. Soll ein Quest nicht
-- getriggert werden, muss false zurückgegeben werden, sonst true.
--
-- @param[type=function] _Function Prüffunktion
-- @within Anwenderfunktionen
-- @local
--
function API.AddDisableTriggerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(ModuleQuest.Global.ExternalTriggerConditions, _Function);
end

---
-- Fügt eine Prüfung hinzu, ob für laufende Quests Zeit vergeht. Soll keine Zeit
-- vergehen für einen Quest, muss false zurückgegeben werden, sonst true.
--
-- @param[type=function] _Function Prüffunktion
-- @within Anwenderfunktionen
-- @local
--
function API.AddDisableTimerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(ModuleQuest.Global.ExternalTimerConditions, _Function);
end

---
-- Fügt eine Prüfung hinzu, ob für laufende Quests Ziele geprüft werden. Sollen
-- keine Ziele geprüft werden, muss false zurückgegeben werden, sonst true.
--
-- @param[type=function] _Function Prüffunktion
-- @within Anwenderfunktionen
-- @local
--
function API.AddDisableDecisionCondition(_Function)
    if GUI then
        return;
    end
    table.insert(ModuleQuest.Global.ExternalDecisionConditions, _Function);
end

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleTypewriter = {
    Properties = {
        Name = "ModuleTypewriter",
        Version = "4.0.0 (ALPHA 1.0.0)",
    },

    Global = {
        TypewriterEventData = {},
        TypewriterEventCounter = 0,
    },
    Local = {},

    Shared = {};
}

QSB.CinematicElementTypes.Typewriter = 1;

-- Global Script ---------------------------------------------------------------

function ModuleTypewriter.Global:OnGameStart()
    QSB.ScriptEvents.TypewriterStarted = API.RegisterScriptEvent("Event_TypewriterStarted");
    QSB.ScriptEvents.TypewriterEnded = API.RegisterScriptEvent("Event_TypewriterEnded");

    API.StartHiResJob(function()
        ModuleTypewriter.Global:ControlTypewriter();
    end);
end

function ModuleTypewriter.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleTypewriter.Global:StartTypewriter(_Data)
    self.TypewriterEventCounter = self.TypewriterEventCounter +1;
    local EventName = "CinematicElement_Typewriter" ..self.TypewriterEventCounter;
    _Data.Name = EventName;
    if not self.LoadscreenClosed or API.IsCinematicElementActive(_Data.PlayerID) then
        ModuleGUI.Global:PushCinematicElementToQueue(
            _Data.PlayerID,
            QSB.CinematicElementTypes.Typewriter,
            EventName,
            _Data
        );
        return _Data.Name;
    end
    return self:PlayTypewriter(_Data);
end

function ModuleTypewriter.Global:PlayTypewriter(_Data)
    local ID = API.StartCinematicElement(_Data.Name, _Data.PlayerID);
    _Data.ID = ID;
    _Data.TextTokens = self:TokenizeText(_Data);
    self.TypewriterEventData[_Data.PlayerID] = _Data;
    Logic.ExecuteInLuaLocalState(string.format(
        [[
        if GUI.GetPlayerID() == %d then
            API.ActivateImageScreen(GUI.GetPlayerID(), "%s", %d, %d, %d, %d)
            API.DeactivateNormalInterface(GUI.GetPlayerID())
            API.DeactivateBorderScroll(GUI.GetPlayerID(), %d)
            Input.CutsceneMode()
            GUI.ClearNotes()
        end
        ]],
        _Data.PlayerID,
        _Data.Image,
        _Data.Color.R or 0,
        _Data.Color.G or 0,
        _Data.Color.B or 0,
        _Data.Color.A or 255,
        _Data.TargetEntity
    ));

    API.SendScriptEvent(QSB.ScriptEvents.TypewriterStarted, _Data.PlayerID, _Data);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.TypewriterStarted, %d, %s)]],
        _Data.PlayerID,
        table.tostring(_Data)
    ));
    return _Data.Name;
end

function ModuleTypewriter.Global:FinishTypewriter(_PlayerID)
    if self.TypewriterEventData[_PlayerID] then
        local EventData = table.copy(self.TypewriterEventData[_PlayerID]);
        local EventPlayer = self.TypewriterEventData[_PlayerID].PlayerID;
        Logic.ExecuteInLuaLocalState(string.format(
            [[
            if GUI.GetPlayerID() == %d then
                ModuleGUI.Local:ResetFarClipPlane()
                API.DeactivateImageScreen(GUI.GetPlayerID())
                API.ActivateNormalInterface(GUI.GetPlayerID())
                API.ActivateBorderScroll(GUI.GetPlayerID())
                Input.GameMode()
                GUI.ClearNotes()
            end
            ]],
            _PlayerID
        ));
        API.SendScriptEvent(QSB.ScriptEvents.TypewriterEnded, EventPlayer, EventData);
        Logic.ExecuteInLuaLocalState(string.format(
            [[API.SendScriptEvent(QSB.ScriptEvents.TypewriterEnded, %d, %s)]],
            EventPlayer,
            table.tostring(EventData)
        ));
        self.TypewriterEventData[_PlayerID]:Callback();
        API.FinishCinematicElement(EventData.Name, EventPlayer);
        self.TypewriterEventData[_PlayerID] = nil;
    end
end

function ModuleTypewriter.Global:TokenizeText(_Data)
    local TextTokens = {};
    local TempTokens = {};
    local Text = API.ConvertPlaceholders(_Data.Text);
    Text = Text:gsub("%s+", " ");
    while (true) do
        local s1, e1 = Text:find("{");
        local s2, e2 = Text:find("}");
        if not s1 or not s2 then
            table.insert(TempTokens, Text);
            break;
        end
        if s1 > 1 then
            table.insert(TempTokens, Text:sub(1, s1 -1));
        end
        table.insert(TempTokens, Text:sub(s1, e2));
        Text = Text:sub(e2 +1);
    end

    local LastWasPlaceholder = false;
    for i= 1, #TempTokens, 1 do
        if TempTokens[i]:find("{") then
            local Index = #TextTokens;
            if LastWasPlaceholder then
                TextTokens[Index] = TextTokens[Index] .. TempTokens[i];
            else
                table.insert(TextTokens, Index+1, TempTokens[i]);
            end
            LastWasPlaceholder = true;
        else
            local Index = 1;
            while (Index <= #TempTokens[i]) do
                if string.byte(TempTokens[i]:sub(Index, Index)) == 195 then
                    table.insert(TextTokens, TempTokens[i]:sub(Index, Index+1));
                    Index = Index +1;
                else
                    table.insert(TextTokens, TempTokens[i]:sub(Index, Index));
                end
                Index = Index +1;
            end
            LastWasPlaceholder = false;
        end
    end
    return TextTokens;
end

function ModuleTypewriter.Global:ControlTypewriter()
    -- Check queue for next event
    for i= 1, 8 do
        if self.LoadscreenClosed and not API.IsCinematicElementActive(i) then
            local Next = ModuleGUI.Global:LookUpCinematicInQueue(i);
            if Next and Next[1] == QSB.CinematicElementTypes.Typewriter then
                local Data = ModuleGUI.Global:PopCinematicElementFromQueue(i);
                self:PlayTypewriter(Data[3]);
            end
        end
    end

    -- Perform active events
    for k, v in pairs(self.TypewriterEventData) do
        if self.TypewriterEventData[k].Delay > 0 then
            self.TypewriterEventData[k].Delay = self.TypewriterEventData[k].Delay -1;
            -- Just my paranoia...
            Logic.ExecuteInLuaLocalState(string.format(
                [[if GUI.GetPlayerID() == %d then GUI.ClearNotes() end]],
                self.TypewriterEventData[k].PlayerID
            ));
        end
        if self.TypewriterEventData[k].Delay == 0 then
            self.TypewriterEventData[k].Index = v.Index + v.CharSpeed;
            if v.Index > #self.TypewriterEventData[k].TextTokens then
                self.TypewriterEventData[k].Index = #self.TypewriterEventData[k].TextTokens;
            end
            local Index = math.floor(v.Index + 0.5);
            local Text = "";
            for i= 1, Index, 1 do
                Text = Text .. self.TypewriterEventData[k].TextTokens[i];
            end
            Logic.ExecuteInLuaLocalState(string.format(
                [[
                if GUI.GetPlayerID() == %d then
                    GUI.ClearNotes()
                    GUI.AddNote("]] ..Text.. [[");
                end
                ]],
                self.TypewriterEventData[k].PlayerID
            ));
            if Index == #self.TypewriterEventData[k].TextTokens then
                self.TypewriterEventData[k].Waittime = v.Waittime -1;
                if v.Waittime <= 0 then
                    self:FinishTypewriter(k);
                end
            end
        end
    end
end

-- Local Script ----------------------------------------------------------------

function ModuleTypewriter.Local:OnGameStart()
    QSB.ScriptEvents.TypewriterStarted = API.RegisterScriptEvent("Event_TypewriterStarted");
    QSB.ScriptEvents.TypewriterEnded = API.RegisterScriptEvent("Event_TypewriterEnded");
end

function ModuleTypewriter.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleTypewriter);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Ermöglicht die Anzeige eines fortlaufend getippten Text auf dem Bildschirm.
--
-- Der Text kann mit oder ohne schwarzem Hintergrund angezeigt werden.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- <li><a href="QSB_1_GUI.api.html">(1) Interface</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Events, auf die reagiert werden kann.
--
-- @field TypewriterStarted Ein Schreibmaschineneffekt beginnt (Parameter: PlayerID, DataTable)
-- @field TypewriterEnded   Ein Schreibmaschineneffekt endet (Parameter: PlayerID, DataTable)
--
-- @within Event
--
QSB.ScriptEvents = QSB.ScriptEvents or {};

---
-- Blendet einen Text Zeichen für Zeichen ein.
--
-- Der Effekt startet erst, nachdem die Map geladen ist. Wenn ein anderes
-- Cinematic Event läuft, wird gewartet, bis es beendet ist. Wärhend der Effekt
-- läuft, können wiederrum keine Cinematic Events starten.
--
-- Mögliche Werte:
-- <table border="1">
-- <tr>
-- <td><b>Feldname</b></td>
-- <td><b>Typ</b></td>
-- <td><b>Beschreibung</b></td>
-- </tr>
-- <tr>
-- <td>Text</td>
-- <td>string|table</td>
-- <td>Der anzuzeigene Text</td>
-- </tr>
-- <tr>
-- <td>PlayerID</td>
-- <td>number</td>
-- <td>(Optional) Spieler, dem der Effekt angezeigt wird (Default: Menschlicher Spieler)</td>
-- </tr>
-- <tr>
-- <td>Callback</td>
-- <td>function</td>
-- <td>(Optional) Funktion nach Abschluss der Textanzeige (Default: nil)</td>
-- </tr>
-- <tr>
-- <td>TargetEntity</td>
-- <td>string|number</td>
-- <td>(Optional) TargetEntity der Kamera (Default: nil)</td>
-- </tr>
-- <tr>
-- <td>CharSpeed</td>
-- <td>number</td>
-- <td>(Optional) Die Schreibgeschwindigkeit (Default: 1.0)</td>
-- </tr>
-- <tr>
-- <td>Waittime</td>
-- <td>number</td>
-- <td>(Optional) Initiale Wartezeigt bevor der Effekt startet</td>
-- </tr>
-- <tr>
-- <td>Opacity</td>
-- <td>number</td>
-- <td>(Optional) Durchsichtigkeit des Hintergrund (Default: 1)</td>
-- </tr>
-- <tr>
-- <td>Color</td>
-- <td>table</td>
-- <td>(Optional) Farbe des Hintergrund (Default: {R= 0, G= 0, B= 0}}</td>
-- </tr>
-- <tr>
-- <td>Image</td>
-- <td>string</td>
-- <td>(Optional) Pfad zur anzuzeigenden Grafik</td>
-- </tr>
-- </table>
--
-- <b>Hinweis</b>: Steuerzeichen wie {cr} oder {@color} werden als ein Token
-- gewertet und immer sofort eingeblendet. Steht z.B. {cr}{cr} im Text, werden
-- die Zeichen atomar behandelt, als seien sie ein einzelnes Zeichen.
-- Gibt es mehr als 1 Leerzeichen hintereinander, werden alle zusammenhängenden
-- Leerzeichen (vom Spiel) auf ein Leerzeichen reduziert!
--
-- @param[type=table] _Data Konfiguration
-- @return[type=string] Name des zugeordneten Event
--
-- @usage
-- local EventName = API.StartTypewriter {
--     PlayerID = 1,
--     Text     = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "..
--                "sed diam nonumy eirmod tempor invidunt ut labore et dolore"..
--                "magna aliquyam erat, sed diam voluptua. At vero eos et"..
--                " accusam et justo duo dolores et ea rebum. Stet clita kasd"..
--                " gubergren, no sea takimata sanctus est Lorem ipsum dolor"..
--                " sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing"..
--                " elitr, sed diam nonumy eirmod tempor invidunt ut labore et"..
--                " dolore magna aliquyam erat, sed diam voluptua. At vero eos"..
--                " et accusam et justo duo dolores et ea rebum. Stet clita"..
--                " kasd gubergren, no sea takimata sanctus est Lorem ipsum"..
--                " dolor sit amet.",
--     Callback = function(_Data)
--         -- Hier kann was passieren
--     end
-- };
-- @within Anwenderfunktionen
--
function API.StartTypewriter(_Data)
    if Framework.IsNetworkGame() ~= true then
        _Data.PlayerID = _Data.PlayerID or QSB.HumanPlayerID;
    end
    if _Data.PlayerID == nil or (_Data.PlayerID < 1 or _Data.PlayerID > 8) then
        return;
    end
    _Data.Text = API.Localize(_Data.Text or "");
    _Data.Callback = _Data.Callback or function() end;
    _Data.CharSpeed = _Data.CharSpeed or 1;
    _Data.Waittime = (_Data.Waittime or 8) * 10;
    _Data.TargetEntity = GetID(_Data.TargetEntity or 0);
    _Data.Image = _Data.Image or "";
    _Data.Color = _Data.Color or {
        R = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        G = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        B = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        A = 255
    };
    if _Data.Opacity and _Data.Opacity >= 0 and _Data.Opacity then
        _Data.Color.A = math.floor((255 * _Data.Opacity) + 0.5);
    end
    _Data.Delay = 15;
    _Data.Index = 0;
    return ModuleTypewriter.Global:StartTypewriter(_Data);
end
API.SimpleTypewriter = API.StartTypewriter;

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

ModuleWeatherManipulation = {
    Properties = {
        Name = "ModuleWeatherManipulation",
    },

    Global = {
        EventQueue = {},
        ActiveEvent = nil,
    },
    Local = {
        ActiveEvent = nil,
    },
}

-- Global ------------------------------------------------------------------- --

function ModuleWeatherManipulation.Global:OnGameStart()
    API.StartHiResJob(function()
        ModuleWeatherManipulation.Global:EventController();
    end);
end

function ModuleWeatherManipulation.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == QSB.ScriptEvents.SaveGameLoaded then
        if self:IsEventActive() then
            Logic.ExecuteInLuaLocalState([[
                Display.StopAllEnvironmentSettingsSequences()
                ModuleWeatherManipulation.Local:DisplayEvent(]] ..self:GetEventRemainingTime().. [[)
            ]]);
        end
    end
end

function ModuleWeatherManipulation.Global:AddEvent(_Event, _Duration)
    local Event = table.copy(_Event);
    Event.Duration = _Duration;
    table.insert(self.EventQueue, Event);
end

function ModuleWeatherManipulation.Global:PurgeAllEvents()
    if #self.EventQueue > 0 then
        for i= #self.EventQueue, 1 -1 do
            self.EventQueue:remove(i);
        end
    end
end

function ModuleWeatherManipulation.Global:NextEvent()
    if not self:IsEventActive() then
        if #self.EventQueue > 0 then
            self:ActivateEvent();
        end
    end
end

function ModuleWeatherManipulation.Global:ActivateEvent()
    if #self.EventQueue == 0 then
        return;
    end

    local Event = table.remove(self.EventQueue, 1);
    self.ActiveEvent = Event;
    Logic.ExecuteInLuaLocalState([[
        ModuleWeatherManipulation.Local.ActiveEvent = ]] ..table.tostring(Event).. [[
        ModuleWeatherManipulation.Local:DisplayEvent()
    ]]);

    Logic.WeatherEventClearGoodTypesNotGrowing();
    for i= 1, #Event.NotGrowing, 1 do
        Logic.WeatherEventAddGoodTypeNotGrowing(Event.NotGrowing[i]);
    end
    if Event.Rain then
        Logic.WeatherEventSetPrecipitationFalling(true);
        Logic.WeatherEventSetPrecipitationHeaviness(1);
        Logic.WeatherEventSetWaterRegenerationFactor(1);
        if Event.Snow then
            Logic.WeatherEventSetPrecipitationIsSnow(true);
        end
    end
    if Event.Ice then
        Logic.WeatherEventSetWaterFreezes(true);
    end
    if Event.Monsoon then
        Logic.WeatherEventSetShallowWaterFloods(true);
    end
    Logic.WeatherEventSetTemperature(Event.Temperature);
    Logic.ActivateWeatherEvent();
end

function ModuleWeatherManipulation.Global:StopEvent()
    Logic.ExecuteInLuaLocalState("ModuleWeatherManipulation.Local.ActiveEvent = nil");
    self.ActiveEvent = nil;
    Logic.DeactivateWeatherEvent();
end

function ModuleWeatherManipulation.Global:GetEventRemainingTime()
    if not self:IsEventActive() then
        return 0;
    end
    return self.ActiveEvent.Duration;
end

function ModuleWeatherManipulation.Global:IsEventActive()
    return self.ActiveEvent ~= nil;
end

function ModuleWeatherManipulation.Global:EventController()
    if self:IsEventActive() then
        self.ActiveEvent.Duration = self.ActiveEvent.Duration -1;
        if self.ActiveEvent.Loop then
            self.ActiveEvent:Loop();
        end

        if self.ActiveEvent.Duration == 0 then
            self:StopEvent();
            self:NextEvent();
        end
    end
end

-- Local -------------------------------------------------------------------- --

function ModuleWeatherManipulation.Local:OnGameStart()
end

function ModuleWeatherManipulation.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleWeatherManipulation.Local:DisplayEvent(_Duration)
    if self:IsEventActive() then
        local SequenceID = Display.AddEnvironmentSettingsSequence(self.ActiveEvent.GFX);
        Display.PlayEnvironmentSettingsSequence(SequenceID, _Duration or self.ActiveEvent.Duration);
    end
end

function ModuleWeatherManipulation.Local:IsEventActive()
    return self.ActiveEvent ~= nil;
end

-- -------------------------------------------------------------------------- --

WeatherEvent = {
    GFX = "ne_winter_sequence.xml",
    NotGrowing = {},
    Rain = false,
    Snow = false,
    Ice = false,
    Monsoon = false,
    Temperature = 10,
}

function WeatherEvent:New()
    return table.copy(self);
end

-- -------------------------------------------------------------------------- --

Revision:RegisterModule(ModuleWeatherManipulation);

--[[
Copyright (C) 2023 totalwarANGEL - All Rights Reserved.

This file is part of the QSB-R. QSB-R is created by totalwarANGEL.
You may use and modify this file unter the terms of the MIT licence.
(See https://en.wikipedia.org/wiki/MIT_License)
]]

-- -------------------------------------------------------------------------- --

---
-- Dieses Modul ermöglicht das Ändern des Wetters.
--
-- Es können nun relativ einfach Wetterevents und Wetteranimationen kombiniert
-- gestartet werden.
--
-- <b>Vorausgesetzte Module:</b>
-- <ul>
-- <li><a href="QSB_0_Kernel.api.html">(0) Basismodul</a></li>
-- </ul>
--
-- @within Beschreibung
-- @set sort=true
--

---
-- Erzeugt ein neues Wetterevent und gibt es zurück.
--
-- Ein Event alleine ändert noch nicht das Wetter! Hier wird ein Event
-- definiert, welches an anderer Stelle benutzt werden kann. Das definierte
-- Event kann jedoch in einer Variable gespeichert und immer wieder neu
-- verwendet werden.
--
-- <b>Hinweis</b>: Es handelt sich um eine dynamische Wettersequenz. Dies muss
-- beachtet werden! Eine statische Sequenz wird nicht funktionieren!
--
-- @param[type=string]  _GFX        Verwendetes Display Set
-- @param[type=boolean] _Rain       Niederschlag aktivieren
-- @param[type=boolean] _Snow       Niederschlag ist Schnee
-- @param[type=boolean] _Ice        Wasser gefriert
-- @param[type=boolean] _Monsoon    Blockendes Monsunwasser aktivieren
-- @param[type=number]  _Temp       Temperatur während des Events
-- @param[type=table]   _NotGrowing Liste der nicht nachwachsenden Güter
-- @return[type=table]              Neues Wetterevent
-- @within WeatherEvent
--
-- @see API.WeatherEventRegister
-- @see API.WeatherEventRegisterLoop
--
-- @usage
-- -- Erzeugt ein Winterevent
-- MyEvent = API.WeatherEventCreate(
--     "ne_winter_sequence.xml", false, true, true, false, -15,
--     {Goods.G_Grain, Goods.G_RawFish, Goods.G_Honeycomb}
-- )
--
function API.WeatherEventCreate(_GFX, _Rain, _Snow, _Ice, _Monsoon, _Temp, _NotGrowing)
    if GUI then
        return;
    end

    local Event = WeatherEvent:New();
    Event.GFX = _GFX or Event.GFX;
    Event.Rain = _Rain or Event.Rain;
    Event.Snow = _Snow or Event.Snow;
    Event.Ice = _Ice or Event.Ice;
    Event.Monsoon = _Monsoon or Event.Monsoon;
    Event.Temperature = _Temp or Event.Temperature;
    Event.NotGrowing = _NotGrowing or Event.NotGrowing;
    return Event;
end

---
-- Registiert ein Event für eine bestimmte Dauer. Das Event wird auf der
-- "Wartebank" eingereiht.
--
-- <b>Hinweis</b>: Ein wartendes Event wird gestartet, sobald kein anderes
-- Event mehr aktiv ist.
-- 
-- @param[type=table]  _Event     Event-Instanz
-- @param[type=number] _Duration  Name des Events
-- @within WeatherEvent
-- @see API.WeatherEventNext
-- @see API.WeatherEventAbort
-- @see API.WeatherEventRegisterLoop
--
-- @usage
-- API.WeatherEventRegister(MyEvent, 300);
--
function API.WeatherEventRegister(_Event, _Duration)
    if GUI then
        return;
    end
    if type(_Event) ~= "table" or not _Event.GFX then
        error("API.WeatherEventStart: Invalid weather event!");
        return;
    end
    ModuleWeatherManipulation.Global:AddEvent(_Event, _Duration);
end

---
-- Registiert ein Event als Endlosschleife. Das Event wird immer wieder neu
-- starten, kurz bevor es eigentlich endet. Es darf keine anderen Events auf
-- der "Wartebank" geben.
-- @param[type=table]  _Event Event-Instanz
-- @within WeatherEvent
-- @see API.WeatherEventNext
-- @see API.WeatherEventAbort
-- @see API.WeatherEventRegister
--
-- @usage
-- API.WeatherEventRegister(MyEvent);
--
function API.WeatherEventRegisterLoop(_Event)
    if GUI then
        return;
    end
    if type(_Event) ~= "table" or not _Event.GFX then
        error("API.WeatherEventStartLoop: Invalid weather event!");
        return;
    end
    
    _Event.Loop = function(_Data)
        if _Data.Duration <= 36 then
            ModuleWeatherManipulation.Global:AddEvent(_Event, 120);
            ModuleWeatherManipulation.Global:StopEvent();
            ModuleWeatherManipulation.Global:ActivateEvent();
        end
    end
    ModuleWeatherManipulation.Global:AddEvent(_Event, 120);
end

---
-- Startet das nächste Wetterevent auf der "Wartebank". Wenn bereits ein Event
-- aktiv ist, wird dieses gestoppt. Es erfolgt ein Übergang zum nächsten Event,
-- sofern möglich.
--
-- @within WeatherEvent
--
function API.WeatherEventNext()
    ModuleWeatherManipulation.Global:StopEvent();
    ModuleWeatherManipulation.Global:ActivateEvent();
end

---
-- Bricht das aktuelle Event inklusive der Animation sofort ab.
-- @within WeatherEvent
--
function API.WeatherEventAbort()
    if GUI then
        return;
    end
    Logic.ExecuteInLuaLocalState("Display.StopAllEnvironmentSettingsSequences()");
    ModuleWeatherManipulation.Global:StopEvent();
end

---
-- Bricht das aktuelle Event ab und löscht alle eingereihten Events.
--
-- Mit dieser Funktion wird die komplette Warteschlange für Wettervents geleert.
-- Dies betrifft sowohl einzelne Events als auch sich wiederholende Events.
--
-- @within WeatherEvent
--
function API.WeatherEventPurge()
    if GUI then
        return;
    end
    ModuleWeatherManipulation.Global:PurgeAllEvents();
    Logic.ExecuteInLuaLocalState("Display.StopAllEnvironmentSettingsSequences()");
    ModuleWeatherManipulation.Global:StopEvent();
end

