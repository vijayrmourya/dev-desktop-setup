# Remote Development Desktop with AWS EC2

This project provides you with a basic setup of an ec2 instance to start the instance with ssh access from your local ip address dynamically and provides you with a ssh key in your local environment 
NOTE: local env is where you put this infrastructure as code and execute it

### How to run

You just need to run the deploy.sh file it takes care of deploying the infra

```bash
source deploy.sh
```

and when you want to cleanup the environment execute `cleanup.sh`

```bash
source cleanup.sh
```