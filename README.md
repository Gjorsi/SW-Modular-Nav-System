# Modular Navigation System for Stormworks
Stormworks is a simulator game where you design and pilot your own sea-rescue service, in a physics playground.

This system was created by in-game scripting using the programming language Lua. 
Note that the game restricts scripts to 4096 characters of code due to multiplayer network limitations, which means for complex scripts, variable names must be shortened and comments left out.

## MNS 01 Map module
This is the base module, needed for any of the others to work.
It provides an interactive map with location data of the hosting vehicle, and a speed / heading vector.

## MNS 02 Autopilot module
This module can be added as a layer on top of module 01 Map.
Now you can click and hold on the map to set waypoints, which the module will navigate through using throttle and rudder control. Note that throttle and rudder control must have a switchbox operated by the module's Autopilot boolean output. Properties can be changed to limit the use of throttle between 0 and 1.

## MNS 03 AIS module
This module adds AIS as a layer to the base module MNS 01 Map.
Vessels using this module share their navigational data over radio communication, using frequency shifting to allow multiple vessels to communicate in a sort of "mesh" radio network.

Information shared over radio includes location, speed, heading and optionally a name / callsign. The information will be displayed on participating units' screens as tracks with speed / heading vectors. The tracks change colors and fade out as connection is lost, to show the user how up-to-date the information on screen is.

To use the name / callsign broadcasting feature, attack a MNS Text Encoder to enter the hosting vessel's name.

![alt text](https://github.com/Gjorsi/SW_ModularNavSystem/blob/master/Pictures/MNS_screenshot.png "Modular Navigation System screen")

Modular Navigation System screen


## MNS Text Encoder
Displays a keyboard on screen such that user can type input to the MNS 03 AIS module.
Encodes text and numbers to the limited 32-bit output which can be decoded by the MNS. 
Press ENT to send the input to AIS.

![alt text](https://github.com/Gjorsi/SW_ModularNavSystem/blob/master/Pictures/Text_Encoder_scrnshot.png "Text Encoder")

Text Encoder


![alt text](https://github.com/Gjorsi/SW_ModularNavSystem/blob/master/Pictures/MNS_02_Autopilot_Connections.png "Signal connection view of Autopilot module")

Signal connection view of Autopilot module


![alt text](https://github.com/Gjorsi/SW_ModularNavSystem/blob/master/Pictures/MNS_02_Autopilot_properties.png "Properties settings of Autopilot module")

Properties settings of Autopilot module

