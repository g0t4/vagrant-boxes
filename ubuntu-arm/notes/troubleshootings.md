# troubleshooting notes

- Read packer logs (hence adding `--timeout-ui` to show timestamps)
- `/var/log/installer` server logs
  - `/var/log/installer/installer-journal.txt`
  - i.e. `grep 'ssh' /var/log/installer/*`
