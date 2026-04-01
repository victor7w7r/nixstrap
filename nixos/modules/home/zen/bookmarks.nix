{ ... }:
{
  programs.zen-browser.profiles.default.bookmarks.settings = [
    {
      name = "Barra de favoritos";
      toolbar = true;
      bookmarks = [
        {
          name = "Github";
          url = "https://github.com/";
        }
        {
          name = "Búsqueda";
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
}
