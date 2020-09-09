a="`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-master"    --query Reservations[*].Instances[*].PublicIpAddress     --output text` master-node" 
echo $a >> ip.txt
b="`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-1"     --query Reservations[*].Instances[*].PublicIpAddress     --output text` slave1"
echo $b >> ip.txt
c="`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-2"    --query Reservations[*].Instances[*].PublicIpAddress     --output text` slave2"
echo $c >> ip.txt
a=`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-master"     --query Reservations[*].Instances[*].PublicIpAddress    --output text`
scp -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem  installation.sh init.sh  ip.txt ec2-user@$a:/home/ec2-user/
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$a sudo yum install  -y dos2unix
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$a dos2unix installation.sh init.sh  ip.txt
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$a sudo sh init.sh

b=`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-1"     --query Reservations[*].Instances[*].PublicIpAddress    --output text`
sed -i 's/#hostnamectl set-hostname slave-1/hostnamectl set-hostname slave-1/g' installation.sh
sed -i 's/hostnamectl set-hostname master-node/#hostnamectl set-hostname master-node/g' installation.sh
sed -i '28,32 s/^/#/' installation.sh
scp -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem  installation.sh init.sh  ip.txt ec2-user@$b:/home/ec2-user/
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$b sudo yum install  -y dos2unix
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$b dos2unix installation.sh init.sh ip.txt
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$b sudo sh init.sh
 
grep 'kubeadm join' output.txt > output1.txt
grep 'discovery' output.txt >> output1.txt
cat output1.txt|xargs > output2.txt
d="`tr -d '\n' < output2.txt`"
echo $d
nohup ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$b sudo $d &

c=`aws ec2 describe-instances     --filters "Name=tag:Name,Values=k8s-2"     --query Reservations[*].Instances[*].PublicIpAddress    --output text`
sed -i 's/#hostnamectl set-hostname slave-2/hostnamectl set-hostname slave-2/g' installation.sh
sed -i 's/hostnamectl set-hostname slave-1/#hostnamectl set-hostname slave-1/g' installation.sh
scp -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem  installation.sh init.sh  ip.txt ec2-user@$c:/home/ec2-user/
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$c sudo yum install  -y dos2unix
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$c dos2unix installation.sh init.sh  ip.txt
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$c sudo sh init.sh
 
ssh -o StrictHostKeyChecking=no -i /c/Users/abjal/Downloads/abs.pem ec2-user@$c sudo $d
