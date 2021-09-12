# RPI-Updater-Notifier

`rpi-updater notifier` is a Shell Script for updating Raspberrypi OS.

It also notifies, with an email notification, thru Gmail relay.

## Usage

Clone this repo

```git clone https://github.com/yurifugi/rpi-updater-notifier.git
cd rpi-updater-notifier
```

Edit `rpi-updater-notifier.sh`, adding your email address to the variable `MAIL_TO`.

## Configuring `sendmail` relay with Gmail

### Install Postfix

You will need an email relay server to "relay" with Gmail's server.

Install Postfix with

`sudo apt install postfix libsasl2-modules`

For the Mail Server configuraion, choose "Internet Site".

For System Mail Name, type the hostname of your Rpi.

### Create an app password on Gmail

Open your Gmail account at https://myaccount.google.com

Then click on "Security" > App Passwords.
On the "Select app" dropdown, choose Other. Then type in your Rpi hostname.

Take note of the char(16) password.

### Configuring SASL for Gmail auth

You'll create the file, then add some text to it.

Open the file for edition with
`sudo vi /etc/postfix/sasl/sasl_passwd`

Then add the line below, changing your username and password (the char(16) password from earlier).
`[smtp.gmail.com]:587 username@gmail.com:password`

Protect the file, for good measure
`sudo chmod u=rw,go= /etc/postfix/sasl/sasl_passwd`

Hash the file for Postfix use
`sudo postmap /etc/postfix/sasl/sasl_passwd`

Secure the file
`sudo chmod u=rw,go= /etc/postfix/sasl/sasl_passwd.db`

### Configuring Postfix

Create a backup for the Postfix config file
`sudo cp /etc/postfix/main.cf !#$.dist`

Edit the config file

`sudo vi /etc/postfix/main.cf`

Change line
`relayhost = `
to
`relayhost = [smtp.gmail.com]:587`

Scroll down to the end of file, then add the lines below to the end of the file

````# Enable authentication using SASL.
smtp_sasl_auth_enable = yes
# Use transport layer security (TLS) encryption.
smtp_tls_security_level = encrypt
# Do not allow anonymous authentication.
smtp_sasl_security_options = noanonymous
# Specify where to find the login information.
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
# Where to find the certificate authority (CA) certificates.
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt```

Restart Postfix
`sudo systemctl restart postfix`


### Testing

We're using `sendmail` to test if the connection is ok. Issue
`sendmail username@gmail.com`
The line will break, and nothing is displayed. This is `sendmail` awaiting for the email text.
Type
`Subject: test123test`
Then hit <ENTER>

Now type the message
`Is it working?`
Then hit <ENTER>.

Now, to indicate the end of the message, sendmail expects a period "."
So, type
`.`
Then hit <ENTER>.


Your screen will looks like:

````

$ sendmail username@gmail.com
Subject: test123test
Is it working?
.

```

That's it! Check your Gmail account.

This `sendmail` config section was entirely based on Stacy Prowell
article (https://medium.com/swlh/setting-up-gmail-and-other-email-on-a-raspberry-pi-6f7e3ad3d0e)
```
