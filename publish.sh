flutter build web
cd publish
rm -rf public/
mkdir public
cd ..
cp -r build/web/* publish/public/
cd publish
firebase deploy
cd ..