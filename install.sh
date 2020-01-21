git clone git@github.com:ispec-inc/kube-angular-template.git
echo -n "application name?"
read app_name
echo -n "use dev? [y/n]"
read use_dev
echo -n "use stg? [y/n]"
read use_stg
echo -n "use github action? [y/n]"

declare -a envs=()
declare -a envs=("prod")
if use_dev -eq 'y';then
envs=('dev' "${envs[@]}")
fi

if use_stg -eq 'y';then
envs=('stg' "${envs[@]}")
fi

mkdir k8s
sed -i "s/{{app_name}}/$app_name/" manifest/**
for env in envs
do
cp kube-angular-template/manifest/depolyment.yml "${env}".depolyment.yml
cp kube-angular-template/manifest/service.yml "${env}".service.yml
cp kube-angular-template/manifest/config.yml "${env}".config.yml
done
