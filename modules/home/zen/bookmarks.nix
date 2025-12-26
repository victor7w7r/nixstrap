{ ... }:
{
  programs.zen-browser.profiles.default.bookmarks = {
    force = true;
    settings = [
      {
        name = "Bookmarks Toolbar";
        toolbar = true;
        bookmarks = [
          {
            name = "Youtube";
            url = "https://www.youtube.com";
          }
          {
            name = "Twitch";
            url = "https://www.twitch.tv";
          }
          {
            name = "Github";
            url = "https://github.com/";
          }
          {
            name = "ChatGPT";
            url = "https://chatgpt.com/";
          }
          {
            name = "Search Engines";
            bookmarks = [
              {
                name = "Startpage";
                url = "https://www.startpage.com/do/mypage.pl?prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d";
              }
              {
                name = "SearX";
                url = "https://searx.aicampground.com";
              }
            ];
          }
        ];
      }
    ];
  };
}
