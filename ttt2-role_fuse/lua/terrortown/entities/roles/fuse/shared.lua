if SERVER then
  AddCSLuaFile()

  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_fuse.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(255, 98, 1, 255)

  self.abbr = "fuse" -- abbreviation
  self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false
  
  self.isOmniscientRole = true

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_TRAITOR

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 1, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 33,
    traitorButton = 1, -- can use traitor buttons
    shopFallback = SHOP_FALLBACK_TRAITOR
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_TRAITOR)
end

--Add Cooldown Status
if CLIENT then
    hook.Add("Initialize", "ttt2_fuse_init", function()
		STATUS:RegisterStatus("ttt2_fuse_timer_status", {
			hud = Material("vgui/ttt/icons/exploder.png"),
			type = "bad",
			name = "Fuse Detonation Timer",
			sidebarDescription = "Kill someone to reset the timer. If it reaches 0 you will explode."
		})
	end)
end

CreateConVar("ttt2_fuse_explode_timer", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

if SERVER then
  -- start timer on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		STATUS:AddTimedStatus(ply, "ttt2_fuse_timer_status", GetConVar("ttt2_fuse_explode_timer"):GetInt(), true)
		timer.Create("ttt2_fuse_timer_explode", GetConVar("ttt2_fuse_explode_timer"):GetInt(), 1, function()
			for k, v in pairs(roles.GetTeamMembers(TEAM_TRAITOR)) do
				-- make sure he is alive
				if v:GetRoleString() == "fuse" and v:Alive() then
					local pos = v:GetNetworkOrigin()
					local effect = EffectData()
					effect:SetStart(pos)
					effect:SetOrigin(pos)
					effect:SetScale(90)
					effect:SetRadius(300)
					effect:SetMagnitude(200)
					util.BlastDamage(v, v, pos, 300, 200) 
					util.Effect("Explosion", effect, true, true)  
					return
				end
			end
		end)
	end

	-- Remove timer on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
	end

  -- Check for if the Fuse kills a player
  hook.Add("TTT2PostPlayerDeath", "FuseCheckForKill", function(victim, inflictor, attacker)
    -- make sure the attacker is the fuse
    if attacker:GetRoleString() == "fuse" then
      -- remove timed status
	    STATUS:RemoveStatus(attacker, "ttt2_fuse_timer_status")
      -- read the timed status
      STATUS:AddTimedStatus(attacker, "ttt2_fuse_timer_status", GetConVar("ttt2_fuse_explode_timer"):GetInt(), true)
      -- adjust the explosion timer
      timer.Adjust("ttt2_fuse_timer_explode", GetConVar("ttt2_fuse_explode_timer"):GetInt(), nil, nil)
    end
  end)
end

--Convar Goes Here
if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")
	
	form:MakeSlider({
      serverConvar = "ttt2_fuse_explode_timer",
      label = "label_fuse_explode_timer",
      min = 5,
      max = 120,
      decimal = 0
	})
	
  end
end