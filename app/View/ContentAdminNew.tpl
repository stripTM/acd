<?php
use Acd\View\Icon;
?>
<main class="narrow">
	<div class="hrow">
		<div><h2 class="h">Nueva estructura</h2><div class="sub">Después de crearla podrás añadirle campos</div></div>
	</div>
	<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
	<form action="do_process_structure.php" method="post" class="card ecard">
		<div class="fgrp">
			<label for="id">Id</label><input type="text" name="id" id="id" value="" required="required" class="field text mono"/>
		</div>
		<div class="fgrp">
			<label for="name">Nombre</label><input type="text" name="name" id="name" value="" required="required" class="field text"/>
		</div>
		<div class="fgrp">
			<?php
			$options = '';
			foreach ($storageTypes as $key => $value) {
				$selected = $storage === $key ? ' selected="selected"' : '';
				$disabled = $value['disabled'] ? ' disabled="disabled"' : '';
				$options .= '<option value="'.htmlspecialchars($key).'"'.$selected.$disabled.'>'.htmlspecialchars($value['name']).'</option>';
			}
			?>
			<label for="storage">Tipo de almacenamiento</label><select name="storage" id="storage" required="required"><?=$options?></select>
		</div>
		<div class="formActions">
			<input type="hidden" name="a" value="new"/>
			<button type="submit" name="accion" value="save" class="btn pri publish"><?=Icon::svg('check')?> Guardar</button>
		</div>
	</form>
</main>
