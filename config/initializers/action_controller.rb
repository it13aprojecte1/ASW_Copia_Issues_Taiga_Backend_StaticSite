# Configurar Rails para que no lance errores cuando faltan acciones en los callbacks
Rails.application.config.action_controller.raise_on_missing_callback_actions = false
