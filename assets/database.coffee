database = [
  domain: "google"
  anchorsel: "h3.r a"
,
  domain: "thepiratebay"
  anchorsel: ".detLink"
,
  domain: "quora"
  anchorsel: ".question_link"
,
  domain: "cheatography"
  anchorsel: "#body_shadow strong a"
,
  domain: "readthedocs"
  anchorsel: "#id_search_result a"
,
  domain: "ynet"
  anchorsel: ".smallheader , #mStrips div div .text12, .whtbigheader:nth-child(2), .blkbigheader span"
,
  domain: "nana10"
  pages: [
    domain: /\?blog=\d{3,8}/
    anchorsel:
      iframe: "a.list:has(img[width='32'])"
      regular: "a.list:has(img[width='32'])"
  ,
    domain: /http:\/\/israblog\.nana10\.co\.il\/?/
    textsel: "b"
    anchorsel: "a.GenenalHompageLinkNoBold"
  ]
,
  domain: ["stackoverflow", "serverfault", "superuser", "meta.stackoverflow", "askubuntu", "stackapps", "answers.onstartups", "mathoverflow"]
  pages: [
    domain: /search\?q=/
    anchorsel: ".result-link a"
    inputsel: "[name='q']:last"
  ,
    domain: "default"
    anchorsel: ".question-hyperlink"
    inputsel: ".textbox[name='q']:last"
  ]
,
  domain: /https+:\/\/.*\.stackexchange\.com/
  pages: [
    domain: /search\?q=/
    anchorsel: ".result-link a"
    inputsel: "[name='q']:last"
  ,
    domain: "default"
    anchorsel: ".question-hyperlink"
    inputsel: ".textbox[name='q']:last"
  ]
,
  domain: "youtube"
  inputsel: "#masthead-search-term"
  pages: [
    domain: "watch"
    anchorsel: "li.video-list-item.related-list-item a"
    anchorsel: "li.video-list-item.related-list-item a"
  ,
    domain: "results"
    anchorsel: "li.yt-uix-tile h3 a"
  ]
,
  domain: "reddit"
  inputsel: "input[name='q']"
  anchorsel: "#siteTable p.title a.title"
,
  domain: "diigo"
  pages: [
    domain: "buzz"
    anchorsel: ".Titleinner a"
  ,
    domain: "user|tag"
    anchorsel: ".titleLink"
  ]
,
  domain: "github"
  anchorsel: ".repolist-name a"
,
  domain: "jquery"
  anchorsel: ".entry-title a"
,
  domain: /https+:\/\/aur.archlinux.*/
  anchorsel: "td:nth-child(3) a"
,
  domain: /https+:\/\/wiki.archlinux.*/
  anchorsel: ".mw-search-result-heading a"
,
  domain: /https+:\/\/www.archlinux.*\/packages.*/
  anchorsel: "td a"
]