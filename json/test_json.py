#!/usr/bin/env python3

import json, sys, time

t0 = time.time()
obj = json.load(sys.stdin)
t1 = time.time()
print("\n----\nDecode JSON: %fs\n----\n" % (t1-t0))
print(obj)
t2 = time.time()
print("\n----\nPrint JSON: %fs\n----\n" % (t2-t1))
