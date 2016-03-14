

function initplayerstats()
	PlayerStats={}

end

function createunit(unitname,location,ind)
--	local unit=CreateUnitByName(unitname,location, true, nil,nil, DOTA_TEAM_NEUTRALS)
    print("creating=",unitname)
    local unit=CreateUnitByName(unitname, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--print("unit111="..unit)
    unit:SetContext("name",unitname,0)
    unit:SetContext("ind",tostring(ind),0)
end

function respawndummy(ind)
	print("parameter type is",type(ind))
    local indloc=ind
    local dummyspawner=Entities:FindByName(nil, "DummySpawner")
    local dummyspawner2=Entities:FindByName(nil, "DummySpawner2")
    local location

    print("indloc=",indloc)

    if indloc==1 then
        print ("handle",dummyspawner)
        location=dummyspawner:GetAbsOrigin()
        print ("location",location)
        elseif indloc==2 then
        location=dummyspawner2:GetAbsOrigin()
        else
        print("not respawning")
    end
    print ("location",location)
	print ("Respawning dummy called")


--    local ifexist=Entities:FindAllByName("testdummy")
--    if ifexist==nil then
        createunit("testdummy",location,ind)
--    end
end
