# vox-communis
Resources to create acoustic models and TextGrids with word- and phone alignments and to extract phonetic measures, derived from the Common Voice Corpus. Derived resources (acoustic models, lexicons, TextGrids, and formants) can be found at https://osf.io/t957v/. 

## Common Voice Processing Instructions
**Prep files and generate lexicon, acoustic model, forced alignment**

### Prep wav files and TextGrids

1.	Download language from Common Voice

2.	Get speaker IDs to put on TextGrids for speaker adaptation. This operates on validated.tsv included in the download. 

Run remap_spkrs.py

```python
python3 remap_spkrs.py CommonVoice/languages/indonesian/validated.tsv CommonVoice/languages/indonesian/validated_spkr.tsv
```

3.	Create validated folder within downloaded Common Voice folder to store TextGrids
 
4.	Create TextGrids based on the transcript in validated_spkr.tsv generated in Step 2. Optionally generate wav files with same filename.

Run processCommonVoice_v2.praat or createTextGridsWav.praat

Technically, we do not need to create wav files (MFA can handle mp3), but MFA does require that the TextGrid and audio have the same filename. MFA requires that speaker information is either the tier name or in the prefix of the filename. If it’s the prefix of the filename, this must be specified in the MFA command. For the purposes of the class, it was easiest to just have them run the createTextGridsWav.praat script which generated only the validated files and ensured that the TextGrid and audio file had the same name. 

Or, just generate TextGrids with speaker ID in the tier name, and only based on validated files, then run the following to move the corresponding wav files into the same folder and in the shell, run: 

```console
cut -f2 validated.tsv | tail -n +2 > mp3_paths.tsv

for file in $(<list.txt); do cp "$file" new_folder; done

for file in $(<mp3_paths.tsv); do cp clips/"$file" validated/; done
```
### Prep lexicon

5.	Extract transcripts from validated.tsv and get each word on its own line

In the shell, run:

```console
cat validated.tsv | cut  -f3 | sed '1d' | tr "[\,\.]" " " | tr " " "\n" | sed 's/^[[:punct:]]*//' | sed 's/[[:punct:]]*$//' |  tr '[:upper:]' '[:lower:]' | sort | uniq > indonesian.txt
```

6.	Run epitran or submit to XPF

```python
python3 run_epitran.py indonesian.txt indonesian_lexicon.txt ind-Latn
```

7.	If XPF, create custom Python script to separate phones with spaces
   
See for example:

```python
python3 ukrainian.py xpf_output_ukrainian.txt
```

### Run Montreal Forced Aligner

8.	Activate the aligner

```console
conda activate aligner
```

9.	Put lexicon in Documents/MFA/pretrained_models/dictionary/

10.	Validate corpus

```console
mfa validate ~/Documents/CommonVoice/languages/indonesian/validated indonesian_lexicon  --ignore_acoustics --clean
```

11.	Train acoustic model using corpus 

```console
mfa train --clean ~/Documents/CommonVoice/languages/indonesian/validated indonesian_lexicon ~/Documents/CommonVoice/languages/indonesian/indonesian_cv10
```
12.	Put new acoustic model in Documents/MFA/pretrained_models/acoustic/ if not there already

13.	Align corpus using new acoustic model
    
```console
mfa align ~/Documents/CommonVoice/languages/indonesian/validated indonesian_lexicon indonesian_cv10 ~/Documents/CommonVoice/languages/indonesian/output/
```

## Notes about the 2021 analysis
The formant data we used in the VoxCommunis 2021 LREC paper is in vox-communis-2021-analysis/data/formants_narrow/. These files contain the average F1 and F2 for each speaker and "narrowly defined" vowel in the language. A "narrowly defined" vowel means that we retained all vowels but collapsed across tones. The set of broadly defined vowels in vox-communis-2021-analysis/data/formants_broad means that we collapsed vowels across tone, length, and nasality. Each speaker was classified as having a high or low formant extraction setting based on the lesser Mahalonobis-distance of their overall F1/F2 average to the overall language-specific F1 and F2 means. More information about speaker formant setting assignment can be found in the outliers repo from Emily P. Ahn here: https://github.com/emilyahn/outliers. 
