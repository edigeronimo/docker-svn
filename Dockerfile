# Alpine Linux with s6 service management
FROM alpine:3.19.1

	# Install Apache2 + SVN support, which requires WebDAV
	# Install svn
	# Create required folders
	# Create the authentication file for http access
RUN apk add --no-cache apache2 apache2-utils apache2-webdav mod_dav_svn &&\
	apk add --no-cache subversion &&\
	mkdir -p /run/apache2/ &&\
	mkdir /home/svn/

# Add WebDav configuration
ADD dav_svn.conf /etc/apache2/conf.d/dav_svn.conf

# Set HOME in non /root folder
ENV HOME /home

# Expose ports
# HTTP is on 80
# HTTPS is on 443. We could support it, but we'd need to set up certificates
# 3690 is SVN protocol. It's a different server with different security, so we're not supporting it.
EXPOSE 80

# Start apache
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
