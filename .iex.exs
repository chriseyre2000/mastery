alias Mastery.Examples.Maths
alias Mastery.Boundary.QuizSession

start = fn ->
  now = DateTime.utc_now()

  five_seconds_from_now = DateTime.add(now, 5)

  one_min_from_now = DateTime.add(now, 60)

  Mastery.schedule_quiz(Maths.quiz_fields(), [Maths.template_fields()], five_seconds_from_now, one_min_from_now)

end