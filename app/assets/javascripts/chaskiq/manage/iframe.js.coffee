
#http://www.kryogenix.org/code/browser/custom-drag-image.html
#http://www.html5rocks.com/en/tutorials/dnd/basics/#toc-examples
class window.Iframe extends Backbone.View
  el: '#chaskiq-mail-editor'

  events: ->

    'drag .blocks li a' : 'drag'
    'drag .tpl-block-controls a' : 'drag'
    'dragstart .tpl-block-controls a': 'setDraggedEl'
    'dragend .tpl-block-controls a': 'removeDraggedEl'
    "dragleave #bodyTable" : "hideSections"
    "drop #bodyTable" : "hideSections"
    "dragover .tpl-block" : "displayItemOver"
    "dragover .chaskiqContainerEmptyMessage": "displayItemOver"

    'drop #templateBody': "drop"
    'drop #templatePreheader': "drop"
    'drop #templateHeader': "drop"
    'drop #templateBody': "drop"
    "drop #templateFooter" : "drop"

    "click .tpl-block": "setFocus"
    "click .imagePlaceholder .button-small" : "displayUploaderList"
    "click .tpl-block-delete": "deleteBloc"

    "click input.submit": "submitEditor"

  initialize: ->
    @editor = top.editor
    @textarea = $(@editor.el).find('#campaign_html_content')
    @css = $(@editor.el).find('#campaign_css')

  copyToTextArea: ()->
    $this = $("#mail-editor")
    window.setTimeout ()=>
      $(@editor.el).find('#campaign_html_content').val($this.html());
    , 0

  copyCssRulesToTextArea: ()->
    rules = _.map @style().cssRules , (rule)->
      rule.cssText
    $("#campaign_css").val(rules.join(" "))

  template: ->
    '<p>dsfsd</p>'

  render: ->
    #$(@el).find('#mail-editor').html(@template())
    $(@el).find('#mail-editor').html(@textarea.val()); #init from saved content
    #$(@el).find('#mail-editor').html(@baseTemplate()) #init from base js tamplarte
    #$("#tab-2").html(@baseStylesTemplate("accordeon", @definitionsForEditor()))

    #$('.colorpicker').colorpicker();

    @removeTplBlockControls() #for legacy already embeded tmp controls
    @addTplBlockControls()

  removeTplBlockControls: ->
    $(".tpl-block-controls").remove()

  addTplBlockControls: ->
    _.each $(".chaskiqBlock.tpl-block"), (n)=>
      $(n).append(@templateBlockControls())

  displaySections: (ev)->

    #console.log($(ev.currentTarget))
    #console.log($(ev.currentTarget).hasClass("tpl-container"))
    container = $(ev.currentTarget).parent(".tpl-container")

    #_.each $('.tpl-container'), (n)->
    #  return if $(n).find(".legend").length > 0
    #  #debugger
    #  #$(n).append("<div class='legend default'>#{$(n).attr("mc:container")}</div>")
    container.append("<div class='legend default'>#{$(container).attr("mc:container")}</div>")
    container.addClass("default")

    if container.hasClass("tpl-container")
      container.addClass("over").removeClass("default")
      container.find(".legend").addClass("over").removeClass("default")

    ev.preventDefault()

  setDraggedEl: (e)->
    @crt = $(e.currentTarget).parents(".tpl-block")[0].cloneNode(true) #.clone()
    @crt.style.backgroundColor = "white";
    @crt.style.position = "absolute";
    @crt.style.border = "1px solid #666";
    @crt.style.boxShadow = "1px 2px 2px #adadad"
    @crt.style.top = "0px";
    @crt.style.right = "0px";
    @crt.style.opacity = 0.9;
    @crt.style.zIndex = -9999;
    document.body.appendChild(@crt);
    e.dataTransfer = e.originalEvent.dataTransfer;
    e.dataTransfer.setDragImage(@crt, 0, 0);

  removeDraggedEl: ->
    $(@crt).remove()

  displayItemOver: (ev)->
    @displaySections(ev)

    $('.tpl-block').removeClass("chaskiqDndItemBefore")
    if $(ev.currentTarget).hasClass("tpl-block")
      $(ev.currentTarget).addClass("chaskiqDndItemBefore")

    ev.preventDefault()

  hideSections: ()->
    $('.tpl-container').removeClass("default").removeClass("over")
    _.each $('.tpl-container'), (n)->
      $(n).find(".legend").remove()

  drag: (ev)->
    #console.log(ev.currentTarget)
    @dragged = $(ev.currentTarget)

  allowDrop: (ev)->
    #console.log("allos drop")
    ev.preventDefault()

  displayEmptyBlocks: ->
    _.each $('.tpl-container'), (container)->
      empty_message = $(container).find('.chaskiqContainerEmptyMessage')
      if $(container).find(".tpl-block").length > 0
        empty_message.hide()
      else
        empty_message.show()

  drop: (ev)->
    ev.preventDefault()
    #console.log($(ev.dataTransfer.getData("text")))
    #console.log(@dragged.data('block'))
    console.log ev.target.id
    #data = $(ev.dataTransfer.getData("text"));
    #ev.target.appendChild(data);
    container = $(ev.currentTarget)
    
    if @editor.dragged && @editor.dragged.attr('data-block')
      tmpl = @editor.handleBlock @editor.dragged.data('block')
      @dropBlock(container, tmpl)
    else
      to_drop = @dragged.parents(".tpl-block")
      @dropBlock(container, to_drop)

    @copyToTextArea()

    @releaseBeforeItem()

    @displayEmptyBlocks()

    @editor.dragged = null
    @dragged = null

  dropBlock: (container, tmpl)->
    #drop on before item or in tpl-container
    if $(".tpl-block.chaskiqDndItemBefore").length > 0
      container.find(".tpl-block.chaskiqDndItemBefore").before(tmpl)
      container.find('.chaskiqContainerEmptyMessage').hide()
    else
      container.find(".tpl-container").append(tmpl)
      #container.find('.chaskiqContainerEmptyMessage').hide()

  releaseBeforeItem: ()->
    $(".tpl-block").removeClass("chaskiqDndItemBefore")

  currentFocused: ()->
    $(".tpl-block.focus")

  setFocus: (ev)->
    $(".tpl-block").removeClass("focus")
    $(ev.currentTarget).addClass("focus")
    @editor.displayWysiwyg()
    @editor.renderBlockDesignSettings()

    false

  deleteBloc: (ev)->
    target = $(ev.currentTarget)
    container = target.parents(".tpl-container")
    target.parents(".tpl-block").remove()

    if container.find(".tpl-block").length is 0
      container.find(".chaskiqContainerEmptyMessage").show()
    false

  
  emptyContainerMessage: ()->
    "<div class='chaskiqContainerEmptyMessage' style='display: block;'>Drop Content Blocks Here</div>"

  wrapBlock: (content)->
    "<div class='chaskiqBlock tpl-block chaskiqDndItem'>
      <div data-chaskiq-attach-point='containerNode'>
        #{content}
      </div>
      #{@templateBlockControls()}
    </div>"

  templateBlockControls: ->
    "<div class='tpl-block-controls'>
      <a data-chaskiq-attach-point='editBtn' class='tpl-block-edit' href='#' title='Edit Block'><i class='fa fa-arrows'></i></a>
      <a data-chaskiq-attach-point='deleteBtn' class='tpl-block-delete' href='#' title='Delete Block'><i class='fa fa-trash'></i></a>
    </div>"
  
  displayUploaderList: (ev)->
    placeholder = $(ev.currentTarget).parents('.imagePlaceholder')
    @editor.checkExistentImages(placeholder)
    false

  ### Style Handling ###

  #http://www.w3.org/wiki/Dynamic_style_-_manipulating_CSS_with_JavaScript

  findStyleSheet: ()->
    _.find document.styleSheets, (n)->
      n.ownerNode.id == "custom_style"

  findRule: (name, sheet=@defaultStyleSheet())->
    _.find sheet.cssRules, (n)->
      n.selectorText == name

  findRuleIndex: (sheet, name)->
    indexes = _.map sheet.cssRules, (n, i)->
      i if n.selectorText == name
    indexes[0]

  defaultStyleSheet: ->
    @findStyleSheet()

  style: ->
    @defaultStyleSheet()

  modifyRule: (selector, property, value)->

    rule = @findRule(selector)
    s = @style()

    if _.isUndefined(rule)
      s.insertRule("#{selector} { property: #{value};}", s.cssRules.length);
    else
      @findRule(selector).style[property] = value
