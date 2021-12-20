# site-search

The purpose of this project is to create a free, light-weight search engine for any Gatsby website hosted by Github Pages. For now, the search documents are scraped using Python and stored in an Elasticsearch database that is hosted on a single, free tier e2-instance on GCP. ReactiveSearch is used for its pre-built search UI components, which allow users to interact and query notes and blog posts. In theory, any search database used on a small website could be able to run on the e2-instance on GCP. These search engines may include Typesense, Lucene, etc.

To create and host a search engine on GCP for a website hosted on Github Pages, we need to do the following steps:
1. Create a free tier account on GCP
2. Instantiate a micro e2-instance (with Ubuntu)
4. Install Docker on the e2-instance
5. Install and run Elasticsearch on the e2-instance
6. Run and schedule Python code for scraping our website and ingesting blog posts and notes into Elasticsearch
7. Implement ReactiveSearch components in our site's code for querying our site's posts and notes saved in Elasticsearch
8. Configure a firewall on GCP (using UFW on Ubuntu)

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

# Installing Elasticsearch on an Ubuntu E2-Instance

1. Update all existing packages on the e2-instance

- Steps for using ElasticSearch to store site data:
    - First, crawl site documents and add to ES DB, then add ReactiveSearch to site code
    - To crawl, create a web crawler in Python to read all pages in /notes/ and /blog/ URL address
    - https://www.elastic.co/site-search/
- Example of using ElasticSearch:
    - https://www.youtube.com/watch?v=jDYeqCkAN_Y&ab_channel=howCode
- Ingesting Data into ElasticSearch:
    - https://www.elastic.co/guide/en/cloud/current/ec-getting-started-python.html
- Installing ElasticSearch on GCP instance:
    - https://meetanshi.com/blog/install-elasticsearch-on-google-cloud/
- Example Part 1 of connecting ReactiveSearch with ElasticSearch:
    - https://www.youtube.com/watch?v=RtxQDMIVK2g&ab_channel=appbaseio
- Example Part 2 of connecting data to ReactiveSearch:
    - https://medium.appbase.io/how-to-build-a-movie-search-app-with-react-and-elasticsearch-2470f202291c
- Other examples of ReactiveSearch applications:
    - https://opensource.appbase.io/reactivesearch/quickstart

- GCP URL: https://console.cloud.google.com/compute/instances?onCreate=true&cloudshell=false&organizationId=0&project=site-search-typesense&supportedpurview=project
- Github Project: https://github.com/dkharazi/site-search

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
$ mkdir /home/dkharazif/typesense-server-data ; cd /home/dkharazif/typesense-server-data
$ # 5. Run search service as Typesense container
$ sudo nohup docker run -i -p 8108:8108 -v/home/dkharazif/typesense-server-data/:/data typesense/typesense:0.15.0 --data-dir /data --api-key=xyz --listen-port 8108 --enable-cors > typesense-server-data.log &
$ # 6. Create shell script for purging logs
$ touch purge-logs.sh
$ # 7. Open crontab
$ crontab -e
$ # 8. Schedule shell script at 2AM every day
$ 0 2 * * * sh /home/dkharazif/typesense-server-data/purge-logs.sh

$ ###
$ ### OTHER USEFUL COMMANDS
$ ###
$
$ # Verify search engine service is running in docker container
$ sudo docker ps
$ # Verify which port docker container is running on
$ sudo netstat -nlp | grep 8108
```

For any additional information about downloading `npm` on an Ubuntu system, read the walkthrough outlined in [this article](https://linuxize.com/post/how-to-install-node-js-on-ubuntu-20-04/). For additional steps about installing Gatsby-related packages and/or Typesense in an Ubuntu environment, please refer to [this article](https://medium.com/swlh/building-a-search-bar-for-your-gatsbyjs-site-with-typesense-3e277dc33942).
