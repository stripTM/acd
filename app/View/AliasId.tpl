<main id="showMatches" class="narrow">
	<?php
		// Distribute results in precise and difuse lists
		$list['precise'] = '';
		$list['difuse'] = '';
		foreach ($matchList as $item) {
			$target = ($item->getAliasId() === $aliasId) ? 'precise' : 'difuse';
			$list[$target] .= '<li><a href="content.php?a=edit&amp;id='.htmlspecialchars($item->getId()).'&amp;idt='.htmlspecialchars($item->getIdStructure()).'"><span class="ti">'.htmlspecialchars($item->getTitle()).'</span><span class="al mono">'.htmlspecialchars($item->getAliasId()).'</span><small>'.htmlspecialchars($item->getIdStructure()).'</small></a></li>';
		}
	?>
	<div class="hrow">
		<div><h2 class="h">Alias-id</h2><div class="sub">Contenidos con el alias <em class="mono"><?=htmlspecialchars((string) $contentTitle)?></em></div></div>
	</div>
	<ol id="precise_aliasId_list" class="card linkList">
			<?=$list['precise']?>
	</ol>
	<?=$resultDesc ? "<p class=\"result fail\">$resultDesc</p>" : ''?>
	<?php
	if ($list['difuse']) {
	?>
		<h3 class="sectionTitle">Coincidencias por búsqueda difusa</h3>
		<ol id="difuse_aliasId_list" class="card linkList">
				<?=$list['difuse']?>
		</ol>
	<?php
	}
	?>
</main>
