# Clean all projects
cd ..

function cleanProject {
  flutter clean
  rm -rf pubspec.lock

  # If has ios folder, clean ios pods
  cd ios || return
  rm -rf Pods
  rm -rf Podfile.lock
  cd ..
}


# Clean the main project
cleanProject

echo "Clean iOS pods for subprojects"
for subproject in packages/*
do
     echo "Remove pubspec.lock $subproject"
     cd "$subproject" || exit
     cleanProject
     cd ../..
     echo "For $subproject completed"
done

echo "All Done"
