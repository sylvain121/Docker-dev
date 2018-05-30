#### XRDP build script from git repo
# V0.1
# Sylvain MATHIEU SCE
#


#clone repo
git clone https://github.com/neutrinolabs/xrdp.git
cd xrdp
git submodule init
git submodule update

#xrdp itself
./bootstrap
./configure --enable-rfxcodec --enable-fuse --enable-tjpeg --with-pic
make
make install
cd ..
#generate keys:
sudo xrdp-keygen  xrdp auto 2048

#rdp module for xorg
git clone https://github.com/neutrinolabs/xorgxrdp.git
cd xorgxrdp/
./bootstrap 
./configure 
make
make install
cd ..

