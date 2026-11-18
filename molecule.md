### Install molecule
```bash
sudo dnf install python3-pip
python3 -m pip install --user molecule
python3 -m pip install --user "molecule-plugins[podman]" "molecule-plugins[vagrant]"
```

###
```bash
mkdir molecule
cat > molecule/requirements.yml << 'EOF'
---
collections:
  - name: containers.podman
    version: ">=1.10.0"
  - name: arista.eos
    version: ">=6.0.0"
EOF

molecule init scenario linux
```

###
```bash

molecule test --scenario-name linux --report --command-borders
molecule create --scenario-name linux --report --command-borders

```