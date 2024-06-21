# CDE Demo Auto Deploy

## Objective

This git repository hosts the data setup automation for the HOL. The script consists of a series of CDE CLI commands that create synthetic data in cloud storage for each participant.

This automation does not run the labs. These are very easy to create from the CDE UI and do not require automation.

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

The Demo includes three parts. Part 1 includes a CDE Session and a CDE Spark Job. Part 2 consists of another CDE Session with Iceberg Spark and SQL commands. Part 3 executes four Spark Iceberg jobs in an Airflow DAG.

The Spark Job in part 1 can be run as many times as needed. It wipes out the previous data saved by jobs 2-5. If an error is made in the workshop, rerunning job 1 will allow you to start from scratch.

In order to run part 3, each participant must complete part 1 and part 2. In part 1 two Spark tables are created. In part 2 the fact table (transactions) is migrated to iceberg.

#### 2. Run deploy.sh

The shell script deploys a CDE Spark Job and associated CDE Resources with the purpose of creating synthetic data in Cloud Storage for each participant.

Before running this be prepared to enter your Docker credentials and CDP Workload Password in the terminal.

When setup is complete navigate to the CDE UI and validate that the job run has completed successfully. This implies that the HOL data has been created successfully in Cloud Storage.

Run the deployment script with:

```
./setup/deploy_hol.sh <docker-user> <cdp-workload-user> <number-of-participants> <storage-location>
```

For example:

```
AWS
./setup/deploy_hol.sh pauldefusco pauldefusco 3 s3a://goes-se-sandbox01/data
```

```
Azure
./setup/deploy_hol.sh pauldefusco pauldefusco 3 abfs://logs@go01demoazure.dfs.core.windows.net/data
```

#### 3. teardown.sh

When you are done run this script to tear down the data in the Catalog but not in S3. That step will be handles by the GOES teardown scripts.

```
./teardown.sh cdpworkloaduser
```

## Summary

You can deploy an end to end CDE Demo with the provided automation. The demo executes a small ETL pipeline including Iceberg, Spark and Airflow.
