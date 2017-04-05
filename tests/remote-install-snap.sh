set +x

user=$1
host=$2
port=$3
snap=$4
tmp_dir=$5

if [ -z "$4" ]; then
	echo "No snap file specified to install, exiting"
	exit 1
fi

echo "snap=$snap"

snap_name="ubuntu-personal-store"
snap_pkg_name=`basename $snap`

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_OPTS="$SSH_OPTS -p $port $user@$host"

echo "SSH_OPTS = $SSH_OPTS"
echo "snap_name = $snap_name"
echo "snap_pkg_name = $snap_pkg_name"

scp -P $port $snap  $user@$host:~/$tmp_dir/
ssh ${SSH_OPTS} "sudo snap remove $snap_name >/dev/null"
ssh ${SSH_OPTS} "sudo snap install ~/$tmp_dir/$snap_pkg_name --dangerous --devmode"
ssh ${SSH_OPTS} "sudo snap disable $snap_name >/dev/null"
ssh ${SSH_OPTS} "sudo snap enable $snap_name >/dev/null"
# need to manually connect interfaces as snapd won't do it anymore in devmode
ssh ${SSH_OPTS} "sudo snap connect $snap_name:snapd-control"
ssh ${SSH_OPTS} "sudo snap connect $snap_name:timeserver-control"
ssh ${SSH_OPTS} "sudo snap connect $snap_name:timezone-control"
ssh ${SSH_OPTS} "sudo snap interfaces"
ssh ${SSH_OPTS} "sudo snap list"
