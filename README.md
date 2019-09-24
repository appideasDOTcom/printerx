# Source code and rendered models for the *printerx* project

I purchased a 3D printer in May of 2017, and I am 85% happy with it. I purchased my first CNC router in May of 2018, and I am 0% happy with it, so it has been sitting in a closet since I purchased I good CNC router a month later.

My 3D printer is a cheap clone of a Prusa i3 MK2. There are a couple of design "decisions" in that style of printer that have frustrated me. They have also made using the printer more work than is necessary, while achieving poorer results at slower speeds than what is possible with a couple design tweaks.

Those problems are:

#### Impossible to true-up
Given the way the pieces fit together and the weight distribution on the frame, it is *nearly* impossible to make every axis line up at right angles. Once you get it there, bumping the machine can throw it off. Forget about moving it anywhere. There are many "upgrades" you can print to "fix" the problem. The only real solution that I have seen for a real Prusa printer is the "Bear" upgrade (source needed). But I don't have a real Prusa printer, and the one I'm making won't be one either, but I'll address the true-up and frame stability issues in much the same manner as the Bear upgrade.

#### Impossible to keep the X axis carriage (the part that goes up and down on the Z axis) straight/level
It can't be done. When you drive two microstepping motors, they can't possibly stay in sync. Physics is against you. Taking encouragement from several sources, I converted the X axis carriage lift mechanism (how you get lift on the Z axis) to using one motor and two lead screws. The pulley design was inspired by this Open Builds printer (source needed)

### printerx is a 3D printer...
...whose name I couldn't really think of - that is an expirement I am conducting to resolve these issues. This printer may or may not ever see the light of day.

I borrowed some models and design ideas from other sources. Materials from those sources are licensed according to the original source. I only chose open source materials to include. Attributions (will) appear where appropriate (sources needed).

My initial inspiration was frustration with the above-mentioned shortcomings of my 3D printer, coupled with the fact that I had a solid 2020 frame and motors left over from my closeted CNC router, plus I had all the electronics sitting around. I had the ideas in my head for a few months prior, so I just needed to start ordering the accessories to make a new printer. The result is a totally unique, solid 3D printer that unashamedly copies good, Open Source designs.

This is an early work in progress. All materials created by me are GPLv3. I'll get more official with licensing and attribution as this project gets closer to being something useful to someone other than me.
