#!/bin/sh -l

####################################
###   Helper Functions Go Here   ###
####################################

# Check CCS project files exist at specified location
Check_CCS_Project_Files() {
    file1="$1/.project"
    file2="$1/.cproject"
    file3="$1/.ccsproject"

    if [ -e "$file1" ] && [ -e "$file2" ] && [ -e "$file3" ]
    then
      echo "CCS project files found"
    else 
      echo "CCS project files not found. Directory contents: "
      ls -l "$1"
      exit 1
    fi
}



####################################
### Main Action Code Starts Here ###
####################################
Check_CCS_Project_Files "$1"

echo import project into workspace
/opt/ti/ccs/eclipse/eclipse -noSplash -data "/home/build/workspace" -application com.ti.ccstudio.apps.projectImport -ccs.location "$1"

echo build project
set +e
output=$(/opt/ti/ccs/eclipse/eclipse -noSplash -data "/home/build/workspace" -application org.eclipse.cdt.managedbuilder.core.headlessbuild -build "$2"/"$3" 2>&1)
build_exit_code=$?
set -e
echo "$output"

# Check build command output to confirm that the correct configuration was built
if ! (echo "$output" | grep -q "Build of configuration $3"); then
  echo error: incorrect build configuration detected
  exit 1
fi

# Check if the build command itself failed
if [ $build_exit_code -ne 0 ]; then
  echo error: build command failed with exit code $build_exit_code
  exit 1
fi

# Check for build errors in the output
if (echo "$output" | grep -qE "Build Failed|Error:|[0-9]+ errors"); then
  echo error: build completed with errors
  exit 1
fi

exit 0
