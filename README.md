# myteam

myteam is a web-based applicant tracking system built with Ruby on Rails, 
designed to streamline in-house recruitment workflows.

## Features

- **Centralised candidate management** — all applications and CVs stored in 
  one place, accessible to the whole team
- **Automatic profile enrichment** — retrieve LinkedIn, Facebook, and Twitter 
  profiles for any candidate via the People Data Labs API using just their 
  email address
- **Pipeline management** — move candidates seamlessly between recruitment, 
  HR, and management stages

## Tech stack

- Ruby on Rails 8
- Hotwire (Turbo + Stimulus)
- Devise (authentication)
- Active Storage (file uploads)
- People Data Labs API (candidate enrichment)
- Capybara & Selenium (integration testing)

## Background

Built as a final project for [CS50](https://cs50.harvard.edu/).
