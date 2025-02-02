#!/bin/bash

echo "###############################################################################"
echo "Workshop environment setup starting.."
echo "###############################################################################"

# Wait if apt is running. 
while :
do
    count=`ps -ef | grep apt.systemd.daily | grep lock_is_held | grep -v grep | wc -l`
    if [ $count = 0 ]; then
        break
    else
        echo "System update is running.. Wait until the completion"
        sleep 10
    fi
done

sudo apt-get update
source /opt/ros/$ROS_DISTRO/setup.sh
rosdep update

pip3 install -U awscli
# pip3 install -U setuptools # 新加坡需要放开注释
pip3 install -U colcon-common-extensions colcon-ros-bundle colcon-bundle
pip3 install boto3
pip3 install colorama

STACK_NAME=meirorunner`echo $C9_USER|tr -d [\.\\-=_@]` 

export SETUPTOOLS_USE_DISTUTILS=stdlib
# aws cloudformation deploy --template-file ./cf/meirorunner.template.json --stack-name $STACK_NAME --capabilities CAPABILITY_IAM

BUCKET_NAME=$1

IAM_ROLE=$2

python3 ./ws_setup.py $STACK_NAME $BUCKET_NAME $IAM_ROLE
