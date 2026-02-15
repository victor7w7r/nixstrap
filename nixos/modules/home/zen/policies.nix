{
  AllowFileSelectionDialogs = true;
  AppAutoUpdate = false;
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  BackgroundAppUpdate = false;
  BlockAboutAddons = false;
  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  BlockAboutSupport = false;
  Cookies = {
    Default = "reject-tracker-and-partition-foreign";
    AcceptThirdParty = "never";
    RejectTracker = true;
    Locked = true;
  };
  DisableAppUpdate = true;
  DisableBuiltinPDFViewer = false;
  DisableCrashReporter = true;
  DisableFeedbackCommands = true;
  DisableFirefoxAccounts = false;
  DisableFirefoxStudies = true;
  DisableFirefoxScreenshots = true;
  DisableForgetButton = false;
  DisableMasterPasswordCreation = true;
  DisablePocket = true;
  DisablePrivateBrowsing = false;
  DisableProfileImport = false;
  DisableProfileRefresh = false;
  DisableTelemetry = true;
  DisableSecurityBypass = {
    InvalidCertificate = true;
    SafeBrowsing = true;
  };
  DisableSafeMode = false;
  DisableSetDesktopBackground = true;
  DisableSystemAddonUpdate = true;
  DontCheckDefaultBrowser = true;
  DNSOverHTTPS = {
    Enabled = false;
    Locked = true;
  };
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  EncryptedMediaExtensions = {
    Enabled = true;
    Locked = true;
  };
  ExtensionUpdate = true;
  FirefoxHome = {
    Search = false;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Pocket = false;
    SponsoredPocket = false;
    Snippets = false;
    Locked = false;
  };
  HardwareAcceleration = true;
  ManualAppUpdateOnly = true;
  NetworkPrediction = false;
  NoDefaultBookmarks = false;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  PictureInPicture.Enabled = true;
  PopupBlocking = {
    Allow = [ ];
    Default = true;
  };
  Preferences = {
    "browser.tabs.warnOnClose" = {
      Value = false;
    };
  };
  PromptForDownloadLocation = false;
  RequestedLocales = [ "es-ES" ];
  SearchSuggestEnabled = false;
  ShowHomeButton = false;
  SearchSuggestEnable = true;
  SanitizeOnShutdown = {
    Cache = true;
    Cookies = false;
    FormData = false;
    History = false;
    Sessions = false;
    SiteSettings = false;
    Locked = true;
  };
  StartDownloadsInTempDirectory = false;
  StartPage = "previous-session";
  UserMessaging = {
    ExtensionRecommendations = false;
    SkipOnboarding = true;
  };
  WebsiteFilter = {
    Block = [
      "*://*.doubleclick.net/*"
      "*://*.googleadservices.com/*"
      "*://*.googlesyndication.com/*"
      "*://*.facebook.com/tr/*"
    ];
  };
}
