exports.rocket = [
    {
        "dom": "google",
        "anchorsel": "h3.r a",
        "input": "input[name='q'][type='text']:first"
    },{
        "dom": "thepiratebay",
        "anchorsel": ".detLink"
    },{
        "dom": "quora",
        "anchorsel": ".question_link"
    },{
        "dom": "cheatography",
        "anchorsel": "#body_shadow strong a"
    },{
        "dom": "readthedocs",
        "anchorsel": "#id_search_result a"
    },{
        "dom": "ynet",
        "anchorsel": ".smallheader , #mStrips div div .text12, .whtbigheader:nth-child(2), .blkbigheader span"
    },{
        "dom": "nana10"
       ,"pages":[
        {
            "dom": /\?blog=\d{3,8}/
           ,"anchorsel": {"iframe":"a.list:has(img[width='32'])","regular":"a.list:has(img[width='32'])"}
        },{
            "dom": /http:\/\/israblog\.nana10\.co\.il\/?/
           ,"textsel": "b"
           ,"anchorsel": "a.GenenalHompageLinkNoBold"
        }]
    },{
        "dom"      : ["stackoverflow","serverfault","superuser","meta.stackoverflow","askubuntu","stackapps","answers.onstartups","mathoverflow"],
        "pages":[{
          "dom": /search\?q=/,
          "anchorsel": ".result-link a",
          "input"    : "[name='q']:last"
        },{
          "dom": "default",
          "anchorsel": ".question-hyperlink",
          "input"    : ".textbox[name='q']:last"
        }]
    },{
        "dom"      : /http:\/\/.*\.stackexchange\.com/,
        "pages":[{
          "dom": /search\?q=/,
          "anchorsel": ".result-link a",
          "input"    : "[name='q']:last"
        },{
          "dom": "default",
          "anchorsel": ".question-hyperlink",
          "input"    : ".textbox[name='q']:last"
        }]
    },{
        "dom": "youtube",
        "input": "#masthead-search-term",
        "pages": [
            {
                "dom": "watch",
                "anchorsel": "li.video-list-item.related-list-item a"
            },
            {
                "dom": "results",
                "anchorsel": "li.yt-uix-tile h3 a"
            }
        ]
    },{
        "dom"      : "reddit"
       ,"input"    : "input[name='q']"
       ,"anchorsel": "#siteTable p.title a.title"
    },{
        "dom"   : "diigo"
       ,"pages" : [{
            "dom":"buzz"
           ,"anchorsel":".Titleinner a"
        },{
           "dom":"user|tag"
          ,"anchorsel":".titleLink"
        }]
    },{
        "dom":"github"
       ,"anchorsel":".repolist-name a"
    },{
        "dom":"jquery"
       ,"anchorsel":".entry-title a"
    }
]