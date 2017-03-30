class WelcomeController < ApplicationController
  require 'matrix'
  def index
    # begin
        @dataAve = getAverageAlt
        @aveCri = getAverageCri
        @alternatives = Alternative.all
        @criterions = Criterion.all
        @matriksAlt = Matrix.columns(@dataAve)
        @matriksCri = Matrix.column_vector(@aveCri)

        @matriksResult = @matriksAlt * @matriksCri
        @result = @matriksResult.to_a
        @altNow = @alternatives.first
        @reschart= []
        @result.each_with_index do |r, ind|
          @reschart[ind] = [@altNow.name, r]
          @altNow = @altNow.next
        end
      # rescue
      #   @dataAve = nil
      #   flash[:warning] = 'Error! Periksa kelengkapan data'
      # end
  end

  def getAverageAlt
    return AlternativeCriterionComparisonsController.get_average
  end

  def getAverageCri
    return CriterionComparisonsController.get_criterion_average
  end
end
