class GagePlayer : DoomPlayer
{
  int challengeStartTimeTk;
  const oxygenDurationS = 30;

	Default {
		// Height 32;
// 		CameraHeight 100;
		// ProjectilePassHeight 75;
		// Player.ViewHeight 75;
		// +BUDDHA
		//-PICKUP
		
// 		Player.WeaponSlot 1, "ImpFist", "BroomWeapon";
// 		Player.WeaponSlot 2, "ImpGun";
// 		Player.WeaponSlot 3, "MugGun";
		//Player.WeaponSlot 3, "ImpGun";
// 		Player.WeaponSlot 4, "Pistol";
		//Player.WeaponSlot 5, "ImpGun";
		//Player.WeaponSlot 6, "ImpGun";
		//Player.WeaponSlot 7, "ImpGun";
		
		Player.DisplayName "Gage Blackwood";
// 		Player.StartItem "ImpFist";
		//Player.StartItem "ImpGun";
// 		Player.StartItem "Mana1",100;
		
		
// 		Speed 0.5;
// 		Health START
    Player.RunHealth 99999;
    Player.Face "GBW";
	}
	
	override void PostBeginPlay()
    {
		super.PostBeginPlay();
		// A_Log("Player init");
		// ClearInventory();
    challengeStartTimeTk = level.time;
	}
	
	override void Tick()
	{
		Super.Tick();

    let timeSinceStartTk = level.time - challengeStartTimeTk;
		let timeSinceStartS = Thinker.Tics2Seconds(timeSinceStartTk);
    A_SetInventory("Clip", oxygenDurationS - timeSinceStartS);
    if((oxygenDurationS - 10) * 35 == timeSinceStartTk) {
      Console.Printf("Oxygen levels critical!");
    }
    if (oxygenDurationS * 35 == timeSinceStartTk) {
			Console.Printf("You ran out of oxygen!");
      A_Die();
    }

		// Check for DEBUG options
		let printInventoryFlagCV = CVar.FindCVar("print_inventory_flag");
		if (printInventoryFlagCV.GetInt() != 0) {
			Console.Printf("Print Inventory.");
			printInventoryFlagCV.SetInt(0);
			// Console.Printf("ScottsBox:" .. CountInv("ScottsBox"));
			// Console.Printf("UselessJunk:" .. CountInv("UselessJunk"));
		}
	}
	
	States
	{
		Spawn:
		TNT1 A 2 {
// 			A_Log("Poochy.Spawn");
		}
		Loop;
	}
}

/* REFERENCE

class EffectPlayer : DoomPlayer
{
	override void Tick()
	{
		Super.Tick();
		
		if (!player || !player.mo || player.mo != self)	
			return;
			
		let timescale = CVar.FindCVar("timescale");
		let scale = CVar.FindCVar("scale");
		let distortion = CVar.FindCVar("distortion");
		let subtractive = CVar.FindCVar("subtractive");
		let animh = CVar.FindCVar("animh");
		let anims = CVar.FindCVar("anims");
		let animv = CVar.FindCVar("animv");
		let tintr = CVar.FindCVar("tintr");
		let tintg = CVar.FindCVar("tintg");
		let tintb = CVar.FindCVar("tintb");

		
		Shader.SetUniform1f(Player, DISTORTION_SHADER, "scale", scale.GetFloat());
		Shader.SetUniform1f(Player, DISTORTION_SHADER, "distortionMultiplier", distortion.GetFloat());
		Shader.SetUniform1f(Player, DISTORTION_SHADER, "subtractiveDistortionMultiplier", subtractive.GetFloat());
		
		Shader.SetUniform1f(Player, DISTORTION_SHADER, "NewTime", level.time * timescale.GetFloat());
		Shader.SetUniform3f(Player, DISTORTION_SHADER, "tintColor", (tintr.GetFloat(), tintg.GetFloat(), tintb.GetFloat()));
		
		let hue = animh.GetBool() ? sin(level.time) : 0;
		let sat = anims.GetBool() ? cos(level.time) * 2 : 0;
		let val = animv.GetBool() ? (sin(level.time) + 1) / 2.5 : 0;
		
		Shader.SetUniform3f(Player, DISTORTION_SHADER, "hsvShift", (hue, sat, val));
	}
	

	override void PostBeginPlay()
	{
		Console.Printf("Player init");
		super.PostBeginPlay();
		
		//Shader.SetEnabled(Player, DISTORTION_SHADER, true);
		/*
        ThinkerIterator MonsterFinder = ThinkerIterator.Create("Actor");
        Actor mo;
        while ( mo = Actor(MonsterFinder.Next()) )
        {
            if ( mo.bIsMonster )
            {
                //mo.RenderStyle = "Fuzzy";
				Console.Printf("Got monster" .. mo);
            }
		}
		*//*
	}
}

class Imp: DoomPlayer
{		
	const TELEPORT_TARGET_TID = 13;
	const STARTING_HEALTH = 100;
	
	bool justUsedMemeTeleporter;
	
	override void PostBeginPlay()
    {
		super.PostBeginPlay();
		//A_Log("Player init");
		A_GiveInventory ("Mana1", 200);
		//bInvulnerable = true;  // It works to set invulnerable flag here to switch to godmode mugshot - iddqd also works but not after teleport happens :/
	}
	

	Default {
		+BUDDHA
		//-PICKUP
		
		Player.WeaponSlot 1, "ImpFist", "BroomWeapon";
		Player.WeaponSlot 2, "ImpGun";
		Player.WeaponSlot 3, "MugGun";
		//Player.WeaponSlot 3, "ImpGun";
		Player.WeaponSlot 4, "Pistol";
		//Player.WeaponSlot 5, "ImpGun";
		//Player.WeaponSlot 6, "ImpGun";
		//Player.WeaponSlot 7, "ImpGun";
		
		Player.DisplayName "Imp";
		Player.StartItem "ImpFist";
		//Player.StartItem "ImpGun";
		Player.StartItem "Mana1",100;
		
		
		Speed 0.5;
		Health STARTING_HEALTH;
	}
	
	States
	{
		Spawn:
		TNT1 A 2 {
			//A_Log("Imp.Spawn");
		}
		
		Pain:  //CHECK HP... IF == 1 teleport
		TNT1 A 2
		{
			if(A_JumpIfHealthLower(2,"Null"))
			{
				let numRespawnsCVar = CVar.FindCVar("numPlayerRespawns");
				let numRespawns = numRespawnsCVar.GetInt();
				
				if (justUsedMemeTeleporter) {
					//A_Log("Skipping count for teleporting back from meme level");
					justUsedMemeTeleporter = false;
				} else {
					numRespawns++;
					numRespawnsCVar.SetInt(numRespawns);
					//A_Log("Respawns:");
					//A_LogInt(numRespawns);
				}
				// Simulated teleport
				let teleporter = GetTeleporter();
				if (!teleporter) {
					A_Log("Teleporter null");
				} else {
					// Teleport/TeleportFrag are a ZScript actor functions with the following signatures:
					// bool Teleport(Vector3 pos, double angle, int flags)
					// bool TeleportMove(Vector3 pos, bool telefrag, bool modifyactor = true)
					TeleportMove(teleporter.pos, true);
					HealThing(STARTING_HEALTH);
					A_PlaySound("misc/teleport");
					//A_PlaySound("bg/doomjazz", CHAN_BODY, 1, true);
					ACS_NamedExecute("SetMusic", 0, true);
					
					if (numRespawns == 2) {
						ACS_NamedExecute("SetPlayerType", 0, 0);
					}
				}
			}
		}
		Goto Spawn;
		
		MemeTeleported:
		TNT1 A 0 {
			//A_Log("Imp.MemeTeleported");
			justUsedMemeTeleporter = true;
		}
		Goto Spawn;
		
		FormerHuman:
		TNT1 A 2 {
			//A_Log("Imp.FormerHuman");
			//bInvulnerable = true; //Try to get former human mugshot to show on HUD. doesn't seem to work after you take damage once.
		}
		Loop;
		
		CanPickup:
		TNT1 A 2 {
			bPickup = true;
		}
		Loop;
		
		DisableGod: // Currently unused
		TNT1 A 2 {
			//A_Log("Imp.DisableGod");
			//bInvulnerable = false;
		}
		Goto Spawn;
	}
	
	Actor GetTeleporter()
    {
		//A_Log("GetTeleporter");
        let MonsterFinder = ActorIterator.Create(TELEPORT_TARGET_TID);
        Actor mo = null;
        while ( mo = Actor(MonsterFinder.Next()) )
        {
			//A_Log("got actor");
			//A_LogInt(mo.tid);
			return mo;
        }
		return mo;
    }
}
*/
