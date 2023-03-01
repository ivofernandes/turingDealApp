cd ..
echo "# Main app:"
find ./lib -name "*.dart" -type f|xargs wc -l | grep total

echo "> # ticker_details:"
find ./app_modules/ticker_details -name "*.dart" -type f|xargs wc -l | grep total

echo "> # backtest:"
find ./packages/backtest -name "*.dart" -type f|xargs wc -l | grep total

echo "> # td_ui:"
find ./packages/td_ui -name "*.dart" -type f|xargs wc -l | grep total

echo "> # ticker_search:"
find ./packages/ticker_search -name "*.dart" -type f|xargs wc -l | grep total

echo "> # stocks_portfolio:"
find ./packages/stocks_portfolio -name "*.dart" -type f|xargs wc -l | grep total