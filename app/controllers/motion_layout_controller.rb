class MotionLayoutController < UIViewController
  attr :label1
  attr :label2
  attr :label3

  layout :root do
    @label1 = subview(UILabel, :label1, text: 'label1')
    @label2 = subview(UILabel, :label2, text: 'label2')
    @label3 = subview(UILabel, :label3, text: 'label3')
  end

  def layoutDidLoad
    auto do
      metrics "margin" => 20, "top" => 100
      horizontal '|-margin-[label1]-margin-[label2(==label1)]-margin-|'
      horizontal '|-margin-[label3]-margin-|'
      vertical '|-top-[label1]'
      vertical '|-220-[label3(==label1)]'
    end
  end

end
