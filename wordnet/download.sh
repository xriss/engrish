
echo " downloading wordnet data "

curl -L "https://wordnetcode.princeton.edu/wn3.1.dict.tar.gz" -o dict.tar.gz
tar -zxvf dict.tar.gz
rm dict.tar.gz

