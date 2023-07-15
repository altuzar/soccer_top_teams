class SoccerTopTeamsCalculator

  def initialize
    @matchday_count = 1
    @current_matchday = {}
    @current_table = Hash.new(0)
  end

  def process_match(match)
    home_score, visit_score = match.split(",").map(&:strip)

    home_team = home_score.split(" ")[0..-2].join(" ")
    home_goals = home_score.split(" ").last.to_i
    visit_team = visit_score.split(" ")[0..-2].join(" ")
    visit_goals = visit_score.split(" ").last.to_i

    if @current_matchday.has_key?(home_team) or @current_matchday.has_key?(visit_team)
      close_matchday
    end

    if home_goals > visit_goals
      @current_matchday[home_team] = 3
      @current_matchday[visit_team] = 0
    elsif home_goals < visit_goals
      @current_matchday[visit_team] = 3
      @current_matchday[home_team] = 0
    else
      @current_matchday[home_team] = 1
      @current_matchday[visit_team] = 1
    end
  rescue
    # if the input is nil or not recognizable, closes the matchday
    close_matchday
  end

  private

  def close_matchday
    return if @current_matchday.empty?

    @current_matchday.each do |team, points|
      @current_table[team] += points
    end

    top_teams = @current_table.sort_by {|k, v| [-v, k] }[0..2]

    puts "Matchday #{@matchday_count}"
    top_teams.each do |team, points|
      puts "#{team}, #{points} pt#{points > 1 ? "s" : ""}"
    end
    puts ""

    @current_matchday.clear
    @matchday_count += 1
  end
end
