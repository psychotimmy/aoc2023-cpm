# aoc2023-cpm
Advent of Code 2023 - Turbo Pascal 3.01A and FTL Modula-2 1.30 under CP/M 2.2

Some examples from Advent of Code 2023 written in Turbo Pascal 3.01A and FTL Modula-2 1.30 under CP/M 2.2. 

Converted from my original solutions written using Free Pascal on a Raspberry Pi.

Unless stated, the Turbo Pascal solutions require my Pascal Big Integer library - BIGILIB.PAS - which can
be found here: https://github.com/psychotimmy/PascalBigIntegers

As per the advent of code rules, the sample and puzzle data are not included in 
this repository. They are available here: https://adventofcode.com/2023

In Turbo Pascal, use the COM compilation option to create day[number]-[part].com executables.

In FTL Modula-2, compile from ME (or use M2 directly on the .mod), link with ML day[number]-[part] /D to create a .com executable.

Input data file names are expected to be of the form: day[number]in.txt

Benchmarks run on an RC2040 (a RC2014 emulator) with the version of BIGILIB.PAS
current at the time. Performance enhancements to this library are ongoing!

Day1-1.pas - runs in 18 seconds using the puzzle data.

Day1-1.mod - runs in 10 seconds using the puzzle data.

Day1-2.pas - runs in 47 seconds using the puzzle data.

Day1-2.mod - runs in 4 minutes 15 seconds using the puzzle data, even with a slightly more efficient algorithm than the
Turbo Pascal version ... 

Day2-1.pas - runs in 7 seconds using the puzzle data.

Day2-2.pas - runs in 11 seconds using the puzzle data.

Day3-1.pas - runs in 40 seconds using the puzzle data.

Day4-1.pas - runs in 17 seconds using the puzzle data. This does not require BIGILIB.PAS.

Day4-2.pas - runs in 37 seconds using the puzzle data.

Day6-1.pas - runs in 4 seconds using the puzzle data.

Day6-2.pas - runs in 2 minutes 37 seconds using the puzzle data. The main bottleneck is the integer square root function in BIGILIB.PAS.

Day7-1.pas - runs in 4 minutes 12 seconds using the puzzle data. Replacing the insertion sort with a better algorithm will improve execution time.

Day7-2.pas - runs in 4 minutes 12 seconds using the puzzle data. As for part 1, replacing the insertion sort with a better algorithm will improve execution time.

Day8-1.pas - runs in 2 minutes using the puzzle data. The data structure used to store and search the map is sub-optimal! This does not require BIGILIB.PAS.

Day9-1.pas - runs in 4 minutes 47 seconds using the puzzle data.

Day9-2.pas - runs in 4 minutes 34 seconds using the puzzle data.

Day11-1.pas - runs in 14 minutes 56 seconds using the puzzle data.

Day11-2.pas - runs in 1 hours 38 minutes using the puzzle data. The main difference between the two parts of day 11 is the speed of BIGILIB.PAS.

Day13-1.pas - runs in 26 seconds using the puzzle data.

Day13-2.pas - runs in 16 minutes 42 seconds using the puzzle data.

Day15-1.pas - runs in 57 seconds using the puzzle data.

Day16-1.pas - runs in 27 seconds (including the time to print the final grid) using the puzzle data. This does not require BIGILIB.PAS.

Day16-2.pas - runs in 1 hour 22 minutes (440 repetitions of part 1). This does not require BIGILIB.PAS.

Day18-1.pas - runs in 3 minutes 17 seconds using the puzzle data. 

Day21-1.pas - runs in 7 minutes 30 seconds using the puzzle data. This does not require BIGILIB.PAS.
