# Manual provision tasks

## Adjust VM Resources

- Memory, CPU
- NIC?
- Disable unnecessary peripherals (audio, )
  - USB
  - Enable clipboard sharing? or disable?
  - Enable drag and drop? or disable?

## Provision

- Disable widgets and other windows store apps default installed?

## NOTES

- ensure vagrant user is admin:
  Get-LocalGroupMember Administrators | fl
- vbox selected Windows Home edition, pick Pro next time
  - Home doesn't support RDP

## WIN 11 PRO virtualbox unattended install

- MUST hit key on startup else when to SHELL>
  - Only ~ 5 seconds to do this
  - if go to SHELL>
    - type "reset" (restarts)
    - try again!
