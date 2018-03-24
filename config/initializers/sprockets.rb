Rails.application.config.assets.register_postprocessor 'application/javascript', :close_over_app_javascripts do |context, data|
  if context.pathname.to_s.starts_with?(Rails.root.join('app/assets/javascripts').to_s)
    "(function () {\n'use strict';\n#{data}\n}).call(this);"
  else
    data
  end
end
