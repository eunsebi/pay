/**
 * 제이쿼리 영역
 */
$(function(){
	getJSON(vo,{seq:1});
	
	$('#eText').keydown(function(e){
		if(e.keyCode == 13){
			$('#employeeSearch').click();
		}
	});
	
	$('#addEmployee').click(function(){
		userModal.show();
	});
	
	$('#addUserBtn').click(function(){
		$.ajax({
			url : getContextPath()+"/user/addEmployee.do",
			type : 'post',
			data : {email : $('#user-email').val(),name : $('#user-name').val(),phone : $('#user-phone').val()},
			success : function(response){
				alert(JSON.parse(response).msg);
				$('#user-email').val('');
				$('#user-name').val('');
				$('#user-phone').val('');
				userModal.hide();
			}
		});
	});
	
	$('#employeeSearch').click(function(){
		var eText = $('#eText').val();
		var sType = searchCombo.getValue();
		if(trim(eText) != ''){
			$('.user-work').hide();
			$('.Employee-container>div').each(function(){
				$(this).css('width','97%');
				$(this).attr('clicked','false');
				if(sType == 3){
					if($(this).attr('name').indexOf(eText) != -1){
						$(this).show();
					}else{
						$(this).hide();
					}
				}else if(sType == 4){
					if($(this).attr('phone').indexOf(eText) != -1){
						$(this).show();
					}else{
						$(this).hide();
					}
				}else if(sType == 5){
					if($(this).attr('email').indexOf(eText) != -1){
						$(this).show();
					}else{
						$(this).hide();
					}
				}
			}); 
		}else{
			$('.user-work').hide();
			$('.Employee-container>div').each(function(){
				$(this).css('width','97%');
				$(this).attr('clicked','false');
				$(this).removeClass('clicked');
				$(this).removeClass('notify-red');
				$(this).show();
			});
		}
	});
	
	$('#etc-chart').click(function(){
		$.getJSON(getContextPath()+"/home/getChart.do",{},function(response){
			var result = response;
			var array = new Array();
			for(var i = 0 ; i < result.length ; i ++){
				var color1 = '#';
				for(var j = 0 ; j < 6 ; j ++){
					color1 += parseInt(Math.random()*(15)).toString(16);
				}
				var chart = {
						val : result[i].cnt,
						label : result[i].name,
						stColor : color1,
						edColor : 'white',
						textColor : 'black',
						textSize : 12
				};
				array.push(chart);
			}
			var myChart = new nieeChart();

			myChart.setChart({
				array : array,
				id : 'canvas',
				width : 600,
				height: 500,
				isLine : true,
				title : 'niee@urielsoft.co.kr',
				titleSize : 10,
				lineCount : 5,
				isTooltip : false,
				toolStyle : "border:1px solid #000;width:100px;height:50px;background:#FF6600"
			});			
		});

		chartModal.show();
	});
	
	$('#changePasswd').click(function(){
		passwdModal.show();
	});
	
	$('#etc-game').click(function(){
		//$('#gameBody').append('<iframe src="'+getContextPath()+'/resources/html/snake.jsp" height="400"></iframe>');
		gameModal.show();
	});

	$('#lib-fileadd').click(function(){
        payModal.show();
	});

    $('#pay-monthtime').click(function(){
        fileModal.show();
    });
    
    /*$('#pay-monthtimView').click(function () {
        alert("시급 수정");
        payupdateModal.show();
    });*/

    $('#pay-monthtimView').click(function(){
		var url = getContextPath()+'/home/payMonthSelect.do';
        var email = $('#email').val();
		$.ajax({
			url : url,
			type : 'post',
			data : {emal:email},
			success : function(response){
				//$('#contents').val('');
				/*$('#pay_day').val('');
				$('#pay_ot').val('');
				$('#pay_ottime').val('');
				$('#pay_latetime').val('');
				$('#pay_nighttime').val('');*/
				//$('#schcalendar').fullCalendar('refetchEvents');
				//$('#schedulefileName').html('');
			}
		});
    });
	
	$('#sessionBtn').click(function(){
		if(sessionCheker == null){
			sessionCheker = setInterval(function(){
				$.ajax({url : getContextPath()+'/user/session.do',success:function(response){console.log(response.locale);}});
			},(1000*60*5));
			sessionCheker;
			$("#sessionBtn").removeClass('btn-gray');
			$("#sessionBtn").addClass('btn-black');
			$(".icon-gear").addClass('icon-white');
			$('#sessionText').text("세션유지(켜짐)");
		}else{
			clearInterval(sessionCheker);
			sessionCheker = null;
			$("#sessionBtn").removeClass('btn-black');
			$("#sessionBtn").addClass('btn-gray');
			$(".icon-gear").removeClass('icon-white');
			$('#sessionText').text("세션유지(꺼짐)");
		}
	});
	
	$('#starttime').val(spicker.getFormat());
	$('#endtime').val(epicker.getFormat());
	
	$('#btnLogout').click(function(){
		location.href=getContextPath()+"/user/logout.do";
	});
	
	$('#userMailSearch').click(function(){
		var sType = userRadio.getValue();
		var sText = $('#mText').val();
		refrashRow(userArticle, {param:{page : 1, email : $('#selectUser').val(),sType:sType,sText:sText}, url: getContextPath()+'/home/userArticle.do'});
	});
	
	$('#etc-refresh').click(function(){
		getEtc();
	});
	
	$('#lib-refresh').click(function(){
		getFiles();
	});

	// 근무 등록
	$('#writeBtn').click(function(){
        //oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
		//var title = $('#title').val();
		var contents = $('#contents').val();
		var starttime = $('#starttime').val();
		var endtime = $('#endtime').val();
        var pay_day = $('#pay_day').val();
        var pay_ot = $('#pay_ot').val();
        var pay_ottime = $('#pay_ottime').val();
        var pay_latetime = $('#pay_latetime').val();
        var title;
        var title1;
        var title2;

        if (pay_day == "1") title1 = "주간";
        else if (pay_day == "2") title1 = "야간";
        else if (pay_day == "3") title1 = "특근";
        else if (pay_day == "4") title1 = "야특";
        else if (pay_day == "5") title1 = "년차";
        else if (pay_day == "6") title1 = "결근";

        if (pay_ot == "1") title2 = "OT";
        else title2 = "";

        if (pay_day == "5") title = title1;
        else title = title1 + " " + title2;

		if(trim(title) == ''){
			alert('제목을 입력하세요');
			$('#title').val('');
			$('#title').focus();
		}
		/*else if(trim(contents) == '<p>&nbsp;</p>' || trim(contents) == ''){
			alert('내용을 입력하세요');
			$('#contents').val('');
			$('#contents').focus();
		}*/
		else{
			var realnames = '';
			var subnames = '';
			$('#schedulefileName').find('span').each(function(){
				var isRealName = ($(this).attr('realname')!='' && $(this).attr('realname')!=null && $(this).attr('realname')!='undefined');
				if( isRealName ){
					realnames += $(this).attr('realname');
					realnames +=',';
				}
				if(isRealName && $(this).attr('subname')!='' && $(this).attr('subname')!=null && $(this).attr('subname')!='undefined'){
					subnames += $(this).attr('subname');
					subnames +=',';
				}
			});

			scheduleParam.title=title;
			scheduleParam.contents=contents;
            scheduleParam.pay_day=pay_day;
            scheduleParam.pay_ot=pay_ot;
            scheduleParam.pay_ottime=pay_ottime;
            scheduleParam.pay_latetime=pay_latetime;

			scheduleParam.starttime = starttime;
			scheduleParam.endtime = endtime;
			var url = getContextPath()+'/home/scheduleWrite.do';

            if (pay_day == "2" || pay_day == "4") {
                if (pay_ot == "1") {
                    scheduleParam.pay_nighttime = '8';
                } else {
                    scheduleParam.pay_nighttime = '7';
                }
                //alert(form.salaryHolidayTime.value);
            }  else {
                scheduleParam.pay_nighttime = "0";
            }

            if (pay_latetime == null || pay_latetime == "0") {
                scheduleParam.pay_latetime = "0";
            }

			if(scheduleParam.seq > 0){
				url = getContextPath()+'/home/scheduleUpdate.do';
			}
			scheduleParam.etcYn = ($('#etcYn').is(':checked')?'N':'Y');
			scheduleParam.realnames = realnames;
			scheduleParam.subnames = subnames;
			$.ajax({
				url : url,
				data : scheduleParam,
				type : 'post',
				success : function(response){
					writeModal.hide();
					$('iframe[id!=scheduleFrame]').remove();
					$('#title').val('');
					//$('#contents').val('');
                    /*$('#pay_day').val('');
                    $('#pay_ot').val('');
                    $('#pay_ottime').val('');
                    $('#pay_latetime').val('');
                    $('#pay_nighttime').val('');*/
					$('#schcalendar').fullCalendar('refetchEvents');
					$('#schedulefileName').html('');
					var date = new Date();
		    		spicker.select(date.getFullYear(),date.getMonth()+1,date.getDate());
		    		epicker.select(date.getFullYear(),date.getMonth()+1,date.getDate());
				}
			});
		}
	});

	/* 달력 출력 */
    $('#schcalendar').fullCalendar({
		header: {
			left: ' ',
			center: 'prev title next',
			right: 'today,month,basicWeek,basicDay'
		},
		titleFormat: {
			month: 'yyyy년 MMMM',
			week: "yyyy년 MMMM d[yyyy]{'일 ~ '[mmm] dd일'}",
			day: "yyyy년 MMM d dddd"
		},
		monthNames : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames : ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
		dayNamesShort : ['일','월','화','수','목','금','토'],
		allDayText : '금일일정',
		minTime : 9,
		maxTime : 19,
		axisFormat : "HH:mm",
		editable: false,
		events: function(start, end, callback) {
            var email = $('#email').val();
	        $.ajax({
	            url: getContextPath()+"/home/scheduleArticle.do",
	            dataType: 'json',
	            data: {
	            	email:email,
	            	syear:start.getFullYear(),
		        	smonth:start.getMonth()+1,
		        	eyear:end.getFullYear(),
		        	emonth:end.getMonth()+1
	            },
	            success: function(response) {
                    getPayDay();
                    getPayMonthView(end.getFullYear(), end.getMonth());
                    getPay(end.getFullYear(),end.getMonth());
                    var events = [];
	                for(var i = 0 ; i < response.length ; i ++){
	                	var color;
	                	var textColor;
	                	var borderColor;
	                	events.push({
	                        title: response[i].title,
	                        start: new Date(response[i].starttime),
	                        end : new Date(response[i].endtime),
	                        seq : response[i].seq,
	                        allDay: (new Date(response[i].starttime).getHours()<8 || new Date(response[i].end).getHours()>19),
	                        color : color,
	                        textColor : textColor,
	                        borderColor:borderColor
	                    });
	                }
	                callback(events);
	            },
	            error : function(response,txt){
	            	location.href = getContextPath()+"/common/error.do?error="+txt;
	            }
	        });
	    },
	    eventClick: function(calEvent, jsEvent, view) {
            var email = $('#email').val();
	    	if(calEvent.seq != null){

	    		$.getJSON(getContextPath()+"/home/scheduleFiles.do",{seq:calEvent.seq},function(response){
	    			var files;
	    			files = response;

			    	$.getJSON(getContextPath()+"/home/getSchedule.do",{seq:calEvent.seq,email:email},function(response){
			    		var article = response;
				    	var sdate = new Date(article.starttime);
						var stime = sdate.getFullYear() + "년 " + (sdate.getMonth()+1) + "월 " + sdate.getDate() + "일";
						var edate = new Date(article.endtime);
						var etime = edate.getFullYear() + "년 " + (edate.getMonth()+1) + "월 " + edate.getDate() + "일";
						var fileHtml = '<div class="notify" style="margin-top:5px;">';
						for(var i = 0 ; i < files.length ; i ++){
							fileHtml += '&nbsp;&nbsp;<a href="javascript:scheduleFileDown('+files[i].seq+')">' + files[i].realname +'</a>&nbsp;&nbsp;';
						}
						fileHtml += '</div>';
						$("#modal-contents").html('<div class="label label-red" style="min-width:300px;">' + stime + ' ~ ' + etime + '</div>' +
                            '<br>'
                             + '<div style="margin-top:5px; height: 50px">' +
                            article.contents +'' +
                            '</div>'
                            + fileHtml
                        );
						if(article.isWriter == 'true'){
							scheduleParam = {email:email,seq : article.seq,title : article.title, contents : article.contents, starttime : article.starttime, endtime : article.endtime, etcYn : article.etcYn, files:files};
							var updateBtn = $('<a/>', {
											    href: '#',
											    name: 'updateBtn',
											    id: 'updateBtn',
											    html: '수정',
											    addClass : 'btn btn-gray btn-small',
											    onclick: 'javascript:contentsUpdate();'
											});
							var deleteBtn = $('<a/>', {
											    href: '#',
											    name: 'deleteBtn',
											    id: 'deleteBtn',
											    html: '삭제',
											    addClass : 'btn btn-gray btn-small',
											    onclick: 'javascript:contentsDelete('+article.seq+');'
											});
							var closeBtn = $('<a/>', {
											    href: '#',
											    name: 'closeBtn',
											    id: 'closeBtn',
											    html: 'Close',
											    addClass : 'btn btn-gray btn-small',
											    onclick: 'javascript:modal.hide();'
											});

							$('#contentsBtn').html( updateBtn[0].outerHTML +  deleteBtn[0].outerHTML +  closeBtn[0].outerHTML);
						}else{
							var closeBtn = $('<a/>', {
							    href: '#',
							    name: 'closeBtn',
							    id: 'closeBtn',
							    html: 'Close',
							    addClass : 'btn btn-gray btn-small',
							    onclick: 'javascript:modal.hide();'
							});

							$('#contentsBtn').html( closeBtn[0].outerHTML);
						}
						$("#modal-title").html(article.title + '<span style="float:right;">'+article.writer+'</span>');
						modal.show();
			    	}).fail(function(jqxhr, textStatus, error){
						 var err = textStatus + ", " + error;
						 console.log( "Request Failed: " + err );
						 location.href=getContextPath()+'/common/error.do?code='+textStatus;
					});
	    		});
	    	}
	    },
	    dayClick: function(date) {
            var email = $('#email').val();
			scheduleParam = {email:email,seq : 0, title : '', contents : '', starttime : date.getTime(), endtime : date.getTime(), writer:''};
			$('#title').val(scheduleParam.title);
			$('#contents').val(scheduleParam.contents);
			spicker.select(date.getFullYear(),date.getMonth()+1,date.getDate());
			epicker.select(date.getFullYear(),date.getMonth()+1,date.getDate());
			$('#etcYn').attr('checked',false);
			writeModal.show();
			//editorInit('contents');
	    }
	});

	$('#mailBtn').click(function(){
		oEditors.getById["mail-contents"].exec("UPDATE_CONTENTS_FIELD", []);
		var title = $('#mail-title').val();
		var contents = $('#mail-contents').val();
		var isSend = $('#mail-yn').is(':checked');
		if(trim(title) == ''){
			alert('제목을 입력하세요');
			$('#mail-title').val('');
			$('#mail-title').focus();
		}
		else if(trim(contents) == '<p>&nbsp;</p>' || trim(contents) == ''){
			alert('내용을 입력하세요');
			$('#mail-contents').val('');
			$('#mail-contents').focus();
		}else{
			var realnames = '';
			var subnames = '';
			var ccs = '';
			$('#fileName').find('span').each(function(){
				if($(this).attr('realname')!='' && $(this).attr('realname')!=null && $(this).attr('realname')!='undefined' ){
					realnames += $(this).attr('realname');
					realnames +=',';
				}
				if($(this).attr('subname')!='' && $(this).attr('subname')!=null && $(this).attr('subname')!='undefined'){
					subnames += $(this).attr('subname');
					subnames +=',';
				}
			});
			$('span[id=cc]').each(function(){
				ccs += $(this).attr('email');
				ccs +=',';
			});
			$.ajax({
				url : getContextPath()+'/home/sendUserMail.do',
				data : {title:title,contents:contents,isSend:isSend,email:$('#selectUser').val(),realnames:realnames,subnames:subnames,ccs:ccs},
				type : 'post',
				success : function(response){
					alert(JSON.parse(response).msg);
					refrashRow(userArticle, {param:{page : 1, email : $('#selectUser').val()}, url: getContextPath()+'/home/userArticle.do'});
					mailModal.hide();
					$('iframe[id!=scheduleFrame]').remove();
					$('#mail-title').val('');
					$('#mail-contents').val('');
					$('#mail-yn').attr('checked',false);
				}
			});
		}
	});

	$('#work-refresh').click(function(){
		refrashRow(userArticle, {param:{page : 1, email : $('#selectUser').val()}, url: getContextPath()+'/home/userArticle.do'});
	});

	$('#sview-refresh').click(function(){
		$('#schcalendar').fullCalendar('refetchEvents');
	});
	
	$('#writeClose').click(function(){
		$('#schedulefileName').html('');
		writeModal.hide();
		$('iframe[id!=scheduleFrame]').remove();
	});

	// 시급 등록 닫기
    $('#payClose').click(function(){
        fileModal.hide();
        $('iframe[id!=scheduleFrame]').remove();
    });

    // 시급 수정 닫기
    $('#payClose_Update').click(function(){
        gameModal.hide();
        $('iframe[id!=scheduleFrame]').remove();
    });

    // 시급 등록
    $('#payBtn').click(function(){
        var timeSalary = removeComma($('#time_salary').val());
        var job_time = removeComma($('#job_time').val());
        var full_working_pension = removeComma($('#full_working_pension').val());
        var family_pension = removeComma($('#family_pension').val());
        var texes = removeComma($('#texes').val());
        var position_pension = removeComma($('#position_pension').val());
        var yearly = removeComma($('#yearly').val());
        var etc = removeComma($('#etc').val());
        var longevity_pension = removeComma($('#longevity_pension').val());
        var payDate = removeComma($('#pay_date').val());
        var email = $('#email').val();

        if(timeSalary == ''){
            alert('시급을 입력하세요.');
            $('#time_salary').val('');
            $('#time_salary').focus();
        } else if(payDate == ''){
            alert('시급 등록 월을 입력하세요.');
            $('#pay_date').val('');
            $('#pay_date').focus();
        } else if (full_working_pension =='') {
            alert('만근수당을 입력하세요.');
            $('#full_working_pension').val('');
            $('#full_working_pension').focus();
        } else if (family_pension =='') {
            alert('가족수당을 입력하세요.');
            $('#family_pension').val('');
            $('#family_pension').focus();
        } else if (texes =='') {
            alert('세금예상액을 입력하세요.');
            $('#texes').val('');
            $('#texes').focus();
        } else if (position_pension =='') {
            alert('직책수당을 입력하세요.');
            $('#position_pension').val('');
            $('#position_pension').focus();
        } else {

            var url = getContextPath() + '/home/payMonthWrite.do';

            /*if(payParam.seq > 0){
                url = getContextPath()+'/home/payMonthUpdate.do';
            }*/

            $.ajax({
                //url: url,
                url : getContextPath()+"/home/payMonthWrite.do",
                //data : payParam,
                data: {
                    time_salary: timeSalary,
                    job_time: job_time,
                    full_working_pension: full_working_pension,
                    family_pension: family_pension,
                    texes: texes,
                    position_pension: position_pension,
                    longevity_pension: longevity_pension,
                    yearly: yearly,
                    etc: etc,
                    pay_date: payDate,
					email: email
                },
                type: 'post',
                success: function (response) {
                    response = JSON.parse(response);
                    if(response.error == 'error' || response.error == null || response.error == 'undefined') {
                        alert("해당일은 이미 등록이 되어있습니다!!!!!.");
                        fileModal.show();
                        $('#pay_date').focus();
					} else {
                        //alert(JSON.parse(response).msg);
                        fileModal.hide();
                    }
                },
                error : function(response,txt){
                    location.href = getContextPath()+"/common/error.do?error="+txt;
                }
            });
        }
    });

    // 시급 수정 등록
    $('#payBtn_Update').click(function(){
    	var email = $('#email').val();
        var time_salary_Update = removeComma($('#time_salary_Update').val());
        /*var job_time = $('#job_time_Update').val();
        var full_working_pension = $('#full_working_pension_Update').val();
        var family_pension = $('#family_pension_Update').val();
        var texes = $('#texes').val();
        var position_pension = $('#position_pension').val();*/
        var pay_date_Update = removeComma($('#pay_date_Update').val());

        /*payParam.time_salary=time_salary;
        payParam.job_time=job_time;
        payParam.full_working_pension=full_working_pension;
        payParam.family_pension=family_pension;
        payParam.texes=texes;
        payParam.position_pension=position_pension;*/

        if(time_salary_Update == ''){
            alert('시급을 입력하세요.');
            $('#time_salary_Update').val('');
            $('#time_salary_Update').focus();
        } else if(pay_date_Update == ''){
            alert('시급 등록 월을 입력하세요.');
            $('#pay_date_Update').val('');
            $('#pay_date_Update').focus();
        } else {

            var url = getContextPath() + '/home/payMonthUpdate.do';

            /*if(payParam.seq > 0){
                url = getContextPath()+'/home/payMonthUpdate.do';
            }*/

            $.ajax({
                url: url,
                //url : getContextPath()+"/home/payMonthWrite.do",
                //data : payParam,
                data: {
                    time_salary: time_salary_Update,
                    job_time: removeComma($('#job_time_Update').val()),
                    full_working_pension: removeComma($('#full_working_pension_Update').val()),
                    family_pension: removeComma($('#family_pension_Update').val()),
                    texes: removeComma($('#texes_Update').val()),
                    position_pension: removeComma($('#position_pension_Update').val()),
                    longevity_pension: removeComma($('#longevity_pension_Update').val()),
                    yearly: removeComma($('#yearly_Update').val()),
                    etc: removeComma($('#etc_Update').val()),
                    pay_date: pay_date_Update,
					email:email
                },
                type: 'post',
                success: function (response) {
                    response = JSON.parse(response);
                    if(response.error == 'error' || response.error == null || response.error == 'undefined') {
                        alert("해당일은 이미 등록이 되어있습니다!!!!!.");
                        gameModal.show();
                        $('#pay_date_Update').focus();
                    } else {
                        //alert(JSON.parse(response).msg);
                        gameModal.hide();
                    }
                },
                error : function(response,txt){
                    location.href = getContextPath()+"/common/error.do?error="+txt;
                }
            });
        }
    });

	$('#mailClose').click(function(){
		mailModal.hide();
		$('iframe[id!=scheduleFrame]').remove();
	});
	
	$('#contentsUpdate').click(function(){
		alert();
	});
	
	$('#tab_Home,#tab_Schedule,#tab_Etc,#tab_Lib,#tab_View,#tab_Pay').click(function(){
		var id = $(this).attr('id');
		$('#selectTab').val(id);
		$('.tab').find('li').each(function(){
			var $child = $(this).find('a'); 
			if($child.attr('id') == id){
				$(this).addClass('active');
				$('#'+ $child.attr('title')).show();
				if(id == 'tab_View'){
					//getPay();
					$('#schcalendar').fullCalendar('refetchEvents');
				}
			}else{
				$(this).removeClass('active');
				$('#'+ $child.attr('title')).hide();
			}
		});
	});
	getEtc();
	getFiles();
	//getPay();
	setInterval(function(){
		var date = new Date();
		$('#head-year').text(date.getFullYear());
		$('#head-month').text(date.getMonth()+1);
		$('#head-day').text(date.getDate());
		$('#head-hour').text(date.getHours());
		$('#head-min').text(date.getMinutes());
	},1000);

	$("#etc-print").click(function() {
	    window.print();
	});
	
	$('#mailFileAddBtn').click(function(){
		 $.ajaxFileUpload 
		    ( 
		        { 
		            url:getContextPath()+'/home/mailFileUpload.do', 
		            secureuri:false, 
		            type:'post',
		            fileElementId:'mailfile', 
		            dataType: 'json', 
		            success: function (data, status) 
		            {
		            	if(data.error == '' || data.error == null || data.error == 'undefined'){
		            		alert('등록이 완료되었습니다.');
		            		
		            		var span = document.createElement('span');
		            		$(span).text(data.realname);
		            		$(span).attr('realname',data.realname);
		            		$(span).attr('subname',data.subname);
		            		
		            		var html = $('#fileName').html();
		            		
		            		$('#fileName').html(html + '<span>&nbsp;' +  span.outerHTML + '<i class="icon-trashcan icon-small" style="cursor:pointer;" onclick="mailFileDelete(\''+trim(data.subname)+'\')"></i></span>');
		            	}else{
		            		alert(data.error);
		            	}
		            }, 
		            error: function (data, status, e) 
		            { 
		                alert(e); 
		            } 
		        } 
		    ); 
		     
		    return false;
	});

	$('#scheduleFileAddBtn').click(function(){
		$.ajaxFileUpload 
		( 
				{ 
					url:getContextPath()+'/home/mailFileUpload.do', 
					secureuri:false, 
					type:'post',
					fileElementId:'schedulefile', 
					dataType: 'json', 
					success: function (data, status) 
					{
						if(data.error == '' || data.error == null || data.error == 'undefined'){
							alert('등록이 완료되었습니다.');
							
							var span = document.createElement('span');
							$(span).text(data.realname);
							$(span).attr('realname',data.realname);
							$(span).attr('subname',data.subname);
							
							var html = $('#schedulefileName').html();
							
							$('#schedulefileName').html(html + '<span>&nbsp;' +  span.outerHTML + '<i class="icon-trashcan icon-small" style="cursor:pointer;" onclick="scheduleFileDelete(\''+trim(data.subname)+'\')"></i></span>');
						}else{
							alert(data.error);
						}
					}, 
					error: function (data, status, e) 
					{ 
						alert(e); 
					} 
				} 
		); 
		
		return false;
	});
	
}).on('click','#file-download',function(){
	if(confirm($(this).attr('name') + " 을 다운 받으시겠습니까?")){
		var url = getContextPath()+'/home/filedownload.do';
		var inputs = '<input type="hidden" name="seq" value="'+$(this).attr('seq')+'"/>';
		$('<form action="'+ url +'" method="post">'+inputs+'</form>').appendTo('body').submit().remove();
	}
}).on('click','#file-delete',function(){
	if(confirm($(this).attr('name') + " 을 삭제하시겠습니까?")){
		var seq = $(this).attr('seq');
		$.ajax({
			url : getContextPath()+'/home/filedelete.do',
			type : 'post',
			data:{seq : seq},
			success:function(response){
				var result = JSON.parse(response);
				alert(result.msg);
				$('#lib-refresh').click();
			}
		});
	}
}).on('click','#write-mail',function(){
	$('#mail-contents').val('');
	$('#mail-title').val('');
	$('#mail-yn').attr('checked',false);
	$('#fileName').html('');
	$('#mailfile').val('');
	$('#cclist').html('');
	if($('.root.open').length != 0){
		$('.root>i').click();
	}
	mailModal.show();
	editorInit('mail-contents');
});
