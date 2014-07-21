class MainWindowController < TeacupWindowController

  def teacup_layout
    @table_view_controller = MainTableController.new

    subview(@table_view_controller.view,
      frame: [[10, 10], [460, 340]],
      autoresizingMask: NSViewWidthSizable | NSViewHeightSizable,
      )
  end

end
