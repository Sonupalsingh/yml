#!/bin/bash

# Variables
VHOST_CONFIG="/etc/httpd/conf.d/puneet.conf"
DOCUMENT_ROOT="/var/www/puneet"
SERVER_NAME="puneet.example.com"
SERVER_ALIAS="puneet.com"
SSL_CERT="/etc/ssl/certs/mydomain.crt"
SSL_KEY="/etc/ssl/private/mydomain.key"
ACCESS_LOG="/var/log/httpd/puneet_log"
ERROR_LOG="/var/log/httpd/puneet_error_log"

# Create Document Root Directory if it doesn't exist
if [ ! -d "$DOCUMENT_ROOT" ]; then
	    mkdir -p "$DOCUMENT_ROOT"
	        echo "<html><h1>Welcome to $SERVER_NAME</h1></html>" > "$DOCUMENT_ROOT/index.html"
		    echo "Created document root: $DOCUMENT_ROOT"
	    else
		        echo "Document root already exists: $DOCUMENT_ROOT"
		fi

		# Create Virtual Host Configuration
		cat <<EOL > "$VHOST_CONFIG"
<VirtualHost 192.168.0.201:80>
    ServerAdmin root@node.example.com
    DocumentRoot $DOCUMENT_ROOT
    DirectoryIndex index.html
    ServerName $SERVER_NAME
    ServerAlias $SERVER_ALIAS
    #Redirect permanent / https://$SERVER_NAME/

    #SSLEngine on
    #SSLCertificateFile $SSL_CERT
    #SSLCertificateKeyFile $SSL_KEY
    # If you have an intermediate certificate, add the following line
    # SSLCertificateChainFile /etc/ssl/certs/intermediate.crt

    CustomLog "$ACCESS_LOG" combined
    ErrorLog "$ERROR_LOG"
</VirtualHost>

<Directory $DOCUMENT_ROOT>
    Require all granted
</Directory>
EOL

echo "Virtual host configuration created at $VHOST_CONFIG"

# Restart Apache service
systemctl restart httpd

# Check Apache status
systemctl status httpd

echo "Apache service restarted."

