class CreateCriterions < ActiveRecord::Migration[5.0]
  def change
    create_table :criterions do |t|
      t.string :name

      t.timestamps
    end
  end
end
