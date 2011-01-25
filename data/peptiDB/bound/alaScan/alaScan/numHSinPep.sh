#! /bin/csh
set list=$1

rm -rf tmp
touch tmp
foreach i (`cat $list`)
echo -n "$i "
cat $i.res | grep DDG_B | awk 'BEGIN{tot=0; hs=0}{if (substr($24,length($24),1)=="B") {tot++; if  ($14 > 1) {hs++}}}END{print hs}' 
end
