README:
Tap It:
By Jason Nawrocki and Erik Wurman

Our app is a version of the classic Bop It game for the iPhone. 
We tested this app on an iPhone 6 and the iPhone Simulator

System Requirement: iOS10

Features: 
	Users can select different game modes. They can play single player, multiplayer, or frenzy mode. 
	There is also a tutorial feature available, which allows users to get an idea 
	of the different actions which the game requires. In multiplayer mode, we added a 
	feature allowing users to input custom player names for themselves

	Basically, the structure of gameplay is that users have a specific amount of time in which 
	they have to do a prompted action with the phone. If that action (and only that action) is 	
	completed, the game will prompt a new action. New rounds occur every so often to give 		
	the users a break. Multiplayer involves passing the phone between users at each round. 		
	Frenzy mode has no round breaks.

Gameplay:
	Gestures work as one would expect with the exception of Rotate. Rotate requires the user to 
	rotate 90 degrees to the point that the phone knows you want to flip the screen to landscape. 
	This also causes the swipe gestures to rotate, so the user must continue the game in landscape 
	after rotating. One can only rotate again on the next rotate, or in between rounds when no
	instruction is on screen.

	For Tapping, we decided to make it more challenging by adding color to the instruction. 
	It begins as blue text means tap blue, but upon getting to round 3, the text color is random 
	between red or blue regardless of which button its telling the user to click.
	
	It is highly recommended to play this on a device with iOS 10, and not the simulator, 
	as the simulator makes it more difficult to react to shaking and rotating instructions.

Bugs: There are a few bugs which we weren’t able to address completely. 
	-First, the app is strictly comparable with iOS10. The timer functionality works only in 		
		iOS10, and we didn’t have enough time to make the appropriate fallback.
	-Also, the view for choosing custom player names doesn’t look good in landscape. The 		
		text fields should really be inside a scroll view, but we just didn’t have the time to
		implement this piece
	-When the game asks you to rotate the phone, you can’t rotate it upside down or else it 		
		doesn’t recognize the rotation.
	-The shaking motion in the game is hard to do with a phone. This isn’t a bug, it just could 	
		be confusing for users
	

