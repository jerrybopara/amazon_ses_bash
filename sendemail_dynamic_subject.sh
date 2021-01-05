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

send_email() {
    # Define all your recipients here.
    send_to=( email1@gmail.com email2@gmail.com email3@gmail.com )

    # Use FROM Email which you've verified with AWS SES.
    FROM="FROM NAME <FROM EMAIL ADDRESS>"
    SUBJECT="$sub" # Dynamic Subject from File.
    MESSAGE="<YOUR MESSAGE HERE>"

    date="$(date -R)"
    priv_key="$AWS_SECRET_KEY"
    access_key="$AWS_ACCESS_KEY"
    signature="$(echo -n "$date" | /usr/bin/openssl dgst -sha256 -hmac "$priv_key" -binary | /usr/bin/base64 -w 0)"
    auth_header="X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=$access_key, Algorithm=HmacSHA256, Signature=$signature"
    endpoint="https://email.us-east-1.amazonaws.com/"

    action="Action=SendEmail"
    source="Source=$FROM"
    subject="Message.Subject.Data=$SUBJECT"
    message="Message.Body.Text.Data=$MESSAGE"


for i in "${send_to[@]}"
do  
    TO="$i"
    to="Destination.ToAddresses.member.1=$TO"
    curl -v -X POST -H "Date: $date" -H "$auth_header" --data-urlencode "$message" --data-urlencode "$to" --data-urlencode "$source" --data-urlencode "$action" --data-urlencode "$subject"  "$endpoint"  >> /dev/null 2>&1
done
}

# Reading Subjects from the subject list file. 
IFS=$'\n' read -d '' -r -a Subjects < /PATH/OF/SUBJECT-FILE.TXT 

for sub in "${Subjects[@]}"
do
  send_email    # Calling SendEmail Funtion. 

done
