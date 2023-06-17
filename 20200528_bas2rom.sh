hex[0]="
41421040000000000000000000000000cd38010f0fe6034f21c1fc856f7ee680
b14f2c2c2c2c7ee60cb1217464229af32ef76722dafe213d4022dcfec9216140
ed5b76f601ffffedb0ed53c2f63ec932dafedd215342cd5901dd21ac73c35901
"

hex[1]=$(cat $1|od -An -tx1 -w16000)

size=$(cat $1|wc -c)
let lo=(size % 256)
let hi=(size / 256)

hex[0]=${hex[0]//01ffffed/01$(printf "%02x" $lo;printf "%02x" $hi)ed}

if [ $size -gt 16000 ]
then
	echo "too large"	&&err=1
fi

if [[ ${hex[1]:1:2} != "ff" ]]
then
	echo "type different" &&err=1
fi

let err=err+$?

if [[ $err -ne 0 ]] 
then
	exit
fi

echo ${hex[@]} | xxd -r -p | dd of=$1.rom iflag=fullblock bs=16k conv=sync >& /dev/null

