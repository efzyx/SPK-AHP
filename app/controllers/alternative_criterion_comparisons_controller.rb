class AlternativeCriterionComparisonsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
  before_action :set_acc, only: [:edit, :update, :destroy]
  before_action :set_alt
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
        redirect_to new_alternative_alternative_criterion_comparison_path(@alternative)
        flash[:warning] = 'Lengkapi Perbandingan terlebih dahulu'
    end
  end

  def self.get_average
    @altr = Alternative.all
    @n = 0
    @averageFix = []
    @altr.each_with_index do |altrr, indexho|
      @averageTemp = []
      @data = self.get_comparison_table(altrr.id)
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
        @averageTemp = @average
        @s += 1
      end
      @averageFix[indexho] = @averageTemp
    end

    return @averageFix
  end

  def new
    if Criterion.count > 1
      @acc = AlternativeCriterionComparison.new(alternative_id: params[:alternative_id])
      @curretCri = get_comparison_criterion
    else
      @acc = nil
    end
  end

  def create
    @acc = AlternativeCriterionComparison.new(acc_params)
    if @acc.save
      redirect_to  new_alternative_alternative_criterion_comparison_path(@alternative), notice: 'Berhasil menambahkan perbandingan'
    else
      redirect_to new_alternative_alternative_criterion_comparison_path(@alternative)
      flash[:warning] = 'Gagal menambahkan, periksa kembali'
    end
  end

  def edit
    @curretCri = [@acc.criterion_id, @acc.other_criterion_id]
  end

  def update
    if @acc.update(cc_params)
      redirect_to new_alternative_alternative_criterion_comparison_path(@alternative), notice: 'Berhasil update perbandingan'
    else
      redirect_to new_alternative_alternative_criterion_comparison_path(@alternative)
      flash[:warning] = 'Gagal update, periksa kembali'
    end
  end

  def destroy
    @acc.destroy
    redirect_to new_alternative_alternative_criterion_comparison_path(@alternative), notice: 'Perbandingan berhasil dihapus'
  end

  private

  def set_acc
    @acc = AlternativeCriterionComparison.find(params[:id])
  end

  def set_alt
    @alternative = Alternative.find(params[:alternative_id])
  end


  def acc_params
    params.require(:alternative_criterion_comparison).permit(:alternative_id, :criterion_id, :comparison, :other_criterion_id)
  end

  def get_comparison_criterion
    @cri = Criterion.all unless Criterion.nil?
    @ccs = AlternativeCriterionComparison.where(alternative_id: @alternative.id).order(criterion_id: :asc, other_criterion_id: :asc)
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

  def get_comparison_table
    @kriteria = Criterion.all
    @sum = @kriteria.count
    @data = []
    @n = 0
    @kriteria.each do |k|
      @dt = AlternativeCriterionComparison.where(alternative_id: @alternative.id, criterion_id: k.id).order(other_criterion_id: :asc)
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

  def self.get_comparison_table(*id)
    @kriteria = Criterion.all
    @sum = @kriteria.count
    @data = []
    @n = 0
    @kriteria.each do |k|
      @dt = AlternativeCriterionComparison.where(alternative_id: id, criterion_id: k.id).order(other_criterion_id: :asc)
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
