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

class_name ATT


enum Status {
	NOT_DETERMINED = 0,
	RESTRICTED = 1,
	DENIED = 2,
	AUTHORIZED = 3,
}

class _SignalDispatcher:
	extends RefCounted
	signal request_tracking_authorization_complete(status: Status)


static var _dispatcher := _SignalDispatcher.new()
static var request_tracking_authorization_complete: Signal = (
	_dispatcher.request_tracking_authorization_complete
)

static var _plugin: Object = _get_plugin()


static func _get_plugin() -> Object:
	if Engine.has_singleton("ATT"):
		var plugin := Engine.get_singleton("ATT")
		if plugin and not plugin.is_connected(
			"request_tracking_authorization_complete",
			_on_native_request_complete
		):
			plugin.connect("request_tracking_authorization_complete", _on_native_request_complete)
		return plugin
	return null


static func _on_native_request_complete(status: int) -> void:
	_dispatcher.request_tracking_authorization_complete.emit(status as Status)


static func request_tracking_authorization(
	on_complete := func(_status: Status) -> void: pass
) -> void:
	if _plugin == null:
		_plugin = _get_plugin()

	if _plugin:
		if on_complete.is_valid():
			var callback_wrapper: Callable
			callback_wrapper = func(status: int) -> void:
				if _plugin.is_connected("request_tracking_authorization_complete", callback_wrapper):
					_plugin.disconnect("request_tracking_authorization_complete", callback_wrapper)
				on_complete.call(status as Status)
			_plugin.connect("request_tracking_authorization_complete", callback_wrapper)

		_plugin.request_tracking_authorization()
	else:
		if OS.get_name() == "iOS":
			printerr("[ATT] Native plugin 'ATT' not found. Make sure it is enabled in export preset.")
		else:
			push_warning("[ATT] Native plugin 'ATT' is only supported on iOS.")

		_dispatcher.request_tracking_authorization_complete.emit.call_deferred(
			Status.NOT_DETERMINED
		)
		if on_complete.is_valid():
			on_complete.call_deferred(Status.NOT_DETERMINED)


static func get_tracking_authorization_status() -> Status:
	if _plugin == null:
		_plugin = _get_plugin()

	if _plugin:
		return _plugin.get_tracking_authorization_status() as Status
	return Status.NOT_DETERMINED


static func get_singleton() -> Object:
	if _plugin == null:
		_plugin = _get_plugin()
	return _plugin
