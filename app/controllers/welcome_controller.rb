class WelcomeController < ApplicationController
  require 'matrix'
  def index
    begin
        @dataAve = getAverageAlt
        @aveCri = getAverageCri
        @alternatives = Alternative.all
        @criterions = Criterion.all
        @matriksAlt = nil
        @matriksCri = nil
        @dataAve.each do |d|
            @matriksAlt = Matrix.rows(@matriksAlt.to_a << d)
        end
        @aveCri.each do |c|
          @matriksCri = Matrix.rows(@matriksCri.to_a << [c])
        end

        @matriksResult = @matriksAlt * @matriksCri
        @result = @matriksResult.to_a
        @altNow = @alternatives.first
        @reschart= []
        @result.each_with_index do |r, ind|
          @reschart[ind] = [@altNow.name, r]
          @altNow = @altNow.next
        end
      rescue
        @dataAve = nil
        flash[:warning] = 'Error! Periksa kelengkapan data'
      end
  end

  def getAverageAlt
    return AlternativeCriterionComparisonsController.get_average
  end

  def getAverageCri
    return CriterionComparisonsController.get_criterion_average
  end
end
