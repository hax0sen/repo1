#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Define variables
IMAGE_NAME="python:alpine3.19"
OUTPUT_DIR="./output"
OUTPUT_FILE="$OUTPUT_DIR/scan-result.json"
SYFT_CONTAINER="anchore/syft:latest"  # The Syft container image

# Step 2: Create the output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Creating output directory..."
  mkdir -p $OUTPUT_DIR
fi

# Step 3: Pull the latest image (optional)
echo "Pulling the latest Docker image..."
docker pull $IMAGE_NAME

# Step 4: Run Syft scan using the Syft Docker container
echo "Running Syft scan on the image..."
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$OUTPUT_DIR":/output \
  $SYFT_CONTAINER $IMAGE_NAME -o json > "$OUTPUT_FILE"

echo "Scan completed. Results saved to $OUTPUT_FILE"

# Step 5: (Optional) Remove any temporary containers (cleanup is unnecessary if only scanning the image)
echo "Done."
