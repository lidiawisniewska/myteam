class AddEnrichmentToCandidates < ActiveRecord::Migration[5.1]
  def up
  	add_column :candidates, :enrichment, :string, null: false, default: ''
  end

  def down
  	remove_column :candidates, :enrichment, :string, null: false, default: ''
  end
end
