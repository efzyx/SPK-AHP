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
        redirect_to new_criterion_alternative_criterion_comparison_path(@criterion)
        flash[:warning] = 'Lengkapi Perbandingan terlebih dahulu'
    end
  end

  def self.get_average
    @krite = Criterion.all.order(id: :asc)
    @n = 0
    @averageFix = []
    @krite.each_with_index do |altrr, indexho|
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
    if Alternative.count > 1
      @acc = AlternativeCriterionComparison.new(criterion_id: params[:criterion_id])
      @curretAlt = get_comparison_criterion
    else
      @acc = nil
    end
  end

  def create
    @acc = AlternativeCriterionComparison.new(acc_params)
    if @acc.save
      redirect_to  new_criterion_alternative_criterion_comparison_path(@criterion), notice: 'Berhasil menambahkan perbandingan'
    else
      redirect_to new_criterion_alternative_criterion_comparison_path(@criterion)
      flash[:warning] = 'Gagal menambahkan, periksa kembali'
    end
  end

  def edit
    @curretAlt = [@acc.alternative_id, @acc.other_alternative_id]
  end

  def update
    if @acc.update(cc_params)
      redirect_to new_criterion_alternative_criterion_comparison_path(@criterion), notice: 'Berhasil update perbandingan'
    else
      redirect_to new_criterion_alternative_criterion_comparison_path(@criterion)
      flash[:warning] = 'Gagal update, periksa kembali'
    end
  end

  def destroy
    @acc.destroy
    redirect_to new_criterion_alternative_criterion_comparison_path(@criterion), notice: 'Perbandingan berhasil dihapus'
  end

  private

  def set_acc
    @acc = AlternativeCriterionComparison.find(params[:id])
  end

  def set_alt
    @criterion = Criterion.find(params[:criterion_id])
  end


  def acc_params
    params.require(:alternative_criterion_comparison).permit(:criterion_id, :alternative_id, :comparison, :other_alternative_id)
  end

  def get_comparison_criterion
    @alt = Alternative.all.order(id: :asc) unless Alternative.nil?
    @ccs = AlternativeCriterionComparison.where(criterion_id: @criterion.id).order(alternative_id: :asc, other_alternative_id: :asc)
    @sumAlt = @alt.count
    @curretAlt1 = nil
    @curretAlt2 = nil

    if @ccs.empty?
      @curretAlt1 = @alt.first.id
      @curretAlt2 = @alt.first.next.id
    else
      @ketemu = false
      @alt.each do |c|
        if @ccs.where(alternative_id: c.id).exists?
          @alt1 = @ccs.where(alternative_id: c.id)
          @alt2 = @ccs.where(other_alternative_id: c.id)

          @alternatif = c.next
          @alt1.each do |cr|
            @stop = false
            @alt1.each do |cr2|
              if cr2.other_alternative_id == @alternatif.id
                @stop = true
              end
              break if @stop == true
            end
            break if @stop == false
            @alternatif = @alternatif.next
          end


          if (@alt1.count + @alt2.count) < @sumAlt-1
            @curretAlt1 = c.id
            @curretAlt2 = @alternatif.id
            @ketemu = true
          end

        else
          begin
            @curretAlt1 = c.id
            @curretAlt2 = c.next.id
            @ketemu = true
          rescue
            @ketemu = true
          end
        end
        break if @ketemu == true
      end
    end
    return [@curretAlt1, @curretAlt2]
  end

  def get_comparison_table
    @alternatif = Alternative.all.order(id: :asc)
    @sum = @alternatif.count
    @data = []
    @n = 0
    @alternatif.each do |k|
      @dt = AlternativeCriterionComparison.where(criterion_id: @criterion.id, alternative_id: k.id).order(other_alternative_id: :asc)
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

    @alternatif.each_with_index do |k, i|
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
    @alternatif = Alternative.all.order(id: :asc)
    @sum = @alternatif.count
    @data = []
    @n = 0
    @alternatif.each do |k|
      @dt = AlternativeCriterionComparison.where(criterion_id: id, alternative_id: k.id).order(other_alternative_id: :asc)
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

    @alternatif.each_with_index do |k, i|
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
