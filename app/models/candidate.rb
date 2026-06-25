class Candidate < ApplicationRecord
  # ActiveStorage replaces Paperclip for file uploads
  has_one_attached :cv
  validates :cv, content_type: ["application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain"]

  belongs_to :user

  after_create do
    CandidateEnrichment.process(self) unless email.blank?
  end

  def self.team_picker(current_user)
    team = current_user.team
    scope = if team == 'Admin'
      Candidate.all
    else
      Candidate.where(team: team)
    end
    scope.with_attached_cv
  end
end
