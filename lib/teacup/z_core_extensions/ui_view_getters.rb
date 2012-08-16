# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $().find('stylename')
class UIView

  # get one stylesheet by stylename
  # my_view[:button] :button => #<UIButton..>
  def viewWithStylename name
    view = subviews.find {|view| view.stylename == name}
    return view if view

    # found_subview will get assigned to the view we want, but the subview is
    # what is returned.
    found_subview = nil
    view = subviews.find {|subview| found_subview = subview.viewWithStylename(name) }
    return found_subview if view

    nil  # couldn't find it
  end

  # get stylesheets by stylename
  # my_view.all :button => [#<UIButton..>, #<UIButton...>]
  def viewsWithStylename name
    r = []
    subviews.each do |view|
      if view.stylename == name
        r.push name
      end
      r += view.viewsWithStylename name
    end
    r
  end

end