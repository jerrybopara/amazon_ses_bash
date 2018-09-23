# !/bin/bash
######################################
# Created @Jerry Bop@r@!             #
# Email  - jerrybopara@gmail.com     #
# Mob    - +91 9646333233            #   
# Site   - jerrybopara.com           #
######################################

# AWS SES Details. 
AWS_ACCESS_KEY="<Amazon IAM Access KEY>"
AWS_SECRET_KEY="<Amazon IAM Secret KEY>"


TO="<EMAIL TO jerrybopara@gmail.com>"
FROM="<FROM EMAIL ADDRESS>"
SUBJECT="<YOUR SUBJECT HERE>"
MESSAGE="<YOUR MESSAGE HERE>"

date="$(date -R)"
priv_key="$AWS_SECRET_KEY"
access_key="$AWS_ACCESS_KEY"
signature="$(echo -n "$date" | openssl dgst -sha256 -hmac "$priv_key" -binary | base64 -w 0)"
auth_header="X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=$access_key, Algorithm=HmacSHA256, Signature=$signature"
endpoint="https://email.us-east-1.amazonaws.com/"

action="Action=SendEmail"
source="Source=$FROM"
to="Destination.ToAddresses.member.1=$TO"
subject="Message.Subject.Data=$SUBJECT"
message="Message.Body.Text.Data=$MESSAGE"

curl -v -X POST -H "Date: $date" -H "$auth_header" --data-urlencode "$message" --data-urlencode "$to" --data-urlencode "$source" --data-urlencode "$action" --data-urlencode "$subject"  "$endpoint"