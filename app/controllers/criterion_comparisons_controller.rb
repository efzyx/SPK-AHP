class CriterionComparisonsController < ApplicationController
  before_action :set_cc, only: [:edit, :update, :destroy]
  def index
    begin
        @data = get_comparison_table
        @c = 0
        @sumFix = []
        @data.each_with_index do |fd1, index1|
          @sumOne = 0
          @data.each_with_index do |fd, index|
            @sumOne += @data[index][index1]
          end
          @sumFix[@c] = @sumOne
          @c += 1
        end

        @s = 0
        @normalFix = []
        @average = []
        @data.each_with_index do |fd1, index1|
          @sumAv = 0
          @norm = []
          @l = 0
          @data.each_with_index do |fd, index|
            @norm[@l] = @data[index1][index] / @sumFix[index]
            @sumAv += @norm[@l]
            @l += 1
          end
          @average[@s] = @sumAv/@data.count
          @normalFix[@s] = @norm
          @s += 1
        end


        @x = 0
        @sumNormalFix = []
        @normalFix.each_with_index do |fd1, index1|
          @sumOne = 0
          @normalFix.each_with_index do |fd, index|
            @sumOne += @normalFix[index][index1]
          end
          @sumNormalFix[@x] = @sumOne
          @x += 1
        end
        @sumNormalFix[@x] = @average.inject(0, :+)
      rescue
        redirect_to new_criterion_comparison_path
        flash[:warning] = 'Lengkapi Perbandingan terlebih dahulu'
      end
  end

  def new
    @cc = CriterionComparison.new
    @curretCri = get_comparison_criterion
  end

  def edit
    @curretCri = [@cc.criterion_id, @cc.other_criterion_id]
  end

  def update
    if @cc.update(cc_params)
      redirect_to new_criterion_comparison_path, notice: 'Berhasil update perbandingan'
    else
      redirect_to new_criterion_comparison_path
      flash[:warning] = 'Gagal update, periksa kembali data'
    end
  end

  def create
    @cc = CriterionComparison.new(cc_params)
    if @cc.save
      redirect_to new_criterion_comparison_path, notice: 'Berhasil menambahkan perbandingan'
    else
      redirect_to new_criterion_comparison_path
      flash[:warning] = 'Gagal menyimpan, periksa kembali data'
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
    @kriteria = Criterion.all
    @sum = @kriteria.count
    @data = []
    @n = 0
    @kriteria.each do |k|
      @dt = CriterionComparison.where(criterion_id: k.id).order(other_criterion_id: :asc)
      @i = 0
      @dat = []
      @dt.each do |dt|
        @dat[@i] = dt.comparison
        @i += 1
      end
      @data[@n] = @dat
      @n += 1
    end
    @fixdata = Array.new(@sum) { Array.new(@sum) }

    @kriteria.each_with_index do |k, i|
      (0..i).each do |n|
        if i == n
          @fixdata[i][n] = 1.to_f
          @k = n+1
          @data[i].each do |d|
            @fixdata[i][@k] = d
            @k += 1
          end
        elsif n < i
          @fixdata[i][n] = 1/@fixdata[n][i]
        end
      end
    end
    return @fixdata
  end
end
