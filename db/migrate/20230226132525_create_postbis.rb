class CreatePostbis < ActiveRecord::Migration[7.0]
  def change
    create_table :postbis do |t|
      t.text :body
      t.string :access
      t.string :passcode

      t.timestamps
    end
  end
end
