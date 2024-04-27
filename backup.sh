#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3]
currentTS=$(date +%s)

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"
echo "Backup File Name: $backupFileName"

# [TASK 5]
origAbsPath=$(pwd)
echo "Original Absolute Path: $origAbsPath"

# [TASK 6]
cd "$destinationDirectory" || exit 1  # Exit if directory change fails
destAbsPath=$(pwd)
echo "Destination Absolute Path: $destAbsPath"

# [TASK 7]
cd "$origAbsPath" || exit 1  # Exit if directory change fails
cd "$targetDirectory" || exit 1  # Exit if directory change fails
echo "Current Directory: $(pwd)"

# [TASK 8]
yesterdayTS=$(($currentTS - 24 * 60 * 60))
echo "Yesterday Timestamp: $yesterdayTS"

declare -a toBackup

for file in $(ls) # [Task 9]
do  # [TASK 10]
  file_last_modified_date=$(date -r "$file" +%s)  # Get last-modified date in seconds
  if [[ $file_last_modified_date -gt $yesterdayTS ]]
  then
    echo "$file was modified within the last 24 hours"
    # Add file to backup list
    toBackup+=("$file")  # Task 11
  fi
done

# Print files to backup
echo "Files to Backup:"
for backupFile in "${toBackup[@]}"
do
  echo "$backupFile"
done

# [TASK 12]
echo "Creating backup archive..."
tar -czvf "$backupFileName" "${toBackup[@]}"

# Check if backup archive was created successfully
if [[ -e "$backupFileName" ]]
then
  echo "Backup archive created successfully!"
else
  echo "Failed to create backup archive!"
fi

# [TASK 13]
echo "Moving backup archive to destination directory..."
mv "$backupFileName" "$destAbsPath/"

# Check if the backup archive was moved successfully
if [[ -e "$destAbsPath/$backupFileName" ]]
then
  echo "Backup archive moved to destination directory successfully!"
else
  echo "Failed to move backup archive to destination directory!"
fi

