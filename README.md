# Ladder
The classic CP/M game Ladder re-written in Turbo Pascal.

#### This is a rewrite in Turbo Pascal of the classic CP/M game "Ladder", originally written by Yahoo Software (not Yahoo!).

![Main Menu](https://github.com/mecparts/Ladder/images/mainmenu.png "Main Menu")

Ladder is an ASCII character based platform arcade game similar to 
Donkey Kong. You travel through levels with platforms and ladders 
where rocks fall down from the top while you collect statues 
before reaching the exit.

![Playing](https://github.com/mecparts/Ladder/images/playing.png "Playing")

Back in 1999 Stephen Ostermiller made a version of [Ladder in 
Java](http://ostermiller.org/ladder/). Later, Mats Engstrom of 
SmallRoomLabs started another version in of [Ladder in 
golang](https://github.com/SmallRoomLabs/ladder). Between my own 
memories of playing the original game on a Kaypro, and the Stephen 
Ostermiller's and Mats Engstrom's code, I was able to come up 
with this version.

This version will use the original LADCONF.COM configuration program 
and LADDER.DAT configuration file. Since this version is a Turbo 
Pascal program, the terminal configuration portion of LADCONF 
isn't used, though it still does set up the movement keys, sound 
and back chatter options.

## Compiling the game

You'd need Turbo Pascal, of course. You'll also need to edit 
LADCONST.PAS to set the cursor on and off sequences for your 
terminal. LADDER.PAS is the main part of the program. I've 
successfully compiled this on a 58K CP/M system, so available RAM 
isn't a particularly critical limitation.

## Limitations

At the moment, once you've successfully completed the 27th level 
(Gang Land), the program ends. If anyone knows what the original 
program actually did (I never managed to get anywhere near to
completing the original game), let me know and I'll see what I 
can do.



