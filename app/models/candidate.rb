class Candidate < ApplicationRecord
  # ActiveStorage replaces Paperclip for file uploads
  has_one_attached :cv
  # TODO: re-add content_type validation once active_storage_validations gem is added

  belongs_to :user

  after_create do
    CandidateEnrichment.process(self) unless email.blank?
  end

  def self.team_picker(current_user)
    team = current_user.team
    if team == 'Admin'
      Candidate.all
    else
      Candidate.where("team = ?", team)
    end
  end
end
