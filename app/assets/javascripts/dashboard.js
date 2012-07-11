var sensors = [];
var schedules = [];
var scheduleSensorId = -1;

// Setup the Ajax token for Javascript
var setupAjax = function() {
    $.ajaxSetup({
        beforeSend : function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
	  }
    });
};

// Parse time string to minutes since midnight
var toMinutes = function(timeString) {
//  var pattern = /(\d+):(\d+)(am)|(pm)/;
  var pattern = /^(\d{1,2})[:\.\s]+(\d{0,2})[\W]*([ap]m)/;
  var result = timeString.split(pattern);

  if(result.length < 4){
     alert("Failed to parse time string");
     return;
  }

  var hh = parseInt(result[1])%12;
  var mm = parseInt(result[2]);

  if((hh < 0) || (hh > 12)){
     alert("Invalid input");
     return;
  }

  if((mm < 0) || (mm > 59)){
     alert("Invalid input");
     return;
  }

  var isPm = (result[3] == "pm");

  var minutes = (hh * 60) + mm;
  if(isPm) { minutes = minutes + (12 * 60); }

  return minutes;
};

// Parse minutes to time string
var fromMinutes = function(minutes) {
    var hh = parseInt(minutes/60);
    var mm = parseInt(minutes%60);

    var suffix = "am";
    if(hh > 12){
       suffix = "pm";
       hh = hh % 12;
    }

    if((hh == 0) && (suffix == "am")) { hh = 12; }

    var timeString = hh.toString();
    timeString = timeString + ":"+mm.toString();

    if(mm < 10) { timeString = timeString + "0";}

    return timeString + suffix;
};

// Handle a toggle sensor switch event
var sensorSwitchToggleHandler = function() {
    var sensorSwitchId =  $(this).attr("id");
    var sensorId = sensorSwitchId.substr(("sensor-switch-").length);
    var desiredState = 0;

    //find the sensor index
    var i = 0;
    var index = 0;
    for(i = 0; i < sensors.length; i++) {
        if(sensors[i].id == parseInt(sensorId)) {
           index = i;
           break;
        }
    }

    // Based on the current state, deduce the desired state
    if (sensors[index].enabled) {
        desiredState = 0;
    } else {
        desiredState = 1;
    }

    $.ajax({
      type: "PUT",
      url: "/sensors/"+sensorId,
      data: {sensor:{enabled:desiredState.toString()}},
      dataType: "json",
	  error : function() {
        alert("Failed to toggle switch. Please try again...");
	  },
      success: function() {
         sensors[index].enabled = desiredState;
         updateSensorSwitchState(sensorSwitchId, desiredState);
      }
    });
};

// Update a sensor switch state
var updateSensorSwitchState = function(id, enabled) {
    if(enabled){
         $("#"+id).addClass('active');
         $("#"+id).addClass('btn-success');
    } else {
         $("#"+id).removeClass('active');
         $("#"+id).removeClass('btn-success');
    }
};

// Get data associated with all sensors
var getSensorsData = function() {
    sensors = [];

    $.ajax({
        type: 'GET',
        url: '/sensors',
        dataType: 'json',
        timeout:20000,
        success: parseSensorsData
    });
};

// Parse the sensor data
var parseSensorsData = function(sensorData) {
    if (sensorData.sensors.length == 0)
        return;

    var numSensors = sensorData.sensors.length;
    var i = 0;
    for (i = 0; i < numSensors; i++) {
        var sensorObj = jQuery.parseJSON(JSON.stringify(sensorData.sensors[i]));
        sensors.push(sensorObj);
    }

//    sensors.sort(function(a, b) {return b.sensor_id - a.sensor_id});

    initializeSensorWidgets();
};

// Initialize sensor widgets
var initializeSensorWidgets = function() {
    var containers = [ "#sensors-container-1","#sensors-container-2"];

    // If another page is loaded...
    if ($(containers[0]).length == 0) {
        return;
    }

    // If no sensors are found...
    if (sensors.length == 0) {
        $("</h6>No sensors detected</h6>").appendTo(containers[0]);
        return;
    }

    $("#sensor-content").sortable({
        connectWith: "#sensor-content"
    });

    // Create portlets for each sensor
    var i = 0;
    for (i = 0; i < sensors.length; i++) {
        var container = containers[i%2];
        var sensorId =  sensors[i].id.toString();
        var sensorContainer = $("<div></div>").appendTo(container).addClass("portlet");

        // Add sensor header
        var sensorHeader = $("<div></div>").appendTo(sensorContainer).addClass("portlet-header");
        $("<h4>" + sensors[i].label + "</h4>").appendTo(sensorHeader);

        // Add device content
        var sensorContent = $("<div></div>").appendTo(sensorContainer).addClass("portlet-content");

        // Add a fluid row and section the row into two equal spans
        var sensorRow1 = $("<div></div>").appendTo(sensorContent).addClass("row-fluid");
        var sensorRow1WidgetSpan = $("<div></div>").appendTo(sensorRow1).addClass("span12");
        var sensorWidgetTable= $("<table></table>").appendTo(sensorRow1WidgetSpan)
            .addClass("table sensor-widgets-table");
        var sensorWidgetTableHeader = $("<thead></thead>").appendTo(sensorWidgetTable);
        var sensorWidgetTableRow1 = $("<tr></tr>").appendTo(sensorWidgetTableHeader);
        var sensorSwitchCell = $("<th></th>").appendTo(sensorWidgetTableRow1);
        var sensorUsageCell = $("<th></th>").appendTo(sensorWidgetTableRow1);
        var sensorWidgetTableBody = $("<tbody></tbody>").appendTo(sensorWidgetTable);
        var sensorWidgetTableRow2 = $("<tr></tr>").appendTo(sensorWidgetTableBody);
        var sensorSpaceCell1 = $("<td></td>").appendTo(sensorWidgetTableRow2);
        var sensorSpaceCell2 = $("<td></td>").appendTo(sensorWidgetTableRow2);

        // First half contains the sensor widgets
        var sensorSwitchId = 'sensor-switch-'+sensorId;
        var sensorSwitch = $("<button></button>").appendTo(sensorSwitchCell)
            .addClass("btn btn-success active sensor-switch").attr('data-toggle', 'button')
            .attr('id', sensorSwitchId).attr('autocomplete','off');

        // Add icon image to switch
        $("<i></i>").appendTo(sensorSwitch).addClass('icon-off icon-white icon-large');

        // Update the state of the sensor switch
        updateSensorSwitchState(sensorSwitchId, sensors[i].enabled);

        // Hook up the event handler for handling the sensor switch toggle
        $("#"+sensorSwitchId).click(sensorSwitchToggleHandler);

        var sensorUsage = $("<div></div>").appendTo(sensorUsageCell).addClass("content well usage-total");
        $("<div><h6>This Month</h6></div>").appendTo(sensorUsage);
        $("<div></div>").appendTo(sensorUsage).attr('id','usage-cost-month-'+sensorId);
        $("<div></div>").appendTo(sensorUsage).attr('id','usage-kwh-month-'+sensorId);
        //getCurrentMonthKwhUsageData(parseInt(sensorId));
        updateCurrentMonthUsageData(parseInt(sensorId));

        // Second row contains the schedules
        var sensorRow2 = $("<div></div>").appendTo(sensorContent).addClass("row-fluid");
        var sensorRow2ScheduleSpan = $("<div></div>").appendTo(sensorRow2).addClass("span12 schedule-list");

        $("<h5>Power off schedule</h5>").appendTo(sensorRow2ScheduleSpan);
        var sensorScheduleTable = $("<table></table>").appendTo(sensorRow2ScheduleSpan)
            .addClass("table table-striped")
            .attr("id","schedule-list-"+sensorId);
        $("<button>Add</button>").appendTo(sensorRow2ScheduleSpan)
            .addClass("btn btn-success")
            .attr("id","create-schedule-"+sensorId)
            .button().click(addScheduleButtonClickHandler);

        // Add headers for device content table
        var sensorScheduleTableHeader = $("<thead></thead>").appendTo(sensorScheduleTable);
        var sensorScheduleTableHeaderRow = $("<tr></tr>").appendTo(sensorScheduleTableHeader);
        $("<th><h6>From<h6></th>").appendTo(sensorScheduleTableHeaderRow);
        $("<th><h6>to<h6></th>").appendTo(sensorScheduleTableHeaderRow);
//        $("<th><h6>Edit<h6></th>").appendTo(sensorScheduleTableHeaderRow);
//        $("<th><h6>Delete<h6></th>").appendTo(sensorScheduleTableHeaderRow);

        // Add schedule list to the sensor widget
        $("<tbody></tbody>").appendTo(sensorScheduleTable);
        getScheduleData(parseInt(sensorId));
    }

    // Add classes to portlets
    $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix")
        .find(".portlet-header")
        .addClass("ui-widget-header ui-widget-header-text")
        .prepend("<span class='ui-icon ui-icon-minusthick'></span>")
        .end()
        .find(".portlet-content");

    $(".portlet-header .ui-icon").click(function() {
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();
    });

    $(container).disableSelection();
};

// Handles the Add Schedule button click
var addScheduleButtonClickHandler = function() {
    scheduleSensorId = $(this).attr("id").substr(("create-schedule-").length);
    $( "#create-schedule-dialog-form" ).dialog( "open" );
};

// Modal dialog for schedule
var initializeScheduleDialog = function() {
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
        $("#start-time").timepicker();
        $("#end-time").timepicker();

		var startTimeField = $( "#start-time" ),
			endTimeField = $( "#end-time" ),
			allFields = $( [] ).add( startTimeField ).add( endTimeField );

		$( "#create-schedule-dialog-form" ).dialog({
			autoOpen: false,
			height: 250,
			width: 350,
			modal: true,
			buttons: {
				Save: function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

                    var startTime = $( "#start-time" ).val();
                    var endTime = $( "#end-time" ).val();

                    bValid = ((startTime != "") && (endTime != ""));

					if (!bValid ) {
                       alert("Invalid duration");
                       return;
					}

                    $.ajax({
                          type: "POST",
                          url: "/schedules",
                          data: {schedule:{sensor_id:scheduleSensorId,start_time:toMinutes(startTime),
                              end_time:toMinutes(endTime)}},
                          dataType: "json",
                          error : function() {
                            alert("Failed to save duration. Please try again...");
                          },
                          success: function() {
                             updateScheduleList(scheduleSensorId, startTime, endTime);
                             $( "#create-schedule-dialog-form" ).dialog( "close" );
                          }
                      });
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});
	};

// Get data associated with schedules
var getScheduleData = function(sensorId) {
    schedules = [];

    $.ajax({
        type: 'GET',
        url: '/schedules?sensor_id='+sensorId.toString(),
        dataType: 'json',
        async:false,
        timeout:20000,
        success: parseScheduleData,
        error: function(){ alert("Failed to update schedules"); }
    }).done(initializeScheduleList(sensorId));
};

// Parse the sensor data
var parseScheduleData = function(scheduleData) {
    var numSchedules = scheduleData.schedules.length;
    var i = 0;
    for (i = 0; i < numSchedules; i++) {
        var scheduleObj = jQuery.parseJSON(JSON.stringify(scheduleData.schedules[i]));
        schedules.push(scheduleObj);
    }
};

// Initialize schedule list for the specified sensor
var initializeScheduleList = function(sensorId) {
    var i = 0;
    for (i = 0; i < schedules.length; i++) {
        var startTime = fromMinutes(schedules[i].start_time).toString();
        var endTime = fromMinutes(schedules[i].end_time).toString();
        updateScheduleList(sensorId, startTime, endTime);
    }
};

// Update schedule list
var updateScheduleList = function(sensorId, startTime, endTime) {
    var scheduleTableBody = "#schedule-list-"+sensorId.toString();
    var scheduleTableBodyRow = $("<tr></tr>").appendTo(scheduleTableBody);
    $("<td><p>"+startTime+"</p></td>").appendTo(scheduleTableBodyRow);
    $("<td><p>"+endTime+"</p></td>").appendTo(scheduleTableBodyRow);
};

// Get the current month's kwh usage data
var getCurrentMonthKwhUsageData = function (sensorId) {
    $.ajax({
        type: 'GET',
        url: '/sensors/get_current_month_kwh_usage',
        data: {sensor_id:sensorId},
        dataType: 'json',
        timeout:20000,
        success: function(data) {
             var usage = data.current_month_kwh_usage;
             $("<h2>$"+(usage * 0.13).toFixed(2)+"</h2>").appendTo("#usage-cost-month-"+sensorId.toString());
             $("<h6>"+usage+" kWh</h6>").appendTo("#usage-kwh-month-"+sensorId.toString());
        }
    });
};

// Update current month usage data
var updateCurrentMonthUsageData = function (sensorId) {
   var usage = 20000 + parseInt(Math.floor(Math.random()*28897));
   $("<h2>$"+((usage/1000) * 0.15).toFixed(2)+"</h2>").appendTo("#usage-cost-month-"+sensorId.toString());
   $("<h6>"+usage+" watt hours</h6>").appendTo("#usage-kwh-month-"+sensorId.toString());
};

$(function() {
    setupAjax();
    initializeScheduleDialog();
    getSensorsData();
});