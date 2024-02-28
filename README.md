1. Overview

Script monitoring changes in computer parameters:
a) upon first startup, it sends information about the status of the computer's parameters to the e-mail address provided in the configuration file,
b) during subsequent launches, it first checks whether any of the parameters have changed, if so, it sends an e-mail with all parameters again, if not, it does nothing.

Parameters checked by the program:
- The IP address of the computer
- Size of RAM
- Number of processors


2. Requirements
Two programs are required for the script to work properly:
ssmtp - to configure the SMTP server
mailutils - for sending emails using SMTP

Two configuration files are required for the script to work properly::
config.txt - containing the e-mail address to which we want to send the message, its content should look like this: TO_EMAIL=email_address
/etc/ssmtp/ssmtp.conf - for example, when sending messages from gmail.com, it should contain the following lines (you should also make sure that the option of logging in to the e-mail account from an external program is possible):
`UseSTARTTLS=YES`
`FromLineOverride=YES`
`root=admin@example.com`
`mailhub=smtp.gmail.com:587`
`AuthUser=username@gmail.com`
`AuthPass=password`


3. Usage
The program takes no arguments. The program should be launched using the "./monitor.sh" command. If everything went well, we will receive information about the delivered e-mail.
