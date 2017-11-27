class AddTeamToCandidates < ActiveRecord::Migration[5.1]
  def change
    add_column :candidates, :team, :string
  end
end
