database = [
  domain: "google"
  exclude: /https?:\/\/plus.google.*/
  anchorsel: "h3.r a"
,
  domain: "twitter"
  anchorsel: ".js-display-url"
,
  domain: "heroku"
  anchorsel: ".ruled a"
,
  domain: "thepiratebay"
  anchorsel: ".detLink"
,
  domain: "quora"
  anchorsel: "a.question_link"
,
  domain: "cheatography"
  anchorsel: "#body_wide_shadow strong a"
,
  domain: "readthedocs"
  anchorsel: "#id_search_result a"
,
  domain: ["stackoverflow", "serverfault", "superuser", "meta.stackoverflow", "askubuntu", "stackapps", "answers.onstartups", "mathoverflow"]
  pages: [
    domain: /search/
    anchorsel: ".result-link a"
    inputsel: "input:last-child"
  ,
    domain: /questions\/\d+\//
    anchorsel: "#sidebar a.question-hyperlink"
  ,
    domain: "default"
    anchorsel: ".question-hyperlink"
  ]
,
  domain: "youtube"
  pages: [
    domain: "watch"
    anchorsel: "#watch-related .title"
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
    domain: /buzz/
    anchorsel: ".titleLink"
  ,
    domain: /user|tag/
    anchorsel: ".Titleinner a"
  ]
,
  domain: "github"
  pages: [
    domain: /issues/
    anchorsel: "h4 a.js-navigation-open"
  ,
    domain: "default"
    anchorsel: ".repolist-name a"
  ]
,
  domain: "jquery"
  anchorsel: ".entry-title a"
,
  domain: "startpage"
  anchorsel: "h3 a"
,
  domain: /https+:\/\/aur.archlinux.*/
  anchorsel: "td:nth-child(3) a"
,
  domain: /https+:\/\/wiki.archlinux.*/
  anchorsel: ".mw-search-result-heading a"
,
  domain: /https+:\/\/www.archlinux.*\/packages.*/
  anchorsel: "td a"
,
  domain: /https?:\/\/developer\.mozilla\.org\/.*\/search\?q=.*/
  anchorsel: "h4 a"
,
  domain: /https?:\/\/www.linkedin.com\/vsearch\/.*/
  anchorsel: "a.title"
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
  domain: /https?:\/\/.*\.stackexchange\.com/
  pages: [
    domain: /search/
    anchorsel: ".result-link a"
    inputsel: "input:last-child"
  ,
    domain: /questions\/\d+\//
    anchorsel: "#sidebar a.question-hyperlink"
  ,
    domain: "default"
    anchorsel: ".question-hyperlink"

  ]
,
  domain: "duckduckgo"
  anchorsel: ".result__a"
,
  domain: "bing"
  anchorsel: "h3 a"
,
  domain: "amazon"
  pages: [
    domain: /search/
    anchorsel: "h3 .bold"
  ]

]