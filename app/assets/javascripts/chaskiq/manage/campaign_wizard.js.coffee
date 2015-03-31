
#http://www.kryogenix.org/code/browser/custom-drag-image.html
#http://www.html5rocks.com/en/tutorials/dnd/basics/#toc-examples
class window.Editor extends Backbone.View
  el: '#chaskiq-mail-editor'

  events: ->
    'keyup .note-editable': 'copyToFocusedElement'

    'drag .blocks li a' : 'drag'
    'drag .tpl-block-controls a' : 'drag'
    'dragstart .tpl-block-controls a': 'setDraggedEl'
    "dragleave #bodyTable" : "hideSections"
    "drop #bodyTable" : "hideSections"
    "dragover .tpl-block" : "displayItemOver"
    "dragover .mojoMcContainerEmptyMessage": "displayItemOver"

    'drop #templateBody': "drop"
    'drop #templatePreheader': "drop"
    'drop #templateHeader': "drop"
    'drop #templateBody': "drop"
    "drop #templateFooter" : "drop"

    "click .tpl-block": "setFocus"
    "click #editor-controls #save" : "saveAndClose"
    "click .imagePlaceholder .button-small" : "displayUploaderList"
    "click .tpl-block-delete": "deleteBloc"

    #propery changer
    "changeColor.colorpicker .colorpicker": "changeColor"
    "change .text-size-picker": "changeProperty"
    "change .font-picker": "changeProperty"
    "change .font-weight": "changeProperty"
    "change .font-spacing": "changeProperty"
    "change .font-align": "changeProperty"

    "submit form" : "submitEditor"

  initialize: ->
    @textarea = $(@el).find('#campaign_html_content')
    @css = $(@el).find('#campaign_css')

  copyToEditor: (ev)->
    $this = $(ev.currentTarget);
    window.setTimeout ()=>
      $(@el).find('#mail-editor').html($this.val());
    , 0

  copyToTextArea: ()->
    $this = $("#mail-editor")
    window.setTimeout ()=>
      $(@el).find('#campaign_html_content').val($this.html());
    , 0

  copyToFocusedElement: (ev)->
    @currentFocused().find('.mcnTextContent').html($(ev.currentTarget).html())
    @copyToTextArea()

  copyCssRulesToTextArea: ()->
    rules = _.map @style().cssRules , (rule)->
      rule.cssText
    $("#campaign_css").val(rules.join(" "))

  submitEditor: (ev)->
    @copyToTextArea()
    @copyCssRulesToTextArea()
    $(ev.currentTarget).submit()
    false

  template: ->
    '<p>dsfsd</p>'

  render: ->
    #$(@el).find('#mail-editor').html(@template())
    $(@el).find('#mail-editor').html(@textarea.val()); #init from saved content
    #$(@el).find('#mail-editor').html(@baseTemplate()) #init from base js tamplarte
    $("#tab-2").html(@baseStylesTemplate())

    $('.colorpicker').colorpicker();

  displaySections: (ev)->

    #console.log($(ev.currentTarget))
    #console.log($(ev.currentTarget).hasClass("tpl-container"))
    container = $(ev.currentTarget).parent(".tpl-container")

    _.each $('.tpl-container'), (n)->
      return if $(n).find(".legend").length > 0
      $(n).append("<div class='legend default'>#{$(n).attr("mc:container")}</div>")

    container.addClass("default")

    if container.hasClass("tpl-container")
      container.addClass("over").removeClass("default")
      container.find(".legend").addClass("over").removeClass("default")

    ev.preventDefault()

  setDraggedEl: (e)->
    crt = $(e.currentTarget).parents(".tpl-block")[0].cloneNode(true) #.clone()
    crt.style.backgroundColor = "white";
    crt.style.position = "absolute";
    crt.style.border = "1px solid #666";
    crt.style.boxShadow = "1px 2px 2px #adadad"
    crt.style.top = "0px";
    crt.style.right = "0px";
    crt.style.opacity = 0.9;
    document.body.appendChild(crt);
    e.dataTransfer = e.originalEvent.dataTransfer;
    e.dataTransfer.setDragImage(crt, 0, 0);

  displayItemOver: (ev)->
    @displaySections(ev)

    $('.tpl-block').removeClass("dojoDndItemBefore")
    if $(ev.currentTarget).hasClass("tpl-block")
      $(ev.currentTarget).addClass("dojoDndItemBefore")

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
      empty_message = $(container).find('.mojoMcContainerEmptyMessage')
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

    if @dragged.attr('data-block')
      tmpl = @handleBlock @dragged.data('block')
      @dropBlock(container, tmpl)
    else
      to_drop = this.dragged.parents(".tpl-block")
      @dropBlock(container, to_drop)

    @copyToTextArea()

    @releaseBeforeItem()

    @displayEmptyBlocks()

  dropBlock: (container, tmpl)->
    #drop on before item or in tpl-container
    if $(".tpl-block.dojoDndItemBefore").length > 0
      container.find(".tpl-block.dojoDndItemBefore").before(tmpl)
      container.find('.mojoMcContainerEmptyMessage').hide()
    else
      container.find(".tpl-container").append(tmpl)
      #container.find('.mojoMcContainerEmptyMessage').hide()

  releaseBeforeItem: ()->
    $(".tpl-block").removeClass("dojoDndItemBefore")

  displayWysiwyg: ->
    $('.block-settings').show()
    $('.main-settings').hide()
    @initWysiwyg()
    false

  displayBlockButtons: ->
    $('.block-settings').hide()
    $('.main-settings').show()
    false

  saveAndClose: ->
    @copyToTextArea()
    @displayBlockButtons()
    false

  currentFocused: ()->
    $(".tpl-block.focus")

  setFocus: (ev)->
    $(".tpl-block").removeClass("focus")
    $(ev.currentTarget).addClass("focus")
    @displayWysiwyg()
    false

  initWysiwyg: ->
    $('.summernote').destroy()
    InitSummernote()
    $('.summernote').code(@currentFocused().find('.mcnTextContent').html());

    #edit = ()->
    #  $('.click2edit').summernote({ focus: true });

  handleBlock: (block_type)->
    html = ""
    switch block_type
      when "boxed"
        html = @boxedBlock()
      when "text"
        html = @textBlock()
      when "separator"
        html = @separatorBlock()
      when "image"
        html = @imageBlock()
      when "image_group"
        html = @imageGroupBlock()
      when "image_card"
        html = @imageCardBlock()
      else
        console.log "Nada"

    @wrapBlock(html)

  deleteBloc: (ev)->
    target = $(ev.currentTarget)
    container = target.parents(".tpl-container")
    target.parents(".tpl-block").remove()

    if container.find(".tpl-block").length is 0
      container.find(".mojoMcContainerEmptyMessage").show()
    false

  wrapBlock: (content)->
    "<div class='mojoMcBlock tpl-block dojoDndItem'>
      <div data-dojo-attach-point='containerNode'>
        #{content}
      </div>
      #{@templateBlockControls()}
    </div>"

  templateBlockControls: ->
    "<div class='tpl-block-controls'>
      <a data-dojo-attach-point='editBtn' class='tpl-block-edit' href='#' title='Edit Block'><i class='fa fa-edit'></i></a>
      <a data-dojo-attach-point='cloneBtn' class='tpl-block-clone' href='#' title='Duplicate Block'><i class='fa fa-files-o'></i></a>
      <a data-dojo-attach-point='deleteBtn' class='tpl-block-delete' href='#' title='Delete Block'><i class='fa fa-trash'></i></a>
    </div>"

  baseTemplate: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' align='center' height='100%' id='bodyTable'>
      <tbody>
        <tr>
          <td valign='top' align='center' id='bodyCell'>
            <!-- BEGIN TEMPLATE // -->
            <table width='600' cellspacing='0' cellpadding='0' border='0' id='templateContainer'>
              <tbody>
                <tr>
                  <td valign='top' align='center'>
                    <!-- BEGIN PREHEADER // -->
                    <table width='600' cellspacing='0' cellpadding='0' border='0' id='templatePreheader'>
                      <tbody>
                        <tr>
                          <td valign='top' mccontainer='preheader_container' mc:container='preheader_container' style='padding-top:9px;' class='preheaderContainer tpl-container dojoDndSource dojoDndTarget dojoDndContainer'>
                            <div class='mojoMcContainerEmptyMessage' style='display: block;'>Drop Content Blocks Here</div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- // END PREHEADER -->
                  </td>
                </tr>
                <tr>
                  <td valign='top' align='center'>
                    <!-- BEGIN HEADER // -->
                    <table width='600' cellspacing='0' cellpadding='0' border='0' id='templateHeader'>
                      <tbody>
                        <tr>
                          <td valign='top' mccontainer='header_container' mc:container='header_container' class='headerContainer tpl-container dojoDndSource dojoDndTarget dojoDndContainer'>
                            <div class='mojoMcContainerEmptyMessage' style='display: block;'>Drop Content Blocks Here</div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- // END HEADER -->
                  </td>
                </tr>
                <tr>
                  <td valign='top' align='center'>
                    <!-- BEGIN BODY // -->
                    <table width='600' cellspacing='0' cellpadding='0' border='0' id='templateBody'>
                      <tbody>
                        <tr>
                          <td valign='top' mccontainer='body_container' mc:container='body_container' class='bodyContainer tpl-container dojoDndSource dojoDndTarget dojoDndContainer'>
                            <div class='mojoMcContainerEmptyMessage' style='display: block;'>Drop Content Blocks Here</div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- // END BODY -->
                  </td>
                </tr>
                <tr>
                  <td valign='top' align='center'>
                    <!-- BEGIN FOOTER // -->
                    <table width='600' cellspacing='0' cellpadding='0' border='0' id='templateFooter'>
                      <tbody>
                        <tr>
                          <td valign='top' mccontainer='footer_container' style='padding-bottom:9px;' mc:container='footer_container' class='footerContainer tpl-container dojoDndSource dojoDndTarget dojoDndContainer'>
                            <div class='mojoMcContainerEmptyMessage' style='display: block;'>Drop Content Blocks Here</div>
                              #{@wrapBlock(@subscriptionBlock())}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- // END FOOTER -->
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- // END TEMPLATE -->
          </td>
        </tr>
      </tbody>
    </table>"

  boxedBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnBoxedTextBlock'>
      <tbody class='mcnBoxedTextBlockOuter'>
        <tr>
          <td valign='top' class='mcnBoxedTextBlockInner'>
            <table width='600' cellspacing='0' cellpadding='0' border='0' align='left' class='mcnBoxedTextContentContainer'>
              <tbody>
                <tr>
                  <td style='padding-top:9px; padding-left:18px; padding-bottom:9px; padding-right:18px;'>
                    <table width='100%' cellspacing='0' cellpadding='18' border='0' class='mcnTextContentContainer' style='border: 1px solid rgb(153, 153, 153); background-color: rgb(235, 235, 235);'>
                      <tbody>
                        <tr>
                          <td valign='top' class='mcnTextContent'>
                            This is a Text Block. Use this to provide text...
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  textBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnTextBlock'>
      <tbody class='mcnTextBlockOuter'>
        <tr>
          <td valign='top' class='mcnTextBlockInner'>
            <table width='600' cellspacing='0' cellpadding='0' border='0' align='left' class='mcnTextContentContainer'>
              <tbody>
                <tr>
                  <td valign='top' style='padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;' class='mcnTextContent'>
                    This is a Text Block. Use this to provide text...
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  separatorBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnDividerBlock'>
      <tbody class='mcnDividerBlockOuter'>
        <tr>
          <td style='padding: 18px;' class='mcnDividerBlockInner'>
            <table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnDividerContent' style='border-top: 1px solid rgb(153, 153, 153);'>
              <tbody>
                <tr>
                  <td>
                    <span></span>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  imageBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnImageBlock'>
      <tbody class='mcnImageBlockOuter'>
        <tr>
          <td valign='top' class='mcnImageBlockInner' style='padding:9px'>
            <table width='100%' cellspacing='0' cellpadding='0' border='0' align='left' class='mcnImageContentContainer'>
              <tbody>
                <tr>
                  <td valign='top' style='padding-right: 9px; padding-left: 9px; padding-top: 0; padding-bottom: 0;' class='mcnImageContent'>
                    <table class='mcpreview-image-uploader' style='width:564px;'>
                      <tr class='mojoImageUploader blockDropTarget' id='dijit__Templated_8' widgetid='dijit__Templated_8'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='mojoImageItemIcon' data-dojo-attach-point='emptyImage'>
                            <div data-dojo-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-dojo-attach-point='browseBtn'></div>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  imageGroupBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnImageGroupBlock'>
      <tbody class='mcnImageGroupBlockOuter'>
        <tr>
          <td valign='top' class='mcnImageGroupBlockInner' style='padding:9px'>
            <table width='273' cellspacing='0' cellpadding='0' border='0' align='left' class='mcnImageGroupContentContainer'>
              <tbody>
                <tr>
                  <td valign='top' style='padding-left: 9px; padding-top: 0; padding-bottom: 0;' class='mcnImageGroupContent'>
                    <table data-mc-id='0' class='mcpreview-image-uploader' style='width:264px;'>
                      <tr class='mojoImageUploader blockDropTarget' id='dijit__Templated_12' widgetid='dijit__Templated_12'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='mojoImageItemIcon' data-dojo-attach-point='emptyImage'>
                            <div data-dojo-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-dojo-attach-point='browseBtn'></div>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            <table width='273' cellspacing='0' cellpadding='0' border='0' align='right' class='mcnImageGroupContentContainer'>
              <tbody>
                <tr>
                  <td valign='top' style='padding-right: 9px; padding-top: 0; padding-bottom: 0;' class='mcnImageGroupContent'>
                    <table data-mc-id='1' class='mcpreview-image-uploader' style='width:264px;'>
                      <tr class='mojoImageUploader blockDropTarget' id='dijit__Templated_13' widgetid='dijit__Templated_13'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='mojoImageItemIcon' data-dojo-attach-point='emptyImage'>
                            <div data-dojo-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-dojo-attach-point='browseBtn'></div>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  imageCardBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnImageCardBlock'>
      <tbody class='mcnImageCardBlockOuter'>
        <tr>
          <td valign='top' style='padding-top:9px; padding-right:18px; padding-bottom:9px; padding-left:18px;' class='mcnImageCardBlockInner'>
            <table width='100%' cellspacing='0' cellpadding='0' border='0' align='right' class='mcnImageCardBottomContent' style='border: 1px solid rgb(153, 153, 153); background-color: rgb(235, 235, 235);'>
              <tbody>
                <tr>
                  <td valign='top' align='left' style='padding-top:18px; padding-right:18px; padding-bottom:0; padding-left:18px;' class='mcnImageCardBottomImageContent'>
                    <table data-mc-id='' class='mcpreview-image-uploader' style='width: 528px;'>
                      <tr class='mojoImageUploader blockDropTarget' id='dijit__Templated_19' widgetid='dijit__Templated_19'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='mojoImageItemIcon' data-dojo-attach-point='emptyImage'>
                            <div data-dojo-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-dojo-attach-point='browseBtn'></div>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td width='528' valign='top' style='padding-top:9px; padding-right:18px; padding-bottom:9px; padding-left:18px;' class='mcnTextContent'>
                    Your text caption goes here
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>"

  subscriptionBlock: ()->
    "<table width='100%' cellspacing='0' cellpadding='0' border='0' class='mcnTextBlock'>
      <tbody class='mcnTextBlockOuter'>
        <tr>
          <td valign='top' class='mcnTextBlockInner'>
              <table width='600' cellspacing='0' cellpadding='0' border='0' align='left' class='mcnTextContentContainer'>
                <tbody><tr>

                  <td valign='top' style='padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;' class='mcnTextContent'>
                      <em>&copy;</em>
                      {{campaign_description}}
                      <br>
                      <br>
                      <strong>Our mailing address is:</strong><br>
                      {{campaign_url}}
                      <br>
                      <br>
                      <a href='{{campaign_unsubscribe}}' class='utilityLink'>unsubscribe from this list</a>&nbsp;&nbsp;&nbsp;
                      <a href='{{campaign_unsubscribe}}' class='utilityLink'>update subscription preferences</a>&nbsp;<br>
                      <br>
                  </td>
                </tr>
                </tbody>
              </table>
          </td>
        </tr>
      </tbody>
    </table>"

  displayUploaderList: (ev)->
    placeholder = $(ev.currentTarget).parents('.imagePlaceholder')
    @checkExistentImages(placeholder)
    false

  checkExistentImages: (placeholder)->
    #@targetForUpload = $(ev.currentTarget)

    $.ajax
      url: $("#editor-container").data("attachments-path")
      dataType: "json"
      success: (data)=>
        Chaskiq.Helpers.showModal(@templateForAttachments(data), "dsdsda")
        _this = this
        $('.image-selector').on "click", ()->
          html = placeholder.parents(".mcpreview-image-uploader")
          url = $(this).data('image-url')
          _this.replaceImagePreview(html, url )
          false

      error: (err)->
        alert("error retrieving files")

  replaceImagePreview: (html_to_replace, url)->
    html_to_replace.replaceWith( "<img src='#{url}'/>" );
    Chaskiq.Helpers.hideModal()
    @copyToTextArea()

  templateForAttachments: (data)->
    html = "<ul>"
    _.each data, (num)->
      html += "<li>"
      html += "<img src='#{num.image.url}'>"
      html += "<a href='#' class='image-selector' data-image-url='#{num.image.url}' >Select</a>"
      html += "</li>"

    html += "</ul>"


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

  definitionsForEditor: ->
    [
      {name: "page", targets:
        [{name: "background page", selector: "#bodyTable", template: "background"},
        {name: "heading 1", selector: "#bodyTable h1", template: "typography"} ,
        {name: "heading 2", selector: "#bodyTable h2", template: "typography"} ,
        {name: "page links", selector: "#bodyTable a", template: "typography"} ]}

      {name: "preheader", targets:
        [{name: "background pre header", selector: "#templatePreheader", template: "background"},
        {name: "headings", selector: "#templatePreHeader h1", template: "typography"},
        {name: "headings", selector: "#templatePreHeader h2", template: "typography"}]}

      {name: "header", targets:
        [{name: "header background", selector: "#templateHeader", template: "background"} ]}

      {name: "body", targets:
        [{name: "body background", selector: "#templateBody", template: "background"} ,
        {name: "body content text", selector: ".bodyContainer .mcnTextContent, .bodyContainer .mcnTextContent p", template: "typography"} ]}

      {name: "footer", targets:
        [{name: "footer background",selector: "#templateFooter", template: "background"},
        {name: "footer content text", selector: ".footerContainer .mcnTextContent, .footerContainer .mcnTextContent p", template: "typography"} ]}

      {name: "columns", targets: []}
    ]

  #size, align, fonttype, color, weight, line heigh, letter spacing
  baseStylesTemplate: ->
    "<div class='panel-group' id='accordion'>
      <div class='panel panel-default'>
        #{@colapsiblePanelsFor()}
      </div>
    </div>"

  colapsiblePanelsFor: ()->
    style_types = @definitionsForEditor()

    tpl = _.map style_types, (n)=>
      "<div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse#{n.name}'>
          #{n.name}
          </a>
        </h4>
      </div>

      <div id='collapse#{n.name}' class='panel-collapse collapse'>
        <div class='panel-body'>
            <p>#{@buildDesignToolForTarget(n)}</p>
        </div>
      </div>"
    tpl.join(" ")

  buildDesignToolForTarget: (section)->
    tpl = _.map section.targets, (n)=>
      @templateToolsFor(n)

    "<fieldset>#{tpl.join(" ")}</fieldset>"

  templateToolsFor: (n)->
    title = "<h3>#{n.name}</h3><hr>"
    tools = ""
    switch n.template
      when "background"
        tools = @backgroundFieldsFor(n)
      when "typography"
        tools = @TypoFieldsFor(n)

    [title, tools].join(" ")

  changeColor: (ev)->
    css = $(ev.currentTarget).data('css')
    property = $(ev.currentTarget).data('css-property')
    value = ev.color.toString()
    console.log "changing from #{css}, #{property} #{value}"
    @modifyRule(css, property, value)

  changeProperty: (ev)->
    css = $(ev.currentTarget).data('css')
    property = $(ev.currentTarget).data('css-property')
    value = $(ev.currentTarget).val()
    console.log "changing from #{css}, #{property} #{value}"
    @modifyRule(css, property, value)

  backgroundFieldsFor: (target)->
    ["<input class='colorpicker' data-css='#{target.selector}' data-css-property='background-color' type='text' autocomplete='off' tabindex='0' value='0'>"].join(" ")

  arrayGen: (n)->
    Array.apply(null, length: n).map Number.call, Number

  #border style, width, color
  TypoFieldsFor: (target)->
    color = "<label>Font color</label><input class='colorpicker' data-css='#{target.selector}' data-css-property='color' type='text' autocomplete='off' tabindex='0' value='0'>"

    sizeFont = "<label>font Size</label><select class='text-size-picker' id='' data-css='#{target.selector}' data-css-property='font-size'>"
    _.each @arrayGen(30), (n)->
      sizeFont += "<option value='#{n}px'>#{n}px</option>"
    sizeFont += "</select>"

    familyFont = "<label>Font Family</label><select class='font-picker' data-css='#{target.selector}' data-css-property='font-family'>
      <option value='Helvetica'>Helvetica</option>
      <option value='Arial'>Arial</option>
      <option value='Georgia'>Georgia</option>
      <option value='Verdana'>Verdana</option>
      </select>"

    weight = "<label>Font Weight</label><select class='font-weight' data-css='#{target.selector}' data-css-property='font-weight'>
      <option value='normal'>normal</option>
      <option value='bold'>bold</option>
      </select>"

    #styleFont
    #weightline
    #heightletter
    spacingtext = "<label>Spacing text</label><select class='font-spacing' data-css='#{target.selector}' data-css-property='letter-spacing'>
          <option value='-5px'>-5px</option>
          <option value='-4px'>-4px</option>
          <option value='-3px'>-3px</option>
          <option value='-2px'>-2px</option>
          <option value='-1px'>-1px</option>
          <option value='normal'>-normal</option>
          <option value='-1px'>-1px</option>
          <option value='-2px'>-2px</option>
          <option value='-3px'>-3px</option>
          <option value='-4px'>-4px</option>
          <option value='-5px'>-5px</option>
          </select>"

    align = "<label>Text Align</label><select class='font-align' data-css='#{target.selector}' data-css-property='text-align'>
          <option value='center'>center</option>
          <option value='left'>left</option>
          <option value='right'>right</option>
          <option value='justify'>justify</option>
          </select>"

    [color, sizeFont, familyFont, weight, spacingtext, align].join("<hr>")
