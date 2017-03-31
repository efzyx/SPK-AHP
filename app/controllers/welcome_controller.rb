class WelcomeController < ApplicationController
  require 'matrix'
  def index
    begin
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
        @mCri = getMatrixCriFromCCC
        @matrixTAve = @mCri * @matriksCri
        @arrayTAve = @matrixTAve.to_a

        @sumT = 0
        @arraySumT=[]
        @arrayTAve.each_with_index do |t, ind|
          @sumT += t[0] / @aveCri[ind]
          @arraySumT[ind] = t[0] / @aveCri[ind]
        end
        @aTA = @arrayTAve.count.to_f
        @aveT = @sumT.to_f/@aTA
        @consIndex = (@aveT-@aTA)/(@aTA-1.to_f)
        @random = [0,0,0.58,0.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49, 1.51, 1.48, 1.56, 1.57, 1.59]
        begin
          @consist = @consIndex / @random[@aTA-1]
        rescue
          @consist = @consIndex / 0
        end

      rescue
        @dataAve = []
      end
  end

  def getAverageAlt
    return AlternativeCriterionComparisonsController.get_average
  end

  def getAverageCri
    return CriterionComparisonsController.get_criterion_average
  end

  def getMatrixCriFromCCC
    return CriterionComparisonsController.get_matrix_cri
  end
end
