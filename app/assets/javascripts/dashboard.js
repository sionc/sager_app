var internalScheduleSensorId = -1;
var domScheduleSensorId = -1;

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
var sensorSwitchToggleHandler = function(e) {

    var target = e.target,
      $target = $(target);

    // the handler is bound to the container of buttons, so we need to
    // ensure that whatever was clicked is indeed the designated set of
    // buttons
    if((/^sensor-switch-/).test(target.id))
    {
      // the internal id of each sensor is saved in the data-id attr
      var sensorId = $target.parents('div[id^="sensor-container-"]').attr('data-id')
      var desiredState = 0;
      desiredState = !$target.hasClass('active');

      $.ajax({
        type: "PUT",
        url: "/sensors/"+sensorId,
        data: {sensor:{enabled:desiredState.toString()}},
        dataType: "json",
      error : function() {
          alert("Failed to toggle switch. Please try again...");
      },
        success: function() {
           updateSensorSwitchState(target.id, desiredState);
        }
      });
    }
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

// Handles the Add Schedule button click
var addScheduleButtonClickHandler = function(e) {

    var target = e.target,
      $target = $(target);

    if((/^create-schedule-/).test(target.id))
    {
      internalScheduleSensorId = $target.parents('div[id^="sensor-container-"]').attr('data-id');
      domScheduleSensorId = $target.attr('id').substring('create-schedule-'.length)
      $("#create-schedule-dialog-form").dialog( "open" );
    }
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
            data: {schedule:{sensor_id:internalScheduleSensorId,start_time:toMinutes(startTime),
                end_time:toMinutes(endTime)}},
            dataType: "json",
            error : function() {
              alert("Failed to save duration. Please try again...");
            },
            success: function() {
               updateScheduleList(domScheduleSensorId, startTime, endTime);
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

// Update schedule list
var updateScheduleList = function(sensorId, startTime, endTime) {
    var scheduleTableBody = "#schedule-list-"+sensorId.toString();
    var scheduleTableBodyRow = $("<tr></tr>").appendTo(scheduleTableBody);
    $("<td><p>"+startTime+"</p></td>").appendTo(scheduleTableBodyRow);
    $("<td><p>"+endTime+"</p></td>").appendTo(scheduleTableBodyRow);
};

var setupBubblePopup = function(){
    // setup bubble popup
    $('#navbar_addsensor_link').CreateBubblePopup({
      innerHtml: 'Welcome to PolarMeter! We noticed that you have not added a single Sensor yet. Click here to fix that!',
      themeMargins: {total: '60px', difference: '0px'},
      themePath: '/assets/jquerybubblepopup-themes',
      themeName: 'blue',
      manageMouseEvents: false})

    if(document.URL.indexOf("/pages/dashboard") != -1 && !$('div[id^="sensor-container-"]').length){
      $('#navbar_addsensor_link').ShowBubblePopup();
    }
}

$(function() {
    setupAjax();
    initializeScheduleDialog();

    // registring handlers
    $('#sensor-content').click(sensorSwitchToggleHandler);
    $('#sensor-content').click(addScheduleButtonClickHandler);
    setupBubblePopup();
});
