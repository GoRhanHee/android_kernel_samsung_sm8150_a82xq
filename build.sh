#!/bin/bash

# Import Cross Compiler
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 \
 toolchain/gcc-cfp/gcc-cfp-single/aarch64-linux-android-4.9

# Import LLVM toolchain
git clone https://github.com/proprietary-stuff/llvm-arm-toolchain-ship-10.0 \
 toolchain/llvm-arm-toolchain-ship/10.0

# Import KernelSU-Next legacy branch
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/legacy/kernel/setup.sh" | bash -s legacy

# Setting 
export ANDROID_BUILD_TOP=$(pwd)
export KSU=$1

# OEM Setting
export ARCH=arm64
BUILD_CROSS_COMPILE=$(pwd)/toolchain/gcc-cfp/gcc-cfp-single/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$(pwd)/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

# Cooking Kernel Source
mkdir out
CONFIGS="a82xq_kor_skt_defconfig gorhanhee.config"

MAKE_ARGS="
-j16 \
$KERNEL_MAKE_ENV \
ARCH=arm64 \
CROSS_COMPILE=$BUILD_CROSS_COMPILE \
REAL_CC=$KERNEL_LLVM_BIN \
CLANG_TRIPLE=$CLANG_TRIPLE \
O=out
"

make ${MAKE_ARGS} ${CONFIGS} || exit 1
make ${MAKE_ARGS} || exit 1 
