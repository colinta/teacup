class CustomAppearanceController < UIViewController
  attr :label_1
  attr :container
  attr :label_2

  def teacup_layout
    @label_1 = subview(CustomAppearanceLabel)
    @container = subview(CustomAppearanceContainer) do
      @label_2 = subview(CustomAppearanceLabel)
    end
  end

end
