class CreateTournamentTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :tournament_teams do |t|
      t.belongs_to :tournament, foreign_key: true
      t.belongs_to :team, foreign_key: true
      t.string :division, limit: 2, index: true
    end
    add_index :tournament_teams, [:tournament_id, :team_id], unique: true
  end
end
