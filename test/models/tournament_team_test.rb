require 'test_helper'

class TournamentTeamTest < ActiveSupport::TestCase

  def setup
    @tournament = tournaments(:first)
    @team = teams(:team_1)
    @tournament_team = TournamentTeam.new(
      tournament_id: @tournament.id,
      team_id: @team
    )
  end

  test "should be valid" do
    @tournament_team.division = 'A'
    assert @tournament_team.valid?
  end

  test "should have valid division" do
    @tournament_team.division = 'C'
    assert_not @tournament_team.valid?
  end

end
