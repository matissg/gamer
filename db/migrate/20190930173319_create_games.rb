class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.belongs_to :tournament, foreign_key: true, index: true
      t.string :stage, limit: 10
      t.integer :home_team_id, index: true
      t.integer :visitor_team_id, index: true
      t.integer :home_team_score
      t.integer :visitor_team_score
      t.integer :winner_id, index: true
    end
  end
end
