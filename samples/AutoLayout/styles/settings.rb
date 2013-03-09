Teacup::Stylesheet.new :settings do
  import :base

  v_padding = 10

  style :label, extends: :custom_label,
    constraints: [
      :full_width,
      constrain_top(150)
    ],
    backgroundColor: :clear

end
