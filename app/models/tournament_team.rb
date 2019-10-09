class TournamentTeam < ApplicationRecord

  #-- Associations -------------------------------------------------------------
  belongs_to :tournament, class_name: "Tournament", optional: true
  belongs_to :team, class_name: "Team", optional: true
  #-- Validations --------------------------------------------------------------
  validates_inclusion_of :division, in: ['A','B'], allow_blank: true
  #-- Scopes -------------------------------------------------------------------
  scope :by_division, ->(name) { where(division: name) }

end
