class Candidate < ApplicationRecord
	# before_save do
	# 	self.enrichment = '' if enrichment.blank?
	# end
	has_attached_file :cv
	validates_attachment_content_type :cv, content_type: ["application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain"]
	belongs_to :user

	after_create do
		CandidateEnrichment.process(self) unless email.blank?
	end

	def self.team_picker(current_user)
		team = current_user.team
		if team == 'Admin'
			@candidates = Candidate.all
		else
			@candidates = Candidate.where("team = ?", team)
	    end
	end

end
