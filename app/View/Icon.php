<?php
namespace Acd\View;

// Inline SVG icons (stroke based, inherit the text color)
class Icon {
	private const PATHS = [
		'grid' => '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/>',
		'layers' => '<path d="M12 3l9 5-9 5-9-5 9-5z"/><path d="M3 13l9 5 9-5"/>',
		'doc' => '<path d="M14 3H6a2 2 0 00-2 2v14a2 2 0 002 2h12a2 2 0 002-2V9z"/><path d="M14 3v6h6M8 13h8M8 17h5"/>',
		'list' => '<path d="M9 6h11M9 12h11M9 18h11"/><circle cx="4" cy="6" r="1"/><circle cx="4" cy="12" r="1"/><circle cx="4" cy="18" r="1"/>',
		'users' => '<circle cx="9" cy="8" r="4"/><path d="M2 21c0-4 3-6 7-6s7 2 7 6M17 11a3 3 0 100-6M22 21c0-3-2-5-5-5.5"/>',
		'search' => '<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>',
		'plus' => '<path d="M12 5v14M5 12h14"/>',
		'left' => '<path d="M15 18l-6-6 6-6"/>',
		'right' => '<path d="M9 18l6-6-6-6"/>',
		'code' => '<path d="M8 7l-5 5 5 5M16 7l5 5-5 5"/>',
		'copy' => '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15V5a2 2 0 012-2h8"/>',
		'trash' => '<path d="M3 6h18M8 6V4h8v2M6 6l1 15h10l1-15"/>',
		'check' => '<path d="M5 12l5 5 9-10"/>',
		'close' => '<path d="M6 6l12 12M18 6L6 18"/>',
		'edit' => '<path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M13.5 6.5l4 4"/>',
		'type' => '<path d="M4 7V5h16v2M12 5v14M9 19h6"/>',
		'img' => '<rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M21 16l-5-5-9 9"/>',
		'sliders' => '<path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="18" cy="18" r="2"/>',
		'tag' => '<path d="M20 12l-8 8-9-9V3h8z"/><circle cx="7.5" cy="7.5" r="1.5"/>',
		'info' => '<circle cx="12" cy="12" r="9"/><path d="M12 11v6M12 7.5v.5"/>',
		'link' => '<path d="M10 14a5 5 0 007 0l3-3a5 5 0 00-7-7l-1 1M14 10a5 5 0 00-7 0l-3 3a5 5 0 007 7l1-1"/>',
		'menu' => '<path d="M4 6h16M4 12h16M4 18h16"/>',
		'logout' => '<path d="M15 4h3a2 2 0 012 2v12a2 2 0 01-2 2h-3M10 8l-4 4 4 4M6 12h10"/>',
		'db' => '<ellipse cx="12" cy="6" rx="8" ry="3"/><path d="M4 6v6c0 1.7 3.6 3 8 3s8-1.3 8-3V6M4 12v6c0 1.7 3.6 3 8 3s8-1.3 8-3v-6"/>',
		'up' => '<path d="M12 19V7M6 12l6-6 6 6M5 3h14"/>',
		'down' => '<path d="M12 5v12M6 12l6 6 6-6M5 21h14"/>',
	];

	public static function svg($name) {
		$paths = self::PATHS[$name] ?? '';
		return '<svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'.$paths.'</svg>';
	}
}
