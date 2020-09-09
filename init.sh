a=`sed -n '1p' ip.txt`
b=`sed -n '2p' ip.txt`
c=`sed -n '3p' ip.txt`
chmod -x installation.sh
bash installation.sh "$a" "$b" "$c"
