# Welcome to Sonic Pi v3.0.1

$rules = { '111' => :guit_harmonics, '110' => :guit_e_fifths, '101' => :guit_e_slide, '100' => :guit_em9,
           '011' => :perc_bell, '010' => :perc_snap, '001' => :perc_snap2, '000' => :perc_swash}

$generations = [[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]];

define :nextGeneration do |last|
  result = []
  for idx in (0...last.length)
    leftIdx = idx > 0 ? idx - 1 : last.length - 1;
    rightIdx = idx < last.length - 1 ? idx + 1 : 0;
    key = "#{last[leftIdx]}#{last[idx]}#{last[rightIdx]}";
    print("Key is: " + key);
    
    result[idx] = $rules[key];
  end
  return result;
end

define :play_generation do |generation|
  for idx in (0..generation.length-1)
    print("chord: " + generation[idx].to_s + "\n")
    sample generation[idx], rate: 0.5
    sleep 1
  end
end

last_generation = $generations[$generations.length - 1];
$generations.push(nextGeneration(last_generation));

for idx in (0..$generations.length-1)
  play_generation $generations[idx]
end

