class Game < ApplicationRecord
  #-- Constants ----------------------------------------------------------------
  MIN_SCORE = 0
  MAX_SCORE = 10
  #-- Associations -------------------------------------------------------------
  belongs_to :tournament, class_name: "Tournament"
  belongs_to :home_team, class_name: "Team", foreign_key: :home_team_id
  belongs_to :visitor_team, class_name: "Team", foreign_key: :visitor_team_id
  belongs_to :winner, class_name: "Team", foreign_key: :winner_id
  #-- Validations --------------------------------------------------------------
  validates :tournament_id, :home_team_id, :visitor_team_id, :winner_id, presence: true
  validates :stage, inclusion: { in: ['A', 'B', 'quarter', 'semi', 'final'] }
  validates :home_team_score, :visitor_team_score, inclusion: 0..10
  #-- Scopes -------------------------------------------------------------------
  scope :by_stage, ->(name) { where(stage: name) }


  #-- Play Game ----------------------------------------------------------------

  def self.play_for(tournament, teams, stage)
    scores = scores_for(teams)
    results = set_winner(scores)
    save_results(tournament, results, stage)
  end

  def self.scores_for(teams)
    teams.map{ |game|
      game.insert( 2, rand(MIN_SCORE..MAX_SCORE), rand(MIN_SCORE..MAX_SCORE) )
    }
  end

  def self.set_winner(scores)
    scores.map{ |item|
      if item[2] == item[3]
        winner = [2,3].sample
        item[winner] = item[winner] + 1
        select_winner(item)
      else
        select_winner(item)
      end
    }
  end

  def self.select_winner(item)
    item.insert(4, (item[2] > item[3] ? item[0] : item[1]) )
  end

  # Fastest way which is not quite stable in SQLite
  def self.save_results(tournament, results, stage)
    columns = [
      :tournament_id,
      :stage,
      :home_team_id,
      :visitor_team_id,
      :home_team_score,
      :visitor_team_score,
      :winner_id
    ]
    values = results.map { |item| item.insert(0, tournament, stage) }
    Game.import columns, values, validate: true
  end

  #-- Get Results --------------------------------------------------------------

  def self.results_for_tournament(id)
    where(tournament: id).includes(:home_team, :visitor_team).references(:teams)
    .map { |game|
      [ game.home_team.name, game.visitor_team.name,
        game.home_team_score, game.visitor_team_score,
        game.stage
      ]
    }.group_by{ |item| item[4] }
  end

end
