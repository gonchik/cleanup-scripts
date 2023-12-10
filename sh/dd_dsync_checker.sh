#!/bin/bash
echo "Disk performance check with dd dsync (synchronized I/O for data)"
# Small files (64KB)
dd if=/dev/zero of=./dsync64KB.img bs=64 count=1000 oflag=dsync 2>&1|tee dsync-test-1-64KB.log

# Small files (512KB)
dd if=/dev/zero of=./dsync64KB.img bs=512 count=1000 oflag=dsync 2>&1|tee dsync-test-1-512KB.log

# Small files (1024KB)
dd if=/dev/zero of=./dsync64KB.img bs=1024 count=1000 oflag=dsync 2>&1|tee dsync-test-1-1024KB.log

# Medium files (8MB)
dd if=/dev/zero of=./dsync8MB.img bs=8k count=1000 oflag=dsync 2>&1|tee dsync-test-2-8MB.log

# Big files (128MB)
dd if=/dev/zero of=./dsync128MB.img bs=128k count=1000 oflag=dsync 2>&1|tee dsync-test-3-128MB.log

for log in dsync*.log; do echo "## $log ##"; cat $log; done

echo "Removing dsync*.img files..."
find . -name "dsync*.img" -delete

echo "More info you can bring from https://cwiki.apache.org/confluence/display/lucene/ImproveIndexingSpeed"