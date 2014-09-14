w, c = nil, nil
c = File.open("/Users/rut216/Desktop/simple_cave.txt") do |f|
  w = f.readline
  c = f.read
end

water = w.to_i
cave = c.split(/\n/).map { |l| l.split(//) }.reject {|a| a.empty? }
# remove ceiling/flooer
cave = cave[1...-1]
# remove walls
cave = cave.transpose
cave = cave[1...-1]
puts cave.map {|r| r.join('')}

def depth(vertical)
  vertical.each_with_index { |i,idx| break idx if (['~','#'].include?(vertical[idx+1]) || idx == vertical.size - 1) } + 1
end

def distance(cave, column_number)
  columns_to_end = cave[0..column_number].reverse
  total = 0
  columns_to_end.each.with_index do |c, i|
    if !columns_to_end[i+1]
      total += depth(c)
    elsif depth(c) == depth(columns_to_end[i+1])
      total += 1
    else
      total += depth(c) - depth(columns_to_end[i+1]) + 2
    end
  end
  total
end
