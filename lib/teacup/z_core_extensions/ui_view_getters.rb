# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $().find('stylename')
class UIView

  # get one stylesheet by stylename
  # my_view[:button] :button => #<UIButton..>
  def [] name
    if name.is_a? Fixnum
      return self.subviews[name]
    end

    r = []
    subviews.each do |view|
      if view.stylename == name
        return view
      end
    end
    subviews.each do |view|
      if v = view[name]
        return v
      end
    end
    nil
  end

  # get stylesheets by stylename
  # my_view.all :button => [#<UIButton..>, #<UIButton...>]
  def viewsWithStylename name
    r = []
    subviews.each do |view|
      if view.stylename == name
        r.push name
      end
    end
    r
  end

end