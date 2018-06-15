<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../header.jsp" />

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>

<div id="hereChart1" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>
<br/>
<div id="hereChart2" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>


<script type="text/javascript">

	Highcharts.chart('hereChart1', {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
    },
    title: {
        text: 'Browser market shares in January, 2018'
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                style: {
                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                }
            }
        }
    },
    series: [{
        name: 'Brands',
        colorByPoint: true,
        data: [{
            name: '크롬',
            y: 61.41,
            sliced: true,
            selected: true
        }, {
            name: '인익',
            y: 11.84
        }, {
            name: '파폭',
            y: 10.85
        }, {
            name: '엣지',
            y: 4.67
        }, {
            name: '샆리',
            y: 4.18
        }, {
            name: '소익',
            y: 1.64
        }, {
            name: '옵라',
            y: 1.6
        }, {
            name: '큐큐',
            y: 1.2
        }, {
            name: '그밖',
            y: 2.61
        }]
    }]
});
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var jsonArray = ${str_jsonArray};

// *** 확인용 ***//
for(var i=0; i<jsonArray.length; i++) {
	console.log(jsonArray[i].CNAME);
	console.log(jsonArray[i].TOTALFIXEDORDERPRICE);
	// *** !! 중요 !! ***//
	console.log(Number(jsonArray[i].PERCENT));
	// 문자열을 숫자로 바꿔주어야 한다.   또는 
	// Number() -> 정수, 실수 // parseFloat() -> 실수  // parseInteger() -> 정수
}

var resultArr = [];

for(var i=0; i<jsonArray.length; i++) {
	var obj = {name: jsonArray[i].CNAME,
		       y: Number(jsonArray[i].PERCENT)};
	resultArr.push(obj);
}


Highcharts.chart('hereChart2', {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
    },
    title: {
        text: '<span style=\"color: red; font-weight: bold;\">${sessionScope.loginuser.name}</span> 님의 주문 성향 분석 통계'
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                style: {
                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                }
            }
        }
    },
    series: [{
        name: 'Brands',
        colorByPoint: true,
        data: resultArr
    }]
});
	
</script>

<jsp:include page="../footer.jsp" />