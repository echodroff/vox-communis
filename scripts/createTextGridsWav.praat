dir$ = "/Users/eleanor/Documents/CommonVoice/data/sorbian_upper15/"
output_folder$ = "validated/"
dir_filetype$ = dir$ + output_folder$
tsv_file$ = "validated_spkr.tsv"
Read Table from tab-separated file: dir$ + tsv_file$
Rename: "files"

nRows = Get number of rows
for i from 1 to nRows
	selectObject: "Table files"
	file$ = Get value: i, "path"
	orig_utt$ = file$ - ".mp3"
	new_utt$ = Get value: i, "new_utt"
	sentence$ = Get value: i, "sentence"
	speakerID$ = Get value: i, "speaker_id"

	# READ FROM MP3 AND SAVE TO WAV
	Read from file: dir$ + "clips/" + file$
	nowarn Save as WAV file: dir_filetype$ + new_utt$ + ".wav"

	dur = Get total duration
	# create TextGrid with sentence and save
	To TextGrid: speakerID$, ""
	Insert boundary: 1, 0.05
	Insert boundary: 1, dur - 0.05
	Set interval text: 1, 2, sentence$
	Save as text file: dir_filetype$ + new_utt$ + ".TextGrid"

	select all
	minusObject: "Table files"
	Remove
endfor

