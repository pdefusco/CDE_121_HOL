# Job Deployment & Orchestration

* [Lab 3: Create CDE Resources and Spark Jobs](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_02_deployment.md#lab-3-create-cde-resources-and-run-cde-spark-job)
* [Lab 4: Orchestrate Spark Pipeline with Airflow](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_02_deployment.md#lab-4-orchestrate-spark-pipeline-with-airflow)
* [A Brief Introduction to Apache Airflow](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_02_deployment.md#a-brief-introduction-to-airflow)
* [Summary](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_02_deployment.md#summary)
* [Useful Links and Resources](https://github.com/pdefusco/CDE_121_HOL/blob/main/step_by_step_guides/english/part_02_deployment.md#useful-links-and-resources)


### Lab 3: Create CDE Resources and Spark Jobs

Up until now you used Sessions to interactively explore data. CDE also allows you to run Spark Application code in batch as a CDE Job. There are two types of CDE Jobs: Spark and Airflow. In this lab we will create an Airflow Job in order to orchestrate three Spark Jobs.

The CDE Job is an abstraction over the Spark Submit or Airflow DAG. With the CDE Spark Job you can create a reusable, modular definition that is saved in the cluster and can be modified in the CDE UI (or via the CDE CLI and API) at every run. CDE stores the job definition for each run in the Job Runs UI so you can go back and refer to it long after your job has completed.

Furthermore, CDE allows you to directly store artifacts such as Python files, Jars and other dependencies, or create Python environments and Docker containers in CDE as "CDE Resources". Once created in CDE, Resources are available to CDE Jobs as modular components of the CDE Job definition which can be swapped and referenced by a particular job run as needed.

These features dramatically reduce the amount of effort otherwise required in order to manage and monitor Spark and Airflow Jobs. By providing a unified pane over all your runs along with a clear view of all associated artifacts and dependencies, CDE streamlines Spark & Airflow operations.

##### Familiarize Yourself with the Code

The Spark Application scripts and configuration files used in these labs are available at the [CDE Spark Jobs folder in the HOL git repository](https://github.com/pdefusco/CDE_121_HOL/tree/main/cde_spark_jobs). Before moving on to the next step, please familiarize yourself with the code in the "01_Lakehouse_Bronze.py", "002_Lakehouse_Silver.py", "003_Lakehouse_Gold.py", "utils.py",  "parameters.conf" files.

The Airflow DAG script is available in the [CDE Airflow Jobs folder in the HOL git repository](https://github.com/pdefusco/CDE_121_HOL/tree/main/cde_airflow_jobs). Please familiarize yourself with the code in the "airflow_dag.py" script as well.

* The "01_Lakehouse_Bronze.py" PySpark Application createas Iceberg Customer and Credit Card transactions tables from different file formats. "utils.py" contains a the Python method to transform multiple dataframe columns at once utilized by the "01_Lakehouse_Bronze.py" script.

* "parameters.conf" contains a configuration variable that is passed to each of the three PySpark scripts. Storing variables in a Files Resource is a commonly used method by CDE Data Engineers to dynamically parameterize scripts and pass hidden credentials at runtime.

* "02_Lakehouse_Silver.py" loads the data from the new transaction json file, validates it with Great Expectations, and appends the data to the Transactions table.

* "03_Lakehouse_Gold.py" loads the data from the Transactions table filtering in terms of Iceberg snapshot ID in order to only reflect the latest batch. Then it joins it with the customer table and uses a PySpark UDF to filter customers in terms of distance to the transaction location. Finally, it creates a Gold Layer table in order to provide curated access to Business analysts and other authorized stakeholders.

* "airflow_dag.py" orchestrates the Data Engineering pipeline. First an AWS S3 bucket is created; a simple file "my_file.txt" is read from a CDE Files Resource and written to the S3 bucket. Successively the three CDE Spark Jobs discussed above are executed in order to create a Lakehouse Gold Layer table.

##### Create CDE Repository

Git repositories allow teams to collaborate, manage project artifacts, and promote applications from lower to higher environments. CDE supports integration with Git providers such as GitHub, GitLab, and Bitbucket to synchronize job runs with different versions of your code.

In this step you will create a CDE Repository in order to clone the PySpark scripts containing the Application Code for your CDE Spark Job.

From the Main Page click on "Repositories" and then the "Create Repository" blue icon.

![alt text](../../img/part3-repos-1.png)

Use the following parameters for the form:

```
Repository Name: CDE_Repo_userxxx
URL: https://github.com/pdefusco/CDE_121_HOL.git
Branch: main
```

![alt text](../../img/part3-repos-2.png)

All files from the git repository are now stored in CDE as a CDE Repository. Each participant will have their own CDE repository.

![alt text](../../img/part3-repos-3.png)

##### Create CDE Files Resource

A resource in CDE is a named collection of files used by a job or a session. Resources can include application code, configuration files, custom Docker images, and Python virtual environment specifications (requirements.txt). CDE Data Engineers leverage Files Resources in order to store files and other job dependencies in CDE, and finally associate them with Job Runs.

A CDE Resource of type "Files" containing the "parameters.conf" and "utils.py" files named "Spark_Files_Resource" has already been created for all participants.

##### Create CDE Python Environment Resource

A CDE Resource of type "Python" built with the requirements.txt file and named "Python_Resource" has already been created for all participants. The requirements.txt includes the list of Python packages installed in it, which will be leveraged by the Job Run when it is attached to it.

For this lab we included Great Expectations, a popular Data Quality and Validation framwork.

##### Create CDE Spark Job

Now that you are familiar with CDE Repositories and Resources you are ready to create your first CDE Spark Job.

Navigate to the CDE Jobs tab and click on "Create Job". The long form loaded to the page allows you to build a Spark Submit as a CDE Spark Job, step by step.

Enter the following values without quotes into the corresponding fields. Make sure to update the username with your assigned user wherever needed:

```
* Job Type: Spark
* Name: 001_Lakehouse_Bronze_userxxx
* File: Select from Repository -> "cde_spark_jobs/001_Lakehouse_Bronze.py"
* Arguments: userxxx #e.g. user002
* Advanced Options - Resources: Spark_Files_Resource
* Advanced Options - Repositories: CDE_Repo_userxxx e.g. CDE_Repo_user002
* Compute Options - increase "Executor Cores" and "Executor Memory" from 1 to 2.
```

Finally, save the CDE Job by clicking the "Create" icon. ***Please do not select "Create and Run".***

![alt text](../../img/new_spark_job_1.png)

![alt text](../../img/new_spark_job_2.png)

Repeat the process for the remaining PySpark scripts:

Lakehouse Silver Spark Job:

```
* Job Type: Spark
* Name: 002_Lakehouse_Silver_userxxx
* File: Select from Repository -> "002_Lakehouse_Silver.py"
* Arguments: userxxx #e.g. user002
* Python Environment: Python_Resource
* Advanced Options - Resources: Spark_Files_Resource
* Advanced Options - Repositories: CDE_Repo_userxxx e.g. CDE_Repo_user002
```

Lakehouse Gold Spark Job:

```
* Job Type: Spark
* Name: 003_Lakehouse_Gold_userxxx
* File: Select from Repository -> "003_Lakehouse_Gold.py"
* Arguments: userxxx #e.g. user002
* Advanced Options - Resources: Spark_Files_Resource
* Advanced Options - Repositories: CDE_Repo_userxxx e.g. CDE_Repo_user002
```

Again, ***please create but do not run the jobs!***

![alt text](../../img/spark_job_create.png)


### Lab 4: Orchestrate Spark Pipeline with Airflow

In this lab you will build a pipeline of Spark Jobs to load a new batch of transactions, join it with customer PII data, and create a table of customers who are likely victims of credit card fraud including their email address and name. The entire workflow will be orchestrated by Apache Airflow.

### A Brief Introduction to Airflow

Apache Airflow is a platform to author, schedule and execute Data Engineering pipelines. It is widely used by the community to create dynamic and robust workflows for batch Data Engineering use cases.

The main characteristic of Airflow workflows is that all workflows are defined in Python code. The Python code defining the worflow is stored as a collection of Airflow Tasks organized in a DAG. Tasks are defined by built-in opearators and Airflow modules. Operators are Python Classes that can be instantiated in order to perform predefined, parameterized actions.

CDE embeds Apache Airflow at the CDE Virtual Cluster level. It is automatically deployed for the CDE user during CDE Virtual Cluster creation and requires no maintenance on the part of the CDE Admin. In addition to the core Operators, CDE supports the CDEJobRunOperator and the CDWOperator in order to trigger Spark Jobs. and Datawarehousing queries.

##### Create Airflow Files Resource

Just like CDE Spark Jobs, Airflow jobs can leverage CDE Files Resources in order to load files including datasets or runtime parameters. A CDE Files Resource named "Airflow_Files_Resource" containing the "my_file.txt" has already been created for all participants.

##### Create Airflow Job

Open the "004_airflow_dag.py" script located in the "cde_airflow_jobs" folder. Familiarize yourself with the code an notice:

* The Python classes needed for the DAG Operators are imported at the top. Notice the CDEJobRunOperator is included to run Spark Jobs in CDE.
* The "default_args" dictionary includes options for scheduling, setting dependencies, and general execution.
* Three instances of the CDEJobRunOperator obect are declared. These reflect the three CDE Spark Jobs you created above.
* Finally, at the bottom of the DAG, Task Dependencies are declared. With this statement you can specify the execution sequence of DAG tasks.

Download the file from [this URL](https://github.com/pdefusco/CDE_121_HOL/tree/main/cde_airflow_jobs) to your local machine. Open it in your editor of choice and edit the username variable at line 52.

Then navigate to the CDE Jobs UI and create a new CDE Job. Select Airflow as the Job Type. Select the "004_airflow_dag.py" script and elect to create a new Files Resource named after yourself in the process. Finally, add the Files Resource dependency where you loaded "my_file.txt".  

![alt text](../../img/new_airflow_job_1.png)

![alt text](../../img/new_airflow_job_2.png)

Monitor the execution of the pipeline from the Job Runs UI. Notice an Airflow Job will be triggered and successively the three CDE Spark Jobs will run one by one.

While the job is in-flight open the Airflow UI and monitor execution.

![alt text](../../img/new_airflow_job_3.png)


### Summary

Cloudera Data Engineering (CDE) is a serverless service for Cloudera Data Platform that allows you to submit batch jobs to auto-scaling virtual clusters. CDE enables you to spend more time on your applications, and less time on infrastructure.

In these labs you improved your code for reusability by modularizing your logic into functions, and stored those functions as a util in a CDE Files Resource. You leveraged your Files Resource by storing dynamic variables in a parameters configurations file and applying a runtime variable via the Arguments field. In the context of more advanced Spark CI/CD pipelines both the parameters file and the Arguments field can be overwritten and overridden at runtime.

You then used Apache Airflow to not only orchestrate these three jobs, but execute them in the context of a more complex data engineering pipeline which touched resources in AWS. Thanks to Airflow's large ecosystem of open source providers, you can also operate on external and 3rd party systems.

Finally, you ran the job and observed outputs in the CDE Job Runs page. CDE stored Job Runs, logs, and associated CDE Resources for each run. This provided you real time job monitoring and troubleshooting capabilities, along with post-execution storage of logs, run dependencies, and cluster information. You will explore Monitoring and Observability in more detail in the next labs.


### Useful Links and Resources

* [Working with CDE Files Resources](https://community.cloudera.com/t5/Community-Articles/Working-with-CDE-Files-Resources/ta-p/379891)
* [Efficiently Monitoring Jobs, Runs, and Resources with the CDE CLI](https://community.cloudera.com/t5/Community-Articles/Efficiently-Monitoring-Jobs-Runs-and-Resources-with-the-CDE/ta-p/379893)
* [Working with CDE Spark Job Parameters in Cloudera Data Engineering](https://community.cloudera.com/t5/Community-Articles/Working-with-CDE-Spark-Job-Parameters-in-Cloudera-Data/ta-p/380792)
* [How to parse XMLs in CDE with the Spark XML Package](https://community.cloudera.com/t5/Community-Articles/How-to-parse-XMLs-in-Cloudera-Data-Engineering-with-the/ta-p/379451)
* [Spark Geospatial with Apache Sedona in CDE](https://community.cloudera.com/t5/Community-Articles/Spark-Geospatial-with-Apache-Sedona-in-Cloudera-Data/ta-p/378086)
* [Automating Data Pipelines Using Apache Airflow in CDE](https://docs.cloudera.com/data-engineering/cloud/orchestrate-workflows/topics/cde-airflow-dag-pipeline.html)
* [Using CDE Airflow](https://github.com/pdefusco/Using_CDE_Airflow)
* [Airflow DAG Arguments Documentation](https://airflow.apache.org/docs/apache-airflow/stable/tutorial.html#default-arguments)
* [Exploring Iceberg Architecture](https://github.com/pdefusco/Exploring_Iceberg_Architecture)
* [Enterprise Data Quality at Scale in CDE with Great Expectations and CDE Custom Runtimes](https://community.cloudera.com/t5/Community-Articles/Enterprise-Data-Quality-at-Scale-with-Spark-and-Great/ta-p/378161)
