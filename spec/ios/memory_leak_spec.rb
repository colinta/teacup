class LeakDetector

  def initialize
    @did_dealloc = false
  end

  def did_dealloc(notification)
    @did_dealloc = true
  end

  def did_dealloc?
    @did_dealloc
  end

end

describe "Memory leaks" do
  tests MemoryLeakController

  def controller
    unless @controller
      root = UIViewController.new
      @controller = UINavigationController.alloc.initWithRootViewController(root)
    end

    @controller
  end

  it "should dealloc after being popped from UINavigationController" do
    detector = LeakDetector.new

    memory_leak = MemoryLeakController.new

    NSNotificationCenter.defaultCenter.addObserver(detector,
            selector: :'did_dealloc:',
            name: MemoryLeakController::DidDeallocNotification,
            object: memory_leak)

    self.controller.pushViewController(memory_leak, animated: false)
    memory_leak = nil

    wait 1 do
      self.controller.popViewControllerAnimated(false)

      wait 1 do
        detector.did_dealloc?.should == true
      end
    end
  end

end
