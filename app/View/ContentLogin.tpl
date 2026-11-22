<main class="loginPage">
	<form action="do_login.php" method="post" class="card form_login">
		<div class="logo"><img src="style/brand/acd-mark.svg" alt="" class="mk" width="34" height="34"/><span class="nm"><b>A</b>dministrador de<br/><b>C</b>ontenidos <b>D</b>inámicos</span></div>
		<h2 class="h">Iniciar sesión</h2>
		<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
		<?php
		if(isset($urlPostLogin)) {
		?>
			<input type="hidden" name="re" value="<?=htmlspecialchars($urlPostLogin)?>"/>
		<?php
		}
		?>
		<div class="fgrp text">
			<label for="login">Usuario</label>
			<input type="text" name="login" value="<?=htmlspecialchars($login)?>" spellcheck="false" id="login" required="required" autofocus="autofocus"/>
		</div>
		<div class="fgrp text">
			<label for="password">Contraseña</label>
			<input type="password" name="password" value="" id="password" required="required"/>
		</div>
		<div class="remember">
			<input type="checkbox" name="remember" id="remember" value="1" <?=\Acd\Model\ValueFormater::encode($bRemember, \Acd\Model\ValueFormater::TYPE_BOOLEAN, \Acd\Model\ValueFormater::FORMAT_EDITOR)?>/>
			<label for="remember">Recordarme en este equipo</label>
		</div>
		<div class="submit"><button type="submit" name="a" value="Enter" class="btn pri">Entrar</button></div>
	</form>
</main>
