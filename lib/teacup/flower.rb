class Flower

  class StretchableViews
    attr_reader :num_stretchable
    def initialize(stretchable_query)
      @stretchable_query = stretchable_query
      reset
    end

    def push(view)
      @num_stretchable += 1 if view.send(@stretchable_query)
      @views.push(view)
    end

    def to_a
      @views
    end

    def reset
      @views = []
      @num_stretchable = 0
    end
  end

  def initialize(views, container_size)
    @views = views
    @container_size = container_size
  end

  def distribute_horz_remainder(stretchable_views, remaining_width)
    debug "remaining_width = #{remaining_width}, stretchable_views = #{stretchable_views.inspect}"
    return if remaining_width == 0.0
    return if stretchable_views.to_a.empty?

    width_per_stretchable_view = remaining_width / stretchable_views.num_stretchable
    added_width_so_far = 0.0
    debug "width_per_stretchable_view = #{width_per_stretchable_view}"
    stretchable_views.to_a.each do |view|
      debug "for view #{view.inspect}"
      if view.horz_stretchable?
        frame = view.frame
        frame.origin.x += added_width_so_far
        if width_per_stretchable_view + frame.size.width > view.max_width
          added_width = width_per_stretchable_view + frame.size.width - view.max_width
          debug "added width goes beyond max width"
        else
          added_width = width_per_stretchable_view
        end
        debug "added_width = #{added_width}"
        frame.size.width += added_width
        view.frame = frame
        added_width_so_far += added_width
        width_per_stretchable_view -= added_width
      end
    end
  end

  def flow
    debug("")
    x = 0; y = 0
    max_height = 0
    @horz_stretch_views = StretchableViews.new(:horz_stretchable?)
    @vert_stretch_views = StretchableViews.new(:vert_stretchable?)

    @views.each do |view|
      debug "view size = [[#{view.min_width},#{view.max_width}],[#{view.min_height}, #{view.max_height}]], margins = #{view.margins.inspect}"
      debug "max_height = #{max_height}, margin_top = #{view.margin_top}"
      debug "before, x = #{x}, y = #{y}"
      if view.position == :relative
        @horz_stretch_views.push(view) if view.horz_stretchable?
        new_line = false
        if  (view.display == :block) ||
            (x + view.margin_left + view.min_width + 
             view.margin_right > @container_size.width)
          distribute_horz_remainder(@horz_stretch_views, @container_size.width - x)
          x = view.margin_left
          y += max_height + view.margin_top 
          max_height = 0
          #@horz_stretch_views.reset
        else
            x += view.margin_left
        end
          
        debug "after, x = #{x}, y = #{y}"
        view.frame = [[x,y], [view.min_width, view.min_height]]

        x += view.min_width + view.margin_right

        # don't include top margin because y is already includes top margin
        total_height = view.min_height + view.margin_bottom
        debug "total_height = #{total_height}, min_height = #{view.min_height}"
        max_height = total_height if total_height > max_height
      end
    end

    distribute_horz_remainder(@horz_stretch_views, @container_size.width - x)
  end
end
