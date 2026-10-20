import hashlib

def weak_hash(message):
    """
    Computes the message digest of a string.
    message: A string of arbitrary length.
    Returns: The message digest (a weak, truncated hash).
    """
    full_hash = hashlib.sha256(message.encode()).digest()
    truncated_hash = full_hash[:3]   # keep only the first 3 bytes (24 bits)
    return truncated_hash.hex()

def collision_search(msg1):
    """
    Searches for a message whose digest is the same as the digest of msg1.
    msg1: A string of arbitrary length.
    Returns: A message different from msg1 that has the same digest as msg1.
    """
    digest1 = weak_hash(msg1)
    i = 0
    while True:
        msg2 = msg1 + str(i)
        if weak_hash(msg2) == digest1:   # same digest, different message
            return msg2
        i += 1

def main():
    msg1 = "Cybersecurity is soooo important!"
    msg2 = collision_search(msg1)             # may take up to a few minutes
    print("original message:", repr(msg1))
    print("collision message:", repr(msg2))
    print("original digest: ", weak_hash(msg1))
    print("collision digest:", weak_hash(msg2))
    print("same digest?", weak_hash(msg1) == weak_hash(msg2))

main()
