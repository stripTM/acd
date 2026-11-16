<?php
use Acd\View\Icon;
?>
<main id="manageStructure">
	<div class="hrow">
		<div><h2 class="h">Enumerados</h2><div class="sub">Colecciones de valores para los campos de selección</div></div>
		<div id="new_enumerated" class="hacts"><a href="?a=new" class="btn pri new"><?=Icon::svg('plus')?> Nuevo enumerado</a></div>
	</div>
	<ol id="enumerated_list" class="card list_with_options">
		<?php
			foreach ($enumeratedList as $item) {
		?>
			<li class="list_item">
			<form action="do_enumerated.php" method="post">
				<input type="hidden" name="id" value="<?=htmlspecialchars($item['id'])?>"/>
				<label class="mono"><?=htmlspecialchars($item['id'])?></label>
				<span class="tools">
					<button type="submit" name="a" value="edit" class="btn sm edit"><?=Icon::svg('edit')?> Editar</button>
					<button type="submit" name="a" value="delete" class="btn sm ghost-bad delete"><?=Icon::svg('trash')?> Eliminar</button>
				</span>
			</form>
		</li>
		<?php
			}
		?>
	</ol>
</main>
