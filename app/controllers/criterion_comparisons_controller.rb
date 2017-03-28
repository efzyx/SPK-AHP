class CriterionComparisonsController < ApplicationController
  cri = Criterion.all unless Criterion.nil?
  ccs = CriterionComparison.all
  def index
    @cc = CriterionComparison.new
    @ccs = ccs
    @criterions = cri
  end

  def create
    @cc = CriterionComparison.new (cc_params)
    if @cc.save
      redirect_to criterion_comparisons_path, notice: 'Berhasil menambahkan perbandingan'
    else
      render criterion_comparisons_path
    end
  end

  private
  def cc_params
    params.require(:criterion_comparison).permit(:criterion_id, :comparison, :other_criterion_id)
  end

  def get_comparison_criterion
    @sumCri = cri.count
    @curretCri1 = nil
    @curretCri2 = nil

    if ccs.nil?
      @curretCri1 = cri.first.id
      @curretCri2 = @curretCri1.next

  end
end
