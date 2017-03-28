class CriterionComparisonsController < ApplicationController
  before_action :set_cc, only: [:edit, :update, :destroy]
  def index
  end

  def new
    @cc = CriterionComparison.new
    @criterions = $cri
    @curretCri = get_comparison_criterion
  end

  def edit
    @curretCri = [@cc.criterion_id, @cc.other_criterion_id]
  end

  def update
    if @cc.update(cc_params)
      redirect_to new_criterion_comparison_path, notice: 'Berhasil update perbandingan'
    else
      render :new
    end
  end

  def create
    @cc = CriterionComparison.new(cc_params)
    if @cc.save
      redirect_to new_criterion_comparison_path, notice: 'Berhasil menambahkan perbandingan'
    else
      redirect_to new_criterion_comparison_path
    end
  end

  def destroy
    @cc.destroy
    redirect_to new_criterion_comparison_path, notice: 'Perbandingan berhasil dihapus'
  end

  private
  def cc_params
    params.require(:criterion_comparison).permit(:criterion_id, :comparison, :other_criterion_id)
  end

  def get_comparison_criterion
    @cri = Criterion.all unless Criterion.nil?
    @ccs = CriterionComparison.all.order(criterion_id: :asc, other_criterion_id: :asc)
    @sumCri = @cri.count
    @curretCri1 = nil
    @curretCri2 = nil

    if @ccs.empty?
      @curretCri1 = @cri.first.id
      @curretCri2 = @cri.first.next.id
    else
      @ketemu = false
      @cri.each do |c|
        if @ccs.where(criterion_id: c.id).exists?
          @cri1 = @ccs.where(criterion_id: c.id)
          @cri2 = @ccs.where(other_criterion_id: c.id)

          @kriteria = c.next
          @cri1.each do |cr|
            @stop = false
            @cri1.each do |cr2|
              if cr2.other_criterion_id == @kriteria.id
                @stop = true
              end
              break if @stop == true
            end
            break if @stop == false
            @kriteria = @kriteria.next
          end


          if (@cri1.count + @cri2.count) < @sumCri-1
            @curretCri1 = c.id
            @curretCri2 = @kriteria.id
            @ketemu = true
          end

        else
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

  def set_cc
    @cc = CriterionComparison.find(params[:id])
  end

  def get_comparison_table
    
  end
end
