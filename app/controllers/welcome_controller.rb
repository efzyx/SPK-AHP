class WelcomeController < ApplicationController
  require 'matrix'
  def index
    # @data = set_data
    #
    # @data.each_with_index do |d, i|
    #
    #   @c = 0
    #   @sumFix = []
    #   @data[i].each_with_index do |fd1, index1|
    #     @sumOne = 0
    #     @data[i].each_with_index do |fd, index|
    #       @sumOne += @data[i][index][index1]
    #     end
    #     @sumFix[@c] = @sumOne
    #     @c += 1
    #   end
    #
    #   @s = 0
    #   @normalFix = []
    #   @average = []
    #   @data[i].each do |fd1, index1|
    #     @sumAv = 0
    #     @norm = []
    #     @l = 0
    #     @data[i].each_with_index do |fd, index|
    #       @norm[@l] = @data[i][index1][index] / @sumFix[index]
    #       @sumAv += @norm[@l]
    #       @l += 1
    #     end
    #     @average[@s] = @sumAv/@data.count
    #     @normalFix[@s] = @norm
    #     @s += 1
    #   end
    #   @x = 0
    #   @sumNormalFix = []
    #   @normalFix.each_with_index do |fd1, index1|
    #     @sumOne = 0
    #     @normalFix.each_with_index do |fd, index|
    #       @sumOne += @normalFix[index][index1]
    #     end
    #     @sumNormalFix[@x] = @sumOne
    #     @x += 1
    #   end
    #   @sumNormalFix[@x] = @average.inject(0, :+)
    # end

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
  end

  def set_data
    AlternativeCriterionComparisonsController.get_index
  end

  def getAverageAlt
    return AlternativeCriterionComparisonsController.get_average
  end

  def getAverageCri
    return CriterionComparisonsController.get_criterion_average
  end
end
