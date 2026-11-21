<main id="showRelation" class="narrow">
	<div class="hrow">
		<div><h2 class="h">Usado en</h2><div class="sub"><em><?=htmlspecialchars((string) $contentTitle)?></em> forma parte de estos contenidos</div></div>
	</div>
	<ol id="enumerated_list" class="card linkList">
		<?php
			foreach ($parentList as $item) {
		?>
			<li><a href="content.php?a=edit&amp;id=<?=htmlspecialchars($item->getId()).'&amp;idt='.htmlspecialchars($item->getIdStructure())?>"><span class="ti"><?=htmlspecialchars($item->getTitle())?></span><small><?=htmlspecialchars($item->getIdStructure())?></small></a></li>
		<?php
			}
		?>
	</ol>
</main>
