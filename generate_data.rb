require 'json'
uberdata = nil
File.open('downsizing_chart.json') do |f|
  uberdata = JSON.parse(f.read)
end
def generate_full_chart(sizes, weights, jumps)
  map = []
  weights.each_with_index do |w,i|
    values = []
    jumps.each_with_index do |n,j|
      values << {:x => n, :y => (w/sizes[i][j]).round(2)}
    end
    map << { :values => values, :key => "#{(w*0.45).round} kg" }
  end
  map
end

def generate_mixed(weights, jumps, sizes_recommended, sizes_max, weight)
  values_recommended = []
  values_max = []
  w = weights.index(weight)
  puts w
  jumps.each_with_index do |n,j|
    values_recommended << {:x => n, :y => (weights[w]/sizes_recommended[w][j]).round(2)}
    values_max << {:x => n, :y => (weights[w]/sizes_max[w][j]).round(2)}
  end
  map_mixed = []
  map_mixed << { :values => values_max, :key => "Maximum" }
  map_mixed << { :values => values_recommended, :key => "Recommended" }
  map_mixed
end
File.open('wl-recommended.json','w') do |f|
  f.puts "wlRecommended = #{(generate_full_chart(uberdata['sizes_recommended'], uberdata['weights'], uberdata['jumps'])).to_json}"
end
File.open('wl-max.json','w') do |f|
  f.puts "wlMax = #{(generate_full_chart(uberdata['sizes_min'], uberdata['weights'], uberdata['jumps'])).to_json}"
end
File.open('wl-mixed-89.json','w') do |f|
  f.puts "wl89Mixed = #{(generate_mixed(uberdata['weights'], uberdata['jumps'], uberdata['sizes_recommended'], uberdata['sizes_min'], 198)).to_json}"
end
