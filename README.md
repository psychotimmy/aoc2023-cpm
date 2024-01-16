# aoc2023-cpm
Advent of Code 2023 - Turbo Pascal 3.01A under CP/M 2.2.

Some examples from Advent of Code 2023 written in Turbo Pascal 3.01A under CP/M 2.2

Most require my Pascal Big Integer library - BIGILIB.PAS - which can
be found here: https://github.com/psychotimmy/PascalBigIntegers

As per the advent of code rules, the sample and puzzle data are not included in 
this repository. They are available here: https://adventofcode.com/2023

In turbo pascal, use the COM compilation option to create day[number]-[part].com executables.

Input data file names are expected to be of the form: day[number]in.txt

Benchmarks run on an RC2040 (a RC2014 emulator) with the version of BIGILIB.PAS
current at the time. Performance enhancements to this library are ongoing!

Day1-1.pas - runs in 18 seconds using the puzzle data.

Day1-2.pas - runs in 47 seconds using the puzzle data.

Day4-1.pas - runs in 17 seconds using the puzzle data. This does not require BIGILIB.PAS.

Day4-2.pas - runs in 37 seconds using the puzzle data.

Day7-1.pas - runs in 4 minutes 12 seconds using the puzzle data. Replacing the insertion sort with a better algorithm will improve execution time.

Day7-2.pas - runs in 4 minutes 12 seconds using the puzzle data. As for part 1, replacing the insertion sort with a better algorithm will improve execution time.

Day9-1.pas - runs in 4 minutes 47 seconds using the puzzle data.

Day9-2.pas - runs in 4 minutes 34 seconds using the puzzle data.

Day16-1.pas - runs in 27 seconds (including the time to print the final grid) using the puzzle data. This does not require BIGILIB.PAS.

Day16-2.pas - runs in 1 hour 22 minutes (440 repetitions of part 1). This does not require BIGILIB.PAS.

Day18-1.pas - runs in 3 minutes 17 seconds using the puzzle data. 
