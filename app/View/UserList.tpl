<?php
use Acd\View\Icon;
use Acd\View\Badge;
?>
<main id="manageUser">
	<div class="hrow">
		<div><h2 class="h">Usuarios</h2><div class="sub">Personas con acceso al gestor</div></div>
		<div id="new_user" class="hacts"><a href="?a=new" class="btn pri new"><?=Icon::svg('plus')?> Nuevo usuario</a></div>
	</div>
	<ol id="usert_list" class="card list_with_options">
		<?php
			foreach ($userList as $item) {
		?>
			<li class="list_item">
			<form action="do_user.php" method="post">
				<input type="hidden" name="id" value="<?=htmlspecialchars($item->getId())?>"/>
				<span class="av"><?=htmlspecialchars(Badge::initials($item->getId()))?></span>
				<label><?=htmlspecialchars($item->getId())?></label>
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
