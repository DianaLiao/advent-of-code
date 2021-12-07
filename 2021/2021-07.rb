require './input.rb'

# 

def simple_fuel_usage(array, position)
  # array.reduce{|sum, pos| sum + (pos-position).abs}
  array.map{|pos| (pos-position).abs}.sum
end 

def one_crab_fuel_burn(steps)
  return 0 if steps == 0
  (1..steps).to_a.sum
end

def real_fuel_usage(array, position)
  # given a position, how much are all the crabs burning?
  used_fuel_array = array.map do |crab_pos|
    steps = (crab_pos-position).abs
    one_crab_fuel_burn(steps)
  end

  used_fuel_array.sum
end

def lowest_crab_fuel_burn(position_array)
  # avg = position_array.sum/position_array.length
  range = (position_array.min..position_array.max).to_a

  fuel_usage_hash = {}
  range.each{|position| fuel_usage_hash[position] = simple_fuel_usage(position_array, position)}
  p fuel_usage_hash.values.min
end

def actual_lowest_crab_fuel_burn(position_array)
  range = (position_array.min..position_array.max).to_a

  fuel_usage_hash = {}
  range.each{|position| fuel_usage_hash[position] = real_fuel_usage(position_array, position)}
  p fuel_usage_hash.values.min
end

lowest_crab_fuel_burn(Input.day_7_input)
actual_lowest_crab_fuel_burn(Input.day_7_input)


require 'rspec'

describe 'Crab brigade' do
  context 'helper methods' do
    it 'one crab fuel burn returns zero if zero' do
      expect(one_crab_fuel_burn(0)).to eq(0)
    end

    it 'one crab fuel burn is additive' do
      expect(one_crab_fuel_burn(4)).to eq(10)
    end
  end
  context 'finds fuel usage' do
    it 'sample 1' do 
      sample_input = Input.day_7_sample_input
      expect(simple_fuel_usage(sample_input,2)).to eq(37)
    end

    it 'sample 2' do 
      sample_input = Input.day_7_sample_input
      expect(simple_fuel_usage(sample_input,1)).to eq(41)
    end
  end

  context 'sample tests' do
    it 'sample input part 1' do
      sample_input = Input.day_7_sample_input
      expect(lowest_crab_fuel_burn(sample_input)).to eq(37)
    end

    it 'sample input part 2' do
      sample_input = Input.day_7_sample_input
      expect(actual_lowest_crab_fuel_burn(sample_input)).to eq(168)
    end
  end

end