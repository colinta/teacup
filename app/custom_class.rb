Teacup::Stylesheet.new :custom do
  style :container,
    frame: [[0, 0], [100, 20]]

  style :label,
    text: 'custom label',
    frame: [[0, 0], [100, 20]]
end

class CustomTeacupClass
  include Teacup::Layout

  def initialize
    self.stylesheet = :custom
  end

  def create_container
    layout(UIView, :container) do
      subview(UILabel, :label)
    end
  end
end
