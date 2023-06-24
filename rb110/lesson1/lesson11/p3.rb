ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }



ages.select! {|_, v| v <= 100 }
p ages