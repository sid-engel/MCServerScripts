#!/usr/bin/env bash

#=============================
# This script wil shut down the amp instance, renames the end world folder, adds a new random generated seed to the server.properties file, starts the instance back up, then optionally compresses the old folder and optionally keeps the uncompressed version.
#=============================

#============================
# NOTE: AMP's API does not like how we do this. Later down the road, I will be changing the seed change function to go through AMP's API. However, this format of the script is easy to adapt to other server systems like Pterodactyl and Multicraft.

# Also, to automate this... All you need to do is schedule it as a cron job.
#============================


# Variable Declaration
# These are here to making executing the script on different Instances easier...
InstanceName='SidsTestServer'
InstanceDirectory='/home/amp/.ampdata/instances/SidTestServer/Minecraft'
ShortSleep='sleep 3'
AmpUsername='amp'
Date=$(date +%F)
OldEndName='world_the_end_OLD'
RandomSeedGenerator=$(shuf -i 10000000000-99999999999 -n1)

# At least one of these needs to be true
KeepUncompressedFolder=true
CreateCompressedCopy=false

# Header/Welcome Script Message.
echo ===========================================
echo "Welcome To Sids End Reset Script."
echo "Find the defined variables below:"
echo "Amp Username: ${AmpUsername}"
echo "Instance Name: ${InstanceName}"
echo "Instance Directory: ${InstanceDirectory}"
echo "Old End Name: ${OldEndName}"
echo "Random Seed Number: ${RandomSeedGenerator}"
echo ===========================================

$ShortSleep
# Commands are being executed as the amp user, as it's the only user with permissions to the ampinstmgr tool and file access to the Instances.

echo Stopping Server+Instance...
sudo su -c "ampinstmgr StopInstance $InstanceName" $AmpUsername
$ShortSleep
echo Server+Instance Stopped.

echo "Changing Level Seed In server.properties..."
sudo su -c "sed -i 's/level-seed=.*/level-seed=$RandomSeedGenerator/g' $InstanceDirectory/server.properties" $AmpUsername
echo "Level Seed Changed To: ${RandomSeedGenerator}."

echo "Renaming End Folder To ${OldEndName}..." 
sudo su -c "mv $InstanceDirectory/world_the_end $InstanceDirectory/$OldEndName" $AmpUsername
$ShortSleep
echo "End Folder Renamed To ${OldEndName}."

echo "Starting Server+Instance(A New End Folder Will Generate)..."
sudo su -c "ampinstmgr RestartInstance $InstanceName" amp
$ShortSleep
echo "Server+Instance Started."

$ShortSleep

# Create Compressed Copy If Enabled.
if [ "$CreateCompressedCopy" = true ];
then
	echo "Compressing ${OldEndName}..."
	sudo su -c "tar -cvzf ${InstanceDirectory}/BACKUP_world_the_end_${Date}.tar.gz ${InstanceDirectory}/${OldEndName}" amp
	echo "${OldEndName} Compressed And Saved As world_the_end_${Date} in ${InstanceDirectory}."
else
	echo "Compressing of ${OldEndName} is disabled. Not compressing."
fi

# Delete Uncompressed Folder If Enabled.
if [ "$KeepUncompressedFolder" = true ];
then
	echo "Keeping Uncompressed Folder."
else
	echo "Removing Uncompressed Folder..."
	sudo su -c "rm -r ${InstanceDirectory}/${OldEndName}" amp
	echo "Uncompressed Folder Removed."
fi
echo "Script Ran Successfully. Exiting..."

$ShortSleep
