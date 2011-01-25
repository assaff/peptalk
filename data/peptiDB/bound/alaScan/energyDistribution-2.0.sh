#! /bin/csh

set list=$1

rm -rf tmp
touch tmp
foreach i (`cat $list`)
cat $i.res | grep DDG_B | awk 'BEGIN{none=0; some=0; lots=0; tot=0; e=0; hse=0; reside=0;}{if (substr($24,length($24),1)=="B") {tot=tot+1; if ($14<=0) none=none+1; if ($14<1.5 && $14 >0) {some=some+1; reside=reside+$14; e=e+$14; }if  ($14 >= 1.5) {lots=lots+1; hse=hse+$14; e=e+$14;}}}END{print tot,reside/e,hse/e}' >> tmp
end

foreach i (5 6 7 8 9 10 11 12 13 14 15)
cat tmp | awk '$1=='$i'' | awk 'BEGIN{bin1=0;bin2=0;bin3=0;bin4=0;bin5=0;bin6=0;bin7=0;bin8=0;bin9=0;bin10=0;}{if ($2<0.1) bin1++; else if ($2<0.2) bin2++; else if ($2<0.3) bin3++; else if ($2<0.4) bin4++; else if ($2<0.5) bin5++; else if ($2<0.6) bin6++; else if ($2<0.7) bin7++; else if ($2<0.8) bin8++; else if ($2<0.9) bin9++; else bin10++}END{print bin1,bin2,bin3,bin4,bin5,bin6,bin7,bin8,bin9,bin10}'
end
