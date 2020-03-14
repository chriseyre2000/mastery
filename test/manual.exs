alias Mastery.Core.{Template, Quiz, Response}
generator = %{left: [1, 2], right: [1,2]}
checker = fn(sub, answer) -> sub[:left] + sub[:right] == String.to_integer(answer) end

quiz = Quiz.new(title: "Addition", mastery: 2) 
|> Quiz.add_template(name: :single_digit_addition,
     category: :addition,
     instructions: "Add the numbers",
     raw: "<%= @left %> + <%= @right %>",
     generators: generator,
     checker: checker )
|> Quiz.select_question