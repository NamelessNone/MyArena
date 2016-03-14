function Fireblink( keys )
        local caster = keys.caster
        local point = keys.target_points[1]

        local radius = 300                --设置范围
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
        local flags = DOTA_UNIT_TARGET_FLAG_NONE

        --设置施法者的面向角度
        caster:SetForwardVector( ((point - caster:GetOrigin()):Normalized()) )

        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_point_time"),
                function( )

                        --判断单位是否死亡，是否存在，是否被击晕
                        if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then

                                --不是死亡，存在这个单位，没被击晕，就运行这里面的内容
                                local caster_abs = caster:GetAbsOrigin()                --获取施法者的位置

                                if (point - caster_abs):Length()>50 then        --当单位移动到距离指定地点小于50时不在进行移动

                                        local face = (point - caster_abs):Normalized()
                                        local vec = face * 75.0
                                        caster:SetAbsOrigin(caster_abs + vec)

                                        return 0.01
                                else
                                        --获取范围内的单位，效率不是很高，在计时器里面注意使用
                                        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, radius, teams, types, flags, FIND_CLOSEST, true)

                                        --利用Lua的循环迭代，循环遍历每一个单位组内的单位
                                        for i,unit in pairs(targets) do
                                                local damageTable = {victim=unit,    --受到伤害的单位
                                                        attacker=caster,          --造成伤害的单位
                                                        damage=50,
                                                        damage_type=DAMAGE_TYPE_MAGICAL}
                                                ApplyDamage(damageTable)    --造成伤害
                                        end

                                        caster:RemoveModifierByName("modifier_phased")
                                        print("MyAbility_point Over")
                                        return nil
                                end

                        else
                                caster:RemoveModifierByName("modifier_phased")
                                print("Caster is dead or stunned")
                                return nil
                        end
                end, 0)

        print("Run Fireblink Succeed")
end
