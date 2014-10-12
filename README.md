docker-solr
===========

Basic docker solr image that able to deploy your custom solr instance. Another
option is that solr instance is store inside data-only container.

Packaged instance template built on `example` instance provided by solr sources.

Usage
-----
All build/run commands aliased inside Makefile.

```bash
git clone https://github.com/krasnobaev/docker-solr
cd docker-solr
sudo make build
sudo make startdata
sudo make startimage
```

If you give [docker non-root access](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo) you will be able to run `make` without `sudo`.

ToDo's
------
- get lucene-solr sources from git, maybe
- get rid of calling svnrevision

Links
-----
[solr docker image by makuk66](https://registry.hub.docker.com/u/makuk66/docker-solr) which just starts native solr.

[same by guywithnose](https://registry.hub.docker.com/u/guywithnose/solr) but built on top of archlinux.

my [docker template](https://github.com/krasnobaev/docker-doc-template)

