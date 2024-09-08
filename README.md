# Installation d'un Cluster Hadoop avec Cloudera

## Description
Ce projet contient une série de playbooks Ansible pour installer un cluster Hadoop sous la distribution Cloudera. Chaque playbook correspond à une étape spécifique de l'installation, et ils doivent être exécutés dans un ordre précis.

## Méthodes d'installation

Il existe trois méthodes pour installer le cluster Hadoop :

### Inventory

Une fois l'infrastructure prête, remplissez le fichier `hosts.ini` qui se trouve dans le dossier `inventory` avec votre propre configuration.

## Étapes d'installation automatique

1. **Installation automatique avec un script shell :**
   Vous pouvez installer le cluster en exécutant le script `cdp_hadoop_installer.sh`, situé dans le dossier `installers`. Ce script automatise les différentes étapes d'installation.

   Pour l'exécuter, utilisez la commande suivante :
   ```bash
   ./installers/cdp_hadoop_installer.sh
   
   ou
   ```bash cd ./installers
   ./cdp_hadoop_installer.sh

2. **Installation automatique avec Makefile :**
   Une autre méthode automatique consiste à utiliser le fichier `cdp_hadoop_installer_make`, également situé dans le dossier `installers`. Ce fichier Make automatise le processus d'installation via des cibles définies.

   Pour lancer cette méthode, exécutez la commande suivante :
   ```bash
   make -f installers/cdp_hadoop_installer_make
   
   ou
   ```bash
   cd ./installers
   make -f cdp_hadoop_installer_make

## Étapes d'installation manuelle

3. **Configuration de l'inventaire :**

. **Exécution des playbooks :**
   Lancez les playbooks dans l'ordre suivant pour procéder à l'installation du cluster :

   - `1_prepare_env.yml` : Préparation de l'environnement.
   - `2_cloudera_dependencies.yml` : Installation des dépendances nécessaires pour Cloudera.
   - `3_cloudera_run_agents.yml` : Lancement des agents Cloudera sur les nœuds.
   - `4_database_install_server.yml` : Installation du serveur de base de données.
   - `5_cloudera_nodes_add_connector.yml` : Ajout du connecteur de base de données aux nœuds.
   - `6_cloudera_install_server.yml` : Installation du serveur Cloudera Manager.
   - `7_cloudera_run_server.yml` : Démarrage du serveur Cloudera Manager.
   - `8_cloudera_create_cluster_part1.yml` : Création initiale du cluster (partie 1).
   - `9_cloudera_agents_restart.yml` : Redémarrage des agents Cloudera.
   - `10_cloudera_create_cluster_part2.yml` : Finalisation de la création du cluster (partie 2).
   - `11_cloudera_add_services.yml` : Ajout des services Hadoop (HDFS, YARN, Kafka, Hive, Hue, etc.).

## Remarques

- Assurez-vous que tous les paramètres sont correctement configurés dans les fichiers de variables avant de lancer les playbooks.
- Chaque étape est critique pour le bon fonctionnement du cluster, suivez l'ordre indiqué.


__________________________________________________________________________________________________________________________________


# Hadoop Cluster Installation with Cloudera

## Description
This project contains a series of Ansible playbooks for installing a Hadoop cluster using the Cloudera distribution. Each playbook corresponds to a specific step of the installation and must be executed in a specific order.

## Installation Methods

There are three methods to install the Hadoop cluster:

### Inventory

Once the infrastructure is ready, fill out the `hosts.ini` file located in the `inventory` folder with your own configuration.

## Automated Installation Steps

1. **Automated Installation with a Shell Script:**
   You can install the cluster by running the `cdp_hadoop_installer.sh` script, located in the `installers` folder. This script automates the various installation steps.

   To execute it, use the following command:
   ```bash
   ./installers/cdp_hadoop_installer.sh
   
   or
   ```bash
   cd ./installers
   ./cdp_hadoop_installer.sh

2. **Automated Installation with Makefile:**
   Another automated method is to use the `cdp_hadoop_installer_make` Makefile, also located in the `installers` folder. This Makefile automates the installation process through defined targets.

   To execute this method, use the following command:
   ```bash
   make -f installers/cdp_hadoop_installer_make
   
   or

   ```bash
   cd ./installers
   make -f cdp_hadoop_installer_make

## Manual Installation Steps

3. **Inventory Configuration:**

. **Running the Playbooks:**
   Execute the playbooks in the following order to proceed with the cluster installation:

   - `1_prepare_env.yml`: Environment preparation.
   - `2_cloudera_dependencies.yml`: Installation of necessary Cloudera dependencies.
   - `3_cloudera_run_agents.yml`: Starting Cloudera agents on the nodes.
   - `4_database_install_server.yml`: Installation of the database server.
   - `5_cloudera_nodes_add_connector.yml`: Adding the database connector to the nodes.
   - `6_cloudera_install_server.yml`: Installation of the Cloudera Manager server.
   - `7_cloudera_run_server.yml`: Starting the Cloudera Manager server.
   - `8_cloudera_create_cluster_part1.yml`: Initial cluster creation (part 1).
   - `9_cloudera_agents_restart.yml`: Restarting Cloudera agents.
   - `10_cloudera_create_cluster_part2.yml`: Finalizing cluster creation (part 2).
   - `11_cloudera_add_services.yml`: Adding Hadoop services (HDFS, YARN, Kafka, Hive, Hue, etc.).

## Notes

- Ensure that all parameters are correctly configured in the variable files before running the playbooks.
- Each step is critical for the proper functioning of the cluster; follow the specified order.
