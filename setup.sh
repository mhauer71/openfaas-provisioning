#!/bin/bash

#Functions for each infrastructure provider
digital_ocean () {
    echo "Provisioning domain $domain on $provider with $nodes nodes"
    echo "Enter your Digital Ocean Token (empty to quit): "
    read do_token
    if [[ -z "$do_token" ]]; then
        exit
    fi
    for ((i=1;i<=nodes;i++))
    do 
        echo "Creating node $prefix-$i"
        docker-machine create --driver digitalocean --digitalocean-image ubuntu-16-04-x64 --digitalocean-access-token $do_token $prefix-$i
       
    done
    exit
}
google_cloud () {
    echo "Google Cloud is not yet implemented"
    exit
}
on_premises () {
    echo "On-Premises infrastructure is not yet implemented"
    exit
}

# User selects infrastructure provider, number of nodes and domain
echo "OpenFaas Provisioning"
echo -n "Enter the domain used by your OpenFaas cluster: "
read domain
echo -n "How many nodes (max 9): "
read nodes
while [[ -n "$nodes" ]]; do
    case "$nodes" in
        -*)
            echo "Please enter a integer between 1 an 9"
            ;;
        0)
            echo "Please enter a integer between 1 an 9"
            ;;
        [0-9])
            break
            ;;
        *)
            echo "Please enter a integer between 1 an 9"
            ;;
    esac
    read -p "How many nodes (max 9): " nodes
done
echo -n "Enter the node(s) prefix (empty to use domain as prefix): "
read prefix
if [[ -z "$prefix" ]]; then
    prefix=$domain
fi
PS3='Please choose your infrastructure (only "Digital Ocean" is available at the moment): '
options=("Digital Ocean" "Google Cloud" "On-Premises" "Quit")
select provider in "${options[@]}"
do
    case $provider  in
        "Digital Ocean")
            digital_ocean $domain $provider $nodes $prefix
            ;;
        "Google Cloud")
            google_cloud $domain $provider $nodes $prefix
            ;;
        "On-Premises")
            on_premises $domain $provider $nodes $prefix
            ;;
        "Quit")
            exit
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done


#DOMAIN="$1"
#DOMAIN="${DOMAIN:-example.co}"
#sed "s/DOMAIN/$DOMAIN/g" ansible-hosts.template > ansible-hosts
#sed "s/DOMAIN/$DOMAIN/g" babyswarm.auto.tfvars.template > babyswarm.auto.tfvars


