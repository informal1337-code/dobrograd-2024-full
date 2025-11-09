local Player = FindMetaTable 'Player'

Player.SteamName = Player.SteamName or Player.Name
function Player:Name()
    return self:GetNetVar('rpname') or self:SteamName()
end
Player.GetName = Player.Name
Player.Nick = Player.Name

function Player:IsPremium()
    return self:GetNetVar('os_dobro') == true
end