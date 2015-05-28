n = 100
num = n
while n > 1 do
  num = num * (n - 1)
  n = n - 1
end

digits = []

while num != 0 do
  num, last_digit = num.divmod(10)
  digits << last_digit
end

puts digits.reduce(:+)
