# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];

  boot.kernelParams = [
    "amd_iommu=on"
    # "vfio-pci.ids=1002:67df,1002:aaf0"
    #"libata.force=4.00:disable"
  ];

  boot.initrd.kernelModules = [
    # "vfio_virqfd"
    # "vfio_pci"
    # "vfio_iommu_type1"
    # "vfio"
  ];

  boot.kernelModules = [
    "kvm-amd"
    # "vfio_virqfd"
    # "vfio_pci"
    # "vfio_iommu_type1"
    # "vfio"
  ];

  boot.extraModulePackages = [ ];
  #boot.kernelPackages = pkgs.linuxPackages_lqx;
  # TODO: maybe remove after ZFS get merged.
  #boot.zfs.enableUnstable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9f7c97e5-d9bf-4681-844a-669c1093da90";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6AE2-F448";
    fsType = "vfat";
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
