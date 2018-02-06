var sessionCheker = null;
var scheduleParam = {};
var payParam = {};
var imagepath = getContextPath()+"/resources/images";
var oEditors = [];
var vo = {
			url:getContextPath()+'/home/employee.do',
			id:'Employee',
			seq : "seq", 
			name : "이름", 
			phone : "전화번호", 
			email : "메일주소"
	};

/**
 * 메일 첨부파일 다운로드
 */
function userFileDown(seq){
	var url = getContextPath()+'/home/userfiledownload.do';
	var inputs = '<input type="hidden" name="seq" value="'+seq+'"/>';
	$('<form action="'+ url +'" method="post">'+inputs+'</form>').appendTo('body').submit().remove();
}

/**
 * 스케줄 첨부파일 다운로드
 */
function scheduleFileDown(seq){
	var url = getContextPath()+'/home/scheduledownload.do';
	var inputs = '<input type="hidden" name="seq" value="'+seq+'"/>';
	$('<form action="'+ url +'" method="post">'+inputs+'</form>').appendTo('body').submit().remove();
}

/**
 *메일 첨부파일 삭제 
*/
function mailFileDelete(subname){
	if(confirm('해당파일을 삭제하시겠습니까?')){
		$.ajax({
			url : getContextPath()+'/home/userFileDelete.do',
			data : {name : subname},
			type : 'post',
			success:function(response){
				response = JSON.parse(response);
				if(response.isDel){
					alert('삭제되었습니다.');
					$('span[subname='+subname+']').parent().remove();					
				}else{
					alert('삭제실패.');
				}
			}
		});
	}
}

/**
 *스케줄 첨부파일 삭제 
 */
function scheduleFileDelete(subname){
	if(confirm('해당파일을 삭제하시겠습니까?')){
		$.ajax({
			url : getContextPath()+'/home/scheduleFileDelete.do',
			data : {name : subname},
			type : 'post',
			success:function(response){
				response = JSON.parse(response);
				if(response.isDel){
					alert('삭제되었습니다.');
					$('span[subname='+subname+']').parent().remove();					
				}else{
					alert('삭제실패.');
				}
			}
		});
	}
}

/**
 * 스마트에디터설정
 */
function editorInit(id){
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: id,
		sSkinURI: getContextPath()+"/resources/SE/SmartEditor2Skin.html",	
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			fOnBeforeUnload : function(){
				//alert("완료!");
			}
		}, //boolean
		fOnAppLoad : function(){
			//예제 코드
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		},
		fCreator: "createSEditor2"
	});
}

/**
 * 트림함수
 */
function trim(str){
	return str.replace(new RegExp(' ','g'),'');
}
/**
 * Etc호출함수
 */
function getEtc(){
	var syear = $('#syear').val();
	var smonth = $('#smonth').val();
	var eyear = $('#eyear').val();
	var emonth = $('#emonth').val();
	$.getJSON(getContextPath()+'/home/getEtc.do',{syear:syear,smonth:smonth,eyear:eyear,emonth:emonth}).done(function(response){
		var result = response;
		var html = '';
		for(var i = 0 ; i < result.length ; i ++){
			//var  contents = result[i].contents;
			var sdate = new Date(result[i].starttime);
			var edate = new Date(result[i].endtime);
			html +='<div class="etc-contents">';
			html +='<div class="label label-blue" style="margin:5px;">';
			html +=(i+1) +". " +result[i].title;
			html +='</div>';
			html +='<br>';
			html +='<div class="label label-red" style="margin:5px;">';
			html +=sdate.getFullYear() + "년 " + (sdate.getMonth()+1) + "월 " + sdate.getDate() + "일";
			if(sdate.getTime() != edate.getTime()){
				html +=' ~ ';
				html +=edate.getFullYear() + "년 " + (edate.getMonth()+1) + "월 " + edate.getDate() + "일";				
			}
			html +='</div>';
			html +='<br>';
			//html +=contents;
			html +='</div>';
		}
		$('#etc-contents').html(html);
	}).fail(function(jqxhr, textStatus, error){
		 var err = textStatus + ", " + error;
		 console.log( "Request Failed: " + err );
		 location.href=getContextPath()+'/common/error.do?code='+textStatus;
	});	
}
/**
 * 파일 호출 함수
 */
function getFiles(){
	$.getJSON(getContextPath()+'/home/getFiles.do',{}).done(function(response){
		var result = response;
		var article = new Array();
		for(var i = 0 ; i < result.length ; i ++){
			var date = new Date(result[i].regtime.replace(/\-/g,"/"));
			var obj = { seq : result[i].seq, realname : result[i].realname, regtime : date.getFullYear() + "년 " + (date.getMonth()+1) + "월 " + date.getDate() + "일", name : result[i].name};
			article.push(obj);
		}
		fileArticle.update(article);
	}).fail(function(jqxhr, textStatus, error){
		 var err = textStatus + ", " + error;
		 console.log( "Request Failed: " + err );
		 location.href=getContextPath()+'/common/error.do?code='+textStatus;
	});	
}

/**
 * Home 호출함수
 */
function getJSON(vo,param){
	var parentVo = vo;
	var nextVo = vo.nextVo;
	$.getJSON(parentVo.url,param).done(function(response){
		var results = response;
		var bodyDiv = $('.'+parentVo.id + '-container');
		if(!bodyDiv[0]){
			bodyDiv = document.createElement("div");
			$(bodyDiv).addClass( parentVo.id + '-container' );
			$(bodyDiv).css('margin-top','5px');
			$('#main_Home').append(bodyDiv);
		}
		$(bodyDiv).hide();
		$(bodyDiv).html('');
		for(var i = 0 ; i < results.length ; i ++){
			var result = results[i];
			var div = document.createElement("div");
			$(bodyDiv).append(div);
			var spans = new Array();
			for(var key in parentVo){
				if(key == 'id'){
					var span = document.createElement("span");
					$(span).text( eval('parentVo.'+key));
					$(span).css('color','blue');
					$(span).css('font-weight','bold');
					spans.push(span);
				}
				if( key != 'seq' && key != 'url' && key != 'isChild' && key != 'id' && key != 'nextVo' ){
					var span = document.createElement("span");
					$(span).html( eval('parentVo.'+key) + ' : <font>' + eval('result.'+key) + '</font>' );
					spans.push(span);
				}
			}
			
			userTree.append({ email: result.eemail , title : result.name+"("+result.email+")", name:result.name});
			
			var br = document.createElement("br");
			$(div).html(spans[0].outerHTML + br.outerHTML + spans[1].outerHTML + br.outerHTML + spans[2].outerHTML + br.outerHTML + spans[3].outerHTML );
			$(div).addClass( parentVo.id + ' navbar' );
			$(div).css('cursor','pointer');
			$(div).css('width','97%');
			$(div).css('line-height','18px');
			$(div).attr('seq',result.seq);
			$(div).attr('clicked',"false");
			$(div).attr('name',result.name);
			$(div).attr('phone',result.phone);
			$(div).attr('email',result.email);
			$(div).css('opacity','0.5').mouseover(function(){
				$(this).css('opacity','1');
			}).mouseout(function(){
				$(this).css('opacity','0.5');
			}).click(function(){
				var $obj = $(this);
				if($obj.attr('clicked') == "false"){
					$obj.addClass('clicked');
					$obj.addClass('clicked notify-red');
					$obj.attr('clicked','true');
					$('.'+parentVo.id).each(function(){
						if(!$(this).is($obj)){
							$(this).hide();
						}
					});
					$obj.animate({width:'385px'},800,function(){
						if(nextVo){
							getJSON(nextVo,{url: getContextPath()+'/home/userArticle.do', seq:$obj.attr('seq')});							
						}else{
							refrashRow(userArticle, {param:{page : 1, email : $obj.attr('email')}, url: getContextPath()+'/home/userArticle.do'});
							$('#work-name').text($obj.attr('name'));
							$('#work-email').attr('href','#');
							$('#work-email').attr('id','write-mail');
							$('#selectUser').val($obj.attr('email'));
							$('#mailTo').text($('#selectUser').val());
							$('.user-work').slideDown('slow');
						}
					});
				}else{
					$obj.attr('clicked','false');
					while(nextVo){
						$('.'+nextVo.id + '-container').html('');
						nextVo = nextVo.nextVo;
					}
					nextVo = parentVo.nextVo;
					$('.user-work').slideUp('slow',function(){
						$obj.animate({width:'97%'},800,function(){
							$('.'+parentVo.id).each(function(){
								$(this).removeClass('clicked');
								$(this).removeClass('notify-red');
								$(this).show();
							});
						});
					});
				}
			});
		}
		$(bodyDiv).slideDown('slow');
	}).fail(function(jqxhr, textStatus, error){
		 var err = textStatus + ", " + error;
		 console.log( "Request Failed: " + err );
		 location.href=getContextPath()+'/common/error.do?code='+textStatus;
	});
}

/**
 * 스케줄 수정함수
 */
function contentsUpdate(){
	modal.hide();
	var contents = scheduleParam.contents;
	$('#title').val(scheduleParam.title);
	$('#contents').val(contents);
	var sdate = new Date(scheduleParam.starttime);
	var edate = new Date(scheduleParam.endtime);
	spicker.select(sdate.getFullYear(),sdate.getMonth()+1,sdate.getDate());
	epicker.select(edate.getFullYear(),edate.getMonth()+1,edate.getDate());
	if(scheduleParam.etcYn == 'N'){
		$('#etcYn').attr('checked',true);
	}else{
		$('#etcYn').attr('checked',false);
	}
	$('#schedulefileName').html('');
	var files = scheduleParam.files;
	for(var i = 0 ; i < files.length ; i ++){
		var html = $('#schedulefileName').html();
		var span = document.createElement('span');
		$(span).text(files[i].realname);
		$(span).attr('subname',files[i].subname);
		$('#schedulefileName').html(html + '<span>&nbsp;' +  span.outerHTML + '<i class="icon-trashcan icon-small" style="cursor:pointer;" onclick="scheduleFileDelete(\''+trim(files[i].subname)+'\')"></i></span>');
	}
	writeModal.show();
	//editorInit('contents');
}

/**
 * 스케줄 삭제함수
 */
function contentsDelete(seq){
	if(confirm('삭제 하시겠습니까?')){
		$.post(getContextPath()+'/home/scheduleDelete.do', {seq:seq}, function(data, textStatus) {
			var result = data;
			if(result.resultCnt > 0){
				alert('삭제 완료');
				$('#schcalendar').fullCalendar('refetchEvents');
				modal.hide();
			}else{
				alert('삭제 실패');
			}
		},"json").fail(function(jqxhr, textStatus, error){
			 var err = textStatus + ", " + error;
			 console.log( "Request Failed: " + err );
			 location.href=getContextPath()+'/common/error.do?code='+textStatus;
		});
	}
}

/**
 * 스케줄 페이지 변경
 */
function changePage(pNo){
	if($('#selectTab').val() == 'tab_Home'){
		refrashRow(userArticle, {param:{page : pNo, email : $('#selectUser').val()}, url: getContextPath()+'/home/userArticle.do'});
	}else if($('#selectTab').val() == 'tab_Schedule'){
		refrashRow(scheduleArticle, {url: getContextPath()+'/home/scheduleArticle.do', param:{page : pNo, today : datepicker.getFormat()}});
	}
}

/**
 * 비밀번호 변경
 */
function changePasswd(){
	var oldpass = $('#oldpass').val();
	var newpass = $('#newpass').val();
	
	if(trim(oldpass) == ''){
		alert('현재 비밀번호를 입력하세요');
		$('#oldpass').val('');
		$('#oldpass').focus();
	}
	else if(trim(newpass) == ''){
		alert('변경 할 비밀번호를 입력하세요');
		$('#newpass').val('');
		$('#newpass').focus();
	}
	else{
		$.ajax({
			url : getContextPath()+"/user/changePasswd.do",
			data : {oldpass:oldpass,newpass:newpass},
			type : 'post',
			success:function(response){
				var result = JSON.parse(response);
				if(result.success){
					alert(result.msg);
					passwdModal.hide();
				}else{
					alert(result.msg);
					$('#oldpass').val('');
					$('#newpass').val('');
					$('#oldpass').focus();
				}
			}
		});
	}
}

/**
 * 자료실 파일업로드
 */
function fileUpload() { 
    $.ajaxFileUpload 
    ( 
        { 
            url:getContextPath()+'/home/fileUpload.do', 
            secureuri:false, 
            type:'post',
            fileElementId:'file', 
            dataType: 'json', 
            success: function (data, status) 
            { 
                if(typeof(data.error) != 'undefined') 
                { 
                    if(data.error != '') 
                    { 
                        alert(data.error); 
                    }else 
                    { 
                        alert(data.msg); 
                    } 
                } 
            }, 
            error: function (data, status, e) 
            { 
                alert(e); 
            } 
        } 
    ); 
     
    return false;
}

/**
 * 페이징 다시계산 & 테이블 세팅
 */
function refrashRow(table, param){
	$.getJSON(param.url,param.param,function(response){
		var articles = response.articles;
		var article = [];

		//schedulePaging.reload(response.count);
		var pageRow = 15;
		var pageCol = 15;
		var totalCnt = response.count;
		var page = response.page == null ? 1 : response.page;
		pageRow = totalCnt<pageRow?totalCnt:pageRow;
		var totalCol = parseInt(totalCnt%pageRow)>0?(totalCnt/pageRow)+1:totalCnt/pageRow;
		 
		var startIdx = (page-1)*pageRow;
		
		var startCol = parseInt(((startIdx / pageCol)/pageRow))*pageCol;
		var endCol = startCol+pageCol < totalCol ? startCol+pageCol : totalCol;
		
		var html = '';
		
		if((startCol+1) > pageCol){
			html += '<a href="#" class="prev" onclick="changePage('+(parseInt(startCol) - 1 - parseInt(pageCol))+')">Previous</a>';				
		}else{
			html += '<a href="#" class="prev">Previous</a>';
		}
		html += '<div class="list">';
		for(var i = (parseInt(startCol)) ; i < parseInt(endCol) ; i ++){
			if((i+1) == page){
				html += '<a href="#" class="page active">'+(i+1)+'</a>';
			}else{
				html += '<a href="#" class="page" onclick="changePage('+(i+1)+')">'+(i+1)+'</a>';
			}
		}
		html += '</div>';
		if(totalCol > endCol){
			html += '<a href="#" class="next" onclick="changePage('+(parseInt(startCol) + 1 + parseInt(pageCol))+')">Next</a>';				
		}else{
			html += '<a href="#" class="next">Next</a>';
		}
		
		if(userArticle.selector == table.selector){
			$('#userArticlePaging').html(html);
		}else{
			$('#schedulePaging').html(html);
		}
		
		for(var i = 0; i < articles.length; i++) {
			var obj = articles[i];
			
			if(userArticle.selector == table.selector){
				var date = new Date(obj.regtime);
				var regtime = date.getFullYear() + "년 " + (date.getMonth()+1) + "월 " + date.getDate() + "일";
				article.push({ seq: obj.seq, title: obj.title, name: obj.name, regtime: regtime, viewYn:obj.viewYn, receivername:obj.receivername });
			}else if(scheduleArticle.selector == table.selector){
				var sdate = new Date(obj.starttime);
				var sregtime = sdate.getFullYear() + "년 " + (sdate.getMonth()+1) + "월 " + sdate.getDate() + "일";
				var edate = new Date(obj.endtime);
				var endtime = edate.getFullYear() + "년 " + (edate.getMonth()+1) + "월 " + edate.getDate() + "일";
				article.push({ seq: obj.seq, title: obj.title, writer: obj.writer, starttime: sregtime, endtime : endtime });
			}
		}
		
		table.update(article);
		
		var list = table.list(); 
		
		for(var i = 0 ; i < list.length ; i++){
			$(list[i].element).attr('seq',list[i].data.seq).mouseover(function(){
				$(this).find('td').css('color','red');
			}).mouseout(function(){
				$(this).find('td').css('color','#000000');
			}).click(function(){
				var url = "";
				if(userArticle.selector == table.selector){
					url = getContextPath()+"/home/" +
							"";
				}else if(scheduleArticle.selector == table.selector){
					url = getContextPath()+"/home/getSchedule.do";
				}
				$.getJSON(url,{seq:$(this).attr('seq')},function(response){
					var article = response;
					if(userArticle.selector == table.selector){
						var html = '';
						$.getJSON(getContextPath()+'/home/getUserFiles.do',{seq:response.seq},function(response){
							var files = response;
							for(var i = 0 ; i < files.length ; i ++){
								html += '&nbsp;<span style="cursor:pointer;" onclick="userFileDown('+files[i].seq+')">'+files[i].realname+'<i class="icon-download"></i></span>';
							}
							html += '<div class="notify contents-view" style="margin-top:5px;">' + article.contents + '</div>';
							$("#modal-contents").html(html);
						});
						var closeBtn = $('<a/>', {
						    href: '#',
						    name: 'closeBtn',
						    id: 'closeBtn',
						    html: 'Close',
						    addClass : 'btn btn-gray btn-small',
						    onclick: 'javascript:modal.hide();'
						});
						$('#contentsBtn').html( closeBtn[0].outerHTML);
						$("#modal-title").html(article.title + '<span style="float:right;">'+article.name+'</span>');
					}
					modal.show();
				}).fail(function(jqxhr, textStatus, error){
					 var err = textStatus + ", " + error;
					 console.log( "Request Failed: " + err );
					 location.href=getContextPath()+'/common/error.do?code='+textStatus;
				});
			});
		}
		
		if(articles.length == 0){
			if(userArticle.selector == table.selector){
				$('#userArticleBody').html("<tr><td colspan='6'>게시글이 없습니다.</td></tr>");
			}else{
				$('#schedulebody').html("<tr><td colspan='5'>해당일의 일정이 없습니다.</td></tr>");
			}			
		}
		
	}).fail(function(jqxhr, textStatus, error){
		 var err = textStatus + ", " + error;
		 console.log( "Request Failed: " + err );
		 location.href=getContextPath()+'/common/error.do?code='+textStatus;
	});	
	
}

/*
* 급여 계산
 */
function getPay(year,month){
    var syear = year;
    var smonth = month;
    /*var syear = $('#paySyear').val();
    var smonth = $('#paySmonth').val();
        $.getJSON(getContextPath()+'/home/payDay.do',{syear:syear,smonth:smonth},function(response){*/
		$.getJSON(getContextPath()+'/home/payDay.do',{syear:year,smonth:month},function(response){
        var result = response;
        var html = '';
        if (result.length == 0) {
            alert(smonth + "월 근무정보가 등록이 안되었습니다..");
            //fileModal.show();
        } else {
            html +='<div class="pay-contents">';
            html +='<div class="label label-blue" style="margin:5px;">';
            html += syear + '년 ' + smonth + '월';
            html +='</div>';
            html +='<br>';
            html +='<div class="label label-red" style="margin:5px;">';
            html += '실지급액 : ' + result[0].total;
            html +='</div>';
            html +='<br>';
            html +='<div class="label-pay" style="margin:5px;">';
            html += '&nbsp;기 본 급 : ' + result[0].calBasicTime;
            html +='<br>';
            if (result[0].calProTime != 0) {
                html += '연장수당 : ' + result[0].calProTime;
                html += '<br>';
            }
            if (result[0].calNightPersion != 0) {
                html += '야간수당 : ' + result[0].calNightPersion;
                html += '<br>';
            }
            if (result[0].calHolidayPersion != 0) {
                html += '특근수당 : ' + result[0].calHolidayPersion;
                html += '<br>';
            }
            if (result[0].family != 0 || result[0].fullWorking != 0 || result[0].longevity != 0 || result[0].positionPension != 0) {
                html += '<br>';
                html += '&nbsp&nbsp&nbsp&nbsp'+' == 각종 수당 == ';
                html += '<br>';
            }
            if (result[0].family != 0) {
                html += '가족수당 : ' +  commaSplit(result[0].family);
                html +='<br>';
            }
            if (result[0].longevity != 0) {
                html += '근속수당 : ' +  commaSplit(result[0].longevity);
                html +='<br>';
            }
            if (result[0].positionPension != 0) {
                html += '직책수당 : ' +  commaSplit(result[0].positionPension);
                html +='<br>';
            }
            if (result[0].fullWorking != 0) {
                html += '만근수당 : ' +  commaSplit(result[0].fullWorking);
                html +='<br>';
            }
            if (result[0].calYearly != 0) {
                html += '연차수당 : ' +  commaSplit(result[0].calYearly);
                html +='<br>';
            }
            if (result[0].calEtc != 0) {
                html += '기타수당 : ' + commaSplit(result[0].calEtc);
                html += '<br>';
            }
            html +='<br>';
            html += '공제총액 : ' + commaSplit(result[0].calTexes);
            html +='<br>';
            html += '총급여액 : ' + result[0].persionSum;
            html +='<br>';
            html +='</div>';
        }
        $('#pay-contents').html(html);
    }).fail(function(jqxhr, textStatus, error){
        var err = textStatus + ", " + error;
        console.log( "Request Failed: " + err );
        //location.href=getContextPath()+'/common/error.do?code='+textStatus;
    });
}

/*
 * 급여정보 수정 페이지
 */
function getPayMonthView(year, month){
    var syear = year;
    var smonth = month;
    $.getJSON(getContextPath()+'/home/payMonthSelect.do',{syear:syear,smonth:month},function(response){
        var result = response;
        var html = '';
        if (result.length == 0) {
            alert(smonth + "월 급여정보가 등록이 안되었거나 근무 기록이 없습니다.");
            fileModal.show();
        } else {
            $('#time_salary_Update').val(commaSplit(result.TIME_SALARY));
            $('#job_time_Update').val(commaSplit(result.JOB_TIME));
            $('#full_working_pension_Update').val(commaSplit(result.FULL_WORKING_PENSION));
            $('#family_pension_Update').val(commaSplit(result.FAMILY_PENSION));
            $('#longevity_pension_Update').val(commaSplit(result.LONGEVITY_PENSION));
            $('#yearly_Update').val(commaSplit(result.YEARLY));
            $('#etc_Update').val(commaSplit(result.ETC_UPDATE));
            $('#texes_Update').val(commaSplit(result.ETC));
            $('#position_pension_Update').val(commaSplit(result.POSITION_PENSION));
            $('#pay_date_Update').val(result.PAY_DATE);
        }
        //$('#pay-contents').html(html);
    }).fail(function(jqxhr, textStatus, error){
        var err = textStatus + ", " + error;
        console.log( "Request Failed: " + err );
        //location.href=getContextPath()+'/common/error.do?code='+textStatus;
        //location.href=getContextPath()+'/main.do';
    });
}


/*
 * Input창 자동 콤마
 */
function cmaComma(obj) {
    var firstNum = obj.value.substring(0,1); // 첫글자 확인 변수
    var strNum = /^[/,/,0,1,2,3,4,5,6,7,8,9,/]/; // 숫자와 , 만 가능
    var str = "" + obj.value.replace(/,/gi,''); // 콤마 제거
    var regx = new RegExp(/(-?\d+)(\d{3})/);
    var bExists = str.indexOf(".",0);
    var strArr = str.split('.');

    /*if (!strNum.test(obj.value)) {
        alert("숫자만 입력하십시오.\n\n특수문자와 한글/영문은 사용할수 없습니다.");
        obj.value = 1;
        obj.focus();
        return false;
    }*/

    /*if ((firstNum < "0" || "9" < firstNum)){
        alert("숫자만 입력하십시오.");
        obj.value = 1;
        obj.focus();
        return false;
    }*/

    while(regx.test(strArr[0])){
        strArr[0] = strArr[0].replace(regx,"$1,$2");
    }
    if (bExists > -1)  {
        obj.value = strArr[0] + "." + strArr[1];
    } else  {
        obj.value = strArr[0];
    }
}

function commaSplit(n) {// 콤마 나누는 부분
    var txtNumber = '' + n;
    var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
    var arrNumber = txtNumber.split('.');
    arrNumber[0] += '.';
    do {
        arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
    }
    while (rxSplit.test(arrNumber[0]));
    if(arrNumber.length > 1) {
        return arrNumber.join('');
    } else {
        return arrNumber[0].split('.')[0];
    }
}

function removeComma(n) {  // 콤마제거
    if ( typeof n == "undefined" || n == null || n == "" ) {
        return "";
    }
    var txtNumber = '' + n;
    return txtNumber.replace(/(,)/g, "");
}


/*
 * 메일 참조 리스트
 */
function addCC(obj){
	var isCC = false;
	var name = obj.name;
	var email = obj.email;
	$('#cclist').find('span').each(function(){
		if(name == $(this).attr("name")){
			$(this).remove();
			isCC = true;
		}
	});
	
	if(!isCC){
		var span = document.createElement('span');
		$(span).attr("name",name);
		$(span).attr("email",email);
		$(span).attr("id","cc");
		$(span).css("margin-right","3px");
		$(span).css("cursor","pointer");
		$(span).html(name+'<i class="icon-close"></i>');
		$('#cclist').append(span);
		$(span).click(function(){
			$(this).remove();
		});
	}
}