# CDE Demo Auto Deploy

## Objective

This git repository hosts the setup automation for the HOL. The script consists of a series of CDE CLI commands that first create synthetic data in cloud storage for each participant, and then create the shared CDE Resource by every participant.

This automation does not run the actual lab material. These are easy to create from the CDE UI and do not require automation.

## Table of Contents

* [Requirements](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#requirements)
* [Deployment Instructions](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#deployment-instructions)
  * [1. Important Information](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#1-important-information)
  * [2. Running deploy.sh](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#2-autodeploysh)
* [Summary](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_00_setup.md#summary)

## Requirements

To deploy the demo via this automation you need:

* A CDP tenant in Public or Private cloud.
* A CDP Workload User with Ranger policies and IDBroker Mappings configured accordingly.
* An CDE Service on version 1.21 or above.
* The Docker Custom Runtime entitlement. Please contact the CDE product or sales team to obtain the entitlement.
* A Dockerhub account. Please have your Dockerhub user and password ready.

## Deployment Instructions

The automation is provided is a set of CDE CLI commands which are run as a shell script. The shell script and accompanying resources are located in the setup folder.

#### 1. Important Information

The shell script deploys the following:

* A CDE Spark Job and associated CDE Resources with the purpose of creating synthetic data in Cloud Storage for each participant.
* A CDE Files Resource for Spark files shared by all participants named "Spark-Files-Shared".
* A CDE Files Resource for Airflow files shared by all participants named "Airflow-Files-Shared".
* A CDE Python Resource shared by all participants named "Python-Env-Shared".

#### 2. Run deploy.sh

You will need to run your Docker credentials and CDP Workload Password in the terminal.

When setup is complete navigate to the CDE UI and validate that the job run has completed successfully. This implies that the HOL data has been created successfully in Cloud Storage.

Run the deployment script with:

```
./setup/deploy_hol.sh <docker-user> <cdp-workload-user> <number-of-participants> <storage-location>
```

For example:

```
#AWS
./setup/deploy_hol.sh pauldefusco pauldefusco 3 s3a://goes-se-sandbox01/data
```

```
#Azure
./setup/deploy_hol.sh pauldefusco pauldefusco 3 abfs://logs@go01demoazure.dfs.core.windows.net/data
```

#### 3. teardown.sh

When you are done run this script to tear down the data in the Catalog but not in S3. That step will be handles by the GOES teardown scripts.

```
./teardown.sh cdpworkloaduser
```

## Summary

You can deploy an end to end CDE Demo with the provided automation. The demo executes a small ETL pipeline including Iceberg, Spark and Airflow.
