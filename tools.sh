#/bin/bash 

#对于函数而言，没有任何区别。仅仅是加了一个｛｝而已
#在调用函数的时候，直接写函数的名字，空格，然后跟参数#
#shell中的参数和c语言中不一样。c中参数的个数，从程序名（参数0）开始算。 c中参数的总数包括程序名。#
#./tool.sh  param0  param1 ，参数的总数为2
prepare_single_dir_data(){
cd $1
echo "begin generate $1"
rm -rf ./*.bin*
rm -rf ./hash
pwd
h2b.py refer/cam_data_hex.trc  			inData.bin
h2b.py refer/cabac_table_hex.trc  	inCtab.bin.tmp
swap 64 inCtab.bin.tmp inCtab.bin
rm -rf inCtab.bin.tmp
chmod 666 inCtab.bin
h2b.py refer/segment_map_hex.trc  	inSeg.bin
h2b.py refer/cam_data_hex.trc  			inStab.bin


h2b.py refer/prob_count_hex.trc					outCtx.bin.tmp
swap 16 outCtx.bin.tmp outCtx.bin
rm -rf outCtx.bin.tmp
h2b.py refer/mv_out_hex.trc  						outMvs.bin
h2b.py refer/nal_unit_size_hex.trc  	outNals.bin.tmp
swap 32 outNals.bin.tmp outNals.bin
rm -rf outNals.bin.tmp
chmod 666 outNals.bin
h2b.py refer/stream_out_hex1.trc  			outPtr1.bin
h2b.py refer/stream_out_hex2.trc  			outPtr2.bin
h2b.py refer/stream_out_hex3.trc  			outPtr3.bin
h2b.py refer/stream_out_hex4.trc  			outPtr4.bin
h2b.py refer/recon_lum_data_hex.trc  	outReLu.bin.tmp
swap 64 outReLu.bin.tmp outReLu.bin
rm -rf outReLu.bin.tmp
chmod 666 outReLu.bin
h2b.py refer/recon_chr_data_hex.trc  	outReCh.bin.tmp
swap 64 outReCh.bin.tmp outReCh.bin
rm -rf outReCh.bin.tmp
chmod 666 outReCh.bin
h2b.py refer/scale_out_hex.trc 				 	outScale.bin
h2b.py refer/stream_out_hex0.trc  			outStrm.bin
chmod 666 outStrm.bin
#h2b.py refer/  outStrmAm.bin

#这里就调用了一个python脚本。
h1_script.py refer/base_address_map.trc  refer/simulation_ctrl_unmapped.trc

#判断文件是否存在，不管文件的类型。
if [ -e "outCtx.bin" ];then
	size=`du outCtx.bin|awk -F '' '{print $1}'`
	if [ $size -ne 0 ];then
		outCtx_crc="outCtxSizeCrc 7 2 0 0x"`crc32 outCtx.bin`
		echo  $outCtx_crc >  hash
	fi
fi

if [ -e "outMvs.bin" ];then
size=`du outMvs.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then 
		outMvs_crc="outMvsSizeCrc 7 2 0 0x"`crc32 outMvs.bin`
		echo  $outMvs_crc>>  hash
	fi
fi

if [ -e "outNals.bin" ];then
size=`du outNals.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outNals_crc="outNalsSizeCrc 7 2 0 0x"`crc32 outNals.bin`
		echo  $outNals_crc>> hash
	fi
fi

if [ -e "outPtr1.bin" ];then
size=`du outPtr1.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then 
		outPtr1_crc="outPtr1SizeCrc 7 2 0 0x"`crc32 outPtr1.bin`
		echo  $outPtr1_crc>> hash
	fi
fi


if [ -e "outPtr2.bin" ];then
size=`du outPtr2.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outPtr2_crc="outPtr2SizeCrc 7 2 0 0x"`crc32 outPtr2.bin`
		echo  $outPtr2_crc>> hash
	fi
fi

if [ -e "outPtr3.bin" ];then
size=`du outPtr3.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outPtr3_crc="outPtr3SizeCrc 7 2 0 0x"`crc32 outPtr3.bin`
		echo  $outPtr3_crc>>  hash
	fi
fi

if [ -e "outPtr4.bin" ];then
size=`du outPtr4.bin|awk -F '' '{ print $1 }'`
	if [  $size -ne 0 ];then
		outPtr4_crc="outPtr4SizeCrc 7 2 0 0x"`crc32 outPtr4.bin`
		echo  $outPtr4_crc>> hash
	fi
fi

if [ -e "outReLu.bin" ];then
size=`du outReLu.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outReLu_crc="outReLuSizeCrc 7 2 0 0x"`crc32 outReLu.bin`
		echo  $outReLu_crc>> hash
	fi
fi

if [ -e "outReCh.bin" ];then
size=`du outReCh.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outReCh_crc="outReChSizeCrc 7 2 0 0x"`crc32 outReCh.bin`
		echo  $outReCh_crc>>  hash
	fi
fi

if [ -e "outScale.bin" ];then
size=`du outScale.bin|awk -F '' '{ print $1 }'`
	if [ $size -ne 0 ];then
		outScale_crc="outScaleSizeCrc 7 2 0 0x"`crc32 outScale.bin`
		echo  $outScale_crc>>  hash
	fi
fi

if [ -e "outStrm.bin" ];then
size=`du outStrm.bin|awk -F '' '{ print $1 }'`
	if [  $size -ne 0 ];then
		outStrm_crc="outStrmSizeCrc 7 2 0 0x"`crc32   outStrm.bin`
		echo  $outStrm_crc>>  hash
	fi
fi

if [ -e "outStrmAm.bin" ];then
size=`du outStrmAm.bin|awk -F '' '{ print $1 }'`
	if [  $size -ne 0 ];then
		outStrmAm_crc="outStrmAmSizeCrc 7 2 0 0x"`crc32 outStrmAm.bin`
		echo  $outStrmAm_crc>>  hash
	fi
fi


echo 
echo
pwd
cat hash

cd -
}

generate_mv_xxx_txt_file(){

cd $1
case_dir=$1
echo "$pwd"
all_dir=`ls *.bin`
var=`echo "$case_dir"|awk -F '_' '{ print $2}'`
txt_file=../../MV-$var.txt
rm -rf $txt_file
touch $txt_file

#semihost path
data_path=venc/h1/res

#generate file
echo "caseName 0 1 h1_case_$var">>$txt_file
for sig_dir in $all_dir
do
	size=`du $sig_dir|awk -F '' '{print $1}'`
	echo $sig_dir
	if [ 0 -eq $size ];then
		rm -rf $sig_dir
		continue
	fi
	#in header file
	header=`echo $sig_dir|cut -c 1-2`
	file_name=`echo $sig_dir|awk -F '.' '{ print $1 }'`
	if [ "$header"x == "in"x ];then
		echo "$file_name 0 1 $data_path/$case_dir/$sig_dir">>$txt_file
	fi
done
echo "picNum 7 1 10">>$txt_file

cat hash>>$txt_file
cd -

}

prepare_basic_data(){
cur=`pwd`
echo $pwd
for dir in `ls .`  
do 
	if [ -d $dir ] 
	then 
		echo "$dir"
		mkdir -p  $dir/refer
		cp -rfv $dir/*.trc  $dir/refer/ 
		cd  $dir/
		echo `pwd`
		ls 
		cd -
		echo "clean $dir +++++++++++++++++++++"
		rm -rf $dir/*.trc
	fi
done
}
prepare_all_dir_data(){
cur=`pwd`
echo $pwd
for dir in `ls -l|grep '^d'|awk -F ' ' '{ print $9 }'`  
do 
	if [ -d $dir ] 
	then 
		echo "$dir"
		prepare_single_dir_data  $dir
		generate_mv_xxx_txt_file $dir
	fi
done
}
echo $1
echo $#


if [ $# -ne 1 ] 
		then 
		    prepare_basic_data
			echo "para error"
else 
		echo "ok"
		if [ $1  = "all"  ] 
		then
				echo "deal all dir"
				prepare_all_dir_data  
		elif [ -d `pwd`"/$1"  ] 
		then 
			echo "deal single dir $1"
			prepare_single_dir_data    $1		
			generate_mv_xxx_txt_file	$1
		else 
				echo "%1 must be all or dirname"	
		fi
fi


