require './input.rb'

class Point
  attr_reader :x, :y
  attr_accessor :lines
  @@all = []

  def initialize(x,y)
    @x = x
    @y = y
    @lines = 0

    @@all << self
  end

  def self.all
    @@all
  end

  def self.find_point(x,y)
    all.find{|point| point.x == x && point.y == y}
  end

  def self.points_with_at_least_lines(num)
    all.filter{|point| point.lines >= num }
  end

end

def parse_input(input)
  coord_strings = input.split(/\n/).map{|e| e.strip}
            .map{|line| line.split(" -> ")}
  coord_pairs = coord_strings.map do |pair|
    first_coord = pair[0].split(",")
    second_coord = pair[1].split(",")
    {x1:first_coord[0].to_i, y1:first_coord[1].to_i, x2:second_coord[0].to_i, y2:second_coord[1].to_i}
  end

  coord_pairs
end

def draw_lines_over_points(coord_pairs_array)
  counter = 0
  coord_pairs_array.each do |pair|
    match_on_x = pair[:x1] == pair[:x2]
    match_on_y = pair[:y1] == pair[:y2]
    if match_on_x 
      for y in range_from_values(pair[:y1], pair[:y2]) do
        point = Point.find_point(pair[:x1], y)
        point.lines += 1
      end
    end
    if match_on_y 
      for x in range_from_values(pair[:x1], pair[:x2]) do
        point = Point.find_point(x, pair[:y1])
        point.lines += 1
      end
    end
    counter += 1
    print counter
  end
end

def range_from_values(v1, v2)
  v1 > v2 ? (v2..v1).to_a : (v1..v2).to_a
end

def make_points
  for x in 0..999 do 
    for y in 0..999 do
      Point.new(x,y)
    end
  end
end

def part1(input)
  make_points
  lines = parse_input(input)
  draw_lines_over_points(lines)
  points = Point.points_with_at_least_lines(2)

  puts points.count
end

# test_input = parse_input(Input.day_5_sample_input)
# make_points
# draw_lines_over_points(test_input)
# print Point.all

# part1(Input.day_5_input)

def generate_fresh_point_grid(high_index)
  row = []
  (high_index + 1).times do
    row << 0
  end

  array = []
  (high_index + 1).times do
    array << row
  end

  array
end

def draw_lines_over_matrix(coord_pairs_array, master_matrix)
  coord_pairs_array.each do |pair|
    print master_matrix
    match_on_x = pair[:x1] == pair[:x2]
    match_on_y = pair[:y1] == pair[:y2]
    if match_on_x 
      puts pair
      x = pair[:x1]
      for y in range_from_values(pair[:y1], pair[:y2]) do
        puts x, y
        # master_matrix[y][x] += 1
        print master_matrix
      end
    end
    if match_on_y 
      puts pair
      y = pair[:y1]
      for x in range_from_values(pair[:x1], pair[:x2]) do
        puts x, y
        temp = master_matrix[y][x]
        new_val = temp + 1
        master_matrix[y][x] = new_val
        # master_matrix[y][x] += 1
        print master_matrix
      end
    end
  end

  master_matrix
end

def part1_try2(input, high_index)
  matrix = generate_fresh_point_grid(high_index)
  lines = parse_input(input)
  draw_lines_over_matrix(lines,matrix)
  points_over_2 = matrix.flatten.filter{|num| num > 1}.count
  puts points_over_2
end

part1_try2(Input.day_5_sample_input,9)