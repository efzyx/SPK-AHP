class CriterionComparisonsController < ApplicationController
  $cri = Criterion.all unless Criterion.nil?
  $ccs = CriterionComparison.all.order(criterion_id: :asc)
  def index
    @cc = CriterionComparison.new
    @ccs = $ccs
    @criterions = $cri
    @curretCri = get_comparison_criterion
  end

  def create
    @cc = CriterionComparison.new (cc_params)
    if @cc.save
      redirect_to criterion_comparisons_path, notice: 'Berhasil menambahkan perbandingan'
    else
      redirect_to criterion_comparisons_path
    end
  end

  private
  def cc_params
    params.require(:criterion_comparison).permit(:criterion_id, :comparison, :other_criterion_id)
  end

  def get_comparison_criterion
    @sumCri = $cri.count
    @curretCri1 = nil
    @curretCri2 = nil

    if $ccs.empty?
      @curretCri1 = $cri.first.id
      @curretCri2 = $cri.first.next.id
    else
      @ketemu = false
      $cri.each do |c|
        if $ccs.where(criterion_id: c.id).exists?
          @cri1 = $ccs.where(criterion_id: c.id)
          @cri2 = $ccs.where(other_criterion_id: c.id)
          @latestCri = @cri1.last
          @latestCri2 = @latestCri.other_criterion_id
          @criForCurrentCri2 = $cri.find(@latestCri2).next
          if (@cri1.count + @cri2.count) < @sumCri-1
            @curretCri1 = c.id
            @curretCri2 = @criForCurrentCri2.id
            @ketemu = true
          end
        elsif
          begin
          @curretCri1 = c.id
          @curretCri2 = c.next.id
          @ketemu = true
          rescue
            @ketemu = true
          end
        end
        break if @ketemu == true
      end
    end
    return [@curretCri1, @curretCri2]
  end
end
