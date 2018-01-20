<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, shrink-to-fit=no">
<title>�ּҿ� ��ǥ �˻� API ����ϱ� | ���̹� ���� API v3</title>
</head>
<body>

	<script src="./js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="./js/base.js"></script>
	<script type="text/javascript"
		src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=fykMCkzq5KUzK1n3hsJS&amp;submodules=panorama,geocoder,drawing,visualization"></script>
	<link rel="stylesheet" type="text/css" href="./css/base.css" />

	<section class="tutorial-section"> <header></header> <article>

	<style type="text/css">
.search {
	position: absolute;
	z-index: 1000;
	top: 20px;
	left: 20px;
}

.search #address {
	width: 150px;
	height: 20px;
	line-height: 20px;
	border: solid 1px #555;
	padding: 5px;
	font-size: 12px;
	box-sizing: content-box;
}

.search #submit {
	height: 30px;
	line-height: 30px;
	padding: 0 10px;
	font-size: 12px;
	border: solid 1px #555;
	border-radius: 3px;
	cursor: pointer;
	box-sizing: content-box;
}
</style>

	<div id="wrap" class="section">
		<h2>�ּҿ� ��ǥ �˻� API ����ϱ�</h2>
		<p>
			Geocoder �������� Service ��ü�� ����Ͽ�, �ּҷ� ��ǥ �˻� (Geocode) �Ǵ� ��ǥ�� �ּҸ� �˻�
			(ReverseGeocode) �ϴ� �����Դϴ�.<br /> �Է�â�� �ּҸ� �Է��Ͽ� �˻��ϸ� �ش� �ּ��� ��ǥ�� �̵��ϸ�,
			������ Ŭ���ϸ� �ش� ������ TM128 ��ǥ�� �ּҸ� �˻��մϴ�.
		</p>
		<div id="map" style="width: 100%; height: 600px;">
			<div class="search" style="">
				<input id="address" type="text" placeholder="�˻��� �ּ�" value="������ 6" />
				<input id="submit" type="button" value="�ּ� �˻�" />
			</div>
		</div>
		<code id="snippet" class="snippet"></code> <!-- �� �̰� ���ű��ϳ� �ڵ尡 �״�� ������  -->
	</div>

	<script id="code">
		var map = new naver.maps.Map("map", {
			center : new naver.maps.LatLng(37.3595316, 127.1052133),
			zoom : 10,
			mapTypeControl : true
		});

		var infoWindow = new naver.maps.InfoWindow({
			anchorSkew : true
		});

		map.setCursor('pointer');

		// search by tm128 coordinate
		function searchCoordinateToAddress(latlng) {
			var tm128 = naver.maps.TransCoord.fromLatLngToTM128(latlng);

			infoWindow.close();

			naver.maps.Service
					.reverseGeocode(
							{
								location : tm128,
								coordType : naver.maps.Service.CoordType.TM128
							},
							function(status, response) {
								if (status === naver.maps.Service.Status.ERROR) {
									return alert('Something Wrong!');
								}

								var items = response.result.items, htmlAddresses = [];

								for (var i = 0, ii = items.length, item, addrType; i < ii; i++) {
									item = items[i];
									addrType = item.isRoadAddress ? '[���θ� �ּ�]'
											: '[���� �ּ�]';

									htmlAddresses.push((i + 1) + '. '
											+ addrType + ' ' + item.address);
									htmlAddresses
											.push('&nbsp&nbsp&nbsp -> '
													+ item.point.x + ','
													+ item.point.y);
								}

								infoWindow
										.setContent([
												'<div style="padding:10px;min-width:200px;line-height:150%;">',
												'<h4 style="margin-top:5px;">�˻� ��ǥ : '
														+ response.result.userquery
														+ '</h4><br />',
												htmlAddresses.join('<br />'),
												'</div>' ].join('\n'));

								infoWindow.open(map, latlng);
							});
		}

		// result by latlng coordinate
		function searchAddressToCoordinate(address) {
			naver.maps.Service
					.geocode(
							{
								address : address
							},
							function(status, response) {
								if (status === naver.maps.Service.Status.ERROR) {
									return alert('Something Wrong!');
								}
								//post
								var data = {
										json : JSON.stringify(response)
								}
								$.post("hello", data, function(result) {
									console.log("postok");
									return result;
								})
								location.href="./hello";
								var item = response.result.items[0], addrType = item.isRoadAddress ? '[���θ� �ּ�]'
										: '[���� �ּ�]', point = new naver.maps.Point(
										item.point.x, item.point.y);

								infoWindow
										.setContent([
												'<div style="padding:10px;min-width:200px;line-height:150%;">',
												'<h4 style="margin-top:5px;">�˻� �ּ� : '
														+ response.result.userquery
														+ '</h4><br />',
												addrType + ' ' + item.address
														+ '<br />',
												'&nbsp&nbsp&nbsp -> ' + point.x
														+ ',' + point.y,
												'</div>' ].join('\n'));

								map.setCenter(point);
								infoWindow.open(map, point);
							});
		}

		function initGeocoder() {
			map.addListener('click', function(e) {
				searchCoordinateToAddress(e.coord);
			});

			$('#address').on('keydown', function(e) {
				var keyCode = e.which;

				if (keyCode === 13) { // Enter Key
					searchAddressToCoordinate($('#address').val());
				}
			});

			$('#submit').on('click', function(e) {
				e.preventDefault();

				searchAddressToCoordinate($('#address').val());
			});

			searchAddressToCoordinate('���ڵ� 178-1');
		}

		naver.maps.onJSContentLoaded = initGeocoder;
	</script> </article> </section>

	</div>
	</div>


	</div>
	</div>


	</script>
</body>
</html>