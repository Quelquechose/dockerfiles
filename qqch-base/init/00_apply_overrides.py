#!/usr/bin/python
import os, fnmatch
from datetime import datetime

OVERRIDES_DIR = "/data/overrides"



def find_files(directory, pattern="*"):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if fnmatch.fnmatch(basename, pattern):
                filename = os.path.join(root, basename)
                yield filename


def get_target(filename):
    return filename.replace(OVERRIDES_DIR,"")

for filename in find_files(OVERRIDES_DIR):
    target = get_target(filename)
    print 'Found:', filename
    print 'Target:', target


    if os.path.exists(target):
        if os.path.realpath(target) != os.path.realpath(filename): 
            suffix =  datetime.now().strftime("%Y%m%d_%H%M%S")
            dst = "%s-%s" % (target,suffix)
            os.rename(target, dst)
            os.symlink(filename, target)
        else:
            pass
    else:
        os.symlink(filename, target) 

    print '---------------------------------------------'
         
