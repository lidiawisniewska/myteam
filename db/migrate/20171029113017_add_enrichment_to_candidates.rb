class AddEnrichmentToCandidates < ActiveRecord::Migration[5.1]
  def up
    add_column :candidates, :avatar, :string, default: ''
    add_column :candidates, :bio, :string, default: ''
    add_column :candidates, :company, :string, default: ''
    add_column :candidates, :title, :string
    add_column :candidates, :role, :string
    add_column :candidates, :linkedin, :string, default: ''
    add_column :candidates, :facebook, :string, default: ''
    add_column :candidates, :twitter, :string, default: ''
  end

  def down
    remove_column :candidates, :avatar, :string, default: ''
    remove_column :candidates, :bio, :string, default: ''
    remove_column :candidates, :company, :string, default: ''
    remove_column :candidates, :title, :string
    remove_column :candidates, :role, :string
    remove_column :candidates, :linkedin, :string, default: ''
    remove_column :candidates, :facebook, :string, default: ''
    remove_column :candidates, :twitter, :string, default: ''
  end
end
