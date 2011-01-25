#! /bin/csh
set list=$1

rm -rf tmp
touch tmp

foreach i (`cat $list`)
set len=`cat $i.res | grep DDG_B | awk 'BEGIN{tot=0}{if (substr($24,length($24),1)=="B") tot++;}END{print tot}'`
cat $i.res | grep DDG_B | awk 'BEGIN{n=0; c=0; fif1=0; fif2=0; fif3=0; fif4=0; fif5=0; pos=0}{if (substr($24,length($24),1)=="B") {pos=pos+1; if  ($14 > 1) {place=pos/'$len'; if (pos==1) n++; if (pos=='$len') c++; if (place < 0.2) fif1++; else if (place < 0.4) fif2++; else if (place <0.6) fif3++; else if (place <0.8) fif4++; else {fif5++}}}}END{print n,fif1,fif2,fif3,fif4,fif5,c}' >> tmp
end

cat tmp | /vol/ek/londonir/scripts/avgNstd.sh
