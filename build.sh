#!/bin/bash

# Define directory locations
root_dir=$(pwd)
page_dir="src/pages"
layout_file="src/templates/layout.html"
navlink_file="src/templates/nav-link.html"
tmp_dir="src/tmp"
tmp_navlink="src/tmp/navlink_tmp.html"
output_dir="docs"
cv_dir="src/cv"
cv_pdf_path="src/cv/output/cv_bgetraer.pdf"

# define pages
pages=(index.html
    research.html
	 cv.html
    contact.html
)
names=(Home
	Research
	CV
	Contact
)

# Create output directory
mkdir -p "${tmp_dir}"
mkdir -p "${output_dir}"

# Current year
export CURRENT_YEAR=$(date +%Y)

# Compile CV pdf
cd $cv_dir
echo -n "Compiling cv in lualatex..."
./cv_compile.sh > output/cv_compile.log
echo " Done"
cd $root_dir

# Compile CV HTML
echo -n "Parsing cv to html..."
luatex $cv_dir/cv_html.lua $cv_dir/cv_data.json > $page_dir/cv.html
echo " Done"

# Compile each page into output directory
for ((i=0; i<${#pages[@]}; i++)); do
	page=${pages[$i]};
	name=${names[$i]};
	filename=$(basename "$page")
	output_path="${output_dir}/${filename}"

	export PAGE_TITLE=$name
	export PAGE_CONTENT=$(cat "$page_dir/$page")

	> $tmp_navlink
	for ((j=0; j<${#pages[@]}; j++)); do
		p=${pages[$j]};
		n=${names[$j]};
		export PAGE_TARGET=${pages[$j]};
		export PAGE_NAME=${names[$j]};
		export PAGE_CLASS
		if [ $i == $j ]; then
			PAGE_CLASS="active"
		else
			PAGE_CLASS="inactive"
		fi

		envsubst '$PAGE_CLASS $PAGE_TARGET $PAGE_NAME' < $navlink_file >> $tmp_navlink
	done
	export NAV_LINKS=$(cat $tmp_navlink)

	envsubst '$PAGE_TITLE $NAV_LINKS $PAGE_CONTENT $CURRENT_YEAR' < ${layout_file} > ${output_path}

	echo "Compiled: ${output_path}"
done

# Copy CSS and Fonts folders into docs/
mkdir -p docs/fonts && cp -R src/fonts/. docs/fonts/
mkdir -p docs/css && cp -R src/css/. docs/css/
mkdir -p docs/images && cp -R src/images/. docs/images/
cp -rf $cv_pdf_path docs/

echo "Build complete!"
