{ ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.zen-browser.profiles.default.settings = {
    "app.normandy.enabled" = lock-false;
    "app.normandy.api_url" = "";
    "app.shield.optoutstudies.enabled" = lock-false;
    "app.update.auto" = false;
    "breakpad.reportURL" = "";

    "browser.aboutConfig.showWarning" = lock-false;
    "browser.aboutwelcome.enabled" = lock-false;
    "browser.bookmarks.defaultLocation" = "toolbar";
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.contentblocking.category" = {
      Value = "strict";
      Status = "locked";
    };
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "browser.discovery.enabled" = false;
    "browser.formfill.enable" = lock-false;
    "browser.laterrun.enabled" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.newtabpage.activity-stream.enabled" = lock-false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
    "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    "browser.newtabpage.activity-stream.telemetry" = lock-false;
    "browser.newtabpage.enhanced" = lock-false;
    "browser.newtabpage.introShown" = lock-true;
    "browser.newtabpage.pinned" = false;
    "browser.newtab.url" = "about:blank";
    "browser.ping-centre.telemetry" = lock-false;
    "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
    "browser.protections_panel.infoMessage.seen" = lock-true;
    "browser.safebrowsing.allowOverride" = false;
    "browser.safebrowsing.blockedURIs.enabled" = false;
    "browser.safebrowsing.debug" = false;
    "browser.safebrowsing.downloads.enabled" = false;
    "browser.safebrowsing.downloads.remote.block_dangerous" = false;
    "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
    "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
    "browser.safebrowsing.downloads.remote.block_uncommon" = false;
    "browser.safebrowsing.downloads.remote.enabled" = false;
    "browser.safebrowsing.downloads.remote.remote.url" = "";
    "browser.safebrowsing.downloads.remote.url" = "";
    "browser.safebrowsing.id" = "";
    "browser.safebrowsing.malware.enabled" = false;
    "browser.safebrowsing.phishing.enabled" = false;
    "browser.safebrowsing.provider.google.advisoryName" = "";
    "browser.safebrowsing.provider.google.advisoryURL" = "";
    "browser.safebrowsing.provider.google.gethashURL" = "";
    "browser.safebrowsing.provider.google.lists" = "";
    "browser.safebrowsing.provider.google.pver" = 0;
    "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
    "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
    "browser.safebrowsing.provider.google.reportURL" = "";
    "browser.safebrowsing.provider.google.updateURL" = "";
    "browser.safebrowsing.provider.google4.advisoryName" = "";
    "browser.safebrowsing.provider.google4.advisoryURL" = "";
    "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
    "browser.safebrowsing.provider.google4.dataSharingURL" = "";
    "browser.safebrowsing.provider.google4.gethashURL" = "";
    "browser.safebrowsing.provider.google4.lists" = "";
    "browser.safebrowsing.provider.google4.pver" = 0;
    "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
    "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
    "browser.safebrowsing.provider.google4.reportURL" = "";
    "browser.safebrowsing.provider.google4.updateURL" = "";
    "browser.safebrowsing.provider.mozilla.gethashURL" = "";
    "browser.safebrowsing.provider.mozilla.lastupdatetime" = 0;
    "browser.safebrowsing.provider.mozilla.lists" = "";
    "browser.safebrowsing.provider.mozilla.lists.base" = "";
    "browser.safebrowsing.provider.mozilla.lists.content" = "";
    "browser.safebrowsing.provider.mozilla.nextupdatetime" = 0;
    "browser.safebrowsing.provider.mozilla.pver" = 0;
    "browser.safebrowsing.provider.mozilla.reportURL" = "";
    "browser.safebrowsing.provider.mozilla.updateURL" = "";
    "browser.safebrowsing.reportPhishURL" = "";

    "browser.search.suggest.enabled" = lock-false;
    "browser.search.suggest.enabled.private" = lock-false;
    "browser.search.separatePrivateDefault" = false;
    "browser.sessionstore.privacy_level" = 0;
    "browser.shell.checkDefaultBrowser" = lock-false;
    "browser.shell.didSkipDefaultBrowserCheckOnFirstRun" = true;
    "browser.ssb.enabled" = true;
    "browser.startup.homepage" = "";
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.startup.page" = 3;
    "browser.tabs.crashReporting.sendReport" = lock-false;
    "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
    "browser.tabs.firefox-view" = lock-false;
    "browser.tabs.inTitlebar" = 0;
    "browser.tabs.unloadOnLowMemory" = true;
    "browser.tabs.warnOnOpen" = false;
    "browser.theme.content-theme" = 0;
    "browser.theme.toolbar-theme" = 0;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.urlbar.suggest.topsites" = lock-false;
    "browser.urlbar.suggest.openpage" = lock-false;
    "browser.urlbar.suggest.recentsearches" = lock-false;

    "content.notify.interval" = 100000;

    "datareporting.healthreport.uploadEnabled" = lock-false;
    "datareporting.healthreport.service.enabled" = lock-false;
    "datareporting.policy.dataSubmissionEnable" = false;
    "datareporting.policy.dataSubmissionEnabled" = lock-false;
    "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
    "dom.allow_scripts_to_close_windows" = true;
    "dom.battery.enabled" = false;
    "dom.block_multiple_popups" = lock-true;
    "dom.event.clipboardevents.enabled" = false;
    "dom.event.contextmenu.enabled" = false;
    "dom.ipc.forkserver.enable" = true;
    "dom.security.https_only_mode" = lock-true;
    "dom.security.https_only_mode_ever_enabled" = lock-true;
    "dom.security.https_only_mode_error_page_user_suggestions" = true;
    "dom.security.https_only_mode_pbm" = true;
    "dom.webnotifications.enabled" = lock-false;
    "dom.webnotifications.serviceworker.enabled" = lock-false;

    "experiments.supported" = lock-false;
    "experiments.enabled" = lock-false;
    "experiments.manifest.uri" = "";
    "extensions.autoDisableScopes" = 0;
    "extensions.enabledScopes" = 15;
    "extensions.formautofill.addresses.enabled" = lock-false;
    "extensions.formautofill.available" = "off";
    "extensions.formautofill.creditCards.available" = lock-false;
    "extensions.formautofill.creditCards.enabled" = lock-false;
    "extensions.formautofill.heuristics.enabled" = lock-false;
    "extensions.pocket.enabled" = lock-false;

    "extensions.allowPrivateBrowsingByDefault" = lock-true;
    "extensions.autoDisableScopes" = {
      Value = 0;
      Status = "locked";
    };
    "extensions.enabledScopes" = {
      Value = 15;
      Status = "locked";
    };
    "extensions.extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "extensions.getAddons.showPane" = lock-false;
    "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
    "extensions.screenshots.disabled" = lock-true;
    "extensions.webcompat.enable_picture_in_picture_overrides" = true;
    "extensions.webcompat.enable_shims" = true;
    "extensions.webcompat.perform_injections" = true;
    "extensions.webcompat.perform_ua_overrides" = true;
    "extensions.webextensions.restrictedDomains" = {
      Value = "";
      Status = "locked";
    };

    "layout.css.color-mix.enabled" = true;
    "layout.css.backdrop-filter.enabled" = true;
    "layout.word_select.eat_space_to_next_word" = lock-false;

    "general.smoothScroll" = false;
    "geo.enabled" = false;
    "gfx.canvas.accelerated.cache-items" = 32768;
    "gfx.canvas.accelerated.cache-size" = 4096;
    "gfx.content.skia-font-cache-size" = 80;
    "gfx.webrender.all" = true;
    "gfx.webrender.precache-shaders" = true;
    "gfx.webrender.program-binary-disk" = true;

    "identity.fxaccounts.enabled" = lock-false;
    "image.cache.size" = 10485760;
    "image.mem.decode_bytes_at_a_time" = 65536;
    "image.mem.shared.unmap.min_expiration_ms" = 120000;
    "intl.locale.requested" = "";
    "javascript.options.baselinejit.threshold" = 50;
    "javascript.options.ion.threshold" = 500;
    "layers.gpu-process.enabled" = true;

    "media.av1.enabled" = true;
    "media.cache_readahead_limit" = 7200;
    "media.cache_resume_threshold" = 3600;
    "media.gpu-process-decoder" = true;
    "media.hardware-video-decoding.force-enabled" = true;
    "media.memory_cache_max_size" = 1048576;
    "media.memory_caches_combined_limit_kb" = 3145728;
    "media.navigator.enabled" = false;
    "media.webrtc.hw.h264.enabled" = true;

    "mousewheel.default.delta_multiplier_y" = 50;
    "mousewheel.min_line_scroll_amount" = 30;
    "mousewheel.system_scroll_override_on_root_content.enabled" = true;
    "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
    "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;

    "network.buffer.cache.size" = 65535;
    "network.dns.disablePrefetch" = true;
    "network.dnsCacheExpiration" = 3600;
    "network.http.max-connections" = 1800;
    "network.http.max-persistent-connections-per-server" = 10;
    "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    "network.http.pacing.requests.enabled" = false;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;
    "network.http.speculative-parallel-limit" = 0;
    "network.ssl_tokens_cache_capacity" = 32768;

    "permissions.default.geo" = 2;
    "permissions.default.camera" = 2;
    "permissions.default.microphone" = 0;
    "permissions.default.desktop-notification" = 2;
    "permissions.default.xr" = 2;

    "privacy.clearOnShutdown.cache" = lock-true;
    "privacy.clearOnShutdown.cookies" = lock-false;
    "privacy.clearOnShutdown.downloads" = lock-true;
    "privacy.clearOnShutdown.formdata" = lock-true;
    "privacy.clearOnShutdown.history" = lock-false;
    "privacy.clearOnShutdown.offlineApps" = lock-true;
    "privacy.clearOnShutdown.sessions" = lock-false;
    "privacy.clearOnShutdown.siteSettings" = lock-true;
    "privacy.donottrackheader.enabled" = lock-true;
    "privacy.donottrackheader.value" = 1;
    "privacy.globalprivacycontrol.enabled" = lock-true;
    "privacy.globalprivacycontrol.functionality.enabled" = lock-true;
    "privacy.purge_trackers.enabled" = lock-true;
    "privacy.popups.disable_from_plugins" = 3;
    "privacy.query_stripping.enabled" = lock-true;
    "privacy.query_stripping.enabled.pbmode" = lock-true;
    "privacy.resistFingerprinting" = lock-true;
    "privacy.sanitize.sanitizeOnShutdown" = lock-true;
    "privacy.trackingprotection.enabled" = lock-true;
    "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
    "privacy.trackingprotection.socialtracking.enabled" = lock-true;
    "privacy.trackingprotection.cryptomining.enabled" = lock-true;
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    "privacy.userContext.longPressBehavior" = 2;

    "security.OCSP.enabled" = 0;
    "security.pki.crlite_mode" = 2;
    "security.remote_settings.crlite_filters.enabled" = true;
    "services.settings.poll_interval" = 300;

    "signon.rememberSignons" = lock-false;
    "svg.context-properties.content.enabled" = true;
    "toolkit.coverage.opt-out" = lock-true;
    "toolkit.coverage.endpoint.base" = "";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "toolkit.telemetry.enabled" = lock-false;
    "toolkit.telemetry.unified" = lock-false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = lock-false;
    "toolkit.telemetry.newProfilePing.enabled" = lock-false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
    "toolkit.telemetry.updatePing.enabled" = lock-false;
    "toolkit.telemetry.bhrPing.enabled" = lock-false;
    "toolkit.telemetry.coverage.opt-out" = lock-true;
    "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
    "toolkit.scrollbox.horizontalScrollDistance" = 6;
    "toolkit.scrollbox.verticalScrollDistance" = 2;
    "trailhead.firstrun.didSeeAboutWelcome" = lock-true;

    "widget.gtk.global-menu.enabled" = true;
    "widget.gtk.global-menu.wayland.enabled" = true;

    "zen.tabs.vertical.right-side" = true;
    "zen.themes.updated-value-observer" = true;
    "zen.urlbar.behavior" = "float";
    "zen.view.compact.animate-sidebar" = false;
    "zen.view.compact.hide-toolbar" = true;
    "zen.view.compact.hide-tabbar" = true;
    "zen.view.sidebar-expanded" = false;
    "zen.view.use-single-toolbar" = false;
    "zen.watermark.enabled" = false;
    "zen.welcome-screen.seen" = true;
    "zen.workspaces.continue-where-left-off" = true;
    "zen.workspaces.natural-scroll" = true;
  };

}
