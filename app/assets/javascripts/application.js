// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(function() {
    var pathname = window.location.pathname;
    if (pathname == "/pages/home") {
      $("#home_tab").addClass("active");
      $("#trends_tab").removeClass("active");
      $("#budgets_tab").removeClass("active");
    } else if (pathname == "/pages/trends") {
      $("#home_tab").removeClass("active");
      $("#trends_tab").addClass("active");
      $("#budgets_tab").removeClass("active");
    } else {
      $("#home_tab").removeClass("active");
      $("#trends_tab").removeClass("active");
      $("#budgets_tab").addClass("active");
    }
});