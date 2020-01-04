#!/bin/bash
boost_src_dir=$1 					# /home/user/Documents/boost_src_dir
prefix=$2						# /home/user/Documents/boost_to_linaro
toolchain_full_path=$3					# /gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++
toolchain_name=$(basename "$toolchain_full_path")	# aarch64-linux-gnu-g++
library_name=$4						# stacktrace, exception, mpi, etc;
error_output=$prefix/install_error
directory_name=boost_to_"$toolchain_name"_with_"$library_name"

#example: sudo ./install.sh ~/Desktop/NewBoost/boost_1_66_0 ~/Desktop/NewBoost ~/Documents/macchiato/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++ stacktrace

#=========================================================
#1. Create boost_to_$toolchain_name_with_$library_name directory
#=========================================================

echo "#=========================================================
#1. Create $directory_name directory [ERROR]
#=========================================================" > $error_output

cd $prefix &>> $error_output
mkdir $directory_name &>> $error_output

echo "#=========================================================
#1. [ERROR END]
#=========================================================" >> $error_output

#=========================================================
#Created boost_to_$toolchain_name_with_$library_name directory
#=========================================================

echo "" >> $error_output

#=========================================================
#2. Bootstrap
#=========================================================

echo "#=========================================================
#2. Bootstrap [ERROR]
#=========================================================" >> $error_output

cd $boost_src_dir &>> $error_output
sudo ./bootstrap.sh --prefix=$prefix/$directory_name &>> $error_output

echo "#=========================================================
#2. [ERROR END]
#=========================================================" >> $error_output

#=========================================================
#End Bootstrap
#=========================================================

echo "" >> $error_output

#=========================================================
#3. Create user-config.jam
#=========================================================

echo "#=========================================================
#3. Create user-config.jam [ERROR]
#=========================================================" >> $error_output

$(echo "using gcc :  : $toolchain_name ;" > user-config.jam) &>> $error_output

echo "#=========================================================
#3. [ERROR END]
#=========================================================" >> $error_output

#=========================================================
#Created user-config.jam
#=========================================================

echo "" >> $error_output

#=========================================================
#4. Replace default architecture with toolchain_full_path
#   inside project-config.jam  
#=========================================================

echo "#=========================================================
#4. Replace default architecture with toolchain_full_path
#   inside project-config.jam [ERROR]
#=========================================================" >> $error_output

sed -i s#"using gcc ; "#"using gcc :  : $toolchain_full_path ; "# $boost_src_dir/project-config.jam &>> $error_output

echo "#=========================================================
#4. [ERROR END]
#=========================================================" >> $error_output

#=========================================================
#4. End Replacing  
#=========================================================

echo "" >> $error_output

#=========================================================
#5. B2 install
#=========================================================

echo "#=========================================================
#5. B2 install [ERROR]
#=========================================================" >> $error_output

cd $boost_src_dir &>> $error_output
sudo ./b2 install --user-conifig=user-config.jam  --prefix=$prefix/$directory_name --with-$library_name &>> $error_output

echo "#=========================================================
#5. [ERROR END]
#=========================================================" >> $error_output

#=========================================================
#End Bootstrap
#=========================================================


