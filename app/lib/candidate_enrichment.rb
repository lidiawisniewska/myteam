require 'net/http'
require 'json'

class CandidateEnrichment
  ENRICH_URL = 'https://api.peopledatalabs.com/v5/person/enrich'

  def self.process(candidate)
    api_key = Rails.application.credentials.people_data_labs_api_key
    if api_key.blank?
      Rails.logger.info "Skipping People Data Labs enrichment for #{candidate.email}:"\
                       " no API key configured"
      return
    end

    uri = URI(ENRICH_URL)
    uri.query = URI.encode_www_form(email: candidate.email)

    request = Net::HTTP::Get.new(uri)
    request['X-API-Key'] = api_key

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }

    case response
    when Net::HTTPSuccess
      data = JSON.parse(response.body)['data']
      candidate.update_columns({
        first_name: data['first_name'],
        last_name: data['last_name'],
        company: data['job_company_name'],
        role: data['job_title'],
        linkedin: data['linkedin_username'],
        facebook: data['facebook_username'],
        twitter: data['twitter_username'],
      }.compact)
    when Net::HTTPNotFound
      Rails.logger.info "No People Data Labs data found for #{candidate.first_name}"\
                       " #{candidate.last_name} using #{candidate.email}"
    else
      Rails.logger.error "People Data Labs enrichment failed for #{candidate.email}:"\
                        " #{response.code} #{response.message}"
    end
  rescue StandardError => e
    Rails.logger.error "People Data Labs enrichment error for #{candidate.email}: #{e.message}"
  end
end
