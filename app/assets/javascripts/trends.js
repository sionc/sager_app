//// Get data associated with total usage
//var getTotalUsageData = function() {
//    if($("#total-usage-chart").length == 0)
//        return;
//
//    $.ajax({
//      type: 'GET',
//      url: 'http://www.highcharts.com/samples/data/jsonp.php?filename=aapl-v.json&callback=?',
//      dataType: 'json',
//      success: displayTotalUsageChart
//    });
//};
//
//// Display the total usage chart
//var displayTotalUsageChart = function(totalUsageData) {
//    var i = 0;
//    for(i = 0; i < totalUsageData.length; i++) {
//        totalUsageData[i][1] = 2 + Math.floor(Math.random()*3);
//    }
//
//    // create the chart
//    chart = new Highcharts.StockChart({
//        chart: {
//            renderTo: 'total-usage-chart',
//            alignTicks: false,
//            backgroundColor: 'transparent',
//            borderColor: '#DDD',
//            borderWidth: '1',
//            plotBackgroundColor: 'transparent'
//        },
//
//        rangeSelector: {
//            buttons: [
//                {
//                    type: 'day',
//                    count: 1,
//                    text: '1d'
//                }, {
//                    type: 'week',
//                    count: 1,
//                    text: '1w'
//                }, {
//                    type: 'month',
//                    count: 1,
//                    text: '1m'
//                }, {
//                    type: 'month',
//                    count: 3,
//                    text: '3m'
//                }, {
//                    type: 'month',
//                    count: 6,
//                    text: '6m'
//                }, {
//                    type: 'ytd',
//                    text: 'YTD'
//                }, {
//                    type: 'year',
//                    count: 1,
//                    text: '1y'
//                }, {
//                    type: 'all',
//                    text: 'All'
//                }
//            ],
//            selected: 2
//        },
////        plotOptions: {
////            column:{
////                dataLabels: {
////                enabled: true,
////                color: (Highcharts.getOptions().colors)[0],
////                style: {
////                    fontWeight: 'bold'
////                },
////                formatter: function() {
////                    return '$' + this.y;
////                }
////			}
////          }
////        },
//        title: {
//            text: 'Daily Energy Usage Data'
//        },
//        yAxis: {
//			title: {
//				text: 'Cost'
//			}
//		},
//        credits: {
//            enabled: false
//        },
//        series: [{
//            type: 'column',
//            name: 'Cost in $ ',
//            data: totalUsageData,
//            dataGrouping: {
//                units: [[
//                    'week', // unit name
//                    [1] // allowed multiples
//                ], [
//                    'month',
//                    [1, 2, 3, 4, 6]
//                ]]
//            }
//        }]
//    });
//};
//
//
//$(function() {
//    //getTotalUsageData();
//});