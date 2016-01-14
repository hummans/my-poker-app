# My Poker App

The kernel of my first self-made application!

Simulate a Texas Holdem poker hand in "single player mode."

###Instructions

####- Step 1:

> Clone this repository to your local machine.

####- Step 2:

> While in the app's directory, open a shell and start an IRB session.

####- Step 3:

> Execute from the command line: 
>>**load './deck.rb'**

####- Step 4:

> Generate a shuffled deck object instance: 
>>**new_deck = Deck.new**

####- Step 5:

> Draw cards from the deck. (We will use '7' as our default argument; this simulates a player who has 2 pocket cards and has remained in the hand until the river): 

>>**river\_draw = new\_deck.draw(7)**

####- Step 6:

> Generate all possible five-card hands from the 7 drawn cards: 
>>**all  =  new\_deck.all\_hands\_from_cards(river\_draw)**

####- Step 7:

> Return the best hand(s) from all hands: 
>>**best  =  new\_deck.best\_hand(all)**

####- Step 8:

> Return the strength of the best hand(s): 
>>**new_deck.winning\_hand(best)**
