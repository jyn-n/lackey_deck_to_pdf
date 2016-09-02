#!/bin/sh

[[ $# -gt 0 ]] || exit 1

input=$1
shift

output=out.pdf
[[ $# -gt 0 ]] && output=$1 && shift

image_path="images\/"
output_path="deck_images/"

mkdir ${output_path}$output
n=0

tmp=$(mktemp)

sed -n 's/.*<name id="\([^"]*\)".*/\1.jpg/p' < $input | sed 's/,cardbackcrypt//' | sed "s/^/ $image_path/" > $tmp
awk 'BEGIN {ORS=""} ((NR-1)%9){print} !((NR-1)%9){print "\n"; print} END {print "\n"}' $tmp \
	| sed '1d' | while read l; do
	montage $l -tile 3x3 -geometry 1462x+0+0 -font DejaVu-Sans-Mono ${output_path}${output}/$n.jpg
	n=$[$n+1]
done
rm $tmp

