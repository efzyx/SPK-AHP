class CriterionComparison < ApplicationRecord
  belongs_to :criterion, class_name: 'Criterion'
  belongs_to :other_criterion, class_name: 'Criterion'
  has_many :criterions
end
