require 'json'

def read_numbers(offset, array)
  nj = []
  index = 0
  array[offset..-1].each_with_index do |str,i|
    index= i 
    break if str == "\n" 
    nj << str.to_f
  end
  return nj, index + offset + 1
end
def read_sizes(offset, array)
  min = []
  max = []
  array[offset..-1].each do |str|
    if str != "\n"
      if str.start_with?('(')
        min << str.tr(')(','').to_f
      else
        max << str.to_f
      end
    end
  end
  return min, max
end
def chunk(arr, sizen=2)
     chunks = []
     (0...arr.length).step(sizen) { |n| chunks << arr[n,sizen] }
     chunks
end
line_array = IO.readlines('/Users/achikin/Downloads/bas_sizingchart.txt')
jumps, index = read_numbers(0, line_array)
weights, index = read_numbers(index, line_array)
min_sizes, max_sizes = read_sizes(index, line_array)
min_chunked = chunk(min_sizes, jumps.length)
max_chunked = chunk(max_sizes, jumps.length)
ubermap = {:weights => weights, :jumps => jumps, :sizes_min => min_chunked, :sizes_recommended => max_chunked}
File.open('downsizing_chart.json', 'w') do |f|
  f.puts ubermap.to_json
end
