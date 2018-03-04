//================================================================================
// CBPSkillManager.
//================================================================================
class CBPSkillManager extends SkillManager;

function CreateSkills (DeusExPlayer Player)
{
	local Skill Z89;

	V06();
	Super.CreateSkills(Player);
	Z89=FirstSkill;
JL001C:
	if ( Z89 != None )
	{
		Z89.NetPriority=1.40;
		Z89=Z89.Next;
		goto JL001C;
	}
}

function Destroyed ()
{
	V06();
	Super.Destroyed();
}

final function V06 ()
{
	local Skill VAC;

	VAC=FirstSkill;
JL000B:
	if ( VAC != None )
	{
		VAC.Destroy();
		VAC=VAC.Next;
		goto JL000B;
	}
	FirstSkill=None;
}

defaultproperties
{
    NetPriority=1.40
}
