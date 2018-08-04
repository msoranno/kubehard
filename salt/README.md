# Salt samples

## Running from roles
```bash
cd /home/msoranno/kubehard/salt
sudo salt -G 'roles:kubeMaster' state.sls htop.htop
``` 

## query documentation
```bash
sudo salt 'salt' sys.doc pkg.install
```