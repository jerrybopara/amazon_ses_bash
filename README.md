# A Simple Shell Script to send Eamils Via Amazon SES.


###### In this script I'm using AWS SES to send emails. I'm using this script/code to send all type of my Server Alarms/Notifications.

###### I found this way is more simple and reliable than the other ways like using default Server SMTP OR Others. 

###### 1. Here just you need to define AWS IAM ACESS and SECRET Keys.
```
# !/bin/bash
# AWS SES Details. 
AWS_ACCESS_KEY="<Amazon IAM Access KEY>"
AWS_SECRET_KEY="<Amazon IAM Secret KEY>"
```

###### 2. Here I'am creating a function called **"Send_Email"** and added a **"for loop"** to send email to multiple recipients.
- below i just added the syntax and you can find full script in the repo.

```
send_email() {

    for i in "${send_to[@]}"
    do  
    
    done
}
```

###### 2. Define your TO, FROM and Email SUBJECT, and MESSAGE
```
# Define all your recipients here.
send_to=( email1@gmail.com email2@gmail.com email3@gmail.com )

# Use FROM Email which you've verified with AWS SES.
FROM="<FROM EMAIL ADDRESS>"
SUBJECT="<YOUR SUBJECT HERE>"
MESSAGE="<YOUR MESSAGE HERE>"
```

###### 3. SES Connection and API Call using cURL. 
```
date="$(date -R)"
priv_key="$AWS_SECRET_KEY"
access_key="$AWS_ACCESS_KEY"
signature="$(echo -n "$date" | /usr/bin/openssl dgst -sha256 -hmac "$priv_key" -binary | /usr/bin/base64 -w 0)"
auth_header="X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=$access_key, Algorithm=HmacSHA256, Signature=$signature"
endpoint="https://email.us-east-1.amazonaws.com/"

action="Action=SendEmail"
source="Source=$FROM"
to="Destination.ToAddresses.member.1=$TO"
subject="Message.Subject.Data=$SUBJECT"
message="Message.Body.Text.Data=$MESSAGE"
```

###### 4. Added **"FOR LOOP"** to send an email to multiple recipients.
```
for i in "${send_to[@]}"
do  
    TO="$i"
    to="Destination.ToAddresses.member.1=$TO"
    curl -v -X POST -H "Date: $date" -H "$auth_header" --data-urlencode "$message" --data-urlencode "$to" --data-urlencode "$source" --data-urlencode "$action" --data-urlencode "$subject"  "$endpoint"  >> /dev/null 2>&1
done
}
```

###### 4. Finally just call your **"send_email"** function wherever you need to send an email notifications.
```
send_email
```



