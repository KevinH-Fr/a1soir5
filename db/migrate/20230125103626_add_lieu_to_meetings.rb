class AddLieuToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :lieu, :string
  end
end
