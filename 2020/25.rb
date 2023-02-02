# part 1

public_key_1 = 10604480
public_key_2 = 4126658

# public_key_1 = 5764801
# public_key_2 = 17807724

def compute_loop_size(public_key)
  value = 1
  subject = 7
  (1..).each do |loop_size|
    value *= subject
    value = value % 20201227
    return loop_size if value == public_key
  end
end

secret_loop_size_1 = compute_loop_size(public_key_1)
secret_loop_size_2 = compute_loop_size(public_key_2)


def compute_encryption_key(loop_size, public_key)
  value = 1
  subject = public_key
  loop_size.times do
    value *= subject
    value = value % 20201227
  end
  value
end

compute_encryption_key(secret_loop_size_1, public_key_2)
compute_encryption_key(secret_loop_size_2, public_key_1)
