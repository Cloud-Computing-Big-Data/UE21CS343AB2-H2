return_to_pwd=$(pwd)
cd
if [ -d "hive" ]; then
    echo "Deleting previous hive installation"
    sudo rm -rf hive
fi

mkdir hive
cd hive

wget https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
tar -xvf apache-hive-3.1.3-bin.tar.gz
mv apache-hive-3.1.3-bin apache_hive

cd
export HIVE_HOME=$HOME/hive/apache_hive >> ~/.bashrc
export PATH=$PATH:$HIVE_HOME/bin >> ~/.bashrc
source ~/.bashrc

echo 'HIVE_HOME'
echo $HIVE_HOME
echo "Do you see something like /home/pes1ug20cs999/hive/apache_hive above?[y/n]"
read answer
if [ $answer == "y" ]; then
    echo "You're good to go. Run ./start-hive.sh to start hive. For now, wait for this process to complete for some post-installation steps."
else
    echo "Run source ~/.bashrc and make sure HIVE_HOME is set. Once done, run ./start-hive.sh to start hive. For now, wait for this process to complete for some post-installation steps."
fi

jps_count=$(jps | wc -l)
if [ $jps_count == 1 ]; then
    echo "Starting Hadoop"
    $HADOOP_HOME/sbin/start-all.sh
fi

jps_count=$(jps | wc -l)
if [ $jps_count < 6 ]; then
    echo "Hadoop startup failed. Exiting"
    jps
    exit 1
fi
hdfs dfs -test -d /root/hive/warehouse
if [ $? == 0 ]; then
    hdfs dfs -rm -r -f /root*
fi
hdfs dfs -mkdir -p /root/hive/warehouse

cd $return_to_pwd