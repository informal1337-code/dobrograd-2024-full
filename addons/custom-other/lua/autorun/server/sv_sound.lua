for k,v in ipairs(ents.GetAll()) do
    if v:Entity() == 'env_soundscape' then
        Entity():Remove()
    end
end