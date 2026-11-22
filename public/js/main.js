var editor = {
	$body : null,
	$iDelete : null,
	init : function() {
		/* Tools menu */
		editor.$body = $("body");
		$("#header-menu .tools-menu, #sideBackdrop")
			.bind("click", function(e) {
				editor.$body.toggleClass("withOptions");
				e.preventDefault();
			})
		theme.init();
		toast.init();
		editor.markBusyOnSave();
		/* Back buttom */
		navigationHistory.init();

		/* Delete buttons */
		editor.$iDelete = $('button[value=delete], input[value=delete]');

		/* Prevent accidental  delete*/
		editor.$iDelete.bind("click", editor.confirmDelete);
		$( ".fields .items" )
		.find( ".field" )
			.prepend("<span class='draggable'></span>").end()
		.sortable({
			items: "> .field",
			handle: "> .draggable"
		});

		/* Search structures */
		if($("#structures_list").length > 0 && $("#structures_filter").length > 0) {
			var jets = new Jets({
				searchTag: '#structures_filter',
				contentTag: "#structures_list",
				diacriticsMap: {
					a: 'ÀÁÂÃÄÅàáâãäåĀāąĄ',
					c: 'ÇçćĆčČ',
					d: 'đĐďĎ',
					e: 'ÈÉÊËèéêëěĚĒēęĘ',
					i: 'ÌÍÎÏìíîïĪī',
					l: 'łŁ',
					n: 'ÑñňŇńŃ',
					o: 'ÒÓÔÕÕÖØòóôõöøŌō',
					r: 'řŘ',
					s: 'ŠšśŚ',
					t: 'ťŤ',
					u: 'ÙÚÛÜùúûüůŮŪū',
					y: 'ŸÿýÝ',
					z: 'ŽžżŻźŹ'
				}
			});
		}

		/* Content fields */
		editor.enhacedContentForm(document);

		/* Enumerated */
		// Return a helper with preserved width of cells
		var fixHelper = function(e, ui) {
			ui.children().each(function() {
				$(this).width($(this).width());
			});
			return ui;
		};

		$(".result_table.enumerated tbody").sortable({
			helper: fixHelper
		});


	},
	enhacedContentForm : function(context) {
		var $context = $(context);
		/* Sortable collection fields li:first-child */
		$context.find( ".collection" )
			.find( ".relatedContent" )
				.prepend("<span class='draggable'></span>").end()
			.sortable({
				items: "> .relatedContent",
				handle: "> .draggable"
			});

		/* Date fields */
		/* Polyfill */
		// 1990-12-31T23:59:60Z
		var inputElem = document.createElement("input");
		inputElem.setAttribute("type", "date");
		if(inputElem.type === "text") {
			$context.find("input[type=date]").datetimepicker({
				lang: "es",
				dayOfWeekStart: 1,
				timepicker: false,
				format: "Y-m-d",
				onShow:function( ct , $input){
					this.setOptions({
						minDate: false,
						maxDate: false
					});
					if ($input.hasClass("start")){
						var value = $input.siblings("input[type=date]").val();
						this.setOptions({
							maxDate: value ? Date.parseDate(value, "Y-m-d").dateFormat("Y/m/d") : false
						})
					}
					if ($input.hasClass("end")){
						var value = $input.siblings("input[type=date]").val();
						this.setOptions({
							minDate: value ? Date.parseDate(value, "Y-m-d").dateFormat("Y/m/d") : false
						})
					}
				}
			}
		)}
		inputElem.setAttribute("type", "datetime");
		if(inputElem.type === "text") {
			$context.find("input[type=datetime]").datetimepicker({
				lang: "es",
				step: 30,
				dayOfWeekStart: 1,
				format: "Y-m-dTH:i:00Z",
				onShow:function( ct , $input){
					this.setOptions({
						minDate: false,
						maxDate: false
					});
					if ($input.hasClass("start")){
						var value = $input.siblings("input[type=date]").val();
						this.setOptions({
							maxDate: value ? Date.parseDate(value, "Y-m-d").dateFormat("Y/m/d") : false
						})
					}
					if ($input.hasClass("end")){
						var value = $input.siblings("input[type=date]").val();
						this.setOptions({
							minDate: value ? Date.parseDate(value, "Y-m-d").dateFormat("Y/m/d") : false
						})
					}
				}
			});
		}

		/* Textarea WYSIWYG  */
		$context.find(".richtext").each( function() {
			var richEditor = CKEDITOR.replace(this);
			// contentDom fires each time the editing area is (re)created
			richEditor.on("contentDom", function() {
				theme.applyToRichEditor(richEditor);
			});
		});

		/* Tags */
		$context.find(".tags")
			.filter(function() {
				var options = {};

				if(typeof $(this).attr("readonly") !== "undefined") {
					options.readOnly = true;
				}
				if(typeof $(this).attr("list") !== "undefined") {
					var idList = $(this).attr("list");
					var autocompleteList = $("#"+idList + " option")
						.map(function(){
							return $(this).attr("value");
						}).get();
					//options.autocomplete: { source: true };
					options.availableTags = autocompleteList;
				}

				$(this).tagit(options);

				var sortableTags = $context.find(".tags.sortable");
				$(sortableTags).siblings(".tagit").sortable({
					stop: function(event,ui) {
						$(sortableTags).val(
							$context.find(".tagit-label",$(this))
								.clone()
								.text(function(index,text){ return (index == 0) ? text : "," + text; })
								.text()
						);
					}
				});
			});

		/* File upload, local preview of the selected image */
		$context.find("input.field.file").on("change", filePreview.update);
		$context.find(".type-file input[type=checkbox][name$='[delete]']").on("change", function() {
			filePreview.refresh($(this).closest(".fgrp"));
		});

		/* Range, show the current value */
		$context.find("input.rangeInput").on("input change", function() {
			$(this).siblings(".rangeValue").text(this.value);
		});

		/* Alias Id. */
		//$(".aliasId").aliasIdFormat();
		$context.find("input[type=text]").aliasIdFormat();

		/* Color rgb / rgba. */
		$context.find("input.colorrgba").colorValue();
		$context.find("input.colorrgb").colorValue();

		/* Select simple and multiple */
		$context.find('.field.select option[value=""]').html(""); // Resolve bug of selectivity for empty options
		$context.find('.field.select').selectivity({
			allowClear: true,
			placeholder: "Selecciona una opción…"
		});

		/* Related content */
		$context.find(".relatedContent .button.edit")
			.each(function () {
				$(this)
					.data("status", "empty");

				$(this)
					.parent()
					.append("<div class='wrapChildContent hidden'></div>");
			})
			.on("click", function(e) {
				var $edit = $(this);
				var $wrapContent = $edit.siblings(".wrapChildContent");

				switch ($edit.data("status")) {
					case "empty":
						/* Load and fill gap */
						var url = $edit.attr("href");
						$wrapContent
							.removeClass("hidden")
							.html("<p class='result'>Cargando…</p>");
						$.get( url, {"v" : "ajax"})
							.done(function(data) {
								/* Get inner form and insert in gap */
								var $contentFields = $(data)
									.find(".inner-form");
								$contentFields.find(".wrap-actions").remove();
								$wrapContent
									.html($contentFields);
								editor.enhacedContentForm($wrapContent.get(0));
								$edit.data("status", "fill-visible");
							});

						break;
					case "fill-visible":
						$wrapContent.addClass("hidden");
						$edit.data("status", "fill-hidden");
						break;
					case "fill-hidden":
						$wrapContent.removeClass("hidden");
						$edit.data("status", "fill-visible");
						break;
				}

				e.preventDefault();
			});

			/* Delete multiple related content */
			$context.find(".relatedContent .button.clear")
				.on("click", function (e) {
					var $wrapper = $(this).closest(".relatedContent");
					var $iData = $wrapper.find("input[type=hidden]");
					if ($(this).hasClass("checked")) {
						$iData.prop({ disabled: false });
						$wrapper.removeClass("removable");
						$(this).removeClass("checked");
					}
					else {
						$iData.prop({ disabled: true });
						$wrapper.addClass("removable");
						$(this).addClass("checked");
					}
					e.preventDefault();
				});

	},
	markBusyOnSave : function() {
		// The button is not disabled: its name/value must travel in the request
		$("form").on("submit", function(e) {
			var submitter = e.originalEvent && e.originalEvent.submitter;
			if (submitter && $(submitter).is(".btn.publish") && !e.isDefaultPrevented()) {
				$(submitter)
					.addClass("is-busy")
					.html("<span class='spin'></span> Guardando…");
			}
		});
	},
	confirmDelete : function(e) {
		var bDelete = window.confirm("¿Eliminar este elemento de forma permanente?");
		if(!bDelete) {
			e.preventDefault();
		}
	}
};
var navigationHistory = {
	LONG_CLICK_TIME : 500,
	backButtomTimeStamp : 0,
	timeoutShow : 0,
	$wrap : null,
	$historyMenu : null,
	status : '',
	init : function() {
		$("#header-menu .back").on("mousedown mouseup click", navigationHistory.backButtom);
		navigationHistory.status = 'hidden';
	},
	backButtom : function(e) {
		if (navigationHistory.$wrap === null) {
			navigationHistory.$wrap = $(this).parent();
		}
		switch (e.type) {
			case 'mousedown' :
				navigationHistory.backButtomTimeStamp = e.timeStamp;
				navigationHistory.timeoutShow = window.setTimeout(navigationHistory.showHistory, navigationHistory.LONG_CLICK_TIME);
				break;
			case 'mouseup' :
				if(e.timeStamp - navigationHistory.backButtomTimeStamp > navigationHistory.LONG_CLICK_TIME) {
					window.clearTimeout(navigationHistory.timeoutShow);
				}
				break;
			case 'click' :
				if(e.timeStamp - navigationHistory.backButtomTimeStamp > navigationHistory.LONG_CLICK_TIME) {
					e.preventDefault();
				}
				window.clearTimeout(navigationHistory.timeoutShow);
				break;
		}
	},
	showHistory : function() {
		if (navigationHistory.$historyMenu === null) {
			navigationHistory.$historyMenu = $(document.createElement("div"));
			navigationHistory.$historyMenu.attr("id", "historyMenu");
			navigationHistory.$wrap.append(navigationHistory.$historyMenu);
			$.get( "history.php", function( data ) {
				navigationHistory.$historyMenu.html(data);
			});
		}
		navigationHistory.status = "loading";
		navigationHistory.$historyMenu.attr("class", navigationHistory.status);
		$("body").on("click", navigationHistory.hideHistory);
	},
	hideHistory : function(e) {
		switch (navigationHistory.status) {
			case "loading":
				navigationHistory.status = "visible";
				break;
			case "visible":
				navigationHistory.status = "hidden";
				$("body").off("click", navigationHistory.hideHistory);
				break;
		}
		navigationHistory.$historyMenu.attr("class", navigationHistory.status);
	}
}
// The colour scheme follows the operating system / browser preference (prefers-color-scheme)
var theme = {
	RICH_EDITOR_DARK_CLASS : "acd-dark",
	darkPreference : window.matchMedia ? window.matchMedia("(prefers-color-scheme: dark)") : null,
	init : function() {
		if (window.CKEDITOR) {
			CKEDITOR.addCss(
				"body.acd-dark { background: #111827; color: #e7ecf6; }" +
				"body.acd-dark a { color: #9db8ff; }"
			);
		}
		if (!theme.darkPreference) {
			return;
		}
		if (theme.darkPreference.addEventListener) {
			theme.darkPreference.addEventListener("change", theme.applyToAllRichEditors);
		}
		else {
			// Safari < 14
			theme.darkPreference.addListener(theme.applyToAllRichEditors);
		}
	},
	isDark : function() {
		return theme.darkPreference !== null && theme.darkPreference.matches;
	},
	applyToAllRichEditors : function() {
		if (window.CKEDITOR) {
			$.each(CKEDITOR.instances, function(instanceName, richEditor) {
				theme.applyToRichEditor(richEditor);
			});
		}
	},
	// The editing area of the rich text editor is an iframe: page styles do not reach it
	applyToRichEditor : function(richEditor) {
		if (!richEditor.document) {
			return;
		}
		var body = richEditor.document.getBody();
		if (theme.isDark()) {
			body.addClass(theme.RICH_EDITOR_DARK_CLASS);
		}
		else {
			body.removeClass(theme.RICH_EDITOR_DARK_CLASS);
		}
	}
};
var toast = {
	VISIBLE_TIME : 4000,
	HIDE_TRANSITION_TIME : 300,
	init : function() {
		var $toast = $(".result.ok");
		if ($toast.length === 0) {
			return;
		}
		$toast.attr("role", "status");
		window.setTimeout(function() {
			$toast.addClass("is-hiding");
			window.setTimeout(function() { $toast.remove(); }, toast.HIDE_TRANSITION_TIME);
		}, toast.VISIBLE_TIME);
	}
};
var filePreview = {
	update : function() {
		var input = this;
		var file = input.files && input.files[0];

		filePreview.clear(input);

		if (file) {
			var $preview = filePreview.build(input, file);
			$(input).data("previewElement", $preview).before($preview);
		}
		filePreview.refresh($(input).closest(".fgrp"));
	},
	build : function(input, file) {
		var $preview = $("<div class='file-preview local'></div>");
		if (file.type.indexOf("image/") === 0) {
			var objectUrl = URL.createObjectURL(file);
			$(input).data("previewUrl", objectUrl);
			$preview.append(
				$("<img class='field preview'/>")
					.attr({ src: objectUrl, alt: "Vista previa, " + file.name }),
				" "
			);
		}
		$preview.append(document.createTextNode(file.name), " ",
			$("<span class='size'></span>").text(filePreview.humanSize(file.size)));
		return $preview;
	},
	/* The saved file is hidden when it is going to be deleted or replaced */
	refresh : function($field) {
		var isMarkedToDelete = $field.find("input[type=checkbox][name$='[delete]']").prop("checked");
		var hasNewFile = $field.find(".file-preview.local").length > 0;
		$field.find(".file-preview").not(".local")
			.toggleClass("hidden", isMarkedToDelete || hasNewFile);
	},
	clear : function(input) {
		var previousUrl = $(input).data("previewUrl");
		if (previousUrl) {
			URL.revokeObjectURL(previousUrl);
		}
		var $previous = $(input).data("previewElement");
		if ($previous) {
			$previous.remove();
		}
		$(input).removeData("previewUrl previewElement");
	},
	humanSize : function(size) {
		if (size >= 1 << 30) {
			return (size / (1 << 30)).toFixed(2) + "GB";
		}
		if (size >= 1 << 20) {
			return (size / (1 << 20)).toFixed(2) + "MB";
		}
		if (size >= 1 << 10) {
			return (size / (1 << 10)).toFixed(2) + "KB";
		}
		return size + " bytes";
	}
};
var isSupported = document.getElementById && document.getElementsByTagName;
if (isSupported) {
	document.documentElement.classList.add("js");
}
$(document).ready(editor.init);
