module CandidatesHelper
  # Best available display name for a candidate.
  def candidate_display_name(candidate)
    name = [candidate.first_name, candidate.last_name].reject(&:blank?).join(" ")
    name.presence || candidate.email.to_s.split("@").first.presence || "Unknown"
  end

  # Round avatar: real photo when enrichment found one, otherwise initials.
  # Pass large: true for the profile header.
  def candidate_avatar(candidate, large: false)
    klass = large ? "avatar avatar-lg" : "avatar"
    if candidate.present? && candidate.avatar.present?
      image_tag(candidate.avatar, class: klass, alt: candidate_display_name(candidate))
    else
      seed = candidate_display_name(candidate)
      content_tag(:span, user_initials(seed), class: "avatar-fallback #{'avatar-lg' if large}")
    end
  end

  def candidate_role(candidate)
    candidate.title.presence || candidate.role.presence || "—"
  end

  # Render the candidate's social handles as small icon buttons.
  def candidate_socials(candidate)
    links = []
    links << social_icon(:linkedin, "https://www.linkedin.com/#{candidate.linkedin}") if candidate.linkedin.present?
    links << social_icon(:twitter,  "https://www.twitter.com/#{candidate.twitter}")   if candidate.twitter.present?
    links << social_icon(:facebook, "https://www.facebook.com/#{candidate.facebook}") if candidate.facebook.present?
    return content_tag(:span, "—", class: "muted") if links.empty?
    content_tag(:span, safe_join(links), class: "social")
  end

  private

  SOCIAL_PATHS = {
    linkedin: '<path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-4 0v7h-4v-7a6 6 0 0 1 6-6z"/><rect x="2" y="9" width="4" height="12"/><circle cx="4" cy="4" r="2"/>'.html_safe,
    twitter:  '<path d="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/>'.html_safe,
    facebook: '<path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>'.html_safe
  }.freeze

  def social_icon(network, url)
    svg = content_tag(:svg, SOCIAL_PATHS[network],
                      viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", "stroke-width": "2")
    link_to(svg, url, target: "_blank", rel: "noopener", title: network.to_s.capitalize)
  end
end
