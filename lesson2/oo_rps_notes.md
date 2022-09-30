    # >> note for additional review/follow-up
    # > I previously didn't have "self" in the next expression; this was preventing the reset back to the shapeshifter 
    # that I wanted. 
    # > That is fixed, but now we have a new problem:
    #     the "update history" invocation is done in the Game class, method Game#play_round
    #     this is an issue because with the current design of this method, we are always giving credit to the Cylon for
    #     its moves, not the AIs it changes into. This makes it impossible as the user to see what this computer
    #     type is doing. Before it was listing multiple different computers in the history which was cool
    # > So what can we do - 
    #   do we need to move the update_history call somewhere else? Perhaps call it separately in the human and computer
    #   classes? This is not DRY of course
    # > We do need the do the reverting back to the Cylon type right within this method, otherwise we will lose track that
    # it ever was this type. 
    # MORE REVIEW NEEDED!



pieces of code that are functional but not 

def copycat
  [[opponent_move.value] * 3,
   (0..2).map { Move::LEGAL_PLAYS.sample }].flatten.sample
end


cool piece of code here:

instance_variables.each do |attr|
      scores[eval(attr.to_s)] = 0
    end

## Questions for PR Request ##
# 1) Is there an easy way to access the object that an attribute belongs to?
# 2)    