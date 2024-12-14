-- CHRMNoBuffs

function GetBeneBuffCount(client)
    if client == nil then
        return 0 -- No buffs if client is nil
    end

    local count = 0
    local maxBuffSlots = client:GetMaxBuffSlots()

    for i = 0, maxBuffSlots - 1 do
        local spell_id = client:GetBuffSpellID(i)
        if spell_id ~= -1 then -- Check if a valid spell exists in this buff slot
            local spell = Spell(spell_id)
            if spell and spell:IsBeneficial() then
                count = count + 1
            end
        end
    end

    return count
end

function event_scale_calc(e)
    if GetBeneBuffCount(e.owner) == 0 then
        e.self:SetScale(1) -- Scale to 1 if no beneficial buffs
    else
        e.self:SetScale(0) -- Scale to 0 if there are beneficial buffs
    end
end
