
echo " downloading wordnet data "

curl -L "https://wordnetcode.princeton.edu/wn3.1.dict.tar.gz" -o dict.tar.gz
tar -zxvf dict.tar.gz
rm dict.tar.gz

# format documentation can be found in section 5 of https://wordnet.princeton.edu/documentation
