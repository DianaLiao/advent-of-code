require './input.rb'

class Lanternfish
  attr_accessor :timer
  @@all = []

  def initialize(timer = 9)
    @timer = timer

    @@all << self
  end

  def age_day
    @timer -= 1
    if @timer < 0
      Lanternfish.new
      @timer = 6
    end
  end

  def self.create_fish(array)
    array.map{|age| Lanternfish.new(age)}
  end

  def self.age_all_fish
    @@all.each{|fish| fish.age_day}
  end

  def self.timers_list
    @@all.map{|fish| fish.timer}
  end

  def self.exterminate
    @@all.clear
  end

  def self.all
    @@all
  end

end

# let's run stuff
def predict_the_fish(init_fish, days)
  Lanternfish.create_fish(init_fish)
  days.times do
    Lanternfish.age_all_fish
  end
  Lanternfish.all.count
end

puts predict_the_fish(Input.day_6_sample_input, 256)

# tests!
require 'rspec'

describe Lanternfish do
  context 'fish creation' do
    it 'creates a fish' do
      fish = Lanternfish.new
      expect(fish.class).to eq(Lanternfish)
    end

    it 'creates multiple fish from an array' do
      Lanternfish.exterminate
      new_fish = Lanternfish.create_fish([4,3,2])
      new_fish_timers = Lanternfish.timers_list
      expect(new_fish_timers).to eq([4,3,2])
    end
  end

  context 'timer countdown' do
    it 'reduces one fish timer' do
      fish = Lanternfish.new(3)
      fish.age_day
      expect(fish.timer).to eq(2)
    end

    it 'reduces multiple fish timers' do
      Lanternfish.exterminate
      Lanternfish.create_fish([5,1,2])
      Lanternfish.age_all_fish
      expect(Lanternfish.timers_list).to contain_exactly(4,0,1)
    end

    it 'creates a new fish after 0' do
      fish = Lanternfish.new(0)
      previous_fish_count = Lanternfish.all.count
      fish.age_day
      new_fish_count = Lanternfish.all.count
      expect(new_fish_count).to eq(previous_fish_count+1)
    end

    it 'does a good mix of stuff' do
      Lanternfish.exterminate
      Lanternfish.create_fish([0,1,0,5,6,7,8])
      Lanternfish.age_all_fish
      expect(Lanternfish.timers_list).to contain_exactly(6,0,6,4,5,6,7,8,8)
    end
  end

  context 'sample input' do
    it 'part 1 first example' do
      Lanternfish.exterminate
      sample_input = Input.day_6_sample_input
      days = 18

      count = predict_the_fish(sample_input,days)
      expect(count).to eq(26)
    end

    it 'part 1 second example' do
      Lanternfish.exterminate
      sample_input = Input.day_6_sample_input
      days = 80

      count = predict_the_fish(sample_input,days)
      expect(count).to eq(5934)
    end
  end

end
