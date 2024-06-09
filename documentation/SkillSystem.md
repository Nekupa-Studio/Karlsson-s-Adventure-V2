# [SkillSystem](../scripts/flappy/skill_system.gd)

> 🚨 Since the game is still in **prototyping phase** we're still **unable to determine whether this system is final**

## Overview

> 💡 **SkillSystem** is a *static class* that will be used to store **informations about skills.**

Since most of the heavy work will be done through an [AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html) which is able to run functions and change properties during its course, the **SkillSystem** class isn't planned to be very complex.

## Skills

The class will have a **dictionary containing skill informations.** 
As you can see below, there will be **two types of skills** (as of now): 
- **use_number**: meaning the skill can be activated **without cooldown** (as long as it isn't active) a **certain amount** of times.
- **cooldown**: meaning the skill has an **unlimited amount** of uses, but a **cooldown** between uses.

```gdscript
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
```

### Data-Structure

#### Limited Uses Skills

As seen above, limited uses skills will be defined using **three properties:**

- **type:** use_number
- **use_number:** number of times you want the skill to be usable.
- **anim:** name of the anim in the animation player.

#### Cooldown-bound Skills

Those will have **four properties**:

- **type:** cooldown.
- **cooldown**: time before next-use.
- **anim**: name of the anim in the animation player.
- **skill_ready**: true *(used by the player script)*.