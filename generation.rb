$rules = { '111' => 0, '110' => 0, '101' => 0, '100' => 1,
        '011' => 1, '010' => 1, '001' => 1, '000' => 0}

$generations = [[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]];

def nextGeneration(last)
  result = [] 
  for idx in (0...last.length)
    leftIdx = idx > 0 ? idx - 1 : last.length - 1;
    rightIdx = idx < last.length - 1 ? idx + 1 : 0;
    key = "#{last[leftIdx]}#{last[idx]}#{last[rightIdx]}";
    print("Key is: " + key + "\n");
    result[idx] = $rules[key];
  end
  return result;
end

last_generation = $generations[$generations.length - 1];
$generations.push(nextGeneration(last_generation));
