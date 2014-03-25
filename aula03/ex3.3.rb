def ordena(array)
   return array if array.size <= 1
   pivot = array[0]
   return ordena(array.select { |y| y < pivot }) +
          array.select { |y| y == pivot } +
          ordena(array.select { |y| y > pivot })
end
a=[20,0,50,30,34,33,35,22,1]
print ordena(a)
