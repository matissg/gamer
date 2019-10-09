require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @tournament = tournaments(:first)
  end

  test "should get index with results" do
    @tournament.play_all_games
    get tournament_results_path(@tournament.id)
    assert_response :success
  end

end
