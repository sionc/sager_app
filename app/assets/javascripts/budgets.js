// Get data associated with all sensors
var getBudgetData = function() {
    var container = "#device-budgets-container";

    // If another page is loaded...
    if ($(container).length == 0) {
        return;
    }

    if(sensors.length != 0) {
        return;
    }

    $.ajax({
        type: 'GET',
        url: '/sensors',
        async: false,
        dataType: 'json',
        success: parseSensorData
    });
};

// Parse the sensor data
var parseSensorData = function(sensorData) {
    if (sensorData.sensors.length == 0)
        return;

    var numSensors = sensorData.sensors.length;
    var i = 0;
    for (i = 0; i < numSensors; i++) {
        var sensorObj = jQuery.parseJSON(JSON.stringify(sensorData.sensors[i]));
        sensors.push(sensorObj);
    }
};

// Initialize budget widgets
var initializeBudgetWidgets = function() {
    var i = 0;
    var divId = "";
    var name = "";

    // Total budget
    divId = "total";
    name = "Total Usage";
    createBudgetWidget("#total-budget-container", divId, name);
    updateBudgetWidget(32.23,40, divId);
    $("#amount-expected-"+divId).change(amountExpectedChangeHandler);

    // Device budgets
    for(i = 0; i < sensors.length; i++) {
       divId = sensors[i].id.toString();
       name = sensors[i].name;
       createBudgetWidget("#device-budgets-container", divId, name);
       var currentAmount = 5 + Math.random()*3;
       var expectedAmount = Math.floor(currentAmount) + Math.floor(Math.random()*4);
       updateBudgetWidget(currentAmount,expectedAmount, divId);
       $("#amount-expected-"+divId).change(amountExpectedChangeHandler);
    }
};

// Create budget widgets
var createBudgetWidget = function(container, divId, name) {
    var budgetContainer = $("<div></div>").addClass("well budget-content").appendTo(container);

    // Budget rows
    var row1 = $("<div></div>").addClass("row-fluid").appendTo(budgetContainer);
    $("<br />").appendTo(budgetContainer);
    var row2 = $("<div></div>").addClass("row-fluid").appendTo(budgetContainer);
    $("<br />").appendTo(budgetContainer);
    var row3 = $("<div></div>").addClass("row-fluid").appendTo(budgetContainer);

    // Row 1 divs
    var titleSpan = $("<div></div>").addClass("span4").appendTo(row1);
    $("<h4>"+name+"</h4>").addClass("budget-sensor").appendTo(titleSpan);

    var amountsSpan = $("<div></div>").addClass("span8").appendTo(row1);
    var amountsForm = $("<form></form>").addClass("budget-amounts form-inline").appendTo(amountsSpan);
    var amountCurrentDiv = $("<div></div>").addClass("input-prepend").appendTo(amountsForm);
    $("<span>$</span>").addClass("add-on").appendTo(amountCurrentDiv);
    $("<input size=8 type='text' disabled=''>").addClass("budget-amount-current span7 disabled")
        .attr('id', 'amount-current-'+divId).appendTo(amountCurrentDiv);
    var amountExpectedDiv = $("<div></div>").addClass("input-prepend").appendTo(amountsForm);
    $("<span>$</span>").addClass("add-on").appendTo(amountExpectedDiv);
    $("<input size=8 type='text'>").addClass("budget-amount-expected span7 disabled")
        .attr('id', 'amount-expected-'+divId).appendTo(amountExpectedDiv);

    // Row 2 divs
    var progressSpan = $("<div></div>").addClass("span12").appendTo(row2);
    var progressBarDiv = $("<div></div>").addClass("progress progress-success budget-progress")
        .attr('id', 'percent-progress-'+divId).appendTo(progressSpan);
    $("<div></div>").addClass("bar").attr('id', 'percent-progress-bar-'+divId)
        .appendTo(progressBarDiv);

    // Row 3 divs
    var notifySpan = $("<div></div>").addClass("span6").appendTo(row3);
    var notifyDiv = $("<div></div>").addClass("budget-notify").appendTo(notifySpan);
    $("<label></label>").addClass("checkbox").appendTo(notifyDiv)
        .append("<input type='checkbox'>Notify me when I exceed this budget");
};

// Update budget widgets
var updateBudgetWidget = function(current, expected, divId){
  var percentProgress = (current/expected)*100;
  $("#amount-current-"+divId).val(current.toFixed(2).toString());
  $("#amount-expected-"+divId).val(expected.toFixed(2).toString());
  $("#percent-progress-bar-"+divId).css("width", Math.round(percentProgress).toString()+"%");

  if (percentProgress < 100) {
    $("#amount-current-"+divId).css("color","#57A957"); //green
    $("#amount-expected-"+divId).css("color","#57A957"); //green
    $("#percent-progress-"+divId).removeClass("progress-danger");
    $("#percent-progress-"+divId).addClass("progress-success");
  } else {
    $("#amount-current-"+divId).css("color","#DD514B"); //red
    $("#amount-expected-"+divId).css("color","#DD514B"); //red
    $("#percent-progress-"+divId).removeClass("progress-success");
    $("#percent-progress-"+divId).addClass("progress-danger");
  }

//   if (!$("#energy-current-"+divId.toString()).is(":empty")){
//   $("#energy-current-"+divId.toString()).empty();
//  }
//
//  if (!$("#energy-expected-"+divId.toString()).is(":empty")){
//    $("#energy-expected-"+divId.toString()).empty();
//  }
//
//  $("#energy-current-"+divId.toString()).append(parseInt(current/0.11).toString() + " kWh");
//  $("#energy-expected-"+divId.toString()).append(parseInt(expected/0.11).toString()+ " kWh");
};

var amountExpectedChangeHandler = function(){
    var divId = $(this).attr("id").substr(("amount-expected-").length);
    var current = parseFloat($("#amount-current-"+divId).val());
    var expected = parseFloat($("#amount-expected-"+divId).val());
    updateBudgetWidget(current, expected, divId);
};

$(function() {
  getBudgetData();
  initializeBudgetWidgets();
});