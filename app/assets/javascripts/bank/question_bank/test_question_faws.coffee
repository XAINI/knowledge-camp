class QuestionFlawList
  constructor: (@$ele)->
    @bind_event()

  bind_event: ->
    @bind_check_all_event()

    @bind_delete_event()
    @bind_batch_delete_event()

  bind_check_all_event: ->
    @$ele.on "click", ".flaw-batch input[type='checkbox'][name='check-all']", (evt)=>
      target = jQuery evt.target
      @$ele.find("table tbody input[type='checkbox'][name='flaw']").prop("checked", target.is(':checked'))

  bind_delete_event: ->
    @$ele.on "click", "table tbody td .delete-flaw", (evt)=>
      return if !confirm("确定删除么？")

      target = jQuery evt.target
      tr = target.closest "tr"
      question_flaw_url = target.data "questionFlawUrl"
      jQuery.ajax
        url: questionFlawUrl
        method: "DELETE"
        success: (msg)=>
          tr.remove()

  bind_batch_delete_event: ->
    @$ele.on "click", ".flaw-batch .batch-delete-flaw", (evt)=>
      eles = @$ele.find("table tbody input:checked[type='checkbox'][name='flaw']").get()

      $tr_arr = jQuery.map eles, (ele)->
        jQuery(ele).closest("tr")

      ids = jQuery.map eles, (ele)->
        return jQuery(ele).closest("tr").find(".delete-flaw").data("questionFlawId")

      return if ids.length == 0
      return if !confirm("确定删除么？")

      $target = jQuery(evt.target).closest('.batch-delete-flaw')
      if $target.data('batchDestroyQuestionFlawsUrl')
        jQuery.ajax
          url: $target.data('batchDestroyQuestionFlawsUrl')
          method: "delete"
          data:
            question_flaw_ids: ids
          dataType: "json"
          success: (msg)=>
            console.log msg
            jQuery.each $tr_arr, (index, $tr)=>
              $tr.remove()


jQuery(document).on "ready page:load", ->
  if jQuery(".page-question-flaws").length > 0
    new QuestionFlawList(jQuery(".page-question-flaws"))
