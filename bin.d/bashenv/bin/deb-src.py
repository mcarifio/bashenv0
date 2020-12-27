#!/usr/bin/python3

import apt_pkg as ap

if __name__ == '__main__':
    ap.init()
    pm = ap.PackageManager(ap.DepCache(ap.Cache()))
    sl = ap.SourceList()
    sl.read_main_list()
    # TODO: add deb-src to list and update. How?
    for mi in sl.list:
        print(f"deb-src {mi.uri} {mi.dist}")
            
