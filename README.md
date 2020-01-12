# Ladder
The classic CP/M game Ladder reverse engineered in Turbo Pascal.

#### This is a rewrite in Turbo Pascal of the classic CP/M game "Ladder", originally written by Yahoo Software (not Yahoo!).

![Main Menu](https://raw.githubusercontent.com/mecparts/Ladder/master/images/mainmenu.png "Main Menu")

Ladder is an ASCII character based platform arcade game similar to 
Donkey Kong. You travel through levels with platforms and ladders 
where rocks fall down from the top while you collect statues 
before reaching the exit.

![Playing](https://raw.githubusercontent.com/mecparts/Ladder/master/images/playing.png "Playing")

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

Once you've compiled LADDER.COM, copy LADCONF.COM to the same user area.
If you don't have a LADDER.DAT file, when you run LADDER the first time
it'll automatically load LADCONF to set up the movement keys and
options, then transfer you back to LADDER.

## Limitations

At the moment, once you've successfully completed the 7th distinct level 
(Gang Land), the program just cycles through all 7 sevens over and over
again until the bonus time becomes too short to actually finish a level.
If anyone knows what the original program actually did (I never managed
to get anywhere near to completing the original game), let me know and
I'll see what I can do.

The Delay(ms) call in Turbo Pascal only works for a Z80 running
at up to 32MHz (and TINST will only allow you to specify a value of up
to 20MHZ if I recall correctly). So if you're trying to run this on a
system with an effective clock speed of greater than 32MHz, you're going
to have to come up with another mechanism. That's not an insurmountable
roadblock though; on my 144MHz-Z80-equivalent RunCPM box running on a
Teensy 4.0, I patched the Turbo Pascal runtime to make a call to a BDOS
extension I created to call the Arduino's delay() function. Works like
a charm. If your system includes any kind of millisecond counter you can
read, that's a good spot to start looking.

## References

[Original Ladder game](http://www.classiccmp.org/cpmarchives/cpm/Software/WalnutCD/lambda/soundpot/f/ladder13.lbr)<br>
[Ladder in Java](http://ostermiller.org/ladder/)<br>
[Ladder in golang](https://github.com/SmallRoomLabs/ladder)<br>


