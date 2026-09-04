{ inputs, ... }: {
  main-domains.lib.macos =
    {
      uuidGpu ? "01234567-89ab-4cde-8f01-23456789abcd",
      memory ? 16384,
    }:
    let
      memoryKiB = builtins.mul memory 1024;
    in
    ''
      <domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
        <name>macOS</name>
        <uuid>2aca0dd6-cec9-4717-9ab2-0b7b13d111c3</uuid>
        <title>macOS</title>
        <memory unit="KiB">${memoryKiB}</memory>
        <currentMemory unit="KiB">${memoryKiB}</currentMemory>
        <vcpu placement="static">6</vcpu>
        <cputune>
          <vcpupin vcpu="0" cpuset="0"/>
          <vcpupin vcpu="1" cpuset="1"/>
          <vcpupin vcpu="2" cpuset="2"/>
          <vcpupin vcpu="3" cpuset="3"/>
          <vcpupin vcpu="4" cpuset="4"/>
          <vcpupin vcpu="5" cpuset="5"/>
        </cputune>
        <os>
          <type arch="x86_64" machine="pc-q35-4.2">hvm</type>
          <loader readonly="yes" type="pflash" format="raw">${inputs.osx-kvm}/OVMF_CODE.fd</loader>
          <nvram template='${inputs.osx-kvm}/OVMF_VARS-1024x768.fd'>/var/lib/libvirt/qemu/nvram/Mac_VARS.fd</nvram>
          <boot dev="hd"/>
        </os>
        <features>
          <acpi/>
          <apic/>
        </features>
        <cpu mode="host-passthrough" check="none" migratable="on"/>
        <clock offset="utc">
          <timer name="rtc" tickpolicy="catchup"/>
          <timer name="pit" tickpolicy="delay"/>
          <timer name="hpet" present="no"/>
        </clock>
        <on_poweroff>destroy</on_poweroff>
        <on_reboot>restart</on_reboot>
        <on_crash>restart</on_crash>
        <devices>
          <emulator>/run/current-system/sw/bin/qemu-system-x86_64</emulator>
          <disk type="file" device="disk">
            <driver name="qemu" type="qcow2" cache="writeback" io="threads"/>
            <source file="/var/lib/libvirt/images/OpenCore.qcow2"/>
            <target dev="sda" bus="sata"/>
            <address type="drive" controller="0" bus="0" target="0" unit="0"/>
          </disk>
          <disk type="block" device="disk">
            <driver name="qemu" type="raw" cache="writeback" io="threads"/>
            <source dev="/dev/nvme0n1p2"/>
            <target dev="sdb" bus="sata"/>
            <address type="drive" controller="0" bus="0" target="0" unit="1"/>
          </disk>
          <controller type="pci" index="0" model="pcie-root"/>
          <controller type="pci" index="1" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="1" port="0x1"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0" multifunction="on"/>
          </controller>
          <controller type="pci" index="2" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="2" port="0x9"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x1"/>
          </controller>
          <controller type="pci" index="3" model="pcie-to-pci-bridge">
            <model name="pcie-pci-bridge"/>
            <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
          </controller>
          <controller type="sata" index="0">
            <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
          </controller>
          <controller type="usb" index="0" model="ich9-ehci1">
            <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x7"/>
          </controller>
          <controller type="usb" index="0" model="ich9-uhci1">
            <master startport="0"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x0" multifunction="on"/>
          </controller>
          <controller type="usb" index="0" model="ich9-uhci2">
            <master startport="2"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x1"/>
          </controller>
          <controller type="usb" index="0" model="ich9-uhci3">
            <master startport="4"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x2"/>
          </controller>
          <controller type="virtio-serial" index="0">
            <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
          </controller>
          <interface type="network">
            <mac address="52:54:00:e6:85:40"/>
            <source network="default"/>
            <model type="vmxnet3"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x0"/>
          </interface>
          <serial type="pty">
            <target type="isa-serial" port="0">
              <model name="isa-serial"/>
            </target>
          </serial>
          <console type="pty">
            <target type="serial" port="0"/>
          </console>
          <channel type="unix">
            <target type="virtio" name="org.qemu.guest_agent.0"/>
            <address type="virtio-serial" controller="0" bus="0" port="1"/>
          </channel>
          <input type="mouse" bus="ps2"/>
          <input type="keyboard" bus="ps2"/>
          <input type="mouse" bus="usb">
            <address type="usb" bus="0" port="1"/>
          </input>
          <graphics type="spice">
            <listen type="none"/>
            <gl enable="yes" rendernode="/dev/dri/by-path/pci-0000:00:02.0-render"/>
          </graphics>
          <audio id="1" type="spice"/>
          <video>
            <model type="vga" vram="16384" heads="1" primary="yes"/>
            <address type="pci" domain="0x0000" bus="0x03" slot="0x01" function="0x0"/>
          </video>
          <hostdev mode="subsystem" type="mdev" managed="no" model="vfio-pci" display="on">
            <source>
              <address uuid="${uuidGpu}"/>
            </source>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0"/>
          </hostdev>
          <watchdog model="itco" action="reset"/>
          <memballoon model="none"/>
        </devices>
        <qemu:commandline>
          <qemu:arg value="-device"/>
          <qemu:arg value="isa-applesmc,osk=ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"/>
          <qemu:arg value="-smbios"/>
          <qemu:arg value="type=2"/>
          <qemu:arg value="-usb"/>
          <qemu:arg value="-device"/>
          <qemu:arg value="usb-tablet"/>
          <qemu:arg value="-device"/>
          <qemu:arg value="usb-kbd"/>
          <qemu:arg value="-cpu"/>
          <qemu:arg value="host,vendor=GenuineIntel,+hypervisor,+invtsc,kvm=on,+fma,+avx,+avx2,+aes,+ssse3,+sse4_2,+popcnt,+sse4a,+bmi1,+bmi2"/>
        </qemu:commandline>
        <qemu:override>
          <qemu:device alias="hostdev0">
            <qemu:frontend>
              <qemu:property name="romfile" type="string" value="${inputs.macos-kvm}/ovmf/other/i915ovmf-new.rom"/>
              <qemu:property name="x-igd-opregion" type="bool" value="true"/>
              <qemu:property name="x-igd-gms" type="unsigned" value="2"/>
            </qemu:frontend>
          </qemu:device>
        </qemu:override>
      </domain>
    '';
}
