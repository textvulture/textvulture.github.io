// scraper_SCHEV.js

// Create a webpage object
var page = require('webpage').create();

// Include the File System module for writing to files
var fs = require('fs');

// Specify source and path to output file
var url  = 'https://research.schev.edu/rdPage.aspx?rdReport=Enrollment.Enrollment_Trend_byProgram&inpPLEVONE=40&inpPROGONE=45.0901&inpUNITID=XXXALL&rdRnd=17363'
var path = 'total.html'

page.open(url, function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});