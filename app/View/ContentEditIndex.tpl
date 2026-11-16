<?php
use Acd\View\Icon;
use Acd\View\Badge;

$maxTypeChips = 4;
?>
<main>
	<div class="hrow">
		<div><h2 class="h">Tipos de contenido</h2><div class="sub">Elige una estructura para gestionar sus contenidos</div></div>
	</div>
	<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
	<div class="toolbar">
		<label class="inputIcon" for="structures_filter"><?=Icon::svg('search')?><input type="search" id="structures_filter" placeholder="Filtrar estructuras…"/></label>
	</div>
	<ol id="structures_list" class="grid">
	<?php
		foreach ($structures as $estructure) {
			$typeNames = [];
			foreach ($estructure->getFields() as $field) {
				$typeNames[Badge::fieldTypeName($field->getType())] = true;
			}
			$typeNames = array_keys($typeNames);
			$hiddenTypes = count($typeNames) - $maxTypeChips;
	?>
		<li class="structure">
			<a href="?a=list_contents&amp;id=<?=urlencode($estructure->getId())?>" class="card scard">
				<span class="ic" style="background:<?=Badge::structureColor($estructure->getId())?>"><?=htmlspecialchars(Badge::initials($estructure->getName()))?></span>
				<h3><?=htmlspecialchars($estructure->getName())?></h3>
				<p class="mono"><?=htmlspecialchars($estructure->getId())?></p>
				<span class="ft">
					<?php
					foreach (array_slice($typeNames, 0, $maxTypeChips) as $typeName) {
						echo '<span class="chip">'.htmlspecialchars($typeName).'</span>';
					}
					if ($hiddenTypes > 0) {
						echo '<span class="chip">+'.$hiddenTypes.'</span>';
					}
					?>
					<span class="n"><?=$estructure->getFields()->length()?> campos</span>
				</span>
			</a>
		</li>
	<?php
		}
	?>
	</ol>
</main>
