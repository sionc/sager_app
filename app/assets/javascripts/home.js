var sensors = new Array;
var daysOfTheWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
var monthsInAYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// Get data associated with all sensors
var getSensorData = function() {
    $.ajax({
        type: 'GET',
        url: '/sensors',
        async: false,
        dataType: 'json',
        success: parseSensorData
    });
};

// Get total usage data
var getTotalUsageData = function() {
    $.ajax({
        type: 'GET',
        url: '',
        async: false,
        dataType: 'xml',
        success: parseTotalUsageData
    });
};

// Parse the total usage data
var parseTotalUsageData = function(totalUsageData){
    alert(totalUsageData.length);
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
        var energy_today = sensors[i].current_day_kwh_usage;
        var cost_today = (energy_today * 0.11).toFixed(2);
        $("<td><p>Today</p></td>").appendTo(deviceContentTableBodyRow1);
        $("<td><p>"+energy_today+" kWh</p></td>").appendTo(deviceContentTableBodyRow1);
        $("<td><p>$"+cost_today+"</p></td>").appendTo(deviceContentTableBodyRow1);

        // Add second row of the device content table
        var deviceContentTableBodyRow2 = $("<tr></tr>").appendTo(deviceContentTableBody);
        var energy_week = sensors[i].current_week_kwh_usage;
        var cost_week = (energy_week * 0.11).toFixed(2);
        $("<td><p>This Week</p></td>").appendTo(deviceContentTableBodyRow2);
        $("<td><p>"+energy_week+" kWh</p></td>").appendTo(deviceContentTableBodyRow2);
        $("<td><p>$"+cost_week+"</p></td>").appendTo(deviceContentTableBodyRow2);
    }

    // Add classes to portlets
    $( ".portlet" ).addClass( "ui-widget ui-widget-content ui-helper-clearfix" )
        .find( ".portlet-header" )
            .addClass( "ui-widget-header ui-widget-header-text" )
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
//var displayWeeklyUsageChart = function() {
//    if($("#weekly-usage-chart").length == 0)
//        return;
//
//    // Set up the chart options using object literals
//	var options = {
//		chart: {
//			renderTo: 'weekly-usage-chart',
//			type: 'bar',
//            backgroundColor: 'transparent',
//            borderColor: '#DDD',
//            borderWidth: '1',
//            plotBackgroundColor: 'transparent'
//		},
//		title: {
//			text: 'Energy Consumption (kwh)'
//		},
//		xAxis: {
//			categories: []
//
//		},
//		yAxis: {
//			min: 0,
//			title: {
//				text: ''
//			}
//		},
//		legend: {
//			backgroundColor: 'transparent',
//            reversed: true
//		},
//		tooltip: {
//			formatter: function() {
//				return ''+
//					this.series.name +': '+ this.y +' kwh';
//			}
//		},
//		plotOptions: {
//			series: {
//				stacking: 'normal'
//			}
//		},
//        credits: {
//            enabled: false
//        },
//        series : []
//	};
//
//    // Add items to xAxis categories array
//    for (i = 0; i < 7; i++) {
//        var d = new Date();
//        d.setDate(d.getDate()-i);
//        var day = daysOfTheWeek[d.getUTCDay()];
//        var month = monthsInAYear[d.getUTCMonth()];
//        var date = d.getUTCDate();
//        options.xAxis.categories.push(day+" "+month+" "+date);
//    }
//
//    // Add items to series array
//    for (i = 0; i < sensors.length; i++) {
//        options.series.push({
//            name: sensors[i].name,
//            //data: sensors[i].last_7_day_kwh_usage_by_day
//            data: [10, 14, 9, 11, 7, 10, 12]
//        });
//    }
//
//    // Create the chart
//    var chart = new Highcharts.Chart(options);
//};

// Display the usage chart for the last 7 days

// Display 7 day usage
var display7DayUsageChart = function() {
    var i = 0, j = 0;
    var categories = new Array;

    // Add items to categories array
    for (i = 0; i < 7; i++) {
        var d = new Date();
        d.setDate(d.getDate()-i);
        var day = daysOfTheWeek[d.getDay()];
        var month = monthsInAYear[d.getMonth()];
        var date = d.getDate();
        categories.push(day+" "+month+" "+date);
    }

    // Add sensor names to list
    var sensorNames = new Array;
    for(i = 0; i < sensors.length; i++) {
        sensorNames.push(sensors[i].name);
    }

    // Chart data
    var colors = Highcharts.getOptions().colors;
    var totalUsage = [18, 12, 16, 14, 13, 12, 11];
    var data = new Array;
    for (i = 0; i < categories.length; i++) {
        var sensorUsageByDay = new Array;
        for(j = 0; j < sensors.length; j++) {
            sensorUsageByDay.push(sensors[j].last_7_day_kwh_usage_by_day[i]);
        }
        data.push({
            y: totalUsage[i],
            color: colors[0],
            drilldown: {
                name: categories[i].toString(),
                categories: sensorNames,
                data: sensorUsageByDay,
                color: colors[2]
            }
        });
    }

	function setChart(name, categories, data, color) {
        chart.xAxis[0].setCategories(categories);
        chart.series[0].remove();
        chart.addSeries({
			name: name,
			data: data,
			color: color || 'white'
		});
	}

    var name = "Energy Usage";
	chart = new Highcharts.Chart({
		chart: {
			renderTo: '7day-usage-chart',
			type: 'column',
            backgroundColor: 'transparent',
            borderColor: '#DDD',
            borderWidth: '1',
            plotBackgroundColor: 'transparent'
		},
		title: {
			text: ''
		},
		subtitle: {
			text: 'Click the columns to view energy usage for each appliance. Click again to view total energy usage ' +
                'for' +' the day.'
		},
		xAxis: {
			categories: categories,
            minRange: 1
		},
		yAxis: {
			title: {
				text: 'Cost'
			}
		},
		plotOptions: {
			column: {
				cursor: 'pointer',
				point: {
					events: {
						click: function() {
							var drilldown = this.drilldown;
							if (drilldown) { // drill down
								setChart(drilldown.name, drilldown.categories, drilldown.data, drilldown.color);
							} else { // restore
								setChart(name, categories, data);
							}
						}
					}
				},
				dataLabels: {
					enabled: true,
					color: colors[0],
					style: {
						fontWeight: 'bold'
					},
					formatter: function() {
						return '$' + this.y;
					}
				}
			}
		},
		tooltip: {
			formatter: function() {
				var point = this.point,
					s = this.x +':<b>'+ '$'+this.y+'</b><br/>';
				if (point.drilldown) {
					s += 'Click to view '+ point.category +' energy usage by appliance';
				} else {
					s += 'Click to return to total energy usage';
				}
				return s;
			}
		},
		series: [{
			name: name,
			data: data,
			color: 'white'
		}],
		exporting: {
			enabled: false
		},
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        }
	});
};

$(function() {
    getSensorData();
    //getTotalUsageData();
    listDevices();
    //displayWeeklyUsageChart();
    display7DayUsageChart();
});