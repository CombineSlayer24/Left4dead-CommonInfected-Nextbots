# Nextbots
- Common Infected ( **`Z_`** ) - L4D1 for now
----------------------------------------------------
- Uncommon Infected ( **`Z_`** ) - Both L4D1 & L4D2
  - Fallen Suvivor
  - Riot
  - Clown
  - CEDA
  - Mud Men
  - Jimmy Gibbs Jr.
----------------------------------------------------
- Special Infected ( **`SI_`** )
  - Smoker
  - Hunter
  - Boomer
  - Charger
  - Jockey
  - Spitter
  - Tank [ *Boss SI* ]
  - Witch [ *Boss SI* ]
  - Leaker [ *Cut SI* ]
  - Screamer [ *Cut SI* ]
----------------------------------------------------
- Survivor Bots ( **`SB_`** )
  - Bill
  - Francis
  - Louis
  - Zoey
  - Nick
  - Ellis
  - Coach
  - Rochelle
----------------------------------------------------
# The Common Infected! ( Code Identifier `Z_` )
- Animations
- Path Finding
- Attacking Behavior
- Climbing
- Voices
- Sounds
- Difficulty
 ----------------------------------------------------
# Animations:
Common Infected (male and Females) have the same animation (ACT) names, except for the females, take a look at [ACT_LIST.txt](https://github.com/CombineSlayer24/Left4dead-CommonInfected-Nextbots/blob/main/ACT_LIST.txt).

When Common Infected are walking around and decide to turn, let them turn without no turning animation. If they turn left or right sharply, play the turning act animation.

When common infected are running and they stop their run, they should play their animation (`ACT_TERROR_RUN_INTENSE_TO_STAND_ALERT`).

# Path Finding - General Idle:
For path finding, depending the their state... When Idle, walking around, they should wander around in a small area, we don't need them traveling 600 HU long, short distance, like 100, 150. Around there.

When idle, Common Infected randomly should walk around, standing still, be able to sit, lie down, lean against walls.

# Attacking Behavior:
When Common Infected are in idle state, they should have a chance to fight with another common infected. The way that this should work is whenever a CI is walking around, they will choose a random CI that is the closest to them. Both of the CI should fight eachother. When they are fighting another CI, make their damage -65% so they will be able to fight longer (Who doesn't like to watch a good fight?)

They have limited Vision, 500 for base right now when spotting a prey.

# Climbing:
When Common Infected are going over slight bumps, have them do the step up climb animation.

More words soon.
# Voices:
Males should have a range of a random pitch of 95 to 104, and for Females, 100 to 112. Why do we need pitches? Both males and females will have shared sounds plus their own gender sounds.

Have the host/player be able to choose which voicesets that the commons should use, L4D1, L4D2 or default? (Default is where the model is originally from, L4D1 models use L4D1 sounds, L4D2 models use L4D2 sounds)

# Difficulty:
A difficulty setting for the commons.
Commons will also have a damage immunity on the target after a successful attack.

Health: 50 (For all difficulties)

### Damage dealt to target
- Easy: 1 dmg per hit, 0.5 immunity delay
- Normal: 2 dmg per hit, 0.33 immunity delay
- Advanced: 5 dmg per hit, 0.5 immunity delay
- Expert: 20 dmg per hit, 1.0 immunity delay

----------------------------------------------------
# The Special Infected! ( Code Identifier `SI_` )
- TODO: Add details laters
----------------------------------------------------
# The Survivor Bots! ( Code Identifier `SB_` )
- TODO: Add details laters
----------------------------------------------------
# Music System:
When the music director is enabled, have random music sounds played in the background (contagion, glimpse). Make sure only 1 instance of whatever is playing

If Common Infected are nearby the player around 2000 HU, play ambient zombie choir sounds, with a 30 second delay in between the next sound playing.

Expand more later.
----------------------------------------------------
# Models (Common Infected)
When it comes down to models, we make all of the models available for the player/admins to customize, sorta similar to how the population is handled in L4D2.
Should the player only want Military, Police, Rural, Common, Hospital, or all of above? ect ect.