<?php
use Acd\View\Icon;
use Acd\View\Badge;

$limits = $contents->getLimits();
$lowerLimit = $limits->getLower();
$bMorePage = $limits->getUpper() <= $limits->getTotal();
$setPrevPage = $lowerLimit > 0;
$nextPage = $limits->getUpper() / $limits->getStep();
$prevPage = $limits->getLower() / $limits->getStep() -1;
$totalPages = ceil($limits->getTotal() / $limits->getStep());
$setPagination = $setPrevPage || $bMorePage;
$position = $lowerLimit;
$thumbColor = Badge::structureColor($structure->getId());
?>
<main>
	<div class="hrow">
		<div>
			<h2 class="h"><?=htmlspecialchars($structure->getName())?></h2>
			<div class="sub"><?=(int) $limits->getTotal()?> contenidos<?=$titleSearch ? ' · filtrados por «'.htmlspecialchars($titleSearch).'»' : ''?></div>
		</div>
		<div id="new_content" class="hacts"><a href="?a=new&amp;idt=<?=urlencode($structure->getId())?>" class="btn pri new"><?=Icon::svg('plus')?> Nuevo contenido</a></div>
	</div>
	<form action="" method="get" class="toolbar wrap_search">
		<input type="hidden" name="id" value="<?=htmlspecialchars($structure->getId())?>"/>
		<input type="hidden" name="a" value="list_contents"/>
		<label class="inputIcon" for="title"><?=Icon::svg('search')?><input type="search" name="s" id="title" value="<?=htmlspecialchars($titleSearch)?>" placeholder="Buscar por título…"/></label>
		<button type="submit" name="action" value="search" class="btn">Buscar</button>
	</form>
	<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
	<div class="card table">
		<div class="thead"><div>#</div><div>Título</div><div>Alias-id</div><div>Etiquetas</div><div>Vigencia</div><div>Estado</div><div>Editado</div></div>
		<ol id="contents_list" data-lower-limit="<?=$lowerLimit?>">
		<?php
			foreach ($contents as $content) {
				$position++;
				$tags = array_filter((array) $content->getTags(), 'strlen');
		?>
			<li class="content">
				<a class="row" href="?a=edit&amp;id=<?=urlencode($content->getId())?>&amp;idt=<?=urlencode($content->getIdStructure())?>">
					<span class="th" style="background:<?=$thumbColor?>"><?=$position?></span>
					<span class="ti"><?=htmlspecialchars($content->getTitle())?></span>
					<span class="al mono"><?=htmlspecialchars((string) $content->getAliasId())?></span>
					<span class="tg"><?php foreach ($tags as $tag) { echo '<span class="chip">'.htmlspecialchars($tag).'</span>'; } ?></span>
					<span class="dt"><?=Badge::validityRange($content)?></span>
					<span class="st"><?=Badge::validity($content)?></span>
					<span class="dt"><?=Badge::elapsed($content->getSaveTime())?></span>
				</a>
			</li>
		<?php
			}
		?>
		</ol>
		<?php
		if ($position === $lowerLimit) {
		?>
			<p class="empty">No hay contenidos<?=$titleSearch ? ' que coincidan con la búsqueda' : ' todavía'?>.</p>
		<?php
		}
		?>
	</div>
	<?php
	if($setPagination) {
	 ?>
	<p class="pagination">
		<?php if($setPrevPage) { ?>
			<a class="btn" href="?a=list_contents&amp;id=<?=urlencode($structure->getId())?>&amp;p=<?=$prevPage?>&amp;s=<?=urlencode((string) $titleSearch)?>"><?=Icon::svg('left')?> Anterior</a>
		<?php } ?>
		<span class="pageNum">Página <?=$nextPage?> de <?=$totalPages?></span>
		<?php if($bMorePage) {?>
		<a class="btn" href="?a=list_contents&amp;id=<?=urlencode($structure->getId())?>&amp;p=<?=$nextPage?>&amp;s=<?=urlencode((string) $titleSearch)?>">Siguiente <?=Icon::svg('right')?></a>
		<?php } ?>
	</p>
	<?php
	}
	?>
</main>
