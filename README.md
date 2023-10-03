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
- Replace .wav sounds for .mp3 for space reasons
- Possibly do Uncommon Infected for L4D1 Variations and L4D2
- Create some entities for the Fallen Survivor Infected to drop (Pills +25% health, HealthKit +80% health, Grenades)

### General:
Have them no collide with other Common Infected, Unstuck detection, if stuck, kill them.

### Climbing System:
I have no idea how I could make this happen...

### Music System:
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
A difficulty setting for the commons

Health: 50 (For all difficulties)

### Damage dealt to target
Easy: 1 dmg per hit
Normal: 2 dmg per hit
Advanced: 5 dmg per hit
Expert: 20 dmg per hit