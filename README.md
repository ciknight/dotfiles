### Adding a user

> useradd justin
> passwd justin

Then set password authentication to `yes` in `/etc/ssh/sshd_config`

Reload ssh service with `sudo service ssh reload`

### Using Mosh
> mosh --ssh="ssh -i path/to/key.pem" user@host
