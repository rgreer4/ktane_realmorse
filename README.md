
# KTANE RealMorse

It's a simple AutoHotkey script for the Keep Talking and Nobody Explodes game.  It reads the flashing morse code light, and plays morse code audio to match.

Why? I despise the flashing light. I know morse code by ear, but the light hits a brick wall in my brain. So I made this to have it play morse code sounds instead.

## Usage

* Make sure AutoHotkey is installed, and download this repo.

* Run the script before starting the game, and then press *Ctrl-Shift-Alt-M* to enable or disable the helper.

* While enabled, keep the tip of mouse cursor over the blinking light, and do not move the mouse.  Ignore the flashing light, and just listen.  

* Using a morse map like https://upload.wikimedia.org/wikipedia/commons/c/ca/Morse_code_tree3.png will help even more.

## Issues

The end of word gap will be the shortest gap instead of the longest, due to the way the timing works. The longest gap will be after the second letter. (This was a compromise vs using real time individual sounds, but that was more erratic than standard sounds for each letter -- could likely be improved.  Or maybe an actual mod?)

You could of course edit this to allow cheating, but then what's the point of playing a game like KTANE at all?  If you hate the morse module, try it with audio, and it shouldn't take long before you don't even need the lookup table.