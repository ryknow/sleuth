# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$("button.browse-button").onclick (ev) -> $("#file-input").click()
$("label#filename").onclick (ev) -> $("file-input").click()
$("#file-input").onchange (ev) -> $("#filename").html $(ev.currentTarget).val()