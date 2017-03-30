class Criterion < ApplicationRecord
  has_many :AlternativeCriterionComparison
  def next
    self.class.where("id > ?", id).first
  end
end
