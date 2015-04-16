Chaskiq.Helpers.showModal = (body, header, opts={}) ->
  window.Chaskiq.Helpers.cleanModal()
  body   ?= ""
  header ?= ""
  @myModal     = $("#myModal")
  @modalHeader = $("#myModal .modal-header")
  @modalBody   = $("#myModal .modal-body")
  @modalFooter = $("#myModal .modal-footer")
  @myModal.attr("data-modal-name",opts.modal_name) if opts.modal_name
  @myModal.find('.modal-dialog').addClass(opts.dialog_class) if opts.dialog_class

  if opts['noheader'] then @modalHeader.addClass('hidden') else @modalHeader.removeClass('hidden')
  if opts['nofooter'] then @modalFooter.addClass('hidden') else @modalFooter.removeClass('hidden')

  @modalBody.html body
  @myModal.modal("show")

  $("#myModal .modal-footer .btn-primary").on "click", ()->
    $("#myModal form").submit()

  this.myModal[0].className = "modal fade in"
  @modalHeader.find('h4').html header unless header.length == 0
  return @myModal

Chaskiq.Helpers.cleanModal = () ->
  self = $("#modal")
  haveModalName = self.attr("data-modal-name")
  self.attr("data-modal-name","")  if typeof haveModalName isnt "undefined" and haveModalName isnt false # 1
  self.find(".modal-dialog").removeClass().addClass("modal-dialog")
  self.find(".modal-container, .modal-title").html('')

Chaskiq.Helpers.hideModal = ()->
  $('#myModal').modal('hide');
