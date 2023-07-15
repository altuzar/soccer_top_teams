require_relative 'soccer_top_teams_calculator'

def process(input)
  if input
    process_file(input)
  else
    process_stdin
  end
end

def process_file(filename)
  File.foreach(filename) do |line|
    processed_line = @calculator.process_match(line.chomp)
  end
  @calculator.process_match(nil)
end

def process_stdin
  $stdin.each_line do |line|
    processed_line = @calculator.process_match(line.chomp)
  end
end

@calculator = SoccerTopTeamsCalculator.new

input = ARGV[0]

process(input)
