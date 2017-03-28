class Criterion < ApplicationRecord
  def next
    self.class.where("id > ?", id).first
  end
end
