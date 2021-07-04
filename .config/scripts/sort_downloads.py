#!python3

from os import listdir
from os.path import isfile, join
import os
import shutil

DOWNLOADS_PATH='/home/vikxter/Downloads'

def sort_files_in_a_folder():
    '''
    A function to sort the files in a download folder
    into their respective categories
    '''
    files = [f for f in listdir(DOWNLOADS_PATH) if isfile(join(DOWNLOADS_PATH, f))]
    file_type_variation_list=[]
    filetype_folder_dict={}

    for file in files:
        if file in [".DS_Store"]: continue
        filename_split = file.split('.')
        if len(filename_split) > 1:
            filetype=file.split('.')[1]
            if filetype not in file_type_variation_list:
                file_type_variation_list.append(filetype)
                new_folder_name=DOWNLOADS_PATH+'/'+ filetype
                filetype_folder_dict[str(filetype)]=str(new_folder_name)

                if os.path.isdir(new_folder_name):
                    continue
                else:
                    os.mkdir(new_folder_name)

    for file in files:
        src_path=DOWNLOADS_PATH+'/'+file
        filename_split = file.split('.')
        if len(filename_split) > 1:
            filetype=filename_split[-1]
            if filetype in filetype_folder_dict.keys():
                dest_path=filetype_folder_dict[str(filetype)]
                shutil.move(src_path,dest_path)

                print(src_path + '>>>' + dest_path)

if __name__=="__main__":
    sort_files_in_a_folder()
