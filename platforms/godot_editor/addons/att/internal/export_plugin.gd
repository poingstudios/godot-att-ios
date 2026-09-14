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

extends EditorExportPlugin

const PLUGIN_NAME := "ATT"
const USAGE_DESCRIPTION := "This identifier will be used to deliver personalized ads to you."


func _get_name() -> String:
	return PLUGIN_NAME


func _supports_platform(platform: EditorExportPlatform) -> bool:
	return platform is EditorExportPlatformIOS


func _export_begin(
	features: PackedStringArray,
	_is_debug: bool,
	_path: String,
	_flags: int
) -> void:
	if not features.has("ios"):
		return

	_add_framework("AppTrackingTransparency.framework")
	_add_plist_content(
		"<key>NSUserTrackingUsageDescription</key><string>%s</string>\n" % USAGE_DESCRIPTION
	)
	_add_linker_flags("-ObjC")


func _add_linker_flags(flags: String) -> void:
	if has_method("add_apple_embedded_platform_linker_flags"):
		call("add_apple_embedded_platform_linker_flags", flags)
	elif has_method("add_ios_linker_flags"):
		call("add_ios_linker_flags", flags)


func _add_framework(framework_name: String) -> void:
	if has_method("add_apple_embedded_platform_framework"):
		call("add_apple_embedded_platform_framework", framework_name)
	elif has_method("add_ios_framework"):
		call("add_ios_framework", framework_name)


func _add_plist_content(content: String) -> void:
	if has_method("add_apple_embedded_platform_plist_content"):
		call("add_apple_embedded_platform_plist_content", content)
	elif has_method("add_ios_plist_content"):
		call("add_ios_plist_content", content)

