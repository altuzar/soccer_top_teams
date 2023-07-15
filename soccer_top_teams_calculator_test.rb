require 'minitest/autorun'
require_relative 'soccer_top_teams_calculator'

class SoccerTopTeamsCalculatorTest < Minitest::Test
  def setup
    @processor = SoccerTopTeamsCalculator.new
  end

  def test_process_match
    expected_output = [
      "Matchday 1",
      "Capitola Seahorses, 3 pts",
      "Felton Lumberjacks, 3 pts",
      "San Jose Earthquakes, 1 pt",
      "",
      "Matchday 2",
      "Capitola Seahorses, 4 pts",
      "Aptos FC, 3 pts",
      "Felton Lumberjacks, 3 pts",
      "",
      "Matchday 3",
      "Aptos FC, 6 pts",
      "Felton Lumberjacks, 6 pts",
      "Monterey United, 6 pts",
      "",
      "Matchday 4",
      "Aptos FC, 9 pts",
      "Felton Lumberjacks, 7 pts",
      "Monterey United, 6 pts",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 3, Santa Cruz Slugs 3")
      @processor.process_match("Capitola Seahorses 1, Aptos FC 0")
      @processor.process_match("Felton Lumberjacks 2, Monterey United 0")
      @processor.process_match("Felton Lumberjacks 1, Aptos FC 2")
      @processor.process_match("Santa Cruz Slugs 0, Capitola Seahorses 0")
      @processor.process_match("Monterey United 4, San Jose Earthquakes 2")
      @processor.process_match("Santa Cruz Slugs 2, Aptos FC 3")
      @processor.process_match("San Jose Earthquakes 1, Felton Lumberjacks 4")
      @processor.process_match("Monterey United 1, Capitola Seahorses 0")
      @processor.process_match("Aptos FC 2, Monterey United 0")
      @processor.process_match("Capitola Seahorses 5, San Jose Earthquakes 5")
      @processor.process_match("Santa Cruz Slugs 1, Felton Lumberjacks 1")
      @processor.process_match(nil)
    end
  end

  def test_process_match_sorts_by_names_of_teams_if_equal_points
    expected_output = [
      "Matchday 1",
      "Aptos FC, 1 pt",
      "Capitola Seahorses, 1 pt",
      "Felton Lumberjacks, 1 pt",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 0, Santa Cruz Slugs 0")
      @processor.process_match("Capitola Seahorses 0, Aptos FC 0")
      @processor.process_match("Felton Lumberjacks 0, Monterey United 0")
      @processor.process_match(nil)
    end
  end

  def test_process_match_pluralize_points
    expected_output = [
      "Matchday 1",
      "San Jose Earthquakes, 3 pts",
      "Aptos FC, 1 pt",
      "Capitola Seahorses, 1 pt",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 1, Santa Cruz Slugs 0")
      @processor.process_match("Capitola Seahorses 0, Aptos FC 0")
      @processor.process_match("Felton Lumberjacks 0, Monterey United 0")
      @processor.process_match(nil)
    end
  end

  def test_process_match_returns_only_two_teams
    expected_output = [
      "Matchday 1",
      "San Jose Earthquakes, 3 pts",
      "Santa Cruz Slugs, 0 pt",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 1, Santa Cruz Slugs 0")
      @processor.process_match(nil)
    end
  end

  def test_process_match_accepts_two_digits_goals
    expected_output = [
      "Matchday 1",
      "Capitola Seahorses, 3 pts",
      "Felton Lumberjacks, 3 pts",
      "San Jose Earthquakes, 1 pt",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 0, Santa Cruz Slugs 0")
      @processor.process_match("Capitola Seahorses 11, Aptos FC 0")
      @processor.process_match("Felton Lumberjacks 22, Monterey United 0")
      @processor.process_match(nil)
    end
  end

  def test_process_match_skips_unrecognized_input
    expected_output = [
      "Matchday 1",
      "Capitola Seahorses, 3 pts",
      "San Jose Earthquakes, 1 pt",
      "Santa Cruz Slugs, 1 pt",
      "",
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match("San Jose Earthquakes 0, Santa Cruz Slugs 0")
      @processor.process_match("Capitola Seahorses 11, Aptos FC 0")
      @processor.process_match("")
      @processor.process_match(nil)
    end
  end

  def test_process_match_skips_empty_input
    expected_output = [
      "",
    ]

    assert_output(expected_output.join("\n")) do
      @processor.process_match(nil)
    end
  end
end
