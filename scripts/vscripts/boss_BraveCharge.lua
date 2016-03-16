function BraveCharge(keys)
    local caster=keys.caster
    local ability= keys.ability

    caster:Stop()

    ability.leap_direction = caster:GetForwardVector()
    ability.leap_distance = ability:GetSpecialValueFor("leap_distance")
	ability.leap_speed = ability:GetSpecialValueFor("leap_speed")
	ability.leap_traveled = 0


    --if ability.leap_traveled < ability.leap_distance  then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction*ability.leap_speed)
        ability.leap_traveled= ability.leap_traveled +ability.leap_speed
    --else
      --  caster:InterruptMotionControllers(true)
    --end


end
