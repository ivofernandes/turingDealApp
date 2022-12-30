cd ..
echo "# All modules:"
find . -name "*.dart" -type f|xargs wc -l | grep total

echo "> # back_test_engine:"
find ./lib/back_test_engine -name "*.dart" -type f|xargs wc -l | grep total

echo "> # big_picture:"
find ./lib/big_picture -name "*.dart" -type f|xargs wc -l | grep total

echo "> # home:"
find ./lib/home -name "*.dart" -type f|xargs wc -l | grep total

echo "> # Settings:"
find ./lib/settings -name "*.dart" -type f|xargs wc -l | grep total

echo "> # shared:"
find ./lib/shared -name "*.dart" -type f|xargs wc -l | grep total

echo "> # ticker:"
find ./lib/ticker -name "*.dart" -type f|xargs wc -l | grep total
