# Salt samples

## Running from roles
```bash
cd /home/msoranno/kubehard/salt
sudo salt -G 'roles:kubeMaster' state.sls htop.htop
``` 

## query documentation
```bash
sudo salt 'salt' sys.doc pkg.install

sudo salt 'salt' sys.list_functions pkg
```

## grains
```bash
sudo salt '*' grains.item os
```

## Runing state using highstate
```bash
sudo salt 'master*' state.highstate test=true
```