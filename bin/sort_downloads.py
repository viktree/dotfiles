#!python3

from os import listdir
from os.path import isfile, join
import os
import shutil

DOWNLOADS_PATH = os.environ["HOME"] + "/Downloads"

ignore_list = [".DS_Store"]


def is_catagorizable(f: str) -> bool:
    if not isfile(join(DOWNLOADS_PATH, f)):
        return False
    if f in ignore_list:
        return False
    filename_split = f.split(".")
    if len(filename_split) <= 1:
        return False
    return True


def put_files_in_folders():
    """
    Sorts the files in the download folder by their file extensions
    """
    files = [f for f in listdir(DOWNLOADS_PATH) if is_catagorizable(f)]
    file_type_variation_list = []
    ftype_folder_dict = {}

    files = []
    for full_filename in listdir(DOWNLOADS_PATH):
        if is_catagorizable(full_filename):
            ftype = full_filename.split(".")[-1]
            files.append((full_filename, ftype))

    for _, ftype in files:
        if ftype in file_type_variation_list:
            continue
        file_type_variation_list.append(ftype)
        new_folder_name = DOWNLOADS_PATH + "/" + ftype
        ftype_folder_dict[str(ftype)] = str(new_folder_name)

        if not os.path.isdir(new_folder_name):
            os.mkdir(new_folder_name)

    file_movements = []
    for full_filename, ftype in files:
        src_path = DOWNLOADS_PATH + "/" + full_filename
        dest_path = ftype_folder_dict[str(ftype)]
        file_movements.append((src_path, dest_path))

    for src_path, dest_path in file_movements:
        shutil.move(src_path, dest_path)
        print(src_path + ">>>" + dest_path)


if __name__ == "__main__":
    put_files_in_folders()
