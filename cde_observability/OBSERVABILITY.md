### Observability Setup Instructions

#### 1. Run autodeploy.sh

Run the autodeploy script with:

```
./auto_deploy_hol.sh pauldefusco pauldefusco 1 s3a://goes-se-sandbox01/data
```

Before running this be prepared to enter your Docker credentials in the terminal. Then, you can follow progress in the terminal output. The pipeline should deploy within three minutes. When setup is complete navigate to the CDE UI and validate that the demo has been deployed. By now the setup_job should have completed and the airflow_orchestration job should already be in process.
