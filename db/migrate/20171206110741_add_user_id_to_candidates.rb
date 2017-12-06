class AddUserIdToCandidates < ActiveRecord::Migration[5.1]
  def change
    add_column :candidates, :user_id, :integer
  end
end
