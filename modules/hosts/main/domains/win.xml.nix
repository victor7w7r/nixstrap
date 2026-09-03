{ inputs, ... }: {
  main-domains.lib.win =
    {
      uuidGpu ? "",
      pkgs,
      memory ? 16384,
    }:
    let
      memoryKiB = builtins.mul memory 1024;
    in
    ''
      <domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
        <name>Win</name>
        <uuid>4d76e36e-c632-43e0-83c0-dc9f36c2829f</uuid>
        <metadata>
          <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
            <libosinfo:os id="http://microsoft.com/win/11"/>
          </libosinfo:libosinfo>
        </metadata>
        <memory unit="KiB">${memoryKiB}</memory>
        <currentMemory unit="KiB">${memoryKiB}</currentMemory>
        <memoryBacking>
          <source type="memfd"/>
          <access mode="shared"/>
        </memoryBacking>
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
          <type arch="x86_64" machine="pc-q35-10.1">hvm</type>
          <loader readonly='yes' type='pflash'>${pkgs.OVMFFull.fd}/FV/OVMF_CODE.ms.fd</loader>
          <nvram template='${pkgs.OVMFFull.fd}/FV/OVMF_VARS.ms.fd'>/var/lib/libvirt/qemu/nvram/win11-4_VARS.fd</nvram>
          <boot dev="hd"/>
          <bootmenu enable="no"/>
        </os>
        <features>
          <acpi/>
          <apic/>
          <hyperv mode="custom">
            <relaxed state="on"/>
            <vapic state="on"/>
            <spinlocks state="on" retries="8191"/>
            <vpindex state="on"/>
            <synic state="on"/>
            <stimer state="on">
              <direct state="on"/>
            </stimer>
            <reset state="on"/>
            <frequencies state="on"/>
            <reenlightenment state="on"/>
            <tlbflush state="on"/>
            <ipi state="on"/>
          </hyperv>
          <kvm>
            <hidden state="on"/>
          </kvm>
          <vmport state="off"/>
          <smm state="on"/>
          <ioapic driver="kvm"/>
        </features>
        <cpu mode="host-passthrough" check="partial" migratable="on">
          <feature policy="disable" name="hypervisor"/>
          <feature policy="require" name="vmx"/>
        </cpu>
        <clock offset="localtime">
          <timer name="rtc" tickpolicy="catchup"/>
          <timer name="pit" tickpolicy="delay"/>
          <timer name="hpet" present="no"/>
          <timer name="kvmclock" present="no"/>
          <timer name="hypervclock" present="yes"/>
        </clock>
        <on_poweroff>destroy</on_poweroff>
        <on_reboot>restart</on_reboot>
        <on_crash>destroy</on_crash>
        <pm>
          <suspend-to-mem enabled="no"/>
          <suspend-to-disk enabled="no"/>
        </pm>
        <devices>
          <emulator>/usr/bin/qemu-system-x86_64</emulator>
          <disk type="file" device="disk">
            <driver name="qemu" type="qcow2" discard="unmap"/>
            <source file="/var/lib/libvirt/images/winvm.qcow2"/>
            <target dev="vda" bus="virtio"/>
            <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
          </disk>
          <controller type="pci" index="0" model="pcie-root"/>
          <controller type="pci" index="1" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="1" port="0x1"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
          </controller>
          <controller type="pci" index="2" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="2" port="0x2"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
          </controller>
          <controller type="pci" index="3" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="3" port="0x3"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
          </controller>
          <controller type="pci" index="4" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="4" port="0x4"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
          </controller>
          <controller type="pci" index="5" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="5" port="0x5"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
          </controller>
          <controller type="pci" index="6" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="6" port="0x6"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
          </controller>
          <controller type="pci" index="7" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="7" port="0x7"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x6"/>
          </controller>
          <controller type="pci" index="8" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="8" port="0x8"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x7"/>
          </controller>
          <controller type="pci" index="9" model="pcie-root-port">
            <model name="pcie-root-port"/>
            <target chassis="9" port="0x9"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x0"/>
          </controller>
          <controller type="usb" index="0" model="qemu-xhci" ports="15">
            <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
          </controller>
          <controller type="virtio-serial" index="0">
            <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
          </controller>
          <controller type="sata" index="0">
            <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
          </controller>
          <filesystem type="mount" accessmode="passthrough">
            <driver type="virtiofs"/>
            <source dir="/home/victor7w7r"/>
            <target dir="victor7w7r"/>
            <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
          </filesystem>
          <interface type="network">
            <mac address="52:54:00:81:ff:44"/>
            <source network="default"/>
            <model type="virtio"/>
            <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
          </interface>
          <serial type="pty">
            <target type="isa-serial" port="0">
              <model name="isa-serial"/>
            </target>
          </serial>
          <console type="pty">
            <target type="serial" port="0"/>
          </console>
          <channel type="spicevmc">
            <target type="virtio" name="com.redhat.spice.0"/>
            <address type="virtio-serial" controller="0" bus="0" port="1"/>
          </channel>
          <channel type="unix">
            <target type="virtio" name="org.qemu.guest_agent.0"/>
            <address type="virtio-serial" controller="0" bus="0" port="2"/>
          </channel>
          <input type="mouse" bus="virtio">
            <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
          </input>
          <input type="keyboard" bus="virtio">
            <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
          </input>
          <input type="mouse" bus="ps2"/>
          <input type="keyboard" bus="ps2"/>
          <tpm model="tpm-crb">
            <backend type="emulator" version="2.0">
              <profile name="default-v1"/>
            </backend>
          </tpm>
          <graphics type="spice" autoport="yes">
            <listen type="address"/>
            <image compression="off"/>
            <gl enable="no" rendernode="/dev/dri/by-path/pci-0000:00:02.0-render"/>
          </graphics>
          <sound model="ich9">
            <audio id="1"/>
            <address type="pci" domain="0x0000" bus="0x00" slot="0x1b" function="0x0"/>
          </sound>
          <audio id="1" type="spice"/>
          <video>
            <model type="none"/>
          </video>
          <hostdev mode="subsystem" type="mdev" managed="no" model="vfio-pci" display="off">
            <source>
              <address uuid="${uuidGpu}"/>
            </source>
            <address type="pci" domain="0x0000" bus="0x08" slot="0x00" function="0x0"/>
          </hostdev>
          <watchdog model="itco" action="reset"/>
          <memballoon model="none"/>
          <rng model="virtio">
            <backend model="random">/dev/urandom</backend>
            <address type="pci" domain="0x0000" bus="0x09" slot="0x00" function="0x0"/>
          </rng>
        </devices>
        <qemu:commandline>
          <qemu:arg value="-device"/>
          <qemu:arg value="{&quot;driver&quot;:&quot;ivshmem-plain&quot;,&quot;id&quot;:&quot;shmem0&quot;,&quot;memdev&quot;:&quot;looking-glass&quot;}"/>
          <qemu:arg value="-object"/>
          <qemu:arg value="{&quot;qom-type&quot;:&quot;memory-backend-file&quot;,&quot;id&quot;:&quot;looking-glass&quot;,&quot;mem-path&quot;:&quot;/dev/kvmfr0&quot;,&quot;size&quot;:33554432,&quot;share&quot;:true}"/>
        </qemu:commandline>
        <qemu:override>
          <qemu:device alias="hostdev0">
            <qemu:frontend>
              <qemu:property name="romfile" type="string" value="${inputs.macos-kvm}/ovmf/other/i915ovmf-new.rom"/>
            </qemu:frontend>
          </qemu:device>
        </qemu:override>
      </domain>
    '';
}
