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
    then echo "CCS project files found"
    else echo "CCS project files not found" && exit 1
    fi
}



####################################
### Main Action Code Starts Here ###
####################################
Check_CCS_Project_Files "$1"

echo import project into workspace
/opt/ti/ccs/eclipse/eclipse -noSplash -data "/home/build/workspace" -application com.ti.ccstudio.apps.projectImport -ccs.location "$1"

echo build project
#output=$(/opt/ti/ccs/eclipse/eclipse -noSplash -data "/home/build/workspace" -application org.eclipse.cdt.managedbuilder.core.headlessbuild -build "$2"/"$3")
output=$(/opt/ti/ccs/eclipse/eclipse -noSplash -data "/home/build/workspace" -application com.ti.ccstudio.apps.projectBuild  -ccs.workspace --ccs.configuration "$3")
echo "$output"

# Check build command output to confirm that the correct configuration was built
if (echo "$output" | grep -q "Build of configuration $3") then
  exit 0
else
  echo error: incorrect build configuration detected
  exit 1
fi
