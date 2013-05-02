module Teacup
  module_function

  # Returns all the subviews of `target` that have a stylename.  `target` is not
  # included in the list.  Used by the motion-layout integration in layout.rb.
  def get_styled_subviews(target)
    retval = target.subviews.select { |v| v.stylename }
    retval.concat(target.subviews.map do |subview|
      get_styled_subviews(subview)
    end)
    retval.flatten
  end

end
