<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<title>한글 아이대니</title>
<style>
/* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
#map {
	height: 100%;
}
/* Optional: Makes the sample page fill the window. */
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}

#floating-panel {
	position: absolute;
	top: 10px;
	left: 25%;
	z-index: 5;
	background-color: #fff;
	padding: 5px;
	border: 1px solid #999;
	text-align: center;
	font-family: 'Roboto', 'sans-serif';
	line-height: 30px;
	padding-left: 10px;
}
</style>
</head>
<body>
	<table class="list">
		<tr>
			<td colspan="5" style="border: white; text-align: right">
		</tr>
		<tr>
			<th>번호</th>
			<th>주소</th>
			<th>X좌표</th>
			<th>Y좌표</th>
		</tr>
		<c:forEach var="c" items="${cdata}">
			<tr class="record">
				<td>${c.num}</td>
				<td>${c.address}</td>
				<td>${c.corX}</td>
				<td>${c.corY}</td>
			</tr>
		</c:forEach>

	</table>
	<div id="floating-panel">
		<b>Start: </b> <select id="start">
			<c:forEach var="c" items="${cdata}">
				<option value='{"lat":"${c.corX}","lng":"${c.corY}"}'>${c.address}</option>	<!-- 아놔 이거 값만 딱 뽑아서 자바스크립트안에 못넣나..못해ㅓㄱ겠네  -->
			</c:forEach>

		</select> <b>End: </b> <select id="end">
			<c:forEach var="c" items="${cdata}">
				<option value='{"lat":"${c.corX}","lng":"${c.corY}"}'>${c.address}</option>
			</c:forEach>
		</select>
	</div>
	<div id="map" style="width: 100%; height: 600px;"></div>
	<script>
		function initMap() {
			var directionsService = new google.maps.DirectionsService;
			var directionsDisplay = new google.maps.DirectionsRenderer;
			var map = new google.maps.Map(document.getElementById('map'), {
				zoom : 7,
				center : {
					lat : 41.85,
					lng : -87.65
				}
			});
			directionsDisplay.setMap(map);
			//console.log(document.getElementById('start').value);
			//console.log(document.getElementById('end').value);

			var onChangeHandler = function() {
				calculateAndDisplayRoute(directionsService, directionsDisplay);
			};
			document.getElementById('start').addEventListener('change',
					onChangeHandler);
			document.getElementById('end').addEventListener('change',
					onChangeHandler);
		}

		function calculateAndDisplayRoute(directionsService, directionsDisplay) {
			
			var X = JSON.parse(document.getElementById('start').value);
			var Y = JSON.parse(document.getElementById('end').value);
			var s = new google.maps.LatLng(X.lat, X.lng);
			var e = new google.maps.LatLng(Y.lat, Y.lng);
			console.log(s.toString());
			console.log(e.toString())
			directionsService.route(
					{
				origin: s,
				destination: e,
				 //origin: {lat:41.878,lng:129.10400000000004},  // Haight.
          //destination: {lat:35.116,lng:129.09000000000003},  // Ocean Beach.
				travelMode : 'DRIVING'
			}, function(response, status) {
				if (status === 'OK') {
					directionsDisplay.setDirections(response);
				} else {
					window.alert('Directions request failed due to ' + status);
				}
			});
		}
	</script>
	<script async defer
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDOXKbwcyrhhhZmUvi8fatEcIs59YQgX5E&callback=initMap">
		
	</script>
</body>
</html>