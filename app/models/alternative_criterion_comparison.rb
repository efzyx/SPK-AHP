class AlternativeCriterionComparison < ApplicationRecord
  belongs_to :criterion
  belongs_to :alternative, class_name: 'Alternative'
  belongs_to :other_alternative, class_name: 'Alternative' 
end
