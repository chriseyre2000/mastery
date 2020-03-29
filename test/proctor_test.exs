defmodule ProctorTest do
  use ExUnit.Case

  alias Mastery.Examples.Maths
  alias Mastery.Boundary.QuizSession

  @moduletag capture_log: true

  test "quizzes can be scheduled" do
    quiz = Maths.quiz_fields() |> Map.put(:title, :timed_addition)
    now = DateTime.utc_now()
    email = "student@example.com"

    assert :ok = Mastery.schedule_quiz(quiz,
      [Maths.template_fields],
      DateTime.add(now, 50, :millisecond),
      DateTime.add(now, 100, :millisecond),
      self()
      )
    
      refute Mastery.take_quiz(quiz.title, email)
      assert_receive {:started, :timed_addition}
      assert Mastery.take_quiz(quiz.title, email)
      assert_receive {:stopped, :timed_addition}

      assert [] == QuizSession.active_sessions_for(quiz.title)
  end
end  