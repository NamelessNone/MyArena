function Fireblink( keys )
        local caster = keys.caster
        local point = keys.target_points[1]

        local radius = 300                --���÷�Χ
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
        local flags = DOTA_UNIT_TARGET_FLAG_NONE

        --����ʩ���ߵ�����Ƕ�
        caster:SetForwardVector( ((point - caster:GetOrigin()):Normalized()) )

        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_point_time"),
                function( )

                        --�жϵ�λ�Ƿ��������Ƿ���ڣ��Ƿ񱻻���
                        if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then

                                --�������������������λ��û�����Σ������������������
                                local caster_abs = caster:GetAbsOrigin()                --��ȡʩ���ߵ�λ��

                                if (point - caster_abs):Length()>50 then        --����λ�ƶ�������ָ���ص�С��50ʱ���ڽ����ƶ�

                                        local face = (point - caster_abs):Normalized()
                                        local vec = face * 75.0
                                        caster:SetAbsOrigin(caster_abs + vec)

                                        return 0.01
                                else
                                        --��ȡ��Χ�ڵĵ�λ��Ч�ʲ��Ǻܸߣ��ڼ�ʱ������ע��ʹ��
                                        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, radius, teams, types, flags, FIND_CLOSEST, true)

                                        --����Lua��ѭ��������ѭ������ÿһ����λ���ڵĵ�λ
                                        for i,unit in pairs(targets) do
                                                local damageTable = {victim=unit,    --�ܵ��˺��ĵ�λ
                                                        attacker=caster,          --����˺��ĵ�λ
                                                        damage=50,
                                                        damage_type=DAMAGE_TYPE_MAGICAL}
                                                ApplyDamage(damageTable)    --����˺�
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
