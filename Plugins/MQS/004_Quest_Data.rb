module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  # Quest1 = {
  #   :ID => "1",
  #   :Name => "Introductions",
  #   :QuestGiver => "Little Boy",
  #   :Stage1 => "Look for clues.",
  #   :Location1 => "Lappet Town",
  #   :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
  #   :RewardString => "Something shiny!"
  # }

  # Here's an extension of the above that includes multiple stages
  MysteryEgg = {
    :ID => "1",
    :Name => "The journey begins",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Get package with Mr. Pokémon.",
    :Stage2 => "Return Mystery Egg.",
    :Location1 => "Past Cherrygrove City",
    :Location2 => "New Bark Town",
    :QuestDescription => "Professor Elm asked you to get something with Mr. Pokémon for him. It's probably an Egg.",
  }

  # @todo: Still need to add code to complete it in the game
  JohtoPokedex = {
    :ID => "2",
    :Name => "Gotta catch ‘em all!",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Complete the Johto Pokédex.",
    :Location1 => "nil",
    :QuestDescription => "Go meet many kinds of Pokémon and complete that Pokédex!",
  }

  JohtoGymChallenge = {
    :ID => "3",
    :Name => "Pokémon Gym challenge",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Challenge Violet City's Gym.",
    :Stage2 => "Challenge Azalea Town's Gym.",
    :Stage3 => "Challenge Goldenrod City's Gym.",
    :Stage4 => "Challenge Ecruteak City's Gym.",
    :Stage5 => "Challenge Cianwood City's Gym.",
    :Stage6 => "Challenge Olivine City's Gym.",
    :Stage7 => "Challenge Mohogany Town's Gym.",
    :Stage8 => "Challenge Blackthorn City's Gym.",
    :Location1 => "Violet City",
    :Location2 => "Azalea Town",
    :Location3 => "Goldenrod City",
    :Location4 => "Ecruteak City",
    :Location5 => "Cianwood City",
    :Location6 => "Olivine City",
    :Location7 => "Mohogany Town",
    :Location8 => "Blackthorn City",
    :QuestDescription => "Collect all 8 Gym Badges in Johto. If you manage to defeat all the Gym Leaders, you'll eventually challenge the Pokémon League Champion!",
  }

  StudentInDarkCave = {
    :ID => "4",
    :Name => "Playing in a Dark Cave...",
    :QuestGiver => "Teacher Earl",
    :Stage1 => "Search for the missing student.",
    :Stage2 => "Go back to Violet School.",
    :Location1 => "Dark Cave",
    :Location2 => "Violet City",
    :QuestDescription => "A student lef for recess and didn't return yet! He was saying something about playing in a Dark Cave...",
  }

  SproutTower = {
    :ID => "4",
    :Name => "Sprout Tower challenge",
    :QuestGiver => "nil",
    :Stage1 => "Train in the Sprout Tower.",
    :Location1 => "Violet City",
    :QuestDescription => "Facing Falkner must be very difficult for you, better train in the Sprout Tower before.",
  }

  TogepiEgg = {
    :ID => "5",
    :Name => "Caring for the Mystery Egg",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Get Egg with the assistant.",
    :Stage2 => "Hatch the egg.",
    :Location1 => "Violet City Poké Center",
    :Location2 => "???",
    :QuestDescription => "Professor Elm wants you to take care of an Egg. It seems that a Pokémon will hatch from it only when you keep it in your party of Pokémon.",
  }

  BellsproutTrade = {
    :ID => "6",
    :Name => "Rocky Trade",
    :QuestGiver => "Youngster Joey",
    :Stage1 => "Trade Pokémon.",
    :Location1 => "Violet City",
    :QuestDescription => "This youngster in Violet City wants to trade a Bellsprout for his Onix. Do you think it's a good trade?",
  }

  
  RuinsOfAlphPuzzleOne = {
    :ID => "7",
    :Name => "Mysterious Ruins",
    :QuestGiver => "nil",
    :Stage1 => "Check the Ruins Misteries.",
    :Location1 => "Ruins of Alph",
    :QuestDescription => "There are odd patterns drawn on the walls of the ruins. They must be the keys for unraveling it's misteries.",
  }

  SchoolKidPhanpy = {
    :ID => "8",
    :Name => "Phanpy's fan",
    :QuestGiver => "School Kid Henry",
    :Stage1 => "Check the Ruins Misteries.",
    :Location1 => "Route 46",
    :RewardString => "Berries!",
    :QuestDescription => "This kid near Route 46 really wants to see a Phanpy. If you can help with that, he's happy to thank you with some berries as a thank-you gift.",
  }

  
  # Here's an extension of the above that includes multiple stages
  # Quest2 = {
  #   :ID => "2",
  #   :Name => "Introductions",
  #   :QuestGiver => "Little Boy",
  #   :Stage1 => "Look for clues.",
  #   :Stage2 => "Follow the trail.",
  #   :Stage3 => "Catch the troublemakers!",
  #   :Location1 => "Lappet Town",
  #   :Location2 => "Viridian Forest",
  #   :Location3 => "Route 3",
	# :StageLabel1 => "1",
	# :StageLabel2 => "2",
  #   :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
  #   :RewardString => "Something shiny!"
  # }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "Grandma",
    :Stage1 => "A",
    :Stage2 => "B",
    :Stage3 => "C",
    :Stage4 => "D",
    :Stage5 => "E",
    :Stage6 => "F",
    :Stage7 => "G",
    :Stage8 => "H",
    :Stage9 => "I",
    :Stage10 => "J",
    :Stage11 => "K",
    :Stage12 => "L",
    :Location1 => "nil",
    :Location2 => "nil",
    :Location3 => "Dewford Town",
    :QuestDescription => "Isn't the alphabet longer than this?",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end
