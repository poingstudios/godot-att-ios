# MIT License
#
# Copyright (c) 2026-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Control

@onready var _output: RichTextLabel = %Output
@onready var _margin_container: MarginContainer = %MarginContainer


func _ready() -> void:
	_update_safe_area()
	get_viewport().size_changed.connect(_update_safe_area)

	_output.text = "[b]Ready.[/b]\n"
	if Engine.has_singleton("ATT"):
		_output.text += "[color=#4ade80]✓ Native ATT plugin is active.[/color]\n"
	else:
		_output.text += "[color=#f87171]✗ Native ATT plugin NOT loaded![/color]\n"
	_output.text += (
		"[color=#94a3b8]Statuses: 0=NOT_DETERMINED, 1=RESTRICTED, 2=DENIED, 3=AUTHORIZED[/color]\n\n"
	)

	ATT.request_tracking_authorization_complete.connect(
		_on_att_request_tracking_authorization_complete
	)


func _on_att_request_tracking_authorization_complete(status: int) -> void:
	_output.text += (
		"[color=#4ade80]✓ Tracking Request Complete:[/color] %s\n" % _status_to_string(status)
	)


func _on_request_tracking_authorization_pressed() -> void:
	_output.text += "[color=#38bdf8]▶ Requesting Tracking Authorization...[/color]\n"
	ATT.request_tracking_authorization()


func _on_get_tracking_authorization_status_pressed() -> void:
	var status := ATT.get_tracking_authorization_status()
	_output.text += "[color=#facc15]ℹ Current Status:[/color] %s\n" % _status_to_string(status)


func _status_to_string(status: int) -> String:
	match status:
		ATT.Status.NOT_DETERMINED:
			return "NOT_DETERMINED (%d)" % status
		ATT.Status.RESTRICTED:
			return "RESTRICTED (%d)" % status
		ATT.Status.DENIED:
			return "DENIED (%d)" % status
		ATT.Status.AUTHORIZED:
			return "AUTHORIZED (%d)" % status
		_:
			return "UNKNOWN (%d)" % status


func _update_safe_area() -> void:
	var safe_area := DisplayServer.get_display_safe_area()
	var window_size := DisplayServer.window_get_size()
	if window_size.x == 0 or window_size.y == 0:
		return

	var viewport_size := Vector2(get_viewport().get_visible_rect().size)
	var scale_factor: float = viewport_size.y / float(window_size.y)
	if is_nan(scale_factor) or is_inf(scale_factor) or scale_factor <= 0.0:
		scale_factor = 1.0

	var top_margin: float = maxf(120.0, float(safe_area.position.y) * scale_factor)
	var bottom_margin: float = maxf(
		40.0, float(window_size.y - (safe_area.position.y + safe_area.size.y)) * scale_factor
	)
	var left_margin: float = maxf(32.0, float(safe_area.position.x) * scale_factor)
	var right_margin: float = maxf(
		32.0, float(window_size.x - (safe_area.position.x + safe_area.size.x)) * scale_factor
	)

	_margin_container.add_theme_constant_override("margin_top", int(top_margin))
	_margin_container.add_theme_constant_override("margin_bottom", int(bottom_margin))
	_margin_container.add_theme_constant_override("margin_left", int(left_margin))
	_margin_container.add_theme_constant_override("margin_right", int(right_margin))
