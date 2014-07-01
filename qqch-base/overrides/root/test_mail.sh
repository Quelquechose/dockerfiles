#!/bin/bash
# script to send simple email 
# email subject
SUBJECT="Test de mail"
# Email To ?
EMAIL="thierry.stiegler@gmail.com"
# Email text/message
EMAILMESSAGE="/tmp/emailmessage.txt"
echo "This is an email message test"> $EMAILMESSAGE
echo "This is email text" >>$EMAILMESSAGE
# send an email using /bin/mail
mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
