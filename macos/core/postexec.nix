{ user, ... }:
{
  system.activationScripts.postActivation.text = ''
    killall mds > /dev/null || true
    mdutil -i off -d / &> /dev/null
    mdutil -E / &> /dev/null

    chflags nohidden ~/Library

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 32" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist

    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

    /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
    defaults write /Library/Preferences/com.apple.loginwindow.plist SHOWFULLNAME -bool true
    hash tmutil > /dev/null 2>&1 && sudo tmutil disablelocal

    qlmanage -r
    killall cfprefsd

    sudo -u ${user} bash -c '
    #xcodebuild -license
    #xcrun simctl delete unavailable

    if ! _=$(/usr/sbin/DevToolsSecurity -status | grep -Fx "Developer mode is currently enabled." > /dev/null); then
      printf >&2 "enabling developer mode...\n"
      /usr/sbin/DevToolsSecurity -enable
    fi

    chflags nohidden /Volumes

    spctl --master-disable
    echo 'd *' | mailx > /dev/null 2>&1 || true
    csrutil enable --without fs --without nvram --without debug
    defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture ""
    mdutil -d /System/Volumes/Preboot /opt

    launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist 2> /dev/null
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

    defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist ProgramArguments -array-add "-NoMulticastAdvertisements"
    defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -int 0
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

    test -f /private/var/vm/sleepimage && sudo rm /private/var/vm/sleepimage

    touch /private/var/vm/sleepimage
    chflags uchg /private/var/vm/sleepimage

    pmset -a hibernatemode 0 2>/dev/null || true

    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -activate \
        -configure \
        -access \
        -off \
        -restart \
        -agent \
        -privs \
        -all \
        -allowAccessFor -allUsers

    DAE="com.apple.telnetd com.apple.tftpd com.apple.ftp-proxy com.apple.analyticsd com.apple.amp.mediasharingd com.apple.mediaanalysisd com.apple.mediaremoteagent com.apple.photoanalysisd com.apple.java.InstallOnDemand com.apple.voicememod com.apple.geod com.apple.locate com.apple.locationd com.apple.netbiosd com.apple.recentsd com.apple.suggestd com.apple.spindump com.apple.metadata.mds.spindump com.apple.ReportPanic com.apple.ReportCrash com.apple.ReportCrash.Self com.apple.DiagnosticReportCleanup"
    for val in $DAE; do
      launchctl disable system/$val
    done
    '
  '';
}
