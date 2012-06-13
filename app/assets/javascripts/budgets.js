// Get data associated with budget sensors
var displayBudgetWidgets = function() {
 updateBudgetWidgets(15, 20, 0);
 updateBudgetWidgets(4, 5, 1);
 updateBudgetWidgets(6, 5, 2);
 updateBudgetWidgets(4, 5, 3);
 updateBudgetWidgets(3, 5, 4);
};

var updateBudgetWidgets = function(current, expected, divId){
  var percentProgress = (current/expected)*100;
  $("#amount-current-"+divId.toString()).val(current.toFixed(2).toString());
  $("#amount-expected-"+divId.toString()).val(expected.toFixed(2).toString());
  $("#percent-progress-bar-"+divId.toString()).css("width", Math.round(percentProgress).toString()+"%");

  if (percentProgress < 100) {
    $("#amount-current-"+divId.toString()).css("color","#57A957"); //green
    $("#amount-expected-"+divId.toString()).css("color","#57A957"); //green
    $("#percent-progress-"+divId.toString()).removeClass("progress-danger");
    $("#percent-progress-"+divId.toString()).addClass("progress-success");
  } else {
    $("#amount-current-"+divId.toString()).css("color","#DD514B"); //red
    $("#amount-expected-"+divId.toString()).css("color","#DD514B"); //red
    $("#percent-progress-"+divId.toString()).removeClass("progress-success");
    $("#percent-progress-"+divId.toString()).addClass("progress-danger");
  }

   if (!$("#energy-current-"+divId.toString()).is(":empty")){
   $("#energy-current-"+divId.toString()).empty();
  }

  if (!$("#energy-expected-"+divId.toString()).is(":empty")){
    $("#energy-expected-"+divId.toString()).empty();
  }

  $("#energy-current-"+divId.toString()).append(parseInt(current/0.11).toString() + " kWh");
  $("#energy-expected-"+divId.toString()).append(parseInt(expected/0.11).toString()+ " kWh");
};

var amountExpectedChangeHandler = function(){
  var divId = 0;
  for(divId = 0; divId < 5; divId++){
    var current = parseFloat($("#amount-current-"+divId.toString()).val());
    var expected = parseFloat($("#amount-expected-"+divId.toString()).val());
    updateBudgetWidgets(current, expected, divId);
  }
};

$(function() {
  displayBudgetWidgets();

  var divId = 0;
  for(divId = 0; divId < 5; divId++){
      $("#amount-expected-"+divId.toString()).change(amountExpectedChangeHandler);
  }
});