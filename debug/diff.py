with open("2.txt") as txt:
  a, b = (txt.read()).split("\n")[:2]
print(a == b)
print(len(a))
print(len(b))
for pos, (i, j) in enumerate(zip(a, b)):

  if i != j:
    print(pos, repr(i), repr(j))
    print(a[pos - 30:pos + 30])
    print(b[pos - 30:pos + 30])
