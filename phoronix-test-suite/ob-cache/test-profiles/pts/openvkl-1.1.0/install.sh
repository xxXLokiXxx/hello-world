#!/bin/sh

tar -xf openvkl-1.0.0.x86_64.linux.tar.gz

echo "#!/bin/sh
cd openvkl-1.0.0.x86_64.linux/bin/
LD_LIBRARY_PATH=../lib:\$LD_LIBRARY_PATH ./\$@ > \$LOG_FILE 2>&1" > openvkl
chmod +x openvkl
