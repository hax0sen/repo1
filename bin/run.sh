#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Define variables
## Image to be scanned.
IMAGE_NAME="debian:latest"
OUTPUT_DIR="/var/shared/workspace/tmp"
SYFT_JSON_FILE="$OUTPUT_DIR/syft-sbom.json"
SYFT_TABLE_FILE="$OUTPUT_DIR/syft-sbom-table.txt"
GRYPE_JSON_FILE="$OUTPUT_DIR/grype-vulnerability-report.json"
GRYPE_TABLE_FILE="$OUTPUT_DIR/grype-vulnerability-report-table.txt"
SYFT_CONTAINER="anchore/syft:latest"   # Syft container for generating SBOM
GRYPE_CONTAINER="anchore/grype:latest"  # Grype container for vulnerability scanning

# Step 2: Create the output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Creating output directory..."
  mkdir -p $OUTPUT_DIR
fi

# Step 3: Pull the latest image (optional)
echo "Pulling the latest Docker image..."
docker pull $IMAGE_NAME

# Step 4: Generate SBOM with Syft (multiple formats)
echo "Generating SBOM using Syft..."

# Generate JSON SBOM, used for automation and analysis.
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$OUTPUT_DIR":/output \
  $SYFT_CONTAINER $IMAGE_NAME -o json > "$SYFT_JSON_FILE"

# Generate table-based SBOM, used to read file, list of installed packages etc
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$OUTPUT_DIR":/output \
  $SYFT_CONTAINER $IMAGE_NAME -o table > "$SYFT_TABLE_FILE"

echo "SBOM generation completed. Results saved in multiple formats."

# Step 5: Run Grype to scan for vulnerabilities (multiple formats)
echo "Running Grype vulnerability scan..."

# Generate JSON vulnerability report, CVEs in json format, used for automation and analysis.
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$OUTPUT_DIR":/output \
  $GRYPE_CONTAINER $IMAGE_NAME -o json > "$GRYPE_JSON_FILE"

# Generate table-based vulnerability report, easy to read, list of CVEs.
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$OUTPUT_DIR":/output \
  $GRYPE_CONTAINER $IMAGE_NAME -o table > "$GRYPE_TABLE_FILE"

echo "Vulnerability scan completed. Results saved in multiple formats."

# Step 6: (Optional) Clean up any temporary containers
echo "Done."
