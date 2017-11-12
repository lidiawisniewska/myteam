class Candidate < ApplicationRecord
	# before_save do
	# 	self.enrichment = '' if enrichment.blank?
	# end

	after_create do
		CandidateEnrichment.process(self) unless email.blank?
	end
end
