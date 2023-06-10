#!/bin/bash

# Function to count the lines of Dart code in a given directory
count_dart_lines() {
    if [ -d "$2" ]; then
        echo "> $1:"
        find $2 -name "*.dart" -type f -exec wc -l {} + | grep total
    fi
}

# Return to the parent directory
cd ..

# Output total lines of Dart code for the main app and its tests
count_dart_lines "# Main App # lib" ./lib
count_dart_lines "Main app tests" ./test

# Output total lines of Dart code for each module
for module in ./app_modules/* ; do
    if [ -d "$module" ]; then
        count_dart_lines "# $(basename $module) # module" $module/lib
    fi
done

# Output total lines of Dart code for each package and its associated tests/examples
for package in ./packages/* ; do
    if [ -d "$package" ]; then
        count_dart_lines "# $(basename $package) # lib" $package/lib
        count_dart_lines "$(basename $package) tests" $package/test
        count_dart_lines "$(basename $package) examples" $package/example
    fi
done

# Output total lines of Dart code across all Dart files
echo "#################### Total lines of Dart code ################"
find . -name "*.dart" -type f -exec wc -l {} + | grep total
