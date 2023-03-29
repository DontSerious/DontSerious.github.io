---
title: Deciding which Type to Use
date: 2023-02-26 10:42:33
updated: 2023-02-26 10:42:33
categories:
- BackEnd
tags:
- cpp
---

1. **Use an unsigned type when you know that the vales cannot be negative.**
2. **Use `int` for integer arithmetic,** `short` is usually too small and, in practice, `long` often has the same size as `int`. If your data values are larger than the minimum guaranteed size as `int`, then use `long long`.  
3. **Do not use plain `char` or `bool` in arithmetic expressions.** Use them *only* to hold characters or truth values. Computations using `char` are especially problematic because `char` is `signed` on some machines and `unsigned` on others. If you need a tiny integer, explicitly specify either `signed char` or `unsigned char`.
4. **Use `double` for floating-point computations;** `float` usually does not have enough precision, and the cost of double-precision calculations versus single-precision is negligible. In fact, on some machines, double-precision operations are faster than single. The precision offered by `long double` usually is unnecessary and often entails considerable run-time cost.