<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<link rel="stylesheet" type="text/css" href="style/main.css"/>
	<link href="style/icon_16.png" rel="icon" />
	<link href="style/icon_128.png" sizes="128x128" rel="icon" />
	<title><?=htmlspecialchars($headTitle)?></title>
</head>
<body class="<?=$bodyClass?>">
<header>
	<?=$headerMenu?>
	<h1>ACD</h1>
</header>
<div id="wrapper">
	<?=$content?>
	<?=$tools?>
</div>
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/main.js"></script>
</body>
</html>