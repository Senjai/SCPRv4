#= require scprbase

class scpr.IndexManager
    DefaultOptions:
        updatable:    "*[data-updatable='true']"
        formTemplate: JST["admin/templates/data_field"]
        
    constructor: (@baseUrl, options={}) ->
        @options = _.defaults options, @DefaultOptions
        
        $(@options.updatable).on
            click: (event) =>
                cell      = $(event.target)
                attribute = cell.attr("data-attribute")
                id        = cell.attr("data-id")
                
                $.ajax
                    url: "#{@baseUrl}/#{id}"
                    dataType: "json"
                    success: (data, status, xhr) =>
                        object = data
                        cell.html(@options.formTemplate attribute: attribute, id: id, inputValue: object[attribute])
                        cell.find("input").focus()
                        
        $(@options.updatable).on
            blur: (event) =>
                cell      = $(event.target).closest("td")
                attribute = cell.attr("data-attribute")
                id        = cell.attr("data-id")
                
                $.ajax
                    type: "put"
                    url: "#{@baseUrl}/#{id}"
                    dataType: "json"
                    data: 
                        data_point:
                            data_value: $(event.target).val()
                    success: (data, status, xhr) ->
                        value = cell.find("input").val()
                        cell.html(value)
        , 'input'