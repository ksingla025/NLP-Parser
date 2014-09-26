#!/bin/bash
echo Question 5: CKY algorithm
echo

if [ ! -f counts_rare.dat ] ; then
    python replace_rare.py parse_train.dat > parse_train_rare.dat
    python count_cfg_freq.py parse_train_rare.dat > counts_rare.dat
    echo Replace complete: parse_train_rare.dat  counts_rare.dat
    echo
fi

echo Generating CKY parser results to parse.out ...
python cky_parser.py counts_rare.dat parse_dev.dat > parse.out

echo
echo Generating the performance report to eval.txt ...
python eval_parser.py parse_dev.key parse.out > eval.txt

echo
echo Performance report:
cat eval.txt

echo
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Question 6: Vertical Markovization
echo
if [ ! -f counts_rare_vert.dat ] ; then
    python replace_rare.py parse_train_vert.dat > parse_train_vert_rare.dat
    python count_cfg_freq.py parse_train_vert_rare.dat > counts_rare_vert.dat
    echo Replace complete: parse_train_rare_vert.dat  counts_rare_vert.dat
    echo
fi

echo Generating CKY parser results to parse_vert.out ...
python cky_parser.py counts_rare_vert.dat parse_dev.dat > parse_vert.out

echo
echo Generating the performance report to eval_vert.txt ...
python eval_parser.py parse_dev.key parse_vert.out > eval_vert.txt

echo
echo Performance report:
cat eval_vert.txt
