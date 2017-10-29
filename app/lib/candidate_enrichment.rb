class CandidateEnrichment
  def self.process(candidate)
    result = Clearbit::Enrichment.find(email: candidate.email, stream: true)

    if result
      candidate.update_columns(first_name: result.person['name']['givenName'])
      candidate.update_columns(last_name: result.person['name']['familyName'])
      candidate.update_columns(avatar: result.person['avatar'])
      candidate.update_columns(bio: result.person['bio'])
      candidate.update_columns(company: result.person['employment']['name'])
      candidate.update_columns(role: result.person['employment']['role'])
      candidate.update_columns(linkedin: result.person.avatar)
      candidate.update_columns(facebook: result.person['facebook']['handle'])
      candidate.update_columns(twitter: result.person['twitter']['handle'])
    else
        Rails.logger.info "No clearbit data found for #{candidate.first_name}"\
                        " #{candidate.last_name} using #{candidate.email}"
    end
  end
end