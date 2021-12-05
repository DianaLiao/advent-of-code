require './input.rb'

def generate_fresh_point_grid(high_index)
  matrix = []
  (high_index + 1).times do
    matrix << Array.new(high_index+1, 0)
  end

  matrix
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

def range_from_values(v1, v2)
  v1 > v2 ? (v2..v1).to_a : (v1..v2).to_a
end

def make_array(v1, v2)
  array = []
  if v1 > v2
    array = (v2..v1).to_a.reverse
  elsif v2 > v1
    array = (v1..v2).to_a
  end

  array
end

def draw_lines_over_matrix(coord_pairs_array, matrix)
  coord_pairs_array.each do |pair|
    match_on_x = pair[:x1] == pair[:x2]
    match_on_y = pair[:y1] == pair[:y2]
    if match_on_x 
      x = pair[:x1]
      for y in range_from_values(pair[:y1], pair[:y2]) do
        matrix[y][x] += 1
      end
    end
    if match_on_y 
      y = pair[:y1]
      for x in range_from_values(pair[:x1], pair[:x2]) do
        matrix[y][x] += 1
      end
    end
  end

  matrix
end

def draw_all_the_lines(coord_pairs_array, matrix)
  coord_pairs_array.each do |pair|
    match_on_x = pair[:x1] == pair[:x2]
    match_on_y = pair[:y1] == pair[:y2]
    diag = (pair[:x1]-pair[:x2]).abs == (pair[:y1]-pair[:y2]).abs
    if match_on_x 
      x = pair[:x1]
      for y in range_from_values(pair[:y1], pair[:y2]) do
        matrix[y][x] += 1
      end
    elsif match_on_y 
      y = pair[:y1]
      for x in range_from_values(pair[:x1], pair[:x2]) do
        matrix[y][x] += 1
      end
    elsif diag
      y_coords = make_array(pair[:y1], pair[:y2])
      x_coords = make_array(pair[:x1], pair[:x2])
      counter = 0
      y_coords.length.times do
        matrix[y_coords[counter]][x_coords[counter]] += 1
        counter += 1
      end
    end
  end

  matrix
end

def part1(input, high_index)
  matrix = generate_fresh_point_grid(high_index)
  lines = parse_input(input)
  end_matrix = draw_lines_over_matrix(lines,matrix)
  points_over_2 = end_matrix.flatten.filter{|num| num > 1}.count
  puts points_over_2
end

def part2(input, high_index)
  matrix = generate_fresh_point_grid(high_index)
  lines = parse_input(input)
  end_matrix = draw_all_the_lines(lines,matrix)
  points_over_2 = end_matrix.flatten.filter{|num| num > 1}.count
  puts points_over_2
end

part1(Input.day_5_sample_input,9)
part1(Input.day_5_input,999)
part2(Input.day_5_sample_input,9)
part2(Input.day_5_input,999)