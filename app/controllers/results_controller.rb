class ResultsController < ApplicationController

  def index
    render locals: {
      tournament: tournament,
      results: Game.results_for_tournament(tournament.id),
      winner: tournament.winner.pluck(:name).join.to_s
    }
  end

  def create
    return unless tournament.games.size == 0
    if tournament.play_all_games
      redirect_to tournament_results_path(tournament.id), notice: 'Results generated!'
    else
      redirect_to tournament_path(tournament.id), notice: 'Cannot generate results, please, try again!'
    end
  end

  private

  def tournament
    @tournament ||= Tournament.find(params[:tournament_id])
  end

end
