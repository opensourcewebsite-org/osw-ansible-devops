# Installation

Please read through our [Contribution Guidelines](CONTRIBUTING.md).

## Setup (PROD)

- Run `wget https://raw.githubusercontent.com/opensourcewebsite-org/osw-ansible-devops/main/install.sh` to download install script.
- Deploy a public key for root.
- Run `sudo bash install.sh` to install initial environment.
- Put user password's hash in `/srv/users-passwords.txt`.
  - Run `mkpasswd -m sha-512` to create a password hash.
- Install Ansible dependencies.
  - Run `ansible-galaxy install -r requirements.yml -f`.
- Run playbook `ansible-playbook -v -i inventory/all all.yml` or run with skip some paybooks `ansible-playbook -v -i inventory/all all.yml --skip-tags hardening`.
- Create a file `/etc/letsencrypt/cloudflareapi.ini`.
  - Add content with Cloudflare token `dns_cloudflare_api_token = CLOUDFLARE_TOKEN`.
- Add `*:apikey:<SetYourAPIKey>` to `/etc/exim4/passwd.client`.
  - Replace `<SetYourAPIKey>` to your own [SendGrid API key](https://app.sendgrid.com/settings/api_keys)
  - Run `systemctl restart exim4`.
  - Check email sending, run `bash mail-testert.sh user@domain.tld`.

### Deploy key

- Run `sudo -i` to switch to `root` user.
- Run `ssh-keygen -t ecdsa` to generate ssh key pair.
- View and copy the public key `cat ~/.ssh/id_ecdsa.pub`.
- Add the public key to GitHub to `Deploy keys` https://github.com/opensourcewebsite-org/osw-ansible-devops/settings/keys
- Test a connection `ssh -T git@github.com`.

### Add/Remove admin users

- Edit a file [`host_vars/localhost`](host_vars/localhost) and add variables with a user data for new user.

### Website opensourcewebsite.org

#### Deploy key

- Run `su - opensourcewebsite.org -s /bin/bash` to switch to `opensourcewebsite.org` user.
- Run `ssh-keygen -t ecdsa` to generate ssh key pair.
- View and copy the public key `cat ~/.ssh/id_ecdsa.pub`.
- Add the public key to GitHub to `Deploy keys` https://github.com/opensourcewebsite-org/opensourcewebsite-ansible-devops/settings/keys
- Test a connection `ssh -T git@github.com`.

#### DNS

- Add a main A record to server IP.

##### Cloudflare

If a proxy is used for the IP, switch the SSL/TLS encryption mode to Full.

#### DKIM

- View and copy the public key `cat /etc/exim4/dkim/opensourcewebsite.org.public`.
- Add TXT record of the domain with name `prod._domainkey` and content `v=DKIM1; h=sha256; k=rsa; p=PUBLIC_KEY` with the public key.
- Add TXT record of the domain with name `_domainkey` and content `t=y; o=~;`.
- Add TXT record of the domain with name `@` and content `v=spf1 a mx include:_spf.mx.cloudflare.net ~all`.
- Add TXT record of the domain with name `_dmarc` and content `v=DMARC1; p=none; sp=none;`

#### Let's Encrypt

##### Выпустить сертификат

Перед первым выпуском сертификата необходимо удалить файлы фиктивного сертификата для сайта.

- `certbot -v certonly --cert-name opensourcewebsite.org --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflareapi.ini --dns-cloudflare-propagation-seconds 60 -d opensourcewebsite.org,*.opensourcewebsite.org`

##### Удалить файлы сертификата

- `certbot delete --cert-name opensourcewebsite.org`

## Run pre-commit tests

```bash
✗ pre-commit run --all-files
check yaml...........................................(no files to check)Skipped
fix end of files.........................................................Passed
trim trailing whitespace.................................................Passed
check json...........................................(no files to check)Skipped
mixed line ending........................................................Passed
check for added large files..............................................Passed
Detect secrets...........................................................Passed
markdownlint.............................................................Passed
Ansible-lint.............................................................Passed
```
