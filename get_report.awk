#!/usr/bin/awk -f

BEGIN {
	FS="\\[|]"
}

/test:/ {
	# start of new record
	test_id = $2

	# print last record
	if (last_id)
		print_record()

	if (last_id != test_id) {
		print_test_header(test_id)
		last_id = test_id
	}

	# reset for this record
	delete quirc_result
	delete zbar_result
	delete timing
	thumb_path = ""
	test_string = ""

	test_level = $4
}

/test string:/ {
	test_string = $2
}

/thumb image:/ {
	thumb_path = $2
}

/quirc / {
	split($0, a, " ")
	if (a[2] == test_string)
		quirc_result[j++] = "PASS"
	else
		quirc_result[j++] = $0
}

/DECODE/ {
	quirc_result[i++] = "quirc " $0
}

/zbar / {
	split($0, a, " ")
	if (a[2] == test_string)
		zbar_result[j++] = "PASS"
	else
		bar_result[j++] = $0
}

/^\[/ {
	timing[l++] = $0
}

END {
	print_record()
}

function print_record()
{
	print "\n## " test_level
	print "\n!["test_id" "test_level"]("thumb_path")"

	print "\nquirc output:\n"
	for (e in quirc_result)
		print "    " quirc_result[e]
	if (length(quirc_result) == 0)
		print "    FAIL"

	print "\nZbar output:\n"
	for (e in zbar_result)
		print "    " zbar_result[e]
	if (length(zbar_result) == 0)
		print "    FAIL"

	print "\nTiming:\n"
	for (e in timing)
		print "    " timing[e]

}

function print_test_header(id)
{
	print "\n"
	print "# " id
}
