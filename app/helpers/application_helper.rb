module ApplicationHelper
  # Two-letter initials from a name or email, for avatar fallbacks.
  def user_initials(source)
    return "?" if source.blank?
    parts = source.to_s.split("@").first.split(/[.\s_\-]+/).reject(&:blank?)
    letters = if parts.length >= 2
      parts.first(2).map { |p| p[0] }
    else
      source.to_s.gsub(/[^A-Za-z]/, "")[0, 2].chars
    end
    letters.join.upcase.presence || "?"
  end

  # Colored team pill. Each team gets a consistent accent color.
  def team_badge(team)
    return content_tag(:span, "—", class: "muted") if team.blank?
    color = {
      "Admin"     => "blue",
      "Sales"     => "green",
      "Marketing" => "purple",
      "Finance"   => "amber"
    }.fetch(team, "slate")
    content_tag(:span, class: "badge badge--#{color}") do
      content_tag(:span, "", class: "dot") + team
    end
  end
end
