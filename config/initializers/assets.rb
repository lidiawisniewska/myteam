# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Precompile all JavaScript under app/javascript (Stimulus controllers, etc.)
# so importmap-rails can resolve pins for files other than application.js.
Rails.application.config.assets.precompile += [
  ->(logical_path, filename) { filename.start_with?(Rails.root.join('app/javascript').to_s) }
]
