octolib = octolib or {}
octolib.bind = octolib.bind or {}

if SERVER then
    AddCSLuaFile()
    include('sv_init.lua')
else
    include('cl_init.lua')
end

octolib.shared('shared')