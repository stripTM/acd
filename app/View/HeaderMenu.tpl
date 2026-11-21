	<div id="header-menu">
		<a href="#tools" class="iconbtn tools-menu" title="Menú" aria-label="Menú"><?=\Acd\View\Icon::svg('menu')?></a>
		<?php
			if($this->bBackLink ) {
		?>
			<span class="backWrap"><a href="back.php" class="iconbtn back" title="Volver (pulsación larga: historial)" aria-label="Volver"><?=\Acd\View\Icon::svg('left')?></a></span>
		<?php
			}
		?>
	</div>
