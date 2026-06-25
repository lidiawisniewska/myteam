# =====================================================================
#  Run with:  bin/rails db:seed
#
#  Creates a few users (one Admin who can see everything) and a set of
#  candidates across teams. A deliberate mix of fully-enriched profiles
#  (photo, role, company, socials, CV) and sparse ones, so the avatar
#  fallbacks and empty states are visible too.
# =====================================================================

require "open-uri"
require "stringio"

# --- Don't call the live enrichment API while seeding -----------------
# We set the "enriched" fields by hand below; this stops the after_create
# hook from overwriting them (and from spending People Data Labs credits).
module SkipEnrichmentDuringSeed
  def process(*) = nil
end
CandidateEnrichment.singleton_class.prepend(SkipEnrichmentDuringSeed)

PASSWORD = "password123"

# --- Users ------------------------------------------------------------
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = PASSWORD
  u.team     = "Admin"
end

%w[Sales Marketing Finance].each do |team|
  User.find_or_create_by!(email: "#{team.downcase}.lead@myteam.test") do |u|
    u.password = PASSWORD
    u.team     = team
  end
end

# --- Start from a clean candidate list (idempotent reseed) ------------
Candidate.destroy_all

def avatar_url(id) = "https://i.pravatar.cc/300?img=#{id}"

candidates = [
  # ---- Sales ----
  { first_name: "Ava",      last_name: "Morgan",    email: "ava.morgan@northwind.io",      team: "Sales",
    title: "Account Executive",  company: "Northwind",      linkedin: "ava-morgan", twitter: "avamorgan",
    avatar: avatar_url(5),  cv: true,
    bio: "Account executive with 6 years of SaaS sales experience, focused on mid-market expansion. Consistently exceeded quota and previously led a team of three SDRs." },

  { first_name: "Daniel",   last_name: "Osei",      email: "daniel.osei@vantage.com",      team: "Sales",
    title: "Sales Manager",      company: "Vantage Group",  linkedin: "daniel-osei",
    avatar: avatar_url(12), cv: true,
    bio: "Sales manager who builds and coaches high-performing teams. Strong track record in outbound strategy and pipeline forecasting." },

  { first_name: "Noah",     last_name: "Bennett",   email: "noah.bennett@acme.com",        team: "Sales",
    title: "Sales Development Rep", company: "Acme Co",      twitter: "noah_sells",
    avatar: avatar_url(11), cv: true,
    bio: "Energetic SDR breaking into tech sales after two years in hospitality. Top of cohort for booked meetings." },

  # Deliberately sparse — shows initials fallback + empty cells in the table.
  { first_name: nil,        last_name: nil,         email: "tom.silva@brightfox.co",       team: "Sales",
    cv: false,
    bio: "" },

  # ---- Marketing ----
  { first_name: "Leo",      last_name: "Chen",      email: "leo.chen@acme.com",            team: "Marketing",
    title: "Growth Marketer",    company: "Acme Co",        linkedin: "leochen",
    avatar: avatar_url(8),  cv: true,
    bio: "Growth marketer specialising in lifecycle and paid acquisition. Scaled a B2B funnel from 2k to 30k MQLs/month." },

  { first_name: "Sofia",    last_name: "Marsh",     email: "sofia@hellobrand.com",         team: "Marketing",
    title: "Content Lead",       company: "HelloBrand",     twitter: "sofiawrites",
    cv: true,
    bio: "Content lead and former journalist. Builds editorial programmes that actually drive pipeline, not just traffic." },

  { first_name: "Maya",     last_name: "Patel",     email: "maya.patel@orbit.io",          team: "Marketing",
    title: "Brand Designer",     company: "Orbit",          linkedin: "maya-patel", twitter: "maya_makes",
    avatar: avatar_url(9),  cv: true,
    bio: "Brand and product designer. Cares about systems, type and the small details that make a product feel finished." },

  { first_name: "Isabella", last_name: "Rossi",     email: "isabella@florent.com",         team: "Marketing",
    title: "Marketing Coordinator", company: "Florent",     linkedin: "isabella-rossi",
    avatar: avatar_url(25), cv: true,
    bio: "Marketing coordinator keeping campaigns, events and the content calendar running on time." },

  # ---- Finance ----
  { first_name: "Priya",    last_name: "Rao",       email: "priya@ledgerline.com",         team: "Finance",
    title: "Financial Analyst",  company: "LedgerLine",     linkedin: "priya-rao",
    avatar: avatar_url(16), cv: true,
    bio: "Financial analyst with an audit background. Comfortable owning models, board reporting and month-end close." },

  { first_name: "James",    last_name: "Whitfield", email: "james.whitfield@summitcap.com", team: "Finance",
    title: "Controller",         company: "Summit Capital", linkedin: "james-whitfield",
    cv: true,
    bio: "Controller scaling finance functions through hypergrowth. Implemented the systems behind two successful audits." },

  { first_name: "Grace",    last_name: "Kim",       email: "grace.kim@northbank.com",      team: "Finance",
    title: "FP&A Lead",          company: "NorthBank",      linkedin: "grace-kim", twitter: "gracenumbers",
    avatar: avatar_url(20), cv: false,
    bio: "FP&A lead turning messy spreadsheets into decisions leadership can trust." },

  { first_name: "Ethan",    last_name: "Clarke",    email: "ethan.clarke@ledgerline.com",  team: "Finance",
    title: "Accountant",         company: "LedgerLine",
    cv: true,
    bio: "Detail-driven accountant, recently qualified, keen to grow into a finance business-partnering role." }
]

created = 0
candidates.each do |attrs|
  cv = attrs.delete(:cv)

  candidate = admin.candidates.build(attrs)
  candidate.save!

  if cv
    name = [attrs[:first_name], attrs[:last_name]].compact.join("_").presence || "candidate"
    candidate.cv.attach(
      io:           StringIO.new("CV for #{candidate.email}\n(placeholder résumé generated by db/seeds.rb)"),
      filename:     "#{name.downcase}_cv.txt",
      content_type: "text/plain"
    )
  end

  created += 1
end

puts "Seeded #{User.count} users and #{created} candidates " \
     "(#{Candidate.joins(:cv_attachment).count rescue Candidate.all.select { |c| c.cv.attached? }.count} with a CV)."
puts "Log in as: #{admin.email} / #{PASSWORD}"
