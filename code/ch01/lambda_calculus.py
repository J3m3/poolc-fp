# Church Encoding: Boolean

T = lambda a: lambda b: a # True (in lambda calculus, λxy.x)
T.__name__ = "True"
F = lambda a: lambda b: b # False (in lambda calculus, λxy.y)
F.__name__ = "False"

notB = lambda p: p(F)(T) # Negation
andB = lambda p: lambda q: p(q)(p) # Conjunction
orB = lambda p: lambda q: p(p)(q) # Disjunction
eqB = lambda p: lambda q: p(q)(notB(q)) # Equal

x = T
y = F

print(notB(x).__name__); # !x
print(eqB(x)(y).__name__); # x == y
print(orB(eqB(notB(x))(y))(andB(y)(x)).__name__); # !x == y || (y && x)
