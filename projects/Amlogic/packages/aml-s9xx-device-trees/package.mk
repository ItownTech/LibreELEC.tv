################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Mateusz Krzak (kszaquitto@gmail.com)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="aml-s9xx-device-trees"
PKG_VERSION="097d287"
PKG_LICENSE="OSS"
PKG_URL="https://github.com/kszaq/s905-device-trees/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="s905-device-trees-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  # Enter kernel directory
  pushd $BUILD/linux-$(kernel_version) > /dev/null

  # Copy all device trees to kernel source folder and create a list
  for f in $PKG_BUILD/*.dts; do
    DTB_NAME="$(basename $f .dts).dtb"
    cp -f $f arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/
    DTB_LIST="$DTB_LIST $DTB_NAME"
  done

  # Compile device trees
  LDFLAGS="" make $DTB_LIST
  cp -a arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/*.dtb $PKG_BUILD

  popd > /dev/null
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -a $PKG_BUILD/*.dtb $INSTALL/usr/share/bootloader
}
