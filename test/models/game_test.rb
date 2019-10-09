require 'test_helper'

class GameTest < ActiveSupport::TestCase

  def setup
    @tournament = tournaments(:first)
    @home_team = teams(:team_1)
    @visitor_team = teams(:team_8)
    @game = Game.new(
      tournament_id: @tournament.id,
      home_team_id: @home_team.id,
      visitor_team: @visitor_team,
      home_team_score: 1,
      visitor_team_score: 2,
      winner_id: @visitor_team.id
    )
  end

  test "should be valid" do
    @game.stage = 'A'
    assert @game.valid?
  end

  test "should not be valid with wrong stage" do
    @game.stage = 'wrong_stage'
    assert_not @game.valid?
  end

end
