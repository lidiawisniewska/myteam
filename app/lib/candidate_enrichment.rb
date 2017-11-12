class CandidateEnrichment
  def self.process(candidate)
    result = Clearbit::Person.find(email: candidate.email, stream: true)

    if result
      candidate.update_columns(first_name: result.name.givenName)
      candidate.update_columns(last_name: result.name.familyName)
      candidate.update_columns(avatar: result.avatar)
      candidate.update_columns(bio: result.bio)
      candidate.update_columns(company: result.employment.name)
      candidate.update_columns(role: result.employment.role)
      candidate.update_columns(linkedin: result.linkedin.handle)
      candidate.update_columns(facebook: result.facebook.handle)
      candidate.update_columns(twitter: result.twitter.handle)
    else
        Rails.logger.info "No clearbit data found for #{candidate.first_name}"\
                        " #{candidate.last_name} using #{candidate.email}"
    end
  end
end