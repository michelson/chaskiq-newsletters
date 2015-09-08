
#http://www.kryogenix.org/code/browser/custom-drag-image.html
#http://www.html5rocks.com/en/tutorials/dnd/basics/#toc-examples
class window.Editor extends Backbone.View
  el: '#chaskiq-mail-editor'

  events: ->
    'keyup .note-editable': 'copyToFocusedElement'
    'drag .blocks li a' : 'drag'
    "click #editor-controls #save" : "saveAndClose"

    #propery changer
    "changeColor.colorpicker .colorpicker": "changeColor"
    "change .text-size-picker": "changeProperty"
    "change .font-picker": "changeProperty"
    "change .font-weight": "changeProperty"
    "change .font-spacing": "changeProperty"
    "change .font-align": "changeProperty"

    #"submit form" : "submitEditor" #get recursion!
    "click input.submit": "submitEditor"

  initialize: ->
    @textarea = $(@el).find('#campaign_html_content')
    @css = $(@el).find('#campaign_css')

  setIframe: (iframe)->
    @iframe = iframe

  copyToEditor: (ev)->
    $this = $(ev.currentTarget);
    window.setTimeout ()=>
      $(@iframe.el).find('#mail-editor').html($this.val());
    , 0

  buildOptionsFromStyles: ()->
    @renderBlockDesignSettings()

  copyToTextArea: ()->
    $this = $(@iframe.el).find("#mail-editor")
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
    @removeTplBlockControls()
    @copyToTextArea()
    @copyCssRulesToTextArea()

    setTimeout ->
      $(ev.currentTarget).submit()
    , 600

  template: ->
    '<p>dsfsd</p>'

  render: ->

    document.getElementById("editor-frame").onload = ()=>
      #iframe loaded
      @iframe = $("#editor-frame")[0].contentWindow.iframe

      #@buildOptionsFromStyles()
      $("#tab-2").html(@baseStylesTemplate("accordeon", @definitionsForEditor()))
      $('.colorpicker').colorpicker();

      if _.isEmpty(@textarea.val())
        $(@iframe.el).find('#mail-editor').html(@baseTemplate())
      else
        $(@iframe.el).find('#mail-editor').html(@textarea.val()); #init from saved content
    #$(@el).find('#mail-editor').html(@baseTemplate()) #init from base js tamplarte
    #$("#tab-2").html(@baseStylesTemplate("accordeon", @definitionsForEditor()))

    #@removeTplBlockControls() #for legacy already embeded tmp controls
    #@addTplBlockControls()

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
    $(@.iframe.el).find(".tpl-block.focus")

  initWysiwyg: ->
    $('.summernote').destroy()
    InitSummernote()
    $('.summernote').code(@currentFocused().find('.mcnTextContent').html());

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
                          <td valign='top' mccontainer='preheader_container' mc:container='preheader_container' style='padding-top:9px;' class='preheaderContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer'>
                            #{@emptyContainerMessage()}
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
                          <td valign='top' mccontainer='header_container' mc:container='header_container' class='headerContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer'>
                            #{@emptyContainerMessage()}
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
                          <td valign='top' mccontainer='body_container' mc:container='body_container' class='bodyContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer'>
                            #{@emptyContainerMessage()}
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
                          <td valign='top' mccontainer='footer_container' style='padding-bottom:9px;' mc:container='footer_container' class='footerContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer'>
                            #{@emptyContainerMessage()}
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
                    <table width='100%' cellspacing='0' cellpadding='18' border='0' class='mcnTextContentContainer' style='border: 1px solid rgb(153, 153, 153);'>
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
                      <tr class='chaskiqImageUploader blockDropTarget' id='dijit__Templated_8' widgetid='dijit__Templated_8'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='chaskiqImageItemIcon' data-chaskiq-attach-point='emptyImage'>
                            <div data-chaskiq-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-chaskiq-attach-point='browseBtn'></div>
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
                    <table data-chaskiq-id='0' class='mcpreview-image-uploader' style='width:264px;'>
                      <tr class='chaskiqImageUploader blockDropTarget' id='dijit__Templated_12' widgetid='dijit__Templated_12'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='chaskiqImageItemIcon' data-chaskiq-attach-point='emptyImage'>
                            <div data-chaskiq-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-chaskiq-attach-point='browseBtn'></div>
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
                    <table data-chaskiq-id='1' class='mcpreview-image-uploader' style='width:264px;'>
                      <tr class='chaskiqImageUploader blockDropTarget' id='dijit__Templated_13' widgetid='dijit__Templated_13'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='chaskiqImageItemIcon' data-chaskiq-attach-point='emptyImage'>
                            <div data-chaskiq-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-chaskiq-attach-point='browseBtn'></div>
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
                    <table data-chaskiq-id='' class='mcpreview-image-uploader' style='width: 528px;'>
                      <tr class='chaskiqImageUploader blockDropTarget' id='dijit__Templated_19' widgetid='dijit__Templated_19'>
                        <td>
                          <div class='imagePlaceholder'>
                            <img src='/images/blocks/empty-image-144.png' class='chaskiqImageItemIcon' data-chaskiq-attach-point='emptyImage'>
                            <div data-chaskiq-attach-point='uploadText'><span>Drop an image here</span><br>or</div>
                            <div><input type='button' value='browse' class='button-small p3' data-chaskiq-attach-point='browseBtn'></div>
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
    html = "<ul class='attachments-modal-list'>"
    _.each data, (num)->
      html += "<li>"
      html += "<a href='#' class='image-selector btn btn-success pull-right' data-image-url='#{num.image.url}' >Select</a>"
      html += "<img src='#{num.image.url}' width=150>"
      html += "</li>"

    html += "</ul>"


  defaultStyleSheet: ->
    @iframe.findStyleSheet()

  style: ->
    @defaultStyleSheet()

  definitionsForEditor: ->
    [
      {name: "Page", targets:
        [ {name: "Background", selector: "#bodyTable", template: "background", namespace: "Content"},
          {name: "Text", selector: "#bodyTable", template: "typography", namespace: "Content"} 
        ]
      }

      {name: "Preheader", targets:
        [{name: "background", selector: "#templatePreheader", template: "background", namespace: "Content"},
         {name: "Text", selector: "#templatePreHeader", template: "typography", namespace: "Content"},
        {name: "h1", selector: "#templatePreHeader h1", template: "typography", namespace: "Content"},
        {name: "h2", selector: "#templatePreHeader h2", template: "typography", namespace: "Content"}]}

      {name: "Header", targets:
        [{name: "Header background", selector: "#templateHeader", template: "background"} ]}

      {name: "Body", targets:
        [{name: "body background", selector: "#templateBody", template: "background", namespace: "Content"} ,
        {name: "font", selector: ".bodyContainer .mcnTextContent", template: "typography", namespace: "Content"} 
        {name: "links", selector: ".bodyContainer .mcnTextContent a", template: "typography", namespace: "Content"} 

        ]}

      {name: "Footer", targets:
        [{name: "background",selector: "#templateFooter", template: "background", namespace: "Content"},
        {name: "font", selector: ".footerContainer .mcnTextContent, .footerContainer .mcnTextContent p", template: "typography", namespace: "Content"} ]}

      {name: "Columns", targets: []}
    ]

  definitionsForBlocks: ->
    [
      {name: "mcnBaseTemplate", targets: []}
      {name: "mcnBoxedText", targets: [
        {name: "background", selector: ".mcnTextContentContainer", template: "background", namespace: "Content"},
        {name: "font", selector: ".mcnTextContentContainer", template: "typography", namespace: "Content"}
      ]}
      {name: "mcnText", targets: [
        {name: "background", selector: "", template: "background", namespace: "Content"},
        {name: "font", selector: "", template: "typography", namespace: "Content"},
        {name: "heading 1", selector: "h1", template: "typography", namespace: "Content"} ,
        {name: "heading 2", selector: "h2", template: "typography", namespace: "Content"} ,
        {name: "page links", selector: "a", template: "typography", namespace: "Content"} ]}

      {name: "mcnDivider", targets: []}
      {name: "mcnImage", targets: []}
      {name: "mcnImageGroup", targets: [
        {name: "background", selector: "", template: "background", namespace: "BlockInner"},
      ]}
      {name: "mcnImageCard", targets: [
        {name: "background", selector: "", template: "background" , namespace: "BottomContent"},
        {name: "font", selector: "", template: "typography", namespace: "BottomContent"}
      ]}
      {name: "mcnSubscription", targets: []}
    ]

  renderBlockDesignSettings: ->
    
    try
      $('.colorpicker').colorpicker('destroy') 
    catch e
      console.log(e)

    focused = @currentFocused().find("table:first").attr("class")
    section = _.find editor.definitionsForBlocks(), (n)=>
      "#{n.name}Block" == focused

    console.log("section #{focused}" )
    if section
      console.log("display for #{focused}")
      @current_section = section
      html = @buildDesignToolForTarget(section)
      $("#tab-4").html(html)

      $('.colorpicker').colorpicker();

    #$('.colorpicker').colorpicker('destroy') 

  #size, align, fonttype, color, weight, line heigh, letter spacing
  baseStylesTemplate: (id, definitions)->
    "<div class='panel-group' id='#{id}'>
      <div class='panel panel-default'>
        #{@colapsiblePanelsFor( id, definitions )}
      </div>
    </div>"

  colapsiblePanelsFor: (id, style_types)->
    tpl = _.map style_types, (n)=>
      "<div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='##{id}' href='#collapse#{n.name}'>
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
      @templateToolsFor(n , section.name)

    "<fieldset>#{tpl.join(" ")}</fieldset>"

  templateToolsFor: (n, parent_name)->
    title = "<h3>#{n.name}</h3>"
    tools = ""
    switch n.template
      when "background"
        tools = @backgroundFieldsFor(n, parent_name)
      when "typography"
        tools = @typoFieldsFor(n, parent_name)

    [title, tools].join(" ")

  rgb2hex: (rgb)->
    return if _.isUndefined(rgb)
    rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
    return if (rgb && rgb.length is 4)  
      "#" +
      ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
      ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
      ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) 
    else
      ''
  
  #dry this
  changeColor: (ev)->
    target = $(ev.currentTarget)
    css = target.data('css')
    property = target.data('css-property')
    value = @rgb2hex(ev.color.toString())
    console.log "changing from #{css}, #{property} #{value}"

    if css.length > 0
      @iframe.modifyRule(css, property, value)
    else
      @currentFocused()
      .find("table:first")
      .find(".#{@current_section.name}#{target.data('namespace')}")
      .css(property, value)

  changeProperty: (ev)->
    target = $(ev.currentTarget)
    css = target.data('css')
    property = target.data('css-property')
    value = target.val()
    console.log "changing from #{css}, #{property} #{value}"

    if css.length > 0
      @iframe.modifyRule(css, property, value)
    else
      editor.currentFocused()
      .find("table:first")
      .find(".#{@current_section.name}#{target.data('namespace')}")
      .css(property, value)

  arrayGen: (n)->
    Array.apply(null, length: n).map Number.call, Number

  styleforSelector: (target, style_selector, parent_name)->
    val = if !target.selector then @currentFocused().find(".#{parent_name}#{target.namespace}") else @.iframe.$el.find(target.selector)
    o = val.css(style_selector)
    console.log o
    o

  backgroundFieldsFor: (target, parent_name)->
    style_selector = "background-color"
    val = @styleforSelector(target, style_selector, parent_name)
    val = @rgb2hex(val)
    ["<input class='colorpicker' data-css='#{target.selector}' data-css-property='#{style_selector}' type='text' autocomplete='off' tabindex='0' value='#{val}' data-namespace='#{target.namespace}'>"].join(" ")

  #border style, width, color
  typoFieldsFor: (target, parent_name)->
    c = @styleforSelector(target, 'color', parent_name)
    color = "<div class='input-field'><label>Font color</label><input class='colorpicker' data-css='#{target.selector}' data-css-property='color' data-namespace='#{target.namespace}' type='text' autocomplete='off' tabindex='0' value='#{@rgb2hex(c)}'></div>"

    sizeFont = "<div class='input-field'><label>font Size</label><select class='text-size-picker' id='' data-css='#{target.selector}' data-css-property='font-size' data-namespace='#{target.namespace}'>"
    sf = @styleforSelector(target, 'font-size', parent_name)
    _.each @arrayGen(30), (n)->
      sizeFont += "<option value='#{n}px'>#{n}px</option>"

    sizeFont += "<option value='#{sf}' selected>#{sf}</option>"
    sizeFont += "</select></div>"

    ff = @styleforSelector(target, 'font-family', parent_name)

    familyFont = "<div class='input-field'><label>Font Family</label><select class='font-picker' data-css='#{target.selector}' data-css-property='font-family' data-namespace='#{target.namespace}'>
      <option value='Helvetica'>Helvetica</option>
      <option value='Arial'>Arial</option>
      <option value='Georgia'>Georgia</option>
      <option value='Verdana'>Verdana</option>"
    familyFont += "<option value='#{ff}' selected>#{ff}</option>"
    familyFont += "</select></div>"

    weight = "<div class='input-field'><label>Font Weight</label><select class='font-weight' data-css='#{target.selector}' data-css-property='font-weight' data-namespace='#{target.namespace}'>
      <option value='normal'>normal</option>
      <option value='bold'>bold</option>
      </select></div>"

    #styleFont
    #weightline
    #heightletter
    spacingtext = "<div class='input-field'><label>Spacing text</label><select class='font-spacing' data-css='#{target.selector}' data-css-property='letter-spacing' data-namespace='#{target.namespace}'>
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
          </select></div>"

    align = "<div class='input-field'><label>Text Align</label><select class='font-align' data-css='#{target.selector}' data-css-property='text-align' data-namespace='#{target.namespace}'>
          <option value='center'>center</option>
          <option value='left'>left</option>
          <option value='right'>right</option>
          <option value='justify'>justify</option>
          </select></div>"

    [color, sizeFont, familyFont, weight, spacingtext, align].join(" ")
