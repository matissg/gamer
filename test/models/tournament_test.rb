require 'test_helper'

class TournamentTest < ActiveSupport::TestCase

  def setup
    @first_tournament = tournaments(:first)
    @tournament = Tournament.new(name: "First Tournament")
  end

  test "should be valid" do
    assert @tournament.valid?
  end

  test "name should be present" do
    @tournament.name = ""
    assert_not @tournament.valid?
  end

  test "name should not be too long" do
    @tournament.name = "a" * 251
    assert_not @tournament.valid?
  end

  test "should be able to split teams into divisions" do
    assert_difference('TournamentTeam.count', +16) do
      @tournament.split_teams_into_divisions
    end
  end

end
