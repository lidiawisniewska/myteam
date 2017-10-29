class CandidateEnrichment
    def self.process(candidate)
        result = Clearbit::Enrichment.find(email: candidate.email, stream: true)
        person = result.person.to_s

        if result
    	   candidate.update_columns(enrichment: person)
    	   Rails.logger.info "#{candidate.first_name} #{candidate.last_name} "\
                        'enriched with clearbit'
        else
    	   Rails.logger.info "No clearbit data found for #{candidate.first_name}"\
                        " #{candidate.last_name} using #{candidate.email}"
        end
    end
end