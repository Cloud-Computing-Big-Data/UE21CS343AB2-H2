cd $HADOOP_HOME/sbin/
./start-all.sh

cd

rm -rf metastore_db/

$HIVE_HOME/bin/schematool -initSchema -dbType derby

hive