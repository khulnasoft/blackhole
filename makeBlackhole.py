#!/usr/bin/env python

# Script by gfyoung
# https://github.com/gfyoung
#
# This Python script will generate blackhole files and update the readme file.

from __future__ import print_function

import argparse
import subprocess
import sys


def print_failure(msg):
    """
    Print a failure message.

    Parameters
    ----------
    msg : str
        The failure message to print.
    """

    print("\033[91m" + msg + "\033[0m")


def update_blackhole_file(*flags):
    """
    Wrapper around running updateBlackholeFile.py

    Parameters
    ----------
    flags : varargs
        Commandline flags to pass into updateBlackholeFile.py. For more info, run
        the following command in the terminal or command prompt:

        ```
        python updateBlackholeFile.py -h
        ```
    """

    if subprocess.call([sys.executable, "updateBlackholeFile.py"] + list(flags)):
        print_failure("Failed to update blackhole file")


def update_readme_file():
    """
    Wrapper around running updateReadme.py
    """

    if subprocess.call([sys.executable, "updateReadme.py"]):
        print_failure("Failed to update readme file")


def recursively_loop_extensions(extension, extensions, current_extensions):
    """
    Helper function that recursively calls itself to prevent manually creating
    all possible combinations of extensions.

    Will call update_blackhole_file for all combinations of extensions
    """

    c_extensions = extensions.copy()
    c_current_extensions = current_extensions.copy()
    c_current_extensions.append(extension)

    name = "-".join(c_current_extensions)

    params = ("-a", "-n", "-o", "alternates/"+name, "-e") + tuple(c_current_extensions)
    update_blackhole_file(*params)

    params = ("-a", "-n", "-s", "--nounifiedblackhole", "-o", "alternates/"+name+"-only", "-e") + tuple(c_current_extensions)
    update_blackhole_file(*params)

    while len(c_extensions) > 0:
        recursively_loop_extensions(c_extensions.pop(0), c_extensions, c_current_extensions)


def main():
    parser = argparse.ArgumentParser(
        description="Creates custom blackhole "
        "file from blackhole stored in "
        "data subfolders."
    )
    parser.parse_args()

    # Update the unified blackhole file
    update_blackhole_file("-a")

    # List of extensions we want to generate, we will loop over them recursively to prevent manual definitions
    # Only add new extensions to the end of the array, to avoid relocating existing blackhole-files
    extensions = ["fakenews", "gambling", "porn", "social"]

    while len(extensions) > 0:
        recursively_loop_extensions(extensions.pop(0), extensions, [])

    # Update the readme files.
    update_readme_file()


if __name__ == "__main__":
    main()
