### Observability Setup Instructions

#### 1. Run autodeploy.sh

Before running beware that autodeploy.sh assumes you have a working installation of the CDE CLI on your local machine.

Be prepared to enter your Docker credentials in the terminal. Then, monitor progress in the terminal or in the CDE Job Runs UI. The setup job can take a while to deploy, depending on how much data you create.

Run the autodeploy script with:

```
./auto_deploy_obs.sh <docker-username> <cdp-username> <number-of-participants> <cdp-storage-location> <number-of-rows>
```

For example the following command will 100,000 rows of data in the sandbox environment.

```
./auto_deploy_obs.sh pauldefusco pauldefusco 1 s3a://goes-se-sandbox01/data 100000
```


./auto_deploy_obs.sh pauldefusco pauldefusco 1 s3a://cde-lab-buk-7f51495d/data 100
