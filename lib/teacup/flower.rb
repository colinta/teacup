class Flower

  class StretchableViews
    attr_reader :num_stretchable
    def initialize(stretchable_query)
      @stretchable_query = stretchable_query
      reset
    end

    def push(view)
      if view.send(@stretchable_query)
        @num_stretchable += 1 
      end
      @views.push(view) if @num_stretchable > 0
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
      else
        frame = view.frame
        frame.origin.x += added_width_so_far
        view.frame = frame
      end
    end
  end

  def distribute_vert_remainder(stretchable_views, remaining_height)
    debug "remaining_height = #{remaining_height}, stretchable_views = #{stretchable_views.inspect}"
    return if remaining_height == 0.0
    return if stretchable_views.to_a.empty?

    height_per_stretchable_view = remaining_height / stretchable_views.num_stretchable
    added_height_so_far = 0.0
    debug "height_per_stretchable_view = #{height_per_stretchable_view}"
    stretchable_views.to_a.each do |view|
      debug "for view #{view.inspect}"
      if view.vert_stretchable?
        frame = view.frame
        frame.origin.y += added_height_so_far
        if height_per_stretchable_view + frame.size.height > view.max_height
          added_height = height_per_stretchable_view + frame.size.height - view.max_height
          debug "added height goes beyond max height"
        else
          added_height = height_per_stretchable_view
        end
        debug "added_height = #{added_height}"
        frame.size.height += added_height
        view.frame = frame
        added_height_so_far += added_height
        height_per_stretchable_view -= added_height
      else
        frame = view.frame
        frame.origin.y += added_height_so_far
        view.frame = frame
      end
    end
  end

  def flow
    debug("")
    debug("ENTER flow container size = #{@container_size.inspect}")
    x = 0; y = 0
    max_height = 0
    @horz_stretch_views = StretchableViews.new(:horz_stretchable?)
    @vert_stretch_views = StretchableViews.new(:vert_stretchable?)

    @views.each_with_index do |view, index|
      debug "view size = [[#{view.min_width},#{view.max_width}],[#{view.min_height}, #{view.max_height}]], margins = #{view.margins.inspect}"
      debug "max_height = #{max_height}, margin_top = #{view.margin_top}"
      debug "before, x = #{x}, y = #{y}"
      if view.position == :relative
        @vert_stretch_views.push(view)

        new_line = false
        left_over_width = @container_size.width - (view.margin_left + view.min_width + view.margin_right)
        if index == 0
          @horz_stretch_views.push(view)
          left_over_width = @container_size.width - (view.margin_left + view.min_width + view.margin_right)
          x = view.margin_left
          y = view.margin_top
        elsif  (view.display == :block) ||
            (x + view.margin_left + view.min_width + 
             view.margin_right > @container_size.width)
          left_over_width = @container_size.width - x
          x = view.margin_left
          y += max_height + view.margin_top 
          max_height = 0
          new_line = true
        else
          @horz_stretch_views.push(view)
          x += view.margin_left
        end
          
        debug "after, x = #{x}, y = #{y}"
        view.frame = [[x,y], [view.min_width, view.min_height]]

        if new_line || index == @views.size - 1
          distribute_horz_remainder(@horz_stretch_views, left_over_width)
          @horz_stretch_views.reset
          if new_line
            @horz_stretch_views.push(view)
          end
        end

        x += view.min_width + view.margin_right

        # don't include top margin because y is already includes top margin
        total_height = view.min_height + view.margin_bottom
        debug "total_height = #{total_height}, min_height = #{view.min_height}"
        max_height = total_height if total_height > max_height
      end

      # if this is the last view, then adjust y for exit
      if index == @views.size - 1
        y += max_height
      end
    end

    #distribute_horz_remainder(@horz_stretch_views, @container_size.width - x)
    distribute_vert_remainder(@vert_stretch_views, @container_size.height - y)
    debug("EXIT flow")
  end
end
