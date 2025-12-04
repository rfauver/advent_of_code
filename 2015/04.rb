require 'digest'

key = File.read("04.txt").chomp

# part 1
(1..).each do |num|
  if Digest::MD5.hexdigest("#{key}#{num}").start_with?("00000")
    p num
    break
  end
end

# part 2
(1..).each do |num|
  if Digest::MD5.hexdigest("#{key}#{num}").start_with?("000000")
    p num
    break
  end
end
