class Team < ApplicationRecord

  #-- Associations -------------------------------------------------------------
  has_many :tournament_teams, class_name: "TournamentTeam"
  has_many :tournaments, class_name: "Tournament", through: :tournament_teams
  #Games
  has_many :home_games, class_name: "Game", foreign_key: :home_team_id
  has_many :visitor_games, class_name: "Game", foreign_key: :visitor_team_id
  has_many :won_games, class_name: "Game", foreign_key: :winner_id
  #-- Validations --------------------------------------------------------------
  validates :name, length: { in: 1..250 }

end
