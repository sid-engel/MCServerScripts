#!/usr/bin/env bash

# This script can easilly be adapted to work with different server managers. AMP, Multicraft, Pterodactyl, etc...
# To set up automation make it a cronjob. Be sure to dry-run it a few times to make sure that it's functioning.

# Variable Declaration
# These are here to making executing the script on different Instances easier and to allow you to change the name of the world folder...
InstanceName='SidsTestServer'
InstanceDirectory='/home/amp/.ampdata/instances/SidsTestServer/Minecraft'
ShortSleep='sleep 3'
AmpUsername='amp'
Date=$(date +%F)
OldEndName='world_the_end_OLD'
RandomSeedGenerator=$(shuf -i 10000000000-99999999999 -n1)

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