% demo use of array_add.cpp function addtwomatrices

A = [1,2;3,4];
B = [5,6;7,8];

C = addtwomatrices(A, B);

assert(isequal(C, A+B), "Error: C does not match A+B")

disp("OK: C == A+B")
