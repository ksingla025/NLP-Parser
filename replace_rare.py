'''
@author: Linxi Fan (lf2422)
Replace all the low-frequency words by '_RARE_'
'''
import json, sys

count = {}

# Count only terminals
def countWords(tree):
    global count
    for i in range(len(tree)):
        item = tree[i]
        if isinstance(item, list):
            countWords(item)
        elif i == len(tree) - 1: # the last str in the tree is a terminal
            if item in count:
                count[item] += 1
            else:
                count[item] = 1

treebank = []

# Process the training data, write to counts and stores the treebank
for tree in open(sys.argv[1], 'r'):
    tree = json.loads(tree)
    countWords(tree)
    treebank.append(tree)

# Replaces all rare words (count < 5) with the tag _RARE_
def rarify(tree):
    for i in range(len(tree)):
        if isinstance(tree[i], list):
            rarify(tree[i])
        # The last item in the tree would be a terminal word
        elif i == len(tree) - 1 and count[tree[i]] < 5:
                tree[i] = '_RARE_'

# Write back to JSON
for tree in treebank:
    rarify(tree)
    print(json.dumps(tree))