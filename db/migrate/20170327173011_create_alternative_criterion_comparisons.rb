class CreateAlternativeCriterionComparisons < ActiveRecord::Migration[5.0]
  def change
    create_table :alternative_criterion_comparisons do |t|
      t.references :alternative, foreign_key: true
      t.references :criterion, index: true, foreign_key_column_for: :criterion, null: false
      t.float :comparison
      t.references :other_criterion, index: true, foreign_key_column_for: :criterion, null: false

      t.timestamps
    end
  end
end
