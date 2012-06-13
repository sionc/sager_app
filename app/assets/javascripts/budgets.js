// Get data associated with budget sensors
var displayBudgetWidgets = function() {
 var current = 15.0;
 var expected = 20.0;

//    <div class="well budget-content">
//          <h4 class="budget-sensor">Television</h4>

//          <form class="budget-amounts form-inline">
//            <div class="input-prepend">
//            <span class="add-on">$</span><input class="budget-amount-current span7 disabled" size=6
//                                                  id="amount-current" type="text" disabled="">
//            </div>
//            <span class="help-inline">of &nbsp</span>
//            <div class="input-prepend">
//              <span class="add-on">$</span><input class="budget-amount-expected span7" size=6
//                                                  id="amount-expected" type="text">
//            </div>
//          </form>

//          <br/><br/>

//          <div class="progress progress-success" style="margin-bottom: 1px;">
//            <div class="bar" id="percent-progress-bar" style="width: 40%"></div>
//          </div>

//          <br/>

//           <div class="budget-energy">
//            <h6 id="energy-current"></h6>
//            <h6>&nbsp of &nbsp</h6>
//            <h6 id="energy-expected"></h6>
//          </div>

//          <label class="checkbox">
//            <input type="checkbox">Notify me when I exceed my budget
//          </label>

//        </div>


 updateBudgetWidgets(current, expected);
};

var updateBudgetWidgets = function(current, expected){
  var percentProgress = (current/expected)*100;
  $("#amount-current").val(current.toFixed(2).toString());
  $("#amount-expected").val(expected.toFixed(2).toString());
  $("#percent-progress-bar").css("width", Math.round(percentProgress).toString()+"%");

  if (percentProgress < 100) {
    $("#amount-current").css("color","#57A957"); //green
    $("#amount-expected").css("color","#57A957"); //green
    $("#percent-progress").removeClass("progress-danger");
    $("#percent-progress").addClass("progress-success");
  } else {
    $("#amount-current").css("color","#DD514B"); //red
    $("#amount-expected").css("color","#DD514B"); //red
    $("#percent-progress").removeClass("progress-success");
    $("#percent-progress").addClass("progress-danger");
  }

   if (!$("#energy-current").is(":empty")){
   $("#energy-current").empty();
  }

  if (!$("#energy-expected").is(":empty")){
    $("#energy-expected").empty();
  }

  $("#energy-current").append(parseInt(current/0.11).toString() + " kWh");
  $("#energy-expected").append(parseInt(expected/0.11).toString()+ " kWh");
};

var amountExpectedChangeHandler = function(){
  var current = parseFloat($("#amount-current").val());
  var expected = parseFloat($("#amount-expected").val());

  updateBudgetWidgets(current, expected);
};

$(function() {
  displayBudgetWidgets();
  $('#amount-expected').change(amountExpectedChangeHandler);
});