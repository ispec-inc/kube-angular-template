#/bin/bash
git clone git@github.com:ispec-inc/kube-angular-template.git
read -p "application name?: " app_name
read -p "use dev? (y/N): " yn
case "$yn" in
    [yY]*) use_dev=true ;;
    *) use_dev=false ;;
esac
read -p "use stg? (y/N): " yn
case "$yn" in
    [yY]*) use_dev=true ;;
    *) use_dev=false ;;
esac

declare -a envs=("prod")
if $use_dev;then
envs+=("dev")
fi

if $use_stg;then
envs+=("stg")
fi

cp kube-angular-template/container/Dockerfile Dockerfile
cp -r kube-angular-template/nginx nginx
cp kube-angular-template/container/docker-compose.yml docker-compose.yml
sed -i "" -e "s/{{app_name}}/$app_name/" docker-compose.yml
mkdir k8s
for env in ${envs[@]}
do
mkdir k8s/${env}
cp kube-angular-template/manifest/deployment.yml k8s/"${env}"/deployment.yml
cp kube-angular-template/manifest/service.yml k8s/"${env}"/service.yml
cp kube-angular-template/manifest/config-map.yml k8s/"${env}"/config-map.yml
sed -i "" -e "s/{{app_name}}/$env-$app_name/" k8s/"${env}"/deployment.yml
sed -i "" -e "s/{{app_name}}/$env-$app_name/" k8s/"${env}"/service.yml
sed -i "" -e "s/{{app_name}}/$env-$app_name/" k8s/"${env}"/config-map.yml
done

rm -rf kube-angular-template
