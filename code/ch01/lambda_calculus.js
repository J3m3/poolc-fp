/* Church Encodings: Booleans */

const T = (a) => (b) => a; // True (in lambda calculus, λxy.x)
const F = (a) => (b) => b; // False (in lambda calculus, λxy.y)

const not = (p) => p(F)(T); // Negation
const and = (p) => (q) => p(q)(p); // Conjunction
const or = (p) => (q) => p(p)(q); // Disjunction
const eq = (p) => (q) => p(q)(not(q)); // Equal

const x = T;
const y = F;

console.log(not(x)); // !x
console.log(eq(x)(y)); // x == y
console.log(or(eq(not(x))(y))(and(y)(x))); // !x == y || (y && x)

module.exports = { T, F, not, and, or, eq };
