var chart;
$(function() {
    if($("#weekly-usage-chart").length == 0)
        return;

	chart = new Highcharts.Chart({
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
			categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
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
			series: [{
            name: 'Television',
			data: [5, 3, 4, 7, 2]
		}, {
			name: 'Desktop',
			data: [2, 2, 3, 2, 1]
		}, {
			name: 'Space Heater',
			data: [3, 4, 4, 2, 5]
		},{
            name: 'Washer',
			data: [5, 3, 4, 7, 2]
		}, {
			name: 'Dryer',
			data: [2, 2, 3, 2, 1]
		}]
	});
});

// Use portlets to display appliances
$(function() {
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
});