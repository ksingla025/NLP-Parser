Linxi Fan
Parser

The parser is implemented entirely in python 2. Testing on CUNIX passes.
The source codes are heavily commented.
Note: if CUNIX says "/bin/bash: bad interpreter: Permission denied", please change the permission:
$  chmod 744 *.sh

=============================================================
One-liner:
$  ./run.sh

There're 5 source files, including this README:

- run.sh
	Shell script that runs all the executable scripts for Question 4, 5, and 6
	Requires 'counts_rare.dat' and 'counts_rare_vert.dat' generated by 'replace_rare.py'
	Auto-detects counts_*.dat and would run 'replace_rare.sh' if the required files don't exist.
	Then runs 'cky_parser.py' on the counts_* data and parse_dev.dat
	For Q5, the parsed tree in JSON format would be stored to 'parse.out'
	For Q6, the parsed tree in JSON format would be stored to 'parse_vert.out'
	The shell script would also print the evaluation report to console.
	For Q5, the evaluation matrix would be stored to 'eval.txt'
	For Q6, the evaluation matrix would be stored to 'eval_vert.txt'

- replace_rare.py
	Replace low-frequency words by '_RARE_'
	Usage: "python replace_rare.py [train].dat > counts_*.dat"
	For Q5, generates 'parse_train_rare.dat'
	For Q6, generates 'parse_train_vert_rare.dat'
	Running the script 'run.sh' would be sufficient.

- cky_parser.py
	Main implementation of the CKY algorithm. Parses the sentence and stores to JSON format.
	Usage: "python cky_parser.py counts_*.dat parse_dev.dat > parse_*.out"
	Would print progress to console stderr and print JSON results to stdout.
	The source code is the same for Q5 and Q6.
	Running the script 'run.sh' would be sufficient.

- clean.sh
	Cleans up all the script-generated files.


Observations:
On my humble laptop, the CKY script runs at a speed of 10 sentences per 3 seconds.
Question 5's performance score is 71.4
Question 6's performance score is 74.2

=============================================================
Q5 & Q6: compare & contrast

The script detects "." (end of sentence) and CONJ ("and") very well, both with or without markovization .

With vertical markovization, however, the script has a significant improvement on NP+DET (0.78 to 0.94),
SBAR (0.09 to 0.66) and VP (0.55 to 0.66). The most significant one is SBAR recognition, which makes sense
because vertical markovization captures the semantic meaning of a subordinate clause, with SBAR parent tag
passed on to the children words that build the clause.

On the other hand, the script with vertical markovization suffers a big drop on the precision of ADJ (0.82 to 0.69).

===========================================================
Q6 example:
The 27th sentence in the parse_dev.dat:
"Conversation was subdued as most patrons watched the latest market statistics on television."

This is the tree by Q5:
[S,
 [VP,
  [VERB, Conversation],
  [VP,
   [VERB, was],
   [VP,
    [VERB, subdued],
    [VP,
     [ADV, as],
     [VP,
      [ADV, most],
      [VP,
       [VERB, patrons],
       [VP,
        [VERB, watched],
        [NP,
         [DET, the],
         [NP,
          [ADJ, latest],
          [NP,
           [NP, [NOUN, market], [NOUN, statistics]],
           [PP, [ADP, on], [NP+NOUN, television]]]]]]]]]]]],
 [., .]]

This is the tree by Q6 (markovized):
[S,
 [VP,
  [VERB, Conversation],
  [VP,
   [VERB, was],
   [VP,
    [ADJP+ADJ, subdued],
    [SBAR,   # gets SBAR correctly here
     [ADP, as],
     [S,
      [NP, [ADJ, most], [NOUN, patrons]],
      [VP,
       [VERB, watched],
       [NP,
        [NP,
         [DET, the],
         [NP, [ADJ, latest], [NP, [NOUN, market], [NOUN, statistics]]]],
        [PP, [ADP, on], [NP+NOUN, television]]]]]]]]],
 [., .]]

 This is the golden tree in parse_dev.key:
 [S,
 [NP+NOUN, Conversation],
 [S,
  [VP,
   [VERB, was],
   [VP,
    [ADJP+ADJ, subdued],
    [SBAR,
     [ADP, as],
     [S,
      [NP, [ADJ, most], [NOUN, patrons]],
      [VP,
       [VERB, watched],
       [VP,
        [NP,
         [DET, the],
         [NP, [ADJ, latest], [NP, [NOUN, market], [NOUN, statistics]]]],
        [PP, [ADP, on], [NP+NOUN, television]]]]]]]],
  [., .]]]


Without markovization, the script totally misses the 'SBAR' subordinate clause starting with 'as', and produces
an F1-score of only 0.556.
With vertical markovization, however, the script takes into account that the as-clause belongs to a single
expansion rule led by SBAR, and thus gets the 'SBAR' correctly and produces an F1-score of 0.889, which
is a huge enhancement.
