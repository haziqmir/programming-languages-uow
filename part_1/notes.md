# Notes

## Exercises

syntax, type-checking rules, and evaluation rules for less-than expressions
syntax: e1 < e2 where e1 and e2 and subexpressions of the
type: int|float|string < int|float|string and type(e1) = type(e2)

## Records

these include record values and record types
record values have a field name and a value
{f1 = v1, ..., fn = vn}
record types have a field name and the type
{f1 : t1, ..., fn : tn}

Build records with {f1 = e1, ..., fn = en} where ei is an expression and fi is
the field name

Access record pieces with #field_name e 

very similar to tuples
{a=1,b=2,c=3} is sort of like (1,2,3)
you refer to things by position with tuples or by field name with records

There are hybrid approaches, for instance in Java, where function arguments are
referred to by position by the caller while the callee uses variables

Tuples are just records where field names are 1, 2, ..., n, etc.
If a record were to be created where field names were one, three, two, it would
be turned into a tuple 
{1=2, 2=7, 3=9} is just (2,7,9) but it's terrible syntax and harder to read
(e1, ..., en) is another way of writing {1=e1, ..., n=en}
t1 * ... * tn is another way of writing {1:t1, ..., n:tn}

## Datatype bindings

Third type of binding after let and fun (i.e. another way to instantiate a
thing). 
datatype t = Cons(of t (* ... * tn)) (| Consof ...)
Cons is a constructor, i.e. a type of function that given values of args return
something of type t

As an example:

```
datatype Number = Int of int
                | Real of real
                | Zero
                | Infinity
```

Number is added to the environment
adds constructors to the environment: Int, Float, Real, Zero, Infinity

Int: int -> Number
Real: real -> Number
Zero -> Number
Infinity -> Number

The type of a value defined using datatypes for instance an x = Real 3.5 would
be `Real 3.5 : Number`

What kind of a Number do we have? The underlying numbre is 3.5. 

This is very similar to 'tagged unions' in other languages

I could define a Number of type Zero so I won't be able to access it directly
somehow.

A value of type Number is made from _one of_ the constructors. The value is made
up of a "tag" for the constructor (e.g. Int) and the data (e.g. 3).

Two facets of accessing datatype values:
1. Check what constructor made it (what is the variant) e.g. isSome, null
2. Extract the data e.g. valOf, hd, tl

## Case expressions
Accessing a one-of value with a case expression and pattern-matching.

This is what pattern-matching looks like:
case _ of Constructor => ... | Constructor x => ...


