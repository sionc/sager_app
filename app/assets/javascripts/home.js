$(document).ready(function() {
	var seriesOptions = [],
		yAxisOptions = [],
		seriesCounter = 0,
		names = ['MSFT', 'AAPL', 'GOOG'],
		colors = Highcharts.getOptions().colors;

	$.each(names, function(i, name) {

		$.getJSON('http://www.highcharts.com/samples/data/jsonp.php?filename='+ name.toLowerCase() +'-c.json&callback=?'
            , function(data) {

			seriesOptions[i] = {
				name: name,
				data: data
			};

			// As we're loading the data asynchronously, we don't know what order it will arrive. So
			// we keep a counter and create the chart when all the data is loaded.
			seriesCounter++;

			if (seriesCounter == names.length) {
				createChart();
			}
		});
	});



	// create the chart when all data is loaded
	function createChart() {

		chart = new Highcharts.StockChart({
		    chart: {
		        renderTo: 'usage-chart'
		    },

		    rangeSelector: {
		        selected: 4
		    },

		    yAxis: {
		    	labels: {
		    		formatter: function() {
		    			return (this.value > 0 ? '+' : '') + this.value + '%';
		    		}
		    	},
		    	plotLines: [{
		    		value: 0,
		    		width: 2,
		    		color: 'silver'
		    	}]
		    },

		    plotOptions: {
		    	series: {
		    		compare: 'percent'
		    	}
		    },

		    tooltip: {
		    	pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
		    	valueDecimals: 2
		    },

		    series: seriesOptions
		});
	}

    // Use portlets to display appliances
    $(function() {
		$( "#appliance-listing-container" ).sortable({
			connectWith: "#appliance-listing-container"
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

		$( "#appliance-listing-container" ).disableSelection();
	});
});
