# CDE Demo Auto Deploy

## Objective

This git repository hosts the setup automation for the HOL. The script consists of a series of CDE CLI commands that first create synthetic data in cloud storage for each participant, and then create the shared CDE Resource by every participant.

This automation does not run the actual lab material. These are easy to create from the CDE UI and do not require automation.

## Table of Contents

* [Requirements](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#requirements)
* [Important Information](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#important-information)
* [Deployment Options](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#deployment-instructions)
  * [1. Docker Deployment Instructions](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#1-docker-deployment-instructions)
  * [2. Local Deployment Instructions](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#2-local-deployment-instructions)
* [Teardown Instructions](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#teardown-instructions)
* [Summary](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#summary)

## Requirements

To deploy the demo via this automation you need:

* A CDP tenant in Public or Private cloud.
* A CDP Workload User with Ranger policies and IDBroker Mappings configured accordingly.
* An CDE Service on version 1.21 or above.
* The Docker Custom Runtime entitlement. Please contact the CDE product or sales team to obtain the entitlement.
* A Dockerhub account. Please have your Dockerhub user and password ready.

## Important Information

The automation deploys the following to your CDE Virtual Cluster:

* A CDE Spark Job and associated CDE Resources with the purpose of creating synthetic data in Cloud Storage for each participant.
* A CDE Files Resource for Spark files shared by all participants named "Spark-Files-Shared".
* A CDE Files Resource for Airflow files shared by all participants named "Airflow-Files-Shared".
* A CDE Python Resource shared by all participants named "Python-Env-Shared".

## Deployment Options

There are two deployment options: Docker or by cloning this git repository and running the setup scripts locally. The Docker option is recommended. Please follow one of the two instruction sets below.

When setup is complete navigate to the CDE UI and validate that the job run has completed successfully. This implies that the HOL data has been created successfully in Cloud Storage.

### 1. Docker Deployment Instructions

A Docker container has been created with all necessary dependencies for HOL deployment.

```
% docker run -it pauldefusco/cde121holsetup
```

In the container's shell, modify the Jobs API URL in the CDE CLI config:

```
[cdeuser@1234567 ~]$ vi ~/.cde/config.yaml

user: <cdp_workload_username>
vcluster-endpoint: https://a1b2345.cde-abcdefg.cde-xxx.xxxxx.cloudera.site/dex/api/v1
```

Then run the deployment script with:

```
[cdeuser@1234567 ~]$ ./setup/deploy_hol.sh <docker-user> <cdp-workload-user> <number-of-participants> <storage-location>
```

For example:

```
#AWS
[cdeuser@1234567 ~]$ ./setup/deploy_hol.sh pauldefusco pauldefusco 3 s3a://goes-se-sandbox01/data
```

```
#Azure
[cdeuser@1234567 ~]$ ./setup/deploy_hol.sh pauldefusco pauldefusco 3 abfs://logs@go01demoazure.dfs.core.windows.net/data
```

### 2. Local Deployment Instructions

Clone this repository to your machine. Then run the deployment script with:

```
% ./setup/deploy_hol.sh <docker-user> <cdp-workload-user> <number-of-participants> <storage-location>
```

For example:

```
#AWS
% ./setup/deploy_hol.sh pauldefusco pauldefusco 3 s3a://goes-se-sandbox01/data
```

```
#Azure
% ./setup/deploy_hol.sh pauldefusco pauldefusco 3 abfs://logs@go01demoazure.dfs.core.windows.net/data
```

## Teardown Instructions

When you are done run this script to tear down the data in the Catalog but not in S3. That step will be handles by the GOES teardown scripts.

```
% ./teardown.sh cdpworkloaduser
```

## Summary

You can deploy an end to end CDE Demo with the provided automation. The demo executes a small ETL pipeline including Iceberg, Spark and Airflow.
