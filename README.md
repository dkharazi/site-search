# site-search

The purpose of this project is to create a free, light-weight search engine for any Gatsby website hosted by Github Pages. For now, the search engine is built using Typesense and hosted on a single free tier e2-instance on GCP. In theory, any search engine used on a small website should be able to run on the e2-instance on GCP. These search engines may include Elasticsearch, Lucene, etc.

To create and host a search engine on GCP for a website hosted on Github Pages, we need to do the following steps:
1. Create a free tier account on GCP
2. Instantiate a micro e2-instance (with Ubuntu)
4. Install Docker on the e2-instance
5. Install the Typesense plugin for Gatsby on the e2-instance
6. Start a Typesense server on the e2-instance
7. Configure a firewall (using UFW on Ubuntu)

# Installing Docker on an Ubuntu E2-Instance

1. Update all existing packages on the e2-instance
2. Install pre-requisite packages for letting `apt` use packages over HTTPS
3. Add the GPG key for the official Docker repository to the system
4. Add the Docker repository to `apt` resources
5. Ensure the installation comes from the official Docker repo, rather than the default Ubuntu repo
6. Install Docker CE

```sh
$ ###
$ ### COMMANDS FOR INSTALLING DOCKER
$ ###
$ 
$ # 1. Update all existing packages on the e2-instance
$ sudo apt update
$ # 2. Install pre-requisite packages
$ sudo apt install apt-transport-https ca-certificates curl software-properties-common
$ # 3. Add the GPG key to the system
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ # 4. Add the Docker repository to `apt` resources
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
$ # 5. Ensure the installation comes from the official Docker repo
$ apt-cache policy docker-ce
$ # 6. Install Docker CE
$ sudo apt install docker-ce
$
$ ###
$ ### OTHER USEFUL COMMANDS
$ ###
$
$ # Print if docker service is running
$ sudo systemctl status docker
$ # Stop docker service
$ sudo service docker stop
$ # Start docker service
$ sudo service docker start
$ # Print list of running containers
$ sudo docker ps
```
For any additional information about downloading Docker, read the detailed steps and overview found in [this article](https://medium.com/swlh/building-a-search-bar-for-your-gatsbyjs-site-with-typesense-3e277dc33942). For more recent, up-to-date information about downloading Docker on Ubuntu machines, please refer to the [official Docker installation docs](https://docs.docker.com/engine/install/ubuntu/).

# Run Typesense Service on an Ubuntu E2-Instance

1. Update all existing packages on the e2-instance
2. Install Node.js and npm
3. Verify the installation by printing the installed Node.js version
4. Create directory for Typesense search service
5. Run search service as Typesense container in daemon mode, while directing output to log file
6. Create shell script `purge-logs.sh` for purging logs to save space
   - Copy contents from `purge-logs.sh` in repo to this file
7. Open crontab
8. Schedule shell script for purging log file in crontab at 2AM every day

```sh
$ ###
$ ### COMMANDS FOR RUNNING TYPESENSE SERVICE
$ ###
$ 
$ # 1. Update all existing packages on the e2-instance
$ sudo apt update
$ # 2. Install Node.js and npm
$ sudo apt install nodejs npm
$ # 3. Verify the installation
$ sudo nodejs --version
$ # 4. Create directory for Typesense search service
$ mkdir /home/dkharazif/typesense-server-data
$ # 5. Run search service as Typesense container
$ sudo nohup docker run -i -p 8108:8108 -v/home/dkharazif/typesense-server-data/:/data typesense/typesense:0.15.0 --data-dir /data --api-key=xyz --listen-port 8108 --enable-cors > typesense-server-data.log &
$ # 6. Create shell script for purging logs
$ touch purge-logs.sh
$ # 7. Open crontab
$ crontab -e
$ # 8. Schedule shell script at 2AM every day
$ 0 2 * * * sh /home/dkharazif/typesense-server-data/purge-logs.sh
```

For any additional information about downloading `npm` on an Ubuntu system, read the walkthrough outlined in [this article](https://linuxize.com/post/how-to-install-node-js-on-ubuntu-20-04/). For additional steps about installing Gatsby-related packages and/or Typesense in an Ubuntu environment, please refer to [this article](https://medium.com/swlh/building-a-search-bar-for-your-gatsbyjs-site-with-typesense-3e277dc33942).
