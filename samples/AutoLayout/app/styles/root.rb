Teacup::Stylesheet.new :root do
  import :base

  v_padding = 10

  style :label, extends: :custom_label,
    constraints: [
      :full_width,
      constrain_top(50)
    ],
    backgroundColor: UIColor.clearColor

  style :button, extends: :custom_button,
    constraints: [
      constrain_below(:label).plus(v_padding),
      # Position at half of middle (q1)
      constrain(:center_x).equals(:superview, :center_x).times(0.5),
      constrain(:left).equals(:superview, :left).plus(10)
    ]

  style :switch, extends: :custom_switch,
    constraints: [
      constrain_below(:label).plus(v_padding * 2),
      # Position at Middle + half (75%)
      constrain(:center_x).equals(:superview, :center_x).times(1.5)
    ]
    
end

