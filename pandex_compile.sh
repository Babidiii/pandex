#!/usr/bin/env sh

build_dir="./build"
src_dir="./src"
main="report.md"

find "${src_dir}" -name "*.md" | entr pandoc --highlight-style=breezedark --columns=50 --toc --dpi=300 \
	-V linkcolor:blue -V mainfont="DejaVu Serif" -V monofont="DejaVu Sans Mono" --include-in-header \
	 ./resources/header.tex --pdf-engine=pdflatex "${src_dir}/${main}" -o "${build_dir}/${main%.*}.pdf"


