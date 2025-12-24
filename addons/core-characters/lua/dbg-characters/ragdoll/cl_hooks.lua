-- "addons\\core-characters\\lua\\dbg-characters\\ragdoll\\cl_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('dbgWeaponSelector.shouldHide', 'dbgChars.ragdoll', function()
	if LocalPlayer():GetNetVar('Ragdolled') then
		return true
	end
end)

local function cantVoice(ply)
	if ply:GetLocalVar('RagdollVoiceDisabled') then
		return false
	end
end
hook.Add('PlayerStartVoice', 'dbgChars.ragdoll', cantVoice)
hook.Add('PlayerEndVoice', 'dbgChars.ragdoll', cantVoice)
