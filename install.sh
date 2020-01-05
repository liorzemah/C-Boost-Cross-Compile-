#!/bin/bash
boost_src_dir=$1 					# /home/user/Documents/boost_src_dir
prefix=$2						# /home/user/Documents/boost_to_linaro
toolchain_full_path=$3					# /gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++
toolchain_name=$(basename "$toolchain_full_path")	# aarch64-linux-gnu-g++
libraries=($4)						# stacktrace, exception, mpi, etc;
libraries_raw=${libraries[@]}
libraries_with_underscore=${libraries_raw// /_}
error_output=$prefix/install_error
directory_name=boost_to_"$toolchain_name"_with_"$libraries_with_underscore"

with_libs_string=""
for i in $libraries_raw
do 
	with_libs_string="$with_libs_string--with-$i "
done

# examples:
# 1. sudo ./install.sh ~/Documents/BoostCross/boost_1_66_0/ ~/Documents/BoostCross/ ~/Documents/BoostCross/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++ "stacktrace"
# 2. sudo ./install.sh ~/Documents/BoostCross/boost_1_66_0/ ~/Documents/BoostCross/ gcc  "exception"



#==================================================================================
#1. Create boost_to_$toolchain_name_with_$libraries_with_underscore directory
#==================================================================================

echo "#==================================================================================
#1. Create $directory_name directory [ERROR]
#==================================================================================" > $error_output

cd $prefix &>> $error_output
mkdir $directory_name &>> $error_output

echo "#==================================================================================
#1. [ERROR END]
#==================================================================================" >> $error_output

#==================================================================================
#Created boost_to_$toolchain_name_with_$libraries_with_underscore directory
#==================================================================================

echo "" >> $error_output

#==================================================================================
#2. Bootstrap
#==================================================================================

echo "#==================================================================================
#2. Bootstrap [ERROR]
#==================================================================================" >> $error_output

cd $boost_src_dir &>> $error_output
sudo ./bootstrap.sh --prefix=$prefix/$directory_name &>> $error_output

echo "#==================================================================================
#2. [ERROR END]
#==================================================================================" >> $error_output

#==================================================================================
#End Bootstrap
#==================================================================================

echo "" >> $error_output

#==================================================================================
#3. Configure .jam files
#==================================================================================

echo "#==================================================================================
#3. Configure .jam files [ERROR]
#==================================================================================" >> $error_output

if [ "$toolchain_full_path" != "gcc" ] && [ "$toolchain_name" != "gcc" ]; then

	#==================================================================================
	#3.1. Create user-config.jam for $toolchain_name
	#==================================================================================

	echo "#==================================================================================" >> $error_output
	echo "#3.1. Create user-config.jam for $toolchain_name [ERROR]" >> $error_output
	echo "#==================================================================================" >> $error_output

	$(echo "using gcc :  : $toolchain_name ;" > user-config.jam) &>> $error_output

	echo "#==================================================================================" >> $error_output
	echo "#3.1. [ERROR END]" >> $error_output
	echo "#==================================================================================" >> $error_output

	#==================================================================================
	#3.1 Created user-config.jam
	#==================================================================================

	echo "" >> $error_output

	#==================================================================================
	#3.2 Replace default architecture with $toolchain_full_path
	#   inside project-config.jam  
	#==================================================================================

	echo "#==================================================================================" >> $error_output
	echo "#3.2. Replace default architecture with $toolchain_full_path" >> $error_output
	echo "#   inside project-config.jam [ERROR]" >> $error_output
	echo "#==================================================================================" >> $error_output

	sed -i s#"using gcc ; "#"using gcc :  : $toolchain_full_path ; "# $boost_src_dir/project-config.jam &>> $error_output

	echo "#==================================================================================" >> $error_output
	echo "#3.2. [ERROR END]" >> $error_output
	echo "#==================================================================================" >> $error_output

	#==================================================================================
	#3.2. End Replacing  
	#==================================================================================

else
	#==================================================================================
	#3.1. Create user-config.jam for default architecture (gcc)
	#==================================================================================

	echo "#==================================================================================" >> $error_output
	echo "#3.1. Create user-config.jam for default architecture (gcc) [ERROR]" >> $error_output
	echo "#==================================================================================" >> $error_output

	$(echo "using gcc ;" > user-config.jam) &>> $error_output

	echo "#==================================================================================" >> $error_output
	echo "#3.1. [ERROR END]" >> $error_output
	echo "#==================================================================================" >> $error_output

	#==================================================================================
	#3.1 Created user-config.jam
	#==================================================================================

fi

echo "" >> $error_output

#==================================================================================
#4. B2 install
#==================================================================================

echo "#==================================================================================
#4. B2 install [ERROR]
#==================================================================================" >> $error_output

cd $boost_src_dir &>> $error_output


sudo ./b2 install --user-conifig=user-config.jam  --prefix=$prefix/$directory_name $with_libs_string &>> $error_output

echo "#==================================================================================
#4. [ERROR END]
#==================================================================================" >> $error_output

#==================================================================================
#End Bootstrap
#==================================================================================


