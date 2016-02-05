class CreateDestroys < ActiveRecord::Migration
  def change
    create_table :destroys do |t|
      t.string :membership

      t.timestamps
    end
  end
end
