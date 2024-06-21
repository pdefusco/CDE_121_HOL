#!/bin/sh

docker_user=$1
cde_user=$2
max_participants=$3
cdp_data_lake_storage=$4

cde_user_formatted=${cde_user//[-._]/}
d=$(date)
fmt="%-30s %s\n"

echo "##########################################################"
printf "${fmt}" "CDE HOL deployment launched."
printf "${fmt}" "demo launch time:" "${d}"
printf "${fmt}" "performed by CDP User:" "${cde_user}"
printf "${fmt}" "performed by Docker User:" "${docker_user}"
echo "##########################################################"

echo "CREATE DOCKER RUNTIME RESOURCE"
echo "Create CDE Credential docker-creds-"$cde_user"-mkt-hol"
cde credential create --name docker-creds-$cde_user"-mkt-hol" --type docker-basic --docker-server hub.docker.com --docker-username $docker_user
echo "Create CDE Docker Runtime dex-spark-runtime-"$cde_user
cde resource create --name dex-spark-runtime-$cde_user --image pauldefusco/dex-spark-runtime-3.2.3-7.2.15.8:1.20.0-b15-great-expectations-data-quality --image-engine spark3 --type custom-runtime-image

echo "CREATE FILE RESOURCE"
echo "Create Resource mkt-hol-setup-"$cde_user
cde resource create --name mkt-hol-setup-$cde_user
echo "Upload utils.py and setup.py to mkt-hol-setup-"$cde_user
cde resource upload --name mkt-hol-setup-$cde_user --local-path utils.py --local-path setup.py
echo "CREATE SETUP JOB"
echo "Delete job mkt-hol-setup-"$cde_user
cde job delete --name mkt-hol-setup-$cde_user
echo "Create job mkt-hol-setup-"$cde_user
cde job create --name mkt-hol-setup-$cde_user --type spark --mount-1-resource mkt-hol-setup-$cde_user --application-file setup.py --runtime-image-resource-name dex-spark-runtime-$cde_user
echo "Run job mkt-hol-setup-"$cde_user
cde job run --name mkt-hol-setup-$cde_user --arg $max_participants --arg $cdp_data_lake_storage

function loading_icon() {
  local loading_animation=( '—' "\\" '|' '/' )

  echo -n "${loading_message} "

  tput civis
  trap "tput cnorm" EXIT

  while true; do
    job_status=$(cde run list --filter 'job[like]%mkt-hol-setup-'$cde_user | jq -r '.[].status')
    if [[ $job_status=="succeeded" ]]; then
      echo "job has completed"
      break
    else
      for frame in "${loading_animation[@]}" ; do
        printf "%s\b" "${frame}"
        sleep 1
      done
    fi
  done
  printf " \b\n"
}

loading_icon "Table Setup in Progress"

echo "CREATE SPARK FILES SHARED RESOURCE"

cde resource create --type files --name Spark-Files-Shared
cde resource upload --name Spark-Files-Shared --local-path cde_spark_jobs/parameters.conf --local-path cde_spark_jobs/utils.py

echo "CREATE AIRFLOW FILES SHARED RESOURCE"

cde resource create --type files --name Airflow-Files-Shared
cde resource upload --name Airflow-Files-Shared --local-path cde_airflow_jobs/my_file.txt

echo "CREATE PYTHON ENVIRONMENT SHARED RESOURCE"

cde resource create --type python-env --name Python-Env-Shared
cde resource upload --name Python-Env-Shared --local-path cde_spark_jobs/requirements.txt


e=$(date)

echo "##########################################################"
printf "${fmt}" "CDE ${cde_demo} demo deployment completed."
printf "${fmt}" "completion time:" "${e}"
printf "${fmt}" "please visit CDE Job Runs UI to view in-progress demo"
echo "##########################################################"
