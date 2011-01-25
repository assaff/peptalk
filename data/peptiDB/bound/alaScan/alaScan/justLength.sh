#! /bin/csh
set list=$1

rm -rf tmp
touch tmp
foreach i (`cat $list`)
set len=`cat $i.res | grep DDG_B | awk 'BEGIN{tot=0}{if (substr($24,length($24),1)=="B") tot++;}END{print tot}'`
echo "$i $len"
end
