global.Restfull = require "../classes/restfull"
global.Auth = require "../classes/auth"

class window.PrintViewModel
    constructor: ->
        @rest = new Restfull
        @auth = new Auth @rest
        @auth.login
            ok: @loadData
            fail: @redirectToLogin

        @users = ko.observableArray()
        @exported = ko.observable false
        @exportHref = ko.observable ""

    loadData: =>
        p = @rest.get "user"
        p.done (users) =>
            sortBy = (a, b) -> a.id - b.id
            @users.push new UserViewModel user for user in users.sort sortBy

    redirectToLogin: =>
        global.location = "login.html#print.html"

    toExcel: =>
        $table = $ "#toprint"
        colcount = $table.find("th").length
        rowcount = $table.find("tr").length
        table = $table[0]
        # data = encodeURIComponent table.outerHTML
        xmldata = $ "<p>"
        xml = $ "<ss:Workbook>"
        xml.attr "xmlns:ss", "urn:schemas-microsoft-com:office:spreadsheet"
        worksheet = $ "<ss:Worksheet ss:Name=\"Sheet1\">"
        worksheet.appendTo xml
        xmltable = $ "<ss:Table>"
        xmltable.appendTo worksheet
        $table.find("tr").each ->
            $row = $ @
            row = $ "<ss:Row>"
            $row.find("th").each ->
                $th = $ @
                th = $th.text()
                data = ""
                i = 0
                for ch in th
                    ++i
                    data = data + ch
                    if i % 10 is 0
                        data = data + "\n"
                cell = $ '<ss:Cell>'
                data = $ "<ss:Data ss:Type=\"String\">#{data}</ss:Data>"
                data.appendTo cell
                cell.appendTo row
            $row.find("td").each ->
                $th = $ @
                th = $th.text()
                data = ""
                i = 0
                for ch in th
                    ++i
                    data = data + ch
                    if i % 25 is 0
                        data = data + "\n"
                cell = $ '<ss:Cell>'
                data = $ "<ss:Data ss:Type=\"String\">#{data}</ss:Data>"
                data.appendTo cell
                cell.appendTo row
            row.appendTo xmltable

        xmldata.append xml
        data = xmldata.html()
        data = data.replace /ss:workbook/g, "ss:Workbook"
        data = data.replace /ss:worksheet/g, "ss:Worksheet"
        data = data.replace /ss:table/g, "ss:Table"
        data = data.replace /ss:row/g, "ss:Row"
        data = data.replace /ss:cell/g, "ss:Cell"
        data = data.replace /ss:data/g, "ss:Data"
        data = data.replace /ss:name/g, "ss:Name"
        data = data.replace /ss:type/g, "ss:Type"
        data = encodeURIComponent "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n#{data}"
        @exportHref "data:application/vnd.ms-excel;charset=utf-8,#{data}"
        @exported true
        console.log @exportHref()




