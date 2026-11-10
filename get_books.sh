#!/bin/bash
# Copy the books from S3 to HPC and write book_list.txt
# Usage: bash get_books.sh BUCKET BOOK_DIR
set -euo pipefail

# The two arguments: name them like in share_book.sh
BUCKET="$1"
BOOK_DIR="$2"

# Create the book directory if it doesn't exist
mkdir -p "$BOOK_DIR"

# Copy only the .txt files from the bucket
aws s3 cp "s3://$BUCKET" "$BOOK_DIR" --recursive --exclude "*" --include "*.txt"

# Turn BOOK_DIR into an absolute path
BOOK_DIR="$(realpath "$BOOK_DIR")"

# Write the header line (starts a new file)
echo "File path" > book_list.txt

# Append one absolute path per book, sorted
find "$BOOK_DIR" -name "*.txt" | sort >> book_list.txt

# Print how many books were listed (lines minus the header)
COUNT=$(( $(wc -l < book_list.txt) - 1 ))
echo "Wrote $COUNT book files to book_list.txt"
