cut -d "	" -f 1,4 $1 | grep -E "/products/...\.html" | sort | uniq
