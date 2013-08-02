//, 0,00 anchorsel iframe
//
///^http:\/\/israblog.nana10.co.il\/$
qlist = [
   {
      "name":"google",
      "anchorsel":"h3.r a"
   }
 , {
      "name":"nana10",
      "pages":[
         {
            "name":"main",
            "urlpattern":/^http:\/\/israblog.nana10.co.il\/$/,
            "textsel":"b",
            "anchorsel":"a.GenenalHompageLinkNoBold"
         },{
         	"name":"israblog-last-visited",
            "urlpattern":/\?blog=\d{3,8}/,
         	"iframe":{ //Maybe change this to iframe tag
         		"sel":"iframe"
             , "prop":"[src*=BlogReadLists]"
         	 ,	"anchorsel": "a"
         	}
         }
      ]
   }
 , {
      "name":"youtube",
      "anchorsel":"li.yt-uix-tile h3 a"
   }
 , {
      "name":"cheatography",
      "anchorsel":"#body_shadow strong a"
   }
]