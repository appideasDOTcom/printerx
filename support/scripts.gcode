; This is a place to put helper gcode scripts that can be copied and pasted into other places

;; PAUSE AND RESUME ;;

; Open the gcode file that needs a pause, find the line that contains 'G1 Z[height]', and add the uncommented lines from 
;    one of the examples below.

; I will generally use method 2 because I don't lose as much filament. Use method 1 if you need a purge or are concerned 
;    about where the nozzle will go when it's "parked"

; Method 1: Hijack the filament change mechanism to provide a better pause and resume experience with a simpler command
M300 S1000 P5000		; Make an obnoxious noise since beeps aren't currently working for M600 (using B<number>)
M600 X20 Y20 Z20 L0 U0 	; Move (X, Y) to (20, 20); raise Z by 20; beep 5 times; load and retract 0 (override firmware filament change values)
; This works really well, and does not require printing from SD card. Advantage over method 2: It uses the firmware's 
;    nozzle park feature and settings.
; One drawback: It purges too much filament before restarting.

; Method 2: A slightly more complicated pause and resume script.
; It has the advantage of not purging too much plastic before restart because 
;    it's a concise process that wasn't designed for another purpose.
; Disadvantage from method 1: You need to be aware of how far you can move X and Y for each print, which may require 
;    some awareness of where the printhead will be.
; To resume from Octoprint, the "Pause" button will change to "Resume" when the printer pauses.
; Other interfaces presumably know how to recover from a printer pause, but I haven't tested them.
; Printing from SD card prompts the user to press the button.
; Also, the beep works.
G91							; Set relative position mode
G1 Z10 X-40 Y-40			; Raise the hotend and move it out of the way
G90                 		; Set absolute position mode
M400						; Make sure all moves are complete before continuing
M300 S1000 P5000			; Make an obnoxious noise
M0 Press button to resume	; Pause and prompt. From Octoprint, press "Resume" not "Restart"!
; User hit the button, so return to previous position and resume
G91							; Set relative position mode
G1 Z-10 X40 Y40				; Put the hotend back where we found it
G90                 		; Set absolute position mode



