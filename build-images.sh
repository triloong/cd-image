#!/bin/bash
set -u
set -e
set -o pipefail

pubdir=$PWD/public
mkdir -p "$pubdir"
stagingdir=$PWD/staging
mkdir -p "$stagingdir"

version="13.3.0"
tmpdir="$(mktemp -d -p "$stagingdir")"

variants=(netinst dvd)

for v in "${variants[@]}"; do
	./build-image.sh "$v" "$tmpdir"
done

for i in "$tmpdir"/*/jigdo-*; do
	jd_dir=$i
	iso_dir=$(echo "$jd_dir" | sed 's,/jigdo-,/iso-,')
	/usr/share/debian-cd/tools/imagesums "$jd_dir" ""
	for f in "$jd_dir/"*SUMS*; do
		out="$iso_dir/$(basename -- "$f")"
		grep '\.iso' "$f" > "$out"
	done
done

if [ -d "$pubdir/$version" ]; then
	for ext in $(seq 1 10); do
		if [ ! -d "$pubdir/$version.$ext" ]; then
			mv "$pubdir/$version" "$pubdir/$version.$ext"
			break
		fi
	done
fi

[ ! -d "$pubdir/$version" ]

chmod 755 "$tmpdir"
mv "$tmpdir" "$pubdir/$version"
ln -sfT "$version" "$pubdir/current"
