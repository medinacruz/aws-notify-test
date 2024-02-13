#/bin/bash

# Define paths
LAMBDA_DIR="lambda/function"  # path to the lambda function direcotry
BUILD_DIR="build"             # path to the directory where the ZIP should be placed    
ZIP_FILE="function.zip"       # name of the ZIP file

# Navigate to the lambdda function directory
cd "$LAMBDA_DIR"

# Install dependencies (if any) in a directory that will be packaged
#pip install -r requirements.txt -t .

# Create the ZIP file with Lambda function and dependencies
zip -r "$ZIP_FILE" .

# Move the ZIP file to the build direcotry
mv "$ZIP_FILE" "../../$BUILD_DIR/"

echo "Lambda function package created and moved to $BUILD_DIR"
