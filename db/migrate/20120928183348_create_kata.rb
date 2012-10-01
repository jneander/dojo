class CreateKata < ActiveRecord::Migration
  def change
    create_table :katas do |t|
      t.string :link
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
