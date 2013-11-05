Augury.Views.Messages.Show = Backbone.View.extend(
  events: ->
    'click nav li a': 'showSubView'

  render: ->
    @$el.html JST["admin/templates/messages/show"](model: @model)
    @showInitialSubView()
    SyntaxHighlighter.highlight()
    @

  showInitialSubView: ->
    switch @model.get('queue_name')
      when 'accepted' 
        @$el.find('#detail-view').html JST["admin/templates/messages/_payload"](model: @model), () ->
          SyntaxHighlighter.highlight()
      when 'archived'
        @$el.find('#detail-view').html JST["admin/templates/messages/_result"](model: @model), () ->
          SyntaxHighlighter.highlight()
      when 'incoming' 
        @$el.find('#detail-view').html JST["admin/templates/messages/_children"](model: @model)
    

  showSubView: (e) ->
    templateName = $(e.currentTarget).data('template')
    $(e.currentTarget).closest('nav').find('a.active').removeClass('active')
    $(e.currentTarget).addClass('active')    
    if templateName?
      @$el.find('#detail-view').html JST["admin/templates/messages/_#{templateName}"](model: @model)
      SyntaxHighlighter.highlight()
      if templateName == 'notifications'
        @$el.find('.message-section').find('td.actions a').on 'click', ->
          $(@).parent().parent().next().toggle()
          $(@).parent().parent().toggleClass('without-border')
)
