#!/usr/bin/python
# -*- coding: utf-8 -*-

#  format_lexicons
#  
#
#  Created by Eleanor Chodroff on Nov 7 2021.

import sys, codecs, re

file = 'XPF_UpperSorbian_translations.txt'
new_dict = codecs.open('sorbian_lexicon.txt', 'w', "utf-8")


f = codecs.open(file, 'r', "utf-8")
for line in f:
    col = line.split(',')
    orth = col[0]
    segs = col[1]	
    phon = ' '.join(segs)
    phon = re.sub(' ʲ','ʲ', phon)
    phon = re.sub('t ʃ','tʃ', phon)
    phon = re.sub('t s','ts', phon)
    phon = re.sub('d ʒ','dʒ', phon)
    if "@" not in phon:
    	new_dict.write(orth + '\t' + phon)