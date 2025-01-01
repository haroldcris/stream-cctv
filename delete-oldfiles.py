import os
import time
import shutil
from datetime import datetime, timedelta

# Configuration
TARGET_FOLDER = r"Z:\\My Drive\AiTech\\cctv\\"  # Path to the folder containing files
MAX_AGE_HOURS = 48 # Maximum age in hours

def delete_old_files(folder: str, max_age_hours: int):
    """Delete files in the specified folder older than max_age_hours."""
    # Calculate the cutoff time
    now = datetime.now()
    cutoff_time = now - timedelta(hours=max_age_hours)

    print(f"Deleting files in '{folder}' older than {max_age_hours} hours...")
    deleted_count = 0

    # Loop through files in the folder
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        
        if os.path.isdir(file_path):
            delete_old_files(file_path,max_age_hours)
                
        # Check if it's a file (not a folder)
        if not os.path.isfile(file_path):
            continue
        
        print(f"Checking: {file_path}")
        # Get the last modification time of the file
        file_mtime = datetime.fromtimestamp(os.path.getmtime(file_path))
        
        # Check if the file is older than the cutoff time
        if file_mtime < cutoff_time:
            print(f"Deleting: {file_path} (Last modified: {file_mtime})")
            os.remove(file_path)
            # destination_file_path = os.path.join(destination_folder, filename)
            # print(f"Moving: {source_file_path} -> {destination_file_path} (Last modified: {file_mtime})")
            #shutil.move(file_path, os.path.join(TARGET_FOLDER, "archive"))
            deleted_count += 1

    print(f"Done! Deleted {deleted_count} file(s).")

# Run the script
if __name__ == "__main__":
    delete_old_files(TARGET_FOLDER, MAX_AGE_HOURS)
