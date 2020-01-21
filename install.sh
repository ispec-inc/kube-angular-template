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

declare -a envs=()
declare -a envs=("prod")
if $use_dev;then
envs=('dev' "${envs[@]}")
fi

if $use_stg;then
envs=('stg' "${envs[@]}")
fi

mkdir k8s
sed -i "s/{{app_name}}/$app_name/" manifest/deployment.yml
sed -i "s/{{app_name}}/$app_name/" manifest/service.yml
sed -i "s/{{app_name}}/$app_name/" manifest/config.yml
for env in envs
do
cp kube-angular-template/manifest/depolyment.yml k8s/"${env}".depolyment.yml
cp kube-angular-template/manifest/service.yml k8s/"${env}".service.yml
cp kube-angular-template/manifest/config.yml k8s/"${env}".config.yml
done
