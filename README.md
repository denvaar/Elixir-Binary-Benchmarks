## Succinct Data Structures

Space and time are two control nobs that we use when writing computer programs.

An algorithm can be designed to execute quickly at the cost of more memory usage, or vice versa. We desire both "quick" and "small", but it's a challenge to have both. Data structures are often picked mainly for their runtime performance characteristics, with less attention to space complexity.

Of course it's true that data may be compressed down to a smaller size, but then it is essentially "frozen", or unavailable to use without bringing it back to the original form.

Succinct data structures are all about minimizing space complexity while still maintaining the same time complexity of their non-succinct counter parts. To me this seems like magic, and that's what has driven me to try and understand more.

Compression vs fast query trade off

## Classifying Smallness

Minimizing space complexity means that we think in terms of bits, rather than bytes and words. When it comes to Succinct Data Structures, there are three categories which are commonly used to classify their smallness:

1. Implicit, meaning that the data structure is represented in the most optimal amount of bits, plus some constant.

2. Succinct, meaning that the data structure is represented in the most optimal amount of bits (call it Z bits), plus an additional amount of bits that always diminishes with respect to Z.

3. Compact, meaning that the data structure is represented in an amount of bits that grows at the same rate or slower than

## Some Examples

I'm going to elaborate on some of the examples from the [Wikipedia]() page to the best of my knowledge.

A null-terminated string, as seen in C, can be thought of as an implicit data structure. The length of the character array grows proportionally to the length of the string, plus one (the null character). It's always plus one, and the amount of space to represent the null character is constant, no matter how many characters you have.

A sorted array is another example of an implicit data structure. The data itself is all that is stored, but it is ordered/arranged in a clever way that allows for some efficient queries (eg. _What's the minimum number in the set?_).

A heap is another example of an implicit data structure, because all that is needed is to have the data arranged in a certain order. There is no additional space needed.

The null-terminated string doesn't give you much advantage in figuring out its length. You need to count up each character until you reach the end to figure that out. If this is a thing you want to do more efficiently, you could store the length alongside the string itself, and now the string is considered succinct. That's because the amount of bits needed to store the length now increases logarithmically as the length increases.

For example, assume each character in the string is represented using a number from 0..255. That means 8 bits are required to represent each character. The integers to represent each character are bounded between 0 and 255, but not so with the integer needed to store the length.

```
sample string                     additional bits to represent length
--------------------              -----------------------------------
a (8 bits)                        1
ab (16 bits)                      2
abc (24 bits)                     2
abcd (32 bits)                    3
abcde (40 bits)                   3
abcdef (48 bits)                  3
... length n (n * 8 bits )        ⌊log₂n⌋ + 1

```

The important detail about being "succinct" is that the additional bits required grows at a rate that is strictly less than `n` (little-o of `n`). No matter how many bits it takes to represent your string, you can store some additional amount of bits which is guaranteed to be lesser, to represent the length. Realistically, though, one byte is the smallest unit of storage you can deal in, so theoretically this checks out, but little exceptions may be made when implementing these ideas, and I think that's OK.

Continuing with the string example, now imagine that you keep all strings (`"this"`, `"is"`, `"a"`, `"sample"`, `"string"`) as one continuous sequence without any delimiters. To know the length of each string, you could keep an auxiliary sequence along side of it.

```
thisisasamplestring
```

## LOUDS Encoding of Trees

## Jacobson's Rank

Bitvectors are commonly used

