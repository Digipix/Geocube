#!/bin/sh

echo "Licenses:"
grep -c GNU *.[mh]  | grep -v 3$

echo
echo "DB_PREPARE / DB_FINISH:"
for fn in db*.m; do
	p=$(grep -c DB_PREPARE $fn)
	f=$(grep -c DB_FINISH $fn)
	if [ "$p" != "$f" ]; then
		echo $fn - $p / $f
	fi
done

echo
echo "Classes:"
grep -h @implementation *.m | sed -e 's/implementation/class/' -e 's/$/;/'| sort > /tmp/a
grep @class Geocube-Classes.h > /tmp/b
diff /tmp/[ab]

echo
echo "Spaces at the end:"
grep -n "[	 ]$" *.m *.h

echo
echo "Empty lines at the end:"
for i in *.m *.h; do if [ -z "$(tail -1 $i)" ]; then echo $i; fi; done

echo
