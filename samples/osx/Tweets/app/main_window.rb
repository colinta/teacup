class MainController < TeacupWindowController
  stylesheet :main_window

  layout do
    @text_search = subview(NSTextField, :text_search,
      stringValue: 'xcode crash'
      )

    subview(NSButton, :search_button,
      action: 'search:',
      target: self,
      )

    scroll_view = subview(NSScrollView, :scroll_view)

    @table_view = subview(NSTableView, :table_view,
      delegate: self,
      dataSource: self,
      )

    column_avatar = NSTableColumn.alloc.initWithIdentifier("avatar")
    column_avatar.editable = false
    column_avatar.headerCell.setTitle("Avator")
    column_avatar.setWidth(40)
    column_avatar.setDataCell(NSImageCell.alloc.init)
    @table_view.addTableColumn(column_avatar)

    column_name = NSTableColumn.alloc.initWithIdentifier("name")
    column_name.editable = false
    column_name.headerCell.setTitle("Name")
    column_name.setWidth(150)
    @table_view.addTableColumn(column_name)

    column_tweet = NSTableColumn.alloc.initWithIdentifier("tweet")
    column_tweet.editable = false
    column_tweet.headerCell.setTitle("Tweet")
    column_tweet.setWidth(290)
    @table_view.addTableColumn(column_tweet)

    scroll_view.setDocumentView(@table_view)
  end


  def search(sender)
    text = @text_search.stringValue
    if text.length > 0
      query = text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
      url = "http://search.twitter.com/search.json?q=#{query}"

      Dispatch::Queue.concurrent.async do
        json = nil
        begin
          json = JSONParser.parse_from_url(url)
        rescue RuntimeError => e
          presentError e.message
        end

        @search_result = []
        json['results'].each do |dict|
          tweet = Tweet.new(dict)
          @search_result << tweet

          Dispatch::Queue.concurrent.async do
            profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(tweet.profile_image_url))
            if profile_image_data
              tweet.profile_image = NSImage.alloc.initWithData(profile_image_data)
              Dispatch::Queue.main.sync do
                @table_view.reloadData
              end
            end
          end
        end

        Dispatch::Queue.main.sync { @table_view.reloadData }
      end

    end
  end

  def numberOfRowsInTableView(aTableView)
    return 0 if @search_result.nil?
    return @search_result.size
  end

  def tableView(aTableView,
                objectValueForTableColumn: aTableColumn,
                row: rowIndex)
    case aTableColumn.identifier
    when "avatar"
      return @search_result[rowIndex].profile_image
    when "name"
      return @search_result[rowIndex].author
    when "tweet"
      return @search_result[rowIndex].message
    end
  end


end