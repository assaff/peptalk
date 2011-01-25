#! /bin/csh
set list=$1

rm -rf tmp
touch tmp
foreach i (`cat $list`)
cat $i.res | grep DDG_B | awk 'BEGIN{none=0; some=0; lots=0; tot=0; e=0; hse=0; reside=0;}{if (substr($24,length($24),1)=="B") {tot=tot+1; if ($14<=0) none=none+1; if ($14<1.5 && $14 >0) {some=some+1; reside=reside+$14; e=e+$14; }if  ($14 >= 1.5) {print substr($25,1,1); lots=lots+1; hse=hse+$14; e=e+$14;}}}END{}' >> tmp
end

set tot=`sort tmp | uniq -c | awk 'BEGIN{sum=0}{sum=sum+$1}END{print sum}'`
sort tmp | uniq -c | awk '{print $2,$1,$1/'$tot'}' | sort -k2 -nr
echo "Sum: $tot"
