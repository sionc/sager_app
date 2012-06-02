var sensors = new Array;
var usage = new Array;
var daysOfTheWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
var monthsInAYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// Get data associated with all sensors
var getSensorData = function() {
    $.ajax({
        type: 'GET',
        url: 'pages/user_sensors/',
        async: false,
        dataType: 'json',
        success: parseSensorData
    });
};

// Parse the sensor data
var parseSensorData = function(sensorData){
    if(sensorData.sensors.length == 0)
        return;

    var numSensors = sensorData.sensors.length;
    var i = 0;
    for(i = 0; i < numSensors; i++){
        var sensorObj = jQuery.parseJSON(JSON.stringify(sensorData.sensors[i]));
        sensors.push(sensorObj);
    }
};

// Use portlets to display appliances
var listDevices = function() {
    var container = "#sensor-list-container";

    // If another page is loaded...
    if($(container).length == 0){
        return;
    }

    // If no sensors are found...
    if(sensors.length == 0){
        $("</h6>No sensors detected</h6>").appendTo(container);
        return;
    }

    $( container ).sortable({
        connectWith: container
    });

     // Create portlets for each sensor
    var i = 0;
    for(i = 0; i < sensors.length; i++) {
        var deviceContainer = $("<div></div>").appendTo(container).addClass("portlet");

        // Add device header
        var deviceHeader = $("<div></div>").appendTo(deviceContainer).addClass("portlet-header");
        $("<h5>"+sensors[i].name+"</h5>").appendTo(deviceHeader);

        // Add device content
        var deviceContent = $("<div></div>").appendTo(deviceContainer).addClass("portlet-content");
        var deviceContentTable = $("<table></table>").appendTo(deviceContent).addClass("table table-condensed");

        // Add headers for device content table
        var deviceContentTableHeader = $("<thead></thead>").appendTo(deviceContentTable);
        var deviceContentTableHeaderRow = $("<tr></tr>").appendTo(deviceContentTableHeader);
        $("<th><h6>Duration<h6></th>").appendTo(deviceContentTableHeaderRow);
        $("<th><h6>Energy<h6></th>").appendTo(deviceContentTableHeaderRow);
        $("<th><h6>Cost<h6></th>").appendTo(deviceContentTableHeaderRow);

        // Add first row of the device content table
        var deviceContentTableBody = $("<tbody></tbody>").appendTo(deviceContentTable);
        var deviceContentTableBodyRow1 = $("<tr></tr>").appendTo(deviceContentTableBody);
        var energy_today = sensors[i].current_day_kwh_usage.toFixed(2);
        var cost_today = (energy_today * 0.11).toFixed(2);
        $("<td><p>Today</p></td>").appendTo(deviceContentTableBodyRow1);
        $("<td><p>"+energy_today+"kWh</p></td>").appendTo(deviceContentTableBodyRow1);
        $("<td><p>$"+cost_today+"</p></td>").appendTo(deviceContentTableBodyRow1);

        // Add second row of the device content table
        var deviceContentTableBodyRow2 = $("<tr></tr>").appendTo(deviceContentTableBody);
        var energy_7days = sensors[i].current_week_kwh_usage.toFixed(2);
        var cost_7days = (energy_7days * 0.11).toFixed(2);
        $("<td><p>This Week</p></td>").appendTo(deviceContentTableBodyRow2);
        $("<td><p>"+energy_7days+" kWh</p></td>").appendTo(deviceContentTableBodyRow2);
        $("<td><p>$"+cost_7days+"</p></td>").appendTo(deviceContentTableBodyRow2);
    }

    // Add classes to portlets
    $( ".portlet" ).addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
        .find( ".portlet-header" )
            .addClass( "ui-widget-header ui-corner-all" )
            .prepend( "<span class='ui-icon ui-icon-minusthick'></span>")
            .end()
        .find( ".portlet-content" );

    $( ".portlet-header .ui-icon" ).click(function() {
        $( this ).toggleClass( "ui-icon-minusthick" ).toggleClass( "ui-icon-plusthick" );
        $( this ).parents( ".portlet:first" ).find( ".portlet-content" ).toggle();
    });

    $(container).disableSelection();
};

// Display the usage chart for the week
var displayWeeklyUsageChart = function() {
    if($("#weekly-usage-chart").length == 0)
        return;

    // Set up the chart options using object literals
	var options = {
		chart: {
			renderTo: 'weekly-usage-chart',
			type: 'bar',
            backgroundColor: 'transparent',
            borderColor: '#DDD',
            borderWidth: '1',
            plotBackgroundColor: 'transparent'
		},
		title: {
			text: 'Energy Consumption (kwh)'
		},
		xAxis: {
			categories: []

		},
		yAxis: {
			min: 0,
			title: {
				text: ''
			}
		},
		legend: {
			backgroundColor: 'transparent',
            reversed: true
		},
		tooltip: {
			formatter: function() {
				return ''+
					this.series.name +': '+ this.y +' kwh';
			}
		},
		plotOptions: {
			series: {
				stacking: 'normal'
			}
		},
        series : []
	};

    // Add items to xAxis categories array
    for (i = 0; i < 7; i++) {
        var d = new Date();
        d.setDate(d.getDate()-i);
        var day = daysOfTheWeek[d.getUTCDay()];
        var month = monthsInAYear[d.getUTCMonth()];
        var date = d.getUTCDate();
        options.xAxis.categories.push(day+" "+month+" "+date);
    }

    // Add items to series array
    for (i = 0; i < sensors.length; i++) {
        options.series.push({
            name: sensors[i].name,
            data: sensors[i].last_7_day_kwh_usage_by_day
        });
    }

    // Create the chart
    var chart = new Highcharts.Chart(options);
};

$(function() {
    getSensorData();
    listDevices();
    displayWeeklyUsageChart();
});