class CreateCriterionComparisons < ActiveRecord::Migration[5.0]
  def change
    create_table :criterion_comparisons do |t|
      t.references :criterion, index: true, foreign_key_column_for: :criterion, null: false
      t.float :comparison
      t.references :other_criterion, index: true, foreign_key_column_for: :criterion, null: false

      t.timestamps
    end
  end
end
