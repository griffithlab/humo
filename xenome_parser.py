import sys
import os

'''
Goal: Parse individual log files to extract Summary statistics

Input: Directory containing log files
Output: Directory containing parsed log files (matching names)

'''

def group_by_heading(source_file, heading):
    buffer = []
    for line in source_file:
        if line.startswith(heading):
            if buffer : yield buffer
            buffer = [line]
        else:
            buffer.append(line)
    yield buffer

def list_files(dir):
    result = []
    for root, dirs, files in os.walk(dir):
        for name in files:
            result.append(os.path.join(root, name))
    return result

def main():

    directory_string = sys.argv[1]

    output_strings = []

    fileList = list_files(directory_string)
    
    for filename in fileList:
        if(filename.endswith(".xenome_classify.log")):
            with open(filename, "r") as log_file:
                for summary in group_by_heading(log_file, "Summary"):
                    output_strings.append((os.path.basename(filename), summary[1:7]))
            log_file.close()

    export_path = "parsed_" + directory_string + "/"
    export_file = ""
    
    if not os.path.exists(export_path):
        os.makedirs(export_path)

    for output in output_strings:
        export_file = export_path + output[0]
        
        with open(export_file, "w+") as output_file:
            for line in output[1]:
                output_file.write(line)
        output_file.close()

main()
