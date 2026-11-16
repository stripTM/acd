<?php
use Acd\View\Icon;
use Acd\View\Badge;
?>
<main>
	<div class="hrow">
		<div><h2 class="h">Estructuras</h2><div class="sub">Define los tipos de contenido y sus campos</div></div>
		<div id="new_structure" class="hacts"><a href="?a=new" class="btn pri new"><?=Icon::svg('plus')?> Nueva estructura</a></div>
	</div>
	<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
	<div class="toolbar">
		<label class="inputIcon" for="structures_filter"><?=Icon::svg('search')?><input type="search" id="structures_filter" placeholder="Filtrar estructuras…"/></label>
	</div>
	<ol id="structures_list" class="card list_with_options">
	<?php
		foreach ($structures as $structure) {
	?>
		<li class="structure list_item">
			<form action="do_process_structure.php" method="post">
				<input type="hidden" name="id" value="<?=htmlspecialchars($structure->getId())?>"/>
				<span class="ic" style="background:<?=Badge::structureColor($structure->getId())?>"><?=htmlspecialchars(Badge::initials($structure->getName()))?></span>
				<label><?=htmlspecialchars($structure->getName())?> <small class="mono"><?=htmlspecialchars($structure->getId())?></small></label>
				<span class="tools">
					<button type="submit" name="a" value="edit" class="btn sm edit"><?=Icon::svg('edit')?> Editar</button>
					<button type="submit" name="a" value="clone" class="btn sm clone"><?=Icon::svg('copy')?> Clonar</button>
					<button type="submit" name="a" value="delete" class="btn sm ghost-bad delete"><?=Icon::svg('trash')?> Eliminar</button>
					<a href="content.php?a=list_contents&amp;id=<?=urlencode($structure->getId())?>" class="btn sm content"><?=Icon::svg('doc')?> Contenidos</a>
				</span>
			</form>
		</li>
	<?php
		}
	?>
	</ol>
</main>
