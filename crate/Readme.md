# Crate Database

## Known Bugs

- To start the database, `vm.max_map_count` has to be increased:
```
sudo sysctl -w vm.max_map_count=262144
```
use `/etc/sysctl.conf` to set the value on every restart
