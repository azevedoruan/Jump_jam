extends Node
class_name IAPManager

signal unlock_new_skin

var google_payments = null

func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payments = Engine.get_singleton("GodotGooglePlayBilling")
		MyUtility.add_log_message("Android IAP support is enabled")
	else:
		MyUtility.add_log_message("Android IAP support is not available")

func purchase_skin() -> void:
	unlock_new_skin.emit()
