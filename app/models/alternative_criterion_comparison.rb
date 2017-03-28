class AlternativeCriterionComparison < ApplicationRecord
  belongs_to :alternative
  belongs_to :criterion, class_name: 'Criterion'
  belongs_to :other_criterion, class_name: 'Criterion' 
end
