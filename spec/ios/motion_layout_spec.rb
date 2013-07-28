describe "MotionLayout" do
  tests MotionLayoutController

  describe 'applied constraints' do
    it 'should have label1 on the left' do
      label1_left = CGRectGetMinX(controller.label1.frame)
      label1_left.should == 20
    end

    it 'should have label1 at the top' do
      label1_top = CGRectGetMinY(controller.label1.frame)
      label1_top.should == 100
    end

    it 'should have label2 at the top' do
      label2_top = CGRectGetMinY(controller.label2.frame)
      label2_top.should == 100
    end

    it 'should have margin between label1 and label2' do
      label1_right = CGRectGetMaxX(controller.label1.frame)
      label2_left = CGRectGetMinX(controller.label2.frame)
      (label2_left - label1_right).should == 20
    end

    it 'should have label2 and label3 on the right' do
      label2_right = CGRectGetMaxX(controller.label2.frame)
      label3_right = CGRectGetMaxX(controller.label3.frame)
      label3_right.should == label2_right
    end

    it 'should have label3 on the left' do
      label3_left = CGRectGetMinX(controller.label3.frame)
      label3_left.should == 20
    end

    it 'should have label3 at 220' do
      label3_top = CGRectGetMinY(controller.label3.frame)
      label3_top.should == 220
    end

    it 'should have label4 at 320' do
      frame = controller.container.label4.frame
      frame = controller.container.convertRect(frame, toView: controller.view)
      label4_top = CGRectGetMinY(frame)
      label4_top.should == 320
    end


  end

end
