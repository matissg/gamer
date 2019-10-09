class Tournament < ApplicationRecord

  #-- Associations -------------------------------------------------------------
  has_many :tournament_teams, class_name: "TournamentTeam", dependent: :destroy
  has_many :teams, class_name: "Team", through: :tournament_teams
  has_many :games, class_name: "Game", dependent: :destroy
  #-- Validations --------------------------------------------------------------
  validates :name, length: { in: 1..250 }
  #-- Callbacks ----------------------------------------------------------------
  after_create :split_teams_into_divisions


  def teams_by(divisions)
    self.tournament_teams.includes(:team).references(:teams).map{ |item|
      [ item.team.id, item.team.name, item.division ]
    }.group_by{ |i| i[-1] }
  end

  def split_teams_into_divisions
    columns = [:tournament_id, :team_id, :division]
    values = Team.ids.shuffle.each_with_index.map { |team, index|
      [self.id, team, (index + 1).even? ? 'A' : 'B']
    }
    TournamentTeam.import columns, values
  end

  def play_all_games
    ActiveRecord::Base.transaction do
      self.division('A')
      self.division('B')
      self.quarter_final
      self.semi_final
      self.final
    end
  end

  #-- Division -----------------------------------------------------------------

  def division(name)
    teams = self.teams.merge(TournamentTeam.by_division(name)).ids.combination(2).to_a
    Game.play_for(self.id, teams, name)
  end

  def division_standings
    self.teams.includes(:tournament_teams, :home_games, :visitor_games, :won_games)
              .references(:tournament_teams, :games).map { |team|
      [
        team.id,
        team.tournament_teams.select{|i| i if i.tournament_id == self.id}.map(&:division).join.to_s,
        (
          team.home_games.select{|i| i if i.tournament_id == self.id}.sum(&:home_team_score) +
          team.visitor_games.select{|i| i if i.tournament_id == self.id}.sum(&:visitor_team_score)
        ),
        team.won_games.select{|i| i if i.tournament_id == self.id}.size
      ]
    }.sort_by{|item| [ item[1], item[3], item[2] ]}.reverse!
     .group_by{ |item| item[1] }
  end

  #-- Play-offs ----------------------------------------------------------------

  def quarter_final
    standings = self.division_standings
    teams = (standings['B'].take(4) + standings['A'].take(4)).map { |item| item[0] }
    pairs = teams.first(4).zip(teams.last(4).reverse)
    Game.play_for(self.id, pairs, 'quarter')
  end

  def semi_final
    teams = self.games.by_stage('quarter').pluck(:winner_id)
    pairs = teams.first(2).zip(teams.last(2).reverse)
    Game.play_for(self.id, pairs, 'semi')
  end

  def final
    teams = [self.games.by_stage('semi').pluck(:winner_id)]
    Game.play_for(self.id, teams, 'final')
  end

  def winner
    Team.find(self.games.by_stage('final').pluck(:winner_id))
  end

end
