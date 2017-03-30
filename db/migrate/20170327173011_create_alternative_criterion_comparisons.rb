class CreateAlternativeCriterionComparisons < ActiveRecord::Migration[5.0]
  def change
    create_table :alternative_criterion_comparisons do |t|
      t.references :criterion, foreign_key: true
      t.references :alternative, index: true, foreign_key_column_for: :alternative, null: false
      t.float :comparison
      t.references :other_alternative, index: true, foreign_key_column_for: :alternative, null: false

      t.timestamps
    end
  end
end
