extends Node
class_name SkillSystem

const SKILLS = {
	"blink": {
		"type": "use_number",
		"use_number": 3,
		"anim": "blink"
	},
	"smollification": {
		"type": "cooldown",
		"cooldown": 10,
		"anim": "smollification",
		"skill_ready": true
	}
}

static func get_skill_names():
	return SKILLS.keys()
	
static func get_skill_data(skill_name):
	assert(skill_name in SKILLS.keys())
	return SKILLS[skill_name].duplicate()
