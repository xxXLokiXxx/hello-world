#!/bin/sh

# FFmpeg install to demux AV1 WebM to IVF that can then be consumed by dav1d/libgav1...
tar -xjf ffmpeg-4.2.1.tar.bz2
mkdir ffmpeg_/

cd ffmpeg-4.2.1/
./configure --disable-zlib --disable-doc --prefix=$HOME/ffmpeg_/
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
make install
cd ~/

./ffmpeg_/bin/ffmpeg -i Stream2_AV1_HD_6.8mbps.webm -vcodec copy -an -f ivf summer_nature_1080p.ivf
./ffmpeg_/bin/ffmpeg -i Stream2_AV1_4K_22.7mbps.webm -vcodec copy -an -f ivf summer_nature_4k.ivf
./ffmpeg_/bin/ffmpeg -i Chimera-AV1-8bit-1920x1080-6736kbps.mp4 -vcodec copy -an -f ivf chimera_8b_1080p.ivf
./ffmpeg_/bin/ffmpeg -i Chimera-AV1-10bit-1920x1080-6191kbps.mp4 -vcodec copy -an -f ivf chimera_10b_1080p.ivf

rm -rf ffmpeg-4.2.1
rm -rf ffmpeg_

# Build GAV1
rm -rf third_party
tar -xf libgav1-0170.tar.xz
mkdir build
mkdir third_party

tar -xf abseil-cpp-20210324.1.tar.gz
mv abseil-cpp-20210324.1 third_party/abseil-cpp

cd build
cmake -G "Unix Makefiles" -DLIBGAV1_ENABLE_TESTS=false ..
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

cd ~

echo "#!/bin/sh
./build/gav1_decode --threads \$NUM_CPU_CORES \$@ -o /dev/null -v > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > libgav1
chmod +x libgav1
