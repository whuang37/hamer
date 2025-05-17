#!/bin/bash

ROOT_DIR="$1"
OUTPUT_ROOT="$1"

# File pattern to detect images
IMAGE_EXTENSIONS="jpg|jpeg|png|bmp|tif|tiff"

# Walk two levels deep
find "$ROOT_DIR" -mindepth 2 -maxdepth 2 -type d | while read -r folder; do
    # Check if folder contains at least one image
    if find "$folder" -maxdepth 1 -type f | grep -Ei "\.($IMAGE_EXTENSIONS)$" > /dev/null; then
        echo "Processing folder: $folder"

        # Compute relative path
        rel_path="${folder#$ROOT_DIR/}"

        # Create corresponding output folder
        output_folder="${ROOT_DIR}/${rel_path}_preds"
        # mkdir -p "$output_folder"
        # Run the processing program
        CUDA_VISIBLE_DEVICES=0 python inference.py --img_folder "$folder" --out_folder "$output_folder" --batch_size 36
    fi
done