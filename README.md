# docker-svn
Docker image providing SVN services over HTTP using an Alpine Linux base.

## Container Setup

1. Pull the Docker image edigeronimo/svn
2. Create a container mapping your data location to `/home/svn`. The remaining instructions assume you named the container `svn-server`, but you can call it whatever you want.
3. Map a port to expose SVN on your host to port 80 on the container. Pick a free port over 1000. We'll use 3080 in the instructions.

## File Layout
### /home/svn/users/permissions/svnauthz.conf

This file contains permissions for all your repositories. You can grant a user access to all repositories like this:

```
[/]
username = rw
```

You can grant a user access to a specific repository like this:

```
[reponame:/]
username = rw
```

You can grant a user access to only a path inside a repository like this:

```
[reponame:/trunk/subpath]
username = rw
```

You can grant read-only access by using `r` instead of `rw`.

### /home/svn/users/passwords

This is a standard Apache htpasswd file. Manage this file with the htpasswd command.

If you do not have a passwords file already, use the following command to create the file and add your first user:

```
docker exec -it svn-server htpasswd -c /home/svn/users/passwords username
```

If you already have a passwords file and would like to add a user or change a user's password, use the following command:

```
docker exec -it svn-server htpasswd /home/svn/users/passwords username
```

### /home/svn/repos

Your repositories will live under this path. Inside this directory there will be one directory per repository.

## Creating Repositories

To create a new repository, run the following command, replacing `repository_name` with the name you would like to use.

```
docker exec -t svn-server svnadmin create /home/svn/repos/repository_name
```

## Setting File Permissions

The SVN service runs as the user `apache`. The files it needs to use need to have the appropriate permissions for that user. We can ensure that with the following commands:

```
docker exec -t svn-server chown -R apache /home/svn
docker exec -t svn-server chmod u+rw /home/svn
```

If you create a new repository after the initial setup, you will need to make sure the new repository also has these permissions. You can use the following commands to update just the new repository:

```
docker exec -t svn-server chown -R apache /home/svn/repos/repository_name
docker exec -t svn-server chmod u+rw /home/svn/repos/repository_name
```

## Start Your Container

You should be ready to run! Start the Docker image.

## Accessing SVN

Adjust the following URL with the hostname of your server and the appropriate port, then try it out in a web browser:

```
http://servername:3080/svn
```

You should now see a listing of all the repositories on your server.

To check out a repository, use a URL similar to the one below in your SVN client of choice:

```
http://servername:3080/svn/repository_name
```