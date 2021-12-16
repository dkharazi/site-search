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
