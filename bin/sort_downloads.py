#!python3

from email.generator import Generator
from os import listdir, environ
from os.path import isfile, join
import os
import shutil

DOWNLOADS_PATH = environ["HOME"] + "/Downloads"

ignore_list = [".DS_Store"]


def is_sortable(f: str) -> bool:
    if not isfile(join(DOWNLOADS_PATH, f)):
        return False
    if f in ignore_list:
        return False
    filename_split = f.split(".")
    return len(filename_split) > 1


def get_filetype(full_filename):
    extension = full_filename.split(".")[-1]
    compressed = ["gz", "tar", "zip"]
    if extension in compressed:
        return "compressed"

    games = ["gb", "nds"]
    if extension in games:
        return "games"
    return extension


def put_files_in_folders():
    files_to_sort = []
    ftype_folder_paths = set([])

    # Plan
    for full_filename in listdir(DOWNLOADS_PATH):
        if not is_sortable(full_filename):
            continue

        ftype = get_filetype(full_filename)

        src_path = DOWNLOADS_PATH + "/" + full_filename
        dest_path = DOWNLOADS_PATH + "/" + ftype

        ftype_folder_paths.add(dest_path)
        files_to_sort.append((src_path, dest_path))

    # Create folders if they are missing
    for ftype_folder_path in ftype_folder_paths:
        if not os.path.isdir(ftype_folder_path):
            os.mkdir(ftype_folder_path)

    # Move files
    for i, file_to_sort in enumerate(files_to_sort):
        src_path, dest_path = file_to_sort
        shutil.move(src_path, dest_path)
        print(str(i + 1) + " :" + src_path + ">>>" + dest_path)


if __name__ == "__main__":
    put_files_in_folders()
