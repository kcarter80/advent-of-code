def levenshtein_distance(s, t)
  m = s.length
  n = t.length
  return m if n == 0
  return n if m == 0
  d = Array.new(m+1) {Array.new(n+1)}

  (0..m).each {|i| d[i][0] = i}
  (0..n).each {|j| d[0][j] = j}
  (1..n).each do |j|
    (1..m).each do |i|
      d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                  d[i-1][j-1]       # no operation required
                else
                  [ d[i-1][j]+1,    # deletion
                    d[i][j-1]+1,    # insertion
                    d[i-1][j-1]+1,  # substitution
                  ].min
                end
    end
  end
  d[m][n]
end

boxes = []
File.open("input2", "r") do |f|
  f.each_line do |line|
    boxes.push(line.strip)
  end
end

j = 0
k = 0

while j < boxes.length
  while k < boxes.length
    if levenshtein_distance(boxes[k],boxes[j]) == 1
      puts "#{j} #{k} #{boxes[k]} #{boxes[j]}" 
    end
    k += 1
  end
  j += 1
  k = 0
end