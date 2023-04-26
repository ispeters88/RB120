using this method method as a guard clause for potential winning sequences that are in column or diagonal form (rows are handled separately)

`def different_and_adjacent_rows?(sequence)
  row_numbers = sequence.map(&:get_row)
  row_numbers.uniq.size == 1 && delta_values(row_numbers) == 1
end`

This doesn't work due to the apparent function of the `(&:method)` shorthand. This shorthand uses the class of each element passed in via the associated iterating method (`#map` in this case)

I am trying to reference an instance method of the `Board` class, but `sequence.map` is passing in `Integer` objects. 

Question: Is there a sneaky way to override the class used by the `(&:method)` shorthand?


* Looks like the &: notation invokes construction of a Proc object. There are ways to override how this works, and other ways to generate procs that might allow one to override the class, but need to research this more.

https://docs.ruby-lang.org/en/2.7.0/Proc.html#method-c-new


* Ran into a weird bug that is not understood well by the terminal syntax formatting - I had gone from using my `prompt` method with a single argument, and not using `()`, then added a second argument, so I wrote

`prompt ("Some text here", 2)`


Need to remember - Ruby allows me to leave off the parentheses, but if we do use them, they MUST be directly next to the method name. Can't have a space between a method name and the calling arguments in parenetheses!