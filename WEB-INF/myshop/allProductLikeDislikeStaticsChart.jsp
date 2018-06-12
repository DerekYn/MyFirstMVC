<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<jsp:include page="../header.jsp"></jsp:include>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>

<div id="hereChart1" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">

//////////////////////////////////////////////////////////////////////////////////////////////

//// *** 자바 스크립트의 2차원 배열화 ***////

/*
    var mainArr = new Array();
 	var mainArr = [];	                원래 자바 스크립트에서 배열만드는 형태
 	
 	for(var i=0; i<10; i++) {
 		var subArr = new Array();
 		subArr.push('내용1');
 		subArr.push('내용2');
 		subArr.push('내용3');
 		subArr.push('내용4');
 		
 		mainArr.push(subArr);
 	} --> 10개의 서브 배열을 큰 배열에 넣는 2차원 배열화 방법
 */

var jsonArray = ${str_jsonArray};

var resultCategory = new Array();
var likeArr = new Array();
var dislikeArr = new Array();

for(var i=0; i<jsonArray.length; i++) {
	
	resultCategory.push(jsonArray[i].PNAME);
	
	likeArr.push(Number(jsonArray[i].LIKECNT));
	dislikeArr.push(Number(jsonArray[i].DISLIKECNT));
}

Highcharts.chart('hereChart1', {
    chart: {
        type: 'column'
    },
    title: {
        text: '제품별 좋아요 & 싫어요!!'
    },
    xAxis: {
        categories: resultCategory
    },
    credits: {
        enabled: false
    },
    series: [{
        name: 'LIKE',
        data: likeArr
    }, {
        name: 'DISLIKE',
        data: dislikeArr
    }]
});

</script>


<jsp:include page="../footer.jsp"></jsp:include>