-- Taskmaster Luga Event

function event_death_complete(e)
    if(e.self:CastToNPC():GetSp2() == 1029975 or e.self:CastToNPC():GetSp2() == 1029976 or e.self:CastToNPC():GetSp2() == 1029977 or e.self:CastToNPC():GetSp2() == 1029978) then --spawn groups inside the water spirit room
        eq.signal(226097,1); -- signal An_ancient_spirit (226097) to add to wave counter
    end

    if(e.self:CastToNPC():GetSp2() == 46865 or e.self:CastToNPC():GetSp2() == 29967 or e.self:CastToNPC():GetSp2() == 46868 or e.self:CastToNPC():GetSp2() == 29968 or e.self:CastToNPC():GetSp2() == 46869) then --spawn groups inside Ritualist Tzobodin room
        eq.signal(226218,1); -- signal A_hate (226218) to add to wave counter
    end
end
