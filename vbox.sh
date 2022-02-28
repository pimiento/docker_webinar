VBoxManage createvm --name Debian \
           -ostype "Debian_64" --register
VBoxManage modifyvm Debian --ioapic on
VBoxManage modifyvm Debian --memory 1024 --vram 128
VBoxManage modifyvm Debian --nic1 nat
VBoxManage createhd --filename Debian/Debian_DISK.vdi\
           --size 40000 --format VDI
VBoxManage storagectl Debian \
           --name "SATA Controller" \
           --add sata --controller IntelAhci
VBoxManage storageattach Debian \
           --storagectl "SATA Controller"\
           --port 0 --device 0 --type hdd \
           --medium Debian/Debian_DISK.vdi
VBoxManage storagectl Debian --name "IDE Controller"\
           --add ide --controller PIIX4
VBoxManage storageattach Debian\
           --storagectl "IDE Controller"\
           --port 1 --device 0 --type dvddrive\
           --medium ~/Downloads/debian.iso
VBoxManage modifyvm Debian --boot1 dvd --boot2 disk\
           --boot3 none --boot4 none
VBoxManage modifyvm Debian --vrde on
VBoxManage modifyvm Debian --vrdemulticon on --vrdeport 10001
VBoxHeadless --startvm Debian
