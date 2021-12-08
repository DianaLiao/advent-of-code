require './input.rb'

# 0:      1:      2:      3:      4:
# aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
# gggg    ....    gggg    gggg    ....

#  5:      6:      7:      8:      9:
# aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
# dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
# gggg    gggg    ....    gggg    gggg

# top - 8, middle - 7, bottom - 7, left top - 6, right top - 8, left bottom - 4, right bottom - 9

# 0: 6 segs; 2 h, 4 v
# 1: 2 segs; 2 v (cis)
# 2: 5 segs; 3 h, 2 v (trans)
# 3: 5 segs; 3 h, 2 v (cis)
# 4: 4 segs; 1 h (center), 3 v
# 5: 5 segs; 3 h, 2 v (trans)
# 6: 6 segs; 3 h, 3 v
# 7: 3 segs; 1 h (top), 2 v (cis)
# 8: 7 segs; all!
# 9: 6 segs; 3 h, 3 v


def parse_to_lines(input)
  lines = input.split(/\n/)
  split_lines = lines.map do |line| 
    chunks = line.split("|")
    patterns = chunks[0].strip.split(" ")
    output_as_strings = chunks[1].strip.split(" ")
    {patterns: patterns, output: output_as_strings}
  end
end

def segment_key_template
  {
    top: "",
    middle: "",
    bottom: "",
    upper_left: "",
    upper_right: "",
    lower_left: "",
    lower_right: ""
  }
end

def count_segments(patterns)
  patterns.each_with_object({}) do |pattern, hash|
    pattern.split("").each do |letter|
      hash[letter] ||= 0
      hash[letter] += 1
    end
  end
end

def figure_out_segments(patterns)
  segment_key = segment_key_template
  segment_count = count_segments(patterns)
  segment_key[:lower_right] = segment_count.key(9)
  segment_key[:lower_left] = segment_count.key(4)
  segment_key[:upper_left] = segment_count.key(6)
  one = patterns.find{|pattern| pattern.length == 2}
  segment_key[:upper_right] = one.split("").find{|letter| letter != segment_key[:lower_right]}
  seven = patterns.find{|pattern| pattern.length == 3}
  segment_key[:top] = seven.split("").find{|letter| !segment_key.values.include?(letter)}
  four = patterns.find{|pattern| pattern.length == 4}
  segment_key[:middle] = four.split("").find{|letter| !segment_key.values.include?(letter)}
  segment_key[:bottom] = "abcdefg".split("").find{|letter| !segment_key.values.include?(letter)}
  segment_key
end

def segments_to_numbers(key)
  number_key = {}
  number_key["1"] = key.fetch_values(:upper_right, :lower_right)
  number_key["2"] = key.fetch_values(:top, :middle, :bottom, :upper_right, :lower_left)
  number_key["3"] = key.fetch_values(:top, :middle, :bottom, :upper_right, :lower_right)
  number_key["4"] = key.fetch_values(:middle, :upper_left, :upper_right, :lower_right)
  number_key["5"] = key.fetch_values(:top, :middle, :bottom, :upper_left, :lower_right)
  number_key["6"] = key.fetch_values(:top, :middle, :bottom, :upper_left, :lower_left, :lower_right)
  number_key["7"] = key.fetch_values(:top, :upper_right, :lower_right)
  number_key["8"] = key.values
  number_key["9"] = key.fetch_values(:top, :middle, :bottom, :upper_right, :lower_right, :upper_left)
  number_key["0"] = key.fetch_values(:top, :bottom, :upper_left, :upper_right, :lower_right, :lower_left)

  number_key
end

def figure_out_key(patterns)
  segment_key = figure_out_segments(patterns)
  number_key = segments_to_numbers(segment_key)
end

def output_to_number(output, key)
  num_array = output.map do |string|
    letter_array = string.split("")
    num_string = ""
    key.each do |number, seg_array| 
      if (letter_array.length == seg_array.length) && (letter_array & seg_array == letter_array)
        num_string.concat(number)
      end
    end
    num_string
  end
  num_array.join.to_i
end

def part1(puzzle_input)
  parsed_input_array = parse_to_lines(puzzle_input)
  count = 0

  parsed_input_array.each do |line|
    line[:output].each do |letter_combo|
      if [2,3,4,7].include?(letter_combo.length)
        count += 1
      end
    end
  end
  count
end

def part2(puzzle_input)
  parsed_input_array = parse_to_lines(puzzle_input)
  sum = 0

  parsed_input_array.each do |line|
    number_key = figure_out_key(line[:patterns])
    num = output_to_number(line[:output], number_key)
    sum += num
  end

  sum
end


# puts part1(Input.day_8_input)
# p figure_out_segments(["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"])
# number_key = segments_to_numbers({:top=>"d", :middle=>"c", :bottom=>"f", :upper_left=>"g", :upper_right=>"b", :lower_left=>"a", :lower_right=>"e"})
# p output_to_number(["fdgacbe", "cefdb", "cefbgd", "gcbe"],number_key)

p part2(Input.day_8_input)

require 'rspec'
describe 'Day 8' do
  context 'helper methods' do
    # it 'parser works' do
    #   input = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    #     edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc"
    #   expect(parse_to_lines(input)).to eq([])
    # end

    it 'counts letters' do
      patterns = ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"]
      expect(count_segments(patterns)).to eq({"a" => 4, "b" => 8, "c" => 7, "d" => 8, "e" => 9, "f" => 7, "g" => 6})
    end

    it 'figures out segments' do
      patterns = ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"]
      expect(figure_out_segments(patterns)).to eq({:top=>"d", :middle=>"c", :bottom=>"f", :upper_left=>"g", :upper_right=>"b", :lower_left=>"a", :lower_right=>"e"})
    end
  end

  context 'sample input answers' do
    it 'for part 1' do
      expect(part1(Input.day_8_sample_input)).to eq(26)
    end
  end

end