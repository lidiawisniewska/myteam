class CandidateEnrichmentJob < ApplicationJob
  queue_as :default

  # Enriches a candidate's profile from People Data Labs, out of the
  # request cycle. Takes an id (not the record) so a candidate deleted
  # before the job runs is simply skipped instead of raising.
  def perform(candidate_id)
    candidate = Candidate.find_by(id: candidate_id)
    return if candidate.nil?

    CandidateEnrichment.process(candidate)
  end
end
