<?php
use Acd\View\Icon;
use Acd\Model\ValueFormater;

$bNew = $userElement->getId() == '';
$userRol = $userElement->getRol();
?>
<main id="manageStructure" class="narrow">
	<form action="do_user.php" method="post">
		<div class="ehead">
			<div class="etitle">
				<div class="etitleRow"><h2><?=$bNew ? 'Nuevo usuario' : htmlspecialchars($userElement->getId())?></h2></div>
				<div class="meta">Usuario</div>
			</div>
			<div class="acts actions">
				<button name="a" value="save" class="btn pri publish" type="submit"><?=Icon::svg('check')?> Guardar</button>
			</div>
		</div>
		<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
		<fieldset class="card ecard internal">
		<?php
			if($bNew) {
		?>
			<div class="fgrp pre_table user">
				<label for="id_user">Id de usuario</label><input name="id" id="id_user" value="" required="required" placeholder="Nuevo id" type="text" class="field text"/>
			</div>
			<div class="fgrp">
				<label for="password">Contraseña</label><input type="password" name="password" id="password" value="" required="required"/>
			</div>
		<?php
			}
			else {
		?>
			<input name="id" value="<?=htmlspecialchars($userElement->getId())?>" type="hidden"/>
			<div class="fgrp">
				<label for="password">Contraseña <em class="hint">· déjala vacía para no cambiarla</em></label><input type="password" name="password" id="password" value=""/>
			</div>
		<?php
			}
		?>
		<div class="fgrp">
			<?php
			$options = '';
			foreach ($roles as $key => $value) {
				$selected = $userRol === $key ? ' selected="selected"' : '';
				$options .= '<option value="'.htmlspecialchars($key).'"'.$selected.'>'.htmlspecialchars($value).'</option>';

			}
			?>
			<label for="rol">Rol</label><select name="rol" id="rol" required="required"><option></option><?=$options?></select>
		</div>
		</fieldset>
	</form>
	<?php
		if($authPermanentList) {
	?>
		<h3 class="sectionTitle">Sesiones recordadas</h3>
		<?php
			$listAuth = '';
			foreach($authPermanentList as $authPermanent) {
				$listAuth .= '<li class="list_item">'
				.'<form action="do_process_auth_permanent.php" method="post">'
				.'<input name="id" value="'.htmlspecialchars($authPermanent->getId()).'" type="hidden"/>'
				.'<input name="login" value="'.htmlspecialchars($authPermanent->getLogin()).'" type="hidden"/>'
				.'<label>'
					.'<span class="mono token">'.htmlspecialchars($authPermanent->getId()).'</span> '
					.'<span class="date" title="Creación '.ValueFormater::encode($authPermanent->getCreationDate(), ValueFormater::TYPE_DATE_TIME, ValueFormater::FORMAT_EDITOR).'">'
						.ValueFormater::encode($authPermanent->getCreationDate(), ValueFormater::TYPE_DATE_TIME, ValueFormater::FORMAT_HUMAN)
					.'</span> - '
					.'<span class="date" title="Último uso '.ValueFormater::encode($authPermanent->getLastUseDate(), ValueFormater::TYPE_DATE_TIME, ValueFormater::FORMAT_EDITOR).'">'
						.ValueFormater::encode($authPermanent->getLastUseDate(), ValueFormater::TYPE_DATE_TIME, ValueFormater::FORMAT_HUMAN)
					.'</span> '
				.'</label>'
				.'<span class="tools"><button type="submit" name="a" value="delete" class="btn sm ghost-bad delete">'.Icon::svg('trash').' Eliminar</button></span>'
				.'</form>'
				.'</li>';
			}
		?>
		<ol id="auth_persistent_list" class="card list_with_options"><?=$listAuth?></ol>
	<?php
		}
	?>
</main>
