# NOTICE
This addon is currently under heavy development, any PR's and contributions is highly appreciated. 💖 

# TODO
### High Priority
- Make some shared folders
- Animations (Walking, running, turning, climbing, death, running death)
- Path Finding
- Wandering Behavior
- Attacking behavior (Attack non infected. Randomly when idle and walking, when near other nearby Common Infected, have a chance to start a fight with another common infected. They should stay in place while fighting)
### Medium Priority
- Climbing
- Sounds
- Clientside / Serverside death ragdolls
### Low Priority
- Music System (Play the ambient Choir sounds when Common Infected are nearby)
- Possibly do Uncommon Infected for L4D1 Variations and L4D2
- Create some entities for the Fallen Survivor Infected to drop (Pills +25% health, HealthKit +80% health, Grenades)

### Animation Issues:
Somewhere in L4D2, there's other Animations that if you don't have L4D2 mounted, it casues issues????

### General:
Have them no collide with other Common Infected, Unstuck detection, if stuck, kill them.

### Climbing System:
I have no idea how I could make this happen...

### Music System:
When the music system is enabled, and common infected are nearby the player around 2000 HU, play ambient zombie choir sounds, with a 30 second delay in between the next sound playing. 

### Horde Music:
TBD

### Wandering / Idling:
When Common Infected are wandering/idle, they should be able to lean against walls, sitting down, lying down. Having limited sightlines for seeing their pray (Make this into a convar)

### Voices:
When making voices for the nextbots to use, Males should have a range of a random pitch of 92 to 104, and for Females, 100 to 112.
Why do we need pitches? Both males and females will have shared sounds plus their own gender sounds.

Have the host/player be able to choose which voicesets that the commons should use, L4D1, L4D2 or default? (Default is where the model is originally from, L4D1 models use L4D1 sounds, L4D2 models use L4D2 sounds)

### Models:
When it comes down to models, we make all of the models available for the player/admins to customize, sorta similar to how the population is handled in L4D2.
Should the player only want Military, Police, Rural, Common, Hospital, or all of above? ect ect.

### Difficulty:
A difficulty setting for the commons.
Commons will also have a damage immunity on the target after a successful attack.

Health: 50 (For all difficulties)

### Damage dealt to target
- Easy: 1 dmg per hit, 0.5 immunity delay
- Normal: 2 dmg per hit, 0.33 immunity delay
- Advanced: 5 dmg per hit, 0.5 immunity delay
- Expert: 20 dmg per hit, 1.0 immunity delay
