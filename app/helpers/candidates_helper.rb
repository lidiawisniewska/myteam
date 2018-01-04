module CandidatesHelper
	def candidate_avatar(candidate)
		return '' if candidate.blank? || candidate.avatar.blank?
		avatar = candidate.avatar
		"<img class =\"avatar\" src = \"#{avatar}\">".html_safe
	end

	def candidate_role(candidate)
		if candidate.title.present?
			return candidate.title
		elsif candidate.role.present?
			return candidate.role
		else
			return ''
		end
	end

	def candidate_linkedin_url(candidate)
		return '' unless candidate.linkedin.present?
		url = 'https://www.linkedin.com/'
		handle = candidate.linkedin
		social_url(handle, url)
	end

	def candidate_facebook_url(candidate)
		return '' unless candidate.facebook.present?
		url = 'https://www.facebook.com/'
		handle = candidate.facebook
		social_url(handle, url)
	end

	def candidate_twitter_url(candidate)
		return '' unless candidate.twitter.present?
		url = 'https://www.twitter.com/'
		handle = candidate.twitter
		social_url(handle, url)
	end

	def social_url(handle, url)
		return '' if handle.blank?
		"<a href=\"#{url + handle}\" target=\"_blank\">#{handle}</a>".html_safe
	end
end
