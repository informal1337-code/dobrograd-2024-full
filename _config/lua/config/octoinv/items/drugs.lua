------------------------------------------------
--
-- DRUGS
--
------------------------------------------------

local function useDrugFunction(buffName, buffLength, sound)
	return function()
		return L.drugs_use, 'octoteam/icons/drug.png', function(ply)
			if ply:HasBuff('Overdose') then
				ply:Notify('warning', L.overdose_hint)
				return 0
			end
			if ply.bleeding then
				ply:Notify('warning', 'Ты при смерти')
				return 0
			end
			ply:AddBuff(buffName, buffLength)
			ply:EmitSound(sound, 75, 100)
			return 1
		end
	end
end

octoinv.registerItem('drug_vitalex', {
	name = L.vitalex,
	icon = 'octoteam/icons/pills2.png',
	mass = 0.2,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/props_lab/jar01b.mdl',
	desc = L.description_vitalex,
	use = { useDrugFunction('HealthRecovery', 45, 'npc/barnacle/barnacle_gulp2.wav') },
})

octoinv.registerItem('drug_painkiller', {
	name = L.painkiller,
	icon = 'octoteam/icons/medicine_morphy_pen.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/props_lab/jar01b.mdl',
	desc = L.description_painkiller,
	use = {
		function()
			return L.drugs_use, 'octoteam/icons/drug.png', function(ply)
				if ply:HasBuff('Overdose') then
					ply:Notify('warning', L.overdose_hint)
					return 0
				end

				ply:AddBuff('Painkillers', 80)
				ply:SetHealth(math.min(ply:Health() + 5, ply:GetMaxHealth()))
				ply:EmitSound('npc/barnacle/barnacle_gulp2.wav', 75, 100)

				return 1
			end
		end,
	},
})

octoinv.registerItem('drug_relaxant', {
	name = L.relaxant,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/props_lab/jar01b.mdl',
	desc = L.description_relaxant,
	use = { useDrugFunction('Muscle Relaxant', 80, 'npc/barnacle/barnacle_gulp2.wav') },
})

octoinv.registerItem('drug_vampire', {
	name = L.vampire,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/props_lab/jar01b.mdl',
	desc = L.description_vampire,
	use = { useDrugFunction('Vampire', 120, 'npc/barnacle/barnacle_gulp2.wav') },
})

octoinv.registerItem('drug_dextradose', {
	name = L.dextradose,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/cocn.mdl',
	desc = L.description_dextradose,
	use = { useDrugFunction('Dextradose', 120, 'player/suit_sprint.wav') },
})

octoinv.registerItem('drug_roids', {
	name = L.roids,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/cocn.mdl',
	desc = L.description_roids,
	use = { useDrugFunction('Steroids', 80, 'player/suit_sprint.wav') },
})

octoinv.registerItem('drug_bouncer', {
	name = L.cocaine,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/cocn.mdl',
	desc = L.description_cocaine,
	use = { useDrugFunction('DoubleJump', 80, 'player/suit_sprint.wav') },
})

octoinv.registerItem('drug_antitoxin', {
	name = L.antitoxin,
	icon = 'octoteam/icons/medicine_antidote_pen.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/props_lab/jar01b.mdl',
	desc = L.description_antitoxin,
	use = {
		function(ply, item)
			return L.drugs_use, 'octoteam/icons/drug.png', function(ply, item)
				if ply:HasBuff('Overdose') then
					ply:Notify('warning', L.overdose_hint)
					return 0
				end

				ply:ClearBuffs()
				ply:MoveModifier('drug', nil)
				ply:MoveModifier('drug2', nil)
				ply:EmitSound('npc/barnacle/barnacle_gulp2.wav', 75, 100)

				return 1
			end
		end,
	},
})

octoinv.registerItem('weed_pot', {
    name = 'Горшок для растений',
    icon = 'octoteam/icons/plant_pot.png',
    mass = 5.0,
    volume = 5.0,
    model = 'models/nater/weedplant_pot.mdl',
    desc = 'Терракотовый горшок для выращивания растений.',
    nostack = true,
})

octoinv.registerItem('weed_soil', {
    name = 'Почва для растений',
    icon = 'octoteam/icons/soil.png',
    mass = 3.0,
    volume = 2.0,
    model = 'models/props_junk/garbage_bag001a.mdl',
    desc = 'Мешок с плодородной почвой для выращивания растений.',
})

octoinv.registerItem('weed_water', {
    name = 'Вода для растений',
    icon = 'octoteam/icons/water_can.png',
    mass = 1.0,
    volume = 1.0,
    model = 'models/props_junk/garbage_milkcarton001a.mdl',
    desc = 'Вода для полива растений.',
})

octoinv.registerItem('weed_seed', {
    name = 'Семена марихуаны',
    icon = 'octoteam/icons/weed_seed.png',
    mass = 0.1,
    volume = 0.1,
    model = 'models/katharsmodels/contraband/zak_wiet/zak_seed.mdl',
    desc = 'Семена конопли для выращивания.',
    nostack = true,
})

octoinv.registerItem('weed_harvested', {
    name = 'Марихуана',
    icon = 'octoteam/icons/drugs_marijuana.png',
    mass = 0.2,
    volume = 0.2,
    model = 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl',
    desc = 'Высушенные и готовые к употреблению соцветия конопли.',
    nostack = true,
    use = { 
        function()
            return 'Употребить', 'octoteam/icons/drug.png', function(ply)
                if ply:HasBuff('Overdose') then
                    ply:Notify('warning', 'У вас передозировка')
                    return 0
                end
                if ply.bleeding then
                    ply:Notify('warning', 'Ты при смерти')
                    return 0
                end
                ply:AddBuff('Weed', 35)
                ply:EmitSound('player/suit_sprint.wav', 75, 100)
                return 1
            end
        end,
        function()
            return 'Продать', 'octoteam/icons/money.png', function(ply)
                -- Совместимость с BraxNetRP банкоматами
                if BraxNetRP then
                    ply:AddBankMoney(WEED_PRICE)
                else
                    ply:addMoney(WEED_PRICE)
                end
                
                ply:Notify('Вы продали марихуану за ' .. (BraxNetRP and BraxNetRP.formatMoney(WEED_PRICE) or DarkRP.formatMoney(WEED_PRICE)))
                
                if WEED_WANTED then
                    ply:wanted(nil, 'Продажа наркотиков', WEED_WANTEDTIME)
                end
                return 1
            end
        end
    }
})


octoinv.registerItem('drug_weed', {
	name = L.marijuana,
	icon = 'octoteam/icons/drugs_marijuana.png',
	mass = 0.2,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl',
	desc = L.description_marijuana,
	use = { useDrugFunction('Weed', 35, 'player/suit_sprint.wav') },
})

octoinv.registerItem('drug_pingaz', {
	name = L.pingaz,
	icon = 'octoteam/icons/drugs_methamphetamine.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/katharsmodels/contraband/metasync/blue_sky.mdl',
	desc = L.description_pingaz,
	use = { useDrugFunction('Pingaz', 120, 'player/suit_sprint.wav') },
})

octoinv.registerItem('drug_preserver', {
	name = L.preserver,
	icon = 'octoteam/icons/medicine_adrenaline_pen.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/katharsmodels/syringe_out/syringe_out.mdl',
	desc = L.description_preserver,
	use = { useDrugFunction('Preserver', 120, 'ambient/levels/canals/toxic_slime_gurgle8.wav') },
})

octoinv.registerItem('drug_meth', {
	name = L.steroids,
	icon = 'octoteam/icons/drug.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	nodespawn = true,
	model = 'models/katharsmodels/syringe_out/syringe_out.mdl',
	desc = L.description_steroids,
	use = {
		function(ply, item)
			do return false, L.temporary_disable end -- TEMP
			if ply:HasBuff('Overdose') then return false, L.overdose_hint end
			return L.drugs_use, 'octoteam/icons/drug.png', function(ply, item)
				ply:AddBuff('Meth', 120)
				ply:EmitSound('ambient/levels/canals/toxic_slime_gurgle8.wav', 75, 100)

				return 1
			end
		end,
	},
})
