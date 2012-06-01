var sensors = new Array;
var daysOfTheWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
var monthsInAYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// Get data associated with all sensors
var getSensorData = function() {
    $.ajax({
        type: 'GET',
        url: '/sensors/',
        async: false,
        dataType: 'json',
        success: parseSensorData
    });
};

// Parse the sensor data
var parseSensorData = function(sensorData){
    if(sensorData.sensors.length == 0)
        return;

    var i = 0;
    for(i = 0; i < sensorData.sensors.length; i++){
        var obj = jQuery.parseJSON(JSON.stringify(sensorData.sensors[i]));
        sensors.push(obj);
    }
};

// Use portlets to display appliances
var listDevices = function() {
    var container = "#device-list-container";
    if($(container).length == 0)
        return;

    $( container ).sortable({
        connectWith: container
    });

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
            data: [1,1,1,1,1,1,1]
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