# hadoop

## images

### base node

## nodes

### name node(hdfs)

* port: 9870
* envs
  * HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
* volumn
  * /hadoop/dfs/name
* run.sh
    ```bash
    #!/bin/bash
    
    namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
    if [ ! -d $namedir ]; then
      echo "Namenode name directory not found: $namedir"
      exit 2
    fi
    
    if [ -z "$CLUSTER_NAME" ]; then
      echo "Cluster name not specified"
      exit 2
    fi
    
    echo "remove lost+found from $namedir"
    rm -r $namedir/lost+found
    
    if [ "`ls -A $namedir`" == "" ]; then
      echo "Formatting namenode name directory: $namedir"
      $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
    fi
    
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
    ```

### data node(hdfs)

* port: 9864
* envs
    * HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
* volume
    * /hadoop/dfs/data
* run.sh
    ```bash
    #!/bin/bash

    datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
    if [ ! -d $datadir ]; then
    echo "Datanode data directory not found: $datadir"
    exit 2
    fi
    
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
    ```

### resource manager node(yarn)

* port: 8088
* envs
* volume
* run.sh
    ```bash
    #!/bin/bash

    $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
    ```

### node manager(yarn)

* port: 8042
* envs
* volume
* run.sh
    ```bash
    #!/bin/bash

    $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager
    ```

### history node(yarn)

* port: 8188
* envs
  * YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
* volume
  * /hadoop/yarn/timeline
* run.sh
    ```bash
    #!/bin/bash

    $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver
    ```


