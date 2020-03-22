defmodule Mastery do
  alias Mastery.Boundary.{QuizSession, QuizManager, Proctor}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz

  @persistence_fn Application.get_env(:mastery, :persistence_fn)

  def start_quiz_manager() do
    GenServer.start_link(QuizManager, %{}, name: QuizManager)
  end
  
  def build_quiz(fields) do
    with :ok <- QuizValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:build_quiz, fields}),
    do: :ok, else: (error -> error)
  end
  
  def add_template(title, fields) do
    with :ok <- TemplateValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:add_template, title, fields}),
         do: :ok, else: (error -> error)
  end
  
  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, session} <- GenServer.start_link(QuizSession, {quiz, email})
         do
          session
         else
           error -> error
         end
  end

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer, persistence_fn \\ @persistence_fn) do
    GenServer.call(session, {:answer_question, answer, persistence_fn})
  end
  
  def schedule_quiz(quiz, templates, start_at, end_at) do
    with :ok <- QuizValidator.errors(quiz),
         true <- Enum.all?(templates, &(:ok == TemplateValidator.errors(&1))),
         :ok <- Proctor.schedule_quiz(quiz, templates, start_at, end_at),
         do: :ok, else: (error -> error)
  end  
end
