## Some helper functions that are used in the game

# MQS plugin helper function to know if quest is already active
# We can use this to avoid adding the same quest twice in cases where a quest
# can be activated in different places
def isQuestActive?(quest)
    $PokemonGlobal.quests.active_quests.each do |q|
      if(q.id == quest)
        return true
      end  
    end
    return false
end