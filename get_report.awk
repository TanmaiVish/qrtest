#!/usr/bin/awk -f

BEGIN {
	FS="\\[|]"
}

/test:/ {
	# start of new record
	# print last record
	print_record()

	# reset for this record
	delete quirc_result
	delete zbar_result
	thumb_path = ""
	test_id = $2
}

/thumb image:/ {
	thumb_path = $2
}

/quirc / {
	quirc_result[i++] = $0
}

/DECODE/ {
	quirc_result[i++] = "quirc " $0
}

/zbar / {
	zbar_result[j++] = $0
}

END {
	print_record()
}

function print_record()
{
	print test_id
	print thumb_path
	for (e in zbar_result)
		print zbar_result[e]
	for (e in quirc_result)
		print quirc_result[e]

}
