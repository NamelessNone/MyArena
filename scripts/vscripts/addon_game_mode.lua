require ('playerinit')
-- Generated from template

if MyArena == nil then
	MyArena = class({})
end

function PrecacheEveryThingFromKV( context )
	local kv_files = {"scripts/npc/npc_units_custom.txt","scripts/npc/npc_abilities_custom.txt","scripts/npc/npc_heroes_custom.txt","scripts/npc/npc_abilities_override.txt","npc_items_custom.txt"}
	for _, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
			PrecacheEverythingFromTable( context, kvs)
		end
	end
    print("done loading shiping")
end

function PrecacheEverythingFromTable( context, kvtable)
	for key, value in pairs(kvtable) do
		if type(value) == "table" then
			PrecacheEverythingFromTable( context, value )
		else
			if string.find(value, "vpcf") then
				PrecacheResource( "particle",  value, context)
				print("PRECACHE PARTICLE RESOURCE", value)
			end
			if string.find(value, "vmdl") then
				PrecacheResource( "model",  value, context)
				print("PRECACHE MODEL RESOURCE", value)
			end
			if string.find(value, "vsndevts") then
				PrecacheResource( "soundfile",  value, context)
				print("PRECACHE SOUND RESOURCE", value)
			end
		end
	end


end

function Precache( context )
	print("BEGIN TO PRECACHE RESOURCE")
	local time = GameRules:GetGameTime()
	PrecacheEveryThingFromKV( context )
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	time = time - GameRules:GetGameTime()
	print("DONE PRECACHEING IN:"..tostring(time).."Seconds")
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = MyArena()
	GameRules.AddonTemplate:InitGameMode()
end

function MyArena:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

    self.onentitykilledcalled=0

    print ("InitGameMode spawning dummy")
    respawndummy(1)
    respawndummy(2)
    ListenToGameEvent('entity_killed',Dynamic_Wrap(MyArena,'OnEntityKilled'),self)
    ListenToGameEvent("player_chat", Dynamic_Wrap(MyArena, "PlayerChat"), self)
--    ListenToGameEvent("entity_hurt", Dynamic_Wrap(MyArena, "OnEntityHurt"), self)

end

-- Evaluate the state of the game
function MyArena:OnThink()


	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function MyArena:OnEntityKilled(keys)

    self.onentitykilledcalled=self.onentitykilledcalled+1
    --print("called amount",self.onentitykilledcalled)
    local unitkilled= EntIndexToHScript(keys.entindex_killed)

 -- local unitkilled=killdata:entindex_killed
	local label= unitkilled:GetContext("name")
    local ind=unitkilled:GetContext("ind")
    --print(label)
    if label then
		if label=="testdummy" then
			respawndummy(ind)
        end
	end

end

function MyArena:PlayerChat(keys)
    print("PlayerChat")
    DeepPrintTable(keys)
    local text=keys.text
    local ArenaCenterSpawner=Entities:FindByName(nil, "ArenaCenterSpawner")
    local location=ArenaCenterSpawner:GetAbsOrigin()

    if text=="1" then

        createunit("Boss_Charger",location,3)
    end

end

function MyArena:OnEntityHurt(keys)
    print("OnEntityHurt")
    DeepPrintTable(keys)
end
