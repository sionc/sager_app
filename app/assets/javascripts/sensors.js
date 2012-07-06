var sensors = new Array;

// Setup the Ajax token for Javascript
var setupAjax = function() {
    $.ajaxSetup({
        beforeSend : function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
	  }
    });
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
var getSensorData = function() {
    var container = "#sensors-container";

    // If another page is loaded...
    if ($(container).length == 0) {
        return;
    }

    $.ajax({
        type: 'GET',
        url: '/sensors',
//        async: false,
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

    initializeSensorWidgets();
};

// Initialize sensor widgets
var initializeSensorWidgets = function() {
    var container = "#sensors-container";

    // If another page is loaded...
    if ($(container).length == 0) {
        return;
    }

    // If no sensors are found...
    if (sensors.length == 0) {
        $("</h6>No sensors detected</h6>").appendTo(container);
        return;
    }

    $(container).sortable({
        connectWith: container
    });

    // Create portlets for each sensor
    var i = 0;
    for (i = 0; i < sensors.length; i++) {
        var sensorContainer = $("<div></div>").appendTo(container).addClass("portlet");

        // Add sensor header
        var sensorHeader = $("<div></div>").appendTo(sensorContainer).addClass("portlet-header");
        $("<h4>" + sensors[i].label + "</h4>").appendTo(sensorHeader);

        // Add device content
        var sensorContent = $("<div></div>").appendTo(sensorContainer).addClass("portlet-content");

        // Add a fluid row and section the row into two equal spans
        var sensorRow = $("<div></div>").appendTo(sensorContent).addClass("row-fluid");

        // First half contains the sensor widgets
        var sensorWidgets = $("<div></div>").appendTo(sensorRow).addClass("span6");
        var sensorSwitchId = 'sensor-switch-'+sensors[i].id.toString();
        var sensorSwitch = $("<button></span></button>").appendTo(sensorWidgets)
            .addClass("btn btn-success sensor-switch").attr('data-toggle', 'button')
            .attr('id', sensorSwitchId).attr('autocomplete','off');

        // Add icon image to switch
        $("<i></i>").appendTo(sensorSwitch).addClass('icon-off icon-white icon-large');

        // Update the state of the sensor switch
        updateSensorSwitchState(sensorSwitchId, sensors[i].enabled);

        // Hook up the event handler
        $("#"+sensorSwitchId).click(sensorSwitchToggleHandler);

        // Second half contains the schedules
        var sensorSchedules = $("<div></div>").appendTo(sensorRow).addClass("span6");
        var sensorScheduleHeader =   $("<h5>Power Off Intervals</h5>").appendTo(sensorSchedules);
        var sensorScheduleTable = $("<table></table>").appendTo(sensorSchedules).addClass("table table-striped");

        // Add headers for device content table
        var sensorScheduleTableHeader = $("<thead></thead>").appendTo(sensorScheduleTable);
        var sensorScheduleTableHeaderRow = $("<tr></tr>").appendTo(sensorScheduleTableHeader);
        $("<th><h6>Start<h6></th>").appendTo(sensorScheduleTableHeaderRow);
        $("<th><h6>End<h6></th>").appendTo(sensorScheduleTableHeaderRow);
        $("<th><h6>Edit<h6></th>").appendTo(sensorScheduleTableHeaderRow);
        $("<th><h6>Delete<h6></th>").appendTo(sensorScheduleTableHeaderRow);

        // Add first row of the device content table
//        var deviceContentTableBody = $("<tbody></tbody>").appendTo(deviceContentTable);
//        var deviceContentTableBodyRow1 = $("<tr></tr>").appendTo(deviceContentTableBody);
//        var energy_today = sensors[i].current_day_kwh_usage;
//        var cost_today = (energy_today * 0.11).toFixed(2);
//        $("<td><p>Today</p></td>").appendTo(deviceContentTableBodyRow1);
//        $("<td><p>" + energy_today + " kWh</p></td>").appendTo(deviceContentTableBodyRow1);
//        $("<td><p>$" + cost_today + "</p></td>").appendTo(deviceContentTableBodyRow1);
//
//        // Add second row of the device content table
//        var deviceContentTableBodyRow2 = $("<tr></tr>").appendTo(deviceContentTableBody);
//        var energy_week = sensors[i].current_week_kwh_usage;
//        var cost_week = (energy_week * 0.11).toFixed(2);
//        $("<td><p>This Week</p></td>").appendTo(deviceContentTableBodyRow2);
//        $("<td><p>" + energy_week + " kWh</p></td>").appendTo(deviceContentTableBodyRow2);
//        $("<td><p>$" + cost_week + "</p></td>").appendTo(deviceContentTableBodyRow2);
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

$(function() {
    setupAjax();
    getSensorData();
});