<?php
use Acd\View\Icon;

$bNew = $enumeratedElement->getId() == '';
?>
<main id="manageStructure">
	<form action="do_enumerated.php" method="post">
		<div class="ehead">
			<div class="etitle">
				<div class="etitleRow"><h2><?=$bNew ? 'Nuevo enumerado' : htmlspecialchars($enumeratedElement->getId())?></h2></div>
				<div class="meta">Colección de valores enumerados · arrastra las filas para ordenarlas</div>
			</div>
			<div class="acts actions">
				<button name="a" value="save" class="btn pri publish" type="submit"><?=Icon::svg('check')?> Guardar</button>
			</div>
		</div>
		<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
		<?php
			if($bNew) {
		?>
			<div class="card ecard pre_table enumerated">
				<div class="fgrp"><label for="id_enumerated">Id de la colección</label><input name="id" id="id_enumerated" value="" required="required" placeholder="Nuevo id" type="text" class="field text mono"/></div>
			</div>
		<?php
			}
			else {
		?>
			<input name="id" value="<?=htmlspecialchars($enumeratedElement->getId())?>" type="hidden"/>
		<?php
			}
		?>
		<div class="card tableWrap">
		<table class="result_table enumerated">
			<thead>
				<tr>
					<th class="id">Id</th>
					<th class="description">Descripción</th>
					<th class="action"></th>
				</tr>
			</thead>
			<tbody>
			<?php
				$n = 0;
				foreach ($enumeratedElement->getItems() as $key => $item) {
			?>
				<tr>
					<td><input type="text" name="element[<?=htmlspecialchars($key)?>][id]" value="<?=htmlspecialchars($key)?>" class="field text mono"/></td>
					<td><input type="text" name="element[<?=htmlspecialchars($key)?>][description]" value="<?=htmlspecialchars($item)?>" class="field text"/></td>
					<td class="action">
						<input name="element[<?=htmlspecialchars($key)?>][delete]" value="1" id="delete_element_<?=$n?>" type="checkbox"/>
						<label for="delete_element_<?=$n?>" class="inlineLabel">Eliminar</label>
					</td>
				</tr>
			<?php
					$n++;
				}
			?>
				<tr>
					<td><input type="text" name="element[<?=$enumeratedElement::EMPTY_ID?>][id]" value="" placeholder="Nuevo id" class="field text mono"/></td>
					<td><input type="text" name="element[<?=$enumeratedElement::EMPTY_ID?>][description]" value="" placeholder="Nueva descripción" class="field text"/></td>
					<td></td>
				</tr>
			</tbody>
		</table>
		</div>
	</form>
</main>
