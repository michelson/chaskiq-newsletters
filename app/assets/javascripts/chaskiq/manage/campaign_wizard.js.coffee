###
window.SetContentTo =  function(id, content){
  $(id).val(content);
}

window.GetContent =  function(id){
  $(id).val(content);
}
###


class window.Editor extends Backbone.View
  el: '#editor-container'

  events: ->
    'keypress .note-editable': 'copyToFocusedElement'
    #'keypress #mail-editor': 'copyToTextArea'
    'drag .blocks li a' : 'drag'

    "dragover #bodyTable" : "displaySections"
    "dragleave #bodyTable" : "hideSections"
    "drop #bodyTable" : "hideSections"

    "dragover #templateBody" : "allowDrop"
    "dragover #templatePreheader" : "allowDrop"
    "dragover #templateHeader" : "allowDrop"
    "dragover #templateBody" : "allowDrop"
    "dragover #templateFooter" : "allowDrop"

    'drop #templateBody': "drop"
    'drop #templatePreheader': "drop"
    'drop #templateHeader': "drop"
    'drop #templateBody': "drop"
    "drop #templateFooter" : "drop"

    "click .tpl-block": "setFocus"
    "click #editor-controls #save" : "displayBlockButtons"
    "click .imagePlaceholder .button-small" : "displayUploaderList"
    "click .tpl-block-delete": "deleteBloc"

  initialize: ->
    @textarea = $(@el).find('#campaign_html_content')

  copyToEditor: (ev)->
    $this = $(ev.currentTarget);
    window.setTimeout ()=>
      $(@el).find('#mail-editor').html($this.val());
    , 0

  copyToTextArea: ()->
    $this = $("#mail-editor");
    window.setTimeout ()=>
      $(@el).find('textarea').val($this.html());
    , 0

  copyToFocusedElement: (ev)->
    console.log "soji"
    @currentFocused().find('.mcnTextContent').html($(ev.currentTarget).html())
    @copyToTextArea()

  template: ->
    '<p>dsfsd</p>'

  render: ->
    #$(@el).find('#mail-editor').html(@template())
    $(@el).find('#mail-editor').html(@textarea.val()); #init from saved content
    #$(@el).find('#mail-editor').html(@baseTemplate()) #init from base js tamplarte

  displaySections: ()->
    $('.tpl-container').addClass("over")
    _.each $('.tpl-container'), (n)->
      return if $(n).find(".legend").length > 0
      $(n).append("<div class='legend'>#{$(n).attr("mc:container")}</div>")

  hideSections: ()->
    $('.tpl-container').removeClass("over")
    _.each $('.tpl-container'), (n)->
      $(n).find(".legend").remove()

  drag: (ev)->
    #console.log(ev)
    @dragged = $(ev.currentTarget)

  allowDrop: (ev)->
    console.log("allos drop")
    ev.preventDefault()

  drop: (ev)->
    ev.preventDefault()
    #console.log($(ev.dataTransfer.getData("text")))
    console.log(@dragged.data('block'), ev.target.id)
    #data = $(ev.dataTransfer.getData("text"));
    #ev.target.appendChild(data);
    container = $(ev.currentTarget)
    tmpl = @handleBlock @dragged.data('block')
    container.find(".tpl-container").append(tmpl)
    $(container).find('.mojoMcContainerEmptyMessage').hide()
    @copyToTextArea()

  displayWysiwyg: ->
    $('.block-settings').show()
    $('.main-settings').hide()
    @initWysiwyg()
    false

  displayBlockButtons: ->
    $('.block-settings').hide()
    $('.main-settings').show()
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
      <span class='tpl-block-drag dojoDndHandle freddicon vellip-square' title='Drag to Reorder'></span>
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



