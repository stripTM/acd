<main id="manageInstallation">
	<div class="hrow">
		<div><h2 class="h">Instalación</h2><div class="sub">Índices de la base de datos</div></div>
	</div>
	<div class="card ecard">
		<pre class="mono"><?=$collectionsIndexes?></pre>
		<form action="do_install.php" method="post" class="formActions">
			<button type="submit" name="a" value="Create DB indexes" class="btn pri">Crear índices</button>
			<button type="submit" name="a" value="Drop DB indexes" class="btn ghost-bad">Eliminar índices</button>
		</form>
	</div>
</main>
