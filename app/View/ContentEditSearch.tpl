<?php
use Acd\View\Icon;
?>
<main>
	<div class="hrow">
		<div><h2 class="h">Buscar contenido</h2><div class="sub">Selecciona los contenidos que quieres relacionar</div></div>
	</div>
	<p class="result"><?=$resultDesc?></p>
	<form action="" method="get" class="toolbar">
		<input type="hidden" name="idp" value="<?=htmlspecialchars($id)?>"/>
		<input type="hidden" name="idtp" value="<?=htmlspecialchars($type)?>"/>
		<input type="hidden" name="f" value="<?=htmlspecialchars($idField)?>"/>
		<label class="inputIcon" for="title"><?=Icon::svg('search')?><input type="search" name="s" id="title" value="<?=htmlspecialchars((string) $titleSearch)?>" placeholder="Buscar por título…"/></label>
		<label for="idt" class="inlineLabel">Estructura</label>
			<select name="idt" id="idt" required="required">
			<?php
				// If there is only one structure it is not necessary to choose it
				if ($structures->length() > 1) {
			?>
				<option></option>
			<?php
			}
				foreach ($structures as $estructure) {
					$selected = $estructure->getId() === $idStructureTypeSearch ? ' selected="selected"' : '';
			?>
				<option value="<?=htmlspecialchars($estructure->getId())?>"<?=$selected?>><?=htmlspecialchars($estructure->getName())?></option>
			<?php
				}
			?>
			</select>
		<button type="submit" name="a" value="search" class="btn">Buscar</button>
	</form>
	<?php
	if($resultSearchContents) {
		$limits = $resultSearchContents->getLimits();
		$lowerLimit = $limits->getLower();
		$bMorePage = $limits->getUpper() <= $limits->getTotal();
		$setPrevPage = $lowerLimit > 0;
		$nextPage = $limits->getUpper() / $limits->getStep();
		$prevPage = $limits->getLower() / $limits->getStep() -1;
		$totalPages = ceil($limits->getTotal() / $limits->getStep());
		$setPagination = $setPrevPage || $bMorePage;
	?>
		<form action="content.php?a=edit&id=<?=urlencode($id)?>&idt=<?=urlencode($type)?>" method="post">
			<input name="a" value="edit" type="hidden"/>
			<input name="modrel" value="1" type="hidden"/>
			<input name="id" value="<?=htmlspecialchars($id)?>" type="hidden"/>
			<input name="idt" value="<?=htmlspecialchars($type)?>" type="hidden"/>
			<ol id="contents_list" class="card checkList" data-lower-limit="<?=$lowerLimit?>">
			<?php
				$posElement = 0;
				foreach ($resultSearchContents as $contentFound) {
					$posElement++;
			?>
				<li>
					<input name="posElement[]" value="<?=$posElement?>" type="checkbox" id="content_<?=$posElement?>"/>
					<input name="element[<?=$posElement?>][id]" value="<?=htmlspecialchars($id)?>" type="hidden"/>
					<input name="element[<?=$posElement?>][idt]" value="<?=htmlspecialchars($type)?>" type="hidden"/>
					<input name="element[<?=$posElement?>][idm]" value="<?=htmlspecialchars($idField)?>" type="hidden"/>
					<input name="element[<?=$posElement?>][refm]" value="<?=htmlspecialchars($contentFound->getId())?>" type="hidden"/>
					<input name="element[<?=$posElement?>][reftm]" value="<?=htmlspecialchars($contentFound->getIdStructure())?>" type="hidden"/>
					<input name="element[<?=$posElement?>][posm]" value="<?=htmlspecialchars((string) $positionInField)?>" type="hidden"/>
					<label for="content_<?=$posElement?>"><?=htmlspecialchars($contentFound->getTitle())?></label>
				</li>
			<?php
				}
			?>
			</ol>
			<?php
			if ($posElement === 0) {
			?>
				<p class="empty">No se han encontrado contenidos.</p>
			<?php
			}
			?>
			<div class="formActions actions">
				<button name="action" value="add top" class="btn pri add_top" type="submit"><?=Icon::svg('up')?> Añadir al principio</button>
				<button name="action" value="add bottom" class="btn pri add_bottom" type="submit"><?=Icon::svg('down')?> Añadir al final</button>
			</div>
		</form>
		<?php
		if($setPagination) {
		?>
		<p class="pagination">
			<?php if($setPrevPage) { ?>
				<a class="btn" href="?idp=<?=urlencode($id)?>&amp;idtp=<?=urlencode($type)?>&amp;f=<?=urlencode($idField)?>&amp;s=<?=urlencode((string) $titleSearch)?>&amp;idt=<?=urlencode((string) $idStructureTypeSearch)?>&amp;a=search&amp;p=<?=$prevPage?>"><?=Icon::svg('left')?> Anterior</a>
			<?php } ?>
			<span class="pageNum">Página <?=$nextPage?> de <?=$totalPages?></span>
			<?php if($bMorePage) {?>
			<a class="btn" href="?idp=<?=urlencode($id)?>&amp;idtp=<?=urlencode($type)?>&amp;f=<?=urlencode($idField)?>&amp;s=<?=urlencode((string) $titleSearch)?>&amp;idt=<?=urlencode((string) $idStructureTypeSearch)?>&amp;a=search&amp;p=<?=$nextPage?>">Siguiente <?=Icon::svg('right')?></a>
			<?php } ?>
		</p>
		<?php
		}
	}
	?>
</main>
