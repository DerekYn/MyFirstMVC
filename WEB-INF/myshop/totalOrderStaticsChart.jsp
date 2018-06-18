<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<jsp:include page="../header.jsp"></jsp:include>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/series-label.js"></script>

<div id="container"></div>

<div id="hereChart1" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
<br/>
<div id="hereChart2" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">

var jsonArray = ${str_jsonArray};

var resultArr = new Array(); // 메인 배열

for(var i=0; i<jsonArray.length; i++) {
	var subArr = new Array();
	subArr.push(Number(jsonArray[i].JAN));
	subArr.push(Number(jsonArray[i].FEB));
	subArr.push(Number(jsonArray[i].MAR));
	subArr.push(Number(jsonArray[i].APR));
	subArr.push(Number(jsonArray[i].MAY));
	subArr.push(Number(jsonArray[i].JUN));
	subArr.push(Number(jsonArray[i].JUL));
	subArr.push(Number(jsonArray[i].AUG));
	subArr.push(Number(jsonArray[i].SEP));
	subArr.push(Number(jsonArray[i].OCT));
	subArr.push(Number(jsonArray[i].NOV));
	subArr.push(Number(jsonArray[i].DEC));
	
	var obj = {name: jsonArray[i].CNAME,
			   data: subArr};
	
	resultArr.push(obj);
}

Highcharts.chart('hereChart1', {

    title: {
        text: '카테고리별 월별 판매현황(선형)'
    },

    subtitle: {
        text: 'Source: 회계팀'
    },

    yAxis: {
        title: {
            text: '구매량'
        }
    },
    legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
    },

    plotOptions: {
        series: {
            label: {
                connectorAllowed: false
            },
            pointStart: 1
        }
    },

    series: resultArr,

    responsive: {
        rules: [{
            condition: {
                maxWidth: 500
            },
            chartOptions: {
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            }
        }]
    }

});

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

var resultArr = new Array(); // 메인 배열

for(var i=0; i<jsonArray.length; i++) {
	var subArr = new Array();
	subArr.push(Number(jsonArray[i].JAN));
	subArr.push(Number(jsonArray[i].FEB));
	subArr.push(Number(jsonArray[i].MAR));
	subArr.push(Number(jsonArray[i].APR));
	subArr.push(Number(jsonArray[i].MAY));
	subArr.push(Number(jsonArray[i].JUN));
	subArr.push(Number(jsonArray[i].JUL));
	subArr.push(Number(jsonArray[i].AUG));
	subArr.push(Number(jsonArray[i].SEP));
	subArr.push(Number(jsonArray[i].OCT));
	subArr.push(Number(jsonArray[i].NOV));
	subArr.push(Number(jsonArray[i].DEC));
	
	var obj = {name: jsonArray[i].CNAME,
			   data: subArr};
	
	resultArr.push(obj);
}



Highcharts.chart('hereChart2', {
    chart: {
        type: 'column'
    },
    title: {
        text: '카테고리별 월별 판매현황(막대)'
    },
    subtitle: {
        text: 'Source: 회계팀'
    },
    xAxis: {
        categories: [
            '1월',
            '2월',
            '3월',
            '4월',
            '5월',
            '6월',
            '7월',
            '8월',
            '9월',
            '10월',
            '11월',
            '12월'
        ],
        crosshair: true
    },
    yAxis: {
        min: 0,
        title: {
            text: '구매량'
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.0f} 개</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    },
    plotOptions: {
        column: {
            pointPadding: 0.2,
            borderWidth: 0
        }
    },
    series: resultArr
});

</script>


<jsp:include page="../footer.jsp"></jsp:include>