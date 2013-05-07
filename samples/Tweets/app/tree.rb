$sugarcube_view = nil
$sugarcube_items = nil
$sugarcube_restore = nil

module SugarCube
  module Adjust
    module_function

    def repl_format(format=nil)
      if format
        @@repl_format = format
      else
        # if adjust has not been called, the instance variable has not yet been set
        @@repl_format ||= :ruby
      end
      @@repl_format
    end

    def adjust(view=nil, format=nil)
      SugarCube::Adjust::repl_format(format.to_sym) if format
      return $sugarcube_view if not view

      if view.is_a? Fixnum
        window = NSApplication.sharedApplication.keyWindow
        window ||= NSApplication.sharedApplication.mainWindow
        window ||= NSApplication.sharedApplication.windows[0]
        $sugarcube_items ||= SugarCube::Adjust::build_tree(window, :subviews)
        view = $sugarcube_items[view]
      end

      # a/adjust will return this object
      $sugarcube_view = view

      if view.is_a?(NSView)
        $sugarcube_restore = {
          frame: SugarCube::Adjust.frame,
        }

        if format
          puts format_frame view.frame
        end
      end

      view
    end
    alias a adjust

    ##|  FRAME
    def frame f=nil
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      return $sugarcube_view.frame if not f

      f = SugarCube::CoreGraphics::Rect(f)
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias f frame

    ##|  ORIGIN
    def left val=1
      SugarCube::Adjust::right -val
    end
    alias l left

    def right val=1
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      f.origin.x += val
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias r right

    def up val=1
      SugarCube::Adjust::down -val
    end
    alias u up

    def down val=1
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      f.origin.y += val
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias d down

    def origin x=nil, y=nil
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      return f.origin if not x

      if y
        f.origin.x = x
        f.origin.y = y
      else
        f.origin = SugarCube::CoreGraphics::Point(x)
      end
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias o origin

    ##|  SIZE
    def thinner val=1
      SugarCube::Adjust::wider -val
    end
    alias n thinner

    def wider val=1
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      f.size.width += val
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias w wider

    def shorter val=1
      SugarCube::Adjust::taller -val
    end
    alias s shorter

    def taller val=1
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      f.size.height += val
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias t taller

    def size w=nil, h=nil
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      f = $sugarcube_view.frame
      return f.size if not w

      if h
        f.size.width = w
        f.size.height = h
      else
        f.size = SugarCube::CoreGraphics::Size(w)
      end
      $sugarcube_view.frame = f
      puts format_frame(f)

      $sugarcube_view
    end
    alias z size

    def center(*args)
      raise "no view has been assigned to SugarCube::Adjust::adjust" unless $sugarcube_view

      element = nil
      total = nil
      direction = 'h'
      args.each do |option|
        case option
        when String, Symbol  # accept string or symbol
          direction = option.to_s
        when Numeric
          if not total
            total = option
          elsif not element
            element = option
          else
            raise "I don't know what to do with #{option.inspect}"
          end
        else
          raise "I don't know what to do with #{option.inspect}"
        end
      end
      element = 1 unless element
      total = 1 unless total

      view = $sugarcube_view

      left = view.origin.x
      top = view.origin.y

      if /h|x/.match(direction.downcase)
        swidth = view.frame.width
        pwidth = view.superview.frame.width / total
        left = (pwidth - swidth) / 2 + pwidth * (element - 1)
      end
      if /v|y/.match(direction.downcase)
        sheight = view.frame.height
        pheight = view.superview.frame.height / total
        top = (pheight - sheight) / 2 + pheight * (element - 1)
      end

      self.origin left, top
    end
    alias c center

    # @param item this can be a tree-like item (UIView, UIViewController,
    #     CALayer) or an integer, in which case it will select that window from
    #     UIApplication.sharedApplication.window.  Defalt is to display the
    #     keyWindow
    # @param selector If you pass an unsupported object to tree, you will need
    #     to pass a selector as well - this method should return an array of
    #     items which are passed recursively to tree
    # @block sel_blk If a block is passed, it will be used to build the array of
    #     items that are called recursively
    def tree(item=nil, selector=nil, &sel_blk)
      if item.is_a?(Fixnum)
        item = NSApplication.sharedApplication.windows[item]
      elsif ! item
        item = NSApplication.sharedApplication.keyWindow || NSApplication.sharedApplication.mainWindow || NSApplication.sharedApplication.windows[0]
      end
      unless item
        puts 'View is nil (no window, view, or controller to display)'
        return
      end

      if sel_blk
        if selector
          raise "You can't hand me a block AND a selector.  I don't know what to do with them!"
        end
        if sel_blk.arity != 1
          raise "The block you passed should accept one and only one object"
        end
        selector = sel_blk
      elsif ! selector
        if item.is_a? NSView
          selector = :subviews
        elsif item.is_a? NSWindow
          item = item.contentView
          selector = :subviews
        elsif item.is_a? NSViewController
          selector = lambda { |ctlr|
                      ret = Array.new ctlr.childViewControllers
                      if ctlr.presentedViewController && ctlr.presentedViewController.presentingViewController == ctlr
                        ret << ctlr.presentedViewController
                      end
                      ret
                    }
        elsif item.is_a? CALayer
          selector = :sublayers
        else
          raise "Unable to determine a SugarCube::Adjust::tree selector for #{item.class.name}"
        end
      end

      $sugarcube_items = SugarCube::Adjust::build_tree(item, selector)
      if self.respond_to? :draw_tree
        draw_tree(item, selector)
      else
        SugarCube::Adjust::draw_tree(item, selector)
      end
      puts ''

      return item
    end

    # Draws the tree items
    def draw_tree(item, selector, tab=nil, is_last=true, items_index=0)
      space = ' '
      if items_index < 10
        print '  '
      elsif items_index < 100
        print ' '
      elsif items_index > 999  # good god, man!
        space = ''
      end
      print items_index.to_s + ":" + space

      if tab
        print tab
        if is_last
          print '`-- '
          tab += '    '
        else
          print '+-- '
          tab += '|   '
        end
      else
        print '. '
        tab = ''
      end

      if self == item || $sugarcube_view == item
        print "\033[1m"
      end
      if item.is_a? NSView
        puts "#{item} frame: [[#{item.frame.origin.x}, #{item.frame.origin.y}], [#{item.frame.size.width}, #{item.frame.size.height}]]"
      else
        puts item.to_s
      end
      if self == item || $sugarcube_view == item
        print "\033[0m"
      end

      if selector.is_a? Proc
        items = selector.call(item)
      else
        items = item.send(selector)
      end
      items ||= []

      items.each_with_index { |subview, index|
        items_index += 1
        if self.respond_to? :draw_tree
          items_index = draw_tree(subview, selector, tab, index == items.length - 1, items_index)
        else
          items_index = SugarCube::Adjust::draw_tree(subview, selector, tab, index == items.length - 1, items_index)
        end
      }

      return items_index
    end

    def build_tree(item, selector)
      if selector.is_a? Proc
        items = selector.call(item)
      else
        items = item.send(selector)
      end
      items ||= []

      ret = [item]
      items.each_with_index { |subview, index|
        ret.concat SugarCube::Adjust::build_tree(subview, selector)
      }
      ret
    end

    def root
      (NSApplication.sharedApplication.keyWindow || NSApplication.sharedApplication.windows[0]).windowController
    end

    ##|  RESTORE
    def restore
      raise 'no view has been assigned to SugarCube::Adjust::adjust' unless $sugarcube_view

      $sugarcube_restore.each do |msg, value|
        SugarCube::Adjust.send(msg, value)
      end
    end

    def format_frame(frame)
      case SugarCube::Adjust::repl_format
        when :json then
          "{x: #{frame.origin.x}, y: #{frame.origin.y}, width: #{frame.size.width}, height: #{frame.size.height}}"
        when :ruby then
          "[[#{frame.origin.x}, #{frame.origin.y}], [#{frame.size.width}, #{frame.size.height}]]"
        when :objc
          frame.to_s
        else
          raise "Unknown repl_format #{SugarCube::Adjust::repl_format.inspect}"
      end
    end
  end
end
