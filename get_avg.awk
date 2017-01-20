#!/usr/bin/awk -f

{print $0}

/^\[.*s.*us/ {
	us = ($4 * 1000000) + $6
	total[$2] = total[$2] + us
	count[$2]++
}

END {
	print "================\naverages:"

	for (test in total) {
		if (test[total] > max)
			max = test[total]
	}

	OFS = "\t"
	for (test in total) {
		avg = total[test]/count[test]
		s = avg / 1000000
		us = avg % 1000000
		speedup = max / total[test]
		print test, s "s", "speedup: " speedup
	}
}
