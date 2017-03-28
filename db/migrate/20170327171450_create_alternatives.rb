class CreateAlternatives < ActiveRecord::Migration[5.0]
  def change
    create_table :alternatives do |t|
      t.string :name

      t.timestamps
    end
  end
end
