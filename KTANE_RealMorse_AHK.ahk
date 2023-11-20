;KTANE RealMorse
;A simple AutoHotkey script for the Keep Talking and Nobody Explodes game.
;It reads the flashing morse code light, and plays morse code audio to match.

;Ctrl-Alt-Shift-n
Hotkey, ^+!m, StartMorseCode, On

toolString := "RealMorse Watching..."
recordWordSeq := ""

wasBright := False
isBright := False
currentColor := ""

timeScaleMs := 10               
measureStartMs := 0
measureEndMs := 0
ticksSinceLastChange := 0
timeInLastPeriodMs := 0

ditTimeMin := 1
ditTimeMax := 399
dashTimeMin := 400
dashTimeMax := 999999

breakSymbolMin := 1
breakSymbolMax := 499
breakletterMin := 500
breakLetterMax := 1999
breakWordMin := 2000
breakWordMax := 999999

morseDictionary := { "i" : "e"
	, "ii" : "i"
	, "iii" : "s"
	, "iiii" : "h"
	, "iiia" : "v"
	, "iia" : "u"
	, "iiai" : "f"
	, "ia" : "a"
	, "iai" : "r"
	, "iaii" : "l"
	, "iaa" : "w"
	, "iaai" : "p"
	, "iaaa" : "j"
	, "a" : "t"
	, "aa" : "m"
	, "aaa" : "o"
	, "aai" : "g"
	, "aaia" : "q"
	, "aaii" : "z"
	, "ai" : "n"
	, "aia" : "k"
	, "aiaa" : "y"
	, "aiai" : "c"
	, "aii" : "d"
	, "aiia" : "x"
	, "aiii" : "b" }

MsgBox,
(

KTANE RealMorse for AutoHotkey

Press Ctrl-Shift-Alt-M to enable and disable the helper.

While enabled, keep the tip of mouse cursor over the blinking light, and do not move the mouse.  Ignore the flashing light, and just listen.

Note the end of word gap will be the shortest gap instead of the longest, due to the way the timing works.  The longest gap will be after the second letter.


)
return


#Persistent
	CoordMode Pixel, Screen
	CoordMode Mouse, Screen
	return

;Ctrl-Alt-Shift-n
;Reloads the script, helpful to enable if you're editing the code.
;^+!n::
;	gosub ReloadCommand
;	return

;Setup the cursor color check routine
;Shortest possible on windows is 10-15ms
StartMorseCode:
	Hotkey, ^+!m, StartMorseCode, Off

	measureStartMs := A_TickCount
	measureEndMs := A_TickCount

	SetTimer, WatchCursor, %timeScaleMs%
	Sleep 1000

	Hotkey, ^+!m, StopMorseCode, On
	return

;Shutdown and reset
;The tooltips don't always clear, so try again after a delay
StopMorseCode:
	Hotkey, ^+!m, StopMorseCode, Off
	SetTimer, WatchCursor, Off, 1000
	ToolTip
	Sleep 200

	recordWordSeq := ""
              
	measureStartMs := 0
	measureEndMs := 0
	ticksSinceLastChange := 0
	timeInLastPeriodMs := 0
	wasBright := False
	isBright := False

	ToolTip
	Sleep 1000
	
	Hotkey, ^+!m, StartMorseCode, On
	Sleep 200
	ToolTip
	return

;Get the cursor pixel color, and process it
WatchCursor:
	MouseGetPos X, Y
	PixelGetColor currentColor, %X%, %Y%, RGB
	
	gosub UpdatePixelData
	gosub UpdateChangeData
	ToolTip, %toolString%
	
	return

;To allow less exact cursor placement, if the Red componant is
;less than A0 (160) consider the light dim, and higher, consider
;it bright.  Usually dim is Red~=87 and lit is Red~=FD.
UpdatePixelData:
	isBright := (SubStr(currentColor, 3, 1)~="^\d" ? False : True)
	return

;If the light changes state, calculate how long it was in the
;prior state, and get the symbol matching the time
UpdateChangeData:
	ticksSinceLastChange := ticksSinceLastChange + 1
	measureEndMs := A_TickCount

	if(isBright != wasBright) {
		timeInLastPeriodMs := measureEndMs - measureStartMs
			 
		gosub GetLastCharacter

		measureStartMs := measureEndMs
		ticksSinceLastChange := 0
		wasBright := isBright
	}
	return

;Build the morse sequence, and get the letter when it ends
;Extra conditions for debugging, etc.
GetLastCharacter:
	if(wasBright = True) {
		if(timeInLastPeriodMs >= ditTimeMin and timeInLastPeriodMs <= ditTimeMax) {
			recordWordSeq := recordWordSeq . "i"
		} else if(timeInLastPeriodMs >= dashTimeMin and timeInLastPeriodMs <= dashTimeMax) {
			recordWordSeq := recordWordSeq . "a"
		} else {
			;MsgBox, ERROR_BRIGHT %timeInLastPeriodMs% ms
		}
	} else {
		if(timeInLastPeriodMs >= breakSymbolMin and timeInLastPeriodMs <= breakSymbolMax) {
			;symbol gap, nothing to do
		} else if(timeInLastPeriodMs >= breakletterMin and timeInLastPeriodMs <= breakLetterMax) {
			gosub GetLastLetter
		} else if(timeInLastPeriodMs >= breakWordMin and timeInLastPeriodMs <= breakWordMax) {
			gosub GetLastLetter
		} else {
			;MsgBox, ERROR_DARK %timeInLastPeriodMs% ms
		}
	}
	return

;Lookup the morse sequence in the dictionary
;and play the matching sound file
;Sourced from https://commons.wikimedia.org/wiki/Category:Audio_files_of_Morse_code_-_alphabet
GetLastLetter:
	lastLetter := morseDictionary[recordWordSeq]

	morseFile := "sounds/" . lastLetter . ".wav"
	SoundPlay, %morseFile%

	recordWordSeq := ""
	return

ReloadCommand:
	Reload
	return