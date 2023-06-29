hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}




fruit_veg = []

hsh.each do |_, value|
  if value[:type] == 'vegetable'
    fruit_veg.push(value[:size].upcase)
  else 
    arr = value[:colors].map do |color|
        color.capitalize
      end
    fruit_veg.push(arr)
  end
end

p fruit_veg

hsh.map do |_, value|
  if value[:type] == 'fruit'
    value[:colors].map do |color|
      color.capitalize
    end
  elseif value[:type] == 'vegetable'
    value[:size].upcase
  end
end
