class MemoryLeakController < UIViewController
  DidDeallocNotification = 'DidDeallocNotification'

  stylesheet :memory_leak

  layout do
    puts("=============== memory_leak_controller.rb line #{__LINE__} ===============")
    subview(UIView, :view) do
      puts("=============== memory_leak_controller.rb line #{__LINE__} ===============")
      subview(UIView)
    end
  end

  def dealloc
    NSNotificationCenter.defaultCenter.postNotificationName(DidDeallocNotification, object:self)
    super
  end

end


Teacup::Stylesheet.new :memory_leak do

  style :view,
    frame: [[10, 10], [100, 100]],
    backgroundColor: UIColor.whiteColor

end
